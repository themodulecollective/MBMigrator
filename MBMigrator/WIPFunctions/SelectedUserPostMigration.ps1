param(
    [string[]]$Users
    ,
    $Wave
)#PrimarySMTPAddress)

$InformationPreference = 'Continue'
$UsersToProcess = $MailboxMigrationList.where( { $_.primarysmtpaddress -in $Users })
Do
{

    Write-Information -InformationAction Continue -MessageData 'Processing Completed Mailboxes for Forwarding'
    Set-MBMMigratedMailboxForwarding -UsersToProcess $UsersToProcess -InformationAction Continue
    Write-Information -InformationAction Continue -MessageData 'Processing Completed Mailboxes for Public Folder Access'
    Set-MBMMigratedMailboxDefaultPFM -UsersToProcess $UsersToProcess -InformationAction Continue
    Write-Information -InformationAction Continue -MessageData 'Processing Completed Mailboxes for OWA For Devices Disablement'
    Set-MBMMigratedCASMailbox -UsersToProcess $UsersToProcess -InformationAction Continue
    Write-Information -InformationAction Continue -MessageData 'Processing Completed Mailboxes for Mailbox Quota Settings'
    Set-MBMMigratedMailboxQuota -UsersToProcess $UsersToProcess -InformationAction Continue
    Write-Information -InformationAction Continue -MessageData 'Processing Completed Mailboxes for Send/Receive Limits'
    Set-MBMMigratedMailboxSendReceive -UsersToProcess $UsersToProcess -InformationAction Continue
    Write-Information -InformationAction Continue -MessageData 'Processing Completed Mailboxes for MaaS360 Devices'
    Grant-MigratedMailboxActiveSyncDeviceAccess -UsersToProcess $UsersToProcess -InformationAction Continue -SendAdminEmail
    Write-Information -InformationAction Continue -MessageData 'Processing Completed Mailboxes for Completion Email Message'
    Send-MBMWaveMoveRequestCompletedMessage -UsersToProcess $UsersToProcess -Wave $Wave -InformationAction Continue
    Write-Information -InformationAction Continue -MessageData 'Sleeping for 60 Seconds'
    New-Timer -showprogress -units Seconds -length 60 -Frequency 5

} until ($false)