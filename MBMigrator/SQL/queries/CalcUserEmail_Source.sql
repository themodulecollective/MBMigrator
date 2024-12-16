DECLARE @Domain NVARCHAR(9)
SELECT @domain = '@suffix.com'

SELECT
	R.RecipientTypeDetails
	, U.DomainName
	, U.GivenName CurrentGivenName
	, CASE
		--dup
		WHEN U.GivenName LIKE '%[1-9]'
			THEN RTRIM(U.GivenName, '-123456789')
		--no dup
		ELSE U.GivenName
		END AS NewGivenName
	, U.Surname CurrentSurname
	, dbo.ToProperCase(U.Surname) AS NewSurname
	, U.SamAccountName CurrentSamAccountName
	, R.Alias CurrentEmailAlias
	, CASE
		--External Not Dup
		WHEN (R.PrimarySmtpAddress LIKE '%.ext@%' OR R.PrimarySmtpAddress LIKE '%@external.%') AND R.PrimarySmtpAddress NOT LIKE '%[1-9]%'
			THEN LOWER(U.GivenName) + '.' + LOWER(U.Surname) + '.ext'
		--External with Dup
		WHEN (R.PrimarySmtpAddress LIKE '%.ext@%' OR R.PrimarySmtpAddress LIKE '%@external.%') AND U.GivenName LIKE '%-[1-9]'
			THEN LOWER(RTRIM(U.GivenName, '-[1-9]')) + '.' + LOWER(U.Surname) + RIGHT(U.GivenName, 1) + '.ext'
		-- Not External with Dup
		WHEN (R.PrimarySmtpAddress LIKE '%[1-9]%')
			THEN LOWER(RTRIM(U.GivenName, '-123456789')) + '.' + LOWER(U.Surname) + RIGHT(U.GivenName, 1)
		-- Not External Not Dup
		ELSE LOWER(U.GivenName) + '.' + LOWER(U.Surname)
		END AS NewEmailAlias
	, W.WEmployeeID NewSamAccountName
	, R.PrimarySmtpAddress CurrentEmail
	, CASE
		--External Not Dup
		WHEN (R.PrimarySmtpAddress LIKE '%.ext@%' OR R.PrimarySmtpAddress LIKE '%@external.%') AND R.PrimarySmtpAddress NOT LIKE '%[1-9]%'
			THEN LOWER(U.GivenName) + '.' + LOWER(U.Surname) + '.ext' + @domain
		--External with Dup
		WHEN (R.PrimarySmtpAddress LIKE '%.ext@%' OR R.PrimarySmtpAddress LIKE '%@external.%') AND U.GivenName LIKE '%-[1-9]'
			THEN LOWER(RTRIM(U.GivenName, '-[1-9]')) + '.' + LOWER(U.Surname) + RIGHT(U.GivenName, 1) + '.ext@targetdomain.com'
		-- Not External with Dup
		WHEN (R.PrimarySmtpAddress LIKE '%[1-9]%')
			THEN LOWER(RTRIM(U.GivenName, '-123456789')) + '.' + LOWER(U.Surname) + RIGHT(U.GivenName, 1) + '@targetdomain.com'
		-- Not External Not Dup
		ELSE LOWER(U.GivenName) + '.' + LOWER(U.Surname) + @domain
		END AS NewEmailAndUsername
	  , U.DisplayName CurrentDisplayName
	, CASE
		--External Not Dup
		WHEN (R.PrimarySmtpAddress LIKE '%.ext@%' OR R.PrimarySmtpAddress LIKE '%@external.%') AND R.PrimarySmtpAddress NOT LIKE '%[1-9]%'
			THEN dbo.toProperCase(U.Surname) + ', ' + U.GivenName + ' (EXT)'
		--External with Dup
		WHEN (R.PrimarySmtpAddress LIKE '%.ext@%' OR R.PrimarySmtpAddress LIKE '%@external.%') AND U.GivenName LIKE '%-[1-9]'
			THEN dbo.toProperCase(U.Surname) + ', ' + RTRIM(U.GivenName, '-123456789') + ' (' + RIGHT(U.GivenName,1) + ') ' + '(EXT)'
		-- Not External with Dup
		WHEN (R.PrimarySmtpAddress LIKE '%[1-9]%')
			THEN dbo.toProperCase(U.Surname) + ', ' + RTRIM(U.GivenName, '-123456789') + ' (' + RIGHT(U.GivenName,1) + ')'
		-- Not External Not Dup
		ELSE 	  dbo.toProperCase(U.Surname) + ', ' + U.GivenName
		END	 AS NewDisplayName
	  --, U.*
	  --, U.msExchExtensionAttribute20
	  --, U.msExchExtensionAttribute21
	  --, U.msExchExtensionAttribute22
	  --, U.msExchExtensionAttribute23
FROM       vRecipients_SOURCE R
				INNER JOIN vADUsers_SOURCE U
				  ON R.PrimarySmtpAddress = U.Mail
				INNER JOIN vSourceUserWorkMail W
				  ON W.ADEmployeeID = U.EmployeeID
WHERE
	--R.PrimarySmtpAddress LIKE '%[1-9]%'
	--AND
	R.RecipientTypeDetails = 'UserMailbox'
	AND
	r.PrimarySmtpAddress LIKE '%-%@%'

	ORDER BY CurrentSurname



	-- Affected Attributes:  CN, DisplayName,GivenName,