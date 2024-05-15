function Get-WaveMemberNonAcceptedDomainReport {
    <#
    .SYNOPSIS
        Gets recipients in a wave with email domains not accepted in the target tenant
    .DESCRIPTION
        Compares Wave Member email address domains to accepted domains in the target destination and reports any recipients with non-accepted domains in their address
    .EXAMPLE
        Get-WaveMemberNonAcceptedDomainReport -WaveMember $wavemembers
        Reports any wave members in $wavemembers who have non-accepted domains in their email addresses
    #>
    
    param(
        #
        [psobject[]]$WaveMember
    )
    $Accepted = Get-AcceptedDomain | Select-Object -ExpandProperty Domainname
    $WaveMemberRecipients = @(
        $WaveMember.foreach( { Get-Recipient -Identity $_.ExchangeGUID })
    )
    foreach ($wmr in $WaveMemberRecipients) {
        $BadAddresses = @($wmr.emailaddresses.where( { $_ -like 'smtp:*' -and $_.split('@')[1] -notin $Accepted }))
        if ($BadAddresses.count -ge 1) {
            [pscustomobject]@{
                ExchangeGUID              = $wmr.Exchangeguid.guid
                DisplayName               = $wmr.DisplayName
                PrimarySMTPAddress        = $wmr.PrimarySMTPAddress
                NonAcceptedEmailAddresses = $BadAddresses
                RecipientTypeDetails      = $wmr.RecipientTypeDetails
            }
        }
    }
}