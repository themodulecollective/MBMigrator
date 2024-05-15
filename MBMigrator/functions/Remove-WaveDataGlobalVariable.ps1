Function Remove-WaveDataGlobalVariable {
    <#
    .SYNOPSIS
        Removes all global wave variables
    .DESCRIPTION
        Removes all global wave variables. Ex. $Wave1_1 or $WaveMR1_1
    .EXAMPLE
        Remove-WaveDataGlobalVariable
        Removes all global wave variables
    #>
    
    @(Get-Variable -Scope Global -Name "Wave*").where( {
            $_.Name -match "Wave\d_\d" -or $_.Name -match "WaveMR\d_\d" }).foreach( {
            Remove-Variable -Name $_.Name -Scope Global
        })

}
