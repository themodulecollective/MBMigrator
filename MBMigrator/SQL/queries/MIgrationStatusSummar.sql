SELECT  count(sourceentraid) UserCount
      ,[MigrationStatus]
  FROM [Migration].[dbo].[vMigrationStatusPerUser]
  Group By MigrationStatus
