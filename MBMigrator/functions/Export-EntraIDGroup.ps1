function Export-EntraIDGroup {
    <#
    .SYNOPSIS
        Get all EntraID groups and export them to a XML file
    .DESCRIPTION
        Export all EntraID groups to an XML file. Optional Zip export using $compressoutput switch param. Can specify additional properties to be included in the export using CustomProperty param.
    .EXAMPLE
        Export-EntraIDGroup -OutputFolderPath "C:\Users\UserName\Documents"
        All groups in the currently connected tenant will be exported Documents in the file 20221014021841contosoUsers.xml
    #>

    [cmdletbinding()]
    param(
        # Folder path for the XML or Zip export
        [parameter(Mandatory)]
        [ValidateScript( { Test-Path -type Container -Path $_ })]
        [string]$OutputFolderPath
        ,
        # Include custom attribute to the exported user attributes
        [parameter()]
        [string[]]$CustomProperty
        ,
        # Compress the XML file into a Zip file
        [parameter()]
        [switch]$CompressOutput

    )

    #$TenantID = (Get-MGContext).TenantID
    $TenantDomain = (Get-MGDomain -All).where({$_.IsDefault}).ID

    $Properties = @(
        'classification', 'createdByAppId', 'createdDateTime', 'deletedDateTime', 'description', 'displayName', 'expirationDateTime',
             'groupTypes', 'id', 'infoCatalogs', 'isAssignableToRole', 'isManagementRestricted', 'mail', 'mailEnabled', 'mailNickname', 'membershipRule', 'membershipRuleProcessingState',
             'onPremisesDomainName', 'onPremisesLastSyncDateTime', 'onPremisesNetBiosName', 'onPremisesProvisioningErrors', 'onPremisesSamAccountName', 'onPremisesSecurityIdentifier', 'onPremisesSyncEnabled',
             'organizationId', 'preferredDataLocation', 'preferredLanguage', 'proxyAddresses', 'renewedDateTime', 'resourceBehaviorOptions', 'resourceProvisioningOptions', 'securityEnabled',
             'securityIdentifier', 'theme', 'visibility', 'writebackConfiguration'
    )

    $Properties = @(@($Properties;$CustomProperty) | Sort-Object -Unique)

    $DateString = Get-Date -Format yyyyMMddhhmmss

    $OutputFileName = $TenantDomain + '-EntraIDGroups' + 'AsOf' + $DateString
    $OutputFilePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.xml')

    $Groups = Get-OGGroup -Property $Properties | 
        Select-Object -ExcludeProperty GroupTypes -Property @(
            $Properties;
            @{n='TenantDomain';e={$TenantDomain}}, @{n='TenantID'; e={$TenantID}}, 
            @{n='groupType';e={$_.groupTypes -join '|'}})
        

    $Groups | Export-Clixml -Path $outputFilePath

    if ($CompressOutput) {
        $ArchivePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.zip')

        Compress-Archive -Path $OutputFilePath -DestinationPath $ArchivePath

        Remove-Item -Path $OutputFilePath -Confirm:$false
    }
}