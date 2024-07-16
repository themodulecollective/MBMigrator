function Export-ExchangeOnlineProtection
{
    <#
    .SYNOPSIS
        Get all Exchange Online Protection Policies from a Tenant and export to an Excel file
    .DESCRIPTION
        Get all Exchange Online Protection Policies from a Tenant and export to an Excel file
    .EXAMPLE
        Export-ExchangeOnlineProtection -OutputFolderPath "C:\Users\UserName\Documents"
        All Exchange Online Protection Policies in the connected tenant will be exported to a date stamped file with a name like EOPPoliciesAsOfyyyyMMddhhmmss.xlsx
    #>

    [cmdletbinding()]
    param(
        # Folder path for the XLSX file exprt
        [parameter(Mandatory)]
        [ValidateScript( { Test-Path -type Container -Path $_ })]
        [string]$OutputFolderPath      
        ,
        # Specify a delimiter, 1 character in length.  Default is '|'.
        [parameter()]
        [ValidateLength(1,1)]
        [string]$Delimiter = '|'
    )

    $OnlineProtectionObjectTypes = [ordered]@{
    'PhishPolicyProperties' = @(
        'AdminDisplayName'
        'AuthenticationFailAction'
        'DistinguishedName'
        'DmarcQuarantineAction'
        'DmarcRejectAction'
        'Enabled'
        'EnableFirstContactSafetyTips'
        'EnableMailboxIntelligence'
        'EnableMailboxIntelligenceProtection'
        'EnableOrganizationDomainsProtection'
        'EnableSimilarDomainsSafetyTips'
        'EnableSimilarUsersSafetyTips'
        'EnableSpoofIntelligence'
        'EnableSuspiciousSafetyTip'
        'EnableTargetedDomainsProtection'
        'EnableTargetedUserProtection'
        'EnableUnauthenticatedSender'
        'EnableUnusualCharactersSafetyTips'
        'EnableViaTag'
        @{n='ExchangeObjectId';e={$_.ExchangeObjectId.guid}},
        'ExchangeVersion'
        @{n='ExcludedDomains';e={$_.ExcludedDomains -join $Delimiter}},
        @{n='ExcludedSenders';e={$_.ExcludedSenders -join $Delimiter}},
        @{n='ExcludedSubDomains';e={$_.ExcludedSubDomains -join $Delimiter}},
        @{n='Guid';e={$_.Guid.guid}},
        'HonorDmarcPolicy'
        'Id'
        'Identity'
        'ImpersonationProtectionState'
        'IsDefault'
        'IsValid'
        'MailboxIntelligenceProtectionAction'
        @{n='MailboxIntelligenceProtectionActionRecipients';e={$_.MailboxIntelligenceProtectionActionRecipients -join $Delimiter}},
        'MailboxIntelligenceQuarantineTag'
        'Name'
        'ObjectCategory'
        'ObjectState'
        'OrganizationalUnitRoot'
        'OrganizationId'
        'OriginatingServer'
        'PhishThresholdLevel'
        'PolicyTag'
        'RecommendedPolicyType'
        'SpoofQuarantineTag'
        @{n='TargetedDomainActionRecipients';e={$_.TargetedDomainActionRecipients -join $Delimiter}},
        'TargetedDomainProtectionAction'
        'TargetedDomainQuarantineTag'
        @{n='TargetedDomainsToProtect';e={$_.TargetedDomainsToProtect -join $Delimiter}},
        @{n='TargetedUserActionRecipients';e={$_.TargetedUserActionRecipients -join $Delimiter}},
        'TargetedUserProtectionAction'
        'TargetedUserQuarantineTag'
        @{n='TargetedUsersToProtect';e={$_.TargetedUsersToProtect -join $Delimiter}},   
        'WhenChangedUTC'
        'WhenCreatedUTC'
    );

    'PhishRuleProperties' = @(
        'AntiPhishPolicy',
        'Comments',
        @{n='Conditions';e={$_.Conditions -join $Delimiter}},
        'Description',
        'DistinguishedName',
        @{n='ExceptIfRecipientDomainIs';e={$_.ExceptIfRecipientDomainIs -join $Delimiter}},
        @{n='ExceptIfSentTo';e={$_.ExceptIfSentTo -join $Delimiter}},
        @{n='ExceptIfSentToMemberOf';e={$_.ExceptIfSentToMemberOf -join $Delimiter}},
        @{n='Exceptions';e={$_.Exceptions -join $Delimiter}},
        'ExchangeVersion',
        @{n='Guid';e={$_.Guid.guid}},
        'Identity',
        @{n='ImmutableId';e={$_.ImmutableId.guid}},
        'IsValid',
        'Name',
        'ObjectState',
        'OrganizationId',
        'Priority',
        'RecipientDomainIs',
        'RuleVersion',
        @{n='SentTo';e={$_.SentTo -join $Delimiter}},
        @{n='SentToMemberOf';e={$_.SentToMemberOf -join $Delimiter}},
        'State',
        'WhenChanged'
    );

    'InboundFilterPolicyProperties' = @(
        'AddXHeaderValue',
        'AdminDisplayName',
        @{n='AllowedSenderDomains';e={$_.AllowedSenderDomains -join $Delimiter}},
        @{n='AllowedSenders';e={$_.AllowedSenders -join $Delimiter}},
        @{n='BlockedSenderDomains';e={$_.BlockedSenderDomains -join $Delimiter}},
        @{n='BlockedSenders';e={$_.BlockedSenders -join $Delimiter}},
        'BulkQuarantineTag',
        'BulkSpamAction',
        'BulkThreshold',
        'DistinguishedName',
        'DownloadLink',
        'EnableLanguageBlockList',
        'EnableRegionBlockList',
        @{n='ExchangeObjectId';e={$_.ExchangeObjectId.guid}},
        'ExchangeVersion',
        @{n='FalsePositiveAdditionalRecipients';e={$_.FalsePositiveAdditionalRecipients -join $Delimiter}},
        @{n='Guid';e={$_.Guid.guid}},
        'HighConfidencePhishAction',
        'HighConfidencePhishQuarantineTag',
        'HighConfidenceSpamAction',
        'HighConfidenceSpamQuarantineTag',
        'Id',
        'Identity',
        'IncreaseScoreWithBizOrInfoUrls',
        'IncreaseScoreWithImageLinks',
        'IncreaseScoreWithNumericIps',
        'IncreaseScoreWithRedirectToOtherPort',
        'InlineSafetyTipsEnabled',
        'IntraOrgFilterState',
        'IsDefault',
        'IsValid',
        @{n='LanguageBlockList';e={$_.LanguageBlockList -join $Delimiter}}, 
        'MarkAsSpamBulkMail',
        'MarkAsSpamEmbedTagsInHtml',
        'MarkAsSpamEmptyMessages',
        'MarkAsSpamFormTagsInHtml',
        'MarkAsSpamFramesInHtml',
        'MarkAsSpamFromAddressAuthFail',
        'MarkAsSpamJavaScriptInHtml',
        'MarkAsSpamNdrBackscatter',
        'MarkAsSpamObjectTagsInHtml',
        'MarkAsSpamSensitiveWordList',
        'MarkAsSpamSpfRecordHardFail',
        'MarkAsSpamWebBugsInHtml',
        'ModifySubjectValue',
        'Name',
        'ObjectCategory',
        'ObjectState',
        'OrganizationalUnitRoot',
        'OrganizationId',
        'OriginatingServer',
        'PhishQuarantineTag',
        'PhishSpamAction',
        'PhishZapEnabled',
        'QuarantineRetentionPeriod',
        'RecommendedPolicyType',
        @{n='RedirectToRecipients';e={$_.RedirectToRecipients -join $Delimiter}},
        @{n='RegionBlockList';e={$_.RegionBlockList -join $Delimiter}},
        'SpamAction',
        'SpamQuarantineTag',
        'SpamZapEnabled',
        'TestModeAction',
        @{n='TestModeBccToRecipients';e={$_.TestModeBccToRecipients -join $Delimiter}},
        'WhenChangedUTC',
        'WhenCreatedUTC',
        'ZapEnabled'
    );

    'InboundFilterRuleProperties' = @(
        'HostedContentFilterPolicy',
        'Comments',
        @{n='Conditions';e={$_.Conditions -join $Delimiter}},
        'Description',
        'DistinguishedName',
        @{n='ExceptIfRecipientDomainIs';e={$_.ExceptIfRecipientDomainIs -join $Delimiter}},
        @{n='ExceptIfSentTo';e={$_.ExceptIfSentTo -join $Delimiter}},
        @{n='ExceptIfSentToMemberOf';e={$_.ExceptIfSentToMemberOf -join $Delimiter}},
        @{n='Exceptions';e={$_.Exceptions -join $Delimiter}},
        'ExchangeVersion',
        @{n='Guid';e={$_.Guid.guid}},
        'Identity',
        @{n='ImmutableId';e={$_.ImmutableId.guid}},
        'IsValid',
        'Name',
        'ObjectState',
        'OrganizationId',
        'Priority',
        @{n='RecipientDomainIs';e={$_.RecipientDomainIs -join $Delimiter}},
        'RuleVersion',
        @{n='SentTo';e={$_.SentTo -join $Delimiter}},
        @{n='SentToMemberOf';e={$_.SentToMemberOf -join $Delimiter}},
        'State',
        'WhenChanged'
    );

    'OutboundSpamFilterPolicyProperties' = @(
        'ActionWhenThresholdReached',
        'AdminDisplayName',
        'AutoForwardingMode',
        @{n='BccSuspiciousOutboundAdditionalRecipients';e={$_.BccSuspiciousOutboundAdditionalRecipients -join $Delimiter}},
        'BccSuspiciousOutboundMail',
        'ConfigurationType',
        'DistinguishedName',
        'Enabled',
        @{n='ExchangeObjectId';e={$_.ExchangeObjectId.guid}},
        'ExchangeVersion',
        @{n='Guid';e={$_.Guid.guid}},
        'Id',
        'Identity',
        'IsDefault',
        'IsValid',
        'Name',
        'NotifyOutboundSpam',
        @{n='NotifyOutboundSpamRecipients';e={$_.NotifyOutboundSpamRecipients -join $Delimiter}}, 
        'ObjectCategory',
        'ObjectState',
        'OrganizationalUnitRoot',
        'OrganizationId',
        'OriginatingServer',
        'RecipientLimitExternalPerHour',
        'RecipientLimitInternalPerHour',
        'RecipientLimitPerDay',
        'RecommendedPolicyType',
        'WhenChangedUTC',
        'WhenCreatedUTC'
    );

    'OutboundFilterRuleProperties' = @(
        'Comments',
        @{n='Conditions';e={$_.Conditions -join $Delimiter}}
        'Description',
        'DistinguishedName',
        @{n='ExceptIfFrom';e={$_.ExceptIfFrom -join $Delimiter}},
        @{n='ExceptIfFromMemberOf';e={$_.ExceptIfFromMemberOf -join $Delimiter}},
        @{n='ExceptIfSenderDomainIs';e={$_.ExceptIfSenderDomainIs -join $Delimiter}},
        @{n='Exceptions';e={$_.Exceptions -join $Delimiter}},
        'ExchangeVersion',
        @{n='From';e={$_.From -join $Delimiter}},
        @{n='FromMemberOf';e={$_.FromMemberOf -join $Delimiter}},
        @{n='Guid';e={$_.Guid.guid}},
        'HostedOutboundSpamFilterPolicy',
        'Identity',
        @{n='ImmutableId';e={$_.ImmutableId.guid}},
        'IsValid',
        'Name',
        'ObjectState',
        'OrganizationId',
        'Priority',
        'RuleVersion',
        @{n='SenderDomainIs';e={$_.SenderDomainIs -join $Delimiter}},
        'State',
        'WhenChanged'
    );

    'MalwareFilterPolicyProperties' = @(
        'AdminDisplayName',
        'CustomExternalBody',
        'CustomExternalSubject',
        'CustomFromAddress',
        'CustomFromName',
        'CustomInternalBody',
        'CustomInternalSubject',
        'CustomNotifications',
        'DistinguishedName',
        'EnableExternalSenderAdminNotifications',
        'EnableFileFilter',
        'EnableInternalSenderAdminNotifications',
        @{n='ExchangeObjectId';e={$_.ExchangeObjectId.guid}},
        'ExchangeVersion',
        'ExternalSenderAdminAddress',
        'FileTypeAction',
        @{n='FileTypes';e={$_.FileTypes -join $Delimiter}},        
        @{n='Guid';e={$_.Guid.guid}},
        'Id',
        'Identity',
        'InternalSenderAdminAddress',
        'IsDefault',
        'IsPolicyOverrideApplied',
        'IsValid',
        'Name',
        'ObjectCategory',
        'ObjectState',
        'OrganizationalUnitRoot',
        'OrganizationId',
        'OriginatingServer',
        'QuarantineTag',
        'RecommendedPolicyType',
        'WhenChangedUTC',
        'WhenCreatedUTC',
        'ZapEnabled'
    );

    'MalwareFilterRuleProperties' = @(
        'Comments',
        @{n='Conditions';e={$_.Conditions -join $Delimiter}},
        'Description',
        'DistinguishedName',
        @{n='ExceptIfRecipientDomainIs';e={$_.ExceptIfRecipientDomainIs -join $Delimiter}},
        @{n='ExceptIfSentTo';e={$_.ExceptIfSentTo -join $Delimiter}},
        @{n='ExceptIfSentToMemberOf';e={$_.ExceptIfSentToMemberOf -join $Delimiter}},
        @{n='Exceptions';e={$_.Exceptions -join $Delimiter}},
        'ExchangeVersion',
        @{n='Guid';e={$_.Guid.guid}},
        'Identity',
        @{n='ImmutableId';e={$_.ImmutableId.guid}},
        'IsValid',
        'MalwareFilterPolicy',
        'Name',
        'ObjectState',
        'OrganizationId',
        'Priority',
        @{n='RecipientDomainIs';e={$_.RecipientDomainIs -join $Delimiter}},
        'RuleVersion',
        @{n='SentTo';e={$_.SentTo -join $Delimiter}},
        @{n='SentToMemberOf';e={$_.SentToMemberOf -join $Delimiter}},
        'State',
        'WhenChanged'
    );

    'SafeAttachmentPolicyProperties' = @(
        'Action',
        'AdminDisplayName',
        'DistinguishedName',
        'Enable',
        'EnableOrganizationBranding',
        @{n='ExchangeObjectId';e={$_.ExchangeObjectId.guid}},
        'ExchangeVersion',
        @{n='Guid';e={$_.Guid.guid}},
        'Id',
        'Identity',
        'IsBuiltInProtection',
        'IsDefault',
        'IsValid',
        'Name',
        'ObjectCategory',
        'ObjectState',
        'OrganizationalUnitRoot',
        'OrganizationId',
        'OriginatingServer',
        'QuarantineTag',
        'RecommendedPolicyType',
        'Redirect',
        'RedirectAddress',
        'WhenChangedUTC',
        'WhenCreatedUTC'
    );

    'SafeAttachmentRuleProperties' = @( #these are speculative properties - need an environment that actually has one
        'Comments',
        'Conditions',
        'Description',
        'DistinguishedName',
        @{n='ExceptIfRecipientDomainIs';e={$_.ExceptIfRecipientDomainIs -join $Delimiter}},
        @{n='ExceptIfSentTo';e={$_.ExceptIfSentTo -join $Delimiter}},
        @{n='ExceptIfSentToMemberOf';e={$_.ExceptIfSentToMemberOf -join $Delimiter}},
        @{n='Exceptions';e={$_.Exceptions -join $Delimiter}},
        'ExchangeVersion',
        @{n='Guid';e={$_.Guid.guid}},
        'Identity',
        @{n='ImmutableId';e={$_.ImmutableId.guid}},
        'IsValid',
        'SafeAttachmentPolicy',
        'Name',
        'ObjectState',
        'OrganizationId',
        'Priority',
        @{n='RecipientDomainIs';e={$_.RecipientDomainIs -join $Delimiter}},
        'RuleVersion',
        @{n='SentTo';e={$_.SentTo -join $Delimiter}},
        @{n='SentToMemberOf';e={$_.SentToMemberOf -join $Delimiter}},
        'State',
        'WhenChanged'
    );

    'SafeLinksPolicyProperties' = @(
        'AdminDisplayName',
        'AllowClickThrough',
        'CustomNotificationText',
        'DeliverMessageAfterScan',
        'DisableUrlRewrite',
        'DistinguishedName',
        @{n='DoNotRewriteUrls';e={$_.DoNotRewriteUrls -join $Delimiter}},
        'EnableForInternalSenders',
        'EnableOrganizationBranding',
        'EnableSafeLinksForEmail',
        'EnableSafeLinksForOffice',
        'EnableSafeLinksForTeams',
        @{n='ExchangeObjectId';e={$_.ExchangeObjectId.guid}},
        'ExchangeVersion',
        @{n='Guid';e={$_.Guid.guid}},
        'Id',
        'Identity',
        'IsBuiltInProtection',
        'IsValid',
        @{n='LocalizedNotificationTextList';e={$_.LocalizedNotificationTextList.tostring() -join $Delimiter}},
        'Name',
        'ObjectCategory',
        'ObjectState',
        'OrganizationalUnitRoot',
        'OrganizationId',
        'OriginatingServer',
        'RecommendedPolicyType',
        'ScanUrls',
        'TrackClicks',
        'WhenChangedUTC',
        'WhenCreatedUTC'
    );

    'SafeLinksRuleProperties' = @( #these are speculative properties - need an environment that actually has one
        'Comments',
        'Conditions',
        'Description',
        'DistinguishedName',
        @{n='ExceptIfRecipientDomainIs';e={$_.ExceptIfRecipientDomainIs -join $Delimiter}},
        @{n='ExceptIfSentTo';e={$_.ExceptIfSentTo -join $Delimiter}},
        @{n='ExceptIfSentToMemberOf';e={$_.ExceptIfSentToMemberOf -join $Delimiter}},
        @{n='Exceptions';e={$_.Exceptions -join $Delimiter}},
        'ExchangeVersion',
        @{n='Guid';e={$_.Guid.guid}},
        'Identity',
        @{n='ImmutableId';e={$_.ImmutableId.guid}},
        'IsValid',
        'SafeAttachmentPolicy',
        'Name',
        'ObjectState',
        'OrganizationId',
        'Priority',
        @{n='RecipientDomainIs';e={$_.RecipientDomainIs -join $Delimiter}},
        'RuleVersion',
        @{n='SentTo';e={$_.SentTo -join $Delimiter}},
        @{n='SentToMemberOf';e={$_.SentToMemberOf -join $Delimiter}},
        'State',
        'WhenChanged'
    );

    'AllowBlockListItemProperties' = @(
        'Action',
        'CreatedDateTime',
        'EntryValueHash',
        'Error',
        'ExpirationDate',
        'Identity',
        'LastModifiedDateTime',
        'LastUsedDate',
        'ListSubType',
        'ModifiedBy',
        'Notes',
        'ObjectState',
        'RemoveAfter',
        'SubmissionID',
        'SysManaged',
        'Value'
    );

    'DKIMSigningConfigEntryProperties' = @(
        'AdminDisplayName',
        'Algorithm',
        'BodyCanonicalization',
        'DistinguishedName',
        'Domain',
        'Enabled',
        @{n='ExchangeObjectId';e={$_.ExchangeObjectId.guid}},
        'ExchangeVersion',
        @{n='Guid';e={$_.Guid.guid}},
        'HeaderCanonicalization',
        'Id',
        'Identity',
        'IncludeKeyExpiration',
        'IncludeSignatureCreationTime',
        'IsDefault',
        'IsValid',
        'KeyCreationTime',
        'LastChecked',
        'Name',
        'NumberOfBytesToSign',
        'ObjectCategory',
        'ObjectState',
        'OrganizationalUnitRoot',
        'OrganizationId',
        'OriginatingServer',
        'RotateOnDate',
        'Selector1CNAME',
        'Selector1KeySize',
        'Selector1PublicKey',
        'Selector2CNAME',
        'Selector2KeySize',
        'Selector2PublicKey',
        'SelectorAfterRotateOnDate',
        'SelectorBeforeRotateOnDate',
        'Status',
        'WhenChangedUTC',
        'WhenCreatedUTC'
    );

    'HostedConnectionFilterPolicyProperties' = @(
        'AdminDisplayName',
        'DirectoryBasedEdgeBlockMode',
        'DistinguishedName',
        'EnableSafeList',
        @{n='ExchangeObjectId';e={$_.ExchangeObjectId.guid}},
        'ExchangeVersion',
        @{n='Guid';e={$_.Guid.guid}},
        'Id',
        'Identity',
        @{n='IPAllowList';e={$_.IPAllowList -join $Delimiter}},        
        @{n='IPBlockList';e={$_.IPBlockList -join $Delimiter}},   
        'IsDefault',
        'IsValid',
        'Name',
        'ObjectCategory',
        'ObjectState',
        'OrganizationalUnitRoot',
        'OrganizationId',
        'OriginatingServer',
        'WhenChangedUTC',
        'WhenCreatedUTC'
    );

    'QuarantinePolicyProperties' = @(
        'DistinguishedName',
        'EndUserQuarantinePermissions',
        'ESNEnabled',
        @{n='ExchangeObjectId';e={$_.ExchangeObjectId.guid}},
        'ExchangeVersion',
        @{n='Guid';e={$_.Guid.guid}},
        'Id',
        'Identity',
        'IncludeMessagesFromBlockedSenderAddress',
        'IsValid',
        'Name',
        'ObjectCategory',
        'ObjectState',
        'OrganizationalUnitRoot',
        'OrganizationId',
        'OriginatingServer',
        'QuarantinePolicyType',
        'QuarantineRetentionDays',
        'WhenChangedUTC',
        'WhenCreatedUTC'
    );

    'InboundConnectorProperties' = @(
        'AdminDisplayName',
        @{n='AssociatedAcceptedDomains';e={$_.AssociatedAcceptedDomains -join $Delimiter}},        
        @{n='ClientHostNames';e={$_.ClientHostNames -join $Delimiter}},        
        'CloudServicesMailEnabled',
        'Comment',
        'ConnectorSource',
        'ConnectorType',
        'DistinguishedName',
        @{n='EFSkipIPs';e={$_.EFSkipIPs -join $Delimiter}},        
        'EFSkipLastIP',
        @{n='EFSkipMailGateway';e={$_.EFSkipMailGateway -join $Delimiter}},
        'EFTestMode',
        @{n='EFUsers';e={$_.EFUsers -join $Delimiter}},        
        'Enabled',
        @{n='ExchangeObjectId';e={$_.ExchangeObjectId.guid}},
        'ExchangeVersion',
        @{n='Guid';e={$_.Guid.guid}},
        'Id',
        'Identity',
        'IsValid',
        'Name',
        @{n='NameHashGuid';e={$_.NameHashGuid.guid}},
        'ObjectCategory',
        'ObjectState',
        'OrganizationalUnitRoot',
        'OrganizationalUnitRootInternal',
        'OrganizationId',
        'OriginatingServer',
        'RequireTls',
        'RestrictDomainsToCertificate',
        'RestrictDomainsToIPAddresses',
        @{n='ScanAndDropRecipients';e={$_.ScanAndDropRecipients -join $Delimiter}},        
        @{n='SenderDomains';e={$_.SenderDomains -join $Delimiter}},        
        @{n='SenderIPAddresses';e={$_.SenderIPAddresses -join $Delimiter}},        
        'TlsSenderCertificateName',
        'TreatMessagesAsInternal',
        @{n='TrustedOrganizations';e={$_.TrustedOrganizations -join $Delimiter}},        
        'WhenChangedUTC',
        'WhenCreatedUTC'
    );

    'OutboundConnectorProperties' = @(
        'AdminDisplayName',
        'AllAcceptedDomains',
        'CloudServicesMailEnabled',
        'Comment',
        'ConnectorSource',
        'ConnectorType',
        'DistinguishedName',
        'Enabled',
        @{n='ExchangeObjectId';e={$_.ExchangeObjectId.guid}},
        'ExchangeVersion',
        @{n='Guid';e={$_.Guid.guid}},
        'Id',
        'Identity',
        'IsTransportRuleScoped',
        'IsValid',
        'IsValidated',
        'LastValidationTimestamp',
        'LinkForModifiedConnector',
        'Name',
        'ObjectCategory',
        'ObjectState',
        'OrganizationalUnitRoot',
        'OrganizationId',
        'OriginatingServer',
        @{n='RecipientDomains';e={$_.RecipientDomains -join $Delimiter}},        
        'RouteAllMessagesViaOnPremises',
        'SenderRewritingEnabled',
        @{n='SmartHosts';e={$_.SmartHosts -join $Delimiter}},        
        'TestMode',
        'TlsDomain',
        'TlsSettings',
        'UseMXRecord',
        @{n='ValidationRecipients';e={$_.ValidationRecipients -join $Delimiter}},
        'WhenChangedUTC',
        'WhenCreatedUTC'
    );
}

    $DateString = Get-Date -Format yyyyMMddhhmmss

    $OutputFileName = 'ExchangeOnlineProtectionPolicies' + 'AsOf' + $DateString
    $ExcelOutputFilePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.xlsx')
    $JSONOutputFilePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.json')
    $exportExcelParams = @{
        Path = $ExcelOutputFilePath
        TableStyle = 'Medium11'
        WorksheetName = $null
        TableName = $null
        AutoSize = $true
        FreezeTopRow = $true
    }

    foreach ($key in $OnlineProtectionObjectTypes.Keys)
    {

        $exportExcelParams.WorksheetName = $key
        $exportExcelParams.TableName = $key
        $property = $OnlineProtectionObjectTypes.$key

        $OPObjects = @(
            switch ($key)
            {
                'PhishPolicyProperties' { 

                    Get-AntiPhishPolicy

                }
                'PhishRuleProperties' {

                    Get-AntiPhishRule
                    
                }
                'InboundFilterPolicyProperties' { 

                    Get-HostedContentFilterPolicy

                }
                'InboundFilterRuleProperties' { 

                    Get-HostedContentFilterRule

                }
                'OutboundSpamFilterPolicyProperties' { 
                    
                    Get-HostedOutboundSpamFilterPolicy
                    
                }
                'OutboundFilterRuleProperties' { 
                    
                    Get-HostedOutboundSpamFilterRule
                    
                }
                'MalwareFilterPolicyProperties' { 
                    
                    Get-MalwareFilterPolicy
                    
                }
                'MalwareFilterRuleProperties' { 
                    
                    Get-MalwareFilterRule
                    
                }
                'SafeAttachmentPolicyProperties' { 
                    
                    Get-SafeAttachmentPolicy
                    
                }
                'SafeAttachmentRuleProperties' { 
                    
                    Get-SafeAttachmentRule
                    
                }
                'SafeLinksPolicyProperties' { 
                    
                    Get-SafeLinksPolicy
                    
                }
                'SafeLinksRuleProperties' { 
                    
                    Get-SafeLinksRule
                    
                }
                'AllowBlockListItemProperties' { 
                    
                    Get-TenantAllowBlockListItems -ListType FileHash
                    Get-TenantAllowBlockListItems -ListType Url
                    Get-TenantAllowBlockListItems -ListType Sender
                    Get-TenantAllowBlockListItems -ListType BulkSender
                    Get-TenantAllowBlockListItems -ListType Recipient
                    Get-TenantAllowBlockListItems -ListType IP

                }
                'DKIMSigningConfigEntryProperties' { 
                    
                    Get-DkimSigningConfig
                    
                }
                'HostedConnectionFilterPolicyProperties' { 
                    
                    Get-HostedConnectionFilterPolicy
                    
                }
                'QuarantinePolicyProperties' { 
                    
                    Get-QuarantinePolicy
                    
                }
                'InboundConnectorProperties' { 
                    
                    Get-InboundConnector
                    
                }
                'OutboundConnectorProperties' { 

                    Get-OutboundConnector

                }    
            }
        ) 
        $OPObjects | ConvertTo-Json | Out-File -FilePath $JSONOutputFilePath -Encoding utf8
        $OPObjects | Select-Object -Property $property | Export-Excel @exportExcelParams
    }
}