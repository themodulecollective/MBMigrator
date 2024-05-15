Function Sync-MBMWaveMoveRequest
{
    <#
    .SYNOPSIS
        Resumes a move request with SuspendWhenReadyToComplete for all members of a specified wave
    .DESCRIPTION
        Resumes a move request with SuspendWhenReadyToComplete for all members of a specified wave allowing any mail recieved in the source mailbox since the last move to be moved without completing the move request
    .EXAMPLE
        Sync-MigrationWaveMoveRequest -Wave "1.1"
        Resumes the move requests for all wave 1.1 members without completing the move
    #>

    [cmdletbinding(DefaultParameterSetName = 'All', SupportsShouldProcess)]
    param(
        [parameter(ParameterSetName = 'All')]
        [parameter(ParameterSetName = 'Region')]
        [string]$Wave # Accepts the wave number for the move requests to resume and Complete-MBMWave
        ,
        [parameter(ParameterSetName = 'Region')]
        [ValidateSet('Americas', 'Asia/Pacific', 'Europe')]
        [string]$Region
        ,
        [parameter()]
        [ValidateRange(2, 10)]
        [int]$MultiThread
    )

    if ($PSBoundParameters.ContainsKey('MultiThread') -and $true -eq $WhatIfPreference)
    {
        throw('Complete-MBMWave does not support WhatIf with MultiThread')
    }

    switch ($PSCmdlet.ParameterSetName)
    {
        'All'
        {
            $waveMR = Get-MBMWaveMoveRequest -Wave $Wave -ErrorAction Stop

            switch ($MultiThread)
            {
                0
                {
                    $waveMR.where({ $_.status -eq 'Autosuspended' }).foreach({
                            if ($PSCmdlet.ShouldProcess($("$($_.exchangeguid.guid) $($_.Identity)"), 'Resume with SuspendWhenReadyToComplete'))
                            {
                                Resume-MoveRequest -Identity $_.exchangeguid.guid -SuspendWhenReadyToComplete
                            }
                        })
                }
                { $_ -ge 2 }
                {
                    $asMR = $waveMR.where({ $_.status -eq 'Autosuspended' })
                    $Ranges = New-SplitArrayRange -inputArray $asMR -parts $MultiThread
                    foreach ($r in $ranges)
                    {
                        Start-ExchangeThreadJob -ScriptBlock {
                            $sr = $using:r
                            $sasMR = $using:asMR
                            @($sasMR[$($sr.start)..$($sr.end)]).foreach({
                                    Resume-MoveRequest -Identity $_.exchangeguid.guid -SuspendWhenReadyToComplete
                                })
                        }
                    }
                }
            }
        }
        'Region'
        {
            Get-MBMWaveMember -Wave $Wave -Global
            #syntax difference because the item being processed here is the wave entry where exchangeguid is already a string
            $RegionalMembers = @(@(Get-WaveMemberVariableValue -Wave $Wave).where({ $_.Region -eq $Region }))
            $RegionalMembers.foreach({
                    if ($PSCmdlet.ShouldProcess($("$($_.exchangeguid) $($_.Alias)"), 'Resume with SuspendWhenReadyToComplete'))
                    {
                        Resume-MoveRequest -Identity $_.exchangeguid -SuspendWhenReadyToComplete
                    }
                })
        }
    }

}
