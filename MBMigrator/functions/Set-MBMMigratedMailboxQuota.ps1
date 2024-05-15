Function Set-MBMMigratedMailboxQuota
{
    <#
    .SYNOPSIS
        Sets the IssueWarningQuota, ProhibitSendQuota, and ProhibitSendReceiveQuota for Wave members or specified users
    .DESCRIPTION
        Sets the IssueWarningQuota, ProhibitSendQuota, and ProhibitSendReceiveQuota for Wave members or specified users
    .EXAMPLE
        Set-MBMMigratedMailboxQuota -Wave "1.1"
        Sets the IssueWarningQuota, ProhibitSendQuota, and ProhibitSendReceiveQuota for Wave 1.1 members
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
        [ValidateSet('StatusQuo','MailboxSize','StatusQuoWithAdjustments')]
        [string[]]$QuotaSelectionMethod
        ,
        [parameter()]
        [hashtable]$Adjustments
    )

    Write-Information -MessageData "PostMigration Quota Processing"
    Write-Information -MessageData "ParameterSetName: $($PSCmdlet.ParameterSetName)"

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

    If ($null -eq $Global:QuotaStatus)
    { $Global:QuotaStatus = @{} }

    $ProcessRequests = @(
        $WaveMR.where( {
                $_.status -like 'Completed*' }).where( {
                -not $Global:QuotaStatus.containskey($_.exchangeguid.guid)
            })
    )

    Write-Information -MessageData "Completed Requests to Process: $($ProcessRequests.count)"

    Switch ($QuotaSelectionMethod)
    {
        'MailboxSize'
        {
            Write-Information -MessageData "Quota Selection Method: MailboxSize"
            $mstats = @(foreach ($r in $ProcessRequests)
            {
                try
                {
                    Write-Information -MessageData "Get-MailboxStatistics -Identity $($r.exchangeguid.guid)"
                    Get-MailboxStatistics -Identity $r.exchangeguid.guid -erroraction Stop
                }
                catch
                {
                    Write-Information -MessageData $($_.tostring())
                }
            })

            $mstats.foreach(
                {
                    [pscustomobject]@{
                        DisplayName     = $_.DisplayName
                        ExchangeGUID    = $_.MailboxGuid.guid
                        TotalMBSizeInGB = [int]$(
                            $_.TotalItemSize.tostring().split(@('(', ')', ' '))[3].replace(',', '') / 1GB
                        )
                        Quotas          = $null
                    }
                }
            ).foreach( {
                    $_.Quotas = switch ($_.TotalMBSizeInGB)
                    {
                        { $_ -lt 8 }
                        {
                            @{
                                IssueWarningQuota        = 9GB
                                ProhibitSendQuota        = 9.5GB
                                ProhibitSendReceiveQuota = 10GB
                            }
                        }
                        { $_ -ge 8 -and $_ -lt 23 }
                        {
                            @{
                                IssueWarningQuota        = 24GB
                                ProhibitSendQuota        = 24.5GB
                                ProhibitSendReceiveQuota = 25GB
                            }
                        }
                        { $_ -ge 23 -and $_ -lt 48 }
                        {
                            @{
                                IssueWarningQuota        = 49GB
                                ProhibitSendQuota        = 49.5GB
                                ProhibitSendReceiveQuota = 50GB
                            }
                        }
                        { $_ -ge 48 -and $_ -lt 73 }
                        {
                            @{
                                IssueWarningQuota        = 74GB
                                ProhibitSendQuota        = 74.5GB
                                ProhibitSendReceiveQuota = 75GB
                            }
                        }
                        { $_ -ge 73 -and $_ -lt 98 }
                        {
                            @{
                                IssueWarningQuota        = 99GB
                                ProhibitSendQuota        = 99.5GB
                                ProhibitSendReceiveQuota = 99.99GB
                            }
                        }
                    }

            $Quotas = $_.Quotas

            try
            {
                Write-Information -MessageData "Set-Mailbox -Identity $($_.ExchangeGUID) -Quotas @Quotas"
                Set-Mailbox -Identity $_.ExchangeGUID @Quotas -Confirm:$false -ErrorAction Stop
                $Global:QuotaStatus.$($_.ExchangeGUID) = $Quotas
            }
            catch
            {
                Write-Information -MessageData $($_.tostring())
            }
            })
        }
        'StatusQuo'
        {
            Write-Information -MessageData "Quota Selection Method: StatusQuo"
            $WaveMember.where({$_.ExchangeGUID -in $ProcessRequests.ExchangeGUID.guid}).foreach({

                $member = $_
                $quotas = @{
                    IssueWarningQuota = switch ($member.IssueWarningQuotaInGB) {'Unlimited' {'Unlimited'} Default {$($member.IssueWarningQuotaInGB + ' GB')}}
                    ProhibitSendQuota = switch ($member.ProhibitSendQuotaInGB) {'Unlimited' {'Unlimited'} Default {$($member.ProhibitSendQuotaInGB + ' GB')}}
                    ProhibitSendReceiveQuota = switch ($member.ProhibitSendReceiveQuotaInGB) {'Unlimited' {'Unlimited'} Default {$($member.ProhibitSendReceiveQuotaInGB + ' GB')}}
                }

                try
                {
                    Write-Information -MessageData "Set-Mailbox -Identity $($_.ExchangeGUID) -Quotas @Quotas"
                    Set-Mailbox -Identity $_.ExchangeGUID @quotas -Confirm:$false -ErrorAction Stop
                    $Global:QuotaStatus.$($_.ExchangeGUID) = $quotas
                }
                catch
                {
                    Write-Information -MessageData $($_.tostring())
                }
            })
        }
        'StatusQuoWithAdjustments'
        {
            Write-Information -MessageData "Quota Selection Method: StatusQuoWithAdjustments"
            $WaveMember.where({$_.ExchangeGUID -in $ProcessRequests.ExchangeGUID.guid}).foreach({

                $member = $_

                foreach ($q in $Adjustments.keys)
                {
                    If ($Adjustments.$q.containskey($member.$q))
                    {
                        $member.$q = $Adjustments.$q.$($member.$q)
                    }
                }

                $quotas = @{
                    IssueWarningQuota = switch ($member.IssueWarningQuotaInGB) {'Unlimited' {'Unlimited'} Default {$($member.IssueWarningQuotaInGB + ' GB')}}
                    ProhibitSendQuota = switch ($member.ProhibitSendQuotaInGB) {'Unlimited' {'Unlimited'} Default {$($member.ProhibitSendQuotaInGB + ' GB')}}
                    ProhibitSendReceiveQuota = switch ($member.ProhibitSendReceiveQuotaInGB) {'Unlimited' {'Unlimited'} Default {$($member.ProhibitSendReceiveQuotaInGB + ' GB')}}
                }

                try
                {
                    Write-Information -MessageData "Set-Mailbox -Identity $($_.ExchangeGUID) @Quotas"
                    Set-Mailbox -Identity $_.ExchangeGUID @quotas -Confirm:$false -ErrorAction Stop
                    $Global:QuotaStatus.$($_.ExchangeGUID) = $quotas
                }
                catch
                {
                    Write-Information -MessageData $($_.tostring())
                }
            })
        }
    }

}