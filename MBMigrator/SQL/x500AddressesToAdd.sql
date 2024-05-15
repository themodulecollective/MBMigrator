USE [Migration]
GO

SELECT
	Alias
	,PrimarySmtpAddress
	,DistinguishedName
	,LegacyExchangeDN
	,('x500:' + LegacyExchangeDN) AS Newx500ProxyAddress
	,RecipientType
	,RecipientTypeDetails
FROM [dbo].[IncomingMailboxes]
WHERE DistinguishedName LIKE N'%OU=Quest Collaboration Services Objects%'


GO
