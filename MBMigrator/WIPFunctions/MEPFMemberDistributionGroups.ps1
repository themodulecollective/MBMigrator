$PublicFolderOUs = @('CN=Microsoft Exchange System Objects,DC=clientdomain,DC=com', 'CN=Microsoft Exchange System Objects,DC=clientdomain,DC=clientdomain,DC=com')
$PFOUMatch = $PublicFolderOUs -join '|'
$ExCred = Get-Credential -Message 'Exchange Credential'
$EXServer = 'server.clientdomain.com'

$exas = New-PSSession -Credential $ExCred -ConfigurationName microsoft.exchange -Name EXA -ConnectionUri "http://$EXServer/PowerShell" -Authentication Kerberos

Import-Module ActiveDirectory
Import-PSSession -Session $exas -AllowClobber

Set-ADServerSettings -ViewEntireForest $true

$ExchangeDGsNoStubs = Get-DistributionGroup -ResultSize Unlimited -Filter "CustomAttribute5 -notlike 'ACS*'"

Set-Location AD:\
$ADDGsWithMembership = $ExchangeDGsNoStubs.ForEach({Get-ADGroup -Identity $_.DistinguishedName -Properties DisplayName, members, mail, mailnickname, managedby})
$ADDGsWithMEPFMembers = $ADDGsWithMembership | Where-Object {@($_.Members -match $PFOUMatch).count -ge 1}
$ByManager = $ADDGsWithMEPFMembers | Group-Object -Property ManagedBy | Sort-Object -Descending -Property Count
$ManagerDetail = $ByManager.ForEach({Get-Recipient -Identity $_.name})
$ManagerHash = @{}
$ManagerDetail.ForEach({$ManagerHash.$($_.DistinguishedName) = $_})
$GroupHash = @{}
$ADDGsWithMEPFMembers.ForEach({$GroupHash.$($_.DistinguishedName) = $_})
$GroupReport = $ADDGsWithMEPFMembers.ForEach({
        if ($null -ne $_.ManagedBy -and $ManagerHash.ContainsKey($_.ManagedBy))
        {
            [pscustomobject]@{
                DisplayName             = $_.DisplayName
                Name                    = $_.Name
                Alias                   = $_.mailnickname
                Mail                    = $_.mail
                GroupCategory           = $_.GroupCategory
                GroupScope              = $_.GroupScope
                MemberCount             = $_.members.count
                PublicFolderMemberCount = ($_.members -match $PFOUMatch).count
                ManagedByDN             = $ManagerHash.$($_.ManagedBy).DistinguishedName
                ManagedByDisplayName    = $ManagerHash.$($_.ManagedBy).DisplayName
                ManagedByMail           = $ManagerHash.$($_.ManagedBy).PrimarySMTPAddress
                ObjectGUID              = $_.ObjectGUID.guid
                ObjectSID               = $_.SID.tostring()
                GroupDN                 = $_.DistinguishedName
            }
        }
        else
        {
            [pscustomobject]@{
                DisplayName             = $_.DisplayName
                Name                    = $_.Name
                Alias                   = $_.mailnickname
                Mail                    = $_.mail
                GroupCategory           = $_.GroupCategory
                GroupScope              = $_.GroupScope
                MemberCount             = $_.members.count
                PublicFolderMemberCount = ($_.members -match $PFOUMatch).count
                ManagedByDN             = $null
                ManagedByDisplayName    = $null
                ManagedByMail           = $null
                ObjectGUID              = $_.ObjectGUID.guid
                ObjectSID               = $_.SID.tostring()
            }
        }
    })
$ManagerReport = @(
    [pscustomobject]@{
        DisplayName = '[No ManagedBy]'
        Name        = $null
        Alias       = $null
        Mail        = $null
        GroupCount  = $ADDGsWithMEPFMembers.where({[string]::IsNullOrEmpty($_.managedBy)}).count
        Groups      = $ADDGsWithMEPFMembers.where({[string]::IsNullOrEmpty($_.managedBy)}).Mail -join ';'
    }
    $ManagerDetail.foreach({
            $ManagerDN = $_.DistinguishedName
            [pscustomobject]@{
                DisplayName = $_.DisplayName
                Name        = $_.Name
                Alias       = $_.Alias
                Mail        = $_.PrimarySMTPAddress
                GroupCount  = $ADDGsWithMEPFMembers.where({$_.managedBy -eq $ManagerDN}).count
                Groups      = $ADDGsWithMEPFMembers.where({$_.managedBy -eq $ManagerDN}).Mail -join ';'
            }
        })
)
$MembershipReport = @(
    $ADDGsWithMEPFMembers.ForEach({
            $GroupDetails = $_
            $GroupDetails.Members.foreach({
                    [pscustomobject]@{
                        GroupDisplayName = $GroupDetails.DisplayName
                        GroupEmail       = $GroupDetails.Mail
                        GroupDN          = $GroupDetails.DistinguishedName
                        MemberDN         = $_
                    }
                })
        })
)


$groupReport | Export-Excel -Path D:\ExchangeReports\MEPFDistributionGroups.xlsx -WorksheetName 'Groups'
$ManagerReport  | Export-Excel -Path D:\ExchangeReports\MEPFDistributionGroups.xlsx -WorksheetName 'Managers'
$MembershipReport  | Export-Excel -Path D:\ExchangeReports\MEPFDistributionGroups.xlsx -WorksheetName 'Membership'