# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"
$ThisTask = Split-Path -Path $PSCommandPath -Leaf
Write-Log -Level INFO -Message "Task $ThisTask Imported Migration Manager Module and Configuration"


#Archive Old User Data
Write-Log -Level INFO -Message "Task $ThisTask Running: Archive Related Data"
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation MailboxStatsData -AgeInDays 30
Write-Log -Level INFO -Message "Task $ThisTask Completed: Archive Related Data"

$OutputFolderPath = $MBMConfiguration.MailboxStatsDataFolder
$MBMModulePath = $MBMConfiguration.MBMModulePath
$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint

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

Write-Log -Level INFO -Message "Task $ThisTask Running: Start Jobs for Tenant $($tenants.TenantDomain -join ' | ')"

$Jobs = @(
    foreach ($t in $tenants) {
        $Organization = $t.TenantDomain
        $AppID = $t.AppID
        Write-Log -Level INFO -Message "Task ThisTask Running: Start Job to Export $Organization Mailbox Statistics"
        try {
            Start-Job -Name ExportOnlineMailboxData -ScriptBlock {
                Import-Module $Using:MBMModulePath
                Import-Module ExchangeOnlineManagement
                Connect-ExchangeOnline -Organization $using:Organization -AppID $using:AppID -CertificateThumbprint $using:CertificateThumbprint
                Export-ExchangeRecipient -InformationAction Continue -Operation MailboxStatistics -OutputFolderPath $using:OutputFolderPath -UseEXOCmdlet
            } 
            Write-Log -Level INFO -Message "Task ThisTask Completed: Start Job to Export $Organization Mailbox Statistics"
        }
        catch {
            Write-Log -Level WARNING -Message "Task ThisTask Failed: Start Job to Export $Organization Mailbox Statistics"
            Write-Log -Level WARNING -Message $_.ToString()
        }
    }
)

Write-Log -Level INFO -Message "Task $ThisTask Waiting: for Jobs $($Jobs.Name -join ',')"
Wait-Job -Job $Jobs
Write-Log -Level INFO -Message "Task $ThisTask Completed: Jobs $($Jobs.name -join ',')"

#Truncate the Table Data
$dbiParams = @{
    SQLInstance = $MBMConfiguration.SQLInstance
    Database = $MBMConfiguration.Database
}

Write-Log -Level INFO -Message "Task $ThisTask Running: Truncate SQL Table staginMailboxStats"
Invoke-DbaQuery @dbiParams -Query  'TRUNCATE TABLE dbo.stagingMailboxStats' -ErrorAction Stop
Write-Log -Level INFO -Message "Task $ThisTask Completed: Truncate SQL Table staginMailboxStats"

$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *ExchangeRecipientsAsOf*.xml)
Write-Log -Level INFO -Message "Task $ThisTask Running: Process New Data Files: $($newDataFiles.fullname -join ' | ')"
foreach ($f in $newDataFiles)
{
	Update-MBMRecipientData -Operation MailboxStatistics -FilePath $f.fullname -InformationAction Continue #-Truncate
}
Write-Log -Level INFO -Message "Task $ThisTask Completed: Process New Data Files: $($newDataFiles.fullname -join ' | ')"

Wait-Logging