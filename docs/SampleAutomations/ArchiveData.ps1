[cmdletbinding()]
param(
[parameter()]
[ValidateSet(
	'RecipientData'
	,'MailboxData'
	,'MailboxStatsData'
	,'ADUserData'
	,'ADGroupData'
	,'ADComputerData'
	,'EXOMobileDeviceData'
	,'EntraIDUserData'
	,'EntraIDGroupData'
	,'EntraIDUserDriveData'
	,'EXOPermissionData'
	,'EntraIDUserLicensingData'
	,'EntraIDGroupLicensingData'
	,'WorkdayData'
	,'UserDriveDetailsData'
	,'IntuneDeviceData'
	,'UnifiedGroupDriveData'
	,'UnifiedGroupRoleData'
	,'MigrationGroupMembershipData'
	,'EntraUserRegistrationData'
	,'FlyUserProjectMappingData'
	)]
[string]$Operation
,
[int]$AgeInDays
)

# Select the folder to archive from 
Switch ($Operation)
{
	'RecipientData'
	{
		$Folder = $MBMConfiguration.RecipientDataFolder
	}
	'MailboxData'
	{
		$Folder = $MBMConfiguration.MailboxDataFolder
	}
	'MailboxStatsData'
	{
		$Folder = $MBMConfiguration.MailboxStatsDataFolder
	}
	'ADUserData'
	{
		$Folder = $MBMConfiguration.ADUserDataFolder
	}
	'ADGroupData'
	{
		$Folder = $MBMConfiguration.ADGroupDataFolder
	}
	'ADComputerData'
	{
		$Folder = $MBMConfiguration.ADComputerDataFolder
	}
	'EXOMobileDeviceData'
	{
		$Folder = $MBMConfiguration.EXOMobileDeviceDataFolder
	}	
	'EntraIDUserData'
	{
		$Folder = $MBMConfiguration.EntraIDUserDataFolder
	}
	'EntraIDUserDriveData'
	{
		$Folder = $MBMConfiguration.EntraIDUserDriveDataFolder
	}
	'EntraIDGroupData'
	{
		$Folder = $MBMConfiguration.EntraIDGroupDataFolder
	}
	'EXOPermissionData'
	{
		$Folder = $MBMConfiguration.EXOPermissionDataFolder
	}	
	'EntraIDUserLicensingData'
	{
		$Folder = $MBMConfiguration.EntraIDUserLicensingDataFolder
	}
	'EntraIDGroupLicensingData'
	{
		$Folder = $MBMConfiguration.EntraIDGroupLicensingDataFolder
	}
	'WorkdayData'
	{
		$Folder = $MBMConfiguration.WorkdayDataFolder
	}
	'UserDriveDetailsData'
	{
		$Folder = $MBMConfiguration.UserDriveDetailsDataFolder
	}
	'IntuneDeviceData'
	{
		$Folder = $MBMConfiguration.IntuneDeviceDataFolder
	}
	'UnifiedGroupDriveData'
	{
		$Folder = $MBMConfiguration.UnifiedGroupDriveDataFolder
	}
	'UnifiedGroupRoleData'
	{
		$Folder = $MBMConfiguration.UnifiedGroupRoleDataFolder
	}
	'MigrationGroupMembershipData'
	{
		$Folder = $MBMConfiguration.MigrationGroupMembershipDataFolder
	}
	'EntraUserRegistrationData'
	{
		$Folder = $MBMConfiguration.EntraUserRegistrationDataFolder
	}
	'FlyUserProjectMappingData'
	{
		$folder = $MBMConfiguration.FlyUserProjectMappingDataFolder
	}
}
# archive the old data

$ArchiveFolder = Join-Path -Path $Folder -Childpath 'Archive'

Get-ChildItem -Path $Folder -file  | Move-Item -Destination $ArchiveFolder -Confirm:$false

# delete older files from the archive folder

$today = get-date
$olderthandate = $today.AddDays(-$AgeInDays)

Get-ChildItem -Path $ArchiveFolder -File | 
    Where-Object -FilterScript {$_.CreationTime -lt $olderthandate} |
    Remove-Item -Confirm:$false