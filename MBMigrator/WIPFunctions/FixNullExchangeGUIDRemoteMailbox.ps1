#Fix null ExchangeGUID
Get-OPRemoteMailbox | where-object {$_.ExchangeGUID -eq '00000000-0000-0000-0000-000000000000'} |
ForEach-Object {Get-Mailbox -Identity $_.PrimarySMTPAddress} |
ForEach-Object {Set-OPRemoteMailbox -Identity $_.PrimarySMTPAddress -ExchangeGuid $_.ExchangeGUID}
