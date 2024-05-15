Import-Module 'E:\MBMigrator\MBMigrator\MBMigrator.psd1' -force
switch (whoami)
{
	'username'
	{$Credential = Import-Clixml -path 'E:\Automations\$(new-guid).xml'}
}

Set-MBMConfiguration -Attribute MBMModulePath -Value "E:\MBMigrator\MBMigrator\MBMigrator.psd1"
Set-MBMConfiguration -Attribute SQLInstance -Value 'localhost\SQLExpress'
Set-MBMConfiguration -Attribute Database -Value 'MBMigrator'
Set-MBMConfiguration -Attribute OrgMap -Value @{$(new-guid) = 'OL';$(new-guid)='OP'}
Set-MBMConfiguration -Attribute Endpoint -Value 'on premises exchange endpoint'
Set-MBMConfiguration -Attribute TargetDeliveryDomain -Value 'customerdomain.mail.onmicrosoft.com'
Set-MBMConfiguration -Attribute TenantID -Value '$(new-guid)'
Set-MBMConfiguration -Attribute TenantDomain -Value 'customerdomain.onmicrosoft.com'
Set-MBMConfiguration -Attribute ReverseMoveDeliveryDomain -Value 'customerdomain'
Set-MBMConfiguration -Attribute ReverseMoveTargetDatabase -Value 'customer exchange database'
Set-MBMConfiguration -Attribute CertificateThumbprint -Value 'cert thumbprint'
Set-MBMConfiguration -Attribute ReportingAppID -Value '$(new-guid)'
Set-MBMConfiguration -Attribute ConfigurationAppID -Value '$(new-guid)'
Set-MBMConfiguration -Attribute AutomationExchangeServer -Value 'onPremServerName'
Set-MBMConfiguration -Attribute ExchangeServers -Value @('On Prem Exchange Server','On Prem Exchange Server')
Set-MBMConfiguration -Attribute OnPremCredential -Value $Credential
Set-MBMConfiguration -Attribute RecipientDataExportFolder -Value 'F:\RecipientData'
Set-MBMConfiguration -Attribute MailboxDataExportFolder -Value 'F:\MailboxData'
Set-MBMConfiguration -Attribute ADUserDataExportFolder -Value 'F:\ADUserData'
Set-MBMConfiguration -Attribute ADUserDomain -Value 'ADDomainName'
Set-MBMConfiguration -Attribute ExchangeMobileDeviceDataFolder -Value 'F:\ExchangeMobileDeviceData'
Set-MBMConfiguration -Attribute ExchangePermissionDataFolder -Value 'F:\PermissionData'
Set-MBMConfiguration -Attribute AzureADUserDataExportFolder -Value 'F:\AzureADUserData'
Set-MBMConfiguration -Attribute MoveRequestDataExportFolder -Value 'F:\MoveRequestData'
Set-MBMConfiguration -Attribute AzureADUserLicensingDataFolder -Value 'F:\LicensingData'
Set-MBMConfiguration -Attribute ExchangePermissionsExportModulePath -Value 'E:\ExchangePermissionsExport\ExchangePermissionsExport\ExchangePermissionsExport.psd1'
Set-MBMConfiguration -Attribute DistributionGroupOwnershipDataFolder -Value 'F:\DistributionGroupOwnershipData'
Set-MBMConfiguration -Attribute DollarGroupMembershipDataFolder -Value "F:\DollarGroupMembershipData"

$MBMConfiguration = Get-MBMConfiguration

$Global:idbParams = @{
    SQLInstance = $MBMConfiguration.SQLInstance
    Database = $MBMConfiguration.Database
}