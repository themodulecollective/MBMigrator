# Import MBM Module and Configuration
. "E:\Automations\MBMConfiguration.ps1"

#Archive Old Recipient Data
. "E:\Automations\ArchiveData.ps1" -Operation AzureADUserLicensingData -AgeInDays 15

$OutputFolderPath = $MBMConfiguration.AzureADUserLicensingDataFolder
$MBMModulePath = $MBMConfiguration.MBMModulePath
$Organization = $MBMConfiguration.TenantDomain
$TenantID = $MBMConfiguration.TenantID
$AppID = $MBMConfiguration.ReportingAppID
$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint

Connect-Graph -TenantID $TenantID -ClientID $AppID -CertificateThumbprint $CertificateThumbprint

Export-AzureADUserLicensing -Sku 'skus' -OutputFolderPath F:\LicensingData

$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *UserLicensingAsOf*.xlsx)


#Truncate the Table Data
$dbiParams = @{
    SQLInstance = $MBMConfiguration.SQLInstance
    Database = $MBMConfiguration.Database
}

Invoke-DbaQuery @dbiParams -Query 'TRUNCATE TABLE dbo.stagingUserLicensing'

foreach ($f in $newDataFiles)
{
    Import-Excel -path $f.fullname | ConvertTo-DbaDataTable | Write-DbaDataTable @dbiParams -Table stagingUserLicensing
}
