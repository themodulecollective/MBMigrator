function Get-WaveMoveRequestStatisticsVariableValue {
    <#
    .SYNOPSIS
        Gets the value for the wave varible containing the wave move request statistics
    .DESCRIPTION
        Gets the value for the wave varible containing the wave move request statistics
    .EXAMPLE
        Get-WaveMoveRequestStatisticsVariableValue -Wave "1.1"
        Returns the stored value for the wave move request statistics variable of wave 1.1
    #>

    [cmdletbinding()]
    param(
        #
        [string]$Wave
    )

    $WaveVariableName = $("WaveMRS" + $Wave.Replace('.', '_'))

    try {
        $WaveVariable = Get-Variable -Name $WaveVariableName -Scope Global -ErrorAction Stop
    }
    catch {
        Get-MBMWaveMoveRequestStatistics -Wave $Wave -Global
        $WaveVariable = Get-Variable -Name $WaveVariableName -Scope Global -ErrorAction Stop
    }

    $WaveVariable.value

}