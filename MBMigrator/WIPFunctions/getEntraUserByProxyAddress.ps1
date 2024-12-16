param($email)

$filter = "proxyAddresses/any(c:c eq 'smtp:$email')"

Get-MgUser -filter $filter -Property ID,UserPrincipalName,Mail