function Add-ExchangeLabUserPermissions {
    param (
        [parameter(Mandatory)]
        [ValidateScript({
                if (-Not ($_ | Test-Path) ) {
                    throw "File or folder does not exist"
                }
                if (-Not ($_ | Test-Path -PathType Leaf) ) {
                    throw "The Path argument must be a file. Folder paths are not allowed."
                }
                if ($_ -notmatch "(\.csv)") {
                    throw "The file specified in the path argument must be type csv"
                }
                return $true 
            })]
        [System.IO.FileInfo]
        $InputFilePath
    )
    $userPermission = import-csv -Path $InputFilePath
    # Custom folder creation
    foreach ($u in $userPermission) {
        switch ($u.permissionType) {
            {
                $_ -in (
                    'AvailibilityOnly',
                    'LimitedDetails',
                    'Author',
                    'Contributor',
                    'NonEdititingAuthor',
                    'Owner',
                    'PublishingAuthor',
                    'PublishingEditor',
                    'Reviewer'
                )
            } {
                if ($u.targetFolder -like "*Custom*") {
                    if (-not [string]::IsNullOrEmpty($u.parentFolder)) {
                        New-MailboxFolder -Parent $u.target:Inbox -Name $u.targetFolder
                    }
                    else {
                        New-MailboxFolder -Parent $u.target -Name $u.targetFolder
                    }
                }
            }
        }
    }
    # Permission creation
    foreach ($u in $userPermission) {

        switch ($u.permissionType) {
            {
                $_ -in (
                    'AvailibilityOnly',
                    'LimitedDetails',
                    'Author',
                    'Contributor',
                    'NonEdititingAuthor',
                    'Owner',
                    'PublishingAuthor',
                    'PublishingEditor',
                    'Reviewer'
                )
            } {
                if (-not [string]::IsNullOrEmpty($u.parentFolder)) {
                    $identity = $u.target + ":\" + $u.parentFolder + "\" + $u.targetFolder
                }
                else {
                    $identity = $u.target + ":\" + $u.targetFolder
                }
                Add-MailboxFolderPermission -Identity $identity -User $u.trustee -AccessRights $u.permissionType -Confirm:$false
            }

            {
                $_ -in (
                    'ChangeOwner',
                    'ChangePermission',
                    'DeleteItem',
                    'ExternalAccount',
                    'FullAccess',
                    'ReadPermission'
                )
            } {
                Add-MailboxPermission -Identity $u.target -user $u.trustee -AccessRights $u.permissionType -Confirm:$false
            }

            {
                $_ -in (
                    'SendAs'
                )
            } {
                Add-ADPermission -Identity $u.target -AccessRights ExtendedRight -ExtendedRights $u.permissionType -User $u.trustee -Confirm:$false
            }
            {
                $_ -in (
                    'SendOnBehalf'
                )
            } {
                Set-Mailbox -Identity $u.target GrantSendOnBehalfTo $u.trustee -Confirm:$false
            }
        }
    }
}