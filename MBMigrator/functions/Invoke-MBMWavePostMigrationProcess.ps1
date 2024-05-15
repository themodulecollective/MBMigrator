Function Invoke-MBMWavePostMigrationProcess
{
    <#
    .SYNOPSIS
        Executes post migration processes on the wave members target mailbox
    .DESCRIPTION
        Executes post migration processes on the wave members target mailbox after a completed migration
    .EXAMPLE
        Invoke-MBMWavePostMigrationProcess -$Wave "1.1"
        Completes post migrations processes on wave 1.1 members target mailboxes
    #>

    param(
        #
        [parameter(Mandatory)]
        [string]$Wave
        ,
        #
        [parameter()]
        [ValidateSet('QuickStatus','DetailStatus', 'CompletionMessage', 'Forwarding', 'PublicFolderMailbox', 'OWAForDevices', 'MailboxQuota', 'SendReceiveLimits', 'RetentionPolicy')]
        [string[]]$Operation
        ,
        #
        [int]$SleepSeconds = 60
        ,
        #
        [parameter()]
        [ValidateScript( { Test-Path -Path $_ -type Container })]
        [string]$MessageRepositoryDirectoryPath
        ,
        #
        [parameter()]
        [ValidateScript( { Test-Path -Path $_ -type Leaf })]
        [string]$WavePlanningFilePath
    )
    if ('MaaS360' -in $Operation -or 'CompletionMessage' -in $Operation)
    {
        if (test-CurrentPrincipalIsAdmin)
        {
            throw('this function must run from a non-elevated prompt due to Outlook integration.')
        }

        if (
            'CompletionMessage' -in $Operation -and (
                [string]::IsNullOrWhiteSpace($MessageRepositoryDirectoryPath) -or
                [string]::IsNullOrWhiteSpace($WavePlanningFilePath)
            )
        )
        {
            throw('You must specify the MessageRepositoryDirectoryPath and the WavePlanningFilePath to perform the "CompletionMessage" operation')
        }
    }
    $InformationPreference = 'Continue'

    Do
    {
        Get-MBMWaveMoveRequest -Wave $Wave -Global
        switch ($Operation)
        {
            'DisplayStatus'
            {
                Get-WaveMoveRequestVariableValue -Wave $Wave | Group-Object -NoElement -Property Status | Format-Table
            }
            'CompletionMessage'
            {
                Write-Information -InformationAction Continue -MessageData 'Processing Completed Mailboxes for Completion Email Message'
                Send-MBMWaveMoveRequestCompletedMessage -Wave $Wave -InformationAction Continue -MessageRepositoryDirectoryPath $MessageRepositoryDirectoryPath -WavePlanningFilePath $WavePlanningFilePath
            }
            'Forwarding'
            {
                Write-Information -InformationAction Continue -MessageData 'Processing Completed Mailboxes for Forwarding'
                Set-MBMMigratedMailboxForwarding -Wave $Wave -InformationAction Continue
            }
            'PublicFolderMailbox'
            {
                Write-Information -InformationAction Continue -MessageData 'Processing Completed Mailboxes for Public Folder Access'
                Set-MBMMigratedMailboxDefaultPFM -Wave $Wave -Verbose -InformationAction Continue
            }
            'OWAForDevices'
            {
                Write-Information -InformationAction Continue -MessageData 'Processing Completed Mailboxes for OWA For Devices Disablement'
                Set-MBMMigratedCASMailbox -Wave $Wave -verbose -InformationAction Continue
            }
            'MailboxQuota'
            {
                Write-Information -InformationAction Continue -MessageData 'Processing Completed Mailboxes for Mailbox Quota Settings'
                Set-MBMMigratedMailboxQuota -Wave $Wave -InformationAction Continue -QuotaSelectionMethod 'StatusQuoWithAdjustments'
            }
            'SendReceiveLimits'
            {
                Write-Information -InformationAction Continue -MessageData 'Processing Completed Mailboxes for Send/Receive Limits'
                Set-MBMMigratedMailboxSendReceive -Wave $Wave -InformationAction Continue
            }
            'RetentionPolicy'
            {
                Write-Information -InformationAction Continue -MessageData 'Processing Completed Mailboxes for Retention Policy'
                Set-MBMMigratedMailboxRetentionPolicy -Wave $Wave -InformationAction Continue -RetentionPolicySelectionMethod 'StatusQuo'
            }
        }

        if ($SleepSeconds -ge 1)
        {
            Write-Information -InformationAction Continue -MessageData "Sleeping for $SleepSeconds Seconds"
            New-Timer -showprogress -units Seconds -length $SleepSeconds -Frequency 5
        }
    } until ($false)
}