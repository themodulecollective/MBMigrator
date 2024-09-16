Function Expand-GroupMemberPreservingSourceGroup {
    [cmdletbinding()]
    param(
        [psobject[]]$Groups
    )
    
    $xProgressID = New-xProgress -ArrayToProcess $Groups -CalculatedProgressInterval 1Percent -Activity 'Group Member Lookup'

    foreach ($g in $Groups) {
        Set-xProgress -Identity $xProgressID -Status $g.Name
        Write-xProgress -Identity $xProgressID
        $members = @(Get-ADGroupMember -Identity $g.objectguid -server $g.ADDomain -Recursive)
        #Write-Information -MessageData "Member Count is $($members.count)"
        if ($members.count -ge 1) {
            $xProgressID2 = New-xProgress -ArrayToProcess $members -CalculatedProgressInterval 25Percent -Activity 'Member Detail Lookup'
            foreach ($m in $members) {
                Set-xProgress -Identity $xProgressID2
                Write-xProgress -Identity $xProgressID2
                #Write-Information -MessageData "getting AD User $($m.ObjectGuid)"
                Try {
                    Get-ADObject -Identity $m.ObjectGuid -Properties SamAccountName,UserPrincipalName,Mail,Enabled,DisplayName,Name -server $($g.ADDomain + ':3268') |
                    Select-Object -Property SamAccountName,UserPrincipalName,Mail,Enabled,DisplayName,@{n='SourceGroup';e={$g.SamAccountName}},@{n='GroupADDomain';e={$g.addomain}}
                }
                catch {
                    Write-Information -MessageData "Unable to find object for identity: $($m.ObjectGuid) | $($m.DistinguishedName)"
                }
            }
            Complete-xProgress -Identity $xProgressID2   
        }
    }
    Complete-xProgress -Identity $xProgressID
}
