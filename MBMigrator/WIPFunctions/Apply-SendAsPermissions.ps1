[cmdletbinding()]
Param(
    [switch]$Refresh
)

if ($Refresh)
{
    $SQL = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly
    $idbqp = @{
        Database    = 'Migration'
        SQLInstance = $SQL
    }
    $SAPerms = @(Invoke-DbaQuery @idbqp -Query "
    Select * FROM SendASPermsReal
    WHERE
        PermissionType = 'SendAS'
        AND AssignmentType = 'GroupMembership'
        AND ParentPermissionIdentity IS NULL
        AND TargetObjectExchangeGUID <> TrusteeExchangeGUID
    " -As PSObject)
}

<#

Select * FROM SendASPermsReal
WHERE
    PermissionType = 'SendAS'
    AND AssignmentType = 'GroupMembership'
    AND ParentPermissionIdentity IS NULL
    AND TargetObjectExchangeGUID <> TrusteeExchangeGUID


Select * FROM SendASPermsReal

WHERE
    PermissionType = 'SendAS'
    AND
    AssignmentType = 'Direct'

    AND TargetObjectExchangeGUID <> TrusteeExchangeGUID

Select * FROM SendASPermsReal
WHERE
    PermissionType = 'SendAS'
    AND AssignmentType = 'GroupMembership'
    AND ParentPermissionIdentity IS NULL
    AND TargetObjectExchangeGUID <> TrusteeExchangeGUID

#>
<#
    AND  (
        TrusteeExchangeGUID IN (Select ExchangeGUID FROM dbo.MigrationListStatic where AssignedWave = '8.2')
      OR
      TargetObjectExchangeGUID IN (Select ExchangeGUID FROM dbo.MigrationListStatic where AssignedWave = '8.2')
    )

#>

$xProgressID = Initialize-xProgress -ArrayToProcess $SAPerms -CalculatedProgressInterval 1Percent -Activity 'Setting SendAS Permissions'
foreach ($P in $SAPerms)
{
    Write-xProgress -Identity $xProgressID
    $AddRPermParams = @{
        AccessRights                         = $P.PermissionType
        Confirm                              = $False
        ErrorAction                          = 'Stop'
        WarningAction                        = 'SilentlyContinue'
        SkipDomainValidationForSharedMailbox = $true
        SkipDomainValidationForMailContact   = $true
        SkipDomainValidationForMailUser      = $true
    }
    switch ($null -eq $P.TrusteeExchangeGUID -or $P.TrusteeExchangeGUID -eq '00000000-0000-0000-0000-000000000000')
    {
        $true
        {
            $AddRPermParams.Trustee = $P.TrusteePrimarySMTPAddress
        }
        $False
        {
            $AddRPermParams.Trustee = $P.TrusteeExchangeGUID
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
        $null = Add-RecipientPermission @AddRPermParams
    }
    catch
    {
        Write-Information -Message $_.tostring()
        Write-Information -Message "Failed to Add $($AddRPermParams.AccessRights) Permission for Target $($AddRPermParams.Identity) to Trustee $($AddRPermParams.Trustee)"
    }
}
Complete-xProgress -Identity $xProgressID