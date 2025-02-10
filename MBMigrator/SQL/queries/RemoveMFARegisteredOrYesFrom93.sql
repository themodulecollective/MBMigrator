DELETE FROM WaveExceptions WHERE SourceEntraID IN (
select SourceEntraID from staticMigrationList 
where 
AssignedWave = 93
AND ((TargetMFARegistered = 1 OR SourceMFARegistered = 1)
OR SourceMail in (SELECT Yes from stagingMFAYes))) AND AssignedWave = 93