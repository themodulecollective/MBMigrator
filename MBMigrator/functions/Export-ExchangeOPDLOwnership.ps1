Function Export-ExchangeOPDLOwnership {
[cmdletbinding()]
param(
    ##[string[]]$LinkedMailboxCN
    ##,
    ##[string]$ExchangeServerFQDN
    [parameter(Mandatory)]
    [string]$OutputFolderPath
    ,
    [string]$RecipientFilter


)
##$OUMatch = $LinkedMailboxCN -join '|'

function ConvertFrom-DN
{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [string[]]$DistinguishedName
    )
    process
    {
        foreach ($DN in $DistinguishedName)
        {
            #Write-Verbose $DN
            foreach ( $item in ($DN.replace('\,', '~').split(',')))
            {
                switch ($item.TrimStart().Substring(0, 2))
                {
                    'CN' { $CN = '/' + $item.Replace('CN=', '') }
                    'OU' { $OU += , $item.Replace('OU=', ''); $OU += '/' }
                    'DC' { $DC += $item.Replace('DC=', ''); $DC += '.' }
                }
            }
            $CanonicalName = $DC.Substring(0, $DC.length - 1)
            for ($i = $OU.count; $i -ge 0; $i -- ) { $CanonicalName += $OU[$i] }
            if ( $DN.Substring(0, 2) -eq 'CN' )
            {
                $CanonicalName += $CN.Replace('~', '\,')
            }
            $CanonicalName

        }
    }
}

function ConvertFrom-CanonicalUser
{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [string]$CanonicalName
    )
    process
    {
        $obj = $CanonicalName.Replace(',', '\,').Split('/')
        [string]$DN = 'CN=' + $obj[$obj.count - 1]
        for ($i = $obj.count - 2; $i -ge 1; $i--) { $DN += ',OU=' + $obj[$i] }
        $obj[0].split('.') | ForEach-Object { $DN += ',DC=' + $_ }
        return $DN
    }
}

Set-ADServerSettings -ViewEntireForest $true

$ExchangeDGsNoStubs = Get-DistributionGroup -ResultSize Unlimited -Filter $RecipientFilter
$AllNonStubDGs = $ExchangeDGsNoStubs | Select-Object -Property 'DisplayName', 'DistinguishedName', 'GroupType', 'RecipientTypeDetails', 'PrimarySMTPAddress', 'Alias', 'Name', 'GUID', 'ManagedBy'
#.where( { $_.ManagedBy -match $OUMatch })
$AllNonStubDGsExpandedByManager =
    $AllNonStubDGs.foreach( { $thisgroup = $_; $_.ManagedBy.foreach( { $manby = $_; $thisgroup | Select-Object -Property 'DisplayName', 'DistinguishedName', 'GroupType', 'RecipientTypeDetails', 'PrimarySMTPAddress', 'Alias', 'Name', 'GUID', @{n = 'ManagedBy'; e = { $manby } } -ExcludeProperty ManagedBy }) })
#$AllNonStubDGsExpandedByManager = $AllNonStubDGsExpandedByManager.where( { $_.ManagedBy -match $OUMatch })
$ByManager = $AllNonStubDGsExpandedByManager | Group-Object ManagedBy | Sort-Object -Descending -Property Count
$ManagerDetail = $ByManager.ForEach( { Get-Recipient -Identity $_.name })
$ManagerHash = @{ }
$ManagerDetail.ForEach( { $ManagerHash.$($_.DistinguishedName) = $_ })
$GroupHash = @{ }
$AllNonStubDGs.ForEach( { $GroupHash.$($_.DistinguishedName) = $_ })
$groupReport = @($AllNonStubDGsExpandedByManager.ForEach( {
            $group = $_
            $manby = $group.ManagedBy
            $manbydn = ConvertFrom-CanonicalUser -CanonicalName $manby
            if ($null -ne $manby -and $ManagerHash.ContainsKey($manbydn))
            {
                [pscustomobject]@{
                    DisplayName          = $group.DisplayName
                    Name                 = $group.Name
                    Alias                = $group.Alias
                    Mail                 = $group.PrimarySMTPAddress
                    GroupType            = $group.GroupType
                    RecipientTypeDetails = $group.RecipientTypeDetails
                    ManagedByDN          = $ManagerHash.$manbydn.DistinguishedName
                    ManagedByDisplayName = $ManagerHash.$manbydn.DisplayName
                    ManagedByMail        = $ManagerHash.$manbydn.PrimarySMTPAddress
                    ManagedByExchangeGUID = $ManagerHash.$manbydn.ExchangeGUID.guid
                    ObjectGUID           = $group.GUID.guid
                    GroupDN              = $group.DistinguishedName
                }
            }
            else
            {
                [PSCustomObject]@{
                    DisplayName          = $group.DisplayName
                    Name                 = $group.Name
                    Alias                = $group.Alias
                    Mail                 = $group.PrimarySMTPAddress
                    GroupType            = $group.GroupType
                    RecipientTypeDetails = $group.RecipientTypeDetails
                    ManagedByDN          = $Null
                    ManagedByDisplayName = $Null
                    ManagedByMail        = $Null
                    ObjectGUID           = $group.GUID.guid
                    GroupDN              = $group.DistinguishedName
                }
            }
        }))

$managerReport = @(
    $ManagerDetail.foreach( {
            $ManagerCN = ConvertFrom-DN -DistinguishedName $_.DistinguishedName
            [pscustomobject]@{
                DisplayName = $_.DisplayName
                Name        = $_.Name
                Alias       = $_.Alias
                Mail        = $_.PrimarySMTPAddress
                ExchangeGUID = $_.ExchangeGUID.guid
                GroupCount  = $AllNonStubDGsExpandedByManager.where( { $_.managedBy -eq $ManagerCN }).count
                Groups      = $AllNonStubDGsExpandedByManager.where( { $_.managedBy -eq $ManagerCN }).PrimarySMTPAddress -join ';'
            }
        })
)

$DateString = Get-Date -Format yyyyMMddHHmmss
$GroupReportFileName = 'DistributionGroupOwnershipAsOf' + $DateString + '.xlsx'
$GroupReportPath = Join-Path -Path $OutputFolderPath -ChildPath $GroupReportFileName

$groupReport | Export-Excel -Path $GroupReportPath -WorksheetName 'Groups'
$ManagerReport | Export-Excel -Path $GroupReportPath -WorksheetName 'Managers'
}