Function Get-MBMWaveUnassignedMoveRequest
{
    <#
    .SYNOPSIS
        Compares Wave Move Requests to Wave Members and returns members missing from the Move Requests using existing Global variables
    .DESCRIPTION
        Compares Wave Move Requests to Wave Members and returns members missing from the Move Requests using existing Global variables
    .EXAMPLE
        Get-MBMWaveUnassignedMoveRequest -Wave "1.1"
        Compares Wave Move Requests in Wave 1.1 to Wave 1.1 Members and returns members missing from the Move Requests using existing Global variables
    #>

    [cmdletbinding()]
    param(
        #
        [string]$Wave
    )

    $WaveMR = Get-WaveMoveRequestVariableValue -Wave $Wave
    $WaveMembers = Get-WaveMemberVariableValue -Wave $Wave

    $WaveMR.Where( { $_.ExchangeGUID.GUID -notin $WaveMembers.ExchangeGUID })

}
