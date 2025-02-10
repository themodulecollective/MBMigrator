select L.*, M.TargetMail InitialTargetMailMatch, MM.MatchType, MM.IntendedTargetADID, MM.IntendedTargetADUPN, MM.IntendedTargetLastADLogon, MM.IntendedTargetLastEntraLogon, MM.IntendedTargetPasswordExpired,
CASE 
	WHEN MM.IntendedTargetLastADLogon IS NOT NULL AND MM.IntendedTargetPasswordExpired = 0
	THEN 'Active'
	WHEN MM.IntendedTargetLastEntraLogon IS NOT NULL 
	THEN  'Active'
	ELSE 'Inactive'
	END
TargetStatus
from staticMigrationList L
JOIN stagingMatches M ON L.SourceMail = M.SourceMail
JOIN stagingMatchMatches MM ON L.SourceADID = MM.SourceADID
WHERE MatchScenario LIKE 'MatchUpdate'