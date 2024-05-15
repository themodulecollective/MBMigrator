function Send-MBMWaveMoveRequestCompletedMessage {
    <#
    .SYNOPSIS
        Send standardized migration complete notification to wave members
    .DESCRIPTION
        Send standardized migration complete notification to wave members. This message inlcudes login help, delayed syncing warnings, and other information to help the user in the target tenant.
    .EXAMPLE
        Send-MBMWaveMoveRequestCompletedMessage -Wave "1.1" -MessageRepository "C:\Users\Username\Repo" -WavePlanningFilePath "C:\Users\Username\Documents\WavePlanning.xlsx"
    #>

    [cmdletbinding(DefaultParameterSetName = 'Wave')]
    param(
        #
        [parameter(Mandatory, ParameterSetName = 'Wave')]
        [parameter(Mandatory, ParameterSetName = 'Selected')]
        $Wave
        ,
        #
        [parameter(Mandatory, ParameterSetName = 'Selected')]
        [psobject[]]$UsersToProcess
        ,
        #
        [parameter(Mandatory)]
        [ValidateScript( { Test-Path -Path $_ -type Container })]
        [string]$MessageRepositoryDirectoryPath
        ,
        #
        [parameter(Mandatory)]
        [ValidateScript( { Test-Path -Path $_ -type Leaf })]
        [string]$WavePlanningFilePath
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

    If ($null -eq $Global:WaveMoveCompletedMessageStatus)
    { $Global:WaveMoveCompletedMessageStatus = @{} }

    $ProcessMembers = @(
        $WaveMR.where( {
                $_.status -like 'Completed*' }).where( {
                -not $Global:WaveMoveCompletedMessageStatus.containskey($_.exchangeguid.guid)
            }).foreach( {
                $exGuidString = $_.exchangeguid.guid
                $WaveMember.where( { $_.ExchangeGUID -eq $exGuidString })
            })
    )

    if ($ProcessMembers.count -ge 1) {
        try {
            Write-Information -MessageData "Send-MBMWaveMessage -WaveMembers $($ProcessMembers.PrimarySMTPAddress -join ';') -MessageName 'T-C' -Wave $Wave"
            $SWMMParams = @{
                Wave                 = $Wave
                MessageName          = 'T-C'
                MessageRepository    = $MessageRepositoryDirectoryPath
                SpecifiedRecipients  = $ProcessMembers
                WavePlanningFilePath = $WavePlanningFilePath
                SendAdditionalBCC    = $true
            }
            Send-MBMWaveMessage @SWMMParams
            $ProcessMembers.foreach( {
                    $Global:WaveMoveCompletedMessageStatus.$($_.ExchangeGUID) = 'Sent'
                })

        }
        catch {
            Write-Information -MessageData $($_.tostring())
        }
    }
}