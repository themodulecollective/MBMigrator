# Import MBM Module and Configuration
. "E:\Automations\MBMConfiguration.ps1"

#Connect & Prepare the Sessions
. "E:\Automations\ConnectSessions.ps1"

#Archive Old Recipient Data
. "E:\Automations\ArchiveData.ps1" -Operation 'DistributionGroupOwnershipData' -AgeInDays 15

#Get the Sessions
$RequiredSessions = @('PremisesExchange')
switch ($RequiredSessions)
{
    'PremisesExchange'
    {
        $OnPremExchange = Get-PSSession -Name $_
    }
}

$OutputFolderPath = $MBMConfiguration.DistributionGroupOwnershipDataFolder

$Jobs = @(
    Invoke-Command -Session $OnPremExchange -AsJob -JobName ExportOnPremisesDLOwnerData -ScriptBlock {
        Export-ExchangeOPDLOwnership -OutputFolderPath $using:OutputFolderPath -RecipientFilter '*'
        }
)

Wait-Job -Job $Jobs

$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter 'DistributionGroupOwnershipAsOf*.xlsx')

#Truncate the Table Data
$dbiParams = @{
    SQLInstance = $MBMConfiguration.SQLInstance
    Database = $MBMConfiguration.Database
}

#Invoke-DbaQuery @dbiParams -File E:\MBMigration\sql\UpdateHistoryMigrationList.sql
Invoke-DbaQuery @dbiParams -Query 'TRUNCATE TABLE dbo.stagingDistributionGroupOwnership'

foreach ($f in $newDataFiles)
{
	
	Import-Excel $f.Fullname -worksheetName 'Managers' | Convertto-dbaDataTable | Write-dbaDataTable @dbiParams -table stagingDistributionGroupOwnership

}
