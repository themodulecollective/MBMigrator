SELECT
    [AssignedWave]
  , COUNT([ExchangeGuid]) AS MailboxCount
  , COUNT(
        CASE
            WHEN [SpecialHandling] IS NOT NULL THEN 1
        END
    ) AS SpecialHandlingCount
  , SUM(CONVERT(FLOAT, [TotalItemSizeInGB])) TotalItemSizeInGB
  , SUM(CONVERT(FLOAT, [TotalDeletedItemSizeInGB])) TotalDeletedItemSizeInGB
  , SUM(CONVERT(bigint, [ItemCount])) TotalItemCount
  , SUM(CONVERT(bigint, [DeletedItemCount])) TotalDeletedItemCount
FROM
    [dbo].[viewMigrationList]
GROUP BY
    AssignedWave