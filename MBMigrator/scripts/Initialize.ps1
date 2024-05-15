#Requires -Version 5.1
###############################################################################################
# Module Variables
###############################################################################################
$ModuleVariableNames = ('MBMigratorConfiguration', 'SQLScripts', 'MRSInProgressProperties', 'MRSFailureProperties')
$ModuleVariableNames.ForEach( { Set-Variable -Scope Script -Name $_ -Value $null })
# enum InstallManager { Chocolatey; Git; PowerShellGet; Manual; WinGet }

$MRSInProgressProperties = @(
  'BatchName'
  'ExchangeGUID'
  'Alias'
  'TotalMailboxItemCount'
  'ItemsTransferred'
  @{n = 'TotalMailboxSizeInGB'; e = { get-SortableSizeValue -Value $_.TotalMailboxSize -Scale GB } }
  @{n = 'GBTransferred'; e = { get-SortableSizeValue -Value $_.BytesTransferred -Scale GB } }
  @{n = 'MBTransferredPerMinute'; e = {
      $s = $_
      switch ($s.Status.Value)
      {
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
$MRSFailureProperties = @(
  'BatchName'
  'ExchangeGUID'
  'Alias'
  'TotalMailboxItemCount'
  'ItemsTransferred'
  @{n = 'TotalMailboxSizeInGB'; e = { get-SortableSizeValue -Value $_.TotalMailboxSize -Scale GB } }
  @{n = 'GBTransferred'; e = { get-SortableSizeValue -Value $_.BytesTransferred -Scale GB } }
  @{n = 'MBTransferredPerMinute'; e = {
      $s = $_
      switch ($s.Status.Value)
      {
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
  'AliaseedingCompletedTimestamp'
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

$SQLScripts = @{}

foreach ($s in $SQLFiles)
{
  $item = Get-Item -Path $s
  $key = $item.BaseName
  $SQLScripts.$key = $(Get-Content -Path $item.FullName -Raw)
}

###############################################################################################
# Module Removal
###############################################################################################
#Clean up objects that will exist in the Global Scope due to no fault of our own . . . like PSSessions

$OnRemoveScript = {
  # perform cleanup
  Write-Verbose -Message 'Removing Module Items from Global Scope'
  Remove-WaveDataGlobalVariable
}

$ExecutionContext.SessionState.Module.OnRemove += $OnRemoveScript
