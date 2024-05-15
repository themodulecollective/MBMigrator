# Import MBM Module and Configuration
. "E:\Automations\MBMConfiguration.ps1"

#Connect & Prepare the Sessions
. "E:\Automations\ConnectSessions.ps1"

#Archive Old Recipient Data
. "E:\Automations\ArchiveData.ps1" -Operation MailboxData -AgeInDays 15

#Get the Sessions
$RequiredSessions = @('PremisesExchange')
switch ($RequiredSessions)
{
    'PremisesExchange'
    {
        $OnPremExchange = Get-PSSession -Name $_
    }
}

$OutputFolderPath = $MBMConfiguration.MailboxDataExportFolder
$MBMModulePath = $MBMConfiguration.MBMModulePath
$Organization = $MBMConfiguration.TenantDomain
$AppID = $MBMConfiguration.ReportingAppID
$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint

$Jobs = @(
    Invoke-Command -Session $OnPremExchange -AsJob -JobName ExportOnPremisesMailboxData -ScriptBlock {
        Export-ExchangeRecipient -informationaction continue -operation Mailbox,CASMailbox,RemoteMailbox,MailboxStatistics -OutputFolderPath $using:OutputFolderPath
        }

	 Start-ThreadJob -Name ExportOnlineMailboxData -ScriptBlock {
        Import-Module $Using:MBMModulePath
		Import-Module ExchangeOnlineManagement
		Connect-ExchangeOnline -Organization $using:Organization -AppID $using:AppID -CertificateThumbprint $using:CertificateThumbprint
        Export-ExchangeRecipient -InformationAction Continue -Operation Mailbox,CASMailbox,MailboxStatistics -OutputFolderPath $using:OutputFolderPath
    } 
)

Wait-Job -Job $Jobs

$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *ExchangeRecipientsAsOf*.xml)

#Truncate the Table Data
$dbiParams = @{
    SQLInstance = $MBMConfiguration.SQLInstance
    Database = $MBMConfiguration.Database
}

#Invoke-DbaQuery @dbiParams -File E:\MBMigration\sql\UpdateHistoryMailboxMigrationList.sql
Invoke-DbaQuery @dbiParams -Query 'TRUNCATE TABLE dbo.stagingMailbox; TRUNCATE TABLE dbo.stagingMailboxStats; TRUNCATE TABLE dbo.stagingCASMailbox'

foreach ($f in $newDataFiles)
{
    Update-MBMRecipientData -Operation Mailbox -FilePath $f.fullname -InformationAction Continue #-Truncate
	Update-MBMRecipientData -Operation MailboxStatistics -FilePath $f.fullname -InformationAction Continue #-Truncate
	
	$Property = 'ActiveSyncDebugLogging','ActiveSyncEnabled','ActiveSyncMailboxPolicy','ActiveSyncMailboxPolicyIsDefaulted','ActiveSyncSuppressReadReceipt','DisplayName','DistinguishedName','ECPEnabled','EmailAddresses','EwsAllowEntourage','EwsAllowMacOutlook','EwsAllowOutlook','EwsApplicationAccessPolicy','EwsEnabled','ExchangeVersion','ExternalImapSettings','ExternalPopSettings','ExternalSmtpSettings','Guid','HasActiveSyncDevicePartnership','Id','Identity','ImapEnabled','ImapEnableExactRFC822Size','ImapForceICalForCalendarRetrievalOption','ImapMessagesRetrievalMimeFormat','ImapSuppressReadReceipt','ImapUseProtocolDefaults','InternalImapSettings','InternalPopSettings','InternalSmtpSettings','IsOptimizedForAccessibility','IsValid','LegacyExchangeDN','LinkedMasterAccount','MAPIBlockOutlookExternalConnectivity','MAPIBlockOutlookNonCachedMode','MAPIBlockOutlookRpcHttp','MAPIBlockOutlookVersions','MAPIEnabled','MapiHttpEnabled','Name','ObjectCategory','ObjectClass','ObjectState','OrganizationId','OriginatingServer','OWAEnabled','OWAforDevicesEnabled','OwaMailboxPolicy','PopEnabled','PopEnableExactRFC822Size','PopForceICalForCalendarRetrievalOption','PopMessageDeleteEnabled','PopMessagesRetrievalMimeFormat','PopSuppressReadReceipt','PopUseProtocolDefaults','PrimarySmtpAddress','PublicFolderClientAccess','SamAccountName','ServerLegacyDN','ServerName','ShowGalAsDefaultView','UniversalOutlookEnabled','WhenChanged','WhenChangedUTC','WhenCreated','WhenCreatedUTC'
	$CustomProperty = @(
		@{n='ActiveSyncAllowedDeviceIDs';e={$_.ActiveSyncAllowedDeviceIDs -join ';'}}
		@{n='ActiveSyncBlockedDeviceIDs';e={$_.ActiveSyncBlockedDeviceIDs -join ';'}}
		@{n='EwsBlockList';e={$_.EwsBlockList -join ';'}}
		@{n='EwsAllowList';e={$_.EwsAllowList -join ';'}}
	)
	$ExcludeProperty = 'ActiveSyncAllowedDeviceIDs','ActiveSyncBlockedDeviceIDs','EwsBlockList','EwsAllowList','EmailAddresses','ExchangeVersion','External*Settings','Id','Internal*Settings','ObjectClass'
	$AllProperty = @($Property;$CustomProperty)
	
	$CASMailbox = Import-Clixml -Path $f.Fullname
	$CASMailbox.CASMailbox | Select-Object -ExcludeProperty $ExcludeProperty -Property $AllProperty | Convertto-dbaDataTable | Write-dbaDataTable @dbiParams -table stagingCASMailbox
}
