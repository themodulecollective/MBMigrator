USE [Migration]
GO



SELECT [AzureADSync]
      ,[Domain]
      ,[RecipientTypeDetails]
      ,Count([PrimarySmtpAddress]) MailboxCount
  FROM [dbo].[ADUsersAllMailboxWithDivCostCenter]
  Group By AzureADSync, RecipientTypeDetails, Domain
  Order BY AzureADSync,MailboxCount
