function Update-MBMRecipientData
{
    <#
    .SYNOPSIS
        Updates Recipient data in the Migration Database
    .DESCRIPTION
        Takes the xml file from Export-ExchangeRecipient and updates the Migration Database with the new recipient data
    .EXAMPLE
        Update-MBMRecipientData -Operation Mailbox -FilePath "C:\Users\Username\Documents\exchangeRecipientExport.xml"
        Updates the mailbox dbs in with the recipient data from the exchangeRecipientExport.xml
    #>

    [cmdletbinding()]
    param(
        #
        [parameter(Mandatory)]
        [validateset('Mailbox', 'MailboxStatistics','Recipient')]
        [string]$Operation
        ,
        #
        [parameter(Mandatory)]
        [validatescript({ Test-Path -Path $_ -PathType Leaf -Filter *.xml })]
        [string]$FilePath
        ,
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

    $SourceOrganization = $SourceData.OrganizationConfig.Name

    $dTParams = @{}
    if ($Truncate)
    { $dTParams.Truncate = $true }
    if ($AutoCreate)
    { $dTParams.AutoCreate = $true }

    switch ($Operation)
    {
        'Mailbox'
        {
            #Update Mailbox Data
            Write-Information -MessageData 'Processing Exchange Mailbox Data'

            $dTParams.Table = 'stagingMailbox'

            $property = @(@(Get-MBMColumnMap -tabletype stagingMailbox).Name)
            $ColumnMap = @{}
            $property.foreach({ $ColumnMap.$_ = $_ })
            $dTParams.ColumnMap = $ColumnMap

            $excludeProperty = @(
                'EmailAddresses'
                ,'ArchiveGuid'
                , 'ArchiveName'
                , 'ArchiveQuotaInGB'
                , 'ArchiveWarningQuotaInGB'
                , 'CalendarLoggingQuotaInGB'
                , 'IssueWarningQuotaInGB'
                , 'ProhibitSendQuotaInGB'
                , 'ProhibitSendReceiveQuotaInGB'
                , 'RecoverableItemsQuotaInGB'
                , 'RecoverableItemsWarningQuotaInGB'
                , 'RulesQuotaInKB'
                , 'MaxSendSizeInMB'
                , 'MaxReceiveSizeInMB'
                , 'ExchangeGuid'
                , 'ExchangeObjectId'
                , 'ExternalDirectoryObjectID'
                , 'Guid'
                , 'BCCBlocked'
                , 'IsAuxMailbox'
                , 'SKUAssigned'
                , 'ExtensionCustomAttribute1'
                , 'ExtensionCustomAttribute2'
                , 'ExtensionCustomAttribute3'
                , 'ExtensionCustomAttribute4'
                , 'ExtensionCustomAttribute5'
                , 'TargetAddress'
                , 'SourceOrganization'
            )
            $property = @($property.where({ $_ -notin $excludeProperty }))
            $customProperty = @(
                @{n = 'SourceOrganization'; e = { $SourceOrganization } }
                @{n = 'ExchangeGuid'; e = { $_.ExchangeGuid.guid } }
                @{n = 'ExchangeObjectId'; e = { $_.ExchangeObjectId.guid } }
                @{n = 'ExternalDirectoryObjectID'; e = { $_.ExternalDirectoryObjectID.tostring() } } # something changed here with serialization/deserialization and it's not coming in as GUID.  This will still work if that changes back to GUID in future.
                @{n = 'Guid'; e = { $_.Guid.guid } }
                @{n = 'ArchiveGuid'; e = { $_.ArchiveGuid.guid } }
                @{n = 'EmailAddresses'; e = { $_.EmailAddresses -join ';' } },
                @{n = 'ExtensionCustomAttribute1'; e = { $_.ExtensionCustomAttribute1 -join ';' } }
                @{n = 'ExtensionCustomAttribute2'; e = { $_.ExtensionCustomAttribute2 -join ';' } }
                @{n = 'ExtensionCustomAttribute3'; e = { $_.ExtensionCustomAttribute3 -join ';' } }
                @{n = 'ExtensionCustomAttribute4'; e = { $_.ExtensionCustomAttribute4 -join ';' } }
                @{n = 'ExtensionCustomAttribute5'; e = { $_.ExtensionCustomAttribute5 -join ';' } }
                @{n = 'ArchiveName'; e = { $_.ArchiveName -join ';' } }
                @{n = 'ArchiveQuotaInGB'; e = { [string]$(Get-SortableSizeValue -Scale GB -Value $_.ArchiveQuota) } }
                @{n = 'ArchiveWarningQuotaInGB'; e = { [string]$(Get-SortableSizeValue -Scale GB -Value $_.ArchiveWarningQuota) } }
                @{n = 'CalendarLoggingQuotaInGB'; e = { [string]$(Get-SortableSizeValue -Scale GB -Value $_.CalendarLoggingQuota) } }
                @{n = 'IssueWarningQuotaInGB'; e = { [string]$(Get-SortableSizeValue -Scale GB -Value $_.IssueWarningQuota) } }
                @{n = 'ProhibitSendQuotaInGB'; e = { [string]$(Get-SortableSizeValue -Scale GB -Value $_.ProhibitSendQuota) } }
                @{n = 'ProhibitSendReceiveQuotaInGB'; e = { [string]$(Get-SortableSizeValue -Scale GB -Value $_.ProhibitSendReceiveQuota) } }
                @{n = 'RecoverableItemsQuotaInGB'; e = { [string]$(Get-SortableSizeValue -Scale GB -Value $_.RecoverableItemsQuota) } }
                @{n = 'RecoverableItemsWarningQuotaInGB'; e = { [string]$(Get-SortableSizeValue -Scale GB -Value $_.RecoverableItemsWarningQuota) } }
                @{n = 'RulesQuotaInKB'; e = { [string]$(Get-SortableSizeValue -Scale KB -Value $_.RulesQuota) } }
                @{n = 'MaxSendSizeInMB'; e = { [string]$(Get-SortableSizeValue -Scale GB -Value $_.MaxSendSize) } }
                @{n = 'MaxReceiveSizeInMB'; e = { [string]$(Get-SortableSizeValue -Scale GB -Value $_.MaxReceiveSize) } }
                @{n = 'BCCBlocked'; e = { [bool]$_.BCCBlocked } }
                @{n = 'IsAuxMailbox'; e = { [bool]$_.IsAuxMailbox } }
                @{n = 'SKUAssigned'; e = { [bool]$_.SKUAssigned } }
                @{n = 'TargetAddress'; e = { $_.EmailAddresses.where({ $_ -like '*.mail.onmicrosoft.com' })[0] } }
            )
            $Mailboxes = @($SourceData.Mailbox; $SourceData.RemoteMailbox)
            $Data = $MailBoxes |
            Select-Object -ExcludeProperty $excludeProperty -Property @($property; $customProperty)

        }
        'MailboxStatistics'
        {
            #Update Mailbox Statistics Data
            Write-Information -MessageData 'Processing Exchange Mailbox Statistics Data'
            $dTParams.Table = 'stagingMailboxStats'
            $property = @(@(Get-MBMColumnMap -tabletype stagingMailboxStats).Name)
            $ColumnMap = @{}
            $property.foreach({ $ColumnMap.$_ = $_ })
            $dTParams.ColumnMap = $ColumnMap
            $excludeProperty = @(
                'MailboxGuid'
                , 'OwnerADGuid'
                , 'ExternalDirectoryOrganizationID'
                , 'TotalItemSizeInGB'
                , 'TotalDeletedItemSizeInGB'
                , 'MessageTableTotalSizeInGB'
                , 'AttachmentTableTotalSizeInGB'
                , 'SourceOrganization'
            )
            $property = @($property.where({ $_ -notin $excludeProperty }))
            $customProperty = @(
                @{n = 'SourceOrganization'; e = { $SourceOrganization } }
                @{n = 'MailboxGuid'; e = { $_.MailboxGuid.guid } }
                @{n = 'OwnerADGuid'; e = { $_.OwnerADGuid.guid } }
                @{n = 'ExternalDirectoryOrganizationID'; e = { $_.ExternalDirectoryOrganizationID.guid } }
                @{n = 'TotalItemSizeInGB'; e = { [string]$(Get-SortableSizeValue -Scale GB -Value $_.TotalItemSize) } }
                @{n = 'TotalDeletedItemSizeInGB'; e = { [string]$(Get-SortableSizeValue -Scale GB -Value $_.TotalDeletedItemSize) } }
                @{n = 'MessageTableTotalSizeInGB'; e = { [string]$(Get-SortableSizeValue -Scale GB -Value $_.MessageTableTotalSize) } }
                @{n = 'AttachmentTableTotalSizeInGB'; e = { [string]$(Get-SortableSizeValue -Scale GB -Value $_.AttachmentTableTotalSize) } }
            )
            $MailboxStats = @($SourceData.MailboxStatistics; )
            $Data = $MailboxStats |
            Select-Object -ExcludeProperty $excludeProperty -Property @($property; $customProperty)
        }
        'Recipient'
        {
            #Update Recipient Data
            Write-Information -MessageData 'Processing Exchange Recipient Data'
            $dTParams.Table = 'stagingRecipient'
            $property = @(@(Get-MBMColumnMap -tabletype stagingRecipient).Name)
            $ColumnMap = @{}
            $property.foreach({ $ColumnMap.$_ = $_ })
            $dTParams.ColumnMap = $ColumnMap
            $excludeProperty = @(
                'EmailAddresses'
                ,'ArchiveGuid'
                , 'ExchangeGuid'
                , 'ExchangeObjectId'
                , 'ExternalDirectoryObjectID'
                , 'Guid'
                , 'ExtensionCustomAttribute1'
                , 'ExtensionCustomAttribute2'
                , 'ExtensionCustomAttribute3'
                , 'ExtensionCustomAttribute4'
                , 'ExtensionCustomAttribute5'
                , 'TargetAddress'
                , 'SourceOrganization'
            )
            $property = @($property.where({ $_ -notin $excludeProperty }))
            $customProperty = @(
                @{n = 'SourceOrganization'; e = { $SourceOrganization } }
                @{n = 'ExchangeGuid'; e = { $_.ExchangeGuid.guid } }
                @{n = 'ExchangeObjectId'; e = { $_.ExchangeObjectId.guid } }
                @{n = 'ExternalDirectoryObjectID'; e = { $_.ExternalDirectoryObjectID.tostring() } } # something changed here with serialization/deserialization and it's not coming in as GUID.  This will still work if that changes back to GUID in future.
                @{n = 'Guid'; e = { $_.Guid.guid } }
                @{n = 'ArchiveGuid'; e = { $_.ArchiveGuid.guid } }
                @{n = 'EmailAddresses'; e = { $_.EmailAddresses -join ';' } },
                @{n = 'ExtensionCustomAttribute1'; e = { $_.ExtensionCustomAttribute1 -join ';' } }
                @{n = 'ExtensionCustomAttribute2'; e = { $_.ExtensionCustomAttribute2 -join ';' } }
                @{n = 'ExtensionCustomAttribute3'; e = { $_.ExtensionCustomAttribute3 -join ';' } }
                @{n = 'ExtensionCustomAttribute4'; e = { $_.ExtensionCustomAttribute4 -join ';' } }
                @{n = 'ExtensionCustomAttribute5'; e = { $_.ExtensionCustomAttribute5 -join ';' } }
                @{n = 'TargetAddress'; e = { $_.EmailAddresses.where({ $_ -like '*.mail.onmicrosoft.com' })[0] } }
            )
            $Recipients = @($SourceData.Recipient)
            $Data = $Recipients | Select-Object -ExcludeProperty $excludeProperty -Property @($property; $customProperty)
        }
    }
    switch ($test)
    {
        $true
        {
            @{
                Map = $ColumnMap
                Data = $Data
                Table = Get-DbaDbTable @dbiParams -Table $dTParams.Table
            }
        }
        $false
        {
                $Data | ConvertTo-DbaDataTable | Write-DbaDataTable @dbiParams @dTParams
        }
    }
}