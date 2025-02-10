USE DirSyncPro
GO
SELECT  [EmployeeID]
      ,[NewDisplayName]
      ,[NewAlias]
      ,[NewSamAccountName]
      ,[NewFirstName]
      ,[NewLastName]
  FROM [DirSyncPro].[dbo].[CT_UserExceptions]
