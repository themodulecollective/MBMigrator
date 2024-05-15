--without NULLS
SELECT
  AssignedWave
FROM
  viewMailboxMigrationList
WHERE
  AssignedWave IS NOT NULL
GROUP BY
  AssignedWave
  --with NULLS
SELECT
  AssignedWave
FROM
  viewMailboxMigrationList
GROUP BY
  AssignedWave


