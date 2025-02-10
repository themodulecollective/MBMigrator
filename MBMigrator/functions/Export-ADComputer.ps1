function Export-ADComputer {
    <#
    .SYNOPSIS
        Get all Active Directory computers and export them to a XML file
    .DESCRIPTION
        Export all Active Directory Computers to an XML file. Optional Zip export using $compressoutput switch param. Can specify additional properties to be included in the user export using CustomProperty param.
    .EXAMPLE
        Export-ADComputer -OutputFolderPath "C:\Users\UserName\Documents" -Domain contoso
        All computers in the domain Contoso will be exported Documents in the file 20221014021841contosoComputers.xml

        Export-ADComputer -OutputFolderPath "C:\Users\UserName\Documents" -Domain contoso -CustomProperty CustomAttribute17
        All computers in the domain Contoso will be exported Documents in the file 20221014021841contosoCopmuters.xml and CustomAttribute17 will be included in the Computer attributes
    #>

    [cmdletbinding()]
    param(
        # Folder path for the XML or Zip export
        [parameter(Mandatory)]
        [ValidateScript( { Test-Path -type Container -Path $_ })]
        [string]$OutputFolderPath
        ,
        # Users Domain. Used when naming export file and as the "server" parameter for Get-ADUser
        [parameter(Mandatory)]
        [string]$Domain
        ,
        # Include custom attribute to the exported user attributes
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
        'AccountExpirationDate','AccountExpires','AccountLockoutTime','AccountNotDelegated','AllowReversiblePasswordEncryption','CannotChangePassword','CanonicalName','Certificates','CN','codePage','countryCode','Created','createTimeStamp','Deleted','Description','DisplayName','DistinguishedName','DNSHostName','DoesNotRequirePreAuth','Enabled','HomedirRequired','HomePage','instanceType','IPv4Address','IPv6Address','isCriticalSystemObject','isDeleted','KerberosEncryptionType','LastBadPasswordAttempt','LastKnownParent','LastLogonDate','lastLogonTimestamp','localPolicyFlags','Location','LockedOut','ManagedBy','MemberOf','MNSLogonAccount','Modified','modifyTimeStamp','msDS-KeyCredentialLink','msDS-SupportedEncryptionTypes','msDS-User-Account-Control-Computed','Name','nTSecurityDescriptor','ObjectCategory','ObjectClass','ObjectGUID','objectSid','OperatingSystem','OperatingSystemHotfix','OperatingSystemServicePack','OperatingSystemVersion','PasswordExpired','PasswordLastSet','PasswordNeverExpires','PasswordNotRequired','PrimaryGroup','primaryGroupID','PrincipalsAllowedToDelegateToAccount','ProtectedFromAccidentalDeletion','pwdLastSet','SamAccountName','sAMAccountType','sDRightsEffective','ServiceAccount','servicePrincipalName','ServicePrincipalNames','SID','SIDHistory','TrustedForDelegation','TrustedToAuthForDelegation','UseDESKeyOnly','userAccountControl','userCertificate','UserPrincipalName','uSNChanged','uSNCreated','whenChanged','whenCreated'
    ) | Sort-Object)

    # 'AuthenticationPolicy','AuthenticationPolicySilo','BadLogonCount','CompoundIdentitySupported','dSCorePropagationData',


    $Properties = @(@($Properties;$CustomProperty) | Sort-Object -Unique)

    $DateString = Get-Date -Format yyyyMMddhhmmss

    $OutputFileName = $Domain + '-ADComputers' + 'AsOf' + $DateString
    $OutputFilePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.xml')

    $gADComputerParams = @{}
    $gADComputerParams.Add('Server',$Domain)

    $ADComputers = Get-ADComputer -Properties $Properties -filter * @gADComputerParams  #| Sort-Object -Property $Properties -Descending

    $ADComputers | Export-Clixml -Path $outputFilePath

    if ($CompressOutput) {
        $ArchivePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.zip')

        Compress-Archive -Path $OutputFilePath -DestinationPath $ArchivePath

        Remove-Item -Path $OutputFilePath -Confirm:$false
    }
}