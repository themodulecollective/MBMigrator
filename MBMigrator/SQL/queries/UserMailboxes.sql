SELECT M.DisplayName, M.Alias, M.PrimarySmtpAddress, EU.employeeId

  FROM [Migration].[dbo].[vMailboxes_TARGET] M
  JOIN vEntraIDUsers_TARGET EU
	ON M.ExternalDirectoryObjectID = EU.id

  WHERE M.RecipientTypeDetails = 'UserMailbox'
  AND EU.employeeId IS NOT NULL

