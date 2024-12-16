Insert stagingFlyMapping (Source,Destination)
SELECT SourceMail, TargetMail
FROM 
staticMigrationList L
LEFT join stagingFlyMapping F
ON L.SourceMail = F.Source
WHERE 
(F.Destination IS NULL) AND L.TargetMail IS NOT NULL
AND L.SourceMail NOT IN (SELECT Source FROM stagingFlyMapping)