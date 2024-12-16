SELECT
    dbo.WOA.*,
    Targets,
    Trustees
FROM
    dbo.WOA
    LEFT OUTER JOIN vTrusteesSummaryForMigrationList ON dbo.WOA.EntraID = vTrusteesSummaryForMigrationList.SourceEntraID
    LEFT OUTER JOIN vTargetsSummaryForMigrationList ON dbo.WOA.EntraID = vTargetsSummaryForMigrationList.SourceEntraID
