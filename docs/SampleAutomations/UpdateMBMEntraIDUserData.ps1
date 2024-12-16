# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"
$ThisTask = Split-Path -Path $PSCommandPath -Leaf
Write-Log -Level INFO -Message "Task $ThisTask Imported Migration Manager Module and Configuration"

Write-Log -Level INFO -Message "Task $ThisTask Running: Archive Entra ID User Data"

#Archive Old User Data
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation EntraIDUserData -AgeInDays 30

Write-Log -Level INFO -Message "Task $ThisTask Completed: Archive Entra ID User Data"

$OutputFolderPath = $MBMConfiguration.EntraIDUserDataFolder
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

Write-Log -Level INFO -Message "Task $ThisTask Running: Start Jobs Export EntraID Users for Tenants $($tenants.TenantDomain -join ' | ')"

$Jobs = @(
    foreach ($t in $tenants) {
        $AppID = $t.AppID
        $TenantID = $t.TenantID
        Start-Job -Name "Export $($t.TenantDomain) EntraID Users" -ScriptBlock { # thread job doesn't work for isolating the graph modules
            Import-Module $Using:MBMModulePath
            Import-Module OGraph
            Connect-OGgraph -TenantID $using:TenantID -ApplicationID $using:AppID -CertificateThumbprint $Using:CertificateThumbprint
            Export-EntraIDUser -OutputFolderPath $Using:OutputFolderPath -InformationAction Continue
        } 
    }
)

Write-Log -Level INFO -Message "Task $ThisTask Waiting: for Jobs $($Jobs.Name -join ',')"
Wait-Job -Job $Jobs
Write-Log -Level INFO -Message "Task $ThisTask Completed: Jobs $($Jobs.name -join ',')"

Write-Log -Level INFO -Message "Task $ThisTask Getting Newly Exported Files from $OutputFolderPath"
$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *EntraIDUsersAsOf*.xml)
Write-Log -Message "Task $ThisTask Running: Update-MBMActiveDirectoryData: Operation: EntraIDUser: with Entra ID Users from $($newDataFiles.fullname -join ';')" -Level INFO
Update-MBMActiveDirectoryData -Operation EntraIDUser -FilePath $newDataFiles.fullname -InformationAction Continue -Truncate 
Write-Log -Message "Task $ThisTask Completed: Update-MBMActiveDirectoryData: Operation: EntraIDUser: with Entra ID Users from $($newDataFiles.fullname -join ';')" -Level INFO

Wait-Logging