SELECT
  TOP (100) PERCENT Recipient
, AssignedWave
, COUNT(CONNECTION) AS ConnectionCount
FROM
  (
    SELECT DISTINCT
      P.TargetObjectExchangeGUID AS Recipient
    , P.TrusteeExchangeGUID AS CONNECTION
    , L.AssignedWave
    FROM
      dbo.viewPermissionsForAnalysis AS P
      INNER JOIN dbo.viewWOAMigrationList AS L ON P.TrusteeExchangeGUID = L.ExchangeGuid
    WHERE
      (P.PermissionType <> 'SendAS')
    UNION
    SELECT DISTINCT
      P.TrusteeExchangeGUID AS Recipient
    , P.TargetObjectExchangeGUID AS CONNECTION
    , L.AssignedWave
    FROM
      dbo.viewPermissionsForAnalysis AS P
      INNER JOIN dbo.viewWOAMigrationList AS L ON P.TargetObjectExchangeGUID = L.ExchangeGuid
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