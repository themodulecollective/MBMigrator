Function Get-MBMWaveWrongMoveRequest
{
    <#
    .SYNOPSIS
        Gets the current move request wave of a user incorrectly placed in that wave
    .DESCRIPTION
        Compares wave members to the wave move requests. If a member is missing from the move requests, it finds the incorrect move request for the user
    .EXAMPLE
        Get-MBMWaveWrongMoveRequest -Wave "1.1"
        Finds members of wave 1.1 with move request that is not in wave 1.1.
    #>

    [cmdletbinding()]
    param(
        #
        [string]$Wave
    )

    $WaveMR = Get-MBMWaveMoveRequest -Wave $Wave
    $WaveMember = Get-MBMWaveMember -Wave $Wave

    $WaveMRGUIDS = $WaveMR.ExchangeGUID.guid
    $MissingMembers = $WaveMember.Where( { $_.ExchangeGUID -notin $WaveMRGUIDS })
    $MissingMembers.foreach( { Get-MoveRequest -identity $_.ExchangeGUID -ErrorAction SilentlyContinue })
}
