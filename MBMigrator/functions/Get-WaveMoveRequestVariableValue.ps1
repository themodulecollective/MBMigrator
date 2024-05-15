function Get-WaveMoveRequestVariableValue {
    <#
        .SYNOPSIS
        Gets the value for the wave varible containing the wave move requests
    .DESCRIPTION
        Gets the value for the wave varible containing the wave move requests
    .EXAMPLE
        Get-WaveMoveRequestVariableValue -Wave "1.1"
        Returns the stored value for the wave move request variable of wave 1.1
    #>

    [cmdletbinding()]
    param(
        #
        [string]$Wave
    )

    $WaveVariableName = $("WaveMR" + $Wave.Replace('.', '_'))

    try {
        $WaveVariable = Get-Variable -Name $WaveVariableName -Scope Global -ErrorAction Stop
    }
    catch {
        Get-MBMWaveMoveRequest -Wave $Wave -Global
        $WaveVariable = Get-Variable -Name $WaveVariableName -Scope Global -ErrorAction Stop
    }

    $WaveVariable.value

}