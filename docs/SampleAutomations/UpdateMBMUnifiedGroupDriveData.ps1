# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"

#Archive Old User Data
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation UnifiedGroupDriveData -AgeInDays 30

$OutputFolderPath = $MBMConfiguration.UnifiedGroupDriveDataFolder
$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint
$MBMModulePath = $MBMConfiguration.MBMModulePath
$SPMModulePath = $MBMConfiguration.SPMModulePath

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
        Start-Job -Name "Export $($t.TenantDomain) Unified Group Drives" -ScriptBlock { 
            Import-Module $Using:MBMModulePath
            #Import-Module $using:SPMModulePath
            Import-Module OGraph
            Connect-OGgraph -TenantID $using:TenantID -ApplicationID $using:AppID -CertificateThumbprint $Using:CertificateThumbprint
            Export-UnifiedGroupDrive -OutputFolderPath $Using:OutputFolderPath
        } 
    }
)

Wait-Job -Job $Jobs

$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *-UnifiedGroupDrivesAsOf*.xlsx)

