Function Get-MBMWaveMissingMoveRequest
{
    <#
    .SYNOPSIS
        Gets wave memembers that do not have a move request
    .DESCRIPTION
        Gets wave memembers that do not have a move request by comparing the specified waves member list to the move requests with that name
    .EXAMPLE
        Get-MBMWaveMissingMoveRequest -Wave "1.1"
        Returns any wave 1.1 members without a move request
    #>

    [cmdletbinding()]
    param(
        #
        [string]$Wave
    )

    $WaveMR = Get-MoveRequest -batchname $Wave
    $WaveMember = Get-WaveMemberVariableValue -Wave $Wave

    $WaveMember.Where( { $_.ExchangeGUID -notin $WaveMr.ExchangeGUID.GUID })
}
