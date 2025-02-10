Function Find-ADUser
{

    [cmdletbinding(DefaultParameterSetName = 'Default')]
    param(
        [parameter(Mandatory, valuefrompipeline, valuefrompipelinebypropertyname, ParameterSetName = 'Default')]
        [parameter(ParameterSetName = 'FirstLast')]
        [string]$Identity
        ,
        [parameter(Mandatory)]
        [validateset('SAMAccountName', 'UserPrincipalName', 'ProxyAddress', 'Mail', 'mailNickname', 'employeeNumber', 'employeeID', 'extensionattribute5', 'extensionattribute11', 'extensionattribute13', 'DistinguishedName', 'CanonicalName', 'ObjectGUID', 'mS-DS-ConsistencyGuid', 'SID', 'GivenNameSurname')]
        $IdentityType
        ,
        [Parameter()]
        [string[]]$Property
        ,
        [parameter(ParameterSetName = 'FirstLast', Mandatory)]
        [string]$GivenName
        ,
        [parameter(ParameterSetName = 'FirstLast', Mandatory)]
        [string]$SurName
        ,
        [switch]$AmbiguousAllowed
        ,
        [switch]$ReportExceptions
    )
    Begin
    {
        #Setup GetADUserParams
        $GetADUserParams = @{ErrorAction = 'Stop' }
        if ($Property.count -ge 1)
        {
            #Write-Log -Message "Using Property List: $($properties -join ",") with Get-ADUser"
            $GetADUserParams.Properties = $Property
        }
        #Setup exception reporting
        if ($ReportExceptions)
        {
            $Script:LookupADUserNotFound = @()
            $Script:LookupADUserAmbiguous = @()
        }
    }#Begin
    Process
    {
        switch ($IdentityType)
        {
            'mS-DS-ConsistencyGuid'
            {
                $Identity = $Identity -join ' '
            }
            'GivenNameSurname'
            {
                $SurName = $SurName.Trim()
                $GivenName = $GivenName.Trim()
                $Identity = "$SurName, $GivenName"
            }
            Default { }
        }
        foreach ($ID in $Identity)
        {
            try
            {
                Write-Log -Message "Attempting: Get-ADUser with identifier $ID for Attribute $IdentityType"
                switch ($IdentityType)
                {
                    'SAMAccountName'
                    {
                        $ADUser = @(Get-ADUser -filter { SAMAccountName -eq $ID } @GetADUserParams)
                    }
                    'UserPrincipalName'
                    {
                        $AdUser = @(Get-ADUser -filter { UserPrincipalName -eq $ID } @GetADUserParams)
                    }
                    'ProxyAddress'
                    {
                        #$wildcardID = "*$ID*"
                        $AdUser = @(Get-ADUser -filter { proxyaddresses -like $ID } @GetADUserParams)
                    }
                    'Mail'
                    {
                        $AdUser = @(Get-ADUser -filter { Mail -eq $ID }  @GetADUserParams)
                    }
                    'mailNickname'
                    {
                        $AdUser = @(Get-ADUser -filter { mailNickname -eq $ID }  @GetADUserParams)
                    }
                    'extensionattribute5'
                    {
                        $AdUser = @(Get-ADUser -filter { extensionattribute5 -eq $ID } @GetADUserParams)
                    }
                    'extensionattribute11'
                    {
                        $AdUser = @(Get-ADUser -filter { extensionattribute11 -eq $ID } @GetADUserParams)
                    }
                    'extensionattribute13'
                    {
                        $AdUser = @(Get-ADUser -filter { extensionattribute13 -eq $ID } @GetADUserParams)
                    }
                    'DistinguishedName'
                    {
                        $AdUser = @(Get-ADUser -filter { DistinguishedName -eq $ID } @GetADUserParams)
                    }
                    'CanonicalName'
                    {
                        $AdUser = @(Get-ADUser -filter { CanonicalName -eq $ID } @GetADUserParams)
                    }
                    'ObjectGUID'
                    {
                        $AdUser = @(Get-ADUser -filter { ObjectGUID -eq $ID } @GetADUserParams)
                    }
                    'SID'
                    {
                        $AdUser = @(Get-ADUser -filter { SID -eq $ID } @GetADUserParams)
                    }
                    'mS-DS-ConsistencyGuid'
                    {
                        $ID = [byte[]]$ID.split(' ')
                        $AdUser = @(Get-ADUser -filter { mS-DS-ConsistencyGuid -eq $ID } @GetADUserParams)
                    }
                    'GivenNameSurName'
                    {
                        $ADUser = @(Get-ADUser -Filter { GivenName -eq $GivenName -and Surname -eq $SurName } @GetADUserParams)
                    }
                    'employeeNumber'
                    {
                        $AdUser = @(Get-ADUser -filter { employeeNumber -eq $ID }  @GetADUserParams)
                    }
                    'employeeID'
                    {
                        $AdUser = @(Get-ADUser -filter { employeeID -eq $ID }  @GetADUserParams)
                    }
                }#switch
                Write-Log -Message "Succeeded: Get-ADUser with identifier $ID for Attribute $IdentityType"
            }#try
            catch
            {
                Write-Log -Message "FAILED: Get-ADUser with identifier $ID for Attribute $IdentityType" -Verbose -ErrorLog
                Write-Log -Message $_.tostring() -ErrorLog
                if ($ReportExceptions) { $Script:LookupADUserNotFound += $ID }
            }
            switch ($aduser.Count)
            {
                1
                {
                    $TrimmedADUser = $ADUser | Select-Object -property * -ExcludeProperty Item, PropertyNames, *Properties, PropertyCount
                    $TrimmedADUser
                }#1
                0
                {
                    if ($ReportExceptions) { $Script:LookupADUserNotFound += $ID }
                }#0
                Default
                {
                    if ($AmbiguousAllowed)
                    {
                        $TrimmedADUser = $ADUser | Select-Object -property * -ExcludeProperty Item, PropertyNames, *Properties, PropertyCount
                        $TrimmedADUser
                    }#if
                    else
                    {
                        if ($ReportExceptions) { $Script:LookupADUserAmbiguous += $ID }#if
                    }#else
                }#Default
            }#switch
        }#foreach
    }#Process
    end
    {
        if ($ReportExceptions)
        {
            if ($Script:LookupADUserNotFound.count -ge 1)
            {
                Write-Log -Message "$($Script:LookupADUserNotFound -join "`n`t")" -ErrorLog
            }#if
            if ($Script:LookupADUserAmbiguous.count -ge 1)
            {
                Write-Log -Message "$($Script:LookupADUserAmbiguous -join "`n`t")" -ErrorLog
            }#if
        }#if
    }#end
}#function
