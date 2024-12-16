SELECT DISTINCT
      [UserID]
      ,[UserDisplayName]
      ,[UserMail]
      ,[UserPrincipalName]
      ,[TenantDomain]
	  --, GroupDisplayName
  FROM [Migration].[dbo].[stagingUGRoleHolder]
  where --GroupMail IN (Select SourceMail from stagingTeamsPilot)
  TenantDomain = 'sourcetenant'
  AND UserMail NOT LIKE '%sourcedomain.com' AND UserMail NOT LIKE '%targetdomain.com' AND UserMail NOT LIKE '%@sourcedomain.onmicrosoft.com'
  AND Usermail <> 'avepointserviceaccount'
  GROUP BY UserID,UserDisplayName,UserMail,UserPrincipalName,TenantDomain,GroupDisplayName
  ORDER BY Usermail

