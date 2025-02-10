Function Get-MBMWaveMember {
    <#
.SYNOPSIS
    Gets the Mailbox Migration List for the specified wave
.DESCRIPTION
    Gets the Mailbox Migration List for the specified wave and give the option to store the returned list in a global variable.
.EXAMPLE
    Get-MBMWaveMember -Wave "1.1"
    Gets the Mailbox Migration List for wave 1.1
#>

    param(
        #
        [string]$Wave
        ,
        #
        [parameter()]
        [switch]$Global
    )
    switch ($null -ne $MigrationList -and $MigrationList.count -ge 1)
    {
        $true
        {
            $WaveData = @($MigrationList.Where( { $_.AssignedWave -eq $Wave }))
            switch ($Global) {
                $true
                {
                    $GlobalName = $('Wave' + $Wave.Replace('.', '_'))
                    New-Variable -Name $GlobalName -Value $WaveData -Scope Global -Force
                }
                $false
                {
                    $WaveData
                }
            }
        }
        $false
        {
            throw('You must run Get-MBMMigrationList before running this command.')
        }
    }

}