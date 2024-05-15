#$Wave2_1.foreach( { Set-Mailbox -DefaultPublicFolderMailbox $_.DefaultPUblicFolderMailbox.split('/')[-1] -identity $_.ExchangeGUID -WarningAction SilentlyContinue })

function Set-MBMMigratedMailboxDefaultPFM
{
    <#
    .SYNOPSIS
        Sets the default public folder mailbox attribute for wave members or specified users
    .DESCRIPTION
        Sets the default public folder mailbox attribute for wave members or specified users
    .EXAMPLE
        Set-MBMMigratedMailboxDefaultPFM -Wave "1.1"
        Sets the default public folder mailbox attribute for wave 1.1 members
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

    If ($null -eq $Global:DefaultPFMStatus)
    { $Global:DefaultPFMStatus = @{} }

    $ProcessMembers = @(
        $WaveMR.where( {
                $_.status -like 'Completed*' }).where( {
                -not $Global:DefaultPFMStatus.containskey($_.exchangeguid.guid)
            }).foreach( {
                $exGuidString = $_.exchangeguid.guid
                $WaveMember.where( { $_.ExchangeGUID -eq $exGuidString })
            })
    )

    $ProcessMembers.foreach( {
            try
            {
                $DefaultPublicFolderMailbox = $_.DefaultPUblicFolderMailbox.split('/')[-1]
                Write-Information -MessageData "Set-Mailbox -Identity $($_.ExchangeGUID) -DefaultPublicFolderMailbox $DefaultPublicFolderMailbox"
                Set-Mailbox -Identity $_.ExchangeGUID -WarningAction SilentlyContinue -ErrorAction Stop -DefaultPublicFolderMailbox $DefaultPublicFolderMailbox
                $Global:DefaultPFMStatus.$($_.ExchangeGUID) = $DefaultPublicFolderMailbox
            }
            catch
            {
                Write-Information -MessageData $($_.tostring())
            }
        })
}