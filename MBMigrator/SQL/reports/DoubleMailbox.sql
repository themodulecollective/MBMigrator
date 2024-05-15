SELECT
    dbo.stagingMailboxOP.DisplayName
  , dbo.stagingMailboxOP.Name
  , dbo.stagingMailboxOP.ExchangeGuid AS OPExchangeGUID
  , dbo.stagingMailboxOP.RecipientTypeDetails AS OPRecipientType
  , dbo.stagingMailboxOP.PrimarySmtpAddress AS OPPrimarySMTP
  , dbo.stagingMailboxOP.WhenCreatedUTC AS OPWhenCreatedUTC
  , dbo.stagingMailboxOL.ExchangeGuid AS OLExchangeGUID
  , dbo.stagingMailboxOL.RecipientTypeDetails AS OLRecipientType
  , dbo.stagingMailboxOL.PrimarySmtpAddress AS OLPrimarySMTP
  , dbo.stagingMailboxOP.WhenCreatedUTC AS OLWhenCreatedUTC
FROM
    dbo.stagingMailboxOL
    INNER JOIN dbo.stagingMailboxOP ON dbo.stagingMailboxOL.PrimarySmtpAddress = dbo.stagingMailboxOP.PrimarySmtpAddress
WHERE
    (
        dbo.stagingMailboxOP.RecipientTypeDetails NOT LIKE 'Remote%'
    )