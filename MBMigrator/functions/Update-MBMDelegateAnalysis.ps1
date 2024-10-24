function Update-MBMDelegateAnalysis
{
    <#
    .SYNOPSIS
        Recommends best wave for mailboxes based on delegate access
    .DESCRIPTION
        Recommends best wave for mailboxes based on delegate access
    .EXAMPLE
        Update-MBMDelegateAnalysis
        Recommends best wave for mailboxes based on delegate access
    #>
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        [validateset('PreferFirstWave', 'PreferLastWave')]
        [string]$Optimization
        ,
        [switch]$Reset #resets back to production Wave Exceptions
        ,
        [parameter()]
        [validateset('SharedMailbox', 'RoomMailbox', 'EqupmentMailbox', 'UserMailbox')]
        [string[]]$RecipientType
        ,
        [parameter()]
        [string[]]$ExcludeWaveFromRecommended
    )

    Write-Information -MessageData 'Getting MBM Configuration'
    $Configuration = Get-MBMConfiguration
    $dbiParams = @{
        SQLInstance = $Configuration.SQLInstance
        Database    = $Configuration.Database
    }

    if ($Reset)
    {
        Write-Information -MessageData 'Reset specified. Truncating and updated WOAWaveExceptions'
        Copy-DbaDbTableData @dbiParams -Table WaveExceptions -DestinationTable WOAWaveExceptions -Truncate
    }

    #$MailboxesToReviewQuery = 'SELECT DISTINCT Name,PrimarySMTPAddress,ExchangeGUID,RecipientTypeDetails,AssignedWave FROM [dbo].[viewWOAMigrationList]'
    $MailboxesToReviewQuery = 'SELECT DISTINCT SourceDisplayName,SourceMail,SourceEntraID,SourceRecipientType,AssignedWave FROM staticMigrationList'
    $MailboxesToReview = Invoke-DbaQuery @dbiParams -Query $MailboxesToReviewQuery -As PSObject
    $AssignedWavesQuery =
    @'
SELECT
AssignedWave
FROM
staticMigrationList
GROUP BY
AssignedWave
ORDER BY AssignedWave
'@
    $AssignedWaves = Invoke-DbaQuery @dbiParams -Query $AssignedWavesQuery -As PSObject

    $ConnectionsQuery = @'
SELECT [Recipient]
      ,[AssignedWave]
      ,[ConnectionCount]
  FROM [dbo].[viewRecipientConnectionsPerAssignedWave]
'@

    $Connections = Invoke-DbaQuery @dbiParams -Query $ConnectionsQuery -As PSObject
    $ConnectionsHash = $Connections | Group-Object -Property Recipient -AsHashTable

    switch ([string]::IsNullOrEmpty($RecipientType))
    {
        $false
        { $MailboxesToReview = @($MailboxesToReview.where({ $_.SourceRecipientType -in $RecipientType })) }
    }

    $woa = @(
        foreach ($m in $MailboxesToReview)
        {
            Write-Information -MessageData "Processing $($m.SourceMail) $($m.SourceEntraID)"
            $Max = 0
            $RWave = $m.AssignedWave
            $MConnections = @($ConnectionsHash.$($m.SourceEntraID))
            #$MConnections = @($Connections.where({$_.Recipient -eq $M.ExchangeGUID}))
            $MConnections.foreach( {
                    $c = $_
                    #-gt will yield the first (earliest), -ge will yield the last (latest) wave
                    switch ([string]$($c.AssignedWave) -in $ExcludeWaveFromRecommended)
                    {
                        $true
                        {}
                        $false
                        {
                            switch ($Optimization)
                            {
                                'PreferFirstWave'
                                {
                                    if ($c.ConnectionCount -gt $Max -and -not [string]::isnullorwhitespace($c.AssignedWave))
                                    {
                                        $RWave = $c.AssignedWave
                                        $Max = $c.ConnectionCount
                                    }
                                }
                                'PreferLastWave'
                                {
                                    if ($_.ConnectionCount -ge $Max -and -not [string]::isnullorwhitespace($c.AssignedWave))
                                    {
                                        $RWave = $c.AssignedWave
                                        $Max = $c.ConnectionCount
                                    }
                                }
                            }
                        }
                    }
                })

            $Report = [ordered]@{
                Name                 = $m.SourceDisplayName
                PrimarySMTPAddress   = $m.SourceMail
                EntraID              = $m.SourceEntraID
                RecipientTypeDetails = $m.SourceRecipientType
                ChangeWave           = $null
                CurrentWave          = $m.AssignedWave
                RecommendedWave      = $RWave
            }
            foreach ($w in $AssignedWaves.AssignedWave)
            {
                switch ($null -eq $w)
                {
                    $true
                    {
                        $Report.'NotAssigned' = $($MConnections.where( { $null -eq $_.AssignedWave }).ConnectionCount)
                    }
                    $false
                    {
                        $Report.$w = $($MConnections.where( { $_.AssignedWave -eq $w }).ConnectionCount)
                    }
                }

            }
            $Report.ChangeWave = $Report.CurrentWave -ne $Report.RecommendedWave
            New-Object -Property $Report -TypeName PSCustomObject
        })

    $WOATable = Get-DbaDbTable @dbiParams -Table 'WOA' -ErrorAction Continue

    if ($WOATable)
    {
        Invoke-DbaQuery @dbiParams -Query 'DROP TABLE WOA'
    }

    $woa | ConvertTo-DbaDataTable | Write-DbaDataTable @dbiParams -Table 'WOA' -AutoCreateTable

}