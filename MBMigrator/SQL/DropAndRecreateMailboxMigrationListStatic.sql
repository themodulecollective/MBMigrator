USE [Migration]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MigrationListStatic]') AND type in (N'U'))
DROP TABLE [dbo].[MigrationListStatic]
GO
USE [Migration]
GO

SELECT *
	  INTO MigrationListStatic
  FROM [dbo].[MigrationList]

GO
