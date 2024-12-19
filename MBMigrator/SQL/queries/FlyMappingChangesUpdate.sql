UPDATE stagingFlyMapping 
set Source = L.SourceMail, Destination = L.TargetMail
FROM 
staticMigrationList L
LEFT join stagingFlyMapping F
ON L.SourceMail = F.Source
WHERE L.TargetMail <> F.Destination