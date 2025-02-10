function Export-EntraIDUserDrive {
    <#
    .SYNOPSIS
        Get all EntraID user Drives (OneDrive) and export them to a Excel file
    .DESCRIPTION
        Export all EntraID user Drives and export them to an Excel file. Optional Zip export using $compressoutput switch param. Can specify additional properties to be included in the user export using CustomProperty param.
    .EXAMPLE
        Export-EntraIDUserDrive -OutputFolderPath "C:\Users\UserName\Documents"
        All licensed users with a provisioned OneDrive in the currently connected tenant (Graph) will be exported Documents in the file TenantDomain-UserDrivesAsOfDateString.xlsx

    #>

    [cmdletbinding()]
    param(
        # Folder path for the XLSX or Zip export
        [parameter(Mandatory)]
        [ValidateScript( { Test-Path -type Container -Path $_ })]
        [string]$OutputFolderPath
        ,
        # Compress the XML file into a Zip file
        [parameter()]
        [switch]$CompressOutput
        ,
        [switch]$SuppressErrors #Licensed Users do not always have a OneDrive. Speed up operation by supressing all errors.

    )

    #$TenantID = (Get-MGContext).TenantID
    $TenantDomain = (Get-MGDomain -All).where({$_.IsDefault}).ID.split('.')[0]

    $GetMGUserParams = @{
        Filter = 'assignedLicenses/$count ne 0'
        ConsistencyLevel='eventual'
        CountVariable='licensedUserCount'
        All=$true
        Select='UserPrincipalName','DisplayName','AssignedLicenses','AssignedPlans','ProvisionedPlans','LicenseAssignmentStates','LicenseDetails','UsageLocation','Mail','ID'
    }

    $LicensedUsers = Get-MgUser @GetMGUserParams

    $UserDrives = @(
        $LicensedUsers.foreach({
            $user = $_
            try {
                Get-OGUserDrive -UserPrincipalName $_.UserPrincipalName -PassthruUserPrincipalName -ErrorAction Stop |
                    Select-Object -Property *,@{n='UserID';e={$user.ID}}
            }
            catch {
                switch ($SuppressErrors -eq $true)
                {
                    $true
                    {}
                    $false
                    {Write-Warning -Message $_.ToString()}
                }
            }
        })
    )

    $DateString = Get-Date -Format yyyyMMddhhmmss

    $OutputFileName = $TenantDomain + '-UserDrives' + 'AsOf' + $DateString
    $OutputFilePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.xlsx')
    $ExportExcelParams = @{
        path = $OutputFilePath
        Autosize = $true
        WorksheetName = 'UserDrives'
        TableName = 'UserDrives'
        TableStyle = 'Medium5'
        FreezeTopRow = $true
    }

    $UserDrives | Export-Excel @ExportExcelParams

    if ($CompressOutput) {
        $ArchivePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.zip')

        Compress-Archive -Path $OutputFilePath -DestinationPath $ArchivePath

        Remove-Item -Path $OutputFilePath -Confirm:$false
    }
}