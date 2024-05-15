if ($null -eq $SQL)
{
    $SQL = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcred -Database Migration -SqlConnectionOnly
}
$idbqp = @{
    Database    = 'Migration'
    SQLInstance = $SQL
}
Invoke-DbaQuery @idbqp -Query "Select * FROM dbo.ApplyPerms"