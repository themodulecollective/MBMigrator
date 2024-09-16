function Export-EntraIDUser {
    <#
    .SYNOPSIS
        Get all EntraID user and export them to a XML file
    .DESCRIPTION
        Export all EntraID user to an XML file. Optional Zip export using $compressoutput switch param. Can specify additional properties to be included in the user export using CustomProperty param.
    .EXAMPLE
        Export-EntraIDUser -OutputFolderPath "C:\Users\UserName\Documents"
        All users in the currently connected tenant (Graph) will be exported Documents in the file TenantDomain-EntraIDUsersAsOfDateString.xml

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
    $TenantDomain = (Get-MGDomain -All).where({$_.IsDefault}).ID.split('.')[0]

    $Properties = @(

     'accountEnabled'
     'assignedLicenses'
     'businessPhones'
     'city'
     'companyName'
     'country'
     'department'
     'displayName'
     'employeeId'
     'givenName'
     'id'
     'jobTitle'
     'lastPasswordChangeDateTime'
     'licenseAssignmentStates'
     'mail'
     'mailNickname'
     'mobilePhone'
     'officeLocation'
     'manager'
     'onPremisesDistinguishedName'
     'onPremisesDomainName'
     'onPremisesExtensionAttributes'
     'onPremisesImmutableId'
     'onPremisesLastSyncDateTime'
     'onPremisesSamAccountName'
     'onPremisesSecurityIdentifier'
     'onPremisesSyncEnabled'
     'onPremisesUserPrincipalName'
     'preferredLanguage'
     'surname'
     'usageLocation'
     'userPrincipalName'
     'userType'
    )

    $Properties = @(@($Properties;$CustomProperty) | Sort-Object -Unique)

    $DateString = Get-Date -Format yyyyMMddhhmmss

    $OutputFileName = $TenantDomain + '-EntraIDUsers' + 'AsOf' + $DateString
    $OutputFilePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.xml')

    $Users = get-oguser -All -Property $Properties | Select-Object -Property @($Properties;@{n='TenantDomain';e={$TenantDomain}})

    $Users | Export-Clixml -Path $outputFilePath

    if ($CompressOutput) {
        $ArchivePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.zip')

        Compress-Archive -Path $OutputFilePath -DestinationPath $ArchivePath

        Remove-Item -Path $OutputFilePath -Confirm:$false
    }
}