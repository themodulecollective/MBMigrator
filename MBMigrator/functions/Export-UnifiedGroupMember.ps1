function Export-UnifiedGroupMember
{
    <#
    .SYNOPSIS
        Get all Azure Active Directory Unified Groups and export their Drive Info to Excel
    .DESCRIPTION
        Get all Azure Active Directory Unified Groups and export their Drive Info to Excel including DriveName, DriveURL, DriveID, driveType, SiteURL, createdDateTime, lastModifiedDateTime, and quota information
    .EXAMPLE
        Export-AzureADGroupDrive -OutputFolderPath "C:\Users\UserName\Documents"
        All Unified Groups in the connected tenant (via Graph) Drive Info  will be exported to an Excel file in Documents
    #>

    [cmdletbinding()]
    param(
        # Folder path for the XML or Zip export
        [parameter(Mandatory)]
        [string]$OutputFolderPath
    )

    $DateString = Get-Date -Format yyyyMMddhhmmss

    #$TenantID = (Get-MgContext).TenantID
    $TenantDomain = (Get-MGDomain -All).where({$_.IsDefault}).ID.split('.')[0]

    $OutputFileName = $TenantDomain + '-UnifiedGroupMembers' + 'AsOf' + $DateString
    $OutputFilePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.xlsx')

    Write-Information -MessageData 'Getting All Entra Unified Groups'
    $Groups = Get-OGGroup -UnifiedAll

    Write-Information -MessageData 'getting the Group Members'

    $UnifiedGroupMembers = @($Groups.foreach({
                $Group = $_
                Get-MgGroupMemberAsUser -GroupID $Group.ID -Property ID,DisplayName,Mail,UserPrincipalName,UserType |
                Select-Object -ExcludeProperty 'ID' -Property @{n='GroupID';e={$Group.ID}},
                    @{n='GroupDisplayName';e={$Group.displayName}},
                    @{n='Role';e={'Member'}}
                    @{n='GroupMail';e={$Group.mail}},
                    @{n='UserID';e={$_.ID}},
                    @{n='UserDisplayName';e={$_.DisplayName}},
                    @{n='UserMail';e={$_.Mail}},
                    @{n='UserPrincipalName';e={$_.UserPrincipalName}},
                    @{n='UserType';e={$_.UserType}},
                    @{n='TenantDomain'; e={$TenantDomain}}
            }))

    $UnifiedGroupMembers | Export-Excel -Path $OutputFilePath -WorksheetName UnifiedGroupMembers -TableName UnifiedGroupMembers -TableStyle Medium4
}
