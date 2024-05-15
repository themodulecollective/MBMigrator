function Get-WaveMemberVariableValue {
    <#
    .SYNOPSIS
        Create the wave variable for a specified wave
    .DESCRIPTION
        Takes a wave name like 1.1 and creates a standardized wave variable
    .EXAMPLE
        Get-WaveMemberVariableValue -Wave "1.1"
        Takes wave 1.1 and creates the global variable $WaveVariable = "Wave1_1"
    #>

    [cmdletbinding()]
    param(
        #
        [string]$Wave
    )
    $WaveVariableName = $("Wave" + $Wave.Replace('.', '_'))

    try {
        $WaveVariable = Get-Variable -Name $WaveVariableName -Scope Global -ErrorAction Stop
    }
    catch {
        Get-MBMWaveMember -Wave $Wave -Global
        $WaveVariable = Get-Variable -Name $WaveVariableName -Scope Global -ErrorAction Stop
    }

    $WaveVariable.value

}