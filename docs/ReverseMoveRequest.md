# Reverse Move Request Process

### Setup

- [ ] Obtain list of valid identifiers for mailboxes to be reverse moved
- [ ] Start 2 Powershell instances (one will be for operations that send email through outlook or for troubleshooting)
- [ ] In each Powershell, load the MBMigrator module and configure the database connection
    ```Powershell
    Import-Module MBMigrator
    Set-MBMConfiguration -Attribute SQLInstance -value 'server\instance'
    Set-MBMConfiguration -Attribute Database -value 'databasename'
    Set-MBMConfiguration -Attribute MigrationEndpoint -value 'fqdn of migration endpoint'
    Set-MBMConfiguration -Attribute TargetDeliveryDomain -value 'fqdn of organization specific mail.onmicrosoft.com routing domain'
    Set-MBMConfiguration -Attribute RemoteTargetDatabase -value 'on premises database name'
    #quotas may need to be set to unlimited on the RemoteTargetDatabase
    ```
- [ ] Run the following commands in EACH Powershell instance:
  ```Powershell
  Connect-ExchangeOnline
  ```

### Create Move Requests
- [ ] Save a credential for each Exchange Organization that has mailboxes in the migration wave.
``` Powershell
$EXACred = Get-Credential
# for an additional source exchange environment
$EXBCred = Get-Credential
# etc.
```

- [ ] MULTIPLE SOURCE: Save all the credentials in a hashtable by Exchange Organization abbreviation

``` Powershell
  # With multiple exchange source environments
  $ExchangeCredentials = @{EXA = $EXMCred; EXB = $EXMCred}
  # With one exchange source environment use the single credential from above

```

- [ ] Get the Migration Endpoints
``` Powershell
  $Endpoint = $(Get-MBMConfiguration).MigrationEndpoint
```

- [ ] Get the Target Delivery Domain and RemoteTargetDatabase
``` Powershell
  $TargetDeliveryDomain = $(Get-MBMConfiguration).TargetDeliveryDomain
  $RemoteTargetDatabase = $(Get-MBMConfiguration).RemoteTargetDatabase
```

``` Powershell
$nRMRParams = @{
  ExchangeCredential = $EXACred
  Endpoint = $MBMConfiguration.Endpoint
  TargetDeliveryDomain = $MBMConfiguration.ReverseMoveTargetDeliveryDomain
  RemoteTargetDatabase = $MBMConfiguration.ReverseMoveTargetDatabase
  ArchiveDomain = $MBMConfiguration.TargetDeliveryDomain
  Identity = [mailbox identifiers]
  #specify a short reason - goes in the batchname attribute of the move request and prefixed with "Reason:"
  ReasonCode = 'Prep1.1'
  #NoSuspend = $true
  #IncludeArchive = $true
}
# add additional parameters if no suspend is desired or if archive move is desired (-NoSuspend or -IncludeArchive)

New-MBMReverseMoveRequest @nWMRParams
```
