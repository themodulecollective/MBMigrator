# Import MBM Module and Configuration
. "E:\Automations\MBMConfiguration.ps1"

#Archive Old Recipient Data
. "E:\Automations\ArchiveData.ps1" -Operation MoveRequestData -AgeInDays 15

$OutputFolderPath = $MBMConfiguration.MoveRequestDataExportFolder

Connect-ExchangeOnline -Organization $MBMConfiguration.TenantDomain -AppID $MBMConfiguration.ReportingAppID -CertificateThumbprint $MBMConfiguration.CertificateThumbprint -showBanner:$false

Export-MoveRequest -OutputFolderPath $OutputFolderPath -RemoteHostName $MBMConfiguration.Endpoint

$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *.xlsx)

#Truncate the Table Data
$dbiParams = @{
    SQLInstance = $MBMConfiguration.SQLInstance
    Database = $MBMConfiguration.Database
}

Invoke-DbaQuery @dbiParams -Query 'TRUNCATE TABLE dbo.stagingMoveRequest'

foreach ($f in $newDataFiles)
{
    Update-MBMRecipientData -Operation Recipient -FilePath $f.fullname -InformationAction Continue
	Import-Excel -Path $f.fullname | ConvertTo-DbaDataTable | Write-DbaDataTable @idbParams -Table stagingMoveRequest
}