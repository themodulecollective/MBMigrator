# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"

#Archive Old Recipient Data
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation ADComputerData -AgeInDays 30

$Jobs = @(
    foreach ($d in @($MBMConfiguration.SourceADUserDomains;$MBMConfiguration.TargetADUserDomains))
    {
        try {
            $logmessage = "Import Credential for $d"
            Write-Log -Level INFO -Message "Attempting: $logmessage"
            $Credential =  switch ($d)
            {
                'Domain'
                {Import-Clixml -path "DomainCredential"}
            }
            Write-Log -Level INFO -Message "Success: $logmessage"
        }
        catch {
            Write-Log -Level WARNING -Message "Failure: $logmessage"
            Write-Log -Level ERROR -Message $_.ToString()
            throw($_)
        }
        $logmessage = "Start Job for $d"
        try {
            Write-Log -Level INFO -Message "Attempting: $logmessage"
            Start-Job -ArgumentList $MBMConfiguration,$d -Credential $Credential -Name "Export $d Computers" -ScriptBlock  {
                param(
                    $MBMConfiguration = $args[0],
                    $Domain = $args[1]
                )
                Import-Module ActiveDirectory
                Import-Module $MBMConfiguration.MBMModulePath
                Export-ADComputer -OutputFolderPath $MBMConfiguration.ADComputerDataFolder -Domain $Domain
            }
            Write-Log -Level INFO -Message "Success: $logmessage"
        }
        catch {
            Write-Log -Level WARNING -Message "Failure: $logmessage"
            Write-Log -Level ERROR -Message $_.ToString()
            throw($_)
        }
    }
)

Write-Log -Level INFO -Message "Waiting for Jobs $($Jobs.Name -join ',') to complete"
Wait-Job -ID $Jobs.Id
Write-Log -Level INFO -Message "Jobs $($Jobs.name -join ',') Completed"


Write-Log -Level INFO -Message "Getting Newly Exported Files"
$OutputFolderPath = $MBMConfiguration.ADComputerDataFolder
$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *ADComputersAsOf*.xml)
Write-Log -Message "Updating Database with AD Computers from $($newDataFiles.fullname -join ';')" -Verbose  -Level INFO
Update-MBMActiveDirectoryData -Operation ADComputer -FilePath $newDataFiles -InformationAction Continue -Truncate

