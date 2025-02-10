SELECT
	l.SourceADID
	, l.SourceRecipientType
	, l.TargetRecipientType
	, l.SourceAlias
	, l.TargetAlias
	, l.SourceADUPN
	, l.TargetADUPN
	, smu.RecipientTypeDetails SOPRecipientType
	, smu.ExternalEmailAddress SOPExternal
	, smu.PrimarySmtpAddress   SOPPrimary
	, tmu.RecipientTypeDetails TOPRecipientType
	, tmu.ExternalEmailAddress TOPExternal
	, tmu.PrimarySmtpAddress   TOPPrimary
--	, SUBSTRING(l.sourcemail, 1, CHARINDEX('@', l.sourcemail) - 1) + '@sourcedomain.com' setPrimary
--	, SUBSTRING(l.sourcemail, 1, CHARINDEX('@', l.sourcemail) - 1) + '@sourcedomain.mail.onmicrosoft.com' setTarget
--	, SUBSTRING(l.sourcemail, 1, CHARINDEX('@', l.sourcemail) - 1) setAlias
	, smu.EmailAddresses
FROM staticMigrationList L
LEFT JOIN stagingmailusers SMU
	ON SMU.ObjectGUID = L.SourceADID
LEFT JOIN stagingmailusers TMU
	ON TMU.ObjectGUID = l.TargetADID
WHERE L.SourceADID IS NOT NULL AND L.TargetADID IS NOT NULL
	AND tmu.PrimarySmtpAddress IS NULL OR tmu.RecipientTypeDetails IS NULL
	and smu.RecipientTypeDetails IS NOT NULL
--ORDER BY SOPRecipientType
