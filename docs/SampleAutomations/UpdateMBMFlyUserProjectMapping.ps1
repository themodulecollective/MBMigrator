[cmdletbinding()]
param(
)

# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"
$ThisTask = Split-Path -Path $PSCommandPath -Leaf
Write-Log -Level INFO -Message "Task $ThisTask Imported Migration Manager Module and Configuration"

#Archive Old User Data
Write-Log -Level INFO -Message "Task $ThisTask Running: Archive Related Data"
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation FlyUserProjectMappingData -AgeInDays 20
Write-Log -Level INFO -Message "Task $ThisTask Completed: Archive Related Data"


$OutputFolderPath = $MBMConfiguration.FlyUserProjectMappingDataFolder
#$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint
$MBMModulePath = $MBMConfiguration.MBMModulePath
$RealFlyModulePath = $MBMConfiguration.RealFlyModulePath


Write-Log -Level INFO -Message "Task $ThisTask Running: Start Job for Fly Service: $($MBMConfiguration.FlyApiURL)"

$Jobs = @(
    $FlyApiURL = $MBMConfiguration.FlyApiURL
    $FlyApiApplicationID = $MBMConfiguration.FlyApiApplicationID
    $CertificatePFXFile = $MBMConfiguration.CertificatePFXFile

    try {
        Start-Job -Name "Export Fly User Project Mapping" -ErrorAction Stop -ScriptBlock { 
            Import-Module $Using:MBMModulePath
            Import-Module Fly.Client
            Import-Module $using:RealFlyModulePath
            connect-fly -Url $Using:FlyApiURL -ClientId $Using:FlyApiApplicationID -Certificate $Using:CertificatePFXFile
            Set-RFConfig -UpdateTokenTime
            # . C:\Migration\Scripts\GetFlyUserProjectMapping.ps1
            $Projects = Get-FlyProjects -top 100 | Select-Object -ExpandProperty Data
            $Projects.foreach({Get-RFUserMapping -projectid $_.id; Start-Sleep -Seconds 2})
        }
    }
    catch {
        Write-Log -Level WARNING -Message "Task ThisTask Failed: Start Job for Fly Service: $($MBMConfiguration.FlyApiURL)"
        Write-Log -Level WARNING -Message $_.ToString()
    }
)

Write-Log -Level INFO -Message "Task $ThisTask Waiting: for Jobs $($Jobs.Name -join ',')"
Wait-Job -Job $Jobs
Write-Log -Level INFO -Message "Task $ThisTask Completed: Jobs $($Jobs.name -join ',')"

$DateString = Get-Date -Format yyyyMMddhhmmss
$OutputFileName = 'FlyUserProjectMappingAsOf' + $DateString + '.xlsx'
$outputFilePath = Join-Path -Path $OutputFolderPath -ChildPath $OutputFileName
$exportExcelParams = @{
    path = $outputFilePath
    Autosize = $true
    WorksheetName = 'FlyUserProjectMapping'
    TableName = 'FlyUserProjectMapping'
    TableStyle = 'Medium5'
    FreezeTopRow = $true
}

Write-Log -Level INFO -Message "Task $ThisTask Running: Export Jobs Results to $outputfilepath"
$Members = @($Jobs | Receive-Job)
$Members | Select-Object -Property * -ExcludeProperty PSComputerName,RunspaceID,PSShowComputerName | Export-Excel @exportExcelParams
Write-Log -Level INFO -Message "Task $ThisTask Completed: Export Jobs Results to $outputfilepath"

#Truncate the Table Data
$dbiParams = @{
    SQLInstance = $MBMConfiguration.SQLInstance
    Database = $MBMConfiguration.Database
}

Write-Log -Message "Task $ThisTask Running: Import/Convert/Write: FlyUserProjectMapping" -Level INFO
$Members | Select-Object -Property * -ExcludeProperty PSComputerName,RunspaceID,PSShowComputerName | ConvertTo-DbaDataTable | Write-DbaDataTable @dbiParams -Table stagingFlyUserProjectMapping -Truncate -AutoCreateTable
Write-Log -Message "Task $ThisTask Completed: Import/Convert/Write: FlyUserProjectMapping" -Level INFO

Wait-Logging