$sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
$MailboxMigrationList = Invoke-DbaQuery -SqlInstance $sql -Database Migration -Query 'select * from dbo.MailboxMigrationList' -As PsObject

$Path = 'C:\Users\MikeCampbell\GitRepos\MigrationTracking\MailboxMigrationList.xlsx'

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

$MMLExcel = $MailboxMigrationList | Export-Excel @ExportExcelParams
Add-PivotTable @Pivot1Params -ExcelPackage $MMLExcel
Add-PivotTable @Pivot2Params -ExcelPackage $MMLExcel
Close-ExcelPackage -ExcelPackage $MMLExcel