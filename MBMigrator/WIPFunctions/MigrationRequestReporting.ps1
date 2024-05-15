$mrs.foreach( {
        [pscustomobject]@{
            DisplayName     = $_.DisplayName
            MBPerHour       = [int]$(
                $_.bytesTransferred.tostring().split(@('(', ')', ' '))[3].replace(',', '') / $_.TotalInProgressDuration.TotalHours / 1MB
            )
            TotalMBSizeInGB = [int]$(
                $_.TotalMailboxSize.tostring().split(@('(', ')', ' '))[3].replace(',', '') / 1GB
            )
        }
    })

$mstats.foreach(
    {
        [pscustomobject]@{
            DisplayName     = $_.DisplayName
            ExchangeGUID    = $_.MailboxGuid
            TotalMBSizeInGB = [int]$(
                $_.TotalItemSize.tostring().split(@('(', ')', ' '))[3].replace(',', '') / 1GB
            )
        }
    }
).foreach( {
        switch ($_.TotalMBSizeInGB)
        {
            { $_ -lt 8 }
            {
                $Quotas = @{
                    IssueWarningQuota        = 9GB
                    ProhibitSendQuota        = 9.5GB
                    ProhibitSendReceiveQuota = 10GB
                }
            }
            { $_ -ge 8 -and $_ -lt 23 }
            {
                $Quotas = @{
                    IssueWarningQuota        = 24GB
                    ProhibitSendQuota        = 24.5GB
                    ProhibitSendReceiveQuota = 25GB
                }
            }
            { $_ -ge 23 -and $_ -lt 48 }
            {
                $Quotas = @{
                    IssueWarningQuota        = 49GB
                    ProhibitSendQuota        = 49.5GB
                    ProhibitSendReceiveQuota = 50GB
                }
            }
            { $_ -ge 48 -and $_ -lt 73 }
            {
                $Quotas = @{
                    IssueWarningQuota        = 74GB
                    ProhibitSendQuota        = 74.5GB
                    ProhibitSendReceiveQuota = 75GB
                }
            }
            { $_ -ge 73 -and $_ -lt 98 }
            {
                $Quotas = @{
                    IssueWarningQuota        = 99GB
                    ProhibitSendQuota        = 99.5GB
                    ProhibitSendReceiveQuota = 99.99GB
                }
            }
        }
        $_.DisplayName
        $Quotas
        #Set-Mailbox -Identity $_.ExchangeGUID.guid @Quotas
    })