Function Switch-MBMWaveMoveRequestEndpoint
{
    <#
    .SYNOPSIS
        Sets the Wave members Move Request endpoint to a specified endpoint if the existing endpoint is failing
    .DESCRIPTION
        Sets the Wave members Move Request endpoint to a specified endpoint if the existing endpoint is failing
    .EXAMPLE
        Switch-MBMWaveMoveRequestEndpoint -Wave "1.1" -EndPoint mail2.contoso.com
        Sets the move request's endpoint to mail2.contoso.com for all wave 1.1 members

    #>

    [cmdletbinding()]
    param(
        #
        [parameter(Mandatory)]
        [string]$Wave
        ,
        #
        [parameter(Mandatory)]
        [string[]]$EndPoint
        ,
        #
        [switch]$Failed
        ,
        #
        [string[]]$FailingEndpoint
        ,
        #
        [switch]$ResumeRequest
    )

    $WaveMR = Get-MBMWaveMoveRequest -Wave $Wave -ErrorAction Stop
    if ($Failed) { $WaveMR = $WaveMR.where( { $_.status -eq 'Failed' }) }
    if ($FailingEndpoint.Count -ge 1) { $WaveMR = $WaveMR.where( { $_.RemoteHostName -in $FailingEndpoint }) }
    $Counter = -1
    $WaveMR.ForEach( {
            $Counter++
            $RemoteHostName = $EndPoint[$($Counter % $EndPoint.Count)]
            $MemberParams = @{
                RemoteHostName = $RemoteHostName
                Identity       = $_.exchangeguid.guid
            }
            Set-MoveRequest @MemberParams
        })
    if ($ResumeRequest)
    {
        $WaveMR.foreach( {
                Resume-MoveRequest -SuspendWhenReadyToComplete -Identity $_.exchangeguid.guid
            })
    }

}
