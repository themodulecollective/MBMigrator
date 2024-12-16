USE [Migration]
GO

SELECT G.ID EntraID,g.mail,g.onPremisesSyncEnabled

  FROM [dbo].[vPermissionsReport] P
  JOIN stagingEntraIDGroup G 
  ON P.TrusteePrimarySMTPAddress = G.mail
  WHERE TrusteeRecipientTypeDetails LIKE '%group%'
  GROUP BY G.id,g.mail,g.onPremisesSyncEnabled
GO


