
#NOTE: this function is being deprecated - functionality is moving to other more specific functions like Update-MBMPermissionData, Update-MBMRecipientData, Update-MBMWavePlanning, etc.
function Update-MBMActiveDirectoryData
{
    <#
    .SYNOPSIS
        A short one-line action-based description, e.g. 'Tests if a function is valid'
    .DESCRIPTION
        A longer description of the function, its purpose, common use cases, etc.
    .EXAMPLE
        Test-MyTestFunction -Verbose
        Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
    #>

    [cmdletbinding()]
    param(
        #
        [parameter(Mandatory)]
        [validateset('ADUser')]
        $Operation
        ,
        #
        [parameter(Mandatory)]
        [validatescript({ Test-Path -Path $_ -PathType Leaf -Filter *.xml })]
        $FilePath
        ,
        #
        [switch]$Truncate
        ,
        [switch]$AutoCreate
        ,
        [switch]$Test
    )

    Import-Module dbatools

    $Configuration = Get-MBMConfiguration

    $dbiParams = @{
        SqlInstance = $Configuration.SQLInstance
        Database    = $Configuration.Database
    }

    $SourceData = @(Import-Clixml -Path $FilePath)

    switch ($Operation)
    {
        'ADUser'
        {
            #Update Mailbox Data
            $ADUsers = @($SourceData)
            Write-Information -MessageData 'Processing Active Directory User Data'
            $dTParams = @{
                Table = 'stagingADUser'
            }
            if ($Truncate)
            {$dTParams.Truncate = $true}
            if ($AutoCreate)
            {$dTParams.AutoCreate = $true}
            #$property = @(@(Get-MBMColumnMap -tabletype stagingADUser).Name)

            $property = @(
                'AccountExpires'
                'AltRecipient'
                'BusinessCategory'
                'Company'
                'City'
                'C'
                'Country'
                'CO'
                'CountryCode'
                'CN'
                'ST'
                'Comment'
                'Description'
                'Division'
                'EmployeeID'
                'EmployeeNumber'
                'EmployeeType'
                'HomePhone'
                'Pager'
                'FacsimileTelephoneNumber'
                'TelephoneNumber'
                'Street'
                'Initials'
                'Manager'
                'Department'
                'Title'
                'PersonalTitle'
                'DisplayName'
                'GivenName'
                'Surname'
                'DistinguishedName'
                'CanonicalName'
                'DomainName'
                'Mail'
                'MailNickName'
                'mS-DS-ConsistencyGUID'
                'msExchMailboxGUID'
                'msExchMasterAccountSID'
                'msExchUsageLocation'
                'ObjectGUID'
                'PhysicalDeliveryOfficeName'
                'ProxyAddresses'
                'SamAccountName'
                'SID'
                'UserPrincipalName'
                'Enabled'
                $((1..15).foreach({"ExtensionAttribute$_"}))
                $((16..45).foreach({"msExchExtensionAttribute$_"}))
                $((1..5).foreach({"msExchExtensionCustomAttribute$_"}))
                'LastLogonDate'
            )
            $excludeProperty = @(
                'businesscategory'
                'ProxyAddresses'
                'mS-DS-ConsistencyGUID'
                'msExchMailboxGUID'
                'msExchMasterAccountSID'
                'SID'
                'ObjectGUID'
                'DomainName'
                $((1..5).foreach({"msExchExtensionCustomAttribute$_"}))
            )
            $customProperty = @(
                @{n = 'businesscategory'; e = { $_.businesscategory -join ';' } },
                @{n = 'ProxyAddresses'; e = { $_.ProxyAddresses -join ';' } },
                @{n = 'mS-DS-ConsistencyGUID'; e = { $([guid]$_.'mS-DS-ConsistencyGUID').guid } },
                @{n = 'msExchMailboxGUID'; e = { $([guid]$_.msExchMailboxGuid).guid } },
                @{n = 'msExchMasterAccountSID'; e = { $_.msExchMasterAccountSID.value } },
                @{n = 'SID'; e = { $_.SID.value } },
                @{n = 'ObjectGUID'; e = { $_.ObjectGUID.guid } },
                @{n = 'DomainName'; e = { $_.DistinguishedName.split(',').where( { $_ -like 'DC=*' }).foreach( { $_.split('=')[1] }) | Select-Object -First 1 } }
                @{n = 'msExchExtensionCustomAttribute2'; e = { $_.msExchExtensionCustomAttribute2 -join ';' } }
                @{n = 'msExchExtensionCustomAttribute1'; e = { $_.msExchExtensionCustomAttribute1 -join ';' } }
                @{n = 'msExchExtensionCustomAttribute3'; e = { $_.msExchExtensionCustomAttribute3 -join ';' } }
                @{n = 'msExchExtensionCustomAttribute4'; e = { $_.msExchExtensionCustomAttribute4 -join ';' } }
                @{n = 'msExchExtensionCustomAttribute5'; e = { $_.msExchExtensionCustomAttribute5 -join ';' } }
            )

            $ColumnMap = [ordered]@{}
            $property.foreach({ $ColumnMap.$_ = $_ })
            $dTParams.ColumnMap = $ColumnMap
            $property = @($property.where({ $_ -notin $excludeProperty }))

            $sADUsers = $ADUsers | Select-Object -ExcludeProperty $excludeProperty -Property @($property; $customProperty)

            switch ($test)
            {
                $true
                {
                    @{
                        Map = $ColumnMap
                        Data = $sADUsers
                        Table = Get-DbaDbTable @dbiParams -Table stagingADUser
                    }
                }
                $false
                {
                    $sAdUsers | ConvertTo-DbaDataTable | Write-DbaDataTable @dbiParams @dTParams
                }
            }

        }
    }
}