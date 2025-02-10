SELECT
      COUNT ([WEmployeeID]) AS IDCount
	  , WEmployeeID
	  , STRING_AGG (SamAccountName, '; ') AS SAMAccountNames
	  , STRING_AGG (DomainName, '; ') AS DomainNames
	   , STRING_AGG (Mail, '; ') AS Mails
	   , STRING_AGG ([Enabled], ';') AS EnabledStatus
  FROM [Migration].[dbo].[vSourceUserWorkMail]
  GROUP BY WEmployeeID
  ORDER BY IDCount DESC