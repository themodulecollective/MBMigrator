SELECT
    count([TargetObjectGUID]) AS PermCount,
    [PermissionType],
    [TrusteeIdentity],
    [TrusteePrimarySMTPAddress] INTO IgnoredPermissionTrustees
FROM
    [Migration].[dbo].[Permissions]
WHERE
    PermissionType <> 'SendAs'
GROUP BY
    PermissionType,
    TrusteePrimarySMTPAddress,
    TrusteeIdentity
HAVING
    count([TargetObjectGUID]) > 100
ORDER BY
    count([TargetObjectGUID]) DESC