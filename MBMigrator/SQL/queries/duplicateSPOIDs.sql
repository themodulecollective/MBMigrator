select l.sourceadid, count(sl.id) IDCount, STRING_AGG(sl.id,'|')
FROM
	staticMigrationList L
		LEFT JOIN 
	stagingSPOUserMigrationListIDs SL
		ON l.SourceADID = sl.SourceADID

GROUP BY l.SourceADID

having count(sl.id) > 1
