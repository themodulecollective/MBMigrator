Select 
	L.*
	,M.MatchType
	,M.IntendedTargetADID
	,M.IntendedTargetADUPN
	,CASE 
	WHEN m.IntendedTargetLastADLogon IS NOT NULL AND m.IntendedTargetPasswordExpired = 0 THEN 'Active'
	WHEN m.IntendedTargetLastEntraLogon IS NOT NULL THEN 'Active'
	ELSE 'Inactive'
	END IntendedTargetStatus
	,m.IntendedTargetLastADLogon
	,m.IntendedTargetLastEntraLogon
	,m.IntendedTargetPasswordExpired
FROM staticMigrationList l
LEFT JOIN stagingMatchMatches M ON L.SourceADID = M.SourceADID
WHERE L.MatchScenario LIKE 'Match%'
