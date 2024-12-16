IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CT_UserExceptions]') AND type in (N'U'))
DROP TABLE [dbo].[CT_UserExceptions]
GO

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


