SELECT
      [ExchangeGuid]
      ,[Name]
      ,[DisplayName]
      ,[UserPrincipalName]
      ,[PrimarySmtpAddress]
      ,[Alias]
      ,[TargetAddress]
      ,[AssignedWave]
      ,[WaveAssignmentSource]
      ,[MigrationState]
      ,[TotalItemSizeInGB]
      ,[TotalDeletedItemSizeInGB]
      ,[ItemCount]
      ,[DeletedItemCount]
      ,[RemoteRoutingAddress]
      ,[RecipientTypeDetails]
      --,[ArchiveName]
      --,[ArchiveDomain]
      --,[ArchiveStatus]
      --,[ArchiveState]
      ,[RetentionPolicy]
      ,[RetainDeletedItemsFor]
      ,[LitigationHoldEnabled]
      ,[SingleItemRecoveryEnabled]
      ,[SpecialHandling]
      ,[OrganizationalUnit]
      ,[Department]
      ,[Company]
      ,[Office]
      ,[City]
      ,[Manager]
      ,[GroupName]
      ,[WhenCreatedUTC]
      ,[Enabled]
      ,[LastLogonDate]
      ,[countryCode]
      ,[Country]
      ,[employeeType]
      ,[Division]
      ,[IssueWarningQuotaInGB]
      ,[ProhibitSendQuotaInGB]
      ,[ProhibitSendReceiveQuotaInGB]
      ,[RecoverableItemsWarningQuotaInGB]
      --,[ArchiveQuotaInGB]
      --,[ArchiveWarningQuotaInGB]
      ,[CalendarLoggingQuotaInGB]
      ,[MobileDeviceType]
      ,[MobileDeviceOS]
      ,[MobileLastSuccessSync]
      ,[MobileDeviceAccessState]
      ,[ActiveSyncEnabled]
      ,[DLsManaged]
      ,[LicenseNames]
      ,[ServicePlanNames]
      ,[DistinguishedName]
      ,[EmailAddresses]
      ,[Trustees]
      ,[Targets]
  FROM [MBMigrator].[dbo].[viewMigrationList]
ORDER BY
  DisplayName