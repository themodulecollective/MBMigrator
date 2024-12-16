SELECT  UGRH.*
	, L.TargetEntraUPN
  FROM [Migration].[dbo].[stagingUGRoleHolder] UGRH
  JOIN staticMigrationList L
	ON UGRH.UserMail = L.SourceMail
  WHERE L.AssignedWave IN (16,17)
  AND TenantDomain = 'SourceDomain'	