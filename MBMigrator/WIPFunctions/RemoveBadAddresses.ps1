[cmdletbinding(SupportsShouldProcess)]
param(
    [switch]$Preview
    ,
    [psobject]$ToProcess
    ,
    [parameter()]
    [ValidateSet()]
    [string[]]$RecipientTypes
)

[System.Collections.Generic.List[psobject]]$moreErrors = @()


$ToProcess.where({ $_.recipienttypedetails -in 'MailUniversalDistributionGroup', 'MailUniversalSecurityGroup', 'RemoteRoomMailbox', 'RemoteSharedMailbox', 'RemoteEquipmentMailbox' }).foreach({
        #$recipients.foreach({

        $r = $_

        if ($null -ne $r.primarysmtpaddress -and -not [string]::IsNullOrWhiteSpace($r.primarysmtpaddress)) {
            $newaddress = 'smtp:' + $r.primarysmtpaddress.split('@')[0] + '@targetdomain.com'
            $badaddresses = @($r.emailaddresses.where({ $_ -like 'notes:*' -or $_ -like '*@exchange.targetdomain.com@targetdomain' }))

            switch ($Preview) {
                $true {
                    [PSCustomObject]@{
                        RecipientTypeDetails = $r.RecipientTypeDetails
                        Alias                = $r.Alias
                        PrimarySMTPAddress   = $r.primarysmtpaddress
                        NewAddress           = $newaddress
                        BadAddresses         = $badaddresses -join '|'
                    }
                }
                $false {
                    $addresses = @{add = $newaddress }
                    if ($badaddresses.count -ge 1) {
                        $addresses.add('remove', $badaddresses)
                    }

                    $setParams = @{
                        Identity       = $r.guid.guid
                        emailaddresses = $addresses
                        erroraction    = 'Stop'
                    }


                    try
                    {
                        switch -wildcard ($r.recipienttypedetails) {

                            'MailUniversalDistributionGroup'
                            {
                                Set-DistributionGroup @setParams
                            }
                            'MailUniversalSecurityGroup'
                            {
                                Set-DistributionGroup @setParams
                            }
                            'Remote*Mailbox'
                            {
                                Set-RemoteMailbox @setParams
                            }
                        }
                    }
                    catch
                    {
                        $moreErrors.add($r)
                    }
                }
            }


        }

    })
