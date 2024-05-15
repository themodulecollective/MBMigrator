[cmdletbinding()]
param(
[parameter(Mandatory)]
[string]$UserPrincipalName #UPN for Connection to Exchange Online
,
[parameter(Mandatory)]
[string]$ExchangeServer #On Premises Exchange Server
)

$ConnectionURI = "http://$ExchangeServer/PowerShell"

$RequiredSessions = @('OnPremExchange','OnlineExchange')
foreach ($rs in $RequiredSessions) {
    $existingSession = @((Get-PSSession).where({$_.Name -eq $rs}))
    $newSessionNeeded = $false
    switch ('switch')
    {
        {$existingSession.count -eq 0}
        {
            
            $newSessionNeeded = $true
            break
        }
        {$existingSession[0].state -ne 'Opened'}
        {
            Remove-PSSession -Name $rs -Confirm:$false
            $newSessionNeeded = $true
        }
    }
    switch ($newSessionNeeded)
    {
        $true 
        {
            $NewSession = New-PSSession -ComputerName localhost -EnableNetworkAccess -Name $rs
            Invoke-Command -Session $NewSession -ScriptBlock {Import-Module MBMigrator}
            Invoke-Command -Session $NewSession -FilePath E:\MBMigration\scripts\MBMConfiguration.ps1
            switch ($rs)
            {
                'OnPremExchange'
                {
                    Invoke-Command -Session $NewSession -ScriptBlock {$OPSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $Using:ConnectionURI ; Import-PSSession -Session $OPSession -DisableNameChecking -AllowClobber}
                }
                'OnlineExchange'
                {
                    Invoke-Command -Session $Newsession -ScriptBlock {Import-Module ExchangeOnlineManagement; Connect-ExchangeOnline -UserPrincipalName $Using:UserPrincipalName}                
                }
            }
        }
    }
}

