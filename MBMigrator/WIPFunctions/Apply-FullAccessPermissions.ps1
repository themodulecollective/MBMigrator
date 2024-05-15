[cmdletbinding()]
Param(
    [switch]$Refresh
)

$SQL = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
$idbqp = @{
    Database    = 'Migration'
    SQLInstance = $SQL
}
$FAPerms = @(Invoke-DbaQuery @idbqp -Query "Select * FROM MailboxPermsReal
WHERE
    PermissionType = 'FullAccess'
    AND
    AssignmentType = 'Direct'
    AND  (
        TrusteeExchangeGUID IN
        (Select ExchangeGUID FROM dbo.MailboxMigrationListStatic where AssignedWave IN ('1.1', '1.2', '2.1', '2.2', '3.1', '3.2', '4.1', '4.2', '5.1', '5.2', '6.1', '6.2', '7.1', '7.2', '8.1', '8.2', '9.1','9.2'))
        OR
        TargetObjectExchangeGUID IN
        (Select ExchangeGUID FROM dbo.MailboxMigrationListStatic where AssignedWave IN ('1.1', '1.2', '2.1', '2.2', '3.1', '3.2', '4.1', '4.2', '5.1', '5.2', '6.1', '6.2', '7.1', '7.2', '8.1', '8.2', '9.1','9.2'))
      )
    AND TargetObjectExchangeGUID <> TrusteeExchangeGUID" -As PSObject)


foreach ($P in $FAPerms)
{
    $AddRPermParams = @{
        AccessRights  = $P.PermissionType
        Confirm       = $False
        ErrorAction   = 'Stop'
        WarningAction = 'SilentlyContinue'
        #InformationAction = 'Continue'
        Automapping   = $true
    }
    switch ($null -eq $P.TrusteeExchangeGUID -or $P.TrusteeExchangeGUID -eq '00000000-0000-0000-0000-000000000000')
    {
        $true
        {
            $AddRPermParams.User = $P.TrusteePrimarySMTPAddress
        }
        $False
        {
            $AddRPermParams.User = $P.TrusteeExchangeGUID
        }

    }
    switch ($null -eq $P.TargetObjectExchangeGUID -or $P.TargetObjectExchangeGUID -eq '00000000-0000-0000-0000-000000000000')
    {
        $true
        {
            $AddRPermParams.Identity = $P.TargetPrimarySMTPAddress
        }
        $False
        {
            $AddRPermParams.Identity = $P.TargetObjectExchangeGUID
        }
    }

    try
    {
        $null = Add-MailboxPermission @AddRPermParams
    }
    catch
    {
        Write-Information -Message $_.tostring()
        Write-Information -Message "Failed to Add $($AddRPermParams.AccessRights) Permission for Target $($AddRPermParams.Identity) to Trustee $($AddRPermParams.User)"
    }
}
