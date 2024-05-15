SELECT        M.AzureADSync, M.Domain, M.LinkedDomain, M.SamAccountName, M.DisplayName, M.mailnickname, M.Mail, M.LinkedMail, M.PrimarySmtpAddress, M.UserPrincipalName, M.Company, M.Department, M.ObjectGUID,
                         M.LinkedObjectGUID, M.DIV_DESC, M.COST_CTR_DESC, M.BUS_AREA, M.COST_CTR, M.DIV_CODE, M.RecipientTypeDetails, M.POOL_SEGMENT_DESC, M.POOL_SEGMENT, CASE WHEN V.EmailAddress IS NULL
                         THEN 0 ELSE 1 END AS IsVIP, CASE WHEN P.EmailAddress IS NOT NULL THEN P.NewWave WHEN E.EmailAddress IS NOT NULL THEN E.NewWave ELSE BDA.AssignedWave END AS AssignedWave, M.ExchangeGUID,
                         M.enabled, M.DefaultPublicFolderMailbox, M.ExchangeOrg, TRIM(SUBSTRING(M.DisplayName, 1, CHARINDEX(' ', M.DisplayName))) AS GivenName, TRIM(SUBSTRING(M.DisplayName, LEN(M.DisplayName) - (CHARINDEX(' ',
                         REVERSE(M.DisplayName)) - 2), LEN(M.DisplayName))) AS SurName, CASE WHEN M.PrimarySmtpAddress = M.UserPrincipalName THEN 1 ELSE 0 END AS UPNMatchesSMTP, dbo.MaaS360Users.UserUPN AS MaaS360UPN,
                         dbo.MaaS360Users.Email AS MaaS360Email, M.GivenName AS Expr1, M.SurName AS Expr2
FROM            dbo.ADUsersAllMailboxWithDivCostCenter AS M LEFT OUTER JOIN
                         dbo.MaaS360Users ON M.PrimarySmtpAddress = dbo.MaaS360Users.Email LEFT OUTER JOIN
                         dbo.WaveExceptions AS E ON M.PrimarySmtpAddress = E.EmailAddress LEFT OUTER JOIN
                         dbo.BusDivAssignments AS BDA ON M.BUS_AREA = BDA.BUS_AREA AND M.DIV_DESC = BDA.DIV_DESC LEFT OUTER JOIN
                         dbo.PilotUsers AS P ON M.PrimarySmtpAddress = P.EmailAddress LEFT OUTER JOIN
                         dbo.VIPs AS V ON M.PrimarySmtpAddress = V.EmailAddress