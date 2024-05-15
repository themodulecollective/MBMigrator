$Review = @()
foreach ($f in $MPF)
{
    $Params = @{
        Alias                = $f.alias
        Name                 = $f.Name
        DisplayName          = $f.DisplayName
        EmailAddresses       = @($f.EmailAddresses; "x500:$($f.legacyexchangedn)")
        ExternalEmailAddress = $f.primarysmtpaddress
        OnPremisesObjectId   = $f.guid
        WindowsEmailAddress  = $f.primarysmtpaddress
        #WhatIf               = $true
        ErrorAction          = 'Stop'
    }
    #set custom attributes if set on premises
    (1..15).foreach( {
            $can = "CustomAttribute$_"
            if (-not [string]::IsNullOrWhiteSpace($f.$can))
            {
                $params.$can = $f.$can
            }
        })

    try
    {
        New-SyncMailPublicFolder @Params
    }

    catch
    {
        $Report = New-Object -TypeName pscustomObject -Property $params
        $Report | Add-Member -MemberType noteproperty -Name Error -Value $_.tostring()
        $Review += $Report
    }

}