[cmdletbinding()]
param(
[parameter()]
[ValidateSet('RecipientData','MailboxData','ADUserData','ExchangeMobileDeviceData','AzureADUserData','PermissionData','MoveRequestData','AzureADUserLicensingData','DistributionGroupOwnershipData','DollarGroupMembershipData')]
[string]$Operation
,
[int]$AgeInDays
)

# Select the folder to archive from 
Switch ($Operation)
{
	'RecipientData'
	{
		$Folder = $MBMConfiguration.RecipientDataExportFolder
	}
	'MailboxData'
	{
		$Folder = $MBMConfiguration.MailboxDataExportFolder
	}
	'ADUserData'
	{
		$Folder = $MBMConfiguration.ADUserDataExportFolder
	}
	'ExchangeMobileDeviceData'
	{
		$Folder = $MBMConfiguration.ExchangeMobileDeviceDataFolder
	}	
	'AzureADUserData'
	{
		$Folder = $MBMConfiguration.AzureADUserDataExportFolder
	}
	'PermissionData'
	{
		$Folder = $MBMConfiguration.ExchangePermissionDataFolder
	}	
	'MoveRequestData'
	{
		$Folder = $MBMConfiguration.MoveRequestDataExportFolder
	}	
	'AzureADUserLicensingData'
	{
		$Folder = $MBMConfiguration.AzureADUserLicensingDataFolder
	}
	'DistributionGroupOwnershipData'
	{
		$Folder = $MBMConfiguration.DistributionGroupOwnershipDataFolder
	}
	'DollarGroupMembershipData'
	{
		$Folder = $MBMConfiguration.DollarGroupMembershipDataFolder
	}
}
# archive the old data

$ArchiveFolder = Join-Path -Path $Folder -Childpath 'Archive'

Get-ChildItem -Path $Folder -file  | Move-Item -Destination $ArchiveFolder -Confirm:$false

# delete older files from the archive folder

$today = get-date
$olderthandate = $today.AddDays(-$AgeInDays)

Get-ChildItem -Path $ArchiveFolder | 
    Where-Object -FilterScript {$_.CreationTime -lt $olderthandate} |
    Remove-Item -Confirm:$false