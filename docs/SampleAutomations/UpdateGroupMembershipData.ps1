# Import MBM Module and Configuration
. "E:\Automations\MBMConfiguration.ps1"

#Archive Old Recipient Data
. "E:\Automations\ArchiveData.ps1" -Operation DollarGroupMembershipData -AgeInDays 15

$OutputFolderPath = $MBMConfiguration.DollarGroupMembershipDataFolder

# Get the Data
Import-Module ActiveDirectory
$AllADGroups = Get-ADGroup -Filter *
$DollarGroups = $AllADGroups.where({$_.Name -like '$*'})
$DollarGroupsDetail = $DollarGroups.foreach({Get-ADGroup -Identity $_.Name -Properties Description,AdminDescription})
$DollarGroupMembers = $DollarGroupsDetail.foreach({
		$Group,$GroupDescription,$GroupAdminDescription = $_.Name,$_.Description,$_.AdminDescription; 
		Get-ADGroupMember -Identity $_.Name -Recursive | 
			Select-object -Property *,@{n='GroupName';e={$Group}},@{n='GroupDescription';e={$GroupDescription}},@{n='GroupAdminDescription';e={$GroupAdminDescription}}
	})


#Export the Data
$DateString = Get-Date -Format yyyyMMddHHmmss
$DollarGroupMembersFileName = 'DollarGroupMembersAsOf' + $DateString + '.xlsx'
$DollarGroupMembersFilePath = Join-Path -path $OutputFolderPath -childpath $DollarGroupMembersFileName
$DollarGroupMembers | Export-Excel -path $DollarGroupMembersFilePath -Table DollarGroupMembers -WorksheetName DollarGroupMembers -TableStyle Medium2

#Truncate the Table Data
$dbiParams = @{
    SQLInstance = $MBMConfiguration.SQLInstance
    Database = $MBMConfiguration.Database
}

Invoke-DbaQuery @dbiParams -Query 'TRUNCATE TABLE dbo.WaveGroupMemberships'	

$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter 'DollarGroupMembersAsOf*.xlsx')


foreach ($f in $newDataFiles)
{
    Import-Excel -Path $f.fullname | Select-Object -excludeProperty RunspaceID,PS* | ConvertTo-DbaDataTable | Write-DbaDataTable @idbParams -Table WaveGroupMemberships
}
