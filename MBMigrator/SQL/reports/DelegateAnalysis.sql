SELECT
   W.*
   , Targets
   , Trustees
   , GroupName
   , Department
   , City
FROM
    dbo.WOA W LEFT JOIN dbo.viewMigrationList L
      ON W.ExchangeGUID = L.ExchangeGUID
