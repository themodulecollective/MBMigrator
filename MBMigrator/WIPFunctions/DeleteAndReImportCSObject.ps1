param(
    $DistinguishedName
    ,
    $ConnectorName = 'clientdomain.com'
)

$CSObject = Get-ADSyncCSObject -ConnectorName $ConnectorName -DistinguishedName $DistinguishedName
Remove-ADSyncCSObject -CsObject $CSObject -Confirm:$false -Force

#get the object back in the connector space
Invoke-ADSyncRunProfile -ConnectorName $ConnectorName -RunProfileName 'Full Import'
#get object back in metaverse, hopefully joined with the correct object(S)
Start-ADSyncSyncCycle -PolicyType Delta
