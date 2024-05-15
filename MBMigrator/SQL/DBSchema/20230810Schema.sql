USE [master]
GO
/****** Object:  Database [MBMigrator]    Script Date: 8/10/2023 11:31:26 AM ******/
CREATE DATABASE [MBMigrator]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MBMigrator', FILENAME = N'F:\Database\MBMigrator.mdf' , SIZE = 598016KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MBMigrator_log', FILENAME = N'F:\Database\MBMigrator.ldf' , SIZE = 598016KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [MBMigrator] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MBMigrator].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MBMigrator] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MBMigrator] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MBMigrator] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MBMigrator] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MBMigrator] SET ARITHABORT OFF 
GO
ALTER DATABASE [MBMigrator] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MBMigrator] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MBMigrator] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MBMigrator] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MBMigrator] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MBMigrator] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MBMigrator] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MBMigrator] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MBMigrator] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MBMigrator] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MBMigrator] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MBMigrator] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MBMigrator] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MBMigrator] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MBMigrator] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MBMigrator] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MBMigrator] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MBMigrator] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MBMigrator] SET  MULTI_USER 
GO
ALTER DATABASE [MBMigrator] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MBMigrator] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MBMigrator] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MBMigrator] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MBMigrator] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MBMigrator] SET QUERY_STORE = OFF
GO
USE [MBMigrator]
GO
/****** Object:  Table [dbo].[stagingPermissions]    Script Date: 8/10/2023 11:31:26 AM ******/
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
SET ANSI_PADDING ON
GO
/****** Object:  Index [ClusteredIndex-20230709-220856]    Script Date: 8/10/2023 11:31:26 AM ******/
CREATE CLUSTERED INDEX [ClusteredIndex-20230709-220856] ON [dbo].[stagingPermissions]
(
	[PermissionType] ASC,
	[TargetExchangeGUID] ASC,
	[TrusteeExchangeGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[configurationOrganization]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[configurationOrganization](
	[Name] [nvarchar](64) NULL,
	[MigrationRole] [nvarchar](64) NULL,
	[Credential] [nvarchar](1024) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewOnPremisesAutoMappings]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[viewOnPremisesAutoMappings]
AS
SELECT PermissionIdentity, ParentPermissionIdentity, SourceExchangeOrganization, TargetRecipientType, TargetRecipientTypeDetails, TrusteeRecipientType, TrusteeRecipientTypeDetails, TargetFolderType, PermissionType, AssignmentType, 
                  TargetPrimarySMTPAddress, TargetAlias, TrusteePrimarySMTPAddress, TrusteeAlias, TrusteeIdentity, TargetDistinguishedName, TrusteeDistinguishedName, TargetFolderPath, FolderAccessRights, TargetObjectGUID, 
                  TargetExchangeGUID, TrusteeGroupObjectGUID, TrusteeObjectGUID, TrusteeExchangeGUID, IsInherited, IsAutoMapped
FROM     dbo.stagingPermissions
WHERE  (SourceExchangeOrganization =
                      (SELECT EXOPOrganizationIdentity
                       FROM      dbo.configurationOrganization)) AND (PermissionType = 'AutoMapping')
GO
/****** Object:  View [dbo].[viewOnlineAutoMappings]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[viewOnlineAutoMappings]
AS
SELECT PermissionIdentity, ParentPermissionIdentity, SourceExchangeOrganization, TargetRecipientType, TargetRecipientTypeDetails, TrusteeRecipientType, TrusteeRecipientTypeDetails, TargetFolderType, PermissionType, AssignmentType, 
                  TargetPrimarySMTPAddress, TargetAlias, TrusteePrimarySMTPAddress, TrusteeAlias, TrusteeIdentity, TargetDistinguishedName, TrusteeDistinguishedName, TargetFolderPath, FolderAccessRights, TargetObjectGUID, 
                  TargetExchangeGUID, TrusteeGroupObjectGUID, TrusteeObjectGUID, TrusteeExchangeGUID, IsInherited, IsAutoMapped
FROM     dbo.stagingPermissions
WHERE  (SourceExchangeOrganization =
                      (SELECT EXOLOrganizationIdentity
                       FROM      dbo.configurationOrganization)) AND (PermissionType = 'AutoMapping')
GO
/****** Object:  View [dbo].[viewRelatedAutoMappings]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewRelatedAutoMappings]
AS
SELECT dbo.viewOnlineAutoMappings.TrusteeExchangeGUID AS OnlineTrustee, dbo.viewOnlineAutoMappings.TargetExchangeGUID AS OnlineTarget, dbo.viewOnPremisesAutoMappings.TrusteeExchangeGUID AS OnPremTrustee, 
                  dbo.viewOnPremisesAutoMappings.TargetExchangeGUID AS OnPremTarget
FROM     dbo.viewOnlineAutoMappings FULL OUTER JOIN
                  dbo.viewOnPremisesAutoMappings ON dbo.viewOnlineAutoMappings.TrusteeExchangeGUID = dbo.viewOnPremisesAutoMappings.TrusteeExchangeGUID AND 
                  dbo.viewOnlineAutoMappings.TargetExchangeGUID = dbo.viewOnPremisesAutoMappings.TargetExchangeGUID
GO
/****** Object:  View [dbo].[viewOnlineFullAccess]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewOnlineFullAccess]
AS
SELECT PermissionIdentity, ParentPermissionIdentity, SourceExchangeOrganization, TargetRecipientType, TargetRecipientTypeDetails, TrusteeRecipientType, TrusteeRecipientTypeDetails, TargetFolderType, PermissionType, AssignmentType, 
                  TargetPrimarySMTPAddress, TargetAlias, TrusteePrimarySMTPAddress, TrusteeAlias, TrusteeIdentity, TargetDistinguishedName, TrusteeDistinguishedName, TargetFolderPath, FolderAccessRights, TargetObjectGUID, 
                  TargetExchangeGUID, TrusteeGroupObjectGUID, TrusteeObjectGUID, TrusteeExchangeGUID, IsInherited, IsAutoMapped
FROM     dbo.stagingPermissions
WHERE  (SourceExchangeOrganization =
                      (SELECT EXOLOrganizationIdentity
                       FROM      dbo.configurationOrganization)) AND (PermissionType = 'FullAccess')
GO
/****** Object:  View [dbo].[viewOnPremisesFullAccess]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewOnPremisesFullAccess]
AS
SELECT PermissionIdentity, ParentPermissionIdentity, SourceExchangeOrganization, TargetRecipientType, TargetRecipientTypeDetails, TrusteeRecipientType, TrusteeRecipientTypeDetails, TargetFolderType, PermissionType, AssignmentType, 
                  TargetPrimarySMTPAddress, TargetAlias, TrusteePrimarySMTPAddress, TrusteeAlias, TrusteeIdentity, TargetDistinguishedName, TrusteeDistinguishedName, TargetFolderPath, FolderAccessRights, TargetObjectGUID, 
                  TargetExchangeGUID, TrusteeGroupObjectGUID, TrusteeObjectGUID, TrusteeExchangeGUID, IsInherited, IsAutoMapped
FROM     dbo.stagingPermissions
WHERE  (SourceExchangeOrganization =
                      (SELECT EXOPOrganizationIdentity
                       FROM      dbo.configurationOrganization)) AND (PermissionType = 'FullAccess')
GO
/****** Object:  View [dbo].[viewRelatedFullAccess]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewRelatedFullAccess]
AS
SELECT OFA.TrusteeExchangeGUID AS OnlineTrustee, OFA.TargetExchangeGUID AS OnlineTarget, PFA.TrusteeExchangeGUID AS OnPremTrustee, PFA.TargetExchangeGUID AS OnPremTarget
FROM     dbo.viewOnlineFullAccess AS OFA FULL OUTER JOIN
                  dbo.viewOnPremisesFullAccess AS PFA ON OFA.TrusteeExchangeGUID = PFA.TrusteeExchangeGUID AND OFA.TargetExchangeGUID = PFA.TargetExchangeGUID
GO
/****** Object:  Table [dbo].[WaveAssignments]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WaveAssignments](
	[Name] [nvarchar](256) NULL,
	[DescriptionFromAD] [nvarchar](256) NULL,
	[BetterDescription] [nvarchar](256) NULL,
	[Notes] [nvarchar](256) NULL,
	[MailboxCount] [float] NULL,
	[AssignedWave] [nvarchar](64) NULL,
	[TargetDate] [nvarchar](256) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WaveGroupMemberships]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WaveGroupMemberships](
	[distinguishedName] [nvarchar](1024) NULL,
	[name] [nvarchar](256) NULL,
	[objectClass] [nvarchar](64) NULL,
	[objectGUID] [nvarchar](36) NULL,
	[SamAccountName] [nvarchar](64) NULL,
	[SID] [nvarchar](256) NULL,
	[GroupName] [nvarchar](256) NULL,
	[GroupDescription] [nvarchar](1024) NULL,
	[GroupAdminDescription] [nvarchar](1024) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewWaveGroupSingleMembership]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*HAVING     (COUNT(GroupName) = 1)*/
CREATE VIEW [dbo].[viewWaveGroupSingleMembership]
AS
SELECT     distinguishedName, COUNT(GroupName) AS GroupCount
FROM        dbo.WaveGroupMemberships
WHERE     (GroupName IN
                      (SELECT     Name
                       FROM        dbo.WaveAssignments))
GROUP BY distinguishedName
HAVING     (COUNT(GroupName) = 1)
GO
/****** Object:  View [dbo].[viewWaveGroupMembershipsAssigned]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewWaveGroupMembershipsAssigned]
AS
SELECT     distinguishedName, GroupName
FROM        dbo.WaveGroupMemberships
WHERE     (GroupName IN
                      (SELECT     Name
                       FROM        dbo.WaveAssignments)) AND (distinguishedName IN
                      (SELECT     distinguishedName
                       FROM        dbo.viewWaveGroupSingleMembership))
GO
/****** Object:  Table [dbo].[WOA]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WOA](
	[Name] [nvarchar](max) NULL,
	[PrimarySMTPAddress] [nvarchar](max) NULL,
	[ExchangeGUID] [nvarchar](max) NULL,
	[RecipientTypeDetails] [nvarchar](max) NULL,
	[ChangeWave] [bit] NULL,
	[CurrentWave] [nvarchar](max) NULL,
	[RecommendedWave] [float] NULL,
	[NotAssigned] [int] NULL,
	[0.1] [nvarchar](max) NULL,
	[0.2] [nvarchar](max) NULL,
	[0.3] [nvarchar](max) NULL,
	[1.1] [nvarchar](max) NULL,
	[1.2] [nvarchar](max) NULL,
	[2.1] [nvarchar](max) NULL,
	[2.2] [nvarchar](max) NULL,
	[4.1] [nvarchar](max) NULL,
	[4.2] [int] NULL,
	[5.1] [nvarchar](max) NULL,
	[5.2] [nvarchar](max) NULL,
	[6.1] [nvarchar](max) NULL,
	[6.2] [nvarchar](max) NULL,
	[7.1] [nvarchar](max) NULL,
	[7.2] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingADUser]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingADUser](
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
	[countryCode] [nvarchar](3) NULL,
	[Enabled] [bit] NULL,
	[LastLogonDate] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ClusteredIndex-20230725-173538]    Script Date: 8/10/2023 11:31:26 AM ******/
CREATE CLUSTERED INDEX [ClusteredIndex-20230725-173538] ON [dbo].[stagingADUser]
(
	[msExchMailboxGUID] ASC,
	[UserPrincipalName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingUserLicensing]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingUserLicensing](
	[ID] [nvarchar](36) NULL,
	[UserPrincipalName] [nvarchar](256) NULL,
	[Mail] [nvarchar](256) NULL,
	[UsageLocation] [nvarchar](64) NULL,
	[LicenseIDs] [nvarchar](1024) NULL,
	[LicenseNames] [nvarchar](max) NULL,
	[ServicePlanIDs] [nvarchar](1024) NULL,
	[ServicePlanNames] [nvarchar](1024) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ClusteredIndex-20230725-173455]    Script Date: 8/10/2023 11:31:26 AM ******/
CREATE CLUSTERED INDEX [ClusteredIndex-20230725-173455] ON [dbo].[stagingUserLicensing]
(
	[ID] ASC,
	[UserPrincipalName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingUserMobileDevice]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingUserMobileDevice](
	[UserExchangeGUID] [nvarchar](36) NULL,
	[FirstSyncTime] [datetime2](7) NULL,
	[LastPolicyUpdateTime] [datetime2](7) NULL,
	[LastSyncAttemptTime] [datetime2](7) NULL,
	[LastSuccessSync] [datetime2](7) NULL,
	[DeviceType] [nvarchar](128) NULL,
	[DeviceID] [nvarchar](128) NULL,
	[DeviceUserAgent] [nvarchar](128) NULL,
	[DeviceWipeSentTime] [datetime2](7) NULL,
	[DeviceWipeRequestTime] [datetime2](7) NULL,
	[DeviceWipeAckTime] [datetime2](7) NULL,
	[AccountOnlyDeviceWipeSentTime] [datetime2](7) NULL,
	[AccountOnlyDeviceWipeRequestTime] [datetime2](7) NULL,
	[AccountOnlyDeviceWipeAckTime] [datetime2](7) NULL,
	[LastPingHeartbeat] [nvarchar](128) NULL,
	[RecoveryPassword] [nvarchar](128) NULL,
	[DeviceModel] [nvarchar](128) NULL,
	[DeviceImei] [nvarchar](128) NULL,
	[DeviceFriendlyName] [nvarchar](512) NULL,
	[DeviceOS] [nvarchar](128) NULL,
	[DeviceOSLanguage] [nvarchar](128) NULL,
	[DevicePhoneNumber] [nvarchar](64) NULL,
	[MailboxLogReport] [nvarchar](1024) NULL,
	[DeviceEnableOutboundSMS] [bit] NULL,
	[DeviceMobileOperator] [nvarchar](128) NULL,
	[Identity] [nvarchar](2048) NULL,
	[Guid] [uniqueidentifier] NULL,
	[IsRemoteWipeSupported] [bit] NULL,
	[Status] [nvarchar](128) NULL,
	[StatusNote] [nvarchar](128) NULL,
	[DeviceAccessState] [nvarchar](128) NULL,
	[DeviceAccessStateReason] [nvarchar](128) NULL,
	[DeviceAccessControlRule] [nvarchar](128) NULL,
	[DevicePolicyApplied] [nvarchar](128) NULL,
	[DevicePolicyApplicationStatus] [nvarchar](128) NULL,
	[LastDeviceWipeRequestor] [nvarchar](128) NULL,
	[LastAccountOnlyDeviceWipeRequestor] [nvarchar](128) NULL,
	[ClientVersion] [nvarchar](128) NULL,
	[NumberOfFoldersSynced] [int] NULL,
	[SyncStateUpgradeTime] [datetime2](7) NULL,
	[ClientType] [nvarchar](128) NULL,
	[IsValid] [bit] NULL,
	[ObjectState] [nvarchar](128) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingCASMailbox]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingCASMailbox](
	[ActiveSyncDebugLogging] [bit] NULL,
	[ActiveSyncEnabled] [bit] NULL,
	[ActiveSyncMailboxPolicy] [nvarchar](256) NULL,
	[ActiveSyncMailboxPolicyIsDefaulted] [bit] NULL,
	[ActiveSyncSuppressReadReceipt] [bit] NULL,
	[DisplayName] [nvarchar](256) NULL,
	[DistinguishedName] [nvarchar](1024) NULL,
	[ECPEnabled] [bit] NULL,
	[EwsAllowEntourage] [nvarchar](128) NULL,
	[EwsAllowMacOutlook] [nvarchar](128) NULL,
	[EwsAllowOutlook] [nvarchar](128) NULL,
	[EwsApplicationAccessPolicy] [nvarchar](128) NULL,
	[EwsEnabled] [nvarchar](64) NULL,
	[Guid] [uniqueidentifier] NULL,
	[HasActiveSyncDevicePartnership] [bit] NULL,
	[Identity] [nvarchar](1024) NULL,
	[ImapEnabled] [bit] NULL,
	[ImapEnableExactRFC822Size] [bit] NULL,
	[ImapForceICalForCalendarRetrievalOption] [bit] NULL,
	[ImapMessagesRetrievalMimeFormat] [nvarchar](256) NULL,
	[ImapSuppressReadReceipt] [bit] NULL,
	[ImapUseProtocolDefaults] [bit] NULL,
	[IsOptimizedForAccessibility] [bit] NULL,
	[IsValid] [bit] NULL,
	[LegacyExchangeDN] [nvarchar](256) NULL,
	[LinkedMasterAccount] [nvarchar](256) NULL,
	[MAPIBlockOutlookExternalConnectivity] [bit] NULL,
	[MAPIBlockOutlookNonCachedMode] [bit] NULL,
	[MAPIBlockOutlookRpcHttp] [bit] NULL,
	[MAPIBlockOutlookVersions] [nvarchar](256) NULL,
	[MAPIEnabled] [bit] NULL,
	[MapiHttpEnabled] [nvarchar](64) NULL,
	[Name] [nvarchar](256) NULL,
	[ObjectCategory] [nvarchar](512) NULL,
	[ObjectState] [nvarchar](64) NULL,
	[OrganizationId] [nvarchar](256) NULL,
	[OriginatingServer] [nvarchar](256) NULL,
	[OWAEnabled] [bit] NULL,
	[OWAforDevicesEnabled] [bit] NULL,
	[OwaMailboxPolicy] [nvarchar](256) NULL,
	[PopEnabled] [bit] NULL,
	[PopEnableExactRFC822Size] [bit] NULL,
	[PopForceICalForCalendarRetrievalOption] [bit] NULL,
	[PopMessageDeleteEnabled] [bit] NULL,
	[PopMessagesRetrievalMimeFormat] [nvarchar](256) NULL,
	[PopSuppressReadReceipt] [bit] NULL,
	[PopUseProtocolDefaults] [bit] NULL,
	[PrimarySmtpAddress] [nvarchar](256) NULL,
	[PublicFolderClientAccess] [bit] NULL,
	[SamAccountName] [nvarchar](64) NULL,
	[ServerLegacyDN] [nvarchar](256) NULL,
	[ServerName] [nvarchar](256) NULL,
	[ShowGalAsDefaultView] [bit] NULL,
	[UniversalOutlookEnabled] [bit] NULL,
	[WhenChanged] [datetime2](7) NULL,
	[WhenChangedUTC] [datetime2](7) NULL,
	[WhenCreated] [datetime2](7) NULL,
	[WhenCreatedUTC] [datetime2](7) NULL,
	[ActiveSyncAllowedDeviceIDs] [nvarchar](1024) NULL,
	[ActiveSyncBlockedDeviceIDs] [nvarchar](1024) NULL,
	[EwsBlockList] [nvarchar](1024) NULL,
	[EwsAllowList] [nvarchar](1024) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ClusteredIndex-20230726-122104]    Script Date: 8/10/2023 11:31:26 AM ******/
CREATE CLUSTERED INDEX [ClusteredIndex-20230726-122104] ON [dbo].[stagingCASMailbox]
(
	[Guid] ASC,
	[PrimarySmtpAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingDistributionGroupOwnership]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingDistributionGroupOwnership](
	[DisplayName] [nvarchar](256) NULL,
	[Name] [nvarchar](256) NULL,
	[Alias] [nvarchar](64) NULL,
	[Mail] [nvarchar](256) NULL,
	[ExchangeGUID] [nvarchar](36) NULL,
	[GroupCount] [int] NULL,
	[Groups] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ClusteredIndex-20230726-155342]    Script Date: 8/10/2023 11:31:26 AM ******/
CREATE CLUSTERED INDEX [ClusteredIndex-20230726-155342] ON [dbo].[stagingDistributionGroupOwnership]
(
	[ExchangeGUID] ASC,
	[Mail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingMailbox]    Script Date: 8/10/2023 11:31:26 AM ******/
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
SET ANSI_PADDING ON
GO
/****** Object:  Index [ClusteredIndex-20230707-140115]    Script Date: 8/10/2023 11:31:26 AM ******/
CREATE CLUSTERED INDEX [ClusteredIndex-20230707-140115] ON [dbo].[stagingMailbox]
(
	[ExchangeGuid] ASC,
	[PrimarySmtpAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingMailboxStats]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingMailboxStats](
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
/****** Object:  View [dbo].[stagingMailboxOL]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[stagingMailboxOL]
AS
SELECT SourceOrganization, ExchangeGuid, ExchangeObjectId, ExternalDirectoryObjectID, ArchiveGuid, Guid, Alias, SamAccountName, DisplayName, Name, PrimarySmtpAddress, UserPrincipalName, RemoteRoutingAddress, TargetAddress, 
                  ForwardingAddress, ForwardingSmtpAddress, LegacyExchangeDN, RecipientType, RecipientTypeDetails, RemoteRecipientType, LinkedMasterAccount, CustomAttribute1, CustomAttribute2, CustomAttribute3, CustomAttribute4, 
                  CustomAttribute5, CustomAttribute6, CustomAttribute7, CustomAttribute8, CustomAttribute9, CustomAttribute10, CustomAttribute11, CustomAttribute12, CustomAttribute13, CustomAttribute14, CustomAttribute15, 
                  ExtensionCustomAttribute1, ExtensionCustomAttribute2, ExtensionCustomAttribute3, ExtensionCustomAttribute4, ExtensionCustomAttribute5, Department, Office, OrganizationalUnit, [Database], ArchiveName, ArchiveDomain, 
                  ArchiveStatus, ArchiveState, RetentionPolicy, RetainDeletedItemsFor, ManagedFolderMailboxPolicy, AddressBookPolicy, RoleAssignmentPolicy, SharingPolicy, DefaultPublicFolderMailbox, RecipientLimits, ResourceCapacity, 
                  DistinguishedName, WhenCreatedUTC, WhenChangedUTC, EmailAddresses, UseDatabaseRetentionDefaults, UseDatabaseQuotaDefaults, LitigationHoldEnabled, SingleItemRecoveryEnabled, RetentionHoldEnabled, BccBlocked, 
                  AutoExpandingArchiveEnabled, HiddenFromAddressListsEnabled, EmailAddressPolicyEnabled, MessageCopyForSentAsEnabled, MessageCopyForSendOnBehalfEnabled, DeliverToMailboxAndForward, 
                  MessageTrackingReadStatusEnabled, DowngradeHighPriorityMessagesEnabled, UMEnabled, IsAuxMailbox, CalendarVersionStoreDisabled, SKUAssigned, AuditEnabled, ArchiveQuotaInGB, ArchiveWarningQuotaInGB, 
                  CalendarLoggingQuotaInGB, IssueWarningQuotaInGB, ProhibitSendQuotaInGB, ProhibitSendReceiveQuotaInGB, RecoverableItemsQuotaInGB, RecoverableItemsWarningQuotaInGB, RulesQuotaInKB, MaxSendSizeInMB, 
                  MaxReceiveSizeInMB
FROM     dbo.stagingMailbox
WHERE  (SourceOrganization = N'OL')
GO
/****** Object:  Table [dbo].[stagingRecipient]    Script Date: 8/10/2023 11:31:26 AM ******/
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
SET ANSI_PADDING ON
GO
/****** Object:  Index [ClusteredIndex-20230518-142639]    Script Date: 8/10/2023 11:31:26 AM ******/
CREATE CLUSTERED INDEX [ClusteredIndex-20230518-142639] ON [dbo].[stagingRecipient]
(
	[ExchangeGuid] ASC,
	[PrimarySmtpAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  View [dbo].[stagingRecipientOP]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[stagingRecipientOP]
AS
SELECT   SourceOrganization, ExchangeGuid, ExchangeObjectId, ExternalDirectoryObjectID, ArchiveGuid, Guid, Alias, DisplayName, PrimarySmtpAddress, ExternalEmailAddress, RecipientType, RecipientTypeDetails, CustomAttribute1, CustomAttribute2, CustomAttribute3, CustomAttribute4, CustomAttribute5, CustomAttribute6, 
             CustomAttribute7, CustomAttribute8, CustomAttribute9, CustomAttribute10, CustomAttribute11, CustomAttribute12, CustomAttribute13, CustomAttribute14, CustomAttribute15, ExtensionCustomAttribute1, ExtensionCustomAttribute2, ExtensionCustomAttribute3, ExtensionCustomAttribute4, ExtensionCustomAttribute5, Department, 
             Company, Office, City, DistinguishedName, Manager, WhenCreatedUTC, WhenChangedUTC, EmailAddresses, ArchiveStatus, ArchiveState
FROM     dbo.stagingRecipient
WHERE   (SourceOrganization = N'OP')
GO
/****** Object:  View [dbo].[viewMailboxList]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*AND dbo.stagingMailbox.RecipientTypeDetails = 'RemoteUserMailbox'*/
CREATE VIEW [dbo].[viewMailboxList]
AS
SELECT     dbo.stagingMailbox.Alias, dbo.stagingMailboxStats.TotalItemSizeInGB, dbo.stagingMailboxStats.TotalDeletedItemSizeInGB, dbo.stagingMailboxStats.MessageTableTotalSizeInGB, dbo.stagingMailboxStats.AttachmentTableTotalSizeInGB, 
                  dbo.stagingMailboxStats.ItemCount, dbo.stagingMailboxStats.DeletedItemCount, dbo.stagingMailbox.ExchangeGuid, dbo.stagingMailbox.Name, dbo.stagingMailbox.DisplayName, dbo.stagingMailbox.PrimarySmtpAddress, dbo.stagingMailbox.UserPrincipalName, 
                  dbo.stagingMailbox.TargetAddress, dbo.stagingMailbox.RemoteRoutingAddress, dbo.stagingMailbox.RecipientTypeDetails, dbo.stagingMailbox.RemoteRecipientType, dbo.stagingMailbox.WhenCreatedUTC, dbo.stagingMailbox.EmailAddresses, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.ArchiveName ELSE dbo.stagingMailbox.ArchiveName END AS ArchiveName, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.ArchiveDomain ELSE dbo.stagingMailbox.ArchiveDomain END AS ArchiveDomain, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.ArchiveStatus ELSE dbo.stagingMailbox.ArchiveStatus END AS ArchiveStatus, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.ArchiveState ELSE dbo.stagingMailbox.ArchiveState END AS ArchiveState, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.RetentionPolicy ELSE dbo.stagingMailbox.RetentionPolicy END AS RetentionPolicy, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.RetainDeletedItemsFor ELSE dbo.stagingMailbox.RetainDeletedItemsFor END AS RetainDeletedItemsFor, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.LitigationHoldEnabled ELSE dbo.stagingMailbox.LitigationHoldEnabled END AS LitigationHoldEnabled, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.SingleItemRecoveryEnabled ELSE dbo.stagingMailbox.SingleItemRecoveryEnabled END AS SingleItemRecoveryEnabled, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.ArchiveQuotaInGB ELSE dbo.stagingMailbox.ArchiveQuotaInGB END AS ArchiveQuotaInGB, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.ArchiveWarningQuotaInGB ELSE dbo.stagingMailbox.ArchiveWarningQuotaInGB END AS ArchiveWarningQuotaInGB, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.IssueWarningQuotaInGB ELSE dbo.stagingMailbox.IssueWarningQuotaInGB END AS IssueWarningQuotaInGB, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.CalendarLoggingQuotaInGB ELSE dbo.stagingMailbox.CalendarLoggingQuotaInGB END AS CalendarLoggingQuotaInGB, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.ProhibitSendQuotaInGB ELSE dbo.stagingMailbox.ProhibitSendQuotaInGB END AS ProhibitSendQuotaInGB, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.ProhibitSendReceiveQuotaInGB ELSE dbo.stagingMailbox.ProhibitSendReceiveQuotaInGB END AS ProhibitSendReceiveQuotaInGB, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.RecoverableItemsWarningQuotaInGB ELSE dbo.stagingMailbox.RecoverableItemsWarningQuotaInGB END AS RecoverableItemsWarningQuotaInGB, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.RulesQuotaInKB ELSE dbo.stagingMailbox.RulesQuotaInKB END AS RulesQuotaInKB, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.MaxReceiveSizeInMB ELSE dbo.stagingMailbox.MaxReceiveSizeInMB END AS MaxReceiveSizeInMB, 
                  CASE dbo.stagingMailbox.RecipientType WHEN 'MailUser' THEN dbo.stagingMailboxOL.MaxSendSizeInMB ELSE dbo.stagingMailbox.MaxSendSizeInMB END AS MaxSendSizeInMB, dbo.stagingMailbox.OrganizationalUnit, dbo.stagingMailbox.DistinguishedName, 
                  dbo.viewWaveGroupMembershipsAssigned.GroupName, dbo.stagingRecipientOP.Department, dbo.stagingADUser.Division, dbo.stagingRecipientOP.Company, dbo.stagingRecipientOP.Office, dbo.stagingRecipientOP.City, dbo.stagingADUser.countryCode, 
                  dbo.stagingADUser.Country, dbo.stagingRecipientOP.Manager, dbo.stagingADUser.employeeID, dbo.stagingADUser.employeeType, dbo.stagingADUser.Enabled, dbo.stagingUserLicensing.LicenseNames, dbo.stagingUserLicensing.ServicePlanNames, 
                  dbo.stagingADUser.LastLogonDate, dbo.stagingUserMobileDevice.DeviceType AS MobileDeviceType, dbo.stagingUserMobileDevice.DeviceOS AS MobileDeviceOS, dbo.stagingUserMobileDevice.LastSuccessSync AS MobileLastSuccessSync, 
                  dbo.stagingUserMobileDevice.DeviceAccessState AS MobileDeviceAccessState, dbo.stagingCASMailbox.ActiveSyncEnabled, dbo.stagingDistributionGroupOwnership.GroupCount AS DLsManaged
FROM        dbo.stagingMailbox INNER JOIN
                  dbo.stagingADUser ON dbo.stagingMailbox.ExchangeGuid = dbo.stagingADUser.msExchMailboxGUID LEFT OUTER JOIN
                  dbo.stagingDistributionGroupOwnership ON dbo.stagingMailbox.ExchangeGuid = dbo.stagingDistributionGroupOwnership.ExchangeGUID LEFT OUTER JOIN
                  dbo.stagingCASMailbox ON dbo.stagingMailbox.PrimarySmtpAddress = dbo.stagingCASMailbox.PrimarySmtpAddress LEFT OUTER JOIN
                  dbo.stagingUserMobileDevice ON dbo.stagingMailbox.ExchangeGuid = dbo.stagingUserMobileDevice.UserExchangeGUID LEFT OUTER JOIN
                  dbo.stagingUserLicensing ON dbo.stagingMailbox.UserPrincipalName = dbo.stagingUserLicensing.UserPrincipalName LEFT OUTER JOIN
                  dbo.viewWaveGroupMembershipsAssigned ON dbo.stagingMailbox.DistinguishedName = dbo.viewWaveGroupMembershipsAssigned.distinguishedName LEFT OUTER JOIN
                  dbo.stagingRecipientOP ON dbo.stagingMailbox.ExchangeGuid = dbo.stagingRecipientOP.ExchangeGuid LEFT OUTER JOIN
                  dbo.stagingMailboxStats ON dbo.stagingMailbox.ExchangeGuid = dbo.stagingMailboxStats.MailboxGuid LEFT OUTER JOIN
                  dbo.stagingMailboxOL ON dbo.stagingMailbox.ExchangeGuid = dbo.stagingMailboxOL.ExchangeGuid
WHERE     (dbo.stagingMailbox.SourceOrganization = N'OP') AND (dbo.stagingMailbox.ExchangeGuid <> N'00000000-0000-0000-0000-000000000000')
GO
/****** Object:  View [dbo].[viewPermissionsForAnalysis]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewPermissionsForAnalysis]
AS
SELECT DISTINCT 
                  SourceOrganization, PermissionIdentity, ParentPermissionIdentity, SourceExchangeOrganization, TargetRecipientType, TargetRecipientTypeDetails, TrusteeRecipientType, TrusteeRecipientTypeDetails, TargetFolderType, PermissionType, AssignmentType, 
                  TargetPrimarySMTPAddress, TrusteePrimarySMTPAddress, TrusteeIdentity, TargetDistinguishedName, TrusteeDistinguishedName, TargetFolderPath, FolderAccessRights, TargetObjectGUID, TargetExchangeGUID, TrusteeGroupObjectGUID, TrusteeObjectGUID, 
                  TrusteeExchangeGUID, IsInherited
FROM        dbo.stagingPermissions
WHERE     (PermissionType <> 'Folder') AND (NOT (TrusteeIdentity IN (N'CCHCS\PPS_TR_EXCH.svc', N'NT AUTHORITY\SYSTEM', N'S-1-5-32-548', N'CCHCS\Domain Admins', N'CN=PPS_TR_Quarantine,OU=Service Accounts,OU=CCHCS,DC=CCHCS,DC=LDAP'))) OR
                  (PermissionType = 'Folder') AND (TargetFolderType = 'Calendar') AND (NOT (TrusteeIdentity IN (N'CCHCS\PPS_TR_EXCH.svc', N'NT AUTHORITY\SYSTEM', N'S-1-5-32-548', N'CCHCS\Domain Admins', 
                  N'CN=PPS_TR_Quarantine,OU=Service Accounts,OU=CCHCS,DC=CCHCS,DC=LDAP')))
GO
/****** Object:  View [dbo].[viewPermissionsReport]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewPermissionsReport]
AS
SELECT DISTINCT 
                  P.TargetRecipientTypeDetails, P.TargetPrimarySMTPAddress, P.TrusteeRecipientTypeDetails, P.TrusteePrimarySMTPAddress, P.PermissionType, P.TargetFolderType, P.TrusteeIdentity, P.TargetDistinguishedName, P.TrusteeDistinguishedName, 
                  P.FolderAccessRights, P.TrusteeExchangeGUID, P.TargetExchangeGUID, TEM.Alias AS TrusteeAlias, TAM.Alias AS TargetAlias
FROM        dbo.viewPermissionsForAnalysis AS P LEFT OUTER JOIN
                  dbo.viewMailboxList AS TEM ON P.TrusteeExchangeGUID = TEM.ExchangeGuid LEFT OUTER JOIN
                  dbo.viewMailboxList AS TAM ON P.TargetExchangeGUID = TAM.ExchangeGuid
GO
/****** Object:  Table [dbo].[WaveExceptions]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WaveExceptions](
	[PrimarySMTPAddress] [nvarchar](256) NULL,
	[OriginalWave] [float] NULL,
	[AssignedWave] [float] NULL,
	[Reason] [nvarchar](1024) NULL,
	[ApprovedByEmailAddress] [nvarchar](256) NULL,
	[DateAdded] [nvarchar](64) NULL,
	[DateModified] [nvarchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewMailboxWaveAssignments]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewMailboxWaveAssignments]
AS
SELECT DISTINCT 
                  L.Alias, L.Name, L.DisplayName, L.PrimarySmtpAddress, L.ExchangeGuid, CASE WHEN E.AssignedWave IS NULL THEN A.AssignedWave ELSE E.AssignedWave END AS AssignedWave, CASE WHEN E.AssignedWave IS NULL 
                  THEN 'WaveAssignments' ELSE 'WaveExceptions' END AS WaveAssignmentSource, L.RecipientTypeDetails, L.LitigationHoldEnabled, L.TargetAddress, L.OrganizationalUnit, L.WhenCreatedUTC, L.GroupName
FROM        dbo.viewMailboxList AS L INNER JOIN
                  dbo.WaveAssignments AS A ON L.GroupName = A.Name LEFT OUTER JOIN
                  dbo.WaveExceptions AS E ON L.PrimarySmtpAddress = E.PrimarySMTPAddress
GO
/****** Object:  View [dbo].[viewTrusteesSummaryForMigrationList]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewTrusteesSummaryForMigrationList]
AS
SELECT     L.[ExchangeGuid], STRING_AGG((CASE P.PermissionType WHEN 'FullAccess' THEN 'FA' WHEN 'SendOnBehalf' THEN 'SB' WHEN 'Folder' THEN 'C' END) + ':' + P.TrusteeAlias + ' (' + CONVERT(nvarchar(5), ISNULL(Convert(nvarchar(5),TL.AssignedWave),'NA')) + ')', ' | ') WITHIN GROUP (ORDER BY P.TrusteeAlias
                   ASC) AS Trustees
FROM        [dbo].[viewMailboxWaveAssignments] L JOIN
                  viewPermissionsReport P ON L.ExchangeGuid = P.TargetExchangeGUID LEFT JOIN
                  viewMailboxWaveAssignments TL ON P.TrusteeExchangeGUID = TL.ExchangeGuid
WHERE     (P.PermissionType IN ('FullAccess', 'SendOnBehalf') OR
                  (P.PermissionType = 'Folder' AND P.TargetFolderType = 'Calendar')) AND P.TrusteeAlias IS NOT NULL
GROUP BY L.ExchangeGuid
GO
/****** Object:  View [dbo].[viewTargetsSummaryForMigrationList]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewTargetsSummaryForMigrationList]
AS
SELECT     L.[ExchangeGuid], STRING_AGG((CASE P.PermissionType WHEN 'FullAccess' THEN 'FA' WHEN 'SendOnBehalf' THEN 'SB' WHEN 'Folder' THEN 'C' END) + ':' + P.TargetAlias + ' (' + CONVERT(nvarchar(5), ISNULL(CONVERT(nvarchar(5), TL.AssignedWave),'NA')) + ')', ' | ') WITHIN GROUP (ORDER BY P.TargetAlias
                   ASC) AS Targets
FROM        [dbo].[viewMailboxWaveAssignments] L JOIN
                  viewPermissionsReport P ON L.ExchangeGuid = P.TrusteeExchangeGUID LEFT JOIN
                  viewMailboxWaveAssignments TL ON P.TargetExchangeGUID = TL.ExchangeGuid
WHERE     (P.PermissionType IN ('FullAccess', 'SendOnBehalf') OR
                  (P.PermissionType = 'Folder' AND P.TargetFolderType = 'Calendar')) AND P.TargetAlias IS NOT NULL
GROUP BY L.ExchangeGuid
GO
/****** Object:  View [dbo].[viewWOAWithTargetsAndTrustees]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewWOAWithTargetsAndTrustees]
AS
SELECT     dbo.WOA.*, dbo.viewTargetsSummaryForMigrationList.Targets, dbo.viewTrusteesSummaryForMigrationList.Trustees
FROM        dbo.WOA LEFT OUTER JOIN
                  dbo.viewTrusteesSummaryForMigrationList ON dbo.WOA.ExchangeGUID = dbo.viewTrusteesSummaryForMigrationList.ExchangeGuid LEFT OUTER JOIN
                  dbo.viewTargetsSummaryForMigrationList ON dbo.WOA.ExchangeGUID = dbo.viewTargetsSummaryForMigrationList.ExchangeGuid
GO
/****** Object:  Table [dbo].[stagingMoveRequest]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingMoveRequest](
	[Alias] [nvarchar](64) NULL,
	[DisplayName] [nvarchar](256) NULL,
	[RecipientTypeDetails] [nvarchar](256) NULL,
	[SourceDatabase] [nvarchar](256) NULL,
	[SourceArchiveDatabase] [nvarchar](256) NULL,
	[TargetDatabase] [nvarchar](256) NULL,
	[TargetArchiveDatabase] [nvarchar](256) NULL,
	[RemoteHostName] [nvarchar](256) NULL,
	[IsOffline] [bit] NULL,
	[SuspendWhenReadyToComplete] [bit] NULL,
	[RequestQueue] [nvarchar](256) NULL,
	[Flags] [nvarchar](256) NULL,
	[BatchName] [nvarchar](64) NULL,
	[Status] [nvarchar](256) NULL,
	[Protect] [bit] NULL,
	[Suspend] [bit] NULL,
	[Direction] [nvarchar](64) NULL,
	[RequestStyle] [nvarchar](64) NULL,
	[OrganizationId] [nvarchar](1024) NULL,
	[IsValid] [bit] NULL,
	[ObjectState] [nvarchar](256) NULL,
	[User] [nvarchar](36) NULL,
	[UserGuid] [nvarchar](36) NULL,
	[ExchangeGUID] [nvarchar](36) NULL,
	[Identity] [nvarchar](36) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ClusteredIndex-20230724-141001]    Script Date: 8/10/2023 11:31:26 AM ******/
CREATE CLUSTERED INDEX [ClusteredIndex-20230724-141001] ON [dbo].[stagingMoveRequest]
(
	[ExchangeGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpecialHandling]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpecialHandling](
	[PrimarySMTPAddress] [nvarchar](256) NULL,
	[Description] [nvarchar](512) NULL,
	[AddedBy] [nvarchar](256) NULL,
	[DateAdded] [datetime2](7) NULL,
	[DateModified] [datetime2](7) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewSpecialHandling]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewSpecialHandling]
AS
SELECT     PrimarySMTPAddress, STRING_AGG(Description, '|') AS Description
FROM        dbo.SpecialHandling
GROUP BY PrimarySMTPAddress
GO
/****** Object:  View [dbo].[viewMailboxMigrationList]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewMailboxMigrationList]
AS
SELECT     L.Name, L.DisplayName, L.PrimarySmtpAddress, L.UserPrincipalName, L.ExchangeGuid, CASE WHEN E.AssignedWave IS NULL THEN A.AssignedWave ELSE E.AssignedWave END AS AssignedWave, CASE WHEN E.AssignedWave IS NULL 
                  THEN 'WaveAssignments' ELSE 'WaveExceptions' END AS WaveAssignmentSource, 
                  CASE WHEN L.RecipientTypeDetails LIKE 'Remote%' THEN 'Migrated' WHEN MR.Status NOT LIKE '%Complet%' THEN 'Synced' WHEN MR.Status LIKE '%Complet%' THEN 'Migrated' ELSE 'Non-Migrated' END AS MigrationState, L.TotalItemSizeInGB, 
                  L.TotalDeletedItemSizeInGB, L.ItemCount, L.DeletedItemCount, L.RemoteRoutingAddress, L.RecipientTypeDetails, L.ArchiveName, L.ArchiveDomain, L.ArchiveStatus, L.ArchiveState, L.RetentionPolicy, L.RetainDeletedItemsFor, L.WhenCreatedUTC, 
                  L.EmailAddresses, L.LitigationHoldEnabled, L.SingleItemRecoveryEnabled, L.TargetAddress, S.Description AS SpecialHandling, L.OrganizationalUnit, TRs.Trustees, TAs.Targets, L.Alias, L.Department, L.Company, L.Office, L.City, L.Manager, 
                  L.ProhibitSendQuotaInGB, L.GroupName, L.Enabled, L.countryCode, L.Country, L.employeeType, L.Division, L.DistinguishedName, L.IssueWarningQuotaInGB, L.ProhibitSendReceiveQuotaInGB, L.RecoverableItemsWarningQuotaInGB, L.ArchiveQuotaInGB, 
                  L.ArchiveWarningQuotaInGB, L.CalendarLoggingQuotaInGB, L.LicenseNames, L.ServicePlanNames, L.LastLogonDate, L.MobileDeviceType, L.MobileDeviceOS, L.MobileLastSuccessSync, L.MobileDeviceAccessState, L.ActiveSyncEnabled, L.DLsManaged
FROM        dbo.viewMailboxList AS L LEFT OUTER JOIN
                  dbo.stagingMoveRequest AS MR ON L.ExchangeGuid = MR.ExchangeGUID LEFT OUTER JOIN
                  dbo.viewTrusteesSummaryForMigrationList AS TRs ON L.ExchangeGuid = TRs.ExchangeGuid LEFT OUTER JOIN
                  dbo.viewTargetsSummaryForMigrationList AS TAs ON L.ExchangeGuid = TAs.ExchangeGuid LEFT OUTER JOIN
                  dbo.viewSpecialHandling AS S ON L.PrimarySmtpAddress = S.PrimarySMTPAddress LEFT OUTER JOIN
                  dbo.WaveExceptions AS E ON L.PrimarySmtpAddress = E.PrimarySMTPAddress LEFT OUTER JOIN
                  dbo.WaveAssignments AS A ON L.GroupName = A.Name
GO
/****** Object:  Table [dbo].[historyMailboxMigrationList]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[historyMailboxMigrationList](
	[Alias] [nvarchar](64) NULL,
	[Name] [nvarchar](256) NULL,
	[DisplayName] [nvarchar](256) NULL,
	[PreferredLastName] [nvarchar](64) NULL,
	[PreferredFirstName] [nvarchar](64) NULL,
	[PrimarySmtpAddress] [nvarchar](256) NULL,
	[UserPrincipalName] [nvarchar](256) NULL,
	[ExchangeGuid] [nchar](36) NULL,
	[AssignedWave] [float] NULL,
	[WaveAssignmentSource] [varchar](15) NOT NULL,
	[ExtensionCustomAttribute2] [nvarchar](1024) NULL,
	[TotalItemSizeInGB] [nvarchar](10) NULL,
	[TotalDeletedItemSizeInGB] [nvarchar](10) NULL,
	[ItemCount] [int] NULL,
	[DeletedItemCount] [int] NULL,
	[RemoteRoutingAddress] [nvarchar](256) NULL,
	[RecipientTypeDetails] [nvarchar](256) NULL,
	[ArchiveName] [nvarchar](256) NULL,
	[ArchiveDomain] [nvarchar](256) NULL,
	[ArchiveStatus] [nvarchar](256) NULL,
	[ArchiveState] [nvarchar](256) NULL,
	[RetentionPolicy] [nvarchar](256) NULL,
	[RetainDeletedItemsFor] [nvarchar](64) NULL,
	[WhenCreatedUTC] [datetime] NULL,
	[EmailAddresses] [nvarchar](4000) NULL,
	[LitigationHoldEnabled] [bit] NULL,
	[SingleItemRecoveryEnabled] [bit] NULL,
	[TargetAddress] [nvarchar](256) NULL,
	[SpecialHandling] [nvarchar](max) NULL,
	[OrganizationalUnit] [nvarchar](256) NULL,
	[Trustees] [nvarchar](4000) NULL,
	[Targets] [nvarchar](4000) NULL,
	[LocationCode] [nvarchar](64) NULL,
	[Region] [nvarchar](36) NULL,
	[LOB1] [nvarchar](1024) NULL,
	[LOB2] [nvarchar](1024) NULL,
	[LOB3] [nvarchar](1024) NULL,
	[Reviewer1] [nvarchar](64) NULL,
	[Reviewer2] [nvarchar](64) NULL,
	[Reviewer3] [nvarchar](64) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewMostRecentMailboxMigrationListChanges]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewMostRecentMailboxMigrationListChanges]
AS
SELECT   Alias, Name, DisplayName, PrimarySmtpAddress, ExchangeGuid, AssignedWave, WaveAssignmentSource, RecipientTypeDetails, TargetAddress, OrganizationalUnit, WhenCreatedUTC, Change, WhenListChangedUTC
FROM     (SELECT   L.Alias, L.Name, L.DisplayName, L.PrimarySmtpAddress, L.ExchangeGuid, L.AssignedWave, L.WaveAssignmentSource, L.RecipientTypeDetails, L.TargetAddress, L.OrganizationalUnit, L.WhenCreatedUTC, CASE WHEN H.ExchangeGuid IS NULL THEN 'Added to Organization' END AS Change, getutcdate() 
                           AS WhenListChangedUTC
             FROM      dbo.viewMailboxMigrationList AS L LEFT OUTER JOIN
                           dbo.historyMailboxMigrationList AS H ON L.ExchangeGuid = H.ExchangeGuid
             UNION
             SELECT   L.Alias, L.Name, L.DisplayName, L.PrimarySmtpAddress, L.ExchangeGuid, L.AssignedWave, L.WaveAssignmentSource, L.RecipientTypeDetails, L.TargetAddress, L.OrganizationalUnit, L.WhenCreatedUTC, CASE WHEN H.AssignedWave <> L.AssignedWave THEN 'Assigned Wave' END AS Change, getutcdate() 
                          AS WhenListChangedUTC
             FROM     dbo.viewMailboxMigrationList AS L INNER JOIN
                          dbo.historyMailboxMigrationList AS H ON L.ExchangeGuid = H.ExchangeGuid
             UNION
             SELECT   H.Alias, H.Name, H.DisplayName, H.PrimarySmtpAddress, H.ExchangeGuid, H.AssignedWave, 'N/A' AS WaveAssignmentSource, H.RecipientTypeDetails, H.TargetAddress, 'N/A' AS OrganizationalUnit, H.WhenCreatedUTC, CASE WHEN H.Alias IS NOT NULL AND L.Alias IS NULL 
                          THEN 'PersonDetails Missing' END AS Change, getutcdate() AS WhenListChangedUTC
             FROM     dbo.historyMailboxMigrationList AS H INNER JOIN
                          dbo.viewMailboxMigrationList AS L ON L.ExchangeGuid = H.ExchangeGuid
             UNION
             SELECT   H.Alias, H.Name, H.DisplayName, H.PrimarySmtpAddress, H.ExchangeGuid, H.AssignedWave, 'N/A' AS WaveAssignmentSource, H.RecipientTypeDetails, H.TargetAddress, 'N/A' AS OrganizationalUnit, H.WhenCreatedUTC, CASE WHEN L.ExchangeGuid IS NULL THEN 'Removed from Organization' END AS Change, 
                          getutcdate() AS WhenListChangedUTC
             FROM     dbo.historyMailboxMigrationList AS H LEFT OUTER JOIN
                          dbo.viewMailboxMigrationList AS L ON L.ExchangeGuid = H.ExchangeGuid
             WHERE   (L.ExchangeGuid IS NULL)) AS C
WHERE   (Change IS NOT NULL)
GO
/****** Object:  View [dbo].[stagingMailboxOP]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[stagingMailboxOP]
AS
SELECT SourceOrganization, ExchangeGuid, ExchangeObjectId, ExternalDirectoryObjectID, ArchiveGuid, Guid, Alias, SamAccountName, DisplayName, Name, PrimarySmtpAddress, UserPrincipalName, RemoteRoutingAddress, TargetAddress, 
                  ForwardingAddress, ForwardingSmtpAddress, LegacyExchangeDN, RecipientType, RecipientTypeDetails, RemoteRecipientType, LinkedMasterAccount, CustomAttribute1, CustomAttribute2, CustomAttribute3, CustomAttribute4, 
                  CustomAttribute5, CustomAttribute6, CustomAttribute7, CustomAttribute8, CustomAttribute9, CustomAttribute10, CustomAttribute11, CustomAttribute12, CustomAttribute13, CustomAttribute14, CustomAttribute15, 
                  ExtensionCustomAttribute1, ExtensionCustomAttribute2, ExtensionCustomAttribute3, ExtensionCustomAttribute4, ExtensionCustomAttribute5, Department, Office, OrganizationalUnit, [Database], ArchiveName, ArchiveDomain, 
                  ArchiveStatus, ArchiveState, RetentionPolicy, RetainDeletedItemsFor, ManagedFolderMailboxPolicy, AddressBookPolicy, RoleAssignmentPolicy, SharingPolicy, DefaultPublicFolderMailbox, RecipientLimits, ResourceCapacity, 
                  DistinguishedName, WhenCreatedUTC, WhenChangedUTC, EmailAddresses, UseDatabaseRetentionDefaults, UseDatabaseQuotaDefaults, LitigationHoldEnabled, SingleItemRecoveryEnabled, RetentionHoldEnabled, BccBlocked, 
                  AutoExpandingArchiveEnabled, HiddenFromAddressListsEnabled, EmailAddressPolicyEnabled, MessageCopyForSentAsEnabled, MessageCopyForSendOnBehalfEnabled, DeliverToMailboxAndForward, 
                  MessageTrackingReadStatusEnabled, DowngradeHighPriorityMessagesEnabled, UMEnabled, IsAuxMailbox, CalendarVersionStoreDisabled, SKUAssigned, AuditEnabled, ArchiveQuotaInGB, ArchiveWarningQuotaInGB, 
                  CalendarLoggingQuotaInGB, IssueWarningQuotaInGB, ProhibitSendQuotaInGB, ProhibitSendReceiveQuotaInGB, RecoverableItemsQuotaInGB, RecoverableItemsWarningQuotaInGB, RulesQuotaInKB, MaxSendSizeInMB, 
                  MaxReceiveSizeInMB
FROM     dbo.stagingMailbox
WHERE  (SourceOrganization = N'OP')
GO
/****** Object:  Table [dbo].[WOAWaveExceptions]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WOAWaveExceptions](
	[PrimarySMTPAddress] [nvarchar](256) NULL,
	[OriginalWave] [float] NULL,
	[AssignedWave] [float] NULL,
	[Reason] [nvarchar](1024) NULL,
	[ApprovedByEmailAddress] [nvarchar](256) NULL,
	[DateAdded] [datetime2](7) NULL,
	[DateModified] [datetime2](7) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewWOAMailboxMigrationList]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewWOAMailboxMigrationList]
AS
SELECT     L.Name, L.DisplayName, L.PrimarySmtpAddress, L.UserPrincipalName, L.ExchangeGuid, CASE WHEN E.AssignedWave IS NULL THEN A.AssignedWave ELSE E.AssignedWave END AS AssignedWave, CASE WHEN E.AssignedWave IS NULL 
                  THEN 'WaveAssignments' ELSE 'WaveExceptions' END AS WaveAssignmentSource, CASE WHEN L.RecipientTypeDetails LIKE 'Remote%' THEN 'Migrated' ELSE 'Non-Migrated' END AS MigrationState, L.TotalItemSizeInGB, L.TotalDeletedItemSizeInGB, L.ItemCount, 
                  L.DeletedItemCount, L.RemoteRoutingAddress, L.RecipientTypeDetails, L.ArchiveName, L.ArchiveDomain, L.ArchiveStatus, L.ArchiveState, L.RetentionPolicy, L.RetainDeletedItemsFor, L.WhenCreatedUTC, L.EmailAddresses, L.LitigationHoldEnabled, 
                  L.SingleItemRecoveryEnabled, L.TargetAddress, S.Description AS SpecialHandling, L.OrganizationalUnit, TRs.Trustees, TAs.Targets, L.Alias, L.Department, L.Company, L.Office, L.City, L.Manager, L.ProhibitSendQuotaInGB, L.GroupName, L.skuDisplayName, 
                  L.Enabled, L.countryCode, L.Country, L.employeeType, L.Division, L.DistinguishedName
FROM        dbo.viewMailboxList AS L LEFT OUTER JOIN
                  dbo.viewTrusteesSummaryForMigrationList AS TRs ON L.ExchangeGuid = TRs.ExchangeGuid LEFT OUTER JOIN
                  dbo.viewTargetsSummaryForMigrationList AS TAs ON L.ExchangeGuid = TAs.ExchangeGuid LEFT OUTER JOIN
                  dbo.viewSpecialHandling AS S ON L.PrimarySmtpAddress = S.PrimarySMTPAddress LEFT OUTER JOIN
                  dbo.WOAWaveExceptions AS E ON L.PrimarySmtpAddress = E.PrimarySMTPAddress LEFT OUTER JOIN
                  dbo.WaveAssignments AS A ON L.GroupName = A.Name
GO
/****** Object:  View [dbo].[stagingRecipientOL]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[stagingRecipientOL]
AS
SELECT SourceOrganization, ExchangeGuid, ExchangeObjectId, ExternalDirectoryObjectID, ArchiveGuid, Guid, Alias, DisplayName, PrimarySmtpAddress, ExternalEmailAddress, RecipientType, RecipientTypeDetails, CustomAttribute1, 
                  CustomAttribute2, CustomAttribute3, CustomAttribute4, CustomAttribute5, CustomAttribute6, CustomAttribute7, CustomAttribute8, CustomAttribute9, CustomAttribute10, CustomAttribute11, CustomAttribute12, CustomAttribute13, 
                  CustomAttribute14, CustomAttribute15, ExtensionCustomAttribute1, ExtensionCustomAttribute2, ExtensionCustomAttribute3, ExtensionCustomAttribute4, ExtensionCustomAttribute5, Department, DistinguishedName, Manager, 
                  WhenCreatedUTC, WhenChangedUTC, EmailAddresses, ArchiveStatus, ArchiveState
FROM     dbo.stagingRecipient
WHERE  (SourceOrganization = N'OL')
GO
/****** Object:  View [dbo].[viewRecipientConnectionsPerAssignedWave]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewRecipientConnectionsPerAssignedWave]
AS
SELECT TOP (100) PERCENT Recipient, AssignedWave, COUNT(CONNECTION) AS ConnectionCount
FROM     (SELECT DISTINCT P.TargetExchangeGUID AS Recipient, P.TrusteeExchangeGUID AS CONNECTION, L.AssignedWave
                  FROM      dbo.viewPermissionsForAnalysis AS P INNER JOIN
                                    dbo.viewWOAMailboxMigrationList AS L ON P.TrusteeExchangeGUID = L.ExchangeGuid
                  WHERE   (P.PermissionType <> 'SendAS')
                  UNION
                  SELECT DISTINCT P.TrusteeExchangeGUID AS Recipient, P.TargetExchangeGUID AS CONNECTION, L.AssignedWave
                  FROM     dbo.viewPermissionsForAnalysis AS P INNER JOIN
                                    dbo.viewWOAMailboxMigrationList AS L ON P.TargetExchangeGUID = L.ExchangeGuid
                  WHERE  (P.PermissionType <> 'SendAS')) AS TheSum
WHERE  (Recipient IS NOT NULL)
GROUP BY Recipient, AssignedWave
ORDER BY Recipient, AssignedWave
GO
/****** Object:  Table [dbo].[domain]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[domain](
	[domainName] [nvarchar](256) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[exchangeOrganization]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[exchangeOrganization](
	[OrganizationGuid] [nchar](36) NOT NULL,
	[OrganizationIdentity] [nvarchar](256) NULL,
	[OrgShortName] [nvarchar](15) NULL,
	[ADForest] [nvarchar](256) NULL,
	[TenantID] [nchar](36) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[historyADUser]    Script Date: 8/10/2023 11:31:26 AM ******/
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
/****** Object:  Table [dbo].[historyContact]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[historyContact](
	[SourceOrganization] [nvarchar](64) NULL,
	[ExchangeObjectId] [nchar](36) NULL,
	[ExternalDirectoryObjectID] [nchar](36) NULL,
	[Guid] [nchar](36) NULL,
	[Alias] [nvarchar](64) NULL,
	[DisplayName] [nvarchar](256) NULL,
	[Name] [nvarchar](256) NULL,
	[ExternalEmailAddress] [nvarchar](256) NULL,
	[PrimarySmtpAddress] [nvarchar](256) NULL,
	[WindowsEmailAddress] [nvarchar](256) NULL,
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
	[DistinguishedName] [nvarchar](1024) NULL,
	[Manager] [nvarchar](1024) NULL,
	[WhenCreatedUTC] [datetime] NULL,
	[WhenChangedUTC] [datetime] NULL,
	[LastExchangeChangedTime] [datetime] NULL,
	[EmailAddresses] [nvarchar](4000) NULL,
	[Description] [nvarchar](2048) NULL,
	[UMDtmfMap] [nvarchar](2048) NULL,
	[EmailAddressPolicyEnabled] [bit] NULL,
	[HiddenFromAddressListsEnabled] [bit] NULL,
	[RequireSenderAuthenticationEnabled] [bit] NULL,
	[ModerationEnabled] [bit] NULL,
	[SendOofMessageToOriginatorEnabled] [bit] NULL,
	[IsDirSynced] [bit] NULL,
	[IsValid] [bit] NULL,
	[UsePreferMessageFormat] [bit] NULL,
	[SendModerationNotifications] [nvarchar](64) NULL,
	[LegacyExchangeDN] [nvarchar](256) NULL,
	[MailTip] [nvarchar](256) NULL,
	[ObjectCategory] [nvarchar](256) NULL,
	[ObjectState] [nvarchar](256) NULL,
	[OrganizationalUnit] [nvarchar](256) NULL,
	[OrganizationalUnitRoot] [nvarchar](256) NULL,
	[OrganizationId] [nvarchar](256) NULL,
	[SimpleDisplayName] [nvarchar](256) NULL,
	[MaxReceiveSize] [nvarchar](64) NULL,
	[MaxSendSize] [nvarchar](64) NULL,
	[AcceptMessagesOnlyFromSendersOrMembers] [nvarchar](2048) NULL,
	[RejectMessagesFromSendersOrMembers] [nvarchar](2048) NULL,
	[AddressListMembership] [nvarchar](2048) NULL,
	[GrantSendOnBehalfTo] [nvarchar](2048) NULL,
	[ManagedBy] [nvarchar](2048) NULL,
	[ModeratedBy] [nvarchar](2048) NULL,
	[BypassModerationFromSendersOrMembers] [nvarchar](2048) NULL,
	[MacAttachmentFormat] [nvarchar](64) NULL,
	[MessageBodyFormat] [nvarchar](64) NULL,
	[UseMapiRichTextFormat] [nvarchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[historyMailbox]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[historyMailbox](
	[SourceOrganization] [nvarchar](64) NULL,
	[ExchangeGuid] [nchar](36) NULL,
	[ExchangeObjectId] [nchar](36) NULL,
	[ExternalDirectoryObjectID] [nchar](36) NULL,
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
/****** Object:  Table [dbo].[historyMailboxStats]    Script Date: 8/10/2023 11:31:26 AM ******/
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
/****** Object:  Table [dbo].[historyMigrationListChanges]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[historyMigrationListChanges](
	[Initials] [nvarchar](64) NULL,
	[Name] [nvarchar](256) NULL,
	[DisplayName] [nvarchar](256) NULL,
	[PrimarySmtpAddress] [nvarchar](256) NULL,
	[ExchangeGuid] [nchar](36) NULL,
	[BusinessUnit] [nvarchar](64) NULL,
	[Department] [nvarchar](64) NULL,
	[AssignedWave] [float] NULL,
	[WaveAssignmentSource] [varchar](15) NOT NULL,
	[ExtensionCustomAttribute2] [nvarchar](1024) NULL,
	[RecipientTypeDetails] [nvarchar](256) NULL,
	[TargetAddress] [nvarchar](256) NULL,
	[OrganizationalUnit] [nvarchar](256) NULL,
	[WhenCreatedUTC] [datetime] NULL,
	[Change] [varchar](25) NOT NULL,
	[WhenListChangedUTC] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[historyRecipient]    Script Date: 8/10/2023 11:31:26 AM ******/
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
	[DistinguishedName] [nvarchar](1024) NULL,
	[Manager] [nvarchar](1024) NULL,
	[WhenCreatedUTC] [datetime] NULL,
	[WhenChangedUTC] [datetime] NULL,
	[EmailAddresses] [nvarchar](4000) NULL,
	[ArchiveStatus] [nvarchar](256) NULL,
	[ArchiveState] [nvarchar](256) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ManagerAssistant]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ManagerAssistant](
	[Alias] [nvarchar](64) NULL,
	[JobShortName] [nvarchar](64) NULL,
	[AssistantAlias] [nvarchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermissionsAnalysis]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionsAnalysis](
	[PrimarySMTPAddress] [nvarchar](max) NULL,
	[RecipientType] [nvarchar](max) NULL,
	[RecipientTypeDetails] [nvarchar](max) NULL,
	[ExchangeGUID] [nvarchar](max) NULL,
	[CurrentWave] [float] NULL,
	[RecommendedWave] [float] NULL,
	[4.2] [int] NULL,
	[2.2] [nvarchar](max) NULL,
	[8.1] [nvarchar](max) NULL,
	[9.1] [nvarchar](max) NULL,
	[0.1] [nvarchar](max) NULL,
	[1.1] [nvarchar](max) NULL,
	[2.1] [nvarchar](max) NULL,
	[4.1] [int] NULL,
	[0.3] [nvarchar](max) NULL,
	[3.2] [int] NULL,
	[NotAssigned] [nvarchar](max) NULL,
	[3.1] [nvarchar](max) NULL,
	[0.2] [nvarchar](max) NULL,
	[1.2] [nvarchar](max) NULL,
	[6.2] [nvarchar](max) NULL,
	[8.2] [nvarchar](max) NULL,
	[6.1] [nvarchar](max) NULL,
	[ChangeWave] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonDetails]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonDetails](
	[AssociateNumber] [nvarchar](64) NULL,
	[Alias] [nvarchar](64) NULL,
	[PreferredLastName] [nvarchar](64) NULL,
	[PreferredFirstName] [nvarchar](64) NULL,
	[StatusCode] [nvarchar](64) NULL,
	[CompanyCode] [nvarchar](64) NULL,
	[CompanyDescription] [nvarchar](64) NULL,
	[DepartmentDescription] [nvarchar](64) NULL,
	[PositionTitle] [nvarchar](64) NULL,
	[CostCenterCode] [nvarchar](64) NULL,
	[CostCenterDescription] [nvarchar](64) NULL,
	[LocationCode] [nvarchar](64) NULL,
	[FLSAStatusCode] [nvarchar](64) NULL,
	[OrgUnitShortName] [nvarchar](64) NULL,
	[BusinessUnit] [nvarchar](64) NULL,
	[Department] [nvarchar](64) NULL,
	[Reviewer1] [nvarchar](64) NULL,
	[Reviewer2] [nvarchar](64) NULL,
	[Reviewer3] [nvarchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relLocationRegion]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relLocationRegion](
	[LocationCode] [nvarchar](5) NULL,
	[Region] [nvarchar](36) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingContact]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingContact](
	[SourceOrganization] [nvarchar](64) NULL,
	[ExchangeObjectId] [nchar](36) NULL,
	[ExternalDirectoryObjectID] [nchar](36) NULL,
	[Guid] [nchar](36) NULL,
	[Alias] [nvarchar](64) NULL,
	[DisplayName] [nvarchar](256) NULL,
	[Name] [nvarchar](256) NULL,
	[ExternalEmailAddress] [nvarchar](256) NULL,
	[PrimarySmtpAddress] [nvarchar](256) NULL,
	[WindowsEmailAddress] [nvarchar](256) NULL,
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
	[DistinguishedName] [nvarchar](1024) NULL,
	[Manager] [nvarchar](1024) NULL,
	[WhenCreatedUTC] [datetime] NULL,
	[WhenChangedUTC] [datetime] NULL,
	[LastExchangeChangedTime] [datetime] NULL,
	[EmailAddresses] [nvarchar](4000) NULL,
	[Description] [nvarchar](2048) NULL,
	[UMDtmfMap] [nvarchar](2048) NULL,
	[EmailAddressPolicyEnabled] [bit] NULL,
	[HiddenFromAddressListsEnabled] [bit] NULL,
	[RequireSenderAuthenticationEnabled] [bit] NULL,
	[ModerationEnabled] [bit] NULL,
	[SendOofMessageToOriginatorEnabled] [bit] NULL,
	[IsDirSynced] [bit] NULL,
	[IsValid] [bit] NULL,
	[UsePreferMessageFormat] [bit] NULL,
	[SendModerationNotifications] [nvarchar](64) NULL,
	[LegacyExchangeDN] [nvarchar](256) NULL,
	[MailTip] [nvarchar](256) NULL,
	[ObjectCategory] [nvarchar](256) NULL,
	[ObjectState] [nvarchar](256) NULL,
	[OrganizationalUnit] [nvarchar](256) NULL,
	[OrganizationalUnitRoot] [nvarchar](256) NULL,
	[OrganizationId] [nvarchar](256) NULL,
	[SimpleDisplayName] [nvarchar](256) NULL,
	[MaxReceiveSize] [nvarchar](64) NULL,
	[MaxSendSize] [nvarchar](64) NULL,
	[AcceptMessagesOnlyFromSendersOrMembers] [nvarchar](2048) NULL,
	[RejectMessagesFromSendersOrMembers] [nvarchar](2048) NULL,
	[AddressListMembership] [nvarchar](2048) NULL,
	[GrantSendOnBehalfTo] [nvarchar](2048) NULL,
	[ManagedBy] [nvarchar](2048) NULL,
	[ModeratedBy] [nvarchar](2048) NULL,
	[BypassModerationFromSendersOrMembers] [nvarchar](2048) NULL,
	[MacAttachmentFormat] [nvarchar](64) NULL,
	[MessageBodyFormat] [nvarchar](64) NULL,
	[UseMapiRichTextFormat] [nvarchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stagingGroupLicensing]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stagingGroupLicensing](
	[groupId] [nvarchar](max) NULL,
	[groupDisplayName] [nvarchar](max) NULL,
	[type] [nvarchar](max) NULL,
	[skuDisplayName] [nvarchar](max) NULL,
	[skuName] [nvarchar](max) NULL,
	[skuId] [nvarchar](max) NULL,
	[skuPrepaidUnitsEnabled] [float] NULL,
	[skuConsumedUnits] [float] NULL,
	[skuNonConsumedUnits] [float] NULL,
	[skuAppliesTo] [nvarchar](max) NULL,
	[servicePlanDisplayName] [nvarchar](max) NULL,
	[servicePlanName] [nvarchar](max) NULL,
	[servicePlanId] [nvarchar](max) NULL,
	[servicePlanProvisioningStatus] [nvarchar](max) NULL,
	[servicePlanAppliesTo] [nvarchar](max) NULL,
	[servicePlanIsEnabled] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tenant]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tenant](
	[TenantID] [nchar](36) NOT NULL,
	[TenantDomain] [nvarchar](256) NOT NULL,
	[TenantName] [nvarchar](256) NOT NULL,
	[TenantShortName] [nvarchar](15) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TenantSKU]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TenantSKU](
	[accountName] [nvarchar](max) NULL,
	[accountId] [nvarchar](max) NULL,
	[appliesTo] [nvarchar](max) NULL,
	[capabilityStatus] [nvarchar](max) NULL,
	[consumedUnits] [bigint] NULL,
	[id] [nvarchar](max) NULL,
	[skuId] [nvarchar](max) NULL,
	[skuPartNumber] [nvarchar](max) NULL,
	[prepaidUnitsEnabled] [bigint] NULL,
	[nonConsumedUnits] [bigint] NULL,
	[skuDisplayName] [nvarchar](max) NULL,
	[servicePlanNames] [nvarchar](max) NULL,
	[servicePlanDisplayNames] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WavePlan]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WavePlan](
	[WaveGroup] [float] NULL,
	[SubWave] [float] NULL,
	[Wave] [nvarchar](max) NULL,
	[TargetDate] [datetime2](7) NULL,
	[T-12] [datetime2](7) NULL,
	[T-10] [datetime2](7) NULL,
	[T-5] [datetime2](7) NULL,
	[T-3] [datetime2](7) NULL,
	[T-1] [datetime2](7) NULL,
	[T] [datetime2](7) NULL,
	[T+1] [datetime2](7) NULL,
	[SyncInitiated] [bit] NULL,
	[MigrationCompleted] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NonClusteredIndex-20230707-140214]    Script Date: 8/10/2023 11:31:26 AM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20230707-140214] ON [dbo].[stagingMailbox]
(
	[DistinguishedName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NonClusteredIndex-20230726-122349]    Script Date: 8/10/2023 11:31:26 AM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20230726-122349] ON [dbo].[stagingMailbox]
(
	[Guid] ASC,
	[PrimarySmtpAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[usp_DiffTableRows]    Script Date: 8/10/2023 11:31:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_DiffTableRows]    
    @pTable0          varchar(300),
    @pTable1          varchar(300),
    @pOrderByCsvOpt   nvarchar(1000) = null,  -- Order the Results
    @pOnlyCsvOpt      nvarchar(4000) = null,  -- Only compare these columns
    @pIgnoreCsvOpt    nvarchar(4000) = null,  -- Ignore these columns (ignored if @pOnlyCsvOpt is specified)
    @pDebug           bit = 0
as
/*---------------------------------------------------------------------------------------------------------------------
    Purpose:  Compare rows between two tables.

      Usage:  exec Common.usp_DiffTableRows '#a', '#b';

    Modified    By          Description
    ----------  ----------  -------------------------------------------------------------------------------------------
    2015.10.06  crokusek    Initial Version
    2019.03.13  crokusek    Added @pOrderByCsvOpt
    2019.06.26  crokusek    Support for @pIgnoreCsvOpt, @pOnlyCsvOpt.    
    2019.09.04  crokusek    Minor debugging improvement
    2020.03.12  crokusek    Detect duplicate rows in either source table
  ---------------------------------------------------------------------------------------------------------------------*/
begin try

    if (substring(@pTable0, 1, 1) = '#')
        set @pTable0 = 'tempdb..' + @pTable0; -- object_id test below needs full names for temp tables

    if (substring(@pTable1, 1, 1) = '#')
        set @pTable1 = 'tempdb..' + @pTable1; -- object_id test below needs full names for temp tables

    if (object_id(@pTable0) is null)
        raiserror('Table name is not recognized: ''%s''', 16, 1, @pTable0);

    if (object_id(@pTable1) is null)
        raiserror('Table name is not recognized: ''%s''', 16, 1, @pTable1);

    create table #ColumnGathering
    (
        Name nvarchar(300) not null,
        Sequence int not null,
        TableArg tinyint not null
    );

    declare
        @usp          varchar(100) = object_name(@@procid),    
        @sql          nvarchar(4000),
        @sqlTemplate  nvarchar(4000) = 
        '  
            use $database$;

            insert into #ColumnGathering
            select Name, column_id as Sequence, $TableArg$ as TableArg
              from sys.columns c
             where object_id = object_id(''$table$'', ''U'')
        ';          

    set @sql = replace(replace(replace(@sqlTemplate,
        '$TableArg$', 0),
        '$database$', (select DatabaseName from Common.ufn_SplitDbIdentifier(@pTable0))),
        '$table$', @pTable0);

    if (@pDebug = 1)
        print 'Sql #CG 0: ' + @sql;

    exec sp_executesql @sql;

    set @sql = replace(replace(replace(@sqlTemplate,
        '$TableArg$', 1),
        '$database$', (select DatabaseName from Common.ufn_SplitDbIdentifier(@pTable1))),
        '$table$', @pTable1);

    if (@pDebug = 1)
        print 'Sql #CG 1: ' + @sql;

    exec sp_executesql @sql;

    if (@pDebug = 1)
        select * from #ColumnGathering;

    select Name, 
           min(Sequence) as Sequence, 
           convert(bit, iif(min(TableArg) = 0, 1, 0)) as InTable0,
           convert(bit, iif(max(TableArg) = 1, 1, 0)) as InTable1
      into #Columns
      from #ColumnGathering
     group by Name
    having (     @pOnlyCsvOpt is not null 
             and Name in (select Value from Common.ufn_UsvToNVarcharKeyTable(@pOnlyCsvOpt, default)))
        or 
           (     @pOnlyCsvOpt is null
             and @pIgnoreCsvOpt is not null 
             and Name not in (select Value from Common.ufn_UsvToNVarcharKeyTable(@pIgnoreCsvOpt, default)))
        or 
           (     @pOnlyCsvOpt is null
             and @pIgnoreCsvOpt is null)

    if (exists (select 1 from #Columns where InTable0 = 0 or InTable1 = 0))
    begin
        select 1; -- without this the debugging info doesn't stream sometimes
        select * from #Columns order by Sequence;        
        waitfor delay '00:00:02';  -- give results chance to stream before raising exception
        raiserror('Columns are not equal between tables, consider using args @pIgnoreCsvOpt, @pOnlyCsvOpt.  See Result Sets for details.', 16, 1);    
    end

    if (@pDebug = 1)
        select * from #Columns order by Sequence;

    declare 
        @columns nvarchar(4000) = --iif(@pOnlyCsvOpt is null and @pIgnoreCsvOpt is null,
           -- '*',     
            (
              select substring((select ',' + ac.name
                from #Columns ac
               order by Sequence
                 for xml path('')),2,200000) as csv
            );

    if (@pDebug = 1)
    begin
        print 'Columns: ' + @columns;
        waitfor delay '00:00:02';  -- give results chance to stream before possibly raising exception
    end

    -- Based on https://stackoverflow.com/a/2077929/538763
    --     - Added sensing for duplicate rows
    --     - Added reporting of source table location
    --
    set @sqlTemplate = '
            with 
               a as (select ~, Row_Number() over (partition by ~ order by (select null)) -1 as Duplicates from $a$), 
               b as (select ~, Row_Number() over (partition by ~ order by (select null)) -1 as Duplicates from $b$)
            select 0 as SourceTable, ~
              from 
                 (
                   select * from a
                   except
                   select * from b
                 )  anb
              union all
             select 1 as SourceTable, ~
               from 
                 (
                   select * from b
                   except
                   select * from a
                 )  bna
             order by $orderBy$
        ';    

     set @sql = replace(replace(replace(replace(@sqlTemplate, 
            '$a$', @pTable0), 
            '$b$', @pTable1),
            '~', @columns),
            '$orderBy$', coalesce(@pOrderByCsvOpt, @columns + ', SourceTable')
        );

     if (@pDebug = 1)
        print 'Sql: ' + @sql;

     exec sp_executesql @sql;

end try
begin catch
    declare        
        @CatchingUsp  varchar(100) = object_name(@@procid);    

    if (xact_state() = -1)
        rollback;    

    -- Disabled for S.O. post

    --exec Common.usp_Log
        --@pMethod = @CatchingUsp;

    --exec Common.usp_RethrowError        
        --@pCatchingMethod = @CatchingUsp;

    throw;
end catch
GO
USE [master]
GO
ALTER DATABASE [MBMigrator] SET  READ_WRITE 
GO
