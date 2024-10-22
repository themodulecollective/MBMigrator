SELECT
  TOP (100) PERCENT Recipient
, AssignedWave
, COUNT(CONNECTION) AS ConnectionCount
FROM
  (
    SELECT DISTINCT
      P.TargetObjectGUID AS Recipient
    , P.TrusteeObjectGUID AS CONNECTION
    , L.AssignedWave
    FROM
      dbo.viewPermissionsForAnalysis AS P
      INNER JOIN staticMigrationList AS L ON P.TrusteeObjectGUID = L.SourceEntraID
    WHERE
      (P.PermissionType <> 'SendAS')
    UNION
    SELECT DISTINCT
      P.TrusteeObjectGUID AS Recipient
    , P.TargetObjectGUID AS CONNECTION
    , L.AssignedWave
    FROM
      dbo.viewPermissionsForAnalysis AS P
      INNER JOIN staticMigrationList AS L ON P.TargetObjectGUID = L.SourceEntraID
    WHERE
      (P.PermissionType <> 'SendAS')
  ) AS TheSum
WHERE
  (Recipient IS NOT NULL)
GROUP BY
  Recipient
, AssignedWave
ORDER BY
  Recipient
, AssignedWave