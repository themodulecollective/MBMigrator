# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"
$ThisTask = Split-Path -Path $PSCommandPath -Leaf
Write-Log -Level INFO -Message "Task $ThisTask Imported Migration Manager Module and Configuration"
$d = 'value of preferred domain controller for the domain'

Write-Log -Level INFO -Message "Task $ThisTask using Domain Controller $d"

Write-Log -Level INFO -Message "Task $ThisTask Running: Start Jobs Export Users, Groups, and Computers"

$Jobs = @(

Start-Job -ArgumentList $MBMConfiguration,$d -Name "Export $d Users" -ScriptBlock  {
    param(
        $MBMConfiguration = $args[0],
        $Domain = $args[1]
    )
    Import-Module ActiveDirectory
    Import-Module $MBMConfiguration.MBMModulePath
    Export-ADUser -OutputFolderPath $MBMConfiguration.ADUserDataFolder -Domain $Domain -Exchange:$true -CustomProperty $MBMConfiguration.ADUserAttributes
}

Start-Job -ArgumentList $MBMConfiguration,$d -Name "Export $d Groups" -ScriptBlock  {
    param(
        $MBMConfiguration = $args[0],
        $Domain = $args[1]
    )
    Import-Module ActiveDirectory
    Import-Module $MBMConfiguration.MBMModulePath
    Export-ADGroup -OutputFolderPath $MBMConfiguration.ADGroupDataFolder -Domain $Domain -Exchange:$true
}

Start-Job -ArgumentList $MBMConfiguration,$d -Name "Export $d Computers" -ScriptBlock  {
    param(
        $MBMConfiguration = $args[0],
        $Domain = $args[1]
    )
    Import-Module ActiveDirectory
    Import-Module $MBMConfiguration.MBMModulePath
    Export-ADComputer -OutputFolderPath $MBMConfiguration.ADComputerDataFolder -Domain $Domain
}

)

Write-Log -Level INFO -Message "Task $ThisTask Waiting: for Jobs $($Jobs.Name -join ',')"
Wait-Job -ID $Jobs.Id
Write-Log -Level INFO -Message "Task $ThisTask Completed: Jobs $($Jobs.name -join ',')"
Wait-Logging