#$Wave2_1.foreach( { Set-Mailbox -DefaultPublicFolderMailbox $_.DefaultPUblicFolderMailbox.split('/')[-1] -identity $_.ExchangeGUID -WarningAction SilentlyContinue })

function Set-MBMMigratedMailboxForwarding {
    <#
    .SYNOPSIS
        Sets wave member's or specified user's target mailbox forwarding to match the source mailboxe's forwarding
    .DESCRIPTION
        Sets wave members target mailbox forwarding to match the source mailboxe's forwarding
    .EXAMPLE
        Set-MBMMigratedMailboxForwarding -Wave "1.1"
        Sets mailbox forwarding for members of wave 1.1 to the same forwarding as the source mailbox
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

    If ($null -eq $Global:ForwardingStatus)
    { $Global:ForwardingStatus = @{} }

    $ProcessMembers = @(
        $WaveMR.where( {
                $_.status -like 'Completed*' }).where( {
                -not $Global:ForwardingStatus.containskey($_.exchangeguid.guid)
            }).foreach( {
                $exGuidString = $_.exchangeguid.guid
                $WaveMember.where( { $_.ExchangeGUID -eq $exGuidString })
            })
    )

    $ProcessMembers.where( { -not [string]::IsNullOrWhiteSpace($_.ForwardingAddress) }).foreach( {
            try {
                $fa = $_.forwardingaddress.split('/')[-1]
                $fr = @(Get-Recipient -Identity $fa -ErrorAction Stop)
                if ($fr.count -ne 1) { throw ("more than one forwarding recipient found for $($_.PrimarySMTPAddress)") }
                $SetMailboxParams = @{
                    Identity          = $_.ExchangeGUID
                    ForwardingAddress = $fr[0].PrimarySMTPAddress
                    ErrorAction       = 'Stop'
                }
                if ($true -eq $_.DeliverToMailboxAndForward) {
                    $SetMailboxParams.DeliverToMailboxAndForward = $true
                }
                Write-Information -MessageData "Set-Mailbox -Identity $($_.ExchangeGUID) -ForwardingAddress $($fr[0].PrimarySMTPAddress)"
                Set-Mailbox @SetMailboxParams
                $Global:ForwardingStatus.$($_.ExchangeGUID) = $fr[0].PrimarySMTPAddress
            }
            catch {
                Write-Information -MessageData $($_.tostring())
            }
        })
}