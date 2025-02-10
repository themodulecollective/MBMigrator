# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"
Write-Log -Level INFO -Message "Migration Manager Module and Configuration Imported by Archive AD Data task"

#Archive Old Recipient Data
Write-Log -Level INFO -Message "Run: Archive Data for AD User Data"
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation ADUserData -AgeInDays 20
Write-Log -Level INFO -Message "Completed: Archive Data for AD User Data"
Write-Log -Level INFO -Message "Run: Archive Data for AD Group Data"
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation ADGroupData -AgeInDays 20
Write-Log -Level INFO -Message "Completed: Archive Data for AD Group Data"
Write-Log -Level INFO -Message "Run: Archive Data for AD Computer Data"
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation ADComputerData -AgeInDays 20
Write-Log -Level INFO -Message "Completed: Archive Data for AD Computer Data"