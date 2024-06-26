MERGE dbo.Mailboxes AS Target USING [dbo].[IncomingMailboxes] AS Source ON (Target.ExchangeGUID = Source.ExchangeGUID)
WHEN MATCHED THEN
UPDATE
SET
    [Database] = Source.[Database],
    [MessageCopyForSentAsEnabled] = Source.[MessageCopyForSentAsEnabled],
    [MessageCopyForSendOnBehalfEnabled] = Source.[MessageCopyForSendOnBehalfEnabled],
    [MailboxProvisioningPreferences] = Source.[MailboxProvisioningPreferences],
    [UseDatabaseRetentionDefaults] = Source.[UseDatabaseRetentionDefaults],
    [RetainDeletedItemsUntilBackup] = Source.[RetainDeletedItemsUntilBackup],
    [DeliverToMailboxAndForward] = Source.[DeliverToMailboxAndForward],
    [IsExcludedFromServingHierarchy] = Source.[IsExcludedFromServingHierarchy],
    [IsHierarchyReady] = Source.[IsHierarchyReady],
    [LitigationHoldEnabled] = Source.[LitigationHoldEnabled],
    [SingleItemRecoveryEnabled] = Source.[SingleItemRecoveryEnabled],
    [RetentionHoldEnabled] = Source.[RetentionHoldEnabled],
    [EndDateForRetentionHold] = Source.[EndDateForRetentionHold],
    [StartDateForRetentionHold] = Source.[StartDateForRetentionHold],
    [RetentionComment] = Source.[RetentionComment],
    [RetentionUrl] = Source.[RetentionUrl],
    [LitigationHoldDate] = Source.[LitigationHoldDate],
    [LitigationHoldOwner] = Source.[LitigationHoldOwner],
    [LitigationHoldDuration] = Source.[LitigationHoldDuration],
    [ManagedFolderMailboxPolicy] = Source.[ManagedFolderMailboxPolicy],
    [RetentionPolicy] = Source.[RetentionPolicy],
    [AddressBookPolicy] = Source.[AddressBookPolicy],
    [CalendarRepairDisabled] = Source.[CalendarRepairDisabled],
    [ExchangeUserAccountControl] = Source.[ExchangeUserAccountControl],
    [AdminDisplayVersion] = Source.[AdminDisplayVersion],
    [MessageTrackingReadStatusEnabled] = Source.[MessageTrackingReadStatusEnabled],
    [ExternalOofOptions] = Source.[ExternalOofOptions],
    [ForwardingAddress] = Source.[ForwardingAddress],
    [ForwardingSmtpAddress] = Source.[ForwardingSmtpAddress],
    [RetainDeletedItemsFor] = Source.[RetainDeletedItemsFor],
    [IsMailboxEnabled] = Source.[IsMailboxEnabled],
    [OfflineAddressBook] = Source.[OfflineAddressBook],
    [ProhibitSendQuota] = Source.[ProhibitSendQuota],
    [ProhibitSendReceiveQuota] = Source.[ProhibitSendReceiveQuota],
    [RecoverableItemsQuota] = Source.[RecoverableItemsQuota],
    [RecoverableItemsWarningQuota] = Source.[RecoverableItemsWarningQuota],
    [CalendarLoggingQuota] = Source.[CalendarLoggingQuota],
    [DowngradeHighPriorityMessagesEnabled] = Source.[DowngradeHighPriorityMessagesEnabled],
    [RecipientLimits] = Source.[RecipientLimits],
    [ImListMigrationCompleted] = Source.[ImListMigrationCompleted],
    [IsResource] = Source.[IsResource],
    [IsLinked] = Source.[IsLinked],
    [IsShared] = Source.[IsShared],
    [IsRootPublicFolderMailbox] = Source.[IsRootPublicFolderMailbox],
    [LinkedMasterAccount] = Source.[LinkedMasterAccount],
    [ResetPasswordOnNextLogon] = Source.[ResetPasswordOnNextLogon],
    [ResourceCapacity] = Source.[ResourceCapacity],
    [ResourceCustom] = Source.[ResourceCustom],
    [ResourceType] = Source.[ResourceType],
    [RoomMailboxAccountEnabled] = Source.[RoomMailboxAccountEnabled],
    [SamAccountName] = Source.[SamAccountName],
    [SCLDeleteThreshold] = Source.[SCLDeleteThreshold],
    [SCLDeleteEnabled] = Source.[SCLDeleteEnabled],
    [SCLRejectThreshold] = Source.[SCLRejectThreshold],
    [SCLRejectEnabled] = Source.[SCLRejectEnabled],
    [SCLQuarantineThreshold] = Source.[SCLQuarantineThreshold],
    [SCLQuarantineEnabled] = Source.[SCLQuarantineEnabled],
    [SCLJunkThreshold] = Source.[SCLJunkThreshold],
    [SCLJunkEnabled] = Source.[SCLJunkEnabled],
    [AntispamBypassEnabled] = Source.[AntispamBypassEnabled],
    [ServerLegacyDN] = Source.[ServerLegacyDN],
    [ServerName] = Source.[ServerName],
    [UseDatabaseQuotaDefaults] = Source.[UseDatabaseQuotaDefaults],
    [IssueWarningQuota] = Source.[IssueWarningQuota],
    [RulesQuota] = Source.[RulesQuota],
    [Office] = Source.[Office],
    [UserPrincipalName] = Source.[UserPrincipalName],
    [UMEnabled] = Source.[UMEnabled],
    [MaxSafeSenders] = Source.[MaxSafeSenders],
    [MaxBlockedSenders] = Source.[MaxBlockedSenders],
    [NetID] = Source.[NetID],
    [ReconciliationId] = Source.[ReconciliationId],
    [WindowsLiveID] = Source.[WindowsLiveID],
    [MicrosoftOnlineServicesID] = Source.[MicrosoftOnlineServicesID],
    [ThrottlingPolicy] = Source.[ThrottlingPolicy],
    [RoleAssignmentPolicy] = Source.[RoleAssignmentPolicy],
    [DefaultPublicFolderMailbox] = Source.[DefaultPublicFolderMailbox],
    [SharingPolicy] = Source.[SharingPolicy],
    [ArchiveDatabase] = Source.[ArchiveDatabase],
    [ArchiveGuid] = Source.[ArchiveGuid],
    [ArchiveName] = Source.[ArchiveName],
    [ArchiveQuota] = Source.[ArchiveQuota],
    [ArchiveWarningQuota] = Source.[ArchiveWarningQuota],
    [ArchiveDomain] = Source.[ArchiveDomain],
    [ArchiveStatus] = Source.[ArchiveStatus],
    [ArchiveState] = Source.[ArchiveState],
    [IsAuxMailbox] = Source.[IsAuxMailbox],
    [CalendarVersionStoreDisabled] = Source.[CalendarVersionStoreDisabled],
    [ImmutableId] = Source.[ImmutableId],
    [PersistedCapabilities] = Source.[PersistedCapabilities],
    [SKUAssigned] = Source.[SKUAssigned],
    [AuditEnabled] = Source.[AuditEnabled],
    [AuditLogAgeLimit] = Source.[AuditLogAgeLimit],
    [WhenMailboxCreated] = Source.[WhenMailboxCreated],
    [SourceAnchor] = Source.[SourceAnchor],
    [UsageLocation] = Source.[UsageLocation],
    [IsSoftDeletedByRemove] = Source.[IsSoftDeletedByRemove],
    [IsSoftDeletedByDisable] = Source.[IsSoftDeletedByDisable],
    [IsInactiveMailbox] = Source.[IsInactiveMailbox],
    [IncludeInGarbageCollection] = Source.[IncludeInGarbageCollection],
    [WhenSoftDeleted] = Source.[WhenSoftDeleted],
    [InPlaceHolds] = Source.[InPlaceHolds],
    [GeneratedOfflineAddressBooks] = Source.[GeneratedOfflineAddressBooks],
    [Extensions] = Source.[Extensions],
    [HasPicture] = Source.[HasPicture],
    [HasSpokenName] = Source.[HasSpokenName],
    [AcceptMessagesOnlyFrom] = Source.[AcceptMessagesOnlyFrom],
    [AcceptMessagesOnlyFromDLMembers] = Source.[AcceptMessagesOnlyFromDLMembers],
    [AcceptMessagesOnlyFromSendersOrMembers] = Source.[AcceptMessagesOnlyFromSendersOrMembers],
    [Alias] = Source.[Alias],
    [BypassModerationFromSendersOrMembers] = Source.[BypassModerationFromSendersOrMembers],
    [OrganizationalUnit] = Source.[OrganizationalUnit],
    [CustomAttribute1] = Source.[CustomAttribute1],
    [CustomAttribute10] = Source.[CustomAttribute10],
    [CustomAttribute11] = Source.[CustomAttribute11],
    [CustomAttribute12] = Source.[CustomAttribute12],
    [CustomAttribute13] = Source.[CustomAttribute13],
    [CustomAttribute14] = Source.[CustomAttribute14],
    [CustomAttribute15] = Source.[CustomAttribute15],
    [CustomAttribute2] = Source.[CustomAttribute2],
    [CustomAttribute3] = Source.[CustomAttribute3],
    [CustomAttribute4] = Source.[CustomAttribute4],
    [CustomAttribute5] = Source.[CustomAttribute5],
    [CustomAttribute6] = Source.[CustomAttribute6],
    [CustomAttribute7] = Source.[CustomAttribute7],
    [CustomAttribute8] = Source.[CustomAttribute8],
    [CustomAttribute9] = Source.[CustomAttribute9],
    [ExtensionCustomAttribute1] = Source.[ExtensionCustomAttribute1],
    [ExtensionCustomAttribute2] = Source.[ExtensionCustomAttribute2],
    [ExtensionCustomAttribute3] = Source.[ExtensionCustomAttribute3],
    [ExtensionCustomAttribute4] = Source.[ExtensionCustomAttribute4],
    [ExtensionCustomAttribute5] = Source.[ExtensionCustomAttribute5],
    [DisplayName] = Source.[DisplayName],
    [ExternalDirectoryObjectId] = Source.[ExternalDirectoryObjectId],
    [HiddenFromAddressListsEnabled] = Source.[HiddenFromAddressListsEnabled],
    [LastExchangeChangedTime] = Source.[LastExchangeChangedTime],
    [LegacyExchangeDN] = Source.[LegacyExchangeDN],
    [MaxSendSize] = Source.[MaxSendSize],
    [MaxReceiveSize] = Source.[MaxReceiveSize],
    [ModeratedBy] = Source.[ModeratedBy],
    [ModerationEnabled] = Source.[ModerationEnabled],
    [EmailAddressPolicyEnabled] = Source.[EmailAddressPolicyEnabled],
    [PrimarySmtpAddress] = Source.[PrimarySmtpAddress],
    [RecipientType] = Source.[RecipientType],
    [RecipientTypeDetails] = Source.[RecipientTypeDetails],
    [RejectMessagesFrom] = Source.[RejectMessagesFrom],
    [RejectMessagesFromDLMembers] = Source.[RejectMessagesFromDLMembers],
    [RejectMessagesFromSendersOrMembers] = Source.[RejectMessagesFromSendersOrMembers],
    [RequireSenderAuthenticationEnabled] = Source.[RequireSenderAuthenticationEnabled],
    [SimpleDisplayName] = Source.[SimpleDisplayName],
    [SendModerationNotifications] = Source.[SendModerationNotifications],
    [WindowsEmailAddress] = Source.[WindowsEmailAddress],
    [MailTip] = Source.[MailTip],
    [MailTipTranslations] = Source.[MailTipTranslations],
    [Identity] = Source.[Identity],
    [IsValid] = Source.[IsValid],
    [ExchangeVersion] = Source.[ExchangeVersion],
    [Name] = Source.[Name],
    [DistinguishedName] = Source.[DistinguishedName],
    [Guid] = Source.[Guid],
    [WhenChanged] = Source.[WhenChanged],
    [WhenCreated] = Source.[WhenCreated],
    [WhenChangedUTC] = Source.[WhenChangedUTC],
    [WhenCreatedUTC] = Source.[WhenCreatedUTC],
    [OrganizationId] = Source.[OrganizationId],
    [Id] = Source.[Id],
    [OriginatingServer] = Source.[OriginatingServer],
    [ObjectState] = Source.[ObjectState],
    [EmailAddresses] = Source.[EmailAddresses],
    [GrantSendOnBehalfTo] = Source.[GrantSendOnBehalfTo]
    WHEN NOT MATCHED BY TARGET THEN
INSERT
    (
        [Database],
        MessageCopyForSentAsEnabled,
        MessageCopyForSendOnBehalfEnabled,
        MailboxProvisioningPreferences,
        UseDatabaseRetentionDefaults,
        RetainDeletedItemsUntilBackup,
        DeliverToMailboxAndForward,
        IsExcludedFromServingHierarchy,
        IsHierarchyReady,
        LitigationHoldEnabled,
        SingleItemRecoveryEnabled,
        RetentionHoldEnabled,
        EndDateForRetentionHold,
        StartDateForRetentionHold,
        RetentionComment,
        RetentionUrl,
        LitigationHoldDate,
        LitigationHoldOwner,
        LitigationHoldDuration,
        ManagedFolderMailboxPolicy,
        RetentionPolicy,
        AddressBookPolicy,
        CalendarRepairDisabled,
        ExchangeGuid,
        ExchangeUserAccountControl,
        AdminDisplayVersion,
        MessageTrackingReadStatusEnabled,
        ExternalOofOptions,
        ForwardingAddress,
        ForwardingSmtpAddress,
        RetainDeletedItemsFor,
        IsMailboxEnabled,
        OfflineAddressBook,
        ProhibitSendQuota,
        ProhibitSendReceiveQuota,
        RecoverableItemsQuota,
        RecoverableItemsWarningQuota,
        CalendarLoggingQuota,
        DowngradeHighPriorityMessagesEnabled,
        RecipientLimits,
        ImListMigrationCompleted,
        IsResource,
        IsLinked,
        IsShared,
        IsRootPublicFolderMailbox,
        LinkedMasterAccount,
        ResetPasswordOnNextLogon,
        ResourceCapacity,
        ResourceCustom,
        ResourceType,
        RoomMailboxAccountEnabled,
        SamAccountName,
        SCLDeleteThreshold,
        SCLDeleteEnabled,
        SCLRejectThreshold,
        SCLRejectEnabled,
        SCLQuarantineThreshold,
        SCLQuarantineEnabled,
        SCLJunkThreshold,
        SCLJunkEnabled,
        AntispamBypassEnabled,
        ServerLegacyDN,
        ServerName,
        UseDatabaseQuotaDefaults,
        IssueWarningQuota,
        RulesQuota,
        Office,
        UserPrincipalName,
        UMEnabled,
        MaxSafeSenders,
        MaxBlockedSenders,
        NetID,
        ReconciliationId,
        WindowsLiveID,
        MicrosoftOnlineServicesID,
        ThrottlingPolicy,
        RoleAssignmentPolicy,
        DefaultPublicFolderMailbox,
        SharingPolicy,
        ArchiveDatabase,
        ArchiveGuid,
        ArchiveName,
        ArchiveQuota,
        ArchiveWarningQuota,
        ArchiveDomain,
        ArchiveStatus,
        ArchiveState,
        IsAuxMailbox,
        CalendarVersionStoreDisabled,
        ImmutableId,
        PersistedCapabilities,
        SKUAssigned,
        AuditEnabled,
        AuditLogAgeLimit,
        WhenMailboxCreated,
        SourceAnchor,
        UsageLocation,
        IsSoftDeletedByRemove,
        IsSoftDeletedByDisable,
        IsInactiveMailbox,
        IncludeInGarbageCollection,
        WhenSoftDeleted,
        InPlaceHolds,
        GeneratedOfflineAddressBooks,
        Extensions,
        HasPicture,
        HasSpokenName,
        AcceptMessagesOnlyFrom,
        AcceptMessagesOnlyFromDLMembers,
        AcceptMessagesOnlyFromSendersOrMembers,
        Alias,
        BypassModerationFromSendersOrMembers,
        OrganizationalUnit,
        CustomAttribute1,
        CustomAttribute10,
        CustomAttribute11,
        CustomAttribute12,
        CustomAttribute13,
        CustomAttribute14,
        CustomAttribute15,
        CustomAttribute2,
        CustomAttribute3,
        CustomAttribute4,
        CustomAttribute5,
        CustomAttribute6,
        CustomAttribute7,
        CustomAttribute8,
        CustomAttribute9,
        ExtensionCustomAttribute1,
        ExtensionCustomAttribute2,
        ExtensionCustomAttribute3,
        ExtensionCustomAttribute4,
        ExtensionCustomAttribute5,
        DisplayName,
        ExternalDirectoryObjectId,
        HiddenFromAddressListsEnabled,
        LastExchangeChangedTime,
        LegacyExchangeDN,
        MaxSendSize,
        MaxReceiveSize,
        ModeratedBy,
        ModerationEnabled,
        EmailAddressPolicyEnabled,
        PrimarySmtpAddress,
        RecipientType,
        RecipientTypeDetails,
        RejectMessagesFrom,
        RejectMessagesFromDLMembers,
        RejectMessagesFromSendersOrMembers,
        RequireSenderAuthenticationEnabled,
        SimpleDisplayName,
        SendModerationNotifications,
        WindowsEmailAddress,
        MailTip,
        MailTipTranslations,
        [Identity],
        IsValid,
        ExchangeVersion,
        Name,
        DistinguishedName,
        Guid,
        WhenChanged,
        WhenCreated,
        WhenChangedUTC,
        WhenCreatedUTC,
        OrganizationId,
        Id,
        OriginatingServer,
        ObjectState,
        EmailAddresses,
        GrantSendOnBehalfTo
    )
VALUES
    (
        Source.[Database],
        Source.MessageCopyForSentAsEnabled,
        Source.MessageCopyForSendOnBehalfEnabled,
        Source.MailboxProvisioningPreferences,
        Source.UseDatabaseRetentionDefaults,
        Source.RetainDeletedItemsUntilBackup,
        Source.DeliverToMailboxAndForward,
        Source.IsExcludedFromServingHierarchy,
        Source.IsHierarchyReady,
        Source.LitigationHoldEnabled,
        Source.SingleItemRecoveryEnabled,
        Source.RetentionHoldEnabled,
        Source.EndDateForRetentionHold,
        Source.StartDateForRetentionHold,
        Source.RetentionComment,
        Source.RetentionUrl,
        Source.LitigationHoldDate,
        Source.LitigationHoldOwner,
        Source.LitigationHoldDuration,
        Source.ManagedFolderMailboxPolicy,
        Source.RetentionPolicy,
        Source.AddressBookPolicy,
        Source.CalendarRepairDisabled,
        Source.ExchangeGuid,
        Source.ExchangeUserAccountControl,
        Source.AdminDisplayVersion,
        Source.MessageTrackingReadStatusEnabled,
        Source.ExternalOofOptions,
        Source.ForwardingAddress,
        Source.ForwardingSmtpAddress,
        Source.RetainDeletedItemsFor,
        Source.IsMailboxEnabled,
        Source.OfflineAddressBook,
        Source.ProhibitSendQuota,
        Source.ProhibitSendReceiveQuota,
        Source.RecoverableItemsQuota,
        Source.RecoverableItemsWarningQuota,
        Source.CalendarLoggingQuota,
        Source.DowngradeHighPriorityMessagesEnabled,
        Source.RecipientLimits,
        Source.ImListMigrationCompleted,
        Source.IsResource,
        Source.IsLinked,
        Source.IsShared,
        Source.IsRootPublicFolderMailbox,
        Source.LinkedMasterAccount,
        Source.ResetPasswordOnNextLogon,
        Source.ResourceCapacity,
        Source.ResourceCustom,
        Source.ResourceType,
        Source.RoomMailboxAccountEnabled,
        Source.SamAccountName,
        Source.SCLDeleteThreshold,
        Source.SCLDeleteEnabled,
        Source.SCLRejectThreshold,
        Source.SCLRejectEnabled,
        Source.SCLQuarantineThreshold,
        Source.SCLQuarantineEnabled,
        Source.SCLJunkThreshold,
        Source.SCLJunkEnabled,
        Source.AntispamBypassEnabled,
        Source.ServerLegacyDN,
        Source.ServerName,
        Source.UseDatabaseQuotaDefaults,
        Source.IssueWarningQuota,
        Source.RulesQuota,
        Source.Office,
        Source.UserPrincipalName,
        Source.UMEnabled,
        Source.MaxSafeSenders,
        Source.MaxBlockedSenders,
        Source.NetID,
        Source.ReconciliationId,
        Source.WindowsLiveID,
        Source.MicrosoftOnlineServicesID,
        Source.ThrottlingPolicy,
        Source.RoleAssignmentPolicy,
        Source.DefaultPublicFolderMailbox,
        Source.SharingPolicy,
        Source.ArchiveDatabase,
        Source.ArchiveGuid,
        Source.ArchiveName,
        Source.ArchiveQuota,
        Source.ArchiveWarningQuota,
        Source.ArchiveDomain,
        Source.ArchiveStatus,
        Source.ArchiveState,
        Source.IsAuxMailbox,
        Source.CalendarVersionStoreDisabled,
        Source.ImmutableId,
        Source.PersistedCapabilities,
        Source.SKUAssigned,
        Source.AuditEnabled,
        Source.AuditLogAgeLimit,
        Source.WhenMailboxCreated,
        Source.SourceAnchor,
        Source.UsageLocation,
        Source.IsSoftDeletedByRemove,
        Source.IsSoftDeletedByDisable,
        Source.IsInactiveMailbox,
        Source.IncludeInGarbageCollection,
        Source.WhenSoftDeleted,
        Source.InPlaceHolds,
        Source.GeneratedOfflineAddressBooks,
        Source.Extensions,
        Source.HasPicture,
        Source.HasSpokenName,
        Source.AcceptMessagesOnlyFrom,
        Source.AcceptMessagesOnlyFromDLMembers,
        Source.AcceptMessagesOnlyFromSendersOrMembers,
        Source.Alias,
        Source.BypassModerationFromSendersOrMembers,
        Source.OrganizationalUnit,
        Source.CustomAttribute1,
        Source.CustomAttribute10,
        Source.CustomAttribute11,
        Source.CustomAttribute12,
        Source.CustomAttribute13,
        Source.CustomAttribute14,
        Source.CustomAttribute15,
        Source.CustomAttribute2,
        Source.CustomAttribute3,
        Source.CustomAttribute4,
        Source.CustomAttribute5,
        Source.CustomAttribute6,
        Source.CustomAttribute7,
        Source.CustomAttribute8,
        Source.CustomAttribute9,
        Source.ExtensionCustomAttribute1,
        Source.ExtensionCustomAttribute2,
        Source.ExtensionCustomAttribute3,
        Source.ExtensionCustomAttribute4,
        Source.ExtensionCustomAttribute5,
        Source.DisplayName,
        Source.ExternalDirectoryObjectId,
        Source.HiddenFromAddressListsEnabled,
        Source.LastExchangeChangedTime,
        Source.LegacyExchangeDN,
        Source.MaxSendSize,
        Source.MaxReceiveSize,
        Source.ModeratedBy,
        Source.ModerationEnabled,
        Source.EmailAddressPolicyEnabled,
        Source.PrimarySmtpAddress,
        Source.RecipientType,
        Source.RecipientTypeDetails,
        Source.RejectMessagesFrom,
        Source.RejectMessagesFromDLMembers,
        Source.RejectMessagesFromSendersOrMembers,
        Source.RequireSenderAuthenticationEnabled,
        Source.SimpleDisplayName,
        Source.SendModerationNotifications,
        Source.WindowsEmailAddress,
        Source.MailTip,
        Source.MailTipTranslations,
        Source.[Identity],
        Source.IsValid,
        Source.ExchangeVersion,
        Source.Name,
        Source.DistinguishedName,
        Source.Guid,
        Source.WhenChanged,
        Source.WhenCreated,
        Source.WhenChangedUTC,
        Source.WhenCreatedUTC,
        Source.OrganizationId,
        Source.Id,
        Source.OriginatingServer,
        Source.ObjectState,
        Source.EmailAddresses,
        Source.GrantSendOnBehalfTo
    )
    WHEN NOT MATCHED BY SOURCE THEN DELETE OUTPUT $action,
    DELETED.ExchangeGUID AS DELETEDTargetExchangeGUID,
    DELETED.UserPrincipalName AS DELETEDTargetUserPrincipalName,
    INSERTED.ExchangeGUID AS INSERTEDTargetExchangeGUID,
    INSERTED.UserPrincipalName AS INSERTEDTargetUserPrincipalName;