#Requires -Version 5.1

$ModuleFolder = Split-Path $PSCommandPath -Parent

$Scripts = Join-Path -Path $ModuleFolder -ChildPath 'scripts'
$Functions = Join-Path -Path $ModuleFolder -ChildPath 'functions'
$SQLFolder = Join-Path -Path $ModuleFolder -ChildPath 'sql'

#Write-Information -MessageData "Scripts Path  = $Scripts" -InformationAction Continue
#Write-Information -MessageData "Functions Path  = $Functions" -InformationAction Continue
#Write-Information -MessageData "SQL Folder  = $SQLFolder" -InformationAction Continue

$Script:SQLFiles = @(
  $(Join-Path -Path $(Join-Path -Path $SQLFolder -ChildPath 'reports') -ChildPath 'PermissionCountByTrustee.sql')
  $(Join-Path -Path $(Join-Path -Path $SQLFolder -ChildPath 'reports') -ChildPath 'MigrationList.sql')
  $(Join-Path -Path $(Join-Path -Path $SQLFolder -ChildPath 'reports') -ChildPath 'MigrationWaveList.sql')
  $(Join-Path -Path $(Join-Path -Path $SQLFolder -ChildPath 'reports') -ChildPath 'MailboxList.sql')
  $(Join-Path -Path $(Join-Path -Path $SQLFolder -ChildPath 'reports') -ChildPath 'MissingRecipient.sql')
  $(Join-Path -Path $(Join-Path -Path $SQLFolder -ChildPath 'reports') -ChildPath 'MigrationListChanges.sql')
  $(Join-Path -Path $(Join-Path -Path $SQLFolder -ChildPath 'reports') -ChildPath 'MigrationListSummary.sql')
  $(Join-Path -Path $(Join-Path -Path $SQLFolder -ChildPath 'reports') -ChildPath 'DoubleMailbox.sql')
  $(Join-Path -Path $(Join-Path -Path $SQLFolder -ChildPath 'reports') -ChildPath 'DelegateAnalysis.sql')
  $(Join-Path -Path $(Join-Path -Path $SQLFolder -ChildPath 'reports') -ChildPath 'DelegateReport.sql')
)

$Script:ModuleFiles = @(
  $(Join-Path -Path $Scripts -ChildPath 'Initialize.ps1')
  # Load Functions
  $(Join-Path -Path $functions -ChildPath Complete-MBMWave.ps1)
  $(Join-Path -Path $functions -ChildPath Export-ADUser.ps1)
  $(Join-Path -Path $functions -ChildPath Export-AzureADUser.ps1)
  $(Join-Path -Path $functions -ChildPath Export-AzureADLicensing.ps1)
  $(Join-Path -Path $functions -ChildPath Export-AzureADUserLicensing.ps1)
  $(Join-Path -Path $functions -ChildPath Export-ExchangeConfiguration.ps1)
  $(Join-Path -Path $functions -ChildPath Export-ExchangeRecipient.ps1)
  $(Join-Path -Path $functions -ChildPath Export-ExchangeOPDLOwnership.ps1)
  $(Join-Path -Path $functions -ChildPath Export-ComplianceRetentionPolicy.ps1)
  $(Join-Path -Path $functions -ChildPath Export-ExchangeRetentionPolicy.ps1)
  $(Join-Path -Path $functions -ChildPath Export-MoveRequest.ps1)
  $(Join-Path -Path $functions -ChildPath Get-MBMMigrationList.ps1)
  $(Join-Path -Path $functions -ChildPath Get-MBMWaveMember.ps1)
  $(Join-Path -Path $functions -ChildPath Get-MBMWaveMissingMoveRequest.ps1)
  $(Join-Path -Path $functions -ChildPath Get-WaveMemberVariableValue.ps1)
  $(Join-Path -Path $functions -ChildPath Get-MBMWaveWrongMoveRequest.ps1)
  $(Join-Path -Path $functions -ChildPath Get-MBMWaveNonMemberMoveRequest.ps1)
  $(Join-Path -Path $functions -ChildPath Get-MBMWaveMoveRequest.ps1)
  $(Join-Path -Path $functions -ChildPath Get-MBMWaveMoveRequestStatistics.ps1)
  $(Join-Path -Path $functions -ChildPath Get-WaveMoveRequestVariableValue.ps1)
  $(Join-Path -Path $functions -ChildPath Get-WaveMoveRequestStatisticsVariableValue.ps1)
  $(Join-Path -Path $functions -ChildPath Get-MBMWaveUnassignedMoveRequest.ps1)
  $(Join-Path -Path $functions -ChildPath Get-MBMWaveRequestReport.ps1)
  $(Join-Path -Path $functions -ChildPath Get-MBMWaveRequestStatisticsReport.ps1)
  $(Join-Path -Path $functions -ChildPath Invoke-MBMWavePostMigrationProcess.ps1)
  $(Join-Path -Path $functions -ChildPath New-SplitArrayRange.ps1)
  $(Join-Path -Path $functions -ChildPath New-Timer.ps1)
  $(Join-Path -Path $functions -ChildPath Group-Join.ps1)
  $(Join-Path -Path $functions -ChildPath New-MBMWaveMoveRequest.ps1)
  $(Join-Path -Path $functions -ChildPath Remove-WaveDataGlobalVariable.ps1)
  $(Join-Path -Path $functions -ChildPath Send-OutlookMail.ps1)
  $(Join-Path -Path $functions -ChildPath Send-MBMWaveMessage.ps1)
  $(Join-Path -Path $functions -ChildPath Send-MBMWaveMoveRequestCompletedMessage.ps1)
  $(Join-Path -Path $functions -ChildPath Set-MBMMigratedCASMailbox.ps1)
  $(Join-Path -Path $functions -ChildPath Set-MBMMigratedMailboxDefaultPFM.ps1)
  $(Join-Path -Path $functions -ChildPath Set-MBMMigratedMailboxForwarding.ps1)
  $(Join-Path -Path $functions -ChildPath Set-MBMMigratedMailboxRetentionPolicy.ps1)
  $(Join-Path -Path $functions -ChildPath Set-MBMMigratedMailboxQuota.ps1)
  $(Join-Path -Path $functions -ChildPath Set-MBMMigratedMailboxSendReceive.ps1)
  $(Join-Path -Path $functions -ChildPath Switch-MBMWaveMoveRequestEndpoint.ps1)
  $(Join-Path -Path $functions -ChildPath Sync-MBMWaveMoveRequest.ps1)
  $(Join-Path -Path $functions -ChildPath Update-MBMRecipientData.ps1)
  $(Join-Path -Path $functions -ChildPath Update-MBMPermissionData.ps1)
  $(Join-Path -Path $functions -ChildPath Update-MBMDelegateAnalysis.ps1)
  $(Join-Path -Path $functions -ChildPath Get-SortableSizeValue.ps1)
  $(Join-Path -Path $functions -ChildPath Get-MBMColumnMap.ps1)
  $(Join-Path -Path $functions -ChildPath Get-MBMConfiguration.ps1)
  $(Join-Path -Path $functions -ChildPath Set-MBMConfiguration.ps1)
  $(Join-Path -Path $functions -ChildPath Update-MBMDatabaseSchema.ps1)
  $(Join-Path -Path $functions -ChildPath Export-MBMReport.ps1)
  $(Join-Path -Path $functions -ChildPath Update-MBMWavePlanning.ps1)
  $(Join-Path -Path $functions -ChildPath New-MBMReverseMoveRequest.ps1)
  $(Join-Path -Path $functions -ChildPath Export-MBMWaveMRSReport.ps1)
  $(Join-Path -Path $functions -ChildPath Update-MBMActiveDirectoryData.ps1)
  $(Join-Path -Path $functions -ChildPath Update-MBMDelegateAnalysis.ps1)
  $(Join-Path -Path $functions -ChildPath Start-ExchangeThreadJob.ps1)
  # Finalize / Run any Module Functions defined above
  $(Join-Path -Path $Scripts -ChildPath 'RunFunctions.ps1')
)
foreach ($f in $ModuleFiles)
{
  . $f
}