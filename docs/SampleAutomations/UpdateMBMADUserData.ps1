# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"
$ThisTask = Split-Path -Path $PSCommandPath -Leaf
Write-Log -Level INFO -Message "Task $ThisTask Imported Migration Manager Module and Configuration"

$OutputFolderPath = $MBMConfiguration.ADUserDataFolder
Write-Log -Level INFO -Message "Task $ThisTask Getting Newly Exported Files from $OutputFolderPath"
$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *ADUsersAsOf*.xml)
Write-Log -Message "Task $ThisTask Running: Update Database with AD Users from $($newDataFiles.fullname -join ';')" -Level INFO
Update-MBMActiveDirectoryData -Operation ADUser -FilePath $newDataFiles -InformationAction Continue -Truncate
Write-Log -Level INFO -Message "Task $ThisTask Completed: Update Database with AD Users from $($newDataFiles.fullname -join ';')"
Wait-Logging