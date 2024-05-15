$TestUser = ''

#Get the available Skus and Usage from the tenant and build a lookup hashtable for the reporting to use to translate guids to human readable sku names
Get-AzureADSubscribedSku | Select-Object SkuID, SkuPartNumber, @{n = 'EnabledUnits'; e = { $_.PrepaidUnits.Enabled } }, ConsumedUnits, @{n = 'AvailableUnits'; e = { $_.PrepaidUnits.Enabled - $_.ConsumedUnits } } -OutVariable AllSkus
$SkuIdToSkuPartNumberHash = @{}
$AllSkus | ForEach-Object { $SkuIdToSkuPartNumberHash.$($_.SkuID) = $_.SkuPartNumber }
$SkuIdToSkuPartNumberHash

#Specify which skus you want to specifically report on, the sample below are the guids for 'STANDARDPACK','ENTERPRISEPACK','ENTERPRISEPREMIUM' respectively
$SkusToReportOn = @('18181a46-0d4e-45cd-891e-60aabd171b4e', '6fd2c87f-b296-42f0-b197-1e91e994b900', 'c7df2760-2c81-4ef7-b578-5b5392b571df')
#Report on Users/Sku Usage

$AllUsers = Get-AzureADUser -ObjectId $TestUser |
Select-Object DisplayName, UserPrincipalName, @{n = 'IsLicensed'; e = { $true } }, @{n = 'Skus'; e = { @($_.AssignedLicenses.SkuId |
            ForEach-Object { $SkuIdToSkuPartNumberHash.$($_) }) }
}, @{n = 'SkuIDs'; e = { @($_.AssignedLicenses.SkuID) } }

#-All $true |
#? {$_.AssignedLicenses.count -ge 1} |

#Below expands licensed users so that for each Sku in SkusToReportOn there would be an entry for the user if the user has more than one of them assigned
$ExpandedSkuUsers = @(
    foreach ($lu in $AllLicensedUsers)
    {
        $SkusHeld = @()
        foreach ($s in $SkusToReportOn)
        {
            if ($lu.SkuIDs -contains $s)
            {
                [pscustomobject]@{
                    DisplayName       = $lu.DisplayName
                    UserPrincipalName = $lu.UserPrincipalName
                    IsLicensed        = $lu.IsLicensed
                    Sku               = $SkuIdToSkuPartNumberHash.$s
                    AllSkus           = $($lu.Skus -join ';')
                }
                $SkusHeld += $s
            }
        }
        if ($SkusHeld.Count -eq 0)
        {
            [pscustomobject]@{
                DisplayName       = $lu.DisplayName
                UserPrincipalName = $lu.UserPrincipalName
                IsLicensed        = $lu.IsLicensed
                Sku               = $null
                AllSkus           = $($lu.Skus -join ';')
            }
        }
    })
#Counts Per License Sku
$ExpandedSkuUsers | Group-Object sku -NoElement
#Users with License Detail (one object per user/SkusToReportOn)
$ExpandedSkuUsers