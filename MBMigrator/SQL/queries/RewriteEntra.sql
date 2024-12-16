SELECT
  ExternalDirectoryObjectID
  ,ExchangeObjectId
  ,Alias
  ,PrimarySmtpAddress
  ,ExternalEmailAddress
  ,RecipientTypeDetails
  ,EmailAddresses
  ,LTRIM(A.value,'smtp:') Address
  , (Alias + '@TARGET.com') ProposedAddress
  , G.onPremisesSyncEnabled
  FROM [Migration].[dbo].[vRecipients_TARGET] R
  OUTER APPLY (SELECT value from string_split(R.emailaddresses,';') WHERE value LIKE '%@rewritedomain.com') A
  LEFT JOIN stagingEntraIDGroup G ON R.ExternalDirectoryObjectID = G.id
  WHERE
  value IS NULL
  AND PrimarySmtpAddress NOT LIKE '%source.com%'
  AND PrimarySmtpAddress LIKE '%target.com'
  and RecipientTypeDetails NOT IN ('GuestMailUser','MailContact','MailUser','UserMailbox','SharedMailbox')
  AND PrimarySmtpAddress NOT LIKE '%other.com'
  AND (Alias + '@rewrite.com') NOT IN (SELECT Address FROM stagingExistingRewrite)
  --AND ExternalDirectoryObjectID IS NOT NULL
  --AND RecipientTypeDetails LIKE '%group%'
  AND onPremisesSyncEnabled IS NULL
  ORDER BY ExchangeObjectId