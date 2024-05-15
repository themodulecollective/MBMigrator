# UPN Change Steps

## Get a list of users
This list might come from AD, Exchange, or another source.  At minimum, the list should include the current UPN and the current Mail attribute or PrimarySMTPAddress.
Some examples below

```PowerShell
#AD 
$users = Get-ADUser -property UserPrincipalName,Mail #add whatever -filter or -identity or other parameter would be appropriate to get the required users
#Exchange
$users = Get-User #add whatever -filter or -identity or other parameter would be appropriate to get the required users
```

## Check if UPN and Mail don't match

```PowerShell
$UsersToProcess = $Users.where({$_.UserPrincipalName -ne $_.Mail})  #if your source was Exchange this should compare to $_.PrimarySMTPAddress instead of $_.Mail
```

Validate your results

```PowerShell
$Users.count
$UsersToProcess.count
#UsersToProcess count should be less than Users count if some of the users already have their UPN changed
```

## Process the change
Examples below
```PowerShell
# Exchange
$usersToProcess.foreach({Set-User -Identity $_.UserPrincipalName -UserPrincipalName $_.PrimarySMTPAddress})

#AD
$usersToProcess.foreach({Set-ADUser -Identity $_.UserPrincipalName -UserPrincipalName $_.Mail})
```

## Wait for and verify Azure AD Connect Sync

view some of the processed users in Azure AD and/or Exchange Online to see the synchronized updated UPN
you can use the portal for this, or from Exchange Online Management Shell

```PowerShell
# Where PrimarySMTPAddress = an address of one of the processed users
Get-User -identity $PrimarySMTPAddress | Select-Object -Property UserPrincipalName,PrimarySMTPAddress
```

UserPrincipalName and PrimarySMTPAddress should match