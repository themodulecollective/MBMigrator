# Understanding the MigrationList

The overall purpose of MigrationList.xlsx is to provide information for planning and understanding migration waves and assignments and the current state of all mailboxes in the environment, both migrated and not yet migrated.

## MigrationList Sheet
A list of all mailboxes in the environment from both Exchange Online and Exchange On Premises, including the AssignedWave (migration wave) for each mailbox.  Each mailbox is identified by the following columns:

-	ExchangeGUID: unique identifier for the mailbox from Exchange (stays with the mailbox when migrated)
-	Name: Name of the user object from Exchange/AD
-	DisplayName: DisplayName of the user object from the Exchange/AD
-	UserPrincipalName: from Exchange/AD
-	PrimarySmtpAddress: from the Exchange mailbox object
-	Alias: short address that can be used internally for message routing and recipient identification
-	TargetAddress: address that will be used for routing to the mailbox in Exchange Online after migration.
-	AssignedWave: currently assigned migration wave for the mailbox, if any.
-	WaveAssignmentSource: WaveAssignments (for automatic assignment from BusinessUnit/Department information), WaveExceptions for manual assignments (various reasons, documented in WavePlanning.xlsx!WaveExceptions)
-	MigrationState: descripes the current state of the mailbox: Migrated, Non-Migrated, Synced (staged for migration)
-	TotalItemSizeInGB: total item size for the mailbox (non-deleted items)
-	TotalDeletedItemSizeInGB: total item size for the Recoverable Items in the mailbox (“deleted” items)
-	ItemCount: total count of non-deleted mailbox items (higher counts are the biggest factor in migration time for a given mailbox)
-	DeletedItemCount: total item count in the Recoverable Items store
-	RemoteRoutingAddress: address used to route mail to the mailbox in Exchange Online. Available for mailboxes already in Exchange Online, Blank for non-migrated mailboxes.
-	RecipientTypeDetails: The mailbox type from the viewpoint of Exchange On Premises.  UserMailbox (normal users not yet migrated), SharedMailbox, RoomMailbox, EquipmentMailbox, RemoteUserMailbox (normal users migrated), RemoteSharedMailbox, RemoteRoomMailbox, RemoteEquipmentMailbox.
-	ArchiveName: name of the Archive mailbox
-	ArchiveDomain: domain of the archive mailbox
-	ArchiveStatus: current status of the archive mailbox
-	ArchiveState: current state of the archive mailbox
-	RetentionPolicy: currently applied retention policy
-	RetainDeletedItemsFor: how long deleted items are retained (for mailboxes not subject to litigation hold)
-	LitigationHoldEnabled: TRUE indicates LitigationHold is in place
-	SingleItemRecoveryEnabled: TRUE or FALSE (retains deleted items until the RetainDeletedItemsFor period like a time bound LitigationHold – user can’t override)
-	SpecialHandling: lists any identified special handling requirements for the mailbox (sourced from WavePlanning.xlsx!SpecialHandling).  Multiple entries separated by ‘|’
-	OrganizationalUnit: the source “container” of the object in ActiveDirectory
-	Department: if available, from ActiveDirectory
-	Company: if available, from ActiveDirectory
-	Office: if available, from ActiveDirectory
-	City: if available, from ActiveDirectory
-	Manger: CanonicalName of the Manager, if available, from ActiveDirectory
-	GroupName: The $Group the mailbox is associated with for Migration Wave Assignment.
-	WhenCreatedUTC: UTC time of mailbox creation
-	Enabled: whether the underlying ActiveDirectory account is enabled
-	LastLogonDate: last logon date from underlying ActiveDirectory account
-	countryCode: 3 digit code for the User’s country from ActiveDirectory account
-	Country: Country abbreviation from ActiveDirectory account
-	employeeType: employeeType from ActiveDirectory
-	Division: Division from ActiveDirectory
-	Mailbox Quotas:
    - IssueWarningQuotaInGB
    - ProhibitSendQuotaInGB
    - ProhibitSendReceiveQuotaInGB
    - RecoverableItemsWarningQuotaInGB
    - ArchiveQuotaInGB
    - ArchiveWarningQuotaInGB
    - CalendarLoggingQuotaInGB
-	MobileDevicetype: User’s most recently synchronized mobile device type
-	MobileDeviceOS: User’s most recently synchronized mobile device OS
-	MobileLastSuccessSync: User’s most recent successful Sync
-	MobileDeviceAccessState:  Whether the users’s device is Allowed or Blocked
-	ActiveSyncEnabled: Whether the user is configured to allow them to use ActiveSync clients (from CASMailbox settings in Exchange).
-	LicenseNames:  Friendly Display Name of the License SKUs currently assigned to the user in Azure AD (this includes direct and group-based assignments).  This list is limited to SKUs relevant to the migration so it will not show all SKUs the user may have.
-	ServicePlanNames: Friendly Display Name of the Service Plans currently assigned to the user in Azure AD (this includes direct and group-based assignments).  This list is limited to ServicePlans relevant to the migration so it will not show all ServicePlans the user may have.
-	DistinguishedName: The DistinguishedName of the user object in AzureAD
-	EmailAddressses: All email addresses assigned to the user, separated by ‘;’
-	Trustees/Targets: Trustees: Trustees are other users who have access to this mailbox, along with the current wave assignment for those mailbox users.   Targets: Targets are other mailboxes to which this mailbox user has access, along with the current wave assignment for those mailbox users.
    - Format: PermissionCode:Alias (AssignedWave), multiple entries separated by ‘|’
    - Permission Codes:
        - C: Calendar
        - FA: Full Access
        - SB: Send on Behalf
