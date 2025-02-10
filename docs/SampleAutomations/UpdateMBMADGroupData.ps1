# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"

#Archive Old Recipient Data
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation ADGroupData -AgeInDays 30

$Jobs = @(
    foreach ($d in @($MBMConfiguration.SourceADUserDomains;$MBMConfiguration.TargetADUserDomains))
    {
        $Credential =  switch ($d)
        {
            'Domain'
            {Import-Clixml -path "DomainCredential"}
        }
        Start-Job -ArgumentList $MBMConfiguration,$d -Credential $Credential -Name "Export $d Groups" -ScriptBlock  {
            param(
                $MBMConfiguration = $args[0],
                $Domain = $args[1]
            )
            Import-Module ActiveDirectory
            Import-Module $MBMConfiguration.MBMModulePath
            Export-ADGroup -OutputFolderPath $MBMConfiguration.ADGroupDataFolder -Domain $Domain -Exchange:$true
        }
    }
)

Wait-Job -ID $Jobs.Id

$OutputFolderPath = $MBMConfiguration.ADGroupDataFolder

$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *ADGroupsAsOf*.xml)

Write-Verbose -Message "Updating Database with AD Groups from $($newDataFiles.fullname -join ';')" -Verbose
Update-MBMActiveDirectoryData -Operation ADGroup -FilePath $newDataFiles -InformationAction Continue -AutoCreate

