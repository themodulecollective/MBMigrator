SELECT
    COUNT(PermissionIdentity) AS PermissionCount
    , TrusteeExchangeGUID
    , TrusteeIdentity
    , TrusteePrimarySMTPAddress
    , PermissionType
FROM [dbo].[stagingPermissions]
WHERE
    TrusteeExchangeGUID IS NOT NULL
    AND PermissionType = @permissionType
GROUP BY TrusteeExchangeGUID, TrusteeIdentity, TrusteePrimarySMTPAddress, PermissionType
ORDER BY PermissionCount DESC