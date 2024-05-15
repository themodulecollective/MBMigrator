$Properties = @(
    'BatchName'
    'Alias'
    'TotalMailboxItemCount'
    @{n='TotalMailboxSizeInGB';e={get-SortableSizeValue -Value $_.TotalMailboxSize -Scale GB}}
    @{n='GBTransferred';e={get-SortableSizeValue -Value $_.BytesTransferred -Scale GB}}
    @{n='MBTransferredPerMinute';e={[math]::round($(get-SortableSizeValue -Value $_.BytesTransferred -Scale MB)/$_.TotalInProgressDuration.TotalMinutes,0)}}
    @{n='InProgressDurationHours';e={[math]::round($_.TotalInProgressDuration.TotalHours,1)}}
    @{n='OverallDurationDays';e={[math]::round($_.OverallDuration.TotalDays,1)}}
    #@{n='Status';e = {$_.Status.Value}}
    @{n='StatusDetail';e = {$_.StatusDetail.Value}}
    #'PercentComplete'
    #'SuspendWhenReadyToComplete'
    'StartTimeStamp'
    'CompletionTimeStamp'
    'DisplayName'
)