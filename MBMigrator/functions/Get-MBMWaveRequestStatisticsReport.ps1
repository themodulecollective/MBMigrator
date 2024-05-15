function Get-MBMWaveRequestStatisticsReport {
    <#
    .SYNOPSIS
        Reports the statistics for the current wave requests
    .DESCRIPTION
        Used for monitoring wave request completion. Provides statics on the wave request including TotalMailboxItems, how many itmes have transferred, details on failures, and percent complete.
    .EXAMPLE
        Get-MBMWaveRequestStatisticsReport -Wave "1.1" -Repeat -RepeatSeconds 60
        Gets the current wave request statistics for wave 1.1 every minute
    #>

    [CmdletBinding()]
    param(
        #
        $Wave
        ,
        #
        [switch]$UseStoredStatistics
        ,
        #
        [parameter()]
        [ValidateSet('Progress', 'Failures', 'ProgressDetail')]
        [string[]]$Operation
        ,
        #
        [switch]$Repeat
        ,
        #
        [Int16]$RepeatSeconds
    )

    do {
        switch ($UseStoredStatistics) {
            $true
            {}
            $false {
                Get-MBMWaveMoveRequestStatistics -Wave $Wave -Global -Operation RefreshInProgress -InformationAction Continue
            }
        }

        $MRS = Get-WaveMoveRequestStatisticsVariableValue -Wave $wave

        switch ($Operation) {
            'Progress' {
                $InProgressProperties = @(
                    'BatchName'
                    'ExchangeGUID'
                    'Alias'
                    'TotalMailboxItemCount'
                    'ItemsTransferred'
                    @{n = 'TotalMailboxSizeInGB'; e = { get-SortableSizeValue -Value $_.TotalMailboxSize -Scale GB } }
                    @{n = 'GBTransferred'; e = { get-SortableSizeValue -Value $_.BytesTransferred -Scale GB } }
                    @{n = 'MBTransferredPerMinute'; e = {
                            $s = $_
                            switch ($s.Status.Value) {
                                'InProgress'
                                { get-SortableSizeValue -Value $s.BytesTransferredPerMinute -Scale MB }
                                { $_ -in @('AutoSuspended', 'Completed', 'CompletedWithWarning', 'CompletedWithWarnings') }
                                { [math]::round($(get-SortableSizeValue -Value $s.BytesTransferred -Scale MB) / $s.TotalInProgressDuration.TotalMinutes, 0) }
                            }
                        }
                    }
                    @{n = 'InProgressDurationHours'; e = { [math]::round($_.TotalInProgressDuration.TotalHours, 1) } }
                    @{n = 'OverallDurationDays'; e = { [math]::round($_.OverallDuration.TotalDays, 1) } }
                    @{n = 'Status'; e = { $_.Status.Value } }
                    @{n = 'StatusDetail'; e = { $_.StatusDetail.Value } }
                    'PercentComplete'
                    'SuspendWhenReadyToComplete'
                    'StartTimeStamp'
                    'InitialSeedingCompletedTimestamp'
                    'DisplayName'
                    'LargeItemsEncountered'
                    'MissingItemsEncountered'
                    'BadItemsEncountered'
                    'SyncStage'
                )
                $MRSP = $MRS | Select-Object -Property $InProgressProperties

                $Report = [PSCustomObject]@{
                    ReportTimeStamp         = Get-Date -Format 'yyyy-MM-dd hh:mm:ss'
                    Wave                    = $Wave
                    MoveRequestCount        = $MRSP.Count
                    WaveMemberCount         = @(Get-WaveMemberVariableValue -Wave $Wave).Count
                    StatusSummary           = @($mrsp | Group-Object -NoElement -Property Status | Select-Object -Property Name, Count)
                    SyncStage               = @($mrsp | Group-Object -NoElement -Property SyncStage | Select-Object -Property Name, Count)
                    TotalMailboxItems       = $mrsp | Measure-Object -Property TotalMailboxItemCount -Sum -Average -Maximum -Minimum
                    ItemsTransferred        = $mrsp | Measure-Object -Property ItemsTransferred -Sum -Average -Maximum -Minimum
                    TotalMailboxSizeInGB    = $mrsp | Measure-Object -Property TotalMailboxSizeInGB -Sum -Average -Maximum -Minimum
                    GBTransferred           = $mrsp | Measure-Object -Property GBTransferred -Sum -Average -Maximum -Minimum
                    MBTransferredPerMinute  = $mrsp | Measure-Object -Property MBTransferredPerMinute -Average -Maximum -Minimum
                    PercentComplete         = $mrsp | Measure-Object -Property PercentComplete -Average -Maximum -Minimum
                    LargeItemsEncountered   = $mrsp | Measure-Object -Property LargeItemsEncountered -Sum -Average -Maximum -Minimum
                    MissingItemsEncountered = $mrsp | Measure-Object -Property MissingItemsEncountered -Sum -Average -Maximum -Minimum
                    BadItemsEncountered     = $mrsp | Measure-Object -Property BadItemsEncountered -Sum -Average -Maximum -Minimum
                }

                $StatusSummaryHash = [ordered]@{'Status' = 'Summary' }
                $Report.StatusSummary.foreach({
                        $StatusSummaryHash.$($_.Name) = $($_.Count)
                    })
                $SyncStageHash = [ordered]@{'SyncStage' = 'Summary' }
                $Report.SyncStage.foreach({
                        $SyncStageHash.$($_.Name) = $($_.Count)
                    })

                $PercentCompleteProperties = @(
                    @{n = 'PercentComplete'; e = { 'Summary' } }
                    @{n = 'OverallAverage'; e = { [math]::Round($Report.PercentComplete.Average, 1) } }
                    @{n = 'Maximum'; e = { $Report.PercentComplete.Maximum } }
                    @{n = 'Minimum'; e = { $Report.PercentComplete.Minimum } }
                )
                $ItemsProperties = @(
                    @{n = 'Items'; e = { 'Summary' } }
                    @{n = 'AverageItems'; e = { [math]::Round($Report.TotalMailboxItems.Average, 0) } }
                    @{n = 'MaximumItems'; e = { $Report.TotalMailboxItems.Maximum } }
                    @{n = 'TotalItems'; e = { $Report.TotalMailboxItems.Sum } }
                    @{n = 'ItemsTransferred'; e = { $Report.ItemsTransferred.Sum } }
                    @{n = 'ProblematicItems'; e = { $Report.LargeItemsEncountered.Sum + $Report.BadItemsEncountered.Sum + $Report.MissingItemsEncountered.Sum } }
                )
                $DataTransferProperties = @(
                    @{n = 'DataTransfer'; e = { 'Summary' } }
                    @{n = 'TotalMailboxSizeInGB'; e = { $Report.TotalMailboxSizeInGB.Sum } }
                    @{n = 'GBTransferred'; e = { $Report.GBTransferred.Sum } }
                    @{n = 'SizeToTransferRatio'; e = { [math]::round($($Report.GBTransferred.Sum / $Report.TotalMailboxSizeInGB.Sum), 1) } }
                    @{n = 'MBTransferredPerMinute'; e = { [math]::round($Report.MBTransferredPerMinute.Average, 1) } }
                )

                $Report | Format-Table -AutoSize -Property ReportTimeStamp, Wave, MoveRequestCount, WaveMemberCount
                New-Object -Property $StatusSummaryHash -TypeName PSObject | Format-Table -AutoSize
                #New-Object -Property $SyncStageHash -TypeName PSObject | Format-Table -AutoSize
                $Report | Select-Object -Property $PercentCompleteProperties | Format-Table -AutoSize
                $Report | Select-Object -Property $ItemsProperties | Format-Table -AutoSize
                $Report | Select-Object -Property $DataTransferProperties | Format-Table -AutoSize
            }
            'ProgressDetail' {
                $MRSP.where({ $_.Status -eq 'InProgress' }) | Select-Object BatchName, Alias, SyncStage, StatusDetail, PercentComplete, MBTransferredPerMinute | Sort-Object -Property SyncStage,StatusDetail,Alias | Format-Table -AutoSize
            }
            'Failures' {
                $FailureProperties = @(
                    'BatchName'
                    'ExchangeGUID'
                    'Alias'
                    'TotalMailboxItemCount'
                    'ItemsTransferred'
                    @{n = 'TotalMailboxSizeInGB'; e = { get-SortableSizeValue -Value $_.TotalMailboxSize -Scale GB } }
                    @{n = 'GBTransferred'; e = { get-SortableSizeValue -Value $_.BytesTransferred -Scale GB } }
                    @{n = 'MBTransferredPerMinute'; e = {
                            $s = $_
                            switch ($s.Status.Value) {
                                'InProgress'
                                { get-SortableSizeValue -Value $s.BytesTransferredPerMinute -Scale MB }
                                { $_ -in @('AutoSuspended', 'Completed', 'CompletedWithWarning', 'CompletedWithWarnings') }
                                { [math]::round($(get-SortableSizeValue -Value $s.BytesTransferred -Scale MB) / $s.TotalInProgressDuration.TotalMinutes, 0) }
                            }
                        }
                    }
                    @{n = 'InProgressDurationHours'; e = { [math]::round($_.TotalInProgressDuration.TotalHours, 1) } }
                    @{n = 'OverallDurationDays'; e = { [math]::round($_.OverallDuration.TotalDays, 1) } }
                    @{n = 'Status'; e = { $_.Status.Value } }
                    @{n = 'StatusDetail'; e = { $_.StatusDetail.Value } }
                    'SyncStage'
                    'PercentComplete'
                    'SuspendWhenReadyToComplete'
                    'StartTimeStamp'
                    'InitialSeedingCompletedTimestamp'
                    'DisplayName'
                    'LargeItemsEncountered'
                    'MissingItemsEncountered'
                    'BadItemsEncountered'
                    'FailureCode'
                    'FailureSide'
                    'FailureType'
                    'LastFailure'
                    'TotalFailedDuration'
                    'TotalTransientFailureDuration'
                )
                $MRSF = $MRS.where({ $_.Status.value -like '*fail*' -or $_.StatusDetail.value -like '*fail*' }) | Select-Object -Property $FailureProperties

                $Report = [PSCustomObject]@{
                    ReportTimeStamp          = Get-Date -Format 'yyyy-MM-dd hh:mm:ss'
                    Wave                     = $Wave
                    FailureMoveRequestsCount = $MRSF.Count
                    WaveMemberCount          = @(Get-WaveMemberVariableValue -Wave $Wave).Count
                    StatusSummary            = $MRSF | Group-Object -NoElement -Property Status | Select-Object -Property Name, Count
                    SyncStage                = $MRSF | Group-Object -NoElement -Property SyncStage | Select-Object -Property Name, Count
                    TotalMailboxItems        = $MRSF | Measure-Object -Property TotalMailboxItemCount -Sum -Average -Maximum -Minimum
                    ItemsTransferred         = $MRSF | Measure-Object -Property ItemsTransferred -Sum -Average -Maximum -Minimum
                    TotalMailboxSizeInGB     = $MRSF | Measure-Object -Property TotalMailboxSizeInGB -Sum -Average -Maximum -Minimum
                    GBTransferred            = $MRSF | Measure-Object -Property GBTransferred -Sum -Average -Maximum -Minimum
                    MBTransferredPerMinute   = $MRSF | Measure-Object -Property MBTransferredPerMinute -Average -Maximum -Minimum
                    PercentComplete          = $MRSF | Measure-Object -Property PercentComplete -Average -Maximum -Minimum
                    LargeItemsEncountered    = $MRSF | Measure-Object -Property LargeItemsEncountered -Sum -Average -Maximum -Minimum
                    MissingItemsEncountered  = $MRSF | Measure-Object -Property MissingItemsEncountered -Sum -Average -Maximum -Minimum
                    BadItemsEncountered      = $MRSF | Measure-Object -Property BadItemsEncountered -Sum -Average -Maximum -Minimum
                    FailureCode              = $MRSF.FailureCode -join ';'
                    FailureSide              = $MRSF.FailureSide -join ';'
                    FailureType              = $MRSF.FailureType -join ';'
                    LastFailure              = $MRSF.LastFailure -join ';'
                }

                $StatusSummaryHash = [ordered]@{'Status' = 'Summary' }
                $Report.StatusSummary.foreach({
                        $StatusSummaryHash.$($_.Name) = $($_.Count)
                    })
                $SyncStageHash = [ordered]@{'SyncStage' = 'Summary' }
                $Report.SyncStage.foreach({
                        $SyncStageHash.$($_.Name) = $($_.Count)
                    })

                $PercentCompleteProperties = @(
                    @{n = 'PercentComplete'; e = { 'Summary' } }
                    @{n = 'OverallAverage'; e = { [math]::Round($Report.PercentComplete.Average, 1) } }
                    @{n = 'Maximum'; e = { $Report.PercentComplete.Maximum } }
                    @{n = 'Minimum'; e = { $Report.PercentComplete.Minimum } }
                )
                $ItemsProperties = @(
                    @{n = 'Items'; e = { 'Summary' } }
                    @{n = 'AverageItems'; e = { [math]::Round($Report.TotalMailboxItems.Average, 0) } }
                    @{n = 'MaximumItems'; e = { $Report.TotalMailboxItems.Maximum } }
                    @{n = 'TotalItems'; e = { $Report.TotalMailboxItems.Sum } }
                    @{n = 'ItemsTransferred'; e = { $Report.ItemsTransferred.Sum } }
                    @{n = 'ProblematicItems'; e = { $Report.LargeItemsEncountered.Sum + $Report.BadItemsEncountered.Sum + $Report.MissingItemsEncountered.Sum } }
                )
                $DataTransferProperties = @(
                    @{n = 'DataTransfer'; e = { 'Summary' } }
                    @{n = 'TotalMailboxSizeInGB'; e = { $Report.TotalMailboxSizeInGB.Sum } }
                    @{n = 'GBTransferred'; e = { $Report.GBTransferred.Sum } }
                    @{n = 'SizeToTransferRatio'; e = { [math]::round($($Report.GBTransferred.Sum / $Report.TotalMailboxSizeInGB.Sum), 1) } }
                    @{n = 'MBTransferredPerMinute'; e = { [math]::round($Report.MBTransferredPerMinute.Average, 1) } }
                )

                $FailureDetailProperties = @(
                    'BatchName'
                    'ExchangeGUID'
                    'Alias'
                    'LargeItemsEncountered'
                    'MissingItemsEncountered'
                    'BadItemsEncountered'
                    'FailureCode'
                    'FailureSide'
                    'FailureType'
                    'LastFailure'
                    'TotalFailedDuration'
                    'TotalTransientFailureDuration'
                )

                $Report | Format-Table -AutoSize -Property ReportTimeStamp, Wave, MoveRequestCount, WaveMemberCount
                New-Object -Property $StatusSummaryHash -TypeName PSObject | Format-Table -AutoSize
                #New-Object -Property $SyncStageHash -TypeName PSObject | Format-Table -AutoSize
                $Report | Select-Object -Property $PercentCompleteProperties | Format-Table -AutoSize
                $Report | Select-Object -Property $ItemsProperties | Format-Table -AutoSize
                $Report | Select-Object -Property $DataTransferProperties | Format-Table -AutoSize
                $MRSF | Select-Object -Property $FailureDetailProperties | Format-Table -AutoSize
            }
        }
        if ($Repeat) {
            Write-Information -InformationAction Continue -MessageData "Sleeping for $RepeatSeconds Seconds"
            New-Timer -showprogress -units Seconds -length $RepeatSeconds -Frequency 5
        }
    }
    until (-not $Repeat)

}