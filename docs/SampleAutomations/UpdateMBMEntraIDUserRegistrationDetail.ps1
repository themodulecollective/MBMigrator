[cmdletbinding()]
param(
    [parameter(Mandatory)]
    [validateset('Source','Target')]
    [string[]]$TenantType
)

# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"
$ThisTask = Split-Path -Path $PSCommandPath -Leaf
Write-Log -Level INFO -Message "Task $ThisTask Imported Migration Manager Module and Configuration"

#Archive Old User Data
Write-Log -Level INFO -Message "Task $ThisTask Running: Archive Related Data"
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation EntraUserRegistrationData -AgeInDays 20
Write-Log -Level INFO -Message "Task $ThisTask Completed: Archive Related Data"


$OutputFolderPath = $MBMConfiguration.EntraUserRegistrationDataFolder
$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint
$MBMModulePath = $MBMConfiguration.MBMModulePath

$tenants = @(switch ($TenantType)
{
    'Source'
    {
        @{
            TenantDomain = $MBMConfiguration.SourceTenantDomain
            TenantID = $MBMConfiguration.SourceTenantID
            AppID = $MBMConfiguration.SourceTenantReportingAppID
        }
    }
    'Target'
    {
        @{
            TenantDomain = $MBMConfiguration.TargetTenantDomain
            TenantID = $MBMConfiguration.TargetTenantID
            AppID = $MBMConfiguration.TargetTenantReportingAppID
        }
    }
})

Write-Log -Level INFO -Message "Task $ThisTask Running: Start Jobs for Tenant $($tenants.TenantDomain -join ' | ')"

$Jobs = @(
    foreach ($t in $tenants) {
        $AppID = $t.AppID
        $TenantID = $t.TenantID
        $TenantDomain = $t.TenantDomain
    
            try {
                Start-Job -Name "Export $TenantDomain User Registration Detail" -ErrorAction Stop -ScriptBlock { 
                    Import-Module $Using:MBMModulePath
                    Import-Module OGraph
                    $null = Connect-OGgraph -TenantID $using:TenantID -ApplicationID $using:AppID -CertificateThumbprint $Using:CertificateThumbprint -ErrorAction Stop
                    $properties = 'ID','UserPrincipalName','UserType','isAdmin','isSsprRegistered','isSsprEnabled','isSsprCapable','isMfaRegistered','isMfaCapable','isPasswordlessCapable',@{n='methodsRegistered';e={$_.methodsRegistered -join ' | '}},'isSystemPreferredAuthenticationMethodEnabled',@{n='systemPreferredAuthenticationMethods';e={$_.systemPreferredAuthenticationMethods -join ' | '}},'userPreferredMethodForSecondaryAuthentication',@{n='TenantDomain';e={$using:TenantDomain}},'lastUpdatedDateTime'
                    Get-OGUserRegistrationDetail -All | Select-Object -Property $properties
                }
            }
            catch {
                Write-Log -Level WARNING -Message "Task ThisTask Failed: Export $TenantDomain User Registration Detail"
                Write-Log -Level WARNING -Message $_.ToString()
            }

        }
)

Write-Log -Level INFO -Message "Task $ThisTask Waiting: for Jobs $($Jobs.Name -join ',')"
Wait-Job -Job $Jobs
Write-Log -Level INFO -Message "Task $ThisTask Completed: Jobs $($Jobs.name -join ',')"

$DateString = Get-Date -Format yyyyMMddhhmmss
$OutputFileName = 'UserRegistrationDetailAsOf' + $DateString + '.xlsx'
$outputFilePath = Join-Path -Path $OutputFolderPath -ChildPath $OutputFileName
$exportExcelParams = @{
    path = $outputFilePath
    Autosize = $true
    WorksheetName = 'UserRegistrationDetail'
    TableName = 'UserRegistrationdetail'
    TableStyle = 'Medium5'
    FreezeTopRow = $true
}

$properties = 'ID','UserPrincipalName','UserType','isAdmin','isSsprRegistered','isSsprEnabled','isSsprCapable','isMfaRegistered','isMfaCapable','isPasswordlessCapable','methodsRegistered','isSystemPreferredAuthenticationMethodEnabled','systemPreferredAuthenticationMethods','userPreferredMethodForSecondaryAuthentication','TenantDomain','lastUpdatedDateTime'

Write-Log -Level INFO -Message "Task $ThisTask Running: Export Jobs Results to $outputfilepath"
$Members = @($Jobs | Receive-Job)
$Members | Select-Object -Property $Properties  | Export-Excel @exportExcelParams
Write-Log -Level INFO -Message "Task $ThisTask Completed: Export Jobs Results to $outputfilepath"

#Truncate the Table Data
$dbiParams = @{
    SQLInstance = $MBMConfiguration.SQLInstance
    Database = $MBMConfiguration.Database
}

#Write-Log -Level INFO -Message "Task $ThisTask Running: Truncate stagingMigrationGroupMember Table"
#Invoke-DbaQuery @dbiParams -Query 'TRUNCATE TABLE dbo.stagingMigrationGroupMember'
#Write-Log -Level INFO -Message "Task $ThisTask Completed: Truncate stagingMigrationGroupMember Table"

Write-Log -Message "Task $ThisTask Running: Import/Convert/Write: UserRegistrationdetail" -Level INFO
$Members | Select-Object -Property $Properties | ConvertTo-DbaDataTable | Write-DbaDataTable @dbiParams -Table stagingUserRegistrationDetail -Truncate 
Write-Log -Message "Task $ThisTask Completed: Import/Convert/Write: UserRegistrationdetail" -Level INFO

Wait-Logging