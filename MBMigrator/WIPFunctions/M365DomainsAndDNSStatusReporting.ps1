function Get-M365DomainStatusReport
{
    [CmdletBinding()]
    param(
        [string[]]$Domain
        ,
        [psobject[]]$ExchangeConfiguration
        ,
        [hashtable]$ShortOrgNames
        ,
        [string[]]$IgnoreDomain
    )
    $domainTenantStatus = @(
        foreach ($d in $Domain)
        {
            try
            {
                Get-AzureADDomain -name $d -ErrorAction Stop | Select-Object -Property *,
                @{n = 'IsPresent'; e = { $true } },
                @{n = 'Ignore'; e = { $IgnoreDomain -contains $d } }
            }
            catch
            {
                $MyError = $_
                if ($MyError.Exception.ErrorContent.Code -eq 'Request_ResourceNotFound')
                {
                    [PSCustomObject]@{
                        AuthenticationType = $null
                        AvailabilityStatus = $null
                        ForceDeleteState   = $null
                        IsAdminManaged     = $null
                        IsDefault          = $null
                        IsInitial          = $null
                        IsRoot             = $null
                        IsVerified         = $null
                        Name               = $d
                        State              = $null
                        SupportedServices  = ""
                        IsPresent          = $false
                        Ignore             = $IgnoreDomain -contains $d
                    }
                }
            }
        }
    )
    if ($PSBoundParameters.ContainsKey('ExchangeConfiguration'))
    {
        foreach ($ec in $ExchangeConfiguration)
        {
            if ($PSBoundParameters.ContainsKey('ShortOrgNames'))
            {
                if ($ShortOrgNames.ContainsKey($ec.OrganizationConfig.Name))
                {
                    $OrgName = $ShortOrgNames.$($ec.OrganizationConfig.Name)
                }
                else
                {
                    $OrgName = $ec.OrganizationConfig.Name
                }
            }
            else
            {
                $OrgName = $ec.OrganizationConfig.Name
            }
            foreach ($d in $domainTenantStatus)
            {
                $statusProperty = $OrgName + '_Status'
                Add-Member -InputObject $d -MemberType NoteProperty -Name $statusProperty -Value $null
                switch ($d.Name -in $ec.AcceptedDomain.DomainName)
                {
                    $true
                    {
                        $d.$statusProperty = $ec.AcceptedDomain |
                        Where-Object -FilterScript {
                            $_.DomainName -eq $d.Name
                        } | Select-Object -ExpandProperty DomainType
                    }
                    $false
                    { $d.$statusProperty = 'NotPresent' }
                }
            }
        }
    }

    $domainTenantStatus.ForEach( {
            $reportObject = [PSCustomObject]@{
                Name               = $_.Name
                Ignore             = $_.Ignore
                IsPresent          = $_.IsPresent
                IsVerified         = $_.IsVerified
                IsDefault          = $_.IsDefault
                IsInitial          = $_.IsInitial
                AuthenticationType = $_.AuthenticationType
                SupportedServices  = $_.SupportedServices -join ';'
            }
            foreach ($p in $($_.psobject.properties.where( { $_.name -like '*_Status' })))
            {
                Add-Member -InputObject $reportObject -MemberType NoteProperty -Name $p.Name -Value $p.Value
            }
            $reportObject
        })
}

function Get-M365DomainDNSRecordReport
{
    [CmdletBinding(DefaultParameterSetName = 'NoVerify')]
    param(
        [psobject[]]$DomainStatus
        ,
        [Parameter(ParameterSetName = 'Verify')]
        [switch]$VerifyDNSRecords
        ,
        $DNSServer = '1.1.1.1'
    )
    $DNSRecords = @(
        foreach ($d in $DomainStatus)
        {
            switch ($d)
            {
                { $d.Ignore }
                {
                    $Message = "{0} is set to Ignore." -f $d.name
                    Write-Information -InformationAction Continue -MessageData $Message
                    break
                }
                { $false -eq $d.IsPresent }
                {
                    $Message = "{0} is not present in the tenant." -f $d.name
                    Write-Information -InformationAction Continue -MessageData $Message
                    break
                }
                { $false -eq $d.IsVerified }
                {
                    Get-AzureADDomainVerificationDnsRecord -Name $d.Name |
                    Where-Object -FilterScript {
                        $_.RecordType -eq 'Txt'
                    } |
                    Select-Object -Property @{
                        n = 'Zone'; e = { $d.Name }
                    }, *
                    break
                }
                { [string]::IsNullOrWhiteSpace($d.SupportedServices) }
                {
                    $Message = "{0} is not configured for Services." -f $d.name
                    Write-Information -InformationAction Continue -MessageData $Message
                }
                { -not [string]::IsNullOrWhiteSpace($d.SupportedServices) }
                {
                    Get-AzureADDomainServiceConfigurationRecord -Name $d.Name |
                    Select-Object -Property @{n = 'Zone'; e = { $d.Name } }, *
                }
            }
        }
    )
    switch ($pscmdlet.ParameterSetName)
    {
        'NoVerify'
        {
            $DNSRecords
        }
        'Verify'
        {
            $SplatParams = @{
                Server      = $DNSServer
                NoHostsFile = $true
                DNSOnly     = $true
                ErrorAction = 'Stop'
            }
            foreach ($r in $DNSRecords)
            {
                $PublicRecords = @(
                    try
                    {
                        switch ($r.RecordType)
                        {
                            'Txt'
                            {
                                $SplatParams.Type = 'Txt'
                                $SplatParams.Name = $r.label
                                @(Resolve-DnsName @SplatParams).where( {
                                        $_.Strings -contains $r.Text
                                    })
                            }
                            'Mx'
                            {
                                $SplatParams.Type = 'Mx'
                                $SplatParams.Name = $r.label
                                @(Resolve-DnsName @SplatParams).where( {
                                        $_.NameExchange -eq $r.MailExchange
                                    })
                            }
                            'CName'
                            {
                                $SplatParams.Type = 'CName'
                                $SplatParams.Name = $r.label
                                @(Resolve-DnsName @SplatParams).where( {
                                        $_.NameHost -eq $r.CanonicalName
                                    })
                            }
                            'Srv'
                            {
                                $SplatParams.Type = 'Srv'
                                $SplatParams.Name = $r.label
                                @(Resolve-DnsName @SplatParams).where( {
                                        $_.NameTarget -eq $r.NameTarget -and
                                        $_.Port -eq $r.Port -and
                                        $_.Priority -eq $r.Priority -and
                                        $_.Weight -eq $r.Weight
                                    })
                            }
                        }
                    }
                    catch
                    {
                        $myerror = $_
                        $Message = "The following Error Occured when Querying Record {0} of Type {1}:" -f $r.Label, $r.RecordType
                        Write-Information -MessageData $Message -InformationAction Continue
                        Write-Information -MessageData $myerror.Exception -InformationAction Continue
                    }
                )

                Add-Member -InputObject $r -MemberType NoteProperty -Name Verified -Value $($PublicRecords.count -eq 1) -PassThru

            }
        }
    }
}

function Add-M365DomainToTenant
{
    [cmdletbinding()]
    param(
        [psobject[]]$DomainStatus
    )
    foreach ($d in $DomainStatus)
    {
        switch ($d)
        {
            { $true -eq $d.Ignore }
            {
                $Message = "{0} is set to Ignore." -f $d.name
                Write-Information -InformationAction Continue -MessageData $Message
                break
            }
            { $false -eq $d.IsPresent }
            {
                if ($d.Name -match '\b(?<!\.)[^\.\s]+\.[\w\d]{2,4}\b')
                {
                    try
                    {
                        New-AzureADDomain -Name $d.Name -ErrorAction Stop
                    }
                    catch
                    {
                        $myerror = $_
                        $Message = "{0} failed to add to the Tenant due to the following error:" -f $d.Name
                        Write-Information -InformationAction Continue -MessageData $Message
                        Write-Information -InformationAction Continue -MessageData $myerror.Exception.Message
                    }
                }
                else
                {
                    $Message = "{0} appears to be a subdomain. The Add-M365DomainToTenant function does not (yet) support subdomains." -f $d.Name
                    Write-Information -InformationAction Continue -MessageData $Message
                }

            }
        }
    }
}
