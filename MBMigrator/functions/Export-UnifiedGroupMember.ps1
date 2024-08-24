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
                $members = Get-MgGroupMemberAsUser -GroupID $Group.ID -Property ID,DisplayName,Mail,UserPrincipalName,UserType
                $members.foreach({
                    [PSCustomObject]@{
                     GroupID = $Group.Id
                     GroupDisplayName = $group.displayName
                     GroupMail = $group.mail
                     Role = 'Member'
                     UserID = $_.Id
                     UserDisplayName = $_.DisplayName
                     UserMail = $_.Mail
                     UserPrincipalName = $_.UserPrincipalName
                     UserType = $_.UserType
                     TenantDomain = $TenantDomain
                    }
                })
            }))

    $UnifiedGroupOwners = @($Groups.foreach({
        $Group = $_
        $members = Get-MgGroupOwnerAsUser -GroupID $Group.ID -Property ID,DisplayName,Mail,UserPrincipalName,UserType
        $members.foreach({
            [PSCustomObject]@{
                GroupID = $Group.Id
                GroupDisplayName = $group.displayName
                GroupMail = $group.mail
                Role = 'Owner'
                UserID = $_.Id
                UserDisplayName = $_.DisplayName
                UserMail = $_.Mail
                UserPrincipalName = $_.UserPrincipalName
                UserType = $_.UserType
                TenantDomain = $TenantDomain
            }
        })
    }))

    @($UnifiedGroupMembers;$UnifiedGroupOwners) | Export-Excel -Path $OutputFilePath -WorksheetName UnifiedGroupMembers -TableName UnifiedGroupMembers -TableStyle Medium4
}
