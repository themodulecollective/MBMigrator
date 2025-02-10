Function New-MBMWaveMoveRequest
{
    <#
    .SYNOPSIS
        Create new move requests for members of a wave
    .DESCRIPTION
        After running Get-MBMMigrationList, this creates new move requests for members of a wave. Additional functionalities like find missing members are availible.
    .EXAMPLE
        New-MBMWaveMoveRequest -ExchangeCredential $Cred -Wave "1.1" -Endpoint contoso.onmicrosoft.com
        Creates new move requests for all members of wave 1.1
    #>

    [cmdletbinding(SupportsShouldProcess)]
    param(
        #
        [parameter(Mandatory)]
        [pscredential]$ExchangeCredential
        ,
        #
        [parameter(Mandatory)]
        [string]$Wave
        ,
        #
        [parameter(Mandatory)]
        #[System.Collections.IDictionary]$EndPoint
        [string]$Endpoint
        ,
        #
        [parameter()]
        [switch]$Missing
        ,
        #
        [parameter()]
        [switch]$NoSuspend
        ,
        #
        [parameter()]
        [switch]$UseAlias
        ,
        #
        [parameter()]
        [switch]$IncludeArchive
        ,
        #
        [parameter()]
        $TargetDeliveryDomain
        ,
        [parameter()]
        [ValidateRange(2, 10)]
        [int]$MultiThread
    )
    if ($null -eq $MigrationList -or $MigrationList.count -lt 1)
    { throw('You must run Get-MBMMigrationList before running this command.') }

    if ($PSBoundParameters.ContainsKey('MultiThread') -and $true -eq $WhatIfPreference)
    {
        throw('New-MBMWaveMoveRequest does not support WhatIf with MultiThread')
    }

    Get-MBMWaveMember -Wave $Wave -Global

    switch ($missing)
    {
        $true
        {
            $WaveMembers = @(Get-MBMWaveMissingMoveRequest -Wave $Wave -errorAction Stop)
        }
        $false
        {
            $WaveMembers = @(Get-WaveMemberVariableValue -Wave $Wave -ErrorAction Stop)
        }
    }
    $NewMoveRequestParams = @{
        BadItemLimit               = 99
        LargeItemLimit             = 99
        TargetDeliveryDomain       = $TargetDeliveryDomain
        AcceptLargeDataLoss        = $true
        SuspendWhenReadyToComplete = $true
        Remote                     = $true
        WarningAction              = 'SilentlyContinue'
        RemoteHostName             = $Endpoint
        RemoteCredential           = $ExchangeCredential
        BatchName                  = $Wave
        ErrorAction                = 'Stop'
    }
    switch ($true)
    {
        { $true -eq $NoSuspend }
        { $NewMoveRequestParams.SuspendWhenReadyToComplete = $false }
    }
    switch ($MultiThread)
    {
        0
        {
            $WaveMembers.ForEach({
                    $member = $_
                    $MemberParams = @{
                        Identity = $_.ExchangeGUID
                    }
                    switch ($IncludeArchive)
                    {
                        $true
                        {
                            #$MemberParams.ArchiveDomain = $TargetDeliveryDomain
                        }
                        $false
                        {
                            if ($_.ArchiveStatus -eq 'Active' -or $_.ArchiveState -ne 'None')
                            {
                                $MemberParams.PrimaryOnly = $true
                            }
                        }
                    }

                    if ($UseAlias)
                    {
                        $MemberParams.Identity = $_.Name
                    }

                    if ($PSCmdlet.ShouldProcess("$($_.exchangeguid) $($_.Alias)", 'New-MoveRequest'))
                    {
                        try
                        {
                            New-MoveRequest @NewMoveRequestParams @MemberParams
                        }
                        catch
                        {
                            $ErrorString = $_.tostring()
                            $InformationObject = $member | Select-Object -Property Name, Alias, ExchangeGUID, PrimarySMTPAddress, *InGB, LitigationHoldEnabled, @{n = 'Error'; e = { $ErrorString } }
                            Write-Information -MessageData $InformationObject -Tags 'FailedToCreate'
                        }
                    }
                })
        }
        { $_ -ge 2 }
        {
            $Ranges = New-SplitArrayRange -inputArray $WaveMembers -parts $MultiThread
            foreach ($r in $ranges)
            {
                Start-ExchangeThreadJob -ScriptBlock {
                    $sr = $using:r
                    $sWaveMembers = $using:WaveMembers
                    @($sWaveMembers[$($sr.start)..$($sr.end)]).foreach({
                            $member = $_
                            $MemberParams = @{
                                Identity = $_.ExchangeGUID
                            }
                            switch ($using:IncludeArchive)
                            {
                                $true
                                {
                                    #$MemberParams.ArchiveDomain = $TargetDeliveryDomain
                                }
                                $false
                                {
                                    if ($_.ArchiveStatus -eq 'Active' -or $_.ArchiveState -ne 'None')
                                    {
                                        $MemberParams.PrimaryOnly = $true
                                    }
                                }
                            }
                            if ($UseAlias)
                            {
                                $MemberParams.Identity = $_.Name
                            }
                            try
                            {
                                New-MoveRequest @Using:NewMoveRequestParams @MemberParams
                            }
                            catch
                            {
                                $ErrorString = $_.tostring()
                                $InformationObject = $member | Select-Object -Property Name, Alias, ExchangeGUID, PrimarySMTPAddress, *InGB, LitigationHoldEnabled, @{n = 'Error'; e = { $ErrorString } }
                                Write-Information -MessageData $InformationObject -Tags 'FailedToCreate'
                            }
                        })
                }
            }
        }
    }
}
