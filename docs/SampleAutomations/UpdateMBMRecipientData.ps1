# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"

#Archive Old User Data
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation RecipientData -AgeInDays 30


$OutputFolderPath = $MBMConfiguration.RecipientDataFolder
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

$Jobs = @(
foreach ($t in $tenants) {
	$Organization = $t.TenantDomain
	$AppID = $t.AppID
	Start-ThreadJob -Name ExportOnlineMailboxData -ScriptBlock {
        Import-Module $Using:MBMModulePath
		Import-Module ExchangeOnlineManagement
		Connect-ExchangeOnline -Organization $using:Organization -AppID $using:AppID -CertificateThumbprint $using:CertificateThumbprint
        Export-ExchangeRecipient -InformationAction Continue -Operation Recipient -OutputFolderPath $using:OutputFolderPath # ,MailboxStatistics,CASMailbox
    }
}
)

Wait-Job -Job $Jobs

$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *ExchangeRecipientsAsOf*.xml)


$dbiParams = @{
    SQLInstance = $MBMConfiguration.SQLInstance
    Database = $MBMConfiguration.Database
}

Invoke-DbaQuery @dbiParams -Query 'TRUNCATE TABLE dbo.stagingRecipient'

foreach ($f in $newDataFiles)
{
    Update-MBMRecipientData -Operation Recipient -FilePath $f.fullname -InformationAction Continue
}
