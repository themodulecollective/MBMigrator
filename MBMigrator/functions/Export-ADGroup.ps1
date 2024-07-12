function Export-ADGroup {
    <#
    .SYNOPSIS
        Get all Active Directory Group and export them to a XML file
    .DESCRIPTION
        Export all Active Directory Group to an XML file. Optional Zip export using $compressoutput switch param. Can specify additional properties to be included in the Group export using CustomProperty param.
    .EXAMPLE
        Export-ADGroup -OutputFolderPath "C:\Users\UserName\Documents" -Domain contoso
        All Groups in the domain Contoso will be exported Documents in the file 20221014021841contosoGroups.xml

        Export-ADGroup -OutputFolderPath "C:\Users\UserName\Documents" -Domain contoso -Exchange:$true
        All Groups in the domain Contoso will be exported Documents in the file 20221014021841contosoGroups.xml. The Group attributes will include some exchange attributes. ex. msExchRecipientDisplayType and mailnickname

        Export-ADGroup -OutputFolderPath "C:\Users\UserName\Documents" -Domain contoso -CustomProperty CustomAttribute17
        All Groups in the domain Contoso will be exported Documents in the file 20221014021841contosoGroups.xml and CustomAttribute17 will be included in the Group attributes
    #>

    [cmdletbinding()]
    param(
        # Folder path for the XML or Zip export
        [parameter(Mandatory)]
        [ValidateScript( { Test-Path -type Container -Path $_ })]
        [string]$OutputFolderPath
        ,
        # Groups Domain. Used when naming export file and as the "server" parameter for Get-ADGroup
        [parameter(Mandatory)]
        [string]$Domain
        ,
        # Includes Exchange Group attributes.
        [parameter()]
        [bool]$Exchange = $true
        ,
        # Include custom attribute to the exported Group attributes
        [parameter()]
        [string[]]$CustomProperty
        ,
        # Compress the XML file into a Zip file
        [parameter()]
        [switch]$CompressOutput
    )


    if ($null -eq $(Get-Module -Name ActiveDirectory)) {
        Import-Module ActiveDirectory -ErrorAction Stop
    }

    $Properties = @(@(
        'CanonicalName'
        'CN'
        'Created'
        'CreateTimeStamp'
        'Description'
        'DisplayName'
        'DistinguishedName'
        'GroupCategory'
        'GroupScope'
        'GroupType'
        'HomePage'
        'InstanceType'
        'Modified'       
        'ModifyTimeStamp'
        'Name'
        'ObjectCategory'
        'ObjectClass'
        'ProtectedFromAccidentalDeletion'
        'SamAccountName'
        'sAMAccountType'
        'sDRightsEffective'
        'WhenChanged'
        'WhenCreated'
        'Mail'
        'ManagedBy'
        'Members'
        'MemberOf'
        'SID'
        'SIDHistory'
        'ObjectGUID'
        ) | Sort-Object)

    switch ($Exchange) {
        $true {
            $Properties = @(@($Properties;@(
                'ProxyAddresses'  
                'MailNickName'
                'LegacyExchangeDN'
                'msExchRoleGroupType'
                'msExchRecipientDisplayType'
                'msExchGroupExternalMemberCount'
                'msExchGroupMemberCount'
                'ShowInAddressBook'
                'msExchCoManagedByLink'
                );@($((1..15).foreach({"ExtensionAttribute$_"}));$((16..45).foreach({"msExchExtensionAttribute$_"}));$((1..5).foreach({"msExchExtensionCustomAttribute$_"})))) | Sort-Object)
        }
    }

    $Properties = @(@($Properties;$CustomProperty) | Sort-Object -Unique)

    $DateString = Get-Date -Format yyyyMMddhhmmss

    $OutputFileName = $Domain + '-ADGroups' + 'AsOf' + $DateString
    $OutputFilePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.xml')

    $gADGroupParams = @{}
    $gADGroupParams.Add('Server',$($Domain))

    $ADGroups = Get-ADGroup -Properties $Properties -filter * @gADGroupParams -Server $Domain  #| Sort-Object -Property $Properties -Descending

    $ADGroups | Export-Clixml -Path $outputFilePath

    if ($CompressOutput) {
        $ArchivePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.zip')

        Compress-Archive -Path $OutputFilePath -DestinationPath $ArchivePath

        Remove-Item -Path $OutputFilePath -Confirm:$false
    }
}