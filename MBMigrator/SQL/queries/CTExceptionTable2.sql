USE [DirSyncPro]
GO

/****** Object:  Table [dbo].[CT_UserExceptions]    Script Date: 12/12/2024 2:17:12 PM ******/
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


