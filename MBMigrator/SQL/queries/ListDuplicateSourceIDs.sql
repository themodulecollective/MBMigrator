SELECT 
           [SourceADID],SourceADUPN
		   , Count([sourceadid]) As ConCount
		     FROM [Migration].[dbo].[staticMigrationList]
  group by sourceADID,SourceADUPN
  having count(targetadid) > 1

SELECT SPOItemID,SourceADUPN,TargetADUPN
,count(sourceadid) as DupCount
FROM staticMigrationList
Group by SPOItemID,SourceADUPN,TargetADUPN
having count(sourceadid) > 1