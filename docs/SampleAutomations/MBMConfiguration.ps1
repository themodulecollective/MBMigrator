Import-Module "C:\GitRepos\MBMigrator\MBMigrator\MBMigrator.psd1" -force

Import-Module Logging
Add-LoggingTarget -name File -Configuration @{Path = 'c:\migration\logs\general_%{+%Y%m%d}.log'; LEVEL = 'INFO'}

Set-MBMConfiguration -Attribute MBMModulePath -Value "C:\GitRepos\MBMigrator\MBMigrator\MBMigrator.psd1"
Set-MBMConfiguration -Attribute SPMModulePath -Value "C:\GitRepos\SPMigrator\SPMigrator\SPMigrator.psd1"
Set-MBMConfiguration -Attribute ExchangePermissionsExportModulePath -Value "C:\GitRepos\ExchangePermissionsExport\ExchangePermissionsExport\ExchangePermissionsExport.psd1"
Set-MBMConfiguration -Attribute SQLInstance -Value 'localhost'
Set-MBMConfiguration -Attribute QMigSQLInstance -Value 'Migrator\SQLExpress'
Set-MBMConfiguration -Attribute QMigDatabase -Value 'DirSyncPro'
Set-MBMConfiguration -Attribute Database -Value 'Migration'
Set-MBMConfiguration -Attribute SourceADUserDomains -Value 'sourcedomain1','sourcedomain2','sourcedomain3'
Set-MBMConfiguration -Attribute TargetADUserDomains -Value 'targetdomain'
Set-MBMConfiguration -Attribute TargetDeliveryDomain -Value 'target.mail.onmicrosoft.com'
Set-MBMConfiguration -Attribute SourceTenantID -Value 'GUID'
Set-MBMConfiguration -Attribute TargetTenantID -Value 'GUID'
Set-MBMConfiguration -Attribute TargetTenantDomain -Value 'target.onmicrosoft.com'
Set-MBMConfiguration -Attribute SourceTenantDomain -Value 'source.onmicrosoft.com'
Set-MBMConfiguration -Attribute ReverseMoveDeliveryDomain -Value 'source.mail.onmicrosoft.com'
Set-MBMConfiguration -Attribute CertificateThumbprint -Value 'Thumbprint'
Set-MBMConfiguration -Attribute CertificatePFXFile -Value 'C:\Migration\Certificates\SQLSelfSigned.pfx'
Set-MBMConfiguration -Attribute SourceTenantReportingAppID -Value 'GUID'
Set-MBMConfiguration -Attribute TargetTenantReportingAppID -Value 'GUID'
Set-MBMConfiguration -Attribute SourceTenantSPOAdmin -Value 'https://source-admin.sharepoint.com/'
Set-MBMConfiguration -Attribute TargetTenantSPOAdmin -Value 'https://target-admin.sharepoint.com/'
Set-MBMConfiguration -Attribute SourceAutomationExchangeServer -Value 'source.local'
Set-MBMConfiguration -Attribute TargetAutomationExchangeServer -Value 'target.local'
Set-MBMConfiguration -Attribute SourceSMTPDomains -Value @('source.onmicrosoft.com','source.mail.onmicrosoft.com')
Set-MBMConfiguration -Attribute WorkdayDataFolder -Value 'C:\Migration\Data\Workday'
Set-MBMConfiguration -Attribute WorkfoldersDataFolder -Value 'C:\Migration\Data\Workfolders'
Set-MBMConfiguration -Attribute RecipientDataFolder -Value 'C:\Migration\Data\Recipient'
Set-MBMConfiguration -Attribute MailboxDataFolder -Value 'C:\Migration\Data\Mailbox'
Set-MBMConfiguration -Attribute MailboxStatsDataFolder -Value 'C:\Migration\Data\MailboxStats'
Set-MBMConfiguration -Attribute ADUserDataFolder -Value 'C:\Migration\Data\ADUser'
Set-MBMConfiguration -Attribute ADGroupDataFolder -Value 'C:\Migration\Data\ADGroup'
Set-MBMConfiguration -Attribute ADComputerDataFolder -Value 'C:\Migration\Data\ADComputer'
Set-MBMConfiguration -Attribute EXOMobileDeviceDataFolder -Value 'C:\Migration\Data\EXOMobileDevice'
Set-MBMConfiguration -Attribute EXOPermissionDataFolder -Value 'C:\Migration\Data\EXOPermissions'
Set-MBMConfiguration -Attribute EXODistributionGroupDataFolder -Value 'C:\Migration\Data\EXODistributionGroup'
Set-MBMConfiguration -Attribute EntraIDUserDataFolder -Value 'C:\Migration\Data\EntraIDUser'
Set-MBMConfiguration -Attribute EntraIDUserDriveDataFolder -Value 'C:\Migration\data\OneDrive'
Set-MBMConfiguration -Attribute IntuneDeviceDataFolder -Value 'C:\Migration\data\IntuneDevice'
Set-MBMConfiguration -Attribute UserDriveDetailsDataFolder -Value 'C:\Migration\data\UserDriveDetails'
Set-MBMConfiguration -Attribute EntraIDGroupDataFolder -Value 'C:\Migration\Data\EntraIDGroup'
Set-MBMConfiguration -Attribute EntraIDUserLicensingDataFolder -Value 'C:\Migration\Data\EntraIDUserLicensing'
Set-MBMConfiguration -Attribute EntraIDGroupLicensingDataFolder -Value 'C:\Migration\Data\EntraIDGroupLicensing'
Set-MBMConfiguration -Attribute UnifiedGroupDriveDataFolder -Value 'C:\Migration\Data\UnifiedGroupDrive'
Set-MBMConfiguration -Attribute UnifiedGroupRoleDataFolder -Value 'C:\Migration\Data\UnifiedGroupRole'
Set-MBMConfiguration -Attribute ADUserAttributes -Value 'AccountExpires','AltRecipient','C','CN','CO','Comment','FacsimileTelephoneNumber','HomePhone','Mobile','Pager','PersonalTitle','ST','Street','TelephoneNumber','Title','msExchUsageLocation'
Set-MBMConfiguration -Attribute ADComputerAttributes -Value @()
Set-MBMConfiguration -Attribute SourceTenantRelevantSKUs -value @('skuGUIDs')
Set-MBMConfiguration -Attribute SourceTenantRelevantServicePlans -value @('PlanGUIDs')
Set-MBMConfiguration -Attribute TargetTenantRelevantSKUs -value @('skuGUIDs')
Set-MBMConfiguration -Attribute TargetTenantRelevantServicePlans -value @('PlanGUIDs')
Set-MBMConfiguration -Attribute WavePlanningSiteURL -Value "https://target.sharepoint.com/sites/MigrationLists"
Set-MBMConfiguration -Attribute WavePlanningSiteID -Value 'siteGUID'
Set-MBMConfiguration -Attribute UserMigrationListID -Value 'listGUID'
Set-MBMConfiguration -Attribute TargetTenantPNPInteractiveClientID -Value 'clientGUID'
Set-MBMConfiguration -Attribute FlyApiApplicationID -Value 'appGUID'
Set-MBMConfiguration -Attribute FlyApiURL -Value 'https://graph-us.avepointonlineservices.com/fly'
Set-MBMConfiguration -Attribute MigrationGroupMembershipDataFolder -Value 'C:\Migration\Data\MigrationGroupMembership'
Set-MBMConfiguration -Attribute EntraUserRegistrationDataFolder -Value 'C:\Migration\Data\EntraUserRegistration'
Set-MBMConfiguration -Attribute FlyUserProjectMappingDataFolder -Value 'C:\Migration\Data\FlyUserProjectMapping'
Set-MBMConfiguration -Attribute skuReadableFilePath -value 'C:\Migration\Data\EntraIDUserLicensing\skuReadable\skuReadable.xml'
Set-MBMConfiguration -Attribute RealFlyModulePath -Value C:\GitRepos\RealFly\RealFly.psd1
Set-MBMConfiguration -Attribute sourcedomainPreferredDC -Value 'dc fqdn'
Set-MBMConfiguration -Attribute targetdomainPreferredDC -Value 'dc fqdn'

$MBMConfiguration = Get-MBMConfiguration

$Global:idbParams = @{
    SQLInstance = $MBMConfiguration.SQLInstance
    Database = $MBMConfiguration.Database
}


$Global:QdbParams = @{
    SQLInstance = $MBMConfiguration.QMigSQLInstance
    Database = $MBMConfiguration.QMigDatabase
}


