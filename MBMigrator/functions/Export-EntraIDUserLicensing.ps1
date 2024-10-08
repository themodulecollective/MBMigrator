function Export-EntraIDUserLicensing {
    <#
    .SYNOPSIS
        Get all relevant (per specified skus and serviceplans) EntraID User Licensing details user and export them to an excel file
    .DESCRIPTION
        Get all relevant (per specified skus and serviceplans) EntraID User Licensing details user and export them to an excel file
    .EXAMPLE
        -SKUs '1c27243e-fb4d-42b1-ae8c-fe25c9616588','05e9a617-0261-4cee-bb44-138d3ef5d965'
        -ServicePlan '9974d6cf-cd24-4ba2-921c-e2aa687da846','efb87545-963c-4e0d-99df-69c6916d9eb0','c1ec4a95-1f05-45b3-a911-aa3fa01094f5','57ff2da0-773e-42df-b2af-ffb7a2317929'
    #>

    [cmdletbinding()]
    param(
        # Folder path for the XML or Zip export
        [parameter(Mandatory)]
        [ValidateScript( { Test-Path -type Container -Path $_ })]
        [string]$OutputFolderPath
        ,
        [parameter(Mandatory)]
        [string[]]$Sku #SKUIDs for relevant skus.  Recommend using Get-OGSKU -includeDisplayName from Ograph module to get the SKUIDs
        ,
        [parameter(Mandatory)]
        [string[]]$ServicePlan
        ,
        [string]$Delimiter = ';'
    )

    $DateString = Get-Date -Format yyyyMMddhhmmss

    $TenantDomain = (Get-MGDomain -All).where({$_.IsDefault}).ID.split('.')[0]
    #$TenantID = (Get-MGContext).TenantID

    $ReadableHash = @{}
    $skusReadable = Get-OGReadableSku -StoreCSV
    foreach ($sR in $skusReadable)
    {
        $ReadableHash[$sR.GUID] = $sR.Product_Display_Name
        $ReadableHash[$sR.Service_Plan_Id] = $sR.Service_Plans_Included_Friendly_Names
    }

    $GetMGUserParams = @{
        Filter = 'assignedLicenses/$count ne 0'
        ConsistencyLevel='eventual'
        CountVariable='licensedUserCount'
        All=$true
        Select='UserPrincipalName','DisplayName','AssignedLicenses','AssignedPlans','ProvisionedPlans','LicenseAssignmentStates','LicenseDetails','UsageLocation','Mail','ID'
    }

    $LicensedUsers = Get-MgUser @GetMGUserParams

    $Results = @($LicensedUsers.foreach({

        $LU = $_

        [pscustomobject]@{
            ID = $LU.ID
            UserPrincipalName = $LU.UserPrincipalName
            Mail = $LU.Mail
            UsageLocation = $LU.UsageLocation
            LicenseSource = @(
                @(
                $($LU.LicenseAssignmentStates.where({$null -ne $_.AssignedByGroup}).AssignedByGroup)
                $(If ($LU.LicenseAssignmentStates.where({$null -eq $_.AssignedByGroup}).count -ge 1){'Direct'})
                ) | Sort-Object -Unique) -Join $Delimiter
            LicenseIDs = @($LU.LicenseAssignmentStates.SkuId.where({$_ -in $Sku}) | Sort-Object -Unique) -join $Delimiter
            LicenseNames = @($LU.LicenseAssignmentStates.SkuId.where({$_ -in $Sku}).foreach({
                    $ReadableHash.$($_)
                }) | Sort-Object -Unique) -join $Delimiter
            ServicePlanIDs = @($LU.AssignedPlans.where({$_.CapabilityStatus -eq 'Enabled'}).ServicePlanId.where({$_ -in $ServicePlan}) | Sort-Object -Unique) -join $Delimiter
            ServicePlanNames = @($LU.AssignedPlans.where({$_.CapabilityStatus -eq 'Enabled'}).ServicePlanId.where({$_ -in $ServicePlan}).foreach({
                    $ReadableHash.$($_)
                }) | Sort-Object -Unique) -join $Delimiter
        }
    }))

    switch ([string]::IsNullOrWhiteSpace($OutputFolderPath))
    {
        $true
        {
            $Results
        }
        $false
        {
            $OutputFileName = $TenantDomain + '-EntraIDUserLicensing' + 'AsOf' + $DateString
            $OutputFilePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.xlsx')
            $ExportExcelParams = @{
                path = $OutputFilePath
                Autosize = $true
                WorksheetName = 'UserLicensing'
                TableName = 'UserLicensing'
                TableStyle = 'Medium5'
                FreezeTopRow = $true
            }
            $Results | Export-Excel @ExportExcelParams
        }
    }


}