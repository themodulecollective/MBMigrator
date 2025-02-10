$sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
$MigrationList = Invoke-DbaQuery -SqlInstance $sql -Database Migration -Query 'select * from dbo.MigrationList' -As PsObject

$Path = 'C:\Users\MikeCampbell\GitRepos\MigrationTracking\MigrationList.xlsx'

Remove-Item -Path $Path -Force -Confirm:$False

$ExportExcelParams = @{
    Path          = $Path
    FreezeTopRow  = $true
    AutoFilter    = $true
    ClearSheet    = $true
    WorksheetName = 'MailboxWaveAssignments'
    TableStyle    = 'Medium20'
    PassThru      = $true
}
$Pivot1Params = @{
    PivotTableName  = 'WaveAssignmentSummary'
    PivotRows       = 'AssignedWave'
    PivotData       = @{'ExchangeGUID' = 'COUNT' }
    PivotFilter     = 'RecipientTypeDetails', 'ExchangeOrg'
    SourceWorksheet = 'MailboxWaveAssignments'
}
$Pivot2Params = @{
    PivotTableName  = 'MigrationStatus'
    PivotRows       = 'Migrated'
    PivotData       = @{'ExchangeGUID' = 'COUNT' }
    PivotFilter     = 'RecipientTypeDetails', 'ExchangeOrg'
    SourceWorksheet = 'MailboxWaveAssignments'
}

$MMLExcel = $MigrationList | Export-Excel @ExportExcelParams
Add-PivotTable @Pivot1Params -ExcelPackage $MMLExcel
Add-PivotTable @Pivot2Params -ExcelPackage $MMLExcel
Close-ExcelPackage -ExcelPackage $MMLExcel