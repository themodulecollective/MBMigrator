select L.*
from staticMigrationList L
join stagingWave4NoMFARemoval F
	ON L.sourcemail = F.SourceMail
--WHERE F.sourcemail not in (SELECT sourcemail from WaveExceptions)
