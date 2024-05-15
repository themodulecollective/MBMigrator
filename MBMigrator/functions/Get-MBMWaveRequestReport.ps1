function Get-MBMWaveRequestReport {
    <#
    .SYNOPSIS
        Gets report on current wave requests
    .DESCRIPTION
        Gets wave request report and allows for monitory during wave completion by repeating the get report on the specified interval
    .EXAMPLE
        Get-MBMWaveRequestReport -Wave "1.1" -Repeat -RepeatSeconds 60
        Gets the wave request report for wave 1.1 every 60 seconds
    #>

    [CmdletBinding()]
    param(
        #
        [string[]]$Wave
        ,
        #
        [switch]$UseStoredRequests
        ,
        #
        [switch]$Repeat
        ,
        #
        [int16]$RepeatSeconds
    )

    do {
        foreach ($w in $Wave) {
            switch ($UseStoredRequests) {
                $true
                {}
                $false
                { Get-MBMWaveMoveRequest -Wave $w -Global }
            }

            $MR = Get-WaveMoveRequestVariableValue -Wave $w

            $Report = [PSCustomObject]@{
                ReportTimeStamp  = Get-Date -Format 'yyyy-MM-dd hh:mm:ss'
                Wave             = $w
                Status           = $mr | Group-Object -AsHashTable -Property Status
                MoveRequestCount = $mr.count
                WaveMemberCount  = @(Get-WaveMemberVariableValue -Wave $w).Count
            }

            $statusHash = @{}
            $Report.Status.getenumerator().foreach({
                    $statusHash.$($_.Name) = $($_.Value.count)
                })

            $Report | Format-Table -AutoSize -Property ReportTimeStamp, Wave, MoveRequestCount, WaveMemberCount
            New-Object -property $statusHash -TypeName psobject | Format-Table -AutoSize
        }
        if ($Repeat) {
            Write-Information -InformationAction Continue -MessageData "Sleeping for $RepeatSeconds Seconds"
            New-Timer -showprogress -units Seconds -length $RepeatSeconds -Frequency 5
        }
    }
    until (-not $Repeat)
}