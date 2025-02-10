
$fmaParams = @{
    file = 'FlyMappingAdds.sql'
    as = 'Psobject'
}

$FlyMappingAdds = Invoke-DbaQuery @idbParams @fmaParams


$fmcParams = @{
    file = 'FlyMappingChanges.sql'
    as = 'psobject'
}

$FlymappingChanges = Invoke-DbaQuery @idbParams @fmcParams

$DateString = Get-Date -Format yyyyMMddhhmmss

$exportExcelParams = @{
    Path = 'C:\Migration\Data\MigrationList\FlyMappingUpdateASOf' + $DateString + '.xlsx'
    WorksheetName = 'Adds'
    TableName = 'Adds'
    TableStyle = 'Medium18'
    FreezeTopRow = $true
    AutoSize = $true
}

$FlyMappingAdds | export-excel @exportExcelParams

$exportExcelParams.TableName = 'Changes'
$exportExcelParams.WorksheetName = 'Changes'

$FlymappingChanges | Export-Excel @exportExcelParams

Invoke-DbaQuery @idbParams -File 'FlyMappingAddsUpdate.sql'
Invoke-DbaQuery @idbParams -File 'FlyMappingChangesUpdate.sql'