# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"

#Archive Old User Data
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation MailboxData -AgeInDays 30

#$OutputFolderPath = $MBMConfiguration.MailboxDataFolder
#$MBMModulePath = $MBMConfiguration.MBMModulePath
$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint

$ExchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://$($MBMConfiguration.TargetAutomationExchangeServer)/PowerShell" -Authentication Kerberos
Import-PSSession -Session $ExchangeSession -AllowClobber

$filter = "EmailAddresses -like '*@$($MBMConfiguration.ReverseMoveDeliveryDomain)'"

$RemoteMBs = @(Get-RemoteMailbox -ResultSize unlimited -filter $filter)

$RemoteMBs.ForEach({
        $mb = $_
        $AddressToRemove = @($mb.emailaddresses.where({$_ -like "*@$($MBMConfiguration.ReverseMoveDeliveryDomain)"}))
        if ($AddressToRemove.count -ge 1)
        {
            Write-Log -Message "Removing proxy address(es) $($AddressToRemove -join '|') from $($mb.PrimarySMTPAddress)"
            Set-RemoteMailbox -identity $mb.guid.guid -emailaddresses @{Remove=$AddressToRemove} 
        }
    })

$MailUsers = @(Get-MailUser -ResultSize unlimited -filter $filter)

$MailUsers.ForEach({
        $mb = $_
        $AddressToRemove = @($mb.emailaddresses.where({$_ -like "*@$($MBMConfiguration.ReverseMoveDeliveryDomain)"}))
        if ($AddressToRemove.count -ge 1)
        {
            Write-Log -Message "Removing proxy address(es) $($AddressToRemove -join '|') from $($mb.PrimarySMTPAddress)"
            Set-MailUser -identity $mb.guid.guid -emailaddresses @{Remove=$AddressToRemove} 
        }
    })
    
    