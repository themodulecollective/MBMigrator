function Export-ExchangeConfiguration {
    <#
    .SYNOPSIS
        Query and Export Exchange Service Configuration in XML file
    .DESCRIPTION
        Queries Exchange Configuration using cmdlets like get-organizationconfig, organanizes the results in custom object and outputs results to XML file
    .EXAMPLE
        Export-ExchangeConfiguration -OutputFolderPath "C:\Users\UserName\Documents"
    #>

    [cmdletbinding()]
    param(
        # Folder path for the XML export
        [parameter(Mandatory)]
        [ValidateScript( { Test-Path -type Container -Path $_ })]
        [string]$OutputFolderPath
        ,
        # Include Exchange Online Configuration
        [parameter()]
        [switch]$ExchangeOnline
        ,
        [parameter()]
        [ValidateSet('NetworkConnectionInfo','ExchangeCertificate')]
        $Optional
    )

    $ErrorActionPreference = 'Continue'

    switch ($ExchangeOnline) {
        $true { }
        default
        {
            Write-Information -MessageData 'Running: Get-ExchangeServer'
            $Servers = Get-ExchangeServer
        }
    }

    $ExchangeConfiguration = [PSCustomObject]@{
        OrganizationConfig              = Get-OrganizationConfig
        AdminAuditLogConfig             = Get-AdminAuditLogConfig
        SettingOverride                 = $null
        ExchangeServer                  = $Null
        NetworkConnectionInfo           = $Null
        PartnerApplication              = Get-PartnerApplication
        AuthConfig                      = $null
        AuthServer                      = Get-AuthServer
        CmdletExtensionAgent            = $null
        FederatedOrganizationIdentifier = Get-FederatedOrganizationIdentifier
        FederationTrust                 = Get-FederationTrust
        HybridConfiguration             = $null
        IntraOrganizationConfiguration  = Get-IntraOrganizationConfiguration
        IntraOrganizationConnector      = Get-IntraOrganizationConnector
        PendingFederatedDomain          = $null
        AvailabilityAddressSpace        = Get-AvailabilityAddressSpace
        AvailabilityConfig              = Get-AvailabilityConfig
        OrganizationRelationship        = Get-OrganizationRelationship
        SharingPolicy                   = Get-SharingPolicy
        MigrationConfig                 = Get-MigrationConfig
        MigrationEndpoint               = Get-MigrationEndpoint
        DatabaseAvailabilityGroup       = $Null
        MailboxDatabase                 = $null
        MailboxServer                   = $null
        AcceptedDomain                  = Get-AcceptedDomain
        DeliveryAgentConnector          = $null
        ForeignConnector                = $null
        FrontEndTransportService        = $null
        MailboxTransportService         = $null
        ReceiveConnector                = switch ($exchangeOnline) { $true { Get-InboundConnector } default { Get-ReceiveConnector } }
        SendConnector                   = switch ($exchangeOnline) { $true { Get-OutboundConnector } default { Get-SendConnector } }
        TransportAgent                  = $null
        TransportConfig                 = Get-TransportConfig
        TransportPipeline               = $null
        TransportRule                   = Get-TransportRule
        ExchangeCertificate             = $null
        SMIMEConfig                     = Get-SmimeConfig
        UPNSuffix                       = $null
        ClientAccessServer              = $null
        ClientAccessArray               = $null
        PowershellVirtualDirectory      = $null
        ActiveSyncVirtualDirectory      = $null
        OABVirtualDirectory             = $null
        OWAVirtualDirectory             = $null
        ECPVirtualDirectory             = $null
        WebServicesVirtualDirectory     = $null
        MAPIVirtualDirectory            = $null
        OutlookProvider                 = $null
        OutlookAnywhere                 = $null
        RPCClientAccess                 = $null
        EmailAddressPolicy              = Get-EmailAddressPolicy
        AddressBookPolicy               = Get-AddressBookPolicy
        AddressList                     = $null
        GlobalAddressList               = $null
        OfflineAddressBook              = $null
        OWAMailboxPolicy                = Get-OWAMailboxPolicy
        MobileDeviceMailboxPolicy       = Get-MobileDeviceMailboxPolicy
        ActiveSyncDeviceClass           = Get-ActiveSyncDeviceClass | Select-Object -Property DeviceModel, DeviceType -Unique
        ActiveSyncDeviceAccessRule      = Get-ActiveSyncDeviceAccessRule
        RetentionPolicy                 = Get-RetentionPolicy
        RetentionTag                    = Get-RetentionPolicyTag
    }

    switch ($ExchangeOnline) {
        $true { }
        Default {

            $ExchangeConfiguration.ExchangeServer = $Servers

            switch ($Optional)
            {
                'NetworkConnectionInfo'
                {
                    Write-Information -MessageData 'Running: Get-NetworkConnectionInfo'
                    $ExchangeConfiguration.NetworkConnectionInfo = foreach ($s in $Servers) { Get-NetworkConnectionInfo -Identity $s.fqdn }
                }
                'ExchangeCertificate'
                {
                    Write-Information -MessageData 'Running: Get-ExchangeCertificate'
                    $ExchangeConfiguration.ExchangeCertificate = foreach ($s in $Servers) { Get-ExchangeCertificate -Server $s.fqdn }
                }
            }

            Write-Information -MessageData 'Running: Get-SettingOverride'
            $ExchangeConfiguration.SettingOverride = Get-SettingOverride
            Write-Information -MessageData 'Running: Get-AuthConfig'
            $ExchangeConfiguration.AuthConfig = Get-AuthConfig
            Write-Information -MessageData 'Running: Get-CmdletExtensionAgent'
            $ExchangeConfiguration.CmdletExtensionAgent = Get-CmdletExtensionAgent
            Write-Information -MessageData 'Running: Get-HybridConfiguration'
            $ExchangeConfiguration.HybridConfiguration = Get-HybridConfiguration
            Write-Information -MessageData 'Running: Get-PendingFederatedDomain'
            $ExchangeConfiguration.PendingFederatedDomain = Get-PendingFederatedDomain
            Write-Information -MessageData 'Running: Get-DatabaseAvailabilityGroup'
            $ExchangeConfiguration.DatabaseAvailabilityGroup = Get-DatabaseAvailabilityGroup
            Write-Information -MessageData 'Running: Get-MailboxDatabase'
            $ExchangeConfiguration.MailboxDatabase = Get-MailboxDatabase
            Write-Information -MessageData 'Running: Get-MailboxServer'
            $ExchangeConfiguration.MailboxServer = Get-MailboxServer
            Write-Information -MessageData 'Running: Get-TransportAgent'
            $ExchangeConfiguration.TransportAgent = Get-TransportAgent
            Write-Information -MessageData 'Running: Get-TransportPipeline'
            $ExchangeConfiguration.TransportPipeline = Get-TransportPipeline
            Write-Information -MessageData 'Running: Get-UserPrincipalNamesSuffix'
            $ExchangeConfiguration.UPNSuffix = Get-UserPrincipalNamesSuffix
            Write-Information -MessageData 'Running: Get-ClientAccessServer'
            $ExchangeConfiguration.ClientAccessServer = Get-ClientAccessServer
            Write-Information -MessageData 'Running: Get-ClientAccessArray'
            $ExchangeConfiguration.ClientAccessArray = Get-ClientAccessArray
            Write-Information -MessageData 'Running: Get-PowershellVirtualDirectory -adpropertiesonly'
            $ExchangeConfiguration.PowershellVirtualDirectory = Get-PowershellVirtualDirectory -adpropertiesonly
            Write-Information -MessageData 'Running: Get-ActiveSyncVirtualDirectory -adpropertiesonly'
            $ExchangeConfiguration.ActiveSyncVirtualDirectory = Get-ActiveSyncVirtualDirectory -adpropertiesonly
            Write-Information -MessageData 'Running: Get-OabVirtualDirectory -adpropertiesonly'
            $ExchangeConfiguration.OABVirtualDirectory = Get-OabVirtualDirectory -adpropertiesonly
            Write-Information -MessageData 'Running: Get-OwaVirtualDirectory -adpropertiesonly'
            $ExchangeConfiguration.OWAVirtualDirectory = Get-OwaVirtualDirectory -adpropertiesonly
            Write-Information -MessageData 'Running: Get-EcpVirtualDirectory -adpropertiesonly'
            $ExchangeConfiguration.ECPVirtualDirectory = Get-EcpVirtualDirectory -adpropertiesonly
            Write-Information -MessageData 'Running: Get-WebServicesVirtualDirectory -adpropertiesonly'
            $ExchangeConfiguration.WebServicesVirtualDirectory = Get-WebServicesVirtualDirectory -adpropertiesonly
            Write-Information -MessageData 'Running: Get-MapiVirtualDirectory -adpropertiesonly'
            $ExchangeConfiguration.MAPIVirtualDirectory = Get-MapiVirtualDirectory -adpropertiesonly
            Write-Information -MessageData 'Running: Get-OutlookProvider'
            $ExchangeConfiguration.OutlookProvider = Get-OutlookProvider
            Write-Information -MessageData 'Running: Get-OutlookAnywhere -adpropertiesonly'
            $ExchangeConfiguration.OutlookAnywhere = Get-OutlookAnywhere -adpropertiesonly
            Write-Information -MessageData 'Running: Get-RPCClientAccess'
            $ExchangeConfiguration.RPCClientAccess = Get-RPCClientAccess
            Write-Information -MessageData 'Running: Get-AddressList'
            $ExchangeConfiguration.AddressList = Get-AddressList
            Write-Information -MessageData 'Running: Get-GlobalAddressList'
            $ExchangeConfiguration.GlobalAddressList = Get-GlobalAddressList
            Write-Information -MessageData 'Running: Get-DeliveryAgentConnector'
            $ExchangeConfiguration.DeliveryAgentConnector = Get-DeliveryAgentConnector
            Write-Information -MessageData 'Running: Get-ForeignConnector'
            $ExchangeConfiguration.ForeignConnector = Get-ForeignConnector
            Write-Information -MessageData 'Running: Get-FrontendTransportService'
            $ExchangeConfiguration.FrontEndTransportService = Get-FrontendTransportService
            Write-Information -MessageData 'Running: Get-MailboxTransportService'
            $ExchangeConfiguration.MailboxTransportService = Get-MailboxTransportService
        }
    }

    $DateString = Get-Date -Format yyyyMMddHHmmss


    $OutputFileName = $($ExchangeConfiguration.OrganizationConfig.guid.guid.split('-')[0]) + '-ExchangeConfigurationAsOf' + $DateString + '.xml'
    $OutputFilePath = Join-Path $OutputFolderPath $OutputFileName

    Write-Information -MessageData "Exporting Configuration Data to $OutputFilePath"
    $ExchangeConfiguration | Export-Clixml -Path $OutputFilePath -Encoding utf8 -Depth 5
}