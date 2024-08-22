function Export-IntuneDevice {
    <#
    .SYNOPSIS
        Get all Intune Devices and export to xlsx file.
    .DESCRIPTION
        Export all Intune Devices to an xlsx file. Optional Zip export using $compressoutput switch param. Can specify additional properties to be included in the user export using CustomProperty param.
    .EXAMPLE
        Export-IntuneDevice -OutputFolderPath "C:\Users\UserName\Documents"
        All devices in the currently connected Intune tenant (Graph) will be exported to the Documents folder in the file TenantDomain-IntuneDevicesAsOfDateString.xlsx
    #>

    [cmdletbinding()]
    param(
        # Folder path for the xlsx or Zip export
        [parameter(Mandatory)]
        [ValidateScript( { Test-Path -type Container -Path $_ })]
        [string]$OutputFolderPath
        ,
        # Include custom attribute to the exported device attributes
        [parameter()]
        [string[]]$CustomProperty
        ,
        # Compress the xlsx file into a Zip file
        [parameter()]
        [switch]$CompressOutput

    )

    #$TenantID = (Get-MGContext).TenantID
    $TenantDomain = (Get-MGDomain -All).where({$_.IsDefault}).ID.split('.')[0]

    $Properties = @(
        'AzureAdDeviceId',
        'ActivationLockBypassCode',
        'AndroidSecurityPatchLevel',
        'AzureAdRegistered',
        'ComplianceGracePeriodExpirationDateTime',
        'ComplianceState',
        'DeviceCategoryDisplayName',
        'DeviceEnrollmentType',
        'DeviceName',
        'DeviceRegistrationState',
        'EasActivated',
        'EasActivationDateTime',
        'EasDeviceId',
        'EmailAddress',
        'EnrolledDateTime',
        'EnrollmentProfileName',
        'EthernetMacAddress',
        'ExchangeAccessState',
        'ExchangeAccessStateReason',
        'ExchangeLastSuccessfulSyncDateTime',
        'FreeStorageSpaceInBytes',
        'Iccid',
        'Id',
        'Imei',
        'IsEncrypted',
        'IsSupervised',
        'JailBroken',
        'LastSyncDateTime',
        'LogCollectionRequests',
        'ManagedDeviceName',
        'ManagedDeviceOwnerType',
        'ManagementAgent',
        'ManagementCertificateExpirationDate',
        'Manufacturer',
        'Meid',
        'Model',
        'Notes',
        'OperatingSystem',
        'OSVersion',
        'PartnerReportedThreatState',
        'PhoneNumber',
        'PhysicalMemoryInBytes',
        'RemoteAssistanceSessionErrorDetails',
        'RemoteAssistanceSessionUrl',
        'RequireUserEnrollmentApproval',
        'SerialNumber',
        'SubscriberCarrier',
        'TotalStorageSpaceInBytes',
        'Udid',
        'UserDisplayName',
        'UserId',
        'UserPrincipalName',
        'Users',
        'WiFiMacAddress'
    )

    $Properties = @(@($Properties;$CustomProperty) | Sort-Object -Unique)

    $DateString = Get-Date -Format yyyyMMddhhmmss

    $OutputFileName = $TenantDomain + '-IntuneDevices' + 'AsOf' + $DateString
    $OutputFilePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.xlsx')
    $ExportExcelParams = @{
        path = $OutputFilePath
        Autosize = $true
        WorksheetName = 'IntuneDevices'
        TableName = 'IntuneDevices'
        TableStyle = 'Medium5'
        FreezeTopRow = $true
    }

    $Devices = @(Get-MgDeviceManagementManagedDevice | Select-Object -Property @($Properties;@{n='TenantDomain';e={$TenantDomain}}))

    $Devices | Export-Excel @ExportExcelParams

    if ($CompressOutput) {
        $ArchivePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.zip')

        Compress-Archive -Path $OutputFilePath -DestinationPath $ArchivePath

        Remove-Item -Path $OutputFilePath -Confirm:$false
    }
}