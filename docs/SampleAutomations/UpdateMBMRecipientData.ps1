# Import MBM Module and Configuration
. "E:\Automations\MBMConfiguration.ps1"

#Connect & Prepare the Sessions
. "E:\Automations\ConnectSessions.ps1"

#Archive Old Recipient Data
. "E:\Automations\ArchiveData.ps1" -Operation RecipientData -AgeInDays 15

#Get the Sessions
$RequiredSessions = @('PremisesExchange')
switch ($RequiredSessions)
{
    'PremisesExchange'
    {
        $OnPremExchange = Get-PSSession -Name $_
    }
}

$OutputFolderPath = $MBMConfiguration.RecipientDataExportFolder
$MBMModulePath = $MBMConfiguration.MBMModulePath
$Organization = $MBMConfiguration.TenantDomain
$AppID = $MBMConfiguration.ReportingAppID
$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint

$Jobs = @(
     Invoke-Command -Session $OnPremExchange -AsJob -JobName ExportOnPremisesRecipientsData -ScriptBlock {
        Export-ExchangeRecipient -informationaction continue -operation Recipient -OutputFolderPath $using:OutputFolderPath
        } 
	 Start-ThreadJob -Name ExportOnlineRecipientsData -ScriptBlock {
        Import-Module $Using:MBMModulePath
		Import-Module ExchangeOnlineManagement
		Connect-ExchangeOnline -Organization $using:Organization -AppID $using:AppID -CertificateThumbprint $using:CertificateThumbprint
        Export-ExchangeRecipient -InformationAction Continue -Operation Recipient -OutputFolderPath $using:OutputFolderPath
    } 
)

Wait-Job -Job $Jobs


$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *ExchangeRecipientsAsOf*.xml)

#Truncate the Table Data
$dbiParams = @{
    SQLInstance = $MBMConfiguration.SQLInstance
    Database = $MBMConfiguration.Database
}

Invoke-DbaQuery @dbiParams -Query 'TRUNCATE TABLE dbo.stagingRecipient'

foreach ($f in $newDataFiles)
{
    Update-MBMRecipientData -Operation Recipient -FilePath $f.fullname -InformationAction Continue
}
