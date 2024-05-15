Function Get-MBMWaveNonMemberMoveRequest
{
    <#
    .SYNOPSIS
        Gets move requests not included in the wave members list
    .DESCRIPTION
        Gets any incorrect move request members by comparing the move requests and the wave members list
    .EXAMPLE
        Get-MBMWaveNonMemberMoveRequest -Wave "1.1"
        Returns any incorrectly created move requests in wave 1.1
    #>

    [cmdletbinding()]
    param(
        #
        [string]$Wave
    )

    $WaveMR = Get-MBMWaveMoveRequest -Wave $Wave
    $WaveMember = Get-WaveMemberVariableValue -Wave $Wave

    $MemberGUIDS = $WaveMember.ExchangeGUID
    $Extra = $WaveMR.Where( { $_.ExchangeGUID.guid -notin $MemberGUIDS })
    $Extra
}
