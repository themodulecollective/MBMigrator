#$Wave2_1.foreach( { Set-Mailbox -DefaultPublicFolderMailbox $_.DefaultPUblicFolderMailbox.split('/')[-1] -identity $_.ExchangeGUID -WarningAction SilentlyContinue })

function Set-MBMMigratedMailboxRetentionPolicy {
    <#
    .SYNOPSIS
        Sets the mailbox retention policy for wave members or specified users
    .DESCRIPTION
        Sets the mailbox retention policy for wave members or specified users
    .EXAMPLE
        Set-MBMMigratedMailboxRetentionPolicy -wave "1.1"
        Sets the mailbox retention policy for wave 1.1 members
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
        ,
        [parameter(Mandatory)]
        [ValidateSet('StatusQuo','Static')]
        [string[]]$RetentionPolicySelectionMethod
        ,
        [parameter()]
        [string]$StaticRetentionPolicy
        ,
        [parameter()]
        [switch]$SingleItemRecoveryEnabled
        ,
        [parameter()]
        [ValidateRange(0,30)]
        [int]$RetainDeletedItemsFor
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

    If ($null -eq $Global:RetentionPolicyStatus)
    { $Global:RetentionPolicyStatus = @{} }

    $ProcessRequests = @(
        $WaveMR.where( {
                $_.status -like 'Completed*' }).where( {
                -not $Global:RetentionPolicyStatus.containskey($_.exchangeguid.guid)
            })
    )

    switch ($RetentionPolicySelectionMethod)
    {
        'Static'
        {
            $WaveMR.where( { $_.Status -like 'Complete*' -and -not $Global:RetentionPolicyStatus.containskey($_.exchangeguid.guid) }).foreach( {
            try {
                Write-Information -MessageData "Set-Mailbox -Identity $($_.ExchangeGUID.guid) -RetentionPolicy $StaticRetentionPolicy"
                $setMBParams = @{
                    Identity = $_.ExchangeGUID
                    WarningAction = 'SilentlyContinue'
                    ErrorAction = 'Stop'
                    RetentionPolicy = $StaticRetentionPolicy
                    Confirm = $false
                }
                if ($PSCmdlet.PSBoundParameters.containskey('SingleItemRecoveryEnabled'))
                {
                    $setMBParams.SingleItemRecoveryEnabled = $SingleItemRecoveryEnabled
                }
                if ($PSCmdlet.PSBoundParameters.containskey('RetainDeletedItemsFor'))
                {
                    $setMBParams.RetainDeletedItemsFor = $RetainDeletedItemsFor
                }
                Set-Mailbox @setMBParams
                $Global:RetentionPolicyStatus.$($_.ExchangeGUID.guid) = $StaticRetentionPolicy
            }
            catch {
                Write-Information -MessageData $($_.tostring())
            }
            })
        }
        'StatusQuo'
        {
            $MembersToProcess = $WaveMember.where({$_.ExchangeGUID -in $ProcessRequests.ExchangeGUID.guid})
            $MembersToProcess.foreach({

                $member = $_
                $RetentionPolicy = $member.RetentionPolicy

                $setMBParams = @{
                    Identity = $member.ExchangeGUID
                    WarningAction = 'SilentlyContinue'
                    ErrorAction = 'Stop'
                    RetentionPolicy = $RetentionPolicy
                    Confirm = $false
                }
                if ($PSCmdlet.PSBoundParameters.containskey('SingleItemRecoveryEnabled'))
                {
                    $setMBParams.SingleItemRecoveryEnabled = $SingleItemRecoveryEnabled
                }
                if ($PSCmdlet.PSBoundParameters.containskey('RetainDeletedItemsFor'))
                {
                    $setMBParams.RetainDeletedItemsFor = $RetainDeletedItemsFor
                }

                try
                {
                    Write-Information -MessageData "Set-Mailbox -Identity $($member.ExchangeGUID) -RetentionPolicy $RetentionPolicy"
                    Set-Mailbox @setMBParams
                    $Global:RetentionPolicyStatus.$($member.ExchangeGUID) = $RetentionPolicy
                }
                catch
                {
                    Write-Information -MessageData $($_.tostring())
                }
            })
        }
    }
}