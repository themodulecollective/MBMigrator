# Create Move Requests

## update WavePlanning data

- Copy the latest WavePlanning.xlsx file to the Migration Server InputFiles folder
- Update the MBM Database by running the following:

```Powershell
Update-MBMWavePlanning -InputFolderPath '[InputFiles folder where WavePlanning.xlsx was copied]' -InformationAction continue
```

## update Migration Lists and Reports

```Powershell

# Remove previous versions of the following reports before exporting
Export-MBMReport -compoundReport MigrationList -OutputFolderPath e:\MBMigration\Reports
# Wave Specific File
Export-MBMReport -Report MigrationWaveList -ReportParams @{AssignedWave = 2.1} -OutputFolderPath E:\MBMigration\Reports
```

## setup

```Powershell
# load the on premises credential
Connect-ExchangeOnline
Get-MBMMigrationList -Global
```

## Initiating Migration Wave Move Request

```Powershell
$Wave = '2.1'
Get-MBMWaveMember -Wave $Wave -Global
$nWMRParams = @{
    ExchangeCredential = $MBMConfiguration.OnPremCredential
    Endpoint = $MBMConfiguration.Endpoint
    TargetDeliveryDomain = $MBMConfiguration.TargetDeliveryDomain
    InformationAction = 'Continue'
    Wave = $Wave
}
New-MBMWaveMoveRequest @nWMRParams
```

## Re-Attempt Any Failed Move Requests for the wave

```Powershell
# This re-attempts move request creation only for
New-MBMWaveMoveRequest @nWMRParams -Missing

# Variations:
# Sometimes it helps to use the Alias instead of ExchangeGUID
New-MBMWaveMoveRequest @nWMRParams -Missing -UseAlias
# Sometimes you need to include the Archive.  This can work if there is an archive, or if the -PrimaryOnly switch is failing for other reasons related to the archive attributes (you'll see this in the error output from Exchange Online)
New-MBMWaveMoveRequest @nWMRParams -Missing -IncludeArchive
```