SELECT
   W.*
   , Targets
   , Trustees
   , GroupName
   , Department
   , City
FROM
    dbo.WOA W LEFT JOIN dbo.viewMailboxMigrationList L
      ON W.ExchangeGUID = L.ExchangeGUID
