
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
        [validateset('ADUser','ADComputer','ADGroup')]
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
            #Update AD User Data
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
                'Mobile'
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
                'LastLogonDate'
            )
            $excludeProperty = @()
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
            @($property;$customProperty.foreach({$_.n})).foreach({ $ColumnMap.$_ = $_ })
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
        'ADComputer'
        {
            #Update AD Computer Data
            $ADComputers = @($SourceData)
            Write-Information -MessageData 'Processing Active Directory Computer Data'
            $dTParams = @{
                Table = 'stagingADComputer'
            }
            if ($Truncate)
            {$dTParams.Truncate = $true}
            if ($AutoCreate)
            {$dTParams.AutoCreate = $true}
            #$property = @(@(Get-MBMColumnMap -tabletype stagingADUser).Name)

            $property = @(
               'AccountExpirationDate'
               'AccountExpires'
               'AccountLockoutTime'
               'AccountNotDelegated'
               'AllowReversiblePasswordEncryption'
               'CannotChangePassword'
               'CanonicalName'
               'CN'
               'codePage'
               'countryCode'
               'Created'
               'createTimeStamp'
               'Description'
               'DisplayName'
               'DistinguishedName'
               'DNSHostName'
               'DoesNotRequirePreAuth'
               'Enabled'
               'HomedirRequired'
               'HomePage'
               'instanceType'
               'IPv4Address'
               'IPv6Address'
               'isCriticalSystemObject'
               'isDeleted'
               'LastBadPasswordAttempt'
               'LastKnownParent'
               'LastLogonDate'
               'lastLogonTimestamp'
               'localPolicyFlags'
               'Location'
               'LockedOut'
               'ManagedBy'
               'MNSLogonAccount'
               'Modified'
               'modifyTimeStamp'
               'Name'
               'ObjectCategory'
               'ObjectClass'
               'OperatingSystem'
               'OperatingSystemHotfix'
               'OperatingSystemServicePack'
               'OperatingSystemVersion'
               'PasswordExpired'
               'PasswordLastSet'
               'PasswordNeverExpires'
               'PasswordNotRequired'
               'PrimaryGroup'
               'primaryGroupID'
               'ProtectedFromAccidentalDeletion'
               'pwdLastSet'
               'SamAccountName'
               'sAMAccountType'
               'sDRightsEffective'
               'TrustedForDelegation'
               'TrustedToAuthForDelegation'
               'UseDESKeyOnly'
               'userAccountControl'
               'uSNChanged'
               'uSNCreated'
               'whenChanged'
               'whenCreated' 
            )
            $excludeProperty = @(
                'Certificates'
                'UserCertificate'
                'KerberosEncryptionType'
                'PrincipalsAllowedToDelegateToAccount'
                'UserPrincipalName'
                'ServiceAccount'
                'servicePrincipalName'
                'ServicePrincipalNames'
            )
            $customProperty = @(
                @{n = 'MemberOf'; e = { $_.MemberOf -join ';' } },
                @{n = 'SID'; e = { $_.SID.Value } },
                @{n = 'SIDHistory'; e={$_.SIDHistory.Value -join ';'}}
                @{n = 'ObjectGUID'; e = { $_.ObjectGUID.guid } },
                @{n = 'DomainName'; e = { $_.DistinguishedName.split(',').where( { $_ -like 'DC=*' }).foreach( { $_.split('=')[1] }) | Select-Object -First 1 } }
            )

            $ColumnMap = [ordered]@{}
            @($property;$customProperty.foreach({$_.n})).foreach({ $ColumnMap.$_ = $_ })
            $dTParams.ColumnMap = $ColumnMap
            $property = @($property.where({ $_ -notin $excludeProperty }))

            $sADComputers = $ADComputers | Select-Object -ExcludeProperty $excludeProperty -Property @($property; $customProperty)

            switch ($test)
            {
                $true
                {
                    @{
                        Map = $ColumnMap
                        Data = $sADComputers
                        Table = Get-DbaDbTable @dbiParams -Table stagingADComputer
                    }
                }
                $false
                {
                    $sADComputers | ConvertTo-DbaDataTable | Write-DbaDataTable @dbiParams @dTParams
                }
            }

        }
        'ADGroup'
        {
            #Update AD Group Data
            $ADGroups = @($SourceData)
            Write-Information -MessageData 'Processing Active Directory Group Data'
            $dTParams = @{
                Table = 'stagingADGroup'
            }
            if ($Truncate)
            {$dTParams.Truncate = $true}
            if ($AutoCreate)
            {$dTParams.AutoCreate = $true}
            #$property = @(@(Get-MBMColumnMap -tabletype stagingADUser).Name)

            $property = @(
                'CanonicalName'
                'CN'
                'Created'
                'CreateTimeStamp'
                'Description'
                'DisplayName'
                'DistinguishedName'
                'GroupCategory'
                'GroupScope'
                'GroupType'
                'HomePage'
                'InstanceType'
                'Modified'       
                'ModifyTimeStamp'
                'Name'
                'ObjectCategory'
                'ObjectClass'
                'ProtectedFromAccidentalDeletion'
                'SamAccountName'
                'sAMAccountType'
                'sDRightsEffective'
                'WhenChanged'
                'WhenCreated'
                'Mail'
                'MailNickName'
                'LegacyExchangeDN'
                'msExchRoleGroupType'
                'msExchRecipientDisplayType'
                'msExchGroupExternalMemberCount'
                'msExchGroupMemberCount'
            )
            $excludeProperty = @(
            )
            $customProperty = @(
                @{n = 'ProxyAddresses'; e = { $_.ProxyAddresses -join ';' } }   
                @{n = 'ManagedBy'; e = { $_.ManagedBy -join ';' } }
                @{n = 'Members'; e = { $_.Members -join ';' } }             
                @{n = 'MemberOf'; e = { $_.MemberOf -join ';' } }
                @{n = 'SID'; e = { $_.SID.Value } }
                @{n = 'SIDHistory'; e={$_.SIDHistory.Value -join ';'}}
                @{n = 'ObjectGUID'; e = { $_.ObjectGUID.guid } }
                @{n = 'ShowInAddressBook'; e = { $_.ShowInAddressBook -join ';' } }
                @{n = 'msExchCoManagedByLink'; e = { $_.msExchCoManagedByLink -join ';' } }                
                @{n = 'DomainName'; e = { $_.DistinguishedName.split(',').where( { $_ -like 'DC=*' }).foreach( { $_.split('=')[1] }) | Select-Object -First 1 } }
            )

            $ColumnMap = [ordered]@{}
            @($property;$customProperty.foreach({$_.n})).foreach({ $ColumnMap.$_ = $_ })
            $dTParams.ColumnMap = $ColumnMap
            $property = @($property.where({ $_ -notin $excludeProperty }))

            $sADGroups = $ADGroups | Select-Object -ExcludeProperty $excludeProperty -Property @($property; $customProperty)

            switch ($test)
            {
                $true
                {
                    @{
                        Map = $ColumnMap
                        Data = $sADGroups
                        Table = Get-DbaDbTable @dbiParams -Table stagingADGroup
                    }
                }
                $false
                {
                    $sADGroups | ConvertTo-DbaDataTable | Write-DbaDataTable @dbiParams @dTParams
                }
            }

        }
    }
}