[cmdletbinding()]
param(
 [parameter(Mandatory)]
 [string]$wave
 ,
 [parameter(Mandatory)]
 [PSCredential]$OPCred # domain\Username format with Password for On Premises Exchange
 ,
 [string]$UserPrincipalName #UPN format for Exchange Online
)

Get-MBMMigrationList -Global
Get-MBMWaveMember -Wave $Wave -Global
$nWMRParams = @{
    ExchangeCredential = $OPCred
    Endpoint = $MBMConfiguration.Endpoint
    TargetDeliveryDomain = $MBMConfiguration.TargetDeliveryDomain
    InformationAction = 'Continue'
    Wave = $Wave
}
