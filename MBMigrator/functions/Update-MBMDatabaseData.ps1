
#NOTE: this function is being deprecated - functionality is moving to other more specific functions like Update-MBMPermissionData, Update-MBMRecipientData, Update-MBMWavePlanning, etc.
function Update-MBMDatabaseData {
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
        [pscredential]$sqlcredential = $(Get-Credential -UserName SA -Message sql)
        ,
        #
        [parameter()]
        [validateset('Mailbox')]
        #'ADUser', 'AzureADUser', , 'CASMailbox', 'MailboxStatistics', 'VIP', 'Pilot', 'WaveAssignments', 'WaveExceptions', 'MMLStatic', 'MMLExport'
        $Operation
        ,
        #
        $InputFolderPath
        ,
        #
        $OutputFolderPath
    )

    Import-Module ImportExcel
    Import-Module dbatools

    $Configuration = Get-MBMConfiguration
    $cdbiParams = @{
        SqlInstance       = $Configuration.SQLInstance
        Database          = $Configuration.Database
        SqlConnectionOnly = $true
    }

    $sql = Connect-DbaInstance @cdbiParams
    $InputFiles = @(Get-ChildItem -Path $InputFolderPath -Filter *.xml)
    $RecipientData = @(
        foreach ($f in $InputFiles) {
            Write-Information -MessageData "Importing File $($f.fullname)"
            Import-Clixml -Path $f.fullname
        }
    )

    switch ($Operation) {
        'ADUser' {
            #Update AD Users
            Write-Information -MessageData 'Processing AD User Data'
            $AD1Users = Import-Clixml -Path $(Join-Path -Path $InputFolderPath -ChildPath AD1Users.xml)
            $AD2Users = Import-Clixml -Path $(Join-Path -Path $InputFolderPath -ChildPath AD2Users.xml)
            $AD3Users = Import-Clixml -Path $(Join-Path -Path $InputFolderPath -ChildPath AD3Users.xml)
            $property = @('AzureADSync', 'Company', 'Department', 'DisplayName', 'DistinguishedName', 'Enabled', 'GivenName', 'Mail', 'mailnickname', 'msExchMasterAccountSID', 'Name', 'ObjectClass', 'objectSID', 'SamAccountName', 'SID', 'Surname', 'UserPrincipalName')
            $excludeProperty = @('ProxyAddresses', 'mS-DS-ConsistencyGUID', 'ExchangeGUID', 'msExchMasterAccountSID', 'ObjectSID', 'SID')
            $customProperty = @(
                @{n = 'ProxyAddresses'; e = { $_.ProxyAddresses -join ';' } },
                @{n = 'mS-DS-ConsistencyGUID'; e = { $([guid]$_.'mS-DS-ConsistencyGUID').guid } },
                @{n = 'msExchMailboxGuid'; e = { $([guid]$_.msExchMailboxGuid).guid } },
                @{n = 'msExchMasterAccountSID'; e = { $_.msExchMasterAccountSID.value } },
                @{n = 'ObjectSID'; e = { $_.ObjectSID.value } },
                @{n = 'SID'; e = { $_.SID.value } },
                @{n = 'ObjectGUID'; e = { $_.ObjectGUID.guid } },
                @{n = 'DomainName'; e = { $_.DistinguishedName.split(',').where( { $_ -like 'DC=*' }).foreach( { $_.split('=')[1] }) | Select-Object -First 1 } }
            )
            $AllADUsers = @($AD1Users; $AD2Users; $AD3Users) | Select-Object -ExcludeProperty $excludeProperty -Property @($property; $customProperty)
            $sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
            $AllADUsers | ConvertTo-DbaDataTable | Write-DbaDataTable -SqlInstance $sql -Database Migration -Table 'IncomingADUsers' -Truncate
            $sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
            $ADUpdates = Invoke-DbaQuery -SqlInstance $sql -Database Migration -Query $(Get-Content -Path '..\SQL\MergeADUsers.sql' -Raw) -As PSObject

            #Update DivCostCenterDepartment For AD Users
            Write-Information -MessageData 'Processing AD User Div Cost Center Data'
            $sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
            $ADUsers = Invoke-DbaQuery -SqlInstance $sql -Database Migration -Query 'Select ObjectGUID, Department FROM dbo.ADUsers'
            $ADUsersWithDivCostCenter = @(Get-ADDivCCDepartment -ADUsers $ADUsers)
            $sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
            $ADUsersWithDivCostCenter | ConvertTo-DbaDataTable | Write-DbaDataTable -SqlInstance $sql -Database Migration -Table 'ADUsersWithDivCostCenter' -Truncate
        }
        'AzureADUser' {
            #Update AAD Users
            Write-Information -MessageData 'Processing Azure AD User Data'
            $property = @('DeletionTimestamp', 'ObjectId', 'ObjectType', 'AccountEnabled', 'City', 'CompanyName', 'Country', 'CreationType', 'Department', 'DirSyncEnabled', 'DisplayName', 'FacsimileTelephoneNumber', 'GivenName', 'IsCompromised', 'ImmutableId', 'JobTitle', 'LastDirSyncTime', 'Mail', 'MailNickName', 'Mobile', 'OnPremisesSecurityIdentifier', 'OtherMails', 'PasswordPolicies', 'PasswordProfile', 'PhysicalDeliveryOfficeName', 'PostalCode', 'PreferredLanguage', 'ProvisioningErrors', 'RefreshTokensValidFromDateTime', 'ShowInAddressList', 'SignInNames', 'SipProxyAddress', 'State', 'StreetAddress', 'Surname', 'TelephoneNumber', 'UsageLocation', 'UserPrincipalName', 'UserState', 'UserStateChangedOn', 'UserType')
            $customProperty = @(@{n = 'ProxyAddresses'; e = { $_.ProxyAddresses -join ';' } })
            $AADUsers = Import-Clixml C:\Users\MikeCampbell\GitRepos\MigrationTracking\ExportedRecipientLists\AADUsers.xml
            $sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
            $AADUsers | Select-Object -Property @($property; $customProperty) | ConvertTo-DbaDataTable | Write-DbaDataTable -SqlInstance $sql -Database Migration -Table 'IncomingAADUsers' -Truncate
            $sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
            $AADUpdates = Invoke-DbaQuery -SqlInstance $sql -Database Migration -Query $(Get-Content -Path '..\SQL\MergeAADUsers.sql' -Raw) -As PSObject

        }
        'Mailbox' {
            #Update Mailbox Data
            Write-Information -MessageData 'Processing Exchange Mailbox Data'
            $Mailboxes = @($RecipientData.Mailbox)
            $property = @(@(Get-MBMColumnMap -tabletype stagingMailbox).Name)
            $excludeProperty = @(
                'EmailAddresses'
                , 'GrantSendOnBehalfTo'
                , 'ArchiveQuota'
                , 'ArchiveWarningQuota'
                , 'CalendarLoggingQuota'
                , 'IssueWarningQuota'
                , 'ProhibitSendQuota'
                , 'ProhibitSendReceiveQuota'
                , 'RecoverableItemsQuota'
                , 'RecoverableItemsWarningQuota'
                , 'RulesQuota'
                , 'MaxSendSize'
                , 'MaxReceiveSize'
            )
            $property = @($property.where({ $_ -notin $excludeProperty }))
            $customProperty = @(
                @{n = 'EmailAddresses'; e = { $_.EmailAddresses -join ';' } },
                @{n = 'GrantSendOnBehalfTo'; e = { $_.GrantSendOnBehalfTo -join ';' } }
                @{n = 'ArchiveQuotaInGB'; e = { Get-SortableSizeValue -Scale GB -Value $_.ArchiveQuota } }
                @{n = 'ArchiveWarningQuotaInGB'; e = { Get-SortableSizeValue -Scale GB -Value $_.ArchiveWarningQuota } }
                @{n = 'CalendarLoggingQuotaInGB'; e = { Get-SortableSizeValue -Scale GB -Value $_.CalendarLoggingQuota } }
                @{n = 'IssueWarningQuotaInGB'; e = { Get-SortableSizeValue -Scale GB -Value $_.IssueWarningQuota } }
                @{n = 'ProhibitSendQuotaInGB'; e = { Get-SortableSizeValue -Scale GB -Value $_.ProhibitSendQuota } }
                @{n = 'ProhibitSendReceiveQuotaInGB'; e = { Get-SortableSizeValue -Scale GB -Value $_.ProhibitSendReceiveQuota } }
                @{n = 'RecoverableItemsQuotaInGB'; e = { Get-SortableSizeValue -Scale GB -Value $_.RecoverableItemsQuota } }
                @{n = 'RecoverableItemsWarningQuotaInGB'; e = { Get-SortableSizeValue -Scale GB -Value $_.RecoverableItemsWarningQuota } }
                @{n = 'RulesQuotaInKB'; e = { Get-SortableSizeValue -Scale KB -Value $_.RulesQuota } }
                @{n = 'MaxSendSizeInMB'; e = { Get-SortableSizeValue -Scale GB -Value $_.MaxSendSize } }
                @{n = 'MaxReceiveSizeInMB'; e = { Get-SortableSizeValue -Scale GB -Value $_.MaxReceiveSize } }
            )
            $MailBoxes | Select-Object -ExcludeProperty $excludeProperty -Property @($property; $customProperty) |
            ConvertTo-DbaDataTable |
            Write-DbaDataTable @cdbiParams -Table 'stagingMailbox' -Truncate
            #$MailboxesUpdates = Invoke-DbaQuery @cdbiParams -Query $(Get-Content -Path '..\SQL\MergeExchangeMailboxes.sql' -Raw) -As PSObject
        }
        'MailboxStatistics' {
            Write-Information -MessageData 'Processing Exchange Mailbox Stats Data'
            $MailboxStats = @($RecipientData.MailboxStatistics)
            $property = @(@(Get-MBMColumnMap -tableType stagingMailboxStats))
            $property = @('ItemCount', 'DeletedItemCount', 'MailboxGuid', 'Database', 'DatabaseName', 'ServerName')
            $excludeProperty = @('TotalItemSize', 'TotalDeletedItemSize')
            $customProperty = @(
                @{n = 'TotalMailboxItemSizeInGB'; e = { [int]$($_.TotalItemSize.tostring().split(@('(', ')', ' '))[3].replace(',', '') / 1GB) } }
                @{n = 'TotalRecoverableItemSizeInGB'; e = { [int]$($_.TotalDeletedItemSize.tostring().split(@('(', ')', ' '))[3].replace(',', '') / 1GB) } }
            )
            $MailboxStats |
            Select-Object -ExcludeProperty $excludeProperty -Property @($property; $customProperty) |
            Select-Object -Property *, @{n = 'CombinedSizeInGB'; e = { $_.TotalMailboxItemSizeInGB + $_.TotalRecoverableItemSizeInGB } } |
            ConvertTo-DbaDataTable |
            Write-DbaDataTable -SqlInstance $sql -Database Migration -Table 'IncomingMailboxStats' -Truncate #-AutoCreateTable
        }
        'CASMailbox' {
            Write-Information -MessageData 'Processing Exchange CAS Mailbox Data'
            $EXACASMailboxes = $EXAMailboxData.CASMailbox
            $EXBCASMailboxes = $EXBMailboxData.CASMailbox
            $AllCASMailboxes = @($EXACASMailboxes; $EXBCASMailboxes)
            $property = @('ActiveSyncDebugLogging', 'ActiveSyncEnabled', 'ActiveSyncMailboxPolicy', 'ActiveSyncMailboxPolicyIsDefaulted', 'DisplayName', 'DistinguishedName', 'ECPEnabled', 'EwsAllowEntourage', 'EwsAllowList', 'EwsAllowMacOutlook', 'EwsAllowOutlook', 'EwsApplicationAccessPolicy', 'EwsBlockList', 'EwsEnabled', 'ExchangeVersion', 'ExternalImapSettings', 'ExternalPopSettings', 'ExternalSmtpSettings', 'Guid', 'HasActiveSyncDevicePartnership', 'Id', 'Identity', 'ImapEnabled', 'ImapEnableExactRFC822Size', 'ImapForceICalForCalendarRetrievalOption', 'ImapMessagesRetrievalMimeFormat', 'ImapSuppressReadReceipt', 'ImapUseProtocolDefaults', 'InternalImapSettings', 'InternalPopSettings', 'InternalSmtpSettings', 'IsValid', 'LegacyExchangeDN', 'LinkedMasterAccount', 'MAPIBlockOutlookExternalConnectivity', 'MAPIBlockOutlookNonCachedMode', 'MAPIBlockOutlookRpcHttp', 'MAPIBlockOutlookVersions', 'MAPIEnabled', 'MapiHttpEnabled', 'Name', 'ObjectCategory', 'ObjectClass', 'ObjectState', 'OrganizationId', 'OriginatingServer', 'OWAEnabled', 'OWAforDevicesEnabled', 'OwaMailboxPolicy', 'PopEnabled', 'PopEnableExactRFC822Size', 'PopForceICalForCalendarRetrievalOption', 'PopMessagesRetrievalMimeFormat', 'PopSuppressReadReceipt', 'PopUseProtocolDefaults', 'PrimarySmtpAddress', 'SamAccountName', 'ServerLegacyDN', 'ServerName', 'ShowGalAsDefaultView', 'WhenChanged', 'WhenChangedUTC', 'WhenCreated', 'WhenCreatedUTC')
            $excludeProperty = @('ActiveSyncAllowedDeviceIDs', 'ActiveSyncBlockedDeviceIDs', 'EmailAddresses')
            $customProperty = @(@{n = 'EmailAddresses'; e = { $_.EmailAddresses -join ';' } })
            $sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
            $ALLCASMailBoxes | Select-Object -ExcludeProperty $excludeProperty -Property @($property; $customProperty) | ConvertTo-DbaDataTable | Write-DbaDataTable -SqlInstance $sql -Database Migration -Table 'IncomingCASMailboxes' -Truncate #-AutoCreateTable
        }

        'VIP' {
            Write-Information -MessageData 'Processing VIPs Data'
            $VIPs = Import-Excel -Path $(Join-Path -Path $InputFolderPath -ChildPath SpecialHandling.xlsx) -WorksheetName VIPs
            $sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
            $VIPs | ConvertTo-DbaDataTable | Write-DbaDataTable -SqlInstance $sql -Database Migration -Table VIPs -Truncate -Confirm:$false
        }
        'Pilot' {
            Write-Information -MessageData 'Processing PilotUsers Data'
            $PilotUsers = Import-Excel -Path $(Join-Path -Path $InputFolderPath -ChildPath SpecialHandling.xlsx) -WorksheetName PilotUsers
            $sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
            $PilotUsers | ConvertTo-DbaDataTable | Write-DbaDataTable -SqlInstance $sql -Database Migration -Table PilotUsers -Truncate -Confirm:$False
        }
        'WaveAssignments' {
            Write-Information -MessageData 'Processing Wave Assignments Data'
            $WaveAssignments = Import-Excel -Path $(Join-Path -Path $InputFolderPath -ChildPath WavePlanning.xlsx) -WorksheetName BusDivAssignments
            $sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
            $WaveAssignments | ConvertTo-DbaDataTable | Write-DbaDataTable -SqlInstance $sql -Database Migration -Table BusDivAssignments -Truncate -Confirm:$false
        }
        'WaveExceptions' {
            Write-Information -MessageData 'Processing Wave Exceptions Data'
            $WaveExceptions = Import-Excel -Path $(Join-Path -Path $InputFolderPath -ChildPath SpecialHandling.xlsx) -WorksheetName WaveExceptions
            $sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
            $WaveExceptions | ConvertTo-DbaDataTable | Write-DbaDataTable -SqlInstance $sql -Database Migration -Table WaveExceptions -Truncate -Confirm:$false
        }
    }

    switch ($Operation) {
        'MMLStatic' {
            Write-Information -MessageData 'Processing Updating MML Static'
            $sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
            Invoke-DbaQuery -SqlInstance $sql -Database Migration -Query $(Get-Content -Path ..\SQL\DropAndRecreateMigrationListStatic.sql -Raw) -As PSObject
        }
        'MMLExport' {
            $sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
            $MigrationList = Invoke-DbaQuery -SqlInstance $sql -Database Migration -Query 'select * from dbo.MigrationList' -As PsObject

            $Path = Join-Path -Path $OutputFolderPath -ChildPath 'MigrationList.xlsx'

            Remove-Item -Path $Path -Force -Confirm:$False

            $ExportExcelParams = @{
                Path          = $Path
                FreezeTopRow  = $true
                AutoFilter    = $true
                ClearSheet    = $true
                WorksheetName = 'MailboxWaveAssignments'
                TableStyle    = 'Medium20'
                PassThru      = $true
            }
            $Pivot1Params = @{
                PivotTableName  = 'WaveAssignmentSummary'
                PivotRows       = 'AssignedWave'
                PivotData       = @{'msExchMailboxGuid' = 'COUNT' }
                PivotFilter     = 'RecipientTypeDetails', 'ExchangeOrg'
                SourceWorksheet = 'MailboxWaveAssignments'
            }
            $Pivot2Params = @{
                PivotTableName  = 'MigrationStatus'
                PivotRows       = 'Migrated'
                PivotData       = @{'msExchMailboxGuid' = 'COUNT' }
                PivotFilter     = 'RecipientTypeDetails', 'ExchangeOrg'
                SourceWorksheet = 'MailboxWaveAssignments'
            }

            $MMLExcel = $MigrationList | Export-Excel @ExportExcelParams
            Add-PivotTable @Pivot1Params -ExcelPackage $MMLExcel
            Add-PivotTable @Pivot2Params -ExcelPackage $MMLExcel
            Close-ExcelPackage -ExcelPackage $MMLExcel
        }
    }
}