[cmdletbinding()]
param(
    [pscredential]$Credential
    ,
    [string]$ExchangeServer  = 'server.clientdomain.com'
    ,
    [string]$QuestBaseOU = '*OU=Quest Corp Stub,OU=CorpSys,DC=clientdomain,DC=clientdomain,DC=com'
    ,
    [string]$OutputFolderPath = 'd:\ExchangeReports'
)

$exasParams = @{
    ConfigurationName = 'microsoft.exchange'
    Name              = 'EXA'
    ConnectionURI     = "http://$ExchangeServer/PowerShell"
    Authentication    = 'Kerberos'
}
if ($null -ne $Credential)
{
    $exasParams.Credential = $Credential
}

$exas = New-PSSession @exasParams
Import-Module ActiveDirectory
Import-Module ImportExcel
Import-PSSession -Session $exas -AllowClobber
Set-ADServerSettings -ViewEntireForest $true
$ExchangeDGsNoStubs = Get-DistributionGroup -ResultSize Unlimited -Filter "CustomAttribute5 -notlike 'ACS*'"

Set-Location AD:\
#Get all AD Distribution Groups with Members
$ADDGsWithMembership = $ExchangeDGsNoStubs.ForEach({Get-ADGroup -Identity $_.DistinguishedName -Properties DisplayName, members, mail, mailnickname, managedby, AzureADsync | Select-Object -Property DisplayName, Name, members, mail, mailnickname, managedby, AzureADsync, objectguid, SID, distinguishedname, groupcategory, groupscope })

#Get the subset with Quest Object members
$GroupWithQuestMemberDN = $ADDGsWithMembership | Where-Object {@($_.members -like $QuestBaseOU).count -ge 1} | Select-Object -ExpandProperty DistinguishedName

#Build a hash of the above for quick lookup
$GroupWithQuestMemberDNHash = @{}
$GroupWithQuestMemberDN.foreach({$GroupWithQuestMemberDNHash.$($_) = $null})

#Get the subset with Nested Quest Object Members
$GroupWithNestedQuestMemberGroupDN = @(
    $ADDGsWithMembership.ForEach({
            $g = $_

            $NestedQuestGroups = @(
                $_.Members.foreach({
                        switch ($GroupWithQuestMemberDNHash.ContainsKey($_))
                        {
                            $true
                            {
                                $_
                            }
                        }
                    })
            )

            if ($NestedQuestGroups.count -ge 1)
            {
                $g.DistinguishedName
            }
        })
)

#Build a hash of the above for quick lookup
$GroupWithNestedQuestMemberGroupDNHash = @{}
$GroupWithNestedQuestMemberGroupDN.foreach({$GroupWithNestedQuestMemberGroupDNHash.$($_) = $null})

#For each group add the quest member and nested status
$ADDGsWithMembershipAndQuestStatus = @(
    $ADDGsWithMembership.foreach({
            $g = $_
            $QuestMember = @{
                n ='QuestMember'
                e = {$null}
            }
            $NestedQuestMember = @{
                n = 'NestedQuestMember'
                e = {$null}
            }

            switch ($GroupWithQuestMemberDNHash.ContainsKey($_.DistinguishedName))
            {
                $true
                {
                    $QuestMember.e = {$true}
                }
                $false
                {
                    $QuestMember.e = {$false}
                }
            }
            switch ($GroupWithNestedQuestMemberGroupDNHash.ContainsKey($_.DistinguishedName))
            {
                $true
                {
                    $NestedQuestMember.e = {$true}
                }
                $false
                {
                    $NestedQuestMember.e = {$false}
                }
            }
            $g | Select-Object -Property *, $QuestMember, $NestedQuestMember
        })
)

#reduce to only groups with quest members or nested members
$ADDGsWithQuestMembers = $ADDGsWithMembershipAndQuestStatus.where({$true -eq $_.QuestMember -or $true -eq $_.NestedQuestMember})

#Report By Manager Grouping
$ByManager = $ADDGsWithQuestMembers | Group-Object -Property ManagedBy | Sort-Object -Descending -Property Count
$ManagerDetail = $ByManager.ForEach({Get-Recipient -Identity $_.name -ErrorAction SilentlyContinue})
$ManagerHash = @{}
$ManagerDetail.ForEach({$ManagerHash.$($_.DistinguishedName) = $_})

#Report By Group
$GroupReport = $ADDGsWithQuestMembers.ForEach({
        if ($null -ne $_.ManagedBy -and $ManagerHash.ContainsKey($_.ManagedBy))
        {
            [pscustomobject]@{
                AzureADSync          = $_.AzureADSync
                DisplayName          = $_.DisplayName
                Name                 = $_.Name
                Alias                = $_.mailnickname
                Mail                 = $_.mail
                GroupCategory        = $_.GroupCategory
                GroupScope           = $_.GroupScope
                MemberCount          = $_.members.count
                QuestMemberCount     = ($_.members -like $QuestBaseOU).count
                ManagedByDN          = $ManagerHash.$($_.ManagedBy).DistinguishedName
                ManagedByDisplayName = $ManagerHash.$($_.ManagedBy).DisplayName
                ManagedByMail        = $ManagerHash.$($_.ManagedBy).PrimarySMTPAddress
                ObjectGUID           = $_.ObjectGUID.guid
                ObjectSID            = $_.SID.tostring()
                GroupDN              = $_.DistinguishedName
                QuestMember          = $_.QuestMember
                NestedQuestMember    = $_.NestedQuestMember
            }
        }
        else
        {
            [pscustomobject]@{
                AzureADSync          = $_.AzureADSync
                DisplayName          = $_.DisplayName
                Name                 = $_.Name
                Alias                = $_.mailnickname
                Mail                 = $_.mail
                GroupCategory        = $_.GroupCategory
                GroupScope           = $_.GroupScope
                MemberCount          = $_.members.count
                QuestMemberCount     = ($_.members -like $QuestBaseOU).count
                ManagedByDN          = $null
                ManagedByDisplayName = $null
                ManagedByMail        = $null
                ObjectGUID           = $_.ObjectGUID.guid
                ObjectSID            = $_.SID.tostring()
                GroupDN              = $_.DistinguishedName
                QuestMember          = $_.QuestMember
                NestedQuestMember    = $_.NestedQuestMembedr
            }
        }
    })

$ManagerReport = @(
    [pscustomobject]@{
        DisplayName = '[No ManagedBy]'
        Name        = $null
        Alias       = $null
        Mail        = $null
        GroupCount  = $ADDGsWithQuestMembers.where({[string]::IsNullOrEmpty($_.managedBy)}).count
        Groups      = $ADDGsWithQuestMembers.where({[string]::IsNullOrEmpty($_.managedBy)}).Mail -join ';'
    }
    $ManagerDetail.foreach({
            $ManagerDN = $_.DistinguishedName
            [pscustomobject]@{
                DisplayName = $_.DisplayName
                Name        = $_.Name
                Alias       = $_.Alias
                Mail        = $_.PrimarySMTPAddress
                GroupCount  = $ADDGsWithQuestMembers.where({$_.managedBy -eq $ManagerDN}).count
                Groups      = $ADDGsWithQuestMembers.where({$_.managedBy -eq $ManagerDN}).Mail -join ';'
            }
        })
)
$MembershipReport = @(
    $ADDGsWithQuestMembers.ForEach({
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


$DateString = Get-Date -Format yyyyMMddHHmmss

$OutputFileName = $('QuestLegacyDistributionGroupsAsOf' + $DateString + '.xlsx')
$OutputFilePath = Join-Path $OutputFolderPath $OutputFileName

$groupReport | Export-Excel -Path $OutputFilePath -WorksheetName 'Groups' -TableStyle Medium2 -TableName 'Groups'
$ManagerReport  | Export-Excel -Path $OutputFilePath -WorksheetName 'Managers' -TableStyle Medium3 -TableName 'Managers'
$MembershipReport  | Export-Excel -Path $OutputFilePath -WorksheetName 'Membership' -TableStyle Medium4 -TableName 'Membership'