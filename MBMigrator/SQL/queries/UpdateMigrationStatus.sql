SELECT * FROM (Select
L.WDEmployeeID,L.SourceEntraID,L.spoitemid,L.AssignedWave,L.AssignmentType,L.FlyExchange UserFlyExchange,P.FlyExchange PlanFlyExchange
,
CASE
	WHEN CAST(P.TargetDate as date) <= CAST(GETDATE() as date) -- today is past the target date
		AND P.FlyExchange = L.FlyExchange
		THEN '4 - Completed'
	WHEN CAST(P.TargetDate as date) > CAST(GETDATE() as date) --today is after the target date
		AND P.FlyExchange = L.FlyExchange
		THEN '1 - Scheduled'
	WHEN CAST(P.TargetDate as date) > CAST(GETDATE() as date) --today is after the target date
		AND (P.FlyExchange <> L.FlyExchange OR L.FlyExchange IS NULL)
		THEN '1 - Scheduling'
	WHEN CAST(P.TargetDate as date) <= CAST(GETDATE() as date) -- today is past the target date
		AND (P.FlyExchange <> L.FlyExchange OR L.FlyExchange IS NULL)
		THEN '5 - Pending Wave Assignment'
	WHEN AssignedWave IS NULL THEN '5 - Pending Wave Assignment'
	WHEN AssignedWave > 90 AND AssignedWave  < 99 THEN '2 - Issue'
	WHEN AssignedWave = 99 THEN '3 - Not Migrating'
END MigrationStatus
From staticMigrationList L
LEFT JOIN stagingWavePlan P
	ON L.AssignedWave = P.Wave
WHERE L.spoitemid IS NOT NULL) AS I
