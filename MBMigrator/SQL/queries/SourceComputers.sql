USE [Migration]
GO

SELECT [CanonicalName]
	  ,(SELECT value FROM STRING_SPLIT(CanonicalName,'/', 1) WHERE ordinal = 3) CountryCode
      ,[CN]
      ,[Created]
      ,[Description]
      ,[DisplayName]
      ,[DistinguishedName]
      ,[DNSHostName]
      ,[Enabled]
      ,[instanceType]
      ,[IPv4Address]
      ,[isDeleted]
      ,[LastBadPasswordAttempt]
      ,[LastLogonDate]
      ,[Location]
      ,[LockedOut]
      ,[ManagedBy]
      ,[Modified]
      ,[Name]
	  , M.Username UserSourceSAM
	  , M.email UserSourceMail
	  , M.Mobile UserMobile
      ,[ObjectClass]
	  , M.Manufacturer
	  , M.Model
	  , m.OScode LSOSCode
	  , M.Version LSOSVersion
	  , M.OSname LSOSName
      ,[OperatingSystem]
      ,[OperatingSystemHotfix]
      ,[OperatingSystemServicePack]
      ,[OperatingSystemVersion]
      ,[PasswordNotRequired]
      ,[pwdLastSet]
      ,[SamAccountName]
      ,[whenChanged]
      ,[whenCreated]
      ,[MemberOf]
      ,[SID]
      ,[SIDHistory]
      ,[ObjectGUID]
      ,[DomainName]
  FROM [dbo].[stagingADComputer] C
  LEFT JOIN stagingComputerToUserMapping M
  ON C.Name = M.AssetName
  WHERE DomainName IN ('dc1','dc2','dc3') AND Enabled = 1
  AND C.OperatingSystem LIKE 'Windows 1%'


GO


