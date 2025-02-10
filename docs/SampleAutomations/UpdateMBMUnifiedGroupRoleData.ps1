# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"
$ThisTask = Split-Path -Path $PSCommandPath -Leaf
Write-Log -Level INFO -Message "Task $ThisTask Imported Migration Manager Module and Configuration"

Write-Log -Level INFO -Message "Task $ThisTask Running: Archive Unified Group Role Data"

#Archive Old User Data
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation UnifiedGroupRoleData -AgeInDays 30

Write-Log -Level INFO -Message "Task $ThisTask Completed: Archive Unified Group Role Data"

$OutputFolderPath = $MBMConfiguration.UnifiedGroupRoleDataFolder
$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint
$MBMModulePath = $MBMConfiguration.MBMModulePath
#$SPMModulePath = $MBMConfiguration.SPMModulePath

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

Write-Log -Level INFO -Message "Task $ThisTask Running: Start Jobs Export EntraID Users for Tenants $($tenants.TenantDomain -join ' | ')"

$Jobs = @(
    foreach ($t in $tenants) {
        $AppID = $t.AppID
        $TenantID = $t.TenantID
        Start-Job -Name "Export $($t.TenantDomain) Unified Group Role Holders" -ScriptBlock { 
            Import-Module $Using:MBMModulePath
            #Import-Module $using:SPMModulePath
            Import-Module OGraph
            Connect-OGgraph -TenantID $using:TenantID -ApplicationID $using:AppID -CertificateThumbprint $Using:CertificateThumbprint
            Export-UnifiedGroupRoleHolder -OutputFolderPath $Using:OutputFolderPath
        } 
    }
)

Write-Log -Level INFO -Message "Task $ThisTask Waiting: for Jobs $($Jobs.Name -join ',')"
Wait-Job -Job $Jobs
Write-Log -Level INFO -Message "Task $ThisTask Completed: Jobs $($Jobs.name -join ',')"

Write-Log -Level INFO -Message "Task $ThisTask Getting Newly Exported Files from $OutputFolderPath"
$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *-UnifiedGroupRoleHoldersAsOf*.xlsx)

Write-Log -Message "Task $ThisTask Running: Update-MBMFromExcelFile: Operation: UnifiedGroupRoleHolder: with Unified Group Roles from $($newDataFiles.fullname -join ';')" -Level INFO

Update-MBMFromExcelFile -Operation UnifiedGroupRoleHolder -FilePath $newDataFiles -Truncate

Write-Log -Message "Task $ThisTask Completed: Update-MBMFromExcelFile: Operation: UnifiedGroupRoleHolder: with Unified Group Roles from $($newDataFiles.fullname -join ';')" -Level INFO

Wait-Logging