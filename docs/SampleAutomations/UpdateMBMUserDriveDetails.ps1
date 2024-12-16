# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"
$ThisTask = Split-Path -Path $PSCommandPath -Leaf
Write-Log -Level INFO -Message "Task $ThisTask Imported Migration Manager Module and Configuration"

#Archive Old User Data
Write-Log -Level INFO -Message "Task $ThisTask Running: Archive User Drive Details Data"
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation UserDriveDetailsData -AgeInDays 30
Write-Log -Level INFO -Message "Task $ThisTask Completed: Archive User Drive Details Data"

$OutputFolderPath = $MBMConfiguration.UserDriveDetailsDataFolder
$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint
$MBMModulePath = $MBMConfiguration.MBMModulePath

$tenants = @(
    @{
        TenantDomain = $MBMConfiguration.SourceTenantDomain
        TenantID = $MBMConfiguration.SourceTenantID
        AppID = $MBMConfiguration.SourceTenantReportingAppID
        AdminURL = $MBMConfiguration.SourceTenantSPOAdmin
    }
    @{
        TenantDomain = $MBMConfiguration.TargetTenantDomain
        TenantID = $MBMConfiguration.TargetTenantID
        AppID = $MBMConfiguration.TargetTenantReportingAppID
        AdminURL = $MBMConfiguration.TargetTenantSPOAdmin
    }
)

Write-Log -Level INFO -Message "Task $ThisTask Running: Start Jobs Export EntraID Users for Tenants $($tenants.TenantDomain -join ' | ')"

$Jobs = @(
    foreach ($t in $tenants) {
        $AppID = $t.AppID
        $TenantID = $t.TenantID
        $AdminURL = $t.AdminURL
        $TenantDomain = $t.TenantDomain
        Start-Job -Name "Export $($t.TenantDomain) User OneDrive Usage" -ScriptBlock { # thread job doesn't work for isolating the graph modules
            Import-Module $Using:MBMModulePath
            Import-Module PnP.PowerShell
            Connect-PnPOnline -Url $using:AdminURL -ClientId $using:AppID -Tenant $using:TenantDomain -Thumbprint $Using:CertificateThumbprint
            Export-PNPUserDriveDetail -OutputFolderPath $using:OutputFolderPath 
        } 
    }
)

Write-Log -Level INFO -Message "Task $ThisTask Waiting: for Jobs $($Jobs.Name -join ',')"
Wait-Job -Job $Jobs
Write-Log -Level INFO -Message "Task $ThisTask Completed: Jobs $($Jobs.name -join ',')"

Write-Log -Level INFO -Message "Task $ThisTask Getting Newly Exported Files from $OutputFolderPath"
$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *UserDriveDetailsAsOf*.xlsx)

Write-Log -Message "Task $ThisTask Running: Update-MBMFromExcelFile: Operation: UserDriveDetail: with Drive Detail from $($newDataFiles.fullname -join ';')" -Level INFO

Update-MBMFromExcelFile -Operation UserDriveDetail -FilePath $newDataFiles.fullname -InformationAction Continue -Truncate

Write-Log -Message "Task $ThisTask Completed: Update-MBMFromExcelFile: Operation: UserDriveDetail: with Drive Detail from $($newDataFiles.fullname -join ';')" -Level INFO

Wait-Logging