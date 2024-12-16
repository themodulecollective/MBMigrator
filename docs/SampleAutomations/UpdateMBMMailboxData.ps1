# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"

$ThisTask = Split-Path -Path $PSCommandPath -Leaf
Write-Log -Level INFO -Message "Task $ThisTask Imported Migration Manager Module and Configuration"

#Archive Old User Data

Write-Log -Level INFO -Message "Task $ThisTask Running: Archive Mailbox Data"

. "C:\Migration\Scripts\ArchiveData.ps1" -Operation MailboxData -AgeInDays 30

Write-Log -Level INFO -Message "Task $ThisTask Completed: Archive Mailbox Data"

$OutputFolderPath = $MBMConfiguration.MailboxDataFolder
$MBMModulePath = $MBMConfiguration.MBMModulePath
$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint

$tenants = @(
    @{
        TenantDomain = $MBMConfiguration.SourceTenantDomain
        TenantID = $MBMConfiguration.SourceTenantID
        AppID = $MBMConfiguration.SourceTenantReportingAppID
    }
    @{
        TenantDomain = $MBMConfiguration.TargetTenantDomain
        TenantID = $MBMConfiguration.TargetTenantID
        AppID = $MBMConfiguration.TargetTenantReportingAppID
    }
)

Write-Log -Level INFO -Message "Task $ThisTask Running: Start Jobs Export Mailboxes for Tenants $($tenants.TenantDomain -join ' | ')"

$Jobs = @(

foreach ($t in $tenants) {
	$Organization = $t.TenantDomain
	$AppID = $t.AppID
	Start-ThreadJob -Name ExportOnlineMailboxData -ScriptBlock {
        Import-Module $Using:MBMModulePath
		Import-Module ExchangeOnlineManagement
		Connect-ExchangeOnline -Organization $using:Organization -AppID $using:AppID -CertificateThumbprint $using:CertificateThumbprint
        Export-ExchangeRecipient -InformationAction Continue -Operation Mailbox -OutputFolderPath $using:OutputFolderPath #,CASMailbox
    } 
}
)

Write-Log -Level INFO -Message "Task $ThisTask Waiting: for Jobs $($Jobs.Name -join ',')"
Wait-Job -Job $Jobs
Write-Log -Level INFO -Message "Task $ThisTask Completed: Jobs $($Jobs.name -join ',')"

Write-Log -Level INFO -Message "Task $ThisTask Getting Newly Exported Files from $OutputFolderPath"
$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *ExchangeRecipientsAsOf*.xml)

#Truncate the Table Data
$dbiParams = @{
    SQLInstance = $MBMConfiguration.SQLInstance
    Database = $MBMConfiguration.Database
}

Write-Log -Level INFO -Message "Task $ThisTask Running: Truncate stagingMailbox Table"
#Invoke-DbaQuery @dbiParams -File E:\MBMigration\sql\UpdateHistoryMailboxMigrationList.sql
Invoke-DbaQuery @dbiParams -Query 'TRUNCATE TABLE dbo.stagingMailbox;' #TRUNCATE TABLE dbo.stagingCASMailbox'
Write-Log -Level INFO -Message "Task $ThisTask Completed: Truncate stagingMailbox Table"

Write-Log -Message "Task $ThisTask Running: Update-MBMRecipientData: Operation: Mailbox: with Mailboxes from $($newDataFiles.fullname -join ';')" -Level INFO
foreach ($f in $newDataFiles)
{
    Update-MBMRecipientData -Operation Mailbox -FilePath $f.fullname -InformationAction Continue #-Truncate
	
<# 	$Property = 'ActiveSyncDebugLogging','ActiveSyncEnabled','ActiveSyncMailboxPolicy','ActiveSyncMailboxPolicyIsDefaulted','ActiveSyncSuppressReadReceipt','DisplayName','DistinguishedName','ECPEnabled','EmailAddresses','EwsAllowEntourage','EwsAllowMacOutlook','EwsAllowOutlook','EwsApplicationAccessPolicy','EwsEnabled','ExchangeVersion','ExternalImapSettings','ExternalPopSettings','ExternalSmtpSettings','Guid','HasActiveSyncDevicePartnership','Id','Identity','ImapEnabled','ImapEnableExactRFC822Size','ImapForceICalForCalendarRetrievalOption','ImapMessagesRetrievalMimeFormat','ImapSuppressReadReceipt','ImapUseProtocolDefaults','InternalImapSettings','InternalPopSettings','InternalSmtpSettings','IsOptimizedForAccessibility','IsValid','LegacyExchangeDN','LinkedMasterAccount','MAPIBlockOutlookExternalConnectivity','MAPIBlockOutlookNonCachedMode','MAPIBlockOutlookRpcHttp','MAPIBlockOutlookVersions','MAPIEnabled','MapiHttpEnabled','Name','ObjectCategory','ObjectClass','ObjectState','OrganizationId','OriginatingServer','OWAEnabled','OWAforDevicesEnabled','OwaMailboxPolicy','PopEnabled','PopEnableExactRFC822Size','PopForceICalForCalendarRetrievalOption','PopMessageDeleteEnabled','PopMessagesRetrievalMimeFormat','PopSuppressReadReceipt','PopUseProtocolDefaults','PrimarySmtpAddress','PublicFolderClientAccess','SamAccountName','ServerLegacyDN','ServerName','ShowGalAsDefaultView','UniversalOutlookEnabled','WhenChanged','WhenChangedUTC','WhenCreated','WhenCreatedUTC'
	$CustomProperty = @(
		@{n='ActiveSyncAllowedDeviceIDs';e={$_.ActiveSyncAllowedDeviceIDs -join ';'}}
		@{n='ActiveSyncBlockedDeviceIDs';e={$_.ActiveSyncBlockedDeviceIDs -join ';'}}
		@{n='EwsBlockList';e={$_.EwsBlockList -join ';'}}
		@{n='EwsAllowList';e={$_.EwsAllowList -join ';'}}
	)
	$ExcludeProperty = 'ActiveSyncAllowedDeviceIDs','ActiveSyncBlockedDeviceIDs','EwsBlockList','EwsAllowList','EmailAddresses','ExchangeVersion','External*Settings','Id','Internal*Settings','ObjectClass'
	$AllProperty = @($Property;$CustomProperty)
	
	$CASMailbox = Import-Clixml -Path $f.Fullname
	$CASMailbox.CASMailbox | Select-Object -ExcludeProperty $ExcludeProperty -Property $AllProperty | Convertto-dbaDataTable | Write-dbaDataTable @dbiParams -table stagingCASMailbox #>
}
Write-Log -Message "Task $ThisTask Completed: Update-MBMRecipientData: Operation: Mailbox: with Mailboxes from $($newDataFiles.fullname -join ';')" -Level INFO

Wait-Logging