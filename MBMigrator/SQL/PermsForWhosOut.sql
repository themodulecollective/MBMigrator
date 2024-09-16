SELECT
    [PermissionIdentity],
    [SourceExchangeOrganization],
    [TargetPrimarySMTPAddress],
    [TargetRecipientTypeDetails],
    [PermissionType],
    [AssignmentType],
    [IsInherited],
    [TrusteePrimarySMTPAddress],
    [TrusteeRecipientTypeDetails]
FROM
    [dbo].[Permissions] P
    JOIN (
        SELECT
            PrimarySMTPAddress
        FROM
            MigrationList
        WHERE
            AssignedWave = '1.2'
    ) M ON P.TargetPrimarySMTPAddress = M.PrimarySmtpAddress
    JOIN (
        SELECT
            PrimarySMTPAddress
        FROM
            MigrationList
        WHERE
            AssignedWave <> '1.2'
            AND RecipientTypeDetails <> 'RemoteUserMailbox'
    ) NM ON P.TrusteePrimarySMTPAddress = NM.PrimarySmtpAddress
WHERE
    AssignmentType = 'Direct'
    --AND TrusteePrimarySMTPAddress NOT IN @() #list of accounts to ignore because they have too many permissions