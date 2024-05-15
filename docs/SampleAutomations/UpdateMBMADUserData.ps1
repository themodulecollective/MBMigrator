# Import MBM Module and Configuration
. "E:\Automations\MBMConfiguration.ps1"

#Archive Old Recipient Data
. "E:\Automations\ArchiveData.ps1" -Operation ADUserData -AgeInDays 15

Import-Module ActiveDirectory

$OutputFolderPath = $MBMConfiguration.ADUserDataExportFolder
$MBMModulePath = $MBMConfiguration.MBMModulePath
$Organization = $MBMConfiguration.TenantDomain
$AppID = $MBMConfiguration.ReportingAppID
$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint

Export-ADUser -OutputFolderPath $OutputFolderPath -Domain $MBMConfiguration.ADUserDomain -Exchange:$true

$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *ADUsersAsOf*.xml)

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
