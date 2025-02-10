SELECT [SourcesamAccountname],U.*
  FROM [Migration].[dbo].[stagingCheck4Workday] C
  JOIN stagingADUser U ON C.SourcesamAccountname = u.SamAccountName
  WHERE Enabled = 1