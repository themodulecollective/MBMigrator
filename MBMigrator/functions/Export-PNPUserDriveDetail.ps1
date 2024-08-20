function Export-PNPUserDriveDetail {
    <#
    .SYNOPSIS
        Get all PNP user Drives (OneDrive) with Usage data  and export them to a Excel file
    .DESCRIPTION
        Export all EntraID user Drives and export them to an Excel file. Optional Zip export using $compressoutput switch param. Can specify additional properties to be included in the user export using CustomProperty param.
    .EXAMPLE
        Export-PNPUserDriveDetail -OutputFolderPath "C:\Users\UserName\Documents"
        All OneDrive sites in the currently connected PNP.Powershell tenant will be exported Documents in the file TenantDomain-UserDrivesAsOfDateString.xlsx

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
    $TenantDomain = $(Get-PNPTenantInfo).DefaultDomainName.split('.')[0]

    $GetPNPTenantSiteParams = @{
        Filter = "Url -like '-my.sharepoint.com/personal/'"
        IncludeOneDriveSites = $true
        Detaild = $true
    }

    $UserDrivesRaw = Get-PnPTenantSite @GetPNPTenantSiteParams

    $UserDrives = @(
        $UserDrivesRaw | Select-object -Property *,
            @{n='UsageInGB';e={[MATH]::Round($_.StorageUsageCurrent * 1MB / 1GB,2)}},
            @{n='QuotaInGB';e={[MATH]::Round($_.StorageQuata * 1MB / 1GB,2)}}

    )

    $DateString = Get-Date -Format yyyyMMddhhmmss

    $OutputFileName = $TenantDomain + '-UserDriveDetails' + 'AsOf' + $DateString
    $OutputFilePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.xlsx')
    $ExportExcelParams = @{
        path = $OutputFilePath
        Autosize = $true
        WorksheetName = 'UserDriveDetails'
        TableName = 'UserDriveDetails'
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