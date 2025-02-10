[CmdletBinding()]
param(
    [parameter(Mandatory)]
    [ValidateSet('UpdateVolDateFields','UpdateMigrationStatus')]
    [string[]]$Operation
)

# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"
$ThisTask = Split-Path -Path $PSCommandPath -Leaf
Write-Log -Level INFO -Message "Task $ThisTask Imported Migration Manager Module and Configuration"
Write-Log -Level INFO -Message "Task $ThisTask Running: $Operation"


switch ($Operation)
{
    'UpdateVolDateFields'
    {
        $UpdateFields = 'SourceEntraLastSyncTime','TargetEntraLastSyncTime','SourceEntraLastSigninTime','TargetEntraLastSigninTime'
        # running this in the job to avoid pnp and graph conflict
        #$job = Start-Job -FilePath "C:\Migration\Scripts\UpdateMBMEntraIDUserData.ps1" -Name 'Update Entra ID User Data' 
        Write-Log -Level INFO -Message "Task $ThisTask Running: Update MBM Entra ID User Data"
        pwsh.exe -noninteractive -file "C:\Migration\Scripts\UpdateMBMEntraIDUserData.ps1"
        Write-Log -Level INFO -Message "Task $ThisTask Completed: Update MBM Entra ID User Data"
        Write-Log -Level INFO -Message "Task $ThisTask Running: Connect to Wave Planning Site via Connect-PnPOnline"
        Connect-PnPOnline -Url $MBMConfiguration.WavePlanningSiteURL -ClientId $MBMConfiguration.TargetTenantReportingAppID -Tenant $MBMConfiguration.TargetTenantDomain -Thumbprint $MBMConfiguration.CertificateThumbprint
        Write-Log -Level INFO -Message "Task $ThisTask Completed: Connect to Wave Planning Site via Connect-PnPOnline"        
        Write-Log -Level INFO -Message "Task $ThisTask Running: List Synchronization with operations: Update Database Items and Update SharePoint Items"
        Write-Log -Level INFO -Message "Task $ThisTask Information: Fields to Update $($UpdateFields -join ' | ')"
        . C:\Migration\Scripts\ListSyncronization.ps1  -FieldSet CustomFields -CustomFields $UpdateFields -UpdateSharePointItems -UpdateDatabaseItems
        Write-Log -Level INFO -Message "Task $ThisTask Completed: List Synchronization with operations: Update Database Items and Update SharePoint Items"
    }
    'UpdateMigrationStatus'
    {
        $UpdateFields = @('MigrationStatus')
        Write-Log -Level INFO -Message "Task $ThisTask Running: Update MBM MigrationStatus Per User"
        Write-Log -Level INFO -Message "Task $ThisTask Running: Connect to Wave Planning Site via Connect-PnPOnline"
        Connect-PnPOnline -Url $MBMConfiguration.WavePlanningSiteURL -ClientId $MBMConfiguration.TargetTenantReportingAppID -Tenant $MBMConfiguration.TargetTenantDomain -Thumbprint $MBMConfiguration.CertificateThumbprint
        Write-Log -Level INFO -Message "Task $ThisTask Completed: Connect to Wave Planning Site via Connect-PnPOnline"        
        Write-Log -Level INFO -Message "Task $ThisTask Running: List Synchronization with operations: UpdateSharePointItems and FieldSet = MigrationStatus"
        Write-Log -Level INFO -Message "Task $ThisTask Information: Fields to Update $($UpdateFields -join ' | ')"
        . C:\Migration\Scripts\ListSyncronization.ps1 -FieldSet MigrationStatus -UpdateSharePointItems
        Write-Log -Level INFO -Message "Task $ThisTask Completed: List Synchronization with operations: UpdateSharePointItems and FieldSet = MigrationStatus"
    }
}

Write-Log -Level INFO -Message "Task $ThisTask Completed: $Operation"