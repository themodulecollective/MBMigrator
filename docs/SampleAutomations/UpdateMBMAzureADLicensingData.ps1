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

Export-AzureADUserLicensing -Sku '1c27243e-fb4d-42b1-ae8c-fe25c9616588','05e9a617-0261-4cee-bb44-138d3ef5d965' -ServicePlan '9974d6cf-cd24-4ba2-921c-e2aa687da846','efb87545-963c-4e0d-99df-69c6916d9eb0','c1ec4a95-1f05-45b3-a911-aa3fa01094f5','57ff2da0-773e-42df-b2af-ffb7a2317929' -OutputFolderPath F:\LicensingData

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
