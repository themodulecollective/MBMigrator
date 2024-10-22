function Update-MBMDelegateAnalysis {
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
        [string[]]$exemptWaves
        ,
        [switch]$Reset #resets back to production Wave Exceptions
    )

    Write-Information -MessageData 'Getting MBM Configuration'
    $Configuration = Get-MBMConfiguration
    $dbiParams = @{
        SQLInstance = $Configuration.SQLInstance
        Database    = $Configuration.Database
    }

    if ($Reset) {
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
staticMigrationListv
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

    $woa = @(
        foreach ($m in $MailboxesToReview) {
            Write-Information -MessageData "Processing $($m.Name) $($m.ExchangeGUID)"
            $Max = 0
            $RWave = $m.AssignedWave
            $MConnections = @($ConnectionsHash.$($m.ExchangeGUID))
            #$MConnections = @($Connections.where({$_.Recipient -eq $M.ExchangeGUID}))
            $MConnections.foreach( {
                    if ($_.ConnectionCount -gt $Max -and -not [string]::isnullorwhitespace($_.AssignedWave)) {
                        #-gt will yield the first (earliest), -ge will yield the last (latest) wave
                        $RWave = $_.AssignedWave
                        $Max = $_.ConnectionCount
                    }
                })

            $Report = [ordered]@{
                Name               = $m.Name
                PrimarySMTPAddress = $m.PrimarySMTPAddress
                ExchangeGUID       = $m.ExchangeGUID
                RecipientTypeDetails = $m.RecipientTypeDetails
                ChangeWave = $null
                CurrentWave        = $m.AssignedWave
                RecommendedWave    = $RWave
            }
            foreach ($w in $AssignedWaves.AssignedWave) {
                switch ($null -eq $w) {
                    $true {
                        $Report.'NotAssigned' = $($MConnections.where( { $null -eq $_.AssignedWave }).ConnectionCount)
                    }
                    $false {
                        $Report.$w = $($MConnections.where( { $_.AssignedWave -eq $w }).ConnectionCount)
                    }
                }

            }
            $Report.ChangeWave = $Report.CurrentWave -ne $Report.RecommendedWave
            New-Object -Property $Report -TypeName PSCustomObject
        })

    $WOATable = Get-DbaDbTable @dbiParams -Table 'WOA' -ErrorAction Continue

    if ($WOATable) {
        Invoke-DbaQuery @dbiParams -Query 'DROP TABLE WOA'
    }

    $woa | ConvertTo-DbaDataTable | Write-DbaDataTable @dbiParams -Table 'WOA' -AutoCreateTable

}