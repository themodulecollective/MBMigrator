Function Complete-MBMWave
{
    <#
.SYNOPSIS
    Get all Move requests in a wave and restart them for completion
.DESCRIPTION
    Specify a wave and all move requests in the wave will be resumed for completion
.EXAMPLE
    Complete-MBMWave -Wave "1.0"
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
                            if ($PSCmdlet.ShouldProcess($("$($_.exchangeguid.guid) $($_.Identity)"), 'Resume'))
                            {
                                Resume-MoveRequest -Identity $_.exchangeguid.guid
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
                                    Resume-MoveRequest -Identity $_.exchangeguid.guid
                                })
                        }
                    }
                }
            }
        }
        'Region'
        {
            #syntax difference because the item being processed here is the wave entry where exchangeguid is already a string
            $RegionalMembers = @(@(Get-WaveMemberVariableValue -Wave $Wave).where({ $_.Region -eq $Region }))
            $RegionalMembers.foreach({
                    if ($PSCmdlet.ShouldProcess($("$($_.exchangeguid) $($_.Alias)"), 'Resume'))
                    {
                        Resume-MoveRequest -Identity $_.exchangeguid
                    }
                })
        }
    }
}
