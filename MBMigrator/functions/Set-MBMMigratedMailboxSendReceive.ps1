#$Wave2_1.foreach( { Set-Mailbox -DefaultPublicFolderMailbox $_.DefaultPUblicFolderMailbox.split('/')[-1] -identity $_.ExchangeGUID -WarningAction SilentlyContinue })

function Set-MBMMigratedMailboxSendReceive
{
    <#
    .SYNOPSIS
        Sets the max send size and max receive size for wave members or specified users
    .DESCRIPTION
        Sets the max send size and max receive size for wave members or specified users
    .EXAMPLE
        Set-MBMMigratedMailboxSendReceive -Wave 1.1
        Sets the max send size and max receive size for wave 1.1 members
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

    switch ($PSCmdlet.ParameterSetName)
    {
        'Wave'
        {
            $WaveMR = Get-WaveMoveRequestVariableValue -Wave $Wave
            $WaveMember = Get-WaveMemberVariableValue -Wave $Wave
        }
        'Selected'
        {
            $WaveMember = $UsersToProcess
            $WaveMR = @($WaveMember.foreach( { Get-MoveRequest -Identity $_.ExchangeGUID }))
        }
    }

    If ($null -eq $Global:SendReceiveStatus)
    { $Global:SendReceiveStatus = @{} }

    $WaveMR.where( { $_.Status -like 'Complete*' -and -not $Global:SendReceiveStatus.containskey($_.exchangeguid.guid) }).foreach( {
            try
            {
                Write-Information -MessageData "Set-Mailbox -Identity $($_.ExchangeGUID.guid) -MaxSendSize 60MB -MaxReceiveSize 60MB"
                Set-Mailbox -Identity $_.ExchangeGUID.guid -WarningAction SilentlyContinue -ErrorAction Stop -MaxSendSize 60MB -MaxReceiveSize 60MB
                $Global:SendReceiveStatus.$($_.ExchangeGUID.guid) = '60MB'
            }
            catch
            {
                Write-Information -MessageData $($_.tostring())
            }
        })
}