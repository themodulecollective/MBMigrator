function Export-UnifiedGroupRoleHolder
{
    <#
    .SYNOPSIS
        Get all Unified Group Members and Owners
    .DESCRIPTION
        Get all EntraID Unified Group members and owners and export the records to Excel including GroupDisplayName,GroupID,GroupMail,Role,TenantDomain,UserDisplayName,UserID,UserMail,UserPrincipalName,UserType
    .EXAMPLE
        Export-UnifiedGroupRole -OutputFolderPath "C:\Users\UserName\Documents"
        All Unified Group Onwers and Members in the connected tenant (via Graph)  will be exported to an Excel file in Documents
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

    $OutputFileName = $TenantDomain + '-UnifiedGroupRoleHolders' + 'AsOf' + $DateString
    $OutputFilePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.xlsx')

    Write-Information -MessageData 'Getting All Entra Unified Groups'
    $Groups = Get-OGGroup -UnifiedAll

    Write-Information -MessageData 'getting the Group Role Holders'

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
