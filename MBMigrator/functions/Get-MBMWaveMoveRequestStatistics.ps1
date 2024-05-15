Function Get-MBMWaveMoveRequestStatistics {
    <#
.SYNOPSIS
    Gets statics of move requests for a specified wave
.DESCRIPTION
    Gets statics of move requests for a specified wave for either requests in progress or all move requests. Can store output in global variable
.EXAMPLE
    Get-MBMWaveMoveRequestStatistics -Wave "1.1" -operation RefreshInProgress
    Gets statistics for move requests in wave 1.1 that are currently in progress

#>

    [cmdletbinding()]
    param(
        #
        [string]$Wave
        ,
        #
        [switch]$Global
        ,
        #
        [parameter()]
        [validateset('RefreshAll', 'RefreshInProgress')]
        [string]$Operation
    )

    Get-MBMWaveMoveRequest -Wave $Wave -Global
    $MR = @(Get-WaveMoveRequestVariableValue -Wave $Wave)

    switch ($Operation) {
        'RefreshInProgress' {
            #Get Existing MRS for the wave from memory
            $ExistingMRS = Get-WaveMoveRequestStatisticsVariableValue -Wave $Wave
            #Create array of the MRS guids
            $ExistingMRSGUIDs = @($ExistingMRS.exchangeguid.guid)
            Write-Information -MessageData "Existing MRS Count: $($ExistingMRS.count)"
            # Create array of any Move Requests without an MRS Statistic
            $Missing = @($MR.where({ $_.ExchangeGUID.guid -notin $ExistingMRSGUIDs }))
            Write-Information -MessageData "Missing MRS Count: $($Missing.count)"
            # Create array of MR where status is InProgress
            $Progressing = @($MR.where({$_.status -eq 'InProgress'}))
            Write-Information -MessageData "Progressing MR Count: $($Progressing.count)"
            # Create array of MR where status is NOT InProgress
            $Static = @($MR.where({ $_.status -ne 'InProgress' }))
            Write-Information -MessageData "Static MR Count: $($Static.count)"
            # Find MR where status is different from existing MRS
            $MRSStatusHash = @{}
            $ExistingMRS.foreach({
                $MRSStatusHash[$_.exchangeguid.guid] = $_.status.value
            })
            $ChangedStatus = @($MR.where({$MRSStatusHash[$_.exchangeguid.guid] -ne $_.status}))
            Write-Information -MessageData "Changed Status MR Count: $($ChangedStatus.count)"

            # Create Exchange GUID Arrays of each of the above categories of MR
            $MMRExchangeGUIDs = @($Missing.exchangeguid.guid)
            $PMRExchangeGUIDs = @($Progressing.exchangeguid.guid)
            #$SMRExchangeGUIDs = @($Static.exchangeguid.guid)
            $CMRExchangeGUIDs = @($ChangedStatus.exchangeguid.guid)

            # Find the MRS which need to be updated
            $MRSUpdatedHash = @{}
            if ($($MMRExchangeGUIDs.count + $PMRExchangeGUIDs.count + $CMRExchangeGUIDs.count) -ge 1) {
                $MRSToUpdate = @(@($MMRExchangeGUIDs;$PMRExchangeGUIDs;$CMRExchangeGUIDs) | Sort-Object -Unique)
                $MRSToUpdate.foreach({$MRSUpdatedHash[$_] = $_})
                $MRSUpdated = @($MRSToUpdate | Get-MoveRequestStatistics)
            }

            $MRSStatic = $ExistingMRS.where({-not $MRSUpdatedHash.ContainsKey($_.exchangeguid.guid)})

            $MRS = @($MRSUpdated; $MRSStatic)
        }
        'RefreshAll' {
            $MRS = @($MR.ExchangeGUID.guid | Get-MoveRequestStatistics)
        }
    }

    switch ($Global) {
        $true {
            $WaveMRSVariableName = $("WaveMRS" + $Wave.Replace('.', '_'))
            New-Variable -Name $WaveMRSVariableName -Scope Global -Value $MRS -Force
        }
        $false {
            $MRS
        }
    }
}
