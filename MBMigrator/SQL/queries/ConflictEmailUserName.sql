USE [Migration]
GO

SELECT M.[RecipientTypeDetails]
      ,[DomainName]
      ,[CurrentGivenName]
      ,[NewGivenName]
      ,[CurrentSurname]
      ,[NewSurname]
      ,[CurrentSamAccountName]
      ,[CurrentEmailAlias]
      ,[NewEmailAlias]
      ,[NewSamAccountName]
      ,[CurrentEmail]
      ,[NewEmailAndUsername]
      ,[CurrentDisplayName]
      ,[NewDisplayName]
	  , C.EmployeeID ConflictEmployeeID
	  , C.onPremisesSamAccountName ConflictingSamAccountName
	  , C.companyName ConflictingCompanyName
	  , C.department ConflictingDepartment
  FROM [dbo].[vCalcMigUserAttributes_SOURCE] M
  INNER JOIN 
  vTARGETEmailEmployeeID C ON 
 M.NewEmailAndUsername = C.PrimarySmtpAddress 
   WHERE M.CurrentSamAccountName NOT LIKE 'AA%'
  AND M.NewSamAccountName <> C.employeeId
GO


