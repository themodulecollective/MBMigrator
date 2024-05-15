Remove-Item -Path 'C:\Program Files\PowerShell\7\Modules\MBMigrator' -Force -Recurse -Confirm:$false
Remove-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\MBMigrator' -Force -Recurse -Confirm:$false
Expand-Archive -Path E:\scripts\Project\MBMigrator.zip -DestinationPath 'C:\Program Files\PowerShell\7\Modules\' 
Expand-Archive -Path E:\scripts\Project\MBMigrator.zip -DestinationPath 'C:\Program Files\WindowsPowerShell\Modules\' 

Remove-Item -Path 'C:\Program Files\PowerShell\7\Modules\ExchangePermissionsExport' -Force -Recurse -Confirm:$false
Remove-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\ExchangePermissionsExport' -Force -Recurse -Confirm:$false
Expand-Archive -Path E:\scripts\Project\ExchangePermissionsExport.zip -DestinationPath 'C:\Program Files\PowerShell\7\Modules\' 
Expand-Archive -Path E:\scripts\Project\ExchangePermissionsExport.zip -DestinationPath 'C:\Program Files\WindowsPowerShell\Modules\' 

Remove-Item -Path 'C:\Program Files\PowerShell\7\Modules\xProgress' -Force -Recurse -Confirm:$false
Remove-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\xProgress' -Force -Recurse -Confirm:$false
Expand-Archive -Path E:\scripts\Project\xProgress.zip -DestinationPath 'C:\Program Files\PowerShell\7\Modules\' 
Expand-Archive -Path E:\scripts\Project\xProgress.zip -DestinationPath 'C:\Program Files\WindowsPowerShell\Modules\' 