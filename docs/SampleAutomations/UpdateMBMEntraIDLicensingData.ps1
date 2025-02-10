# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"
$ThisTask = Split-Path -Path $PSCommandPath -Leaf
Write-Log -Level INFO -Message "Task $ThisTask Imported Migration Manager Module and Configuration"

#Archive Old User Data
Write-Log -Level INFO -Message "Task $ThisTask Running: Archive Entra ID User Licensing Data"
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation EntraIDUserLicensingData -AgeInDays 30
Write-Log -Level INFO -Message "Task $ThisTask Completed: Archive Entra ID User Licensing Data"


$OutputFolderPath = $MBMConfiguration.EntraIDUserLicensingDataFolder
$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint
$MBMModulePath = $MBMConfiguration.MBMModulePath
$skuReadableFilePath = $MBMConfiguration.skuReadableFilePath

$tenants = @(
    @{
        TenantDomain = $MBMConfiguration.SourceTenantDomain
        TenantID = $MBMConfiguration.SourceTenantID
        AppID = $MBMConfiguration.SourceTenantReportingAppID
        sku = $MBMConfiguration.SourceTenantRelevantSKUs
        ServicePlan = $MBMConfiguration.SourceTenantRelevantServicePlans
    }
    @{
        TenantDomain = $MBMConfiguration.TargetTenantDomain
        TenantID = $MBMConfiguration.TargetTenantID
        AppID = $MBMConfiguration.TargetTenantReportingAppID
        sku = $MBMConfiguration.TargetTenantRelevantSKUs
        ServicePlan = $MBMConfiguration.TargetTenantRelevantServicePlans
    }
)

Write-Log -Level INFO -Message "Task $ThisTask Running: Start Jobs Export EntraID User Licensing for Tenants $($tenants.TenantDomain -join ' | ')"

$Jobs = @(
    foreach ($t in $tenants) {
        start-sleep -Seconds 5
        $AppID = $t.AppID
        $TenantID = $t.TenantID
        $sku = $t.sku
        $ServicePlan = $t.ServicePlan
        
        Start-Job -Name "Export $($t.TenantDomain) EntraID User Licensing" -ScriptBlock { 
            Import-Module $Using:MBMModulePath
            Import-Module OGraph
            $null = Connect-OGgraph -TenantID $using:TenantID -ApplicationID $using:AppID -CertificateThumbprint $Using:CertificateThumbprint
            Export-EntraIDUserLicensing -OutputFolderPath $Using:OutputFolderPath -sku $Using:sku -ServicePlan $using:ServicePlan -skuReadableFilePath $using:skuReadableFilePath
        } 
    }
)

Write-Log -Level INFO -Message "Task $ThisTask Waiting: for Jobs $($Jobs.Name -join ',')"
Wait-Job -Job $Jobs
Write-Log -Level INFO -Message "Task $ThisTask Completed: Jobs $($Jobs.name -join ',')"

Write-Log -Level INFO -Message "Task $ThisTask Getting Newly Exported Files from $OutputFolderPath"
$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *UserLicensingAsOf*.xlsx)

#Truncate the Table Data
$dbiParams = @{
    SQLInstance = $MBMConfiguration.SQLInstance
    Database = $MBMConfiguration.Database
}

Write-Log -Level INFO -Message "Task $ThisTask Running: Truncate stagingUserLicensing Table"
#Invoke-DbaQuery @dbiParams -File E:\MBMigration\sql\UpdateHistoryMailboxMigrationList.sql
Invoke-DbaQuery @dbiParams -Query 'TRUNCATE TABLE dbo.stagingUserLicensing'
Write-Log -Level INFO -Message "Task $ThisTask Completed: Truncate stagingUserLicensing Table"

Write-Log -Message "Task $ThisTask Running: Import/Convert/Write: Operation: EntraID User Licensing: with Entra ID Licensing Data from $($newDataFiles.fullname -join ';')" -Level INFO
foreach ($f in $newDataFiles)
{
    Import-Excel -path $f.fullname | ConvertTo-DbaDataTable | Write-DbaDataTable @dbiParams -Table stagingUserLicensing
} 
Write-Log -Message "Task $ThisTask Completed: Import/Convert/Write: Operation: EntraID User Licensing: with Entra ID Licensing Data from $($newDataFiles.fullname -join ';')" -Level INFO

Wait-Logging