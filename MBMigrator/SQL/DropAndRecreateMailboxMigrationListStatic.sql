USE [Migration]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MailboxMigrationListStatic]') AND type in (N'U'))
DROP TABLE [dbo].[MailboxMigrationListStatic]
GO
USE [Migration]
GO

SELECT *
	  INTO MailboxMigrationListStatic
  FROM [dbo].[MailboxMigrationList]

GO
