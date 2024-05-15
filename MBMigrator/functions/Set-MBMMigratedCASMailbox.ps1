function Set-MBMMigratedCASMailbox {
    <#
    .SYNOPSIS
        Sets OWAforDevicesEnabled to FALSE for wave members or specified users
    .DESCRIPTION
        Sets OWAforDevicesEnabled to FALSE for wave members or specified users
    .EXAMPLE
        Set-MBMMigratedCASMailbox -Wave "1.1"
        Sets OWAforDevicesEnabled to FALSE for members of wave 1.1
    #>

    [cmdletbinding(DefaultParameterSetName = 'Wave')]
    param(
        #
        [parameter(Mandatory, ParameterSetName = 'Wave')]
        $Wave
        ,
        #
        [parameter(Mandatory, ParameterSetName = 'Selected')]
        [psobject[]]$UsersToProcess
    )

    switch ($PSCmdlet.ParameterSetName) {
        'Wave' {
            $WaveMR = Get-WaveMoveRequestVariableValue -Wave $Wave
            $WaveMember = Get-WaveMemberVariableValue -Wave $Wave
        }
        'Selected' {
            $WaveMember = $UsersToProcess
            $WaveMR = @($WaveMember.foreach( { Get-MoveRequest -Identity $_.ExchangeGUID }))
        }
    }

    If ($null -eq $Global:OWAForDevicesStatus)
    { $Global:OWAForDevicesStatus = @{} }

    $WaveMR.where( {
            $_.status -like 'Completed*' }).where( {
            -not $Global:OWAForDevicesStatus.containskey($_.exchangeguid.guid)
        }).foreach( {
            try {
                Set-CASMailbox  -OWAforDevicesEnabled $false -Identity $_.exchangeguid.guid -WarningAction SilentlyContinue -ErrorAction Stop
                $Global:OWAForDevicesStatus.$($_.exchangeguid.guid) = 'Disabled'
            }
            catch {
                Write-Information -MessageData $($_.tostring())
            }
        })
}