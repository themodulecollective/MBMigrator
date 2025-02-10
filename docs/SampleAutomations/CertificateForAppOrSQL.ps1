[cmdletbinding()]
param(
    [parameter(Mandatory)]
    $DNSSuffix
)


$NewSSCParams = @{
    Type = 'SSLServerAuthentication'
    Subject = 'CN=' + $localmachinename + '.' + $DNSSuffix
    FriendlyName = 'M365 EntraID Self-Signed'
    DnsName = @($($localmachinename + '.' + $DNSSuffix),'localhost.',$localmachinename)
    KeyAlgorithm = 'RSA'
    KeySpec = 'KeyExchange'
    KeyLength = 2048
    Hash = 'SHA256'
    TextExtension = '2.5.29.37={text}1.3.6.1.5.5.7.3.1'
    NotAfter = (Get-Date).AddMonths(24)
    Provider="Microsoft RSA SChannel Cryptographic Provider"
    CertStoreLocation="Cert:\LocalMachine\My"
}

$Certificate = New-SelfSignedCertificate @NewSSCParams