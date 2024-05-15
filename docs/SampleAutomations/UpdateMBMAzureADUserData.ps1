# Import MBM Module and Configuration
. "E:\Automations\MBMConfiguration.ps1"

#Archive Old Recipient Data
. "E:\Automations\ArchiveData.ps1" -Operation AzureADUserData -AgeInDays 15

$OutputFolderPath = $MBMConfiguration.AzureADUserDataExportFolder
$MBMModulePath = $MBMConfiguration.MBMModulePath
$Organization = $MBMConfiguration.TenantDomain
$TenantID = $MBMConfiguration.TenantID
$AppID = $MBMConfiguration.ReportingAppID
$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint

Connect-OGgraph -TenantID $TenantID -ApplicationID $AppID -CertificateThumbprint $CertificateThumbprint

Export-AzureADUser -OutputFolderPath $OutputFolderPath

#$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *ADUsersAsOf*.xml)

<# 
#Truncate the Table Data
$dbiParams = @{
    SQLInstance = $MBMConfiguration.SQLInstance
    Database = $MBMConfiguration.Database
}

Invoke-DbaQuery @dbiParams -Query 'TRUNCATE TABLE dbo.stagingADUser'

foreach ($f in $newDataFiles)
{
    Update-MBMActiveDirectoryData -Operation ADUser -FilePath $f.fullname -InformationAction Continue
}
 #>