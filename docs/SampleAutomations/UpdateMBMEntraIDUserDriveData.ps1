$Host.UI.RawUI.WindowTitle = "Update MBM User Drive Data"

# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"

#Archive Old User Data
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation EntraIDUserDriveData -AgeInDays 30

$OutputFolderPath = $MBMConfiguration.EntraIDUserDriveDataFolder
$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint
$MBMModulePath = $MBMConfiguration.MBMModulePath

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
        $AppID = $t.AppID
        $TenantID = $t.TenantID
        Start-Job -Name "Export $($t.TenantDomain) EntraID User Drives" -ScriptBlock { 
            Import-Module $Using:MBMModulePath
            Import-Module OGraph
            Connect-OGgraph -TenantID $using:TenantID -ApplicationID $using:AppID -CertificateThumbprint $Using:CertificateThumbprint
            Export-EntraIDUserDrive -OutputFolderPath $Using:OutputFolderPath -SuppressErrors
        } 
    }
)

Wait-Job -Job $Jobs



$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *UserDrivesAsOf*.xlsx)
Update-MBMFromExcelFile -Operation UserDrive -FilePath $newDataFiles.fullname -InformationAction Continue -Truncate

