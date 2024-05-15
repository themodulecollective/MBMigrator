# Import MBM Module and Configuration
. "E:\Automations\MBMConfiguration.ps1"

#Archive Old Recipient Data
. "E:\Automations\ArchiveData.ps1" -Operation PermissionData -AgeInDays 45

$ExchangeServer = $MBMConfiguration.AutomationExchangeServer
$OnPremCredential = $MBMConfiguration.OnPremCredential
$OutputFolderPath = $MBMConfiguration.ExchangePermissionDataFolder
$Organization = $MBMConfiguration.TenantDomain
$AppID = $MBMConfiguration.ReportingAppID
$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint
$EPEModulePath = $MBMConfiguration.ExchangePermissionsExportModulePath

$Jobs = @(
Start-Job -PSVersion '5.1' -Name "ExportOPPermissions" -ScriptBlock {
    Import-Module ActiveDirectory
    $AD = Get-PSDrive -PSProvider ActiveDirectory
    Import-Module $Using:EPEModulePath
    Connect-ExchangeOrganization -OnPremises -ExchangeOnPremisesServer $Using:ExchangeServer -Credential $using:OnPremCredential
    Export-ExchangePermission -OutputFolderPath $Using:OutputFolderPath -AllMailboxes -IncludeSendOnBehalf -IncludeFullAccess -IncludeSendAs -IncludeCalendar -IncludeAutoMapping -IncludeAutoMappingSetting -ActiveDirectoryDrive $AD -ExcludeNonePermissionOutput
} 

Start-Job -Name "ExportOLPermissions" -ScriptBlock {
	Import-Module $Using:EPEModulePath
	$ConnectExchangeOnlineParams = @{
		Organization = $using:Organization 
		AppID = $using:AppID
		CertificateThumbprint = $using:CertificateThumbprint
	}
	Connect-ExchangeOrganization -Online -ConnectExchangeOnlineParams $ConnectExchangeOnlineParams
    Export-ExchangePermission -OutputFolderPath $Using:OutputFolderPath -AllMailboxes -IncludeSendOnBehalf -IncludeFullAccess -IncludeSendAs -IncludeCalendar -IncludeAutoMapping -IncludeAutoMappingSetting -ExcludeNonePermissionOutput
}  
)

Wait-Job -Job $Jobs

Update-MBMPermissionData -InputFolderPath $OutputFolderPath -Truncate -InformationAction Continue