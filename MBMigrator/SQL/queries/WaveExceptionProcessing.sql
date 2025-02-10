insert WaveExceptions (SourceEntraID,SourceMail,AssignedWave)

select sourceentraId,L.SourceMail,93 AssignedWave
from staticMigrationList L
join stagingNoMFARemoval F
	ON L.sourcemail = F.SourceMail
WHERE F.sourcemail not in (SELECT sourcemail from WaveExceptions)
