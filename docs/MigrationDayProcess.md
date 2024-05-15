# Migration Day Process

## Simplified

### setup

Prepare 3 PowerShell consoles using the following procedure
``` PowerShell

. MBM\SetupShell.ps1
$OPCred = Get-Credential -UserName [On Premises Exchange Credential] -Message 'OPExchangeAccess'
Connect-ExchangeOnline -UserPrincipalName [Exchange Online UPN]
Get-MBMMigrationList -Global
$Wave = [current wave]
```

### Initiating Migration Wave Completions

``` Powershell
#This will take a while to complete (often up to or over an hour)
Complete-MBMWave -Wave $Wave
```
### Monitoring Completion Progress

```Powershell
# In one PS Console
Get-MBMWaveRequestReport -Wave $Wave -Repeat -RepeatSeconds 30
# In another PS Console
Get-MBMWaveRequestStatisticsReport -Wave $wave -Repeat -RepeatSeconds 30 -Operation Progress,ProgressDetail
```

## Sending Communication Emails If Required

- [ ] If sending communications emails, get latest Messages folder and contents from it's source in the customer environment
- [ ] Start Outlook with an outlook profile connected to a customer mailbox with an identity that has SendAS rights for the migration communiction mailbox(es).
- [ ] Start a Windows Powershell 5.1 instance that is NOT elevated

```Powershell
Connect-ExchangeOnline -UserPrincipalName [your tenant admin UPN] -ShowProgress $true
Get-MBMMigrationList -Global
Get-MBMWaveMember -Global -Wave $Wave
Get-MBMWaveMoveRequest -Global -Wave $Wave
```

# Synchronization of Move Requests

Usually about 48 hours prior to Migration cutover

```Powershell
Sync-MigrationWaveMoveRequest -Wave [Wave Number like '5.2']
```


## Cutover Tasks

### About 5 minutes before cutover

- [ ] In the non-elevated Windows Powershell 5.1 run:

```Powershell

Invoke-MBMWavePostMigrationProcess -wave [Wave Number like '5.2'] -SleepSeconds 60 -Operation DisplayStatus,MaaS360,CompletionMessage -MessageRepositoryDirectoryPath [Path to the Messages directory if sending messages] -WavePlanningFilePath [Path to WavePlanning.xlsx if sending messages]
```

### At Cutover

```Powershell
#This will take a while to complete (often up to or over an hour)
Complete-MBMWave -Wave [Wave Number like '5.2']
```