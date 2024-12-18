USE [Migration]
GO
/****** Object:  UserDefinedFunction [dbo].[getISO3166Alpha2FromAlpha3]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getISO3166Alpha2FromAlpha3]
(
	@Alpha3 nchar(3)
)
RETURNS nchar(2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Alpha2 nchar(2)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Alpha2 = (SELECT [alpha-2] FROM ISO3166 WHERE [alpha-3] = @Alpha3)

	-- Return the result of the function
	RETURN @Alpha2

END
GO
/****** Object:  Table [dbo].[stagingRecipient]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingRecipient](
	[SourceOrganization] [nvarchar](64) NULL,
	[ExchangeGuid] [nchar](36) NULL,
	[ExchangeObjectId] [nchar](36) NULL,
	[ExternalDirectoryObjectID] [nchar](36) NULL,
	[ArchiveGuid] [nchar](36) NULL,
	[Guid] [nchar](36) NULL,
	[Alias] [nvarchar](64) NULL,
	[DisplayName] [nvarchar](256) NULL,
	[PrimarySmtpAddress] [nvarchar](256) NULL,
	[ExternalEmailAddress] [nvarchar](256) NULL,
	[RecipientType] [nvarchar](256) NULL,
	[RecipientTypeDetails] [nvarchar](256) NULL,
	[CustomAttribute1] [nvarchar](1024) NULL,
	[CustomAttribute2] [nvarchar](1024) NULL,
	[CustomAttribute3] [nvarchar](1024) NULL,
	[CustomAttribute4] [nvarchar](1024) NULL,
	[CustomAttribute5] [nvarchar](1024) NULL,
	[CustomAttribute6] [nvarchar](1024) NULL,
	[CustomAttribute7] [nvarchar](1024) NULL,
	[CustomAttribute8] [nvarchar](1024) NULL,
	[CustomAttribute9] [nvarchar](1024) NULL,
	[CustomAttribute10] [nvarchar](1024) NULL,
	[CustomAttribute11] [nvarchar](1024) NULL,
	[CustomAttribute12] [nvarchar](1024) NULL,
	[CustomAttribute13] [nvarchar](1024) NULL,
	[CustomAttribute14] [nvarchar](1024) NULL,
	[CustomAttribute15] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute1] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute2] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute3] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute4] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute5] [nvarchar](1024) NULL,
	[Department] [nvarchar](256) NULL,
	[Company] [nvarchar](256) NULL,
	[Office] [nvarchar](256) NULL,
	[City] [nvarchar](256) NULL,
	[DistinguishedName] [nvarchar](1024) NULL,
	[Manager] [nvarchar](1024) NULL,
	[WhenCreatedUTC] [datetime] NULL,
	[WhenChangedUTC] [datetime] NULL,
	[EmailAddresses] [nvarchar](4000) NULL,
	[ArchiveStatus] [nvarchar](256) NULL,
	[ArchiveState] [nvarchar](256) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vRecipients_Source]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vRecipients_Source]
AS
SELECT     dbo.stagingRecipient.*
FROM        dbo.stagingRecipient
WHERE     (SourceOrganization = N'SourceDomain.onmicrosoft.com')
GO
/****** Object:  Table [dbo].[stagingADUser]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingADUser](
	[AccountExpires] [bigint] NULL,
	[AltRecipient] [nvarchar](256) NULL,
	[Company] [nvarchar](128) NULL,
	[City] [nvarchar](64) NULL,
	[C] [nvarchar](3) NULL,
	[Country] [nvarchar](3) NULL,
	[CO] [nvarchar](64) NULL,
	[CountryCode] [int] NULL,
	[CN] [nvarchar](128) NULL,
	[ST] [nvarchar](64) NULL,
	[Comment] [nvarchar](max) NULL,
	[Description] [nvarchar](512) NULL,
	[Division] [nvarchar](64) NULL,
	[EmployeeID] [nvarchar](32) NULL,
	[EmployeeNumber] [nvarchar](32) NULL,
	[EmployeeType] [nvarchar](32) NULL,
	[HomePhone] [nvarchar](64) NULL,
	[Mobile] [nvarchar](64) NULL,
	[Pager] [nvarchar](64) NULL,
	[FacsimileTelephoneNumber] [nvarchar](64) NULL,
	[TelephoneNumber] [nvarchar](64) NULL,
	[Street] [nvarchar](128) NULL,
	[Initials] [nvarchar](32) NULL,
	[Manager] [nvarchar](256) NULL,
	[Department] [nvarchar](128) NULL,
	[Title] [nvarchar](128) NULL,
	[PersonalTitle] [nvarchar](128) NULL,
	[DisplayName] [nvarchar](128) NULL,
	[GivenName] [nvarchar](64) NULL,
	[Surname] [nvarchar](64) NULL,
	[DistinguishedName] [nvarchar](256) NULL,
	[CanonicalName] [nvarchar](256) NULL,
	[Mail] [nvarchar](128) NULL,
	[MailNickName] [nvarchar](128) NULL,
	[msExchUsageLocation] [nvarchar](2) NULL,
	[PhysicalDeliveryOfficeName] [nvarchar](128) NULL,
	[SamAccountName] [nvarchar](64) NULL,
	[UserPrincipalName] [nvarchar](128) NULL,
	[Enabled] [bit] NULL,
	[ExtensionAttribute1] [nvarchar](128) NULL,
	[ExtensionAttribute2] [nvarchar](128) NULL,
	[ExtensionAttribute3] [nvarchar](128) NULL,
	[ExtensionAttribute4] [nvarchar](128) NULL,
	[ExtensionAttribute5] [nvarchar](128) NULL,
	[ExtensionAttribute6] [nvarchar](128) NULL,
	[ExtensionAttribute7] [nvarchar](128) NULL,
	[ExtensionAttribute8] [nvarchar](128) NULL,
	[ExtensionAttribute9] [nvarchar](128) NULL,
	[ExtensionAttribute10] [nvarchar](128) NULL,
	[ExtensionAttribute11] [nvarchar](128) NULL,
	[ExtensionAttribute12] [nvarchar](128) NULL,
	[ExtensionAttribute13] [nvarchar](128) NULL,
	[ExtensionAttribute14] [nvarchar](128) NULL,
	[ExtensionAttribute15] [nvarchar](128) NULL,
	[msExchExtensionAttribute16] [nvarchar](128) NULL,
	[msExchExtensionAttribute17] [nvarchar](128) NULL,
	[msExchExtensionAttribute18] [nvarchar](128) NULL,
	[msExchExtensionAttribute19] [nvarchar](128) NULL,
	[msExchExtensionAttribute20] [nvarchar](128) NULL,
	[msExchExtensionAttribute21] [nvarchar](128) NULL,
	[msExchExtensionAttribute22] [nvarchar](128) NULL,
	[msExchExtensionAttribute23] [nvarchar](128) NULL,
	[msExchExtensionAttribute24] [nvarchar](128) NULL,
	[msExchExtensionAttribute25] [nvarchar](128) NULL,
	[msExchExtensionAttribute26] [nvarchar](128) NULL,
	[msExchExtensionAttribute27] [nvarchar](128) NULL,
	[msExchExtensionAttribute28] [nvarchar](128) NULL,
	[msExchExtensionAttribute29] [nvarchar](128) NULL,
	[msExchExtensionAttribute30] [nvarchar](128) NULL,
	[msExchExtensionAttribute31] [nvarchar](128) NULL,
	[msExchExtensionAttribute32] [nvarchar](128) NULL,
	[msExchExtensionAttribute33] [nvarchar](128) NULL,
	[msExchExtensionAttribute34] [nvarchar](128) NULL,
	[msExchExtensionAttribute35] [nvarchar](128) NULL,
	[msExchExtensionAttribute36] [nvarchar](128) NULL,
	[msExchExtensionAttribute37] [nvarchar](128) NULL,
	[msExchExtensionAttribute38] [nvarchar](128) NULL,
	[msExchExtensionAttribute39] [nvarchar](128) NULL,
	[msExchExtensionAttribute40] [nvarchar](128) NULL,
	[msExchExtensionAttribute41] [nvarchar](128) NULL,
	[msExchExtensionAttribute42] [nvarchar](128) NULL,
	[msExchExtensionAttribute43] [nvarchar](128) NULL,
	[msExchExtensionAttribute44] [nvarchar](128) NULL,
	[msExchExtensionAttribute45] [nvarchar](128) NULL,
	[LastLogonDate] [datetime2](7) NULL,
	[BusinessCategory] [nvarchar](128) NULL,
	[ProxyAddresses] [nvarchar](2048) NULL,
	[mS-DS-ConsistencyGUID] [nvarchar](36) NULL,
	[msExchMailboxGUID] [nvarchar](36) NULL,
	[msExchMasterAccountSID] [nvarchar](64) NULL,
	[SID] [nvarchar](64) NULL,
	[ObjectGUID] [nvarchar](36) NULL,
	[ImmutableID] [nvarchar](32) NULL,
	[DomainName] [nvarchar](64) NULL,
	[msExchExtensionCustomAttribute2] [nvarchar](128) NULL,
	[msExchExtensionCustomAttribute1] [nvarchar](128) NULL,
	[msExchExtensionCustomAttribute3] [nvarchar](128) NULL,
	[msExchExtensionCustomAttribute4] [nvarchar](128) NULL,
	[msExchExtensionCustomAttribute5] [nvarchar](128) NULL,
	[PasswordLastSet] [datetime2](7) NULL,
	[PasswordExpired] [bit] NULL,
	[PasswordNeverExpires] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vADUsers_Source]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vADUsers_Source]
AS
SELECT     AccountExpires, AltRecipient, Company, City, C, Country, CO, CountryCode, CN, ST, Comment, Description, Division, EmployeeID, EmployeeNumber, EmployeeType, HomePhone, Mobile, Pager, FacsimileTelephoneNumber, TelephoneNumber, Street, Initials, Manager, Department, Title,
                  PersonalTitle, DisplayName, GivenName, Surname, DistinguishedName, CanonicalName, Mail, MailNickName, msExchUsageLocation, PhysicalDeliveryOfficeName, SamAccountName, UserPrincipalName, Enabled, ExtensionAttribute1, ExtensionAttribute2, ExtensionAttribute3,
                  ExtensionAttribute4, ExtensionAttribute5, ExtensionAttribute6, ExtensionAttribute7, ExtensionAttribute8, ExtensionAttribute9, ExtensionAttribute10, ExtensionAttribute11, ExtensionAttribute12, ExtensionAttribute13, ExtensionAttribute14, ExtensionAttribute15, msExchExtensionAttribute16,
                  msExchExtensionAttribute17, msExchExtensionAttribute18, msExchExtensionAttribute19, msExchExtensionAttribute20, msExchExtensionAttribute21, msExchExtensionAttribute22, msExchExtensionAttribute23, msExchExtensionAttribute24, msExchExtensionAttribute25,
                  msExchExtensionAttribute26, msExchExtensionAttribute27, msExchExtensionAttribute28, msExchExtensionAttribute29, msExchExtensionAttribute30, msExchExtensionAttribute31, msExchExtensionAttribute32, msExchExtensionAttribute33, msExchExtensionAttribute34,
                  msExchExtensionAttribute35, msExchExtensionAttribute36, msExchExtensionAttribute37, msExchExtensionAttribute38, msExchExtensionAttribute39, msExchExtensionAttribute40, msExchExtensionAttribute41, msExchExtensionAttribute42, msExchExtensionAttribute43,
                  msExchExtensionAttribute44, msExchExtensionAttribute45, LastLogonDate, BusinessCategory, ProxyAddresses, [mS-DS-ConsistencyGUID], msExchMailboxGUID, msExchMasterAccountSID, SID, ObjectGUID, DomainName, PasswordLastSet, PasswordExpired, PasswordNeverExpires
FROM        dbo.stagingADUser
WHERE     (DomainName <> N'SourceDomain')
GO
/****** Object:  Table [dbo].[stagingEntraIDUser]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingEntraIDUser](
	[TenantDomain] [nvarchar](256) NULL,
	[accountEnabled] [bit] NULL,
	[businessPhones] [nvarchar](32) NULL,
	[city] [nvarchar](32) NULL,
	[companyName] [nvarchar](64) NULL,
	[country] [nvarchar](32) NULL,
	[department] [nvarchar](128) NULL,
	[displayName] [nvarchar](128) NULL,
	[employeeId] [nvarchar](16) NULL,
	[givenName] [nvarchar](64) NULL,
	[id] [nvarchar](36) NULL,
	[ConsistencyGUID] [nvarchar](36) NULL,
	[jobTitle] [nvarchar](128) NULL,
	[lastPasswordChangeDateTime] [datetime2](7) NULL,
	[licenseAssignmentStates] [nvarchar](max) NULL,
	[mail] [nvarchar](128) NULL,
	[mailNickname] [nvarchar](64) NULL,
	[mobilePhone] [nvarchar](32) NULL,
	[officeLocation] [nvarchar](64) NULL,
	[manager] [nvarchar](32) NULL,
	[onPremisesDistinguishedName] [nvarchar](256) NULL,
	[onPremisesDomainName] [nvarchar](32) NULL,
	[onPremisesExtensionAttributes] [nvarchar](1024) NULL,
	[onPremisesImmutableId] [nvarchar](32) NULL,
	[onPremisesLastSyncDateTime] [datetime2](7) NULL,
	[onPremisesSamAccountName] [nvarchar](32) NULL,
	[onPremisesSecurityIdentifier] [nvarchar](64) NULL,
	[onPremisesSyncEnabled] [bit] NULL,
	[onPremisesUserPrincipalName] [nvarchar](128) NULL,
	[preferredLanguage] [nvarchar](32) NULL,
	[surname] [nvarchar](64) NULL,
	[usageLocation] [nvarchar](2) NULL,
	[userPrincipalName] [nvarchar](128) NULL,
	[userType] [nvarchar](32) NULL,
	[assignedLicenses] [nvarchar](1024) NULL,
	[lastSignInDateTime] [datetime2](7) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingMailbox]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingMailbox](
	[SourceOrganization] [nvarchar](64) NULL,
	[ExchangeGuid] [nchar](36) NULL,
	[ExchangeObjectId] [nchar](36) NULL,
	[ExternalDirectoryObjectID] [nchar](36) NULL,
	[ArchiveGuid] [nchar](36) NULL,
	[Guid] [nchar](36) NULL,
	[Alias] [nvarchar](64) NULL,
	[SamAccountName] [nvarchar](64) NULL,
	[DisplayName] [nvarchar](256) NULL,
	[Name] [nvarchar](256) NULL,
	[PrimarySmtpAddress] [nvarchar](256) NULL,
	[UserPrincipalName] [nvarchar](256) NULL,
	[RemoteRoutingAddress] [nvarchar](256) NULL,
	[TargetAddress] [nvarchar](256) NULL,
	[ForwardingAddress] [nvarchar](256) NULL,
	[ForwardingSmtpAddress] [nvarchar](256) NULL,
	[LegacyExchangeDN] [nvarchar](256) NULL,
	[RecipientType] [nvarchar](256) NULL,
	[RecipientTypeDetails] [nvarchar](256) NULL,
	[RemoteRecipientType] [nvarchar](256) NULL,
	[LinkedMasterAccount] [nvarchar](256) NULL,
	[CustomAttribute1] [nvarchar](1024) NULL,
	[CustomAttribute2] [nvarchar](1024) NULL,
	[CustomAttribute3] [nvarchar](1024) NULL,
	[CustomAttribute4] [nvarchar](1024) NULL,
	[CustomAttribute5] [nvarchar](1024) NULL,
	[CustomAttribute6] [nvarchar](1024) NULL,
	[CustomAttribute7] [nvarchar](1024) NULL,
	[CustomAttribute8] [nvarchar](1024) NULL,
	[CustomAttribute9] [nvarchar](1024) NULL,
	[CustomAttribute10] [nvarchar](1024) NULL,
	[CustomAttribute11] [nvarchar](1024) NULL,
	[CustomAttribute12] [nvarchar](1024) NULL,
	[CustomAttribute13] [nvarchar](1024) NULL,
	[CustomAttribute14] [nvarchar](1024) NULL,
	[CustomAttribute15] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute1] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute2] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute3] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute4] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute5] [nvarchar](1024) NULL,
	[Department] [nvarchar](256) NULL,
	[Office] [nvarchar](256) NULL,
	[OrganizationalUnit] [nvarchar](256) NULL,
	[Database] [nvarchar](256) NULL,
	[ArchiveName] [nvarchar](256) NULL,
	[ArchiveDomain] [nvarchar](256) NULL,
	[ArchiveStatus] [nvarchar](256) NULL,
	[ArchiveState] [nvarchar](256) NULL,
	[RetentionPolicy] [nvarchar](256) NULL,
	[RetainDeletedItemsFor] [nvarchar](64) NULL,
	[ManagedFolderMailboxPolicy] [nvarchar](256) NULL,
	[AddressBookPolicy] [nvarchar](256) NULL,
	[RoleAssignmentPolicy] [nvarchar](256) NULL,
	[SharingPolicy] [nvarchar](256) NULL,
	[DefaultPublicFolderMailbox] [nvarchar](256) NULL,
	[RecipientLimits] [nvarchar](64) NULL,
	[ResourceCapacity] [nvarchar](64) NULL,
	[DistinguishedName] [nvarchar](1024) NULL,
	[WhenCreatedUTC] [datetime] NULL,
	[WhenChangedUTC] [datetime] NULL,
	[WhenMailboxCreated] [datetime] NULL,
	[EmailAddresses] [nvarchar](4000) NULL,
	[UseDatabaseRetentionDefaults] [bit] NULL,
	[UseDatabaseQuotaDefaults] [bit] NULL,
	[LitigationHoldEnabled] [bit] NULL,
	[SingleItemRecoveryEnabled] [bit] NULL,
	[RetentionHoldEnabled] [bit] NULL,
	[BccBlocked] [bit] NULL,
	[AutoExpandingArchiveEnabled] [bit] NULL,
	[HiddenFromAddressListsEnabled] [bit] NULL,
	[EmailAddressPolicyEnabled] [bit] NULL,
	[MessageCopyForSentAsEnabled] [bit] NULL,
	[MessageCopyForSendOnBehalfEnabled] [bit] NULL,
	[DeliverToMailboxAndForward] [bit] NULL,
	[MessageTrackingReadStatusEnabled] [bit] NULL,
	[DowngradeHighPriorityMessagesEnabled] [bit] NULL,
	[UMEnabled] [bit] NULL,
	[IsAuxMailbox] [bit] NULL,
	[CalendarVersionStoreDisabled] [bit] NULL,
	[SKUAssigned] [bit] NULL,
	[AuditEnabled] [bit] NULL,
	[ArchiveQuotaInGB] [nvarchar](10) NULL,
	[ArchiveWarningQuotaInGB] [nvarchar](10) NULL,
	[CalendarLoggingQuotaInGB] [nvarchar](10) NULL,
	[IssueWarningQuotaInGB] [nvarchar](10) NULL,
	[ProhibitSendQuotaInGB] [nvarchar](10) NULL,
	[ProhibitSendReceiveQuotaInGB] [nvarchar](10) NULL,
	[RecoverableItemsQuotaInGB] [nvarchar](10) NULL,
	[RecoverableItemsWarningQuotaInGB] [nvarchar](10) NULL,
	[RulesQuotaInKB] [nvarchar](10) NULL,
	[MaxSendSizeInMB] [nvarchar](10) NULL,
	[MaxReceiveSizeInMB] [nvarchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingWorkday]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingWorkday](
	[EmployeeID] [nvarchar](8) NULL,
	[Worker] [nvarchar](128) NULL,
	[EmailAddress] [nvarchar](64) NULL,
	[EmployeeType] [nvarchar](32) NULL,
	[TimeType] [nvarchar](32) NULL,
	[FTEPercent] [float] NULL,
	[WorkerType] [nvarchar](32) NULL,
	[ContingentWorkerType] [nvarchar](32) NULL,
	[JobTitle] [nvarchar](128) NULL,
	[JobProfile] [nvarchar](64) NULL,
	[JobCategory] [nvarchar](32) NULL,
	[ManagementLevel] [nvarchar](32) NULL,
	[Manages] [nvarchar](32) NULL,
	[DirectReportCount] [float] NULL,
	[HireDate] [datetime2](7) NULL,
	[TermDate] [datetime2](7) NULL,
	[ContingentContractEndDate] [datetime2](7) NULL,
	[EndEmploymentDate] [datetime2](7) NULL,
	[ContinuousServiceDate] [datetime2](7) NULL,
	[Location] [nvarchar](64) NULL,
	[HasAltPrimaryEmail] [nvarchar](32) NULL,
	[LocationCountry] [nvarchar](32) NULL,
	[Company] [nvarchar](64) NULL,
	[BusinessUnit] [nvarchar](64) NULL,
	[Division] [nvarchar](64) NULL,
	[Region] [nvarchar](32) NULL,
	[JobFamily] [nvarchar](64) NULL,
	[JobFamilyGroup] [nvarchar](64) NULL,
	[CostCenter] [nvarchar](32) NULL,
	[Manager] [nvarchar](128) NULL,
	[ManagerEmail] [nvarchar](64) NULL,
	[LeaveStatus] [nvarchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vStagingWorkday]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vStagingWorkday]
AS
SELECT     EmployeeID, Worker, EmailAddress, EmployeeType, TimeType, FTEPercent, WorkerType, ContingentWorkerType, JobTitle, JobProfile, JobCategory, ManagementLevel, Manages, DirectReportCount, HireDate, TermDate, ContingentContractEndDate, EndEmploymentDate,
                  ContinuousServiceDate, Location, HasAltPrimaryEmail, LocationCountry, Company, BusinessUnit, Division, Region, JobFamily, JobFamilyGroup, CostCenter, Manager, ManagerEmail, 'A' + EmployeeID AS AEmployeeID1, 'A' + SUBSTRING(EmployeeID, 2, 7) AS AEmployeeID2,
                  LeaveStatus
FROM        dbo.stagingWorkday
GO
/****** Object:  View [dbo].[vSourceUserWorkMail]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vSourceUserWorkMail]
AS
SELECT     U.EmployeeID AS ADEmployeeID, W.EmployeeID AS WEmployeeID, U.SamAccountName, U.MailNickName, W.EmailAddress AS WEmailAddress, U.Mail, W.Division, W.Company, W.LocationCountry, W.Location, W.ManagerEmail, W.Manager AS WManager, W.Manages,
                  W.DirectReportCount, W.JobTitle, W.JobProfile, W.JobCategory, W.ManagementLevel, W.EmployeeType, W.TimeType, U.Comment, U.Description, U.Manager AS ADManager, U.DisplayName, U.UserPrincipalName, U.Enabled, U.msExchExtensionAttribute20,
                  U.msExchExtensionAttribute21, U.msExchExtensionAttribute22, U.msExchExtensionAttribute23, U.DomainName, dbo.stagingEntraIDUser.assignedLicenses, dbo.stagingEntraIDUser.onPremisesUserPrincipalName, dbo.stagingEntraIDUser.userPrincipalName AS EIDUserPrincipalName,
                  dbo.stagingMailbox.RecipientTypeDetails, dbo.stagingMailbox.ExchangeGuid, dbo.stagingMailbox.ExternalDirectoryObjectID, dbo.stagingEntraIDUser.id
FROM        dbo.vADUsers_Source AS U INNER JOIN
                  dbo.vStagingWorkday AS W ON U.EmployeeID = W.AEmployeeID1 OR U.EmployeeID = W.AEmployeeID2 INNER JOIN
                  dbo.stagingEntraIDUser ON U.UserPrincipalName = dbo.stagingEntraIDUser.onPremisesUserPrincipalName INNER JOIN
                  dbo.stagingMailbox ON dbo.stagingEntraIDUser.userPrincipalName = dbo.stagingMailbox.UserPrincipalName
WHERE     (U.SamAccountName NOT LIKE 'AdminAccountPrefix%') AND (U.EmployeeID = U.SamAccountName)
GO
/****** Object:  View [dbo].[vCalcMigUserAttributes_Source]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Affected Attributes:  CN, DisplayName,GivenName, */
CREATE VIEW [dbo].[vCalcMigUserAttributes_Source]
AS
SELECT     R.RecipientTypeDetails, U.DomainName, U.GivenName AS CurrentGivenName, CASE WHEN U.GivenName LIKE '%[1-9]' THEN RTRIM(U.GivenName, '-123456789') ELSE U.GivenName END AS NewGivenName, U.Surname AS CurrentSurname, dbo.ToProperCase(U.Surname)
                  AS NewSurname, U.SamAccountName AS CurrentSamAccountName, R.Alias AS CurrentEmailAlias, CASE WHEN (R.PrimarySmtpAddress LIKE '%.ext@%' OR
                  R.PrimarySmtpAddress LIKE '%@external.%') AND R.PrimarySmtpAddress NOT LIKE '%[1-9]%' THEN LOWER(U.GivenName) + '.' + LOWER(U.Surname) + '.ext' WHEN (R.PrimarySmtpAddress LIKE '%.ext@%' OR
                  R.PrimarySmtpAddress LIKE '%@external.%') AND U.GivenName LIKE '%-[1-9]' THEN LOWER(RTRIM(U.GivenName, '-[1-9]')) + '.' + LOWER(U.Surname) + RIGHT(U.GivenName, 1) + '.ext' WHEN (R.PrimarySmtpAddress LIKE '%[1-9]%') THEN LOWER(RTRIM(U.GivenName, '-123456789'))
                  + '.' + LOWER(U.Surname) + RIGHT(U.GivenName, 1) ELSE LOWER(U.GivenName) + '.' + LOWER(U.Surname) END AS NewEmailAlias, W.WEmployeeID AS NewSamAccountName, R.PrimarySmtpAddress AS CurrentEmail, CASE WHEN (R.PrimarySmtpAddress LIKE '%.ext@%' OR
                  R.PrimarySmtpAddress LIKE '%@external.%') AND R.PrimarySmtpAddress NOT LIKE '%[1-9]%' THEN LOWER(U.GivenName) + '.' + LOWER(U.Surname) + '.ext@targetdomain.com' WHEN (R.PrimarySmtpAddress LIKE '%.ext@%' OR
                  R.PrimarySmtpAddress LIKE '%@external.%') AND U.GivenName LIKE '%-[1-9]' THEN LOWER(RTRIM(U.GivenName, '-[1-9]')) + '.' + LOWER(U.Surname) + RIGHT(U.GivenName, 1) + '.ext@targetdomain.com' WHEN (R.PrimarySmtpAddress LIKE '%[1-9]%') THEN LOWER(RTRIM(U.GivenName,
                  '-123456789')) + '.' + LOWER(U.Surname) + RIGHT(U.GivenName, 1) + '@targetdomain.com' ELSE LOWER(U.GivenName) + '.' + LOWER(U.Surname) + '@targetdomain.com' END AS NewEmailAndUsername, U.DisplayName AS CurrentDisplayName,
                  CASE WHEN (R.PrimarySmtpAddress LIKE '%.ext@%' OR
                  R.PrimarySmtpAddress LIKE '%@external.%') AND R.PrimarySmtpAddress NOT LIKE '%[1-9]%' THEN dbo.toProperCase(U.Surname) + ', ' + U.GivenName + ' (EXT)' WHEN (R.PrimarySmtpAddress LIKE '%.ext@%' OR
                  R.PrimarySmtpAddress LIKE '%@external.%') AND U.GivenName LIKE '%-[1-9]' THEN dbo.toProperCase(U.Surname) + ', ' + RTRIM(U.GivenName, '-123456789') + ' (' + RIGHT(U.GivenName, 1) + ') ' + '(EXT)' WHEN (R.PrimarySmtpAddress LIKE '%[1-9]%') THEN dbo.toProperCase(U.Surname)
                  + ', ' + RTRIM(U.GivenName, '-123456789') + ' (' + RIGHT(U.GivenName, 1) + ')' ELSE dbo.toProperCase(U.Surname) + ', ' + U.GivenName END AS NewDisplayName
FROM        dbo.vRecipients_Source AS R INNER JOIN
                  dbo.vADUsers_Source AS U ON R.PrimarySmtpAddress = U.Mail INNER JOIN
                  dbo.vSourceUserWorkMail AS W ON W.ADEmployeeID = U.EmployeeID
WHERE     (R.RecipientTypeDetails = 'UserMailbox')
GO
/****** Object:  Table [dbo].[stagingUserDriveDetail]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingUserDriveDetail](
	[Owner] [nvarchar](256) NULL,
	[Title] [nvarchar](64) NULL,
	[LastContentModifiedDate] [datetime2](7) NULL,
	[Url] [nvarchar](256) NULL,
	[UsageInGB] [float] NULL,
	[QuotaInGB] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vUserDriveDetail]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vUserDriveDetail]
AS
SELECT     Owner, MAX(Url) AS DriveURL, COUNT(Url) AS DriveCount, SUM(UsageInGB) AS TotalUsageInGB
FROM        dbo.stagingUserDriveDetail
GROUP BY Owner
GO
/****** Object:  Table [dbo].[stagingWorkFolders]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingWorkFolders](
	[Source.Name] [nvarchar](64) NULL,
	[name] [nvarchar](64) NULL,
	[samaccountname] [nvarchar](max) NULL,
	[Enabled] [bit] NULL,
	[Email] [nvarchar](128) NULL,
	[ADDomain] [nvarchar](64) NULL,
	[UNC] [nvarchar](64) NULL,
	[UNC Path] [nvarchar](128) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vWorkFolders]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vWorkFolders]
AS
SELECT     string_agg([UNC Path], ' | ') AS WorkFolders, Email
FROM        dbo.stagingWorkFolders
WHERE     (Email IS NOT NULL)
GROUP BY Email
GO
/****** Object:  Table [dbo].[stagingPermissions]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingPermissions](
	[SourceOrganization] [nvarchar](64) NULL,
	[PermissionIdentity] [nchar](36) NULL,
	[ParentPermissionIdentity] [nchar](36) NULL,
	[SourceExchangeOrganization] [nvarchar](64) NULL,
	[TargetRecipientType] [nvarchar](64) NULL,
	[TargetRecipientTypeDetails] [nvarchar](64) NULL,
	[TargetAlias] [nvarchar](64) NULL,
	[TrusteeRecipientType] [nvarchar](64) NULL,
	[TrusteeRecipientTypeDetails] [nvarchar](64) NULL,
	[TrusteeAlias] [nvarchar](64) NULL,
	[TargetFolderType] [nvarchar](64) NULL,
	[PermissionType] [nvarchar](64) NULL,
	[AssignmentType] [nvarchar](64) NULL,
	[TargetPrimarySMTPAddress] [nvarchar](256) NULL,
	[TrusteePrimarySMTPAddress] [nvarchar](256) NULL,
	[TrusteeIdentity] [nvarchar](256) NULL,
	[TargetDistinguishedName] [nvarchar](1024) NULL,
	[TrusteeDistinguishedName] [nvarchar](1024) NULL,
	[TargetFolderPath] [nvarchar](1024) NULL,
	[FolderAccessRights] [nvarchar](1024) NULL,
	[TargetObjectGUID] [nchar](36) NULL,
	[TargetExchangeGUID] [nchar](36) NULL,
	[TrusteeGroupObjectGUID] [nchar](36) NULL,
	[TrusteeObjectGUID] [nchar](36) NULL,
	[TrusteeExchangeGUID] [nchar](36) NULL,
	[IsAutoMapped] [nvarchar](5) NULL,
	[IsInherited] [nvarchar](5) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vIgnorablePermissions]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vIgnorablePermissions]
AS
SELECT     PermissionIdentity
FROM        dbo.stagingPermissions
WHERE     (TrusteeAlias IN ('CommonlyUsedAdminAccounts'))
GO
/****** Object:  Table [dbo].[stagingMailboxAddresses]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingMailboxAddresses](
	[SourceOrganization] [nvarchar](64) NULL,
	[ExternalDirectoryObjectID] [nchar](36) NULL,
	[ExchangeObjectId] [nchar](36) NULL,
	[Address] [nvarchar](256) NULL,
	[Type] [nvarchar](32) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingFlyUserProjectMapping]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingFlyUserProjectMapping](
	[ProjectName] [nvarchar](max) NULL,
	[ProjectType] [nvarchar](max) NULL,
	[Color] [nvarchar](max) NULL,
	[Source] [nvarchar](max) NULL,
	[Destination] [nvarchar](max) NULL,
	[CurrentJobStatus] [nvarchar](max) NULL,
	[CurrentJobStage] [nvarchar](max) NULL,
	[LastJobStatus] [nvarchar](max) NULL,
	[FailComment] [nvarchar](max) NULL,
	[JobProgress] [bigint] NULL,
	[MappingId] [nvarchar](max) NULL,
	[ProjectId] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vFlyExchange]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vFlyExchange]
AS
SELECT     ProjectName, ProjectType, Source, Destination
FROM        dbo.stagingFlyUserProjectMapping
WHERE     (ProjectType = N'Exchange')
GO
/****** Object:  View [dbo].[vFlyExchangeByAnyAddress]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vFlyExchangeByAnyAddress]
AS
SELECT     FE.Source, FE.ProjectName, FE.ProjectType, A.ExternalDirectoryObjectID
FROM        dbo.vFlyExchange AS FE INNER JOIN
                  dbo.stagingMailboxAddresses AS A ON FE.Source = A.Address
GO
/****** Object:  View [dbo].[vEntraIDUsers_Source]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vEntraIDUsers_Source]
AS
SELECT     TenantDomain, accountEnabled, businessPhones, city, companyName, country, department, displayName, employeeId, givenName, id, jobTitle, lastPasswordChangeDateTime, licenseAssignmentStates, mail, mailNickname, mobilePhone, officeLocation, manager,
                  onPremisesDistinguishedName, onPremisesDomainName, onPremisesExtensionAttributes, onPremisesImmutableId, onPremisesLastSyncDateTime, onPremisesSamAccountName, onPremisesSecurityIdentifier, onPremisesSyncEnabled, onPremisesUserPrincipalName,
                  preferredLanguage, surname, usageLocation, userPrincipalName, userType, assignedLicenses, ConsistencyGUID, lastSignInDateTime
FROM        dbo.stagingEntraIDUser
WHERE     (TenantDomain = N'SourceDomain')
GO
/****** Object:  View [dbo].[vRecipients_Target]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vRecipients_Target]
AS
SELECT     dbo.stagingRecipient.*
FROM        dbo.stagingRecipient
WHERE     (SourceOrganization = N'targetdomain.onmicrosoft.com')
GO
/****** Object:  View [dbo].[vEntraIDUsers_Target]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vEntraIDUsers_Target]
AS
SELECT     TenantDomain, accountEnabled, businessPhones, city, companyName, country, department, displayName, employeeId, givenName, id, jobTitle, lastPasswordChangeDateTime, licenseAssignmentStates, mail, mailNickname, mobilePhone, officeLocation, manager,
                  onPremisesDistinguishedName, onPremisesDomainName, onPremisesExtensionAttributes, onPremisesImmutableId, onPremisesLastSyncDateTime, onPremisesSamAccountName, onPremisesSecurityIdentifier, onPremisesSyncEnabled, onPremisesUserPrincipalName,
                  preferredLanguage, surname, usageLocation, userPrincipalName, userType, assignedLicenses, ConsistencyGUID, lastSignInDateTime
FROM        dbo.stagingEntraIDUser
WHERE     (TenantDomain = N'TargetDomain')
GO
/****** Object:  View [dbo].[vTargetEmailEmployeeID]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vTargetEmailEmployeeID]
AS
SELECT     dbo.vRecipients_Target.PrimarySmtpAddress, dbo.vRecipients_Target.EmailAddresses, dbo.vEntraIDUsers_Target.employeeId, dbo.vEntraIDUsers_Target.department, dbo.vEntraIDUsers_Target.companyName, dbo.vEntraIDUsers_Target.onPremisesSamAccountName,
                  dbo.vEntraIDUsers_Target.userType
FROM        dbo.vRecipients_Target INNER JOIN
                  dbo.vEntraIDUsers_Target ON dbo.vRecipients_Target.ExternalDirectoryObjectID = dbo.vEntraIDUsers_Target.id
WHERE     (dbo.vEntraIDUsers_Target.userType NOT IN ('Guest', 'Test'))
GO
/****** Object:  View [dbo].[vConflictingSourceToTargetEmail]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vConflictingSourceToTargetEmail]
AS
SELECT     M.RecipientTypeDetails, M.DomainName, M.CurrentGivenName, M.NewGivenName, M.CurrentSurname, M.NewSurname, M.CurrentSamAccountName, M.CurrentEmailAlias, M.NewEmailAlias, M.NewSamAccountName, M.CurrentEmail, M.NewEmailAndUsername, M.CurrentDisplayName,
                  M.NewDisplayName, C.employeeId AS ConflictEmployeeID, C.onPremisesSamAccountName AS ConflictingSamAccountName, C.companyName AS ConflictingCompanyName, C.department AS ConflictingDepartment
FROM        dbo.vCalcMigUserAttributes_Source AS M INNER JOIN
                  dbo.vTargetEmailEmployeeID AS C ON M.NewEmailAndUsername = C.PrimarySmtpAddress AND M.NewSamAccountName <> C.employeeId
WHERE     (M.CurrentSamAccountName NOT LIKE 'AdminAccountPrefix%')
GO
/****** Object:  Table [dbo].[stagingEntraIDGroup]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingEntraIDGroup](
	[classification] [nvarchar](64) NULL,
	[createdByAppId] [nvarchar](36) NULL,
	[createdDateTime] [datetime2](7) NULL,
	[deletedDateTime] [datetime2](7) NULL,
	[description] [nvarchar](1024) NULL,
	[displayName] [nvarchar](256) NULL,
	[expirationDateTime] [datetime2](7) NULL,
	[id] [nvarchar](36) NULL,
	[infoCatalogs] [nvarchar](64) NULL,
	[isAssignableToRole] [bit] NULL,
	[isManagementRestricted] [bit] NULL,
	[mail] [nvarchar](128) NULL,
	[mailEnabled] [bit] NULL,
	[mailNickname] [nvarchar](64) NULL,
	[membershipRule] [nvarchar](2048) NULL,
	[membershipRuleProcessingState] [nvarchar](32) NULL,
	[onPremisesDomainName] [nvarchar](64) NULL,
	[onPremisesLastSyncDateTime] [datetime2](7) NULL,
	[onPremisesNetBiosName] [nvarchar](32) NULL,
	[onPremisesProvisioningErrors] [nvarchar](32) NULL,
	[onPremisesSamAccountName] [nvarchar](128) NULL,
	[onPremisesSecurityIdentifier] [nvarchar](48) NULL,
	[onPremisesSyncEnabled] [bit] NULL,
	[organizationId] [nvarchar](64) NULL,
	[preferredDataLocation] [nvarchar](64) NULL,
	[preferredLanguage] [nvarchar](64) NULL,
	[proxyAddresses] [nvarchar](2048) NULL,
	[renewedDateTime] [datetime2](7) NULL,
	[resourceBehaviorOptions] [nvarchar](128) NULL,
	[resourceProvisioningOptions] [nvarchar](32) NULL,
	[securityEnabled] [bit] NULL,
	[securityIdentifier] [nvarchar](64) NULL,
	[theme] [nvarchar](32) NULL,
	[visibility] [nvarchar](32) NULL,
	[writebackConfiguration] [nvarchar](32) NULL,
	[TenantDomain] [nvarchar](64) NULL,
	[TenantID] [nvarchar](36) NULL,
	[groupType] [nvarchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vEntraIDGroups_Source]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vEntraIDGroups_Source]
AS
SELECT     classification, createdByAppId, createdDateTime, deletedDateTime, description, displayName, expirationDateTime, id, infoCatalogs, isAssignableToRole, isManagementRestricted, mail, mailEnabled, mailNickname, membershipRule, membershipRuleProcessingState,
                  onPremisesDomainName, onPremisesLastSyncDateTime, onPremisesNetBiosName, onPremisesProvisioningErrors, onPremisesSamAccountName, onPremisesSecurityIdentifier, onPremisesSyncEnabled, organizationId, preferredDataLocation, preferredLanguage, proxyAddresses,
                  renewedDateTime, resourceBehaviorOptions, resourceProvisioningOptions, securityEnabled, securityIdentifier, theme, visibility, writebackConfiguration, TenantDomain, TenantID, groupType
FROM        dbo.stagingEntraIDGroup
WHERE     (TenantDomain = N'SourceDomain')
GO
/****** Object:  View [dbo].[vEntraIDGroups_Target]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vEntraIDGroups_Target]
AS
SELECT     classification, createdByAppId, createdDateTime, deletedDateTime, description, displayName, expirationDateTime, id, infoCatalogs, isAssignableToRole, isManagementRestricted, mail, mailEnabled, mailNickname, membershipRule, membershipRuleProcessingState,
                  onPremisesDomainName, onPremisesLastSyncDateTime, onPremisesNetBiosName, onPremisesProvisioningErrors, onPremisesSamAccountName, onPremisesSecurityIdentifier, onPremisesSyncEnabled, organizationId, preferredDataLocation, preferredLanguage, proxyAddresses,
                  renewedDateTime, resourceBehaviorOptions, resourceProvisioningOptions, securityEnabled, securityIdentifier, theme, visibility, writebackConfiguration, TenantDomain, TenantID, groupType
FROM        dbo.stagingEntraIDGroup
WHERE     (TenantDomain = N'TargetDomain')
GO
/****** Object:  View [dbo].[vADUsers_Target]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vADUsers_Target]
AS
SELECT     AccountExpires, AltRecipient, Company, City, C, Country, CO, CountryCode, CN, ST, Comment, Description, Division, EmployeeID, EmployeeNumber, EmployeeType, HomePhone, Mobile, Pager, FacsimileTelephoneNumber, TelephoneNumber, Street, Initials, Manager, Department, Title,
                  PersonalTitle, DisplayName, GivenName, Surname, DistinguishedName, CanonicalName, Mail, MailNickName, msExchUsageLocation, PhysicalDeliveryOfficeName, SamAccountName, UserPrincipalName, Enabled, ExtensionAttribute1, ExtensionAttribute2, ExtensionAttribute3,
                  ExtensionAttribute4, ExtensionAttribute5, ExtensionAttribute6, ExtensionAttribute7, ExtensionAttribute8, ExtensionAttribute9, ExtensionAttribute10, ExtensionAttribute11, ExtensionAttribute12, ExtensionAttribute13, ExtensionAttribute14, ExtensionAttribute15, msExchExtensionAttribute16,
                  msExchExtensionAttribute17, msExchExtensionAttribute18, msExchExtensionAttribute19, msExchExtensionAttribute20, msExchExtensionAttribute21, msExchExtensionAttribute22, msExchExtensionAttribute23, msExchExtensionAttribute24, msExchExtensionAttribute25,
                  msExchExtensionAttribute26, msExchExtensionAttribute27, msExchExtensionAttribute28, msExchExtensionAttribute29, msExchExtensionAttribute30, msExchExtensionAttribute31, msExchExtensionAttribute32, msExchExtensionAttribute33, msExchExtensionAttribute34,
                  msExchExtensionAttribute35, msExchExtensionAttribute36, msExchExtensionAttribute37, msExchExtensionAttribute38, msExchExtensionAttribute39, msExchExtensionAttribute40, msExchExtensionAttribute41, msExchExtensionAttribute42, msExchExtensionAttribute43,
                  msExchExtensionAttribute44, msExchExtensionAttribute45, LastLogonDate, BusinessCategory, ProxyAddresses, [mS-DS-ConsistencyGUID], msExchMailboxGUID, msExchMasterAccountSID, SID, ObjectGUID, ImmutableID, DomainName, PasswordLastSet, PasswordExpired, PasswordNeverExpires
FROM        dbo.stagingADUser
WHERE     (DomainName = N'TargetDomain')
GO
/****** Object:  View [dbo].[vExistingSourceToTargetMatches]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vExistingSourceToTargetMatches]
AS
SELECT     M.RecipientTypeDetails, M.DomainName, M.CurrentGivenName, M.NewGivenName, M.CurrentSurname, M.NewSurname, M.CurrentSamAccountName, M.CurrentEmailAlias, M.NewEmailAlias, M.NewSamAccountName, M.CurrentEmail, M.NewEmailAndUsername, M.CurrentDisplayName,
                  M.NewDisplayName, C.employeeId AS ConflictEmployeeID, C.onPremisesSamAccountName AS ConflictingSamAccountName, C.companyName AS ConflictingCompanyName, C.department AS ConflictingDepartment
FROM        dbo.vCalcMigUserAttributes_Source AS M INNER JOIN
                  dbo.vTargetEmailEmployeeID AS C ON M.NewEmailAndUsername = C.PrimarySmtpAddress AND M.NewSamAccountName = C.employeeId
WHERE     (M.CurrentSamAccountName NOT LIKE 'AdminAccountPrefix%')
GO
/****** Object:  Table [dbo].[stagingUserDrive]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingUserDrive](
	[UserID] [nvarchar](36) NULL,
	[UserPrincipalName] [nvarchar](256) NULL,
	[createdDateTime] [datetime2](7) NULL,
	[description] [nvarchar](512) NULL,
	[id] [nvarchar](128) NULL,
	[lastModifiedDateTime] [datetime2](7) NULL,
	[name] [nvarchar](32) NULL,
	[webUrl] [nvarchar](256) NULL,
	[driveType] [nvarchar](16) NULL,
	[createdBy] [nvarchar](256) NULL,
	[lastModifiedBy] [nvarchar](256) NULL,
	[owner] [nvarchar](256) NULL,
	[quota] [nvarchar](256) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vWorkFoldersToSourceOneDrive]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vWorkFoldersToSourceOneDrive]
AS
SELECT     dbo.stagingWorkFolders.*, dbo.stagingUserDrive.UserPrincipalName, dbo.stagingUserDrive.UserID, dbo.stagingUserDrive.webUrl, dbo.stagingUserDrive.name AS LibraryName
FROM        dbo.stagingWorkFolders INNER JOIN
                  dbo.stagingUserDrive ON dbo.stagingWorkFolders.Email = dbo.stagingUserDrive.UserPrincipalName
GO
/****** Object:  View [dbo].[vMailboxPrimaryAddress_Target]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vMailboxPrimaryAddress_Target]
AS
SELECT     P.ExternalDirectoryObjectID, P.Address AS PrimaryAddress, SUBSTRING(P.Address, 1, CHARINDEX('@', P.Address) - 1) AS Prefix, A.Address AS RequiredAddress
FROM        dbo.stagingMailboxAddresses AS P LEFT OUTER JOIN
                  dbo.stagingMailboxAddresses AS A ON P.ExternalDirectoryObjectID = A.ExternalDirectoryObjectID
WHERE     (P.Type = N'primary') AND (P.SourceOrganization = N'targetdomain.onmicrosoft.com') AND (A.Address = SUBSTRING(P.Address, 1, CHARINDEX('@', P.Address) - 1) + '@rewrite.com' OR
                  A.Address IS NULL)
GO
/****** Object:  Table [dbo].[stagingPrimaryUsersFromCM]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingPrimaryUsersFromCM](
	[Computer] [nvarchar](64) NULL,
	[User] [nvarchar](32) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vMultiUserComputerUsers]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vMultiUserComputerUsers]
AS
SELECT     [User]
FROM        dbo.stagingPrimaryUsersFromCM
WHERE     (Computer IN
                      (SELECT     Computer
                       FROM        dbo.stagingPrimaryUsersFromCM AS stagingPrimaryUsersFromCM_1
                       GROUP BY Computer
                       HAVING     (COUNT(USER) > 2)))
GO
/****** Object:  Table [dbo].[ISO3166]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ISO3166](
	[name] [nvarchar](255) NULL,
	[alpha-2] [nchar](2) NULL,
	[alpha-3] [nchar](3) NULL,
	[country-code] [nchar](3) NULL,
	[region] [nvarchar](64) NULL,
	[sub-region] [nvarchar](64) NULL,
	[intermediate-region] [nvarchar](64) NULL,
	[region-code] [nchar](3) NULL,
	[sub-region-code] [nchar](3) NULL,
	[intermediate-region-code] [nchar](3) NULL
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[getISO3166FromAlpha3]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[getISO3166FromAlpha3]
(
	@Alpha3 nchar(3)
)
RETURNS TABLE
AS
RETURN
(
	SELECT name, [alpha-2], [alpha-3],[country-code], region, [sub-region], [intermediate-region], [region-code], [sub-region-code], [intermediate-region-code]
	FROM dbo.ISO3166 I
	WHERE I.[alpha-3] = @Alpha3
)
GO
/****** Object:  View [dbo].[vSourceUserInternalTypeWithExternalAddress]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vSourceUserInternalTypeWithExternalAddress]
AS
SELECT     EmployeeID, EmployeeType, GivenName, Surname, DisplayName, Mail, MailNickName, SamAccountName, UserPrincipalName, Enabled, ProxyAddresses, DomainName
FROM        dbo.vADUsers_Source
WHERE     (SamAccountName NOT LIKE 'AdminAccountPrefix%') AND (EmployeeID IS NOT NULL) AND (EmployeeID NOT LIKE 'L%') AND (EmployeeType = 'internal') AND (Mail LIKE '%external%')
GO
/****** Object:  View [dbo].[vSourceUserExternalTypeWithoutExternalAddress]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vSourceUserExternalTypeWithoutExternalAddress]
AS
SELECT     EmployeeID, EmployeeType, GivenName, Surname, DisplayName, Mail, MailNickName, SamAccountName, UserPrincipalName, Enabled, ProxyAddresses, DomainName
FROM        dbo.vADUsers_Source
WHERE     (SamAccountName NOT LIKE 'AdminAccountPrefix%') AND (EmployeeID IS NOT NULL) AND (EmployeeID NOT LIKE 'L%') AND (EmployeeType = 'external') AND (Mail NOT LIKE '%external%') AND (Mail LIKE '%sourcedomain.com%')
GO
/****** Object:  View [dbo].[vMailboxes_Source]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vMailboxes_Source]
AS
SELECT     dbo.stagingMailbox.*
FROM        dbo.stagingMailbox
WHERE     (SourceOrganization = N'SourceDomain.onmicrosoft.com')
GO
/****** Object:  View [dbo].[vMailboxes_Target]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vMailboxes_Target]
AS
SELECT     dbo.stagingMailbox.*
FROM        dbo.stagingMailbox
WHERE     (SourceOrganization = N'targetdomain.onmicrosoft.com')
GO
/****** Object:  Table [dbo].[stagingIntuneDevice]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingIntuneDevice](
	[TenantDomain] [nvarchar](128) NULL,
	[AzureAdDeviceId] [nvarchar](36) NULL,
	[ActivationLockBypassCode] [nvarchar](64) NULL,
	[AndroidSecurityPatchLevel] [nvarchar](64) NULL,
	[AzureAdRegistered] [bit] NULL,
	[ComplianceGracePeriodExpirationDateTime] [datetime2](7) NULL,
	[ComplianceState] [nvarchar](64) NULL,
	[DeviceCategoryDisplayName] [nvarchar](64) NULL,
	[DeviceEnrollmentType] [nvarchar](64) NULL,
	[DeviceName] [nvarchar](128) NULL,
	[DeviceRegistrationState] [nvarchar](64) NULL,
	[EasActivated] [bit] NULL,
	[EasActivationDateTime] [datetime2](7) NULL,
	[EasDeviceId] [nvarchar](64) NULL,
	[EmailAddress] [nvarchar](128) NULL,
	[EnrolledDateTime] [datetime2](7) NULL,
	[EnrollmentProfileName] [nvarchar](32) NULL,
	[EthernetMacAddress] [nvarchar](36) NULL,
	[ExchangeAccessState] [nvarchar](64) NULL,
	[ExchangeAccessStateReason] [nvarchar](64) NULL,
	[ExchangeLastSuccessfulSyncDateTime] [datetime2](7) NULL,
	[FreeStorageSpaceInBytes] [float] NULL,
	[Iccid] [nvarchar](32) NULL,
	[Id] [nvarchar](36) NULL,
	[Imei] [float] NULL,
	[IsEncrypted] [bit] NULL,
	[IsSupervised] [bit] NULL,
	[JailBroken] [nvarchar](32) NULL,
	[LastSyncDateTime] [datetime2](7) NULL,
	[LogCollectionRequests] [nvarchar](32) NULL,
	[ManagedDeviceName] [nvarchar](128) NULL,
	[ManagedDeviceOwnerType] [nvarchar](64) NULL,
	[ManagementAgent] [nvarchar](64) NULL,
	[ManagementCertificateExpirationDate] [datetime2](7) NULL,
	[Manufacturer] [nvarchar](64) NULL,
	[Meid] [float] NULL,
	[Model] [nvarchar](64) NULL,
	[Notes] [nvarchar](64) NULL,
	[OperatingSystem] [nvarchar](64) NULL,
	[OSVersion] [nvarchar](32) NULL,
	[PartnerReportedThreatState] [nvarchar](32) NULL,
	[PhoneNumber] [nvarchar](32) NULL,
	[PhysicalMemoryInBytes] [float] NULL,
	[RemoteAssistanceSessionErrorDetails] [nvarchar](32) NULL,
	[RemoteAssistanceSessionUrl] [nvarchar](256) NULL,
	[RequireUserEnrollmentApproval] [nvarchar](32) NULL,
	[SerialNumber] [nvarchar](64) NULL,
	[SubscriberCarrier] [nvarchar](32) NULL,
	[TotalStorageSpaceInBytes] [float] NULL,
	[Udid] [nvarchar](32) NULL,
	[UserDisplayName] [nvarchar](128) NULL,
	[UserId] [nvarchar](36) NULL,
	[UserPrincipalName] [nvarchar](128) NULL,
	[Users] [nvarchar](32) NULL,
	[WiFiMacAddress] [nvarchar](32) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vIntuneMobileOSDevice_Target]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vIntuneMobileOSDevice_Target]
AS
SELECT     dbo.stagingIntuneDevice.*
FROM        dbo.stagingIntuneDevice
WHERE     (OperatingSystem = N'android') AND (TenantDomain = N'TargetDomain') OR
                  (OperatingSystem = N'iOS') AND (TenantDomain = N'TargetDomain')
GO
/****** Object:  View [dbo].[vIntuneMobileOSDevice_Source]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vIntuneMobileOSDevice_Source]
AS
SELECT     TenantDomain, AzureAdDeviceId, ActivationLockBypassCode, AndroidSecurityPatchLevel, AzureAdRegistered, ComplianceGracePeriodExpirationDateTime, ComplianceState, DeviceCategoryDisplayName, DeviceEnrollmentType, DeviceName, DeviceRegistrationState, EasActivated,
                  EasActivationDateTime, EasDeviceId, EmailAddress, EnrolledDateTime, EnrollmentProfileName, EthernetMacAddress, ExchangeAccessState, ExchangeAccessStateReason, ExchangeLastSuccessfulSyncDateTime, FreeStorageSpaceInBytes, Iccid, Id, Imei, IsEncrypted, IsSupervised,
                  JailBroken, LastSyncDateTime, LogCollectionRequests, ManagedDeviceName, ManagedDeviceOwnerType, ManagementAgent, ManagementCertificateExpirationDate, Manufacturer, Meid, Model, Notes, OperatingSystem, OSVersion, PartnerReportedThreatState, PhoneNumber,
                  PhysicalMemoryInBytes, RemoteAssistanceSessionErrorDetails, RemoteAssistanceSessionUrl, RequireUserEnrollmentApproval, SerialNumber, SubscriberCarrier, TotalStorageSpaceInBytes, Udid, UserDisplayName, UserId, UserPrincipalName, Users, WiFiMacAddress
FROM        dbo.stagingIntuneDevice
WHERE     (OperatingSystem = N'android') AND (TenantDomain = N'SourceDomain') OR
                  (OperatingSystem = N'iOS') AND (TenantDomain = N'SourceDomain')
GO
/****** Object:  View [dbo].[vMobileOSDevicesPerSourceUser]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vMobileOSDevicesPerSourceUser]
AS
SELECT     UserId, STRING_AGG(OperatingSystem + ' ' + CONVERT(NVARCHAR, LastSyncDateTime, 1), '|') AS MobileDevices
FROM        dbo.vIntuneMobileOSDevice_Source AS MD
GROUP BY UserId
GO
/****** Object:  View [dbo].[vMatchingAccountSearch]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vMatchingAccountSearch]
AS
SELECT     SADU.DomainName AS SDomainName, TADU.DomainName AS TDomainName, SADU.EmployeeID AS SEmpID, TADU.EmployeeID AS TEmpID, SADU.SamAccountName AS SSAM, TADU.SamAccountName AS TSAM, SADU.UserPrincipalName AS SUPN, TADU.UserPrincipalName AS TUPN,
                  SADU.Mail AS SMail, TADU.Mail AS TMail, SADU.MailNickName AS SAlias, TADU.MailNickName AS TAlias, SADU.Enabled AS SEnabled, TADU.Enabled AS TEnabled, SADU.[mS-DS-ConsistencyGUID] AS SConsistencyGUID, TADU.[mS-DS-ConsistencyGUID] AS TConsistencyGUID,
                  SADU.ExtensionAttribute1 AS S_ExtAtt1, SADU.msExchExtensionAttribute16 AS S_ExtAtt16, SADU.msExchExtensionAttribute17 AS S_ExtAtt17, SADU.msExchExtensionAttribute18 AS S_ExtAtt18, SADU.msExchExtensionAttribute19 AS S_ExtAtt19,
                  SADU.msExchExtensionAttribute20 AS S_ExtAtt20, SADU.msExchExtensionAttribute21 AS S_ExtAtt21, SADU.msExchExtensionAttribute22 AS S_ExtAtt22, TADU.ExtensionAttribute1 AS T_ExtAtt1, TADU.ExtensionAttribute2 AS T_ExtAtt2, TADU.ExtensionAttribute3 AS T_ExtAtt3,
                  TADU.ExtensionAttribute4 AS T_ExtAtt4, TADU.ExtensionAttribute5 AS T_ExtAtt5, TADU.ExtensionAttribute6 AS T_ExtAtt6, TADU.ExtensionAttribute7 AS T_ExtAtt7, TADU.ExtensionAttribute8 AS T_ExtAtt8, TADU.ExtensionAttribute9 AS T_ExtAtt9, TADU.ExtensionAttribute10 AS T_ExtAtt10,
                  TADU.ExtensionAttribute11 AS T_ExtAtt11, TADU.ExtensionAttribute12 AS T_ExtAtt12, TADU.ExtensionAttribute13 AS T_ExtAtt13, TADU.ExtensionAttribute14 AS T_ExtAtt14, TADU.ExtensionAttribute15 AS T_ExtAtt15, TADU.msExchExtensionAttribute16 AS T_ExtAtt16,
                  TADU.msExchExtensionAttribute17 AS T_ExtAtt17, TADU.msExchExtensionAttribute18 AS T_ExtAtt18, TADU.msExchExtensionAttribute19 AS T_ExtAtt19, TADU.msExchExtensionAttribute20 AS T_ExtAtt20, TADU.msExchExtensionAttribute21 AS T_ExtAtt21,
                  TADU.msExchExtensionAttribute22 AS T_ExtAtt22
FROM        dbo.vADUsers_Target AS TADU INNER JOIN
                  dbo.vADUsers_Source AS SADU ON TADU.EmployeeID = SADU.EmployeeID
GO
/****** Object:  Table [dbo].[WaveExceptions]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WaveExceptions](
	[SourceEntraID] [nvarchar](36) NULL,
	[SourceMail] [nvarchar](128) NULL,
	[AssignedWave] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WaveAssignments]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WaveAssignments](
	[LocationName] [nvarchar](64) NULL,
	[LocationCountry] [nvarchar](64) NULL,
	[SupportResource] [nvarchar](64) NULL,
	[MailboxCount] [int] NULL,
	[AssignedWave] [float] NULL,
	[TargetDate] [datetime2](7) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vAssignedWave]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vAssignedWave]
AS
SELECT  DISTINCT   SEIDU.id,
	CASE
	WHEN WE.AssignedWave IS NULL THEN WA.AssignedWave
	ELSE WE.AssignedWave END AS AssignedWave,
	CASE WHEN WE.AssignedWave IS NULL THEN 'ByLocation'
	ELSE 'ByException' END AS AssignmentType
FROM        dbo.vEntraIDUsers_Source AS SEIDU LEFT OUTER JOIN
                  dbo.vStagingWorkday AS WD ON SEIDU.mail = WD.EmailAddress OR (SEIDU.employeeId = WD.AEmployeeID1 OR SEIDU.employeeId = WD.AEmployeeID2)
				  LEFT OUTER JOIN
                  dbo.WaveAssignments AS WA ON WA.LocationName = WD.Location LEFT OUTER JOIN
                  dbo.WaveExceptions AS WE ON WE.SourceEntraID = SEIDU.id
GO
/****** Object:  View [dbo].[vFlyOneDrive]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vFlyOneDrive]
AS
SELECT     ProjectName, ProjectType, Source, Destination
FROM        dbo.stagingFlyUserProjectMapping
WHERE     (ProjectType = N'OneDrive')
GO
/****** Object:  View [dbo].[vFlyTeamsChat]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vFlyTeamsChat]
AS
SELECT     ProjectName, ProjectType, Source, Destination
FROM        dbo.stagingFlyUserProjectMapping
WHERE     (ProjectType = N'TeamChat')
GO
/****** Object:  Table [dbo].[staticMigrationList]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[staticMigrationList](
	[SourceEntraID] [nvarchar](36) NULL,
	[TargetEntraID] [nvarchar](36) NULL,
	[SourceADID] [nvarchar](36) NULL,
	[TargetADID] [nvarchar](36) NULL,
	[SourceConsistency] [nvarchar](36) NULL,
	[TargetConsistency] [nvarchar](36) NULL,
	[WDEmployeeID] [nvarchar](8) NULL,
	[SourceEntraIDEnabled] [bit] NULL,
	[TargetEntraIDEnabled] [bit] NULL,
	[SourceADEnabled] [bit] NULL,
	[TargetADEnabled] [bit] NULL,
	[SourcePasswordLastSet] [date] NULL,
	[TargetPasswordLastSet] [date] NULL,
	[TargetGoodForKerb] [bit] NULL,
	[LeaveStatus] [nvarchar](10) NULL,
	[SourceCanonicalName] [nvarchar](256) NULL,
	[TargetCanonicalName] [nvarchar](256) NULL,
	[SourceFirstName] [nvarchar](64) NULL,
	[TargetFirstName] [nvarchar](64) NULL,
	[SourceLastName] [nvarchar](64) NULL,
	[TargetLastName] [nvarchar](64) NULL,
	[SourceDisplayName] [nvarchar](128) NULL,
	[TargetDisplayName] [nvarchar](128) NULL,
	[SourceMail] [nvarchar](128) NULL,
	[TargetMail] [nvarchar](128) NULL,
	[TargetRewrite] [nvarchar](128) NULL,
	[SourceRecipientType] [nvarchar](256) NULL,
	[TargetRecipientType] [nvarchar](256) NULL,
	[SourceTargetAddress] [nvarchar](256) NULL,
	[TargetTargetAddress] [nvarchar](256) NULL,
	[SourceForwardingSMTPAddress] [nvarchar](256) NULL,
	[TargetForwardingSMTPAddress] [nvarchar](256) NULL,
	[SourceAlias] [nvarchar](128) NULL,
	[TargetAlias] [nvarchar](128) NULL,
	[SourceSAM] [nvarchar](64) NULL,
	[TargetSAM] [nvarchar](64) NULL,
	[SourceADUPN] [nvarchar](128) NULL,
	[TargetADUPN] [nvarchar](128) NULL,
	[SourceEntraUPN] [nvarchar](128) NULL,
	[TargetEntraUPN] [nvarchar](128) NULL,
	[TargetGuestUPN] [nvarchar](128) NULL,
	[SpecialHandlingNotes] [nvarchar](4000) NULL,
	[AssignedWave] [float] NULL,
	[AssignmentType] [varchar](11) NULL,
	[TargetDate] [date] NULL,
	[SourceLitigationHoldEnabled] [varchar](5) NULL,
	[TargetLitigationHoldEnabled] [varchar](5) NULL,
	[SourceMailboxGB] [nvarchar](10) NULL,
	[SourceMailboxDeletedGB] [nvarchar](10) NULL,
	[SourceMailboxItemCount] [int] NULL,
	[SourceDriveGB] [float] NULL,
	[SourceDriveURL] [nvarchar](256) NULL,
	[SourceDriveCount] [int] NULL,
	[TargetDriveURL] [nvarchar](256) NULL,
	[WorkFolders] [nvarchar](128) NULL,
	[usageLocation] [nvarchar](2) NULL,
	[Country] [nvarchar](3) NULL,
	[Location] [nvarchar](64) NULL,
	[LocationCountry] [nvarchar](32) NULL,
	[Region] [nvarchar](32) NULL,
	[SourceLicensing] [nvarchar](128) NULL,
	[TargetLicensing] [nvarchar](128) NULL,
	[SourceMobileDevices] [nvarchar](4000) NULL,
	[msExchExtensionAttribute16] [nvarchar](128) NULL,
	[msExchExtensionAttribute17] [nvarchar](128) NULL,
	[msExchExtensionAttribute18] [nvarchar](128) NULL,
	[msExchExtensionAttribute20] [nvarchar](128) NULL,
	[msExchExtensionAttribute21] [nvarchar](128) NULL,
	[msExchExtensionAttribute22] [nvarchar](128) NULL,
	[msExchExtensionAttribute23] [nvarchar](128) NULL,
	[SourceEntraLastSyncTime] [date] NULL,
	[TargetEntraLastSyncTime] [date] NULL,
	[SourceEntraLastSigninTime] [date] NULL,
	[TargetEntraLastSigninTime] [date] NULL,
	[SourceEntraType] [nvarchar](32) NULL,
	[TargetEntraType] [nvarchar](32) NULL,
	[SourceADDomain] [nvarchar](64) NULL,
	[TargetADDomain] [nvarchar](64) NULL,
	[SourceDC] [nvarchar](25) NULL,
	[TargetDC] [nvarchar](28) NOT NULL,
	[MatchScenario] [nvarchar](13) NULL,
	[spoitemid] [int] NULL,
	[MigrationStatus] [nvarchar](64) NULL,
	[ManagerEmail] [nvarchar](128) NULL,
	[SourceMFARegistered] [bit] NULL,
	[TargetMFARegistered] [bit] NULL,
	[FlyOneDrive] [nvarchar](64) NULL,
	[FlyTeamsChat] [nvarchar](64) NULL,
	[FlyExchange] [nvarchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingWavePlan]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingWavePlan](
	[Wave] [float] NULL,
	[TargetDate] [datetime2](7) NULL,
	[T1] [datetime2](7) NULL,
	[FlyOneDrive] [nvarchar](64) NULL,
	[FlyTeamsChat] [nvarchar](64) NULL,
	[FlyExchange] [nvarchar](64) NULL,
	[Description] [nvarchar](256) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vMigrationStatusPerUser]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vMigrationStatusPerUser]
AS
SELECT     L.WDEmployeeID, L.SourceEntraID, L.spoitemid, L.AssignedWave, L.AssignmentType, L.FlyExchange AS UserFlyExchange, P.FlyExchange AS PlanFlyExchange, CASE WHEN CAST(P.TargetDate AS date) <= CAST(GETDATE() AS date) AND
                  P.FlyExchange = L.FlyExchange THEN '4 - Completed' WHEN CAST(P.TargetDate AS date) > CAST(GETDATE() AS date) AND P.FlyExchange = L.FlyExchange THEN '1 - Scheduled' WHEN CAST(P.TargetDate AS date) > CAST(GETDATE() AS date) AND (P.FlyExchange <> L.FlyExchange OR
                  L.FlyExchange IS NULL) THEN '1 - Scheduling' WHEN CAST(P.TargetDate AS date) <= CAST(GETDATE() AS date) AND (P.FlyExchange <> L.FlyExchange OR
                  L.FlyExchange IS NULL) THEN '5 - Pending Wave Assignment' WHEN AssignedWave IS NULL THEN '5 - Pending Wave Assignment' WHEN AssignedWave > 90 AND AssignedWave < 99 THEN '2 - Issue' WHEN AssignedWave = 99 THEN '3 - Not Migrating' END AS MigrationStatus
FROM        dbo.staticMigrationList AS L LEFT OUTER JOIN
                  dbo.stagingWavePlan AS P ON L.AssignedWave = P.Wave
WHERE     (L.spoitemid IS NOT NULL)
GO
/****** Object:  Table [dbo].[stagingSpecialHandling]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingSpecialHandling](
	[SourceMail] [nvarchar](128) NULL,
	[EmployeeID] [nvarchar](16) NULL,
	[Note] [nvarchar](512) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vSpecialHandling]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vSpecialHandling]
AS
SELECT     SourceMail, EmployeeID, STRING_AGG(Note,' | ') WITHIN GROUP ( ORDER BY Note ASC) SpecialHandlingNotes
FROM        dbo.stagingSpecialHandling
GROUP BY  SourceMail, EmployeeID

GO
/****** Object:  View [dbo].[viewPermissionsForAnalysis]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewPermissionsForAnalysis]
AS
SELECT     P.SourceOrganization, P.PermissionIdentity, P.ParentPermissionIdentity, P.SourceExchangeOrganization, P.TargetRecipientType, P.TargetRecipientTypeDetails, P.TargetAlias, P.TrusteeRecipientType, P.TrusteeRecipientTypeDetails, P.TrusteeAlias, P.TargetFolderType, P.PermissionType,
                  P.AssignmentType, P.TargetPrimarySMTPAddress, P.TrusteePrimarySMTPAddress, P.TrusteeIdentity, P.TargetDistinguishedName, P.TrusteeDistinguishedName, P.TargetFolderPath, P.FolderAccessRights, P.TargetObjectGUID, P.TargetExchangeGUID, P.TrusteeGroupObjectGUID,
                  P.TrusteeObjectGUID, P.TrusteeExchangeGUID, P.IsAutoMapped, P.IsInherited, Target.ExternalDirectoryObjectID AS TargetEntraID, Trustee.ExternalDirectoryObjectID AS TrusteeEntraID
FROM        dbo.stagingPermissions AS P LEFT OUTER JOIN
                  dbo.stagingMailbox AS Trustee ON P.TrusteeExchangeGUID = Trustee.ExchangeGuid LEFT OUTER JOIN
                  dbo.stagingMailbox AS Target ON P.TargetExchangeGUID = Target.ExchangeGuid
WHERE     (P.TrusteeAlias NOT IN ('CommonlyUsedAdminAccounts')) AND (P.PermissionIdentity NOT IN
                      (SELECT     PermissionIdentity
                       FROM        dbo.vIgnorablePermissions)) AND (P.ParentPermissionIdentity NOT IN
                      (SELECT     PermissionIdentity
                       FROM        dbo.vIgnorablePermissions AS vIgnorablePermissions_1) OR
                  P.ParentPermissionIdentity IS NULL)
GO
/****** Object:  View [dbo].[viewRecipientConnectionsPerAssignedWave]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewRecipientConnectionsPerAssignedWave]
AS
SELECT     TOP (100) PERCENT Recipient, AssignedWave, COUNT(CONNECTION) AS ConnectionCount
FROM        (SELECT DISTINCT P.TargetEntraID AS Recipient, P.TrusteeEntraID AS CONNECTION, L.AssignedWave
                   FROM        dbo.viewPermissionsForAnalysis AS P INNER JOIN
                                     dbo.staticMigrationList AS L ON P.TrusteeEntraID = L.SourceEntraID
                   WHERE     (P.PermissionType <> 'SendAS')
                   UNION
                   SELECT DISTINCT P.TrusteeEntraID AS Recipient, P.TargetEntraID AS CONNECTION, L.AssignedWave
                   FROM        dbo.viewPermissionsForAnalysis AS P INNER JOIN
                                     dbo.staticMigrationList AS L ON P.TargetEntraID = L.SourceEntraID
                   WHERE     (P.PermissionType <> 'SendAS')) AS TheSum
WHERE     (Recipient IS NOT NULL)
GROUP BY Recipient, AssignedWave
ORDER BY Recipient, AssignedWave
GO
/****** Object:  View [dbo].[vPermissionsReport]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vPermissionsReport]
AS
SELECT DISTINCT
                  P.TargetEntraID, P.TrusteeEntraID, P.TargetRecipientTypeDetails, P.TargetPrimarySMTPAddress, P.TrusteeRecipientTypeDetails, P.TrusteePrimarySMTPAddress, P.PermissionType, P.TargetFolderType, P.TrusteeIdentity, P.TargetDistinguishedName, P.TrusteeDistinguishedName,
                  P.FolderAccessRights, P.TrusteeExchangeGUID, P.TargetExchangeGUID, TEM.SourceAlias AS TrusteeAlias, TEM.AssignedWave AS TrusteeWave, TAM.SourceAlias AS TargetAlias, TAM.AssignedWave AS TargetWave
FROM        dbo.viewPermissionsForAnalysis AS P LEFT OUTER JOIN
                  dbo.staticMigrationList AS TEM ON P.TrusteeEntraID = TEM.SourceEntraID LEFT OUTER JOIN
                  dbo.staticMigrationList AS TAM ON P.TargetEntraID = TAM.SourceEntraID
GO
/****** Object:  View [dbo].[vTrusteesSummaryForMigrationList]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vTrusteesSummaryForMigrationList]
AS
SELECT
    L.SourceEntraID,
    STRING_AGG(
        (
            CASE P.PermissionType
                WHEN 'FullAccess' THEN 'FA'
                WHEN 'SendOnBehalf' THEN 'SB'
                WHEN 'Folder' THEN 'C'
            END
        ) + ':' + P.TrusteeAlias + ' (' + CONVERT(
            NVARCHAR(5),
            ISNULL(Convert(NVARCHAR(5), P.TrusteeWave), 'NA')
        ) + ')',
        ' | '
    ) WITHIN GROUP (
        ORDER BY
            P.TrusteeAlias ASC
    ) AS Trustees
FROM
    staticMigrationList L
    JOIN vPermissionsReport P ON L.SourceEntraID = P.TargetEntraID
WHERE
    (
        P.PermissionType IN ('FullAccess', 'SendOnBehalf')
        OR (
            P.PermissionType = 'Folder'
            AND P.TargetFolderType = 'Calendar'
        )
    )
    AND P.TrusteeAlias IS NOT NULL
GROUP BY
    L.SourceEntraID
GO
/****** Object:  View [dbo].[vTargetsSummaryForMigrationList]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vTargetsSummaryForMigrationList]
AS
SELECT
    L.SourceEntraID,
    STRING_AGG(
        (
            CASE P.PermissionType
                WHEN 'FullAccess' THEN 'FA'
                WHEN 'SendOnBehalf' THEN 'SB'
                WHEN 'Folder' THEN 'C'
            END
        ) + ':' + P.TargetAlias + ' (' + CONVERT(
            NVARCHAR(5),
            ISNULL(CONVERT(NVARCHAR(5), P.TargetWave), 'NA')
        ) + ')',
        ' | '
    ) WITHIN GROUP (
        ORDER BY
            P.TargetAlias ASC
    ) AS Targets
FROM
    staticMigrationList L
    JOIN vPermissionsReport P ON L.SourceEntraID = P.TrusteeEntraID
WHERE
    (
        P.PermissionType IN ('FullAccess', 'SendOnBehalf')
        OR (
            P.PermissionType = 'Folder'
            AND P.TargetFolderType = 'Calendar'
        )
    )
    AND P.TargetAlias IS NOT NULL
GROUP BY
    L.SourceEntraID
GO
/****** Object:  Table [dbo].[configurationOrganization]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[configurationOrganization](
	[Name] [nvarchar](64) NULL,
	[MigrationRole] [nvarchar](64) NULL,
	[Credential] [nvarchar](1024) NULL,
	[TenantDomain] [nvarchar](512) NULL,
	[PrimaryDomain] [nvarchar](512) NULL,
	[ConflictPrefix] [nvarchar](8) NULL,
	[ConflictPriority] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CT_UserExceptions]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_UserExceptions](
	[EmployeeID] [nvarchar](12) NULL,
	[NewDisplayName] [nvarchar](255) NULL,
	[NewAlias] [nvarchar](255) NULL,
	[NewSamAccountName] [nvarchar](20) NULL,
	[NewFirstName] [nvarchar](255) NULL,
	[NewLastName] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[historyADUser]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[historyADUser](
	[mS-DS-ConsistencyGUID] [nchar](36) NULL,
	[msExchMailboxGUID] [nchar](36) NULL,
	[ObjectGUID] [nchar](36) NULL,
	[msExchMasterAccountSID] [nvarchar](256) NULL,
	[SID] [nvarchar](256) NULL,
	[DisplayName] [nvarchar](256) NULL,
	[Mail] [nvarchar](256) NULL,
	[DomainName] [nvarchar](256) NULL,
	[UserPrincipalName] [nvarchar](256) NULL,
	[Division] [nvarchar](256) NULL,
	[employeeType] [nvarchar](256) NULL,
	[businesscategory] [nvarchar](128) NULL,
	[physicalDeliveryOfficeName] [nvarchar](128) NULL,
	[City] [nvarchar](64) NULL,
	[Company] [nvarchar](64) NULL,
	[Country] [nvarchar](64) NULL,
	[Department] [nvarchar](64) NULL,
	[mailnickname] [nvarchar](64) NULL,
	[GivenName] [nvarchar](64) NULL,
	[Surname] [nvarchar](64) NULL,
	[SamAccountName] [nvarchar](64) NULL,
	[ProxyAddresses] [nvarchar](4000) NULL,
	[DistinguishedName] [nvarchar](1024) NULL,
	[CanonicalName] [nvarchar](1024) NULL,
	[Description] [nvarchar](1024) NULL,
	[Manager] [nvarchar](1024) NULL,
	[ExtensionAttribute1] [nvarchar](1024) NULL,
	[ExtensionAttribute2] [nvarchar](1024) NULL,
	[ExtensionAttribute3] [nvarchar](1024) NULL,
	[ExtensionAttribute4] [nvarchar](1024) NULL,
	[ExtensionAttribute5] [nvarchar](1024) NULL,
	[ExtensionAttribute6] [nvarchar](1024) NULL,
	[ExtensionAttribute7] [nvarchar](1024) NULL,
	[ExtensionAttribute8] [nvarchar](1024) NULL,
	[ExtensionAttribute9] [nvarchar](1024) NULL,
	[ExtensionAttribute10] [nvarchar](1024) NULL,
	[ExtensionAttribute11] [nvarchar](1024) NULL,
	[ExtensionAttribute12] [nvarchar](1024) NULL,
	[ExtensionAttribute13] [nvarchar](1024) NULL,
	[ExtensionAttribute14] [nvarchar](1024) NULL,
	[ExtensionAttribute15] [nvarchar](1024) NULL,
	[msExchExtensionAttribute16] [nvarchar](1024) NULL,
	[msExchExtensionAttribute17] [nvarchar](1024) NULL,
	[msExchExtensionAttribute18] [nvarchar](1024) NULL,
	[msExchExtensionAttribute19] [nvarchar](1024) NULL,
	[msExchExtensionAttribute20] [nvarchar](1024) NULL,
	[msExchExtensionAttribute21] [nvarchar](1024) NULL,
	[msExchExtensionAttribute22] [nvarchar](1024) NULL,
	[msExchExtensionAttribute23] [nvarchar](1024) NULL,
	[msExchExtensionAttribute24] [nvarchar](1024) NULL,
	[msExchExtensionAttribute25] [nvarchar](1024) NULL,
	[msExchExtensionAttribute26] [nvarchar](1024) NULL,
	[msExchExtensionAttribute27] [nvarchar](1024) NULL,
	[msExchExtensionAttribute28] [nvarchar](1024) NULL,
	[msExchExtensionAttribute29] [nvarchar](1024) NULL,
	[msExchExtensionAttribute30] [nvarchar](1024) NULL,
	[msExchExtensionAttribute31] [nvarchar](1024) NULL,
	[msExchExtensionAttribute32] [nvarchar](1024) NULL,
	[msExchExtensionAttribute33] [nvarchar](1024) NULL,
	[msExchExtensionAttribute34] [nvarchar](1024) NULL,
	[msExchExtensionAttribute35] [nvarchar](1024) NULL,
	[msExchExtensionAttribute36] [nvarchar](1024) NULL,
	[msExchExtensionAttribute37] [nvarchar](1024) NULL,
	[msExchExtensionAttribute38] [nvarchar](1024) NULL,
	[msExchExtensionAttribute39] [nvarchar](1024) NULL,
	[msExchExtensionAttribute40] [nvarchar](1024) NULL,
	[msExchExtensionAttribute41] [nvarchar](1024) NULL,
	[msExchExtensionAttribute42] [nvarchar](1024) NULL,
	[msExchExtensionAttribute43] [nvarchar](1024) NULL,
	[msExchExtensionAttribute44] [nvarchar](1024) NULL,
	[msExchExtensionAttribute45] [nvarchar](1024) NULL,
	[msExchExtensionCustomAttribute1] [nvarchar](4000) NULL,
	[msExchExtensionCustomAttribute2] [nvarchar](4000) NULL,
	[msExchExtensionCustomAttribute3] [nvarchar](4000) NULL,
	[msExchExtensionCustomAttribute4] [nvarchar](4000) NULL,
	[msExchExtensionCustomAttribute5] [nvarchar](4000) NULL,
	[initials] [nvarchar](6) NULL,
	[employeeID] [nvarchar](16) NULL,
	[employeeNumber] [nvarchar](512) NULL,
	[countryCode] [nchar](2) NULL,
	[Enabled] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[historyContact]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[historyContact](
	[SourceOrganization] [nvarchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[historyMailbox]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[historyMailbox](
	[SourceOrganization] [nvarchar](64) NULL,
	[ExchangeGuid] [nchar](36) NULL,
	[ExchangeObjectId] [nchar](36) NULL,
	[ExternalDirectoryObjectID] [nchar](36) NULL,
	[ArchiveGuid] [nchar](36) NULL,
	[Guid] [nchar](36) NULL,
	[Alias] [nvarchar](64) NULL,
	[SamAccountName] [nvarchar](64) NULL,
	[DisplayName] [nvarchar](256) NULL,
	[Name] [nvarchar](256) NULL,
	[PrimarySmtpAddress] [nvarchar](256) NULL,
	[UserPrincipalName] [nvarchar](256) NULL,
	[RemoteRoutingAddress] [nvarchar](256) NULL,
	[TargetAddress] [nvarchar](256) NULL,
	[ForwardingAddress] [nvarchar](256) NULL,
	[ForwardingSmtpAddress] [nvarchar](256) NULL,
	[LegacyExchangeDN] [nvarchar](256) NULL,
	[RecipientType] [nvarchar](256) NULL,
	[RecipientTypeDetails] [nvarchar](256) NULL,
	[RemoteRecipientType] [nvarchar](256) NULL,
	[LinkedMasterAccount] [nvarchar](256) NULL,
	[CustomAttribute1] [nvarchar](1024) NULL,
	[CustomAttribute2] [nvarchar](1024) NULL,
	[CustomAttribute3] [nvarchar](1024) NULL,
	[CustomAttribute4] [nvarchar](1024) NULL,
	[CustomAttribute5] [nvarchar](1024) NULL,
	[CustomAttribute6] [nvarchar](1024) NULL,
	[CustomAttribute7] [nvarchar](1024) NULL,
	[CustomAttribute8] [nvarchar](1024) NULL,
	[CustomAttribute9] [nvarchar](1024) NULL,
	[CustomAttribute10] [nvarchar](1024) NULL,
	[CustomAttribute11] [nvarchar](1024) NULL,
	[CustomAttribute12] [nvarchar](1024) NULL,
	[CustomAttribute13] [nvarchar](1024) NULL,
	[CustomAttribute14] [nvarchar](1024) NULL,
	[CustomAttribute15] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute1] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute2] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute3] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute4] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute5] [nvarchar](1024) NULL,
	[Department] [nvarchar](256) NULL,
	[Office] [nvarchar](256) NULL,
	[OrganizationalUnit] [nvarchar](256) NULL,
	[Database] [nvarchar](256) NULL,
	[ArchiveName] [nvarchar](256) NULL,
	[ArchiveDomain] [nvarchar](256) NULL,
	[ArchiveStatus] [nvarchar](256) NULL,
	[ArchiveState] [nvarchar](256) NULL,
	[RetentionPolicy] [nvarchar](256) NULL,
	[RetainDeletedItemsFor] [nvarchar](64) NULL,
	[ManagedFolderMailboxPolicy] [nvarchar](256) NULL,
	[AddressBookPolicy] [nvarchar](256) NULL,
	[RoleAssignmentPolicy] [nvarchar](256) NULL,
	[SharingPolicy] [nvarchar](256) NULL,
	[DefaultPublicFolderMailbox] [nvarchar](256) NULL,
	[RecipientLimits] [nvarchar](64) NULL,
	[ResourceCapacity] [nvarchar](64) NULL,
	[DistinguishedName] [nvarchar](1024) NULL,
	[WhenCreatedUTC] [datetime] NULL,
	[WhenChangedUTC] [datetime] NULL,
	[WhenMailboxCreated] [datetime] NULL,
	[EmailAddresses] [nvarchar](4000) NULL,
	[UseDatabaseRetentionDefaults] [bit] NULL,
	[UseDatabaseQuotaDefaults] [bit] NULL,
	[LitigationHoldEnabled] [bit] NULL,
	[SingleItemRecoveryEnabled] [bit] NULL,
	[RetentionHoldEnabled] [bit] NULL,
	[BccBlocked] [bit] NULL,
	[AutoExpandingArchiveEnabled] [bit] NULL,
	[HiddenFromAddressListsEnabled] [bit] NULL,
	[EmailAddressPolicyEnabled] [bit] NULL,
	[MessageCopyForSentAsEnabled] [bit] NULL,
	[MessageCopyForSendOnBehalfEnabled] [bit] NULL,
	[DeliverToMailboxAndForward] [bit] NULL,
	[MessageTrackingReadStatusEnabled] [bit] NULL,
	[DowngradeHighPriorityMessagesEnabled] [bit] NULL,
	[UMEnabled] [bit] NULL,
	[IsAuxMailbox] [bit] NULL,
	[CalendarVersionStoreDisabled] [bit] NULL,
	[SKUAssigned] [bit] NULL,
	[AuditEnabled] [bit] NULL,
	[ArchiveQuotaInGB] [nvarchar](10) NULL,
	[ArchiveWarningQuotaInGB] [nvarchar](10) NULL,
	[CalendarLoggingQuotaInGB] [nvarchar](10) NULL,
	[IssueWarningQuotaInGB] [nvarchar](10) NULL,
	[ProhibitSendQuotaInGB] [nvarchar](10) NULL,
	[ProhibitSendReceiveQuotaInGB] [nvarchar](10) NULL,
	[RecoverableItemsQuotaInGB] [nvarchar](10) NULL,
	[RecoverableItemsWarningQuotaInGB] [nvarchar](10) NULL,
	[RulesQuotaInKB] [nvarchar](10) NULL,
	[MaxSendSizeInMB] [nvarchar](10) NULL,
	[MaxReceiveSizeInMB] [nvarchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[historyMailboxStats]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[historyMailboxStats](
	[SourceOrganization] [nvarchar](64) NULL,
	[MailboxGuid] [nchar](36) NULL,
	[OwnerADGuid] [nchar](36) NULL,
	[ExternalDirectoryOrganizationID] [nchar](36) NULL,
	[TotalItemSizeInGB] [nvarchar](10) NULL,
	[TotalDeletedItemSizeInGB] [nvarchar](10) NULL,
	[MessageTableTotalSizeInGB] [nvarchar](10) NULL,
	[AttachmentTableTotalSizeInGB] [nvarchar](10) NULL,
	[ItemCount] [int] NULL,
	[DeletedItemCount] [int] NULL,
	[AssociatedItemCount] [int] NULL,
	[LastLoggoffTime] [datetime] NULL,
	[LastLogonTime] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[historyPermissions]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[historyPermissions](
	[SourceOrganization] [nvarchar](64) NULL,
	[PermissionIdentity] [nchar](36) NULL,
	[ParentPermissionIdentity] [nchar](36) NULL,
	[SourceExchangeOrganization] [nvarchar](64) NULL,
	[TargetRecipientType] [nvarchar](64) NULL,
	[TargetRecipientTypeDetails] [nvarchar](64) NULL,
	[TargetAlias] [nvarchar](64) NULL,
	[TrusteeRecipientType] [nvarchar](64) NULL,
	[TrusteeRecipientTypeDetails] [nvarchar](64) NULL,
	[TrusteeAlias] [nvarchar](64) NULL,
	[TargetFolderType] [nvarchar](64) NULL,
	[PermissionType] [nvarchar](64) NULL,
	[AssignmentType] [nvarchar](64) NULL,
	[TargetPrimarySMTPAddress] [nvarchar](256) NULL,
	[TrusteePrimarySMTPAddress] [nvarchar](256) NULL,
	[TrusteeIdentity] [nvarchar](256) NULL,
	[TargetDistinguishedName] [nvarchar](1024) NULL,
	[TrusteeDistinguishedName] [nvarchar](1024) NULL,
	[TargetFolderPath] [nvarchar](1024) NULL,
	[FolderAccessRights] [nvarchar](1024) NULL,
	[TargetObjectGUID] [nchar](36) NULL,
	[TargetExchangeGUID] [nchar](36) NULL,
	[TrusteeGroupObjectGUID] [nchar](36) NULL,
	[TrusteeObjectGUID] [nchar](36) NULL,
	[TrusteeExchangeGUID] [nchar](36) NULL,
	[IsAutoMapped] [nvarchar](5) NULL,
	[IsInherited] [nvarchar](5) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[historyRecipient]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[historyRecipient](
	[SourceOrganization] [nvarchar](64) NULL,
	[ExchangeGuid] [nchar](36) NULL,
	[ExchangeObjectId] [nchar](36) NULL,
	[ExternalDirectoryObjectID] [nchar](36) NULL,
	[ArchiveGuid] [nchar](36) NULL,
	[Guid] [nchar](36) NULL,
	[Alias] [nvarchar](64) NULL,
	[DisplayName] [nvarchar](256) NULL,
	[PrimarySmtpAddress] [nvarchar](256) NULL,
	[ExternalEmailAddress] [nvarchar](256) NULL,
	[RecipientType] [nvarchar](256) NULL,
	[RecipientTypeDetails] [nvarchar](256) NULL,
	[CustomAttribute1] [nvarchar](1024) NULL,
	[CustomAttribute2] [nvarchar](1024) NULL,
	[CustomAttribute3] [nvarchar](1024) NULL,
	[CustomAttribute4] [nvarchar](1024) NULL,
	[CustomAttribute5] [nvarchar](1024) NULL,
	[CustomAttribute6] [nvarchar](1024) NULL,
	[CustomAttribute7] [nvarchar](1024) NULL,
	[CustomAttribute8] [nvarchar](1024) NULL,
	[CustomAttribute9] [nvarchar](1024) NULL,
	[CustomAttribute10] [nvarchar](1024) NULL,
	[CustomAttribute11] [nvarchar](1024) NULL,
	[CustomAttribute12] [nvarchar](1024) NULL,
	[CustomAttribute13] [nvarchar](1024) NULL,
	[CustomAttribute14] [nvarchar](1024) NULL,
	[CustomAttribute15] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute1] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute2] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute3] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute4] [nvarchar](1024) NULL,
	[ExtensionCustomAttribute5] [nvarchar](1024) NULL,
	[Department] [nvarchar](256) NULL,
	[Company] [nvarchar](256) NULL,
	[Office] [nvarchar](256) NULL,
	[City] [nvarchar](256) NULL,
	[DistinguishedName] [nvarchar](1024) NULL,
	[Manager] [nvarchar](1024) NULL,
	[WhenCreatedUTC] [datetime] NULL,
	[WhenChangedUTC] [datetime] NULL,
	[EmailAddresses] [nvarchar](4000) NULL,
	[ArchiveStatus] [nvarchar](256) NULL,
	[ArchiveState] [nvarchar](256) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingADComputer]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingADComputer](
	[AccountExpirationDate] [nvarchar](128) NULL,
	[AccountExpires] [bigint] NULL,
	[AccountLockoutTime] [nvarchar](128) NULL,
	[AccountNotDelegated] [bit] NULL,
	[AllowReversiblePasswordEncryption] [bit] NULL,
	[CannotChangePassword] [bit] NULL,
	[CanonicalName] [nvarchar](256) NULL,
	[CN] [nvarchar](128) NULL,
	[codePage] [int] NULL,
	[countryCode] [int] NULL,
	[Created] [datetime2](7) NULL,
	[createTimeStamp] [datetime2](7) NULL,
	[Description] [nvarchar](512) NULL,
	[DisplayName] [nvarchar](128) NULL,
	[DistinguishedName] [nvarchar](256) NULL,
	[DNSHostName] [nvarchar](128) NULL,
	[DoesNotRequirePreAuth] [bit] NULL,
	[Enabled] [bit] NULL,
	[HomedirRequired] [bit] NULL,
	[HomePage] [nvarchar](32) NULL,
	[instanceType] [int] NULL,
	[IPv4Address] [nvarchar](64) NULL,
	[IPv6Address] [nvarchar](128) NULL,
	[isCriticalSystemObject] [bit] NULL,
	[isDeleted] [bit] NULL,
	[LastBadPasswordAttempt] [nvarchar](64) NULL,
	[LastKnownParent] [nvarchar](128) NULL,
	[LastLogonDate] [datetime2](7) NULL,
	[lastLogonTimestamp] [bigint] NULL,
	[localPolicyFlags] [int] NULL,
	[Location] [nvarchar](64) NULL,
	[LockedOut] [bit] NULL,
	[ManagedBy] [nvarchar](128) NULL,
	[MNSLogonAccount] [bit] NULL,
	[Modified] [datetime2](7) NULL,
	[modifyTimeStamp] [datetime2](7) NULL,
	[Name] [nvarchar](64) NULL,
	[ObjectCategory] [nvarchar](128) NULL,
	[ObjectClass] [nvarchar](64) NULL,
	[OperatingSystem] [nvarchar](64) NULL,
	[OperatingSystemHotfix] [nvarchar](64) NULL,
	[OperatingSystemServicePack] [nvarchar](64) NULL,
	[OperatingSystemVersion] [nvarchar](64) NULL,
	[PasswordExpired] [bit] NULL,
	[PasswordLastSet] [datetime2](7) NULL,
	[PasswordNeverExpires] [bit] NULL,
	[PasswordNotRequired] [bit] NULL,
	[PrimaryGroup] [nvarchar](128) NULL,
	[primaryGroupID] [int] NULL,
	[ProtectedFromAccidentalDeletion] [bit] NULL,
	[pwdLastSet] [bigint] NULL,
	[SamAccountName] [nvarchar](64) NULL,
	[sAMAccountType] [int] NULL,
	[sDRightsEffective] [int] NULL,
	[TrustedForDelegation] [bit] NULL,
	[TrustedToAuthForDelegation] [bit] NULL,
	[UseDESKeyOnly] [bit] NULL,
	[userAccountControl] [int] NULL,
	[uSNChanged] [bigint] NULL,
	[uSNCreated] [bigint] NULL,
	[whenChanged] [datetime2](7) NULL,
	[whenCreated] [datetime2](7) NULL,
	[MemberOf] [nvarchar](2048) NULL,
	[SID] [nvarchar](64) NULL,
	[SIDHistory] [nvarchar](256) NULL,
	[ObjectGUID] [nvarchar](36) NULL,
	[DomainName] [nvarchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingADGroup]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingADGroup](
	[CanonicalName] [nvarchar](256) NULL,
	[CN] [nvarchar](128) NULL,
	[Created] [datetime2](7) NULL,
	[CreateTimeStamp] [datetime2](7) NULL,
	[Description] [nvarchar](512) NULL,
	[DisplayName] [nvarchar](128) NULL,
	[DistinguishedName] [nvarchar](256) NULL,
	[GroupCategory] [nvarchar](64) NULL,
	[GroupScope] [nvarchar](64) NULL,
	[GroupType] [int] NULL,
	[HomePage] [nvarchar](64) NULL,
	[InstanceType] [int] NULL,
	[Modified] [datetime2](7) NULL,
	[ModifyTimeStamp] [datetime2](7) NULL,
	[Name] [nvarchar](128) NULL,
	[ObjectCategory] [nvarchar](128) NULL,
	[ObjectClass] [nvarchar](64) NULL,
	[ProtectedFromAccidentalDeletion] [bit] NULL,
	[SamAccountName] [nvarchar](128) NULL,
	[sAMAccountType] [int] NULL,
	[sDRightsEffective] [int] NULL,
	[WhenChanged] [datetime2](7) NULL,
	[WhenCreated] [datetime2](7) NULL,
	[Mail] [nvarchar](256) NULL,
	[MailNickName] [nvarchar](128) NULL,
	[LegacyExchangeDN] [nvarchar](256) NULL,
	[msExchRoleGroupType] [nvarchar](64) NULL,
	[msExchGroupExternalMemberCount] [nvarchar](64) NULL,
	[msExchGroupMemberCount] [nvarchar](64) NULL,
	[msExchRecipientDisplayType] [nvarchar](64) NULL,
	[ProxyAddresses] [nvarchar](2048) NULL,
	[ManagedBy] [nvarchar](1024) NULL,
	[Members] [nvarchar](max) NULL,
	[MemberOf] [nvarchar](max) NULL,
	[SID] [nvarchar](64) NULL,
	[SIDHistory] [nvarchar](512) NULL,
	[ObjectGUID] [nvarchar](36) NULL,
	[ShowInAddressBook] [nvarchar](1024) NULL,
	[msExchCoManagedByLink] [nvarchar](1024) NULL,
	[DomainName] [nvarchar](64) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingCheck4Workday]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingCheck4Workday](
	[SourcesamAccountname] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingComputerToUserMapping]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingComputerToUserMapping](
	[AssetName] [nvarchar](64) NULL,
	[Username] [nvarchar](32) NULL,
	[email] [nvarchar](128) NULL,
	[OSname] [nvarchar](64) NULL,
	[Version] [nvarchar](64) NULL,
	[OScode] [nvarchar](32) NULL,
	[Manufacturer] [nvarchar](128) NULL,
	[Model] [nvarchar](64) NULL,
	[Mobile] [nvarchar](32) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingContact]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingContact](
	[SourceOrganization] [nvarchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingDualUsers]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingDualUsers](
	[User ID] [nvarchar](64) NULL,
	[Name] [nvarchar](64) NULL,
	[Email] [nvarchar](128) NULL,
	[Active] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingEmployeeIDEmail]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingEmployeeIDEmail](
	[EmployeeID] [nvarchar](8) NULL,
	[EmailAddress] [nvarchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingExistingRewrite]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingExistingRewrite](
	[ExternalDirectoryObjectID] [nchar](36) NULL,
	[ExchangeObjectId] [nchar](36) NULL,
	[Alias] [nvarchar](64) NULL,
	[PrimarySmtpAddress] [nvarchar](128) NULL,
	[ExternalEmailAddress] [nvarchar](256) NULL,
	[RecipientTypeDetails] [nvarchar](64) NULL,
	[EmailAddresses] [nvarchar](4000) NULL,
	[Address] [nvarchar](128) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingFinanceUsers]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingFinanceUsers](
	[Login] [nvarchar](max) NULL,
	[DisplayName] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingFlyMapping]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingFlyMapping](
	[Source] [nvarchar](128) NULL,
	[Destination] [nvarchar](128) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingMailboxStats]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingMailboxStats](
	[SourceOrganization] [nvarchar](64) NULL,
	[MailboxGuid] [nchar](36) NULL,
	[TotalItemSizeInGB] [nvarchar](10) NULL,
	[TotalDeletedItemSizeInGB] [nvarchar](10) NULL,
	[ItemCount] [int] NULL,
	[DeletedItemCount] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingMailUsers]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingMailUsers](
	[ExchangeGuid] [nvarchar](36) NULL,
	[ExternalEmailAddress] [nvarchar](128) NULL,
	[PrimarySmtpAddress] [nvarchar](128) NULL,
	[WindowsEmailAddress] [nvarchar](128) NULL,
	[DisplayName] [nvarchar](256) NULL,
	[RecipientType] [nvarchar](32) NULL,
	[RecipientTypeDetails] [nvarchar](32) NULL,
	[EmailAddressPolicyEnabled] [bit] NULL,
	[Alias] [nvarchar](64) NULL,
	[SamAccountName] [nvarchar](20) NULL,
	[UserPrincipalName] [nvarchar](128) NULL,
	[EmailAddresses] [nvarchar](2048) NULL,
	[ObjectGUID] [nchar](36) NULL,
	[OrganizationalUnit] [nvarchar](512) NULL,
	[Identity] [nvarchar](512) NULL,
	[Organization] [nvarchar](32) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingMatches]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingMatches](
	[WDEmployeeID] [nvarchar](10) NULL,
	[SourceMail] [nvarchar](128) NULL,
	[TargetMail] [nvarchar](128) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingMigrationGroupMember]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingMigrationGroupMember](
	[id] [nvarchar](36) NULL,
	[mail] [nvarchar](128) NULL,
	[userPrincipalName] [nvarchar](128) NULL,
	[GroupID] [nvarchar](36) NULL,
	[Role] [nvarchar](32) NULL,
	[TenantDomain] [nvarchar](128) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingSPOUserMigrationListIDs]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingSPOUserMigrationListIDs](
	[ID] [int] NULL,
	[SourceEntraID] [nvarchar](36) NULL,
	[SourceADID] [nvarchar](36) NULL,
	[MigrationStatus] [nvarchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingUGDrive]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingUGDrive](
	[GroupID] [nvarchar](36) NULL,
	[displayName] [nvarchar](256) NULL,
	[mail] [nvarchar](128) NULL,
	[mailNickname] [nvarchar](64) NULL,
	[DriveName] [nvarchar](32) NULL,
	[DriveURL] [nvarchar](256) NULL,
	[DriveID] [nvarchar](128) NULL,
	[driveType] [nvarchar](32) NULL,
	[SiteURL] [nvarchar](256) NULL,
	[createdDateTime] [datetime2](7) NULL,
	[lastModifiedDateTime] [datetime2](7) NULL,
	[quotaTotal] [float] NULL,
	[quotaUsed] [float] NULL,
	[quotaRemaining] [float] NULL,
	[quotaDeleted] [float] NULL,
	[quotaState] [nvarchar](32) NULL,
	[TenantDomain] [nvarchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingUGRoleHolder]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingUGRoleHolder](
	[GroupID] [nvarchar](36) NULL,
	[GroupDisplayName] [nvarchar](256) NULL,
	[GroupMail] [nvarchar](128) NULL,
	[Role] [nvarchar](6) NULL,
	[UserID] [nvarchar](36) NULL,
	[UserDisplayName] [nvarchar](256) NULL,
	[UserMail] [nvarchar](128) NULL,
	[UserPrincipalName] [nvarchar](128) NULL,
	[UserType] [nvarchar](10) NULL,
	[TenantDomain] [nvarchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingUserLicensing]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingUserLicensing](
	[ID] [nvarchar](36) NULL,
	[UserPrincipalName] [nvarchar](128) NULL,
	[Mail] [nvarchar](128) NULL,
	[UsageLocation] [nvarchar](2) NULL,
	[LicenseSource] [nvarchar](1024) NULL,
	[LicenseIDs] [nvarchar](128) NULL,
	[LicenseNames] [nvarchar](128) NULL,
	[ServicePlanIDs] [nvarchar](1024) NULL,
	[ServicePlanNames] [nvarchar](1024) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingUserRegistrationDetail]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingUserRegistrationDetail](
	[id] [nvarchar](36) NULL,
	[userPrincipalName] [nvarchar](128) NULL,
	[userType] [nvarchar](32) NULL,
	[isAdmin] [bit] NULL,
	[isSsprRegistered] [bit] NULL,
	[isSsprEnabled] [bit] NULL,
	[isSsprCapable] [bit] NULL,
	[isMfaRegistered] [bit] NULL,
	[isMfaCapable] [bit] NULL,
	[isPasswordlessCapable] [bit] NULL,
	[methodsRegistered] [nvarchar](256) NULL,
	[isSystemPreferredAuthenticationMethodEnabled] [bit] NULL,
	[systemPreferredAuthenticationMethods] [nvarchar](256) NULL,
	[userPreferredMethodForSecondaryAuthentication] [nvarchar](128) NULL,
	[TenantDomain] [nvarchar](128) NULL,
	[lastUpdatedDateTime] [datetime2](7) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WavePlan]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WavePlan](
	[WaveGroup] [int] NULL,
	[SubWave] [int] NULL,
	[Wave] [int] NULL,
	[Name] [nvarchar](64) NULL,
	[TargetDate] [datetime2](7) NULL,
	[T-1] [datetime2](7) NULL,
	[T] [datetime2](7) NULL,
	[T+1] [datetime2](7) NULL,
	[SyncInitiated] [bit] NULL,
	[MigrationCompleted] [bit] NULL,
	[FlyOneDrive] [nvarchar](50) NULL,
	[FlyTeamsChat] [nvarchar](50) NULL,
	[FlyExchange] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WOA]    Script Date: 12/2/2024 3:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WOA](
	[Name] [nvarchar](max) NULL,
	[PrimarySMTPAddress] [nvarchar](max) NULL,
	[EntraID] [nvarchar](max) NULL,
	[RecipientTypeDetails] [nvarchar](max) NULL,
	[ChangeWave] [bit] NULL,
	[CurrentWave] [float] NULL,
	[RecommendedWave] [float] NULL,
	[NotAssigned] [nvarchar](max) NULL,
	[0.1] [nvarchar](max) NULL,
	[0.2] [nvarchar](max) NULL,
	[0.3] [nvarchar](max) NULL,
	[0.4] [nvarchar](max) NULL,
	[0.5] [nvarchar](max) NULL,
	[1] [nvarchar](max) NULL,
	[2] [nvarchar](max) NULL,
	[3] [nvarchar](max) NULL,
	[4] [int] NULL,
	[5] [nvarchar](max) NULL,
	[6] [nvarchar](max) NULL,
	[7] [nvarchar](max) NULL,
	[8] [nvarchar](max) NULL,
	[9] [nvarchar](max) NULL,
	[10] [int] NULL,
	[11] [nvarchar](max) NULL,
	[12] [nvarchar](max) NULL,
	[13] [nvarchar](max) NULL,
	[14] [nvarchar](max) NULL,
	[91] [nvarchar](max) NULL,
	[92] [nvarchar](max) NULL,
	[93] [nvarchar](max) NULL,
	[95] [nvarchar](max) NULL,
	[99] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
