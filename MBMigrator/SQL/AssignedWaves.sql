--without NULLS
SELECT
  AssignedWave
FROM
  viewMigrationList
WHERE
  AssignedWave IS NOT NULL
GROUP BY
  AssignedWave
  --with NULLS
SELECT
  AssignedWave
FROM
  viewMigrationList
GROUP BY
  AssignedWave


