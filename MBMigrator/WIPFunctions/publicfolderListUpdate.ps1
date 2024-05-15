
Write-Information -MessageData 'Processing Exchange Mail Public Folder Data'
@{n = 'ExchangeOrg'; e = { $O } }

$allMPF = @(
    $EXA.MailPublicFolder | Select-Object *, @{n = 'ExchangeOrg'; e = { 'EXA' } };
    $EXM.MailPublicFolder | Select-Object *, @{n = 'ExchangeOrg'; e = { 'EXM' } };
)

$allPF = @(
    $EXA.PublicFolder | Select-Object *, @{n = 'ExchangeOrg'; e = { 'EXA' } };
    $EXM.PublicFolder | Select-Object *, @{n = 'ExchangeOrg'; e = { 'EXM' } };
)

$allPFS = @(
    $EXA.PublicFolderStatistics | Select-Object *, @{n = 'ExchangeOrg'; e = { 'EXA' } };
    $EXM.PublicFolderStatistics | Select-Object *, @{n = 'ExchangeOrg'; e = { 'EXM' } };
)

$sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly

$allMPF | ConvertTo-DbaDataTable | Write-DbaDataTable -SqlInstance $sql -Database Migration -Table 'MailPublicFolder' -AutoCreateTable #-Truncate

$sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly

$allPF | ConvertTo-DbaDataTable | Write-DbaDataTable -SqlInstance $sql -Database Migration -Table 'PublicFolder' -AutoCreateTable #-Truncate


$property = @(
    'AssociatedItemCount'
    'ContactCount'
    'CreationTime'
    'DeletedItemCount'
    'EntryId'
    'FolderPath'
    'Identity'
    'IsValid'
    'ItemCount'
    'LastModificationTime'
    'MailboxOwnerId'
    'Name'
    'OwnerCount'
    'TotalAssociatedItemSize'
    'TotalDeletedItemSize'
    'TotalItemSize'
)
$delimiters = [System.Collections.Generic.List[string]]@('(', ')', ' ')
$excludeProperty = @('TotalItemSize', 'TotalDeletedItemSize', 'TotalAssociatedItemSize')
$customProperty = @(
    @{n = 'TotalItemSizeInMB'; e = { [int]$($_.TotalItemSize.tostring().split($delimiters)[3].replace(',', '') / 1MB) } }
    @{n = 'TotalDeletedItemSizeInMB'; e = { [int]$($_.TotalDeletedItemSize.tostring().split($delimiters)[3].replace(',', '') / 1MB) } }
    @{n = 'TotalAssociatedItemSizeInMB'; e = { [int]$($_.TotalAssociatedItemSize.tostring().split($delimiters)[3].replace(',', '') / 1MB) } }
)
$sql = Connect-DbaInstance -SqlInstance 127.0.0.1 -SqlCredential $sqlcredential -Database Migration -SqlConnectionOnly

$allPFS | Select-Object -ExcludeProperty $excludeProperty -Property @($property; $customProperty) | ConvertTo-DbaDataTable | Write-DbaDataTable -SqlInstance $sql -Database Migration -Table 'PublicFolderStatistics' -AutoCreateTable