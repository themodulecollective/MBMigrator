[System.Collections.Generic.List[psobject]]$badrecipients = @()

$recipients.foreach({

    $r = $_

    $newaddress = 'smtp:' + $r.primarysmtpaddress.split('@')[0] + '@mks.com'

    $cmdlet = Get-RecipientCmdlet -Recipient $r -verb set

    $commandstring = "$cmdlet -Identity $($r.guid.guid) -EmailAddresses @{add='$newaddress'} -whatif -erroraction Stop"

    $scriptblock = [scriptblock]::create($commandstring)

    switch ($r.recipienttypedetails) {
        'MailContact'
        {break}
        'RoomList'
        {break}
        default
        {
            try {
                Invoke-Command -ScriptBlock $scriptblock
            }

            catch {
                $badrecipients.add($r)
            }
        }
    }
})