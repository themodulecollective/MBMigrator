TRUNCATE TABLE stagingMailboxAddresses;
INSERT stagingMailboxAddresses
SELECT 
	SourceOrganization
	,ExternalDirectoryObjectID
	,ExchangeObjectId
	,Ltrim(Split.value,'smtp:') Address
	, CASE 
		WHEN Split.value LIKE 'SMTP:%' COLLATE latin1_General_CS_AS THEN 'Primary' 
		WHEN Split.value LIKE 'smtp:%' COLLATE latin1_General_CS_AS THEN 'Alias' 
	END Type
FROM stagingMailbox M 
CROSS APPLY string_split(M.EmailAddresses,';') Split
WHERE Split.value LIKE 'smtp:%'
UNION
SELECT 
	SourceOrganization
	,ExternalDirectoryObjectID
	,ExchangeObjectId
	,UserPrincipalName Address
	,'UserPrincipalName' Type
FROM stagingMailbox

;


