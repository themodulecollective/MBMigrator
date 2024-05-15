Function Get-MBMWaveMoveRequest {
    <#
.SYNOPSIS
    Gets all move requests for a specified wave
.DESCRIPTION
    Gets all move requests for a specified wave. Provides the option to store results in a global variable.
.EXAMPLE
    Get-MBMWaveMoveRequest -Wave "1.1"
    Gets all move requests for wave "1.1"
#>

    [cmdletbinding()]
    param(
        #
        [string]$Wave
        ,
        #
        [switch]$Global
    )

    $MR = @(Get-MoveRequest -batchName $Wave -ResultSize Unlimited)
    switch ($Global) {
        $true {
            $WaveMRVariableName = $("WaveMR" + $Wave.Replace('.', '_'))
            New-Variable -Name $WaveMRVariableName -Scope Global -Value $MR -Force
        }
        $false {
            $MR
        }
    }



}
