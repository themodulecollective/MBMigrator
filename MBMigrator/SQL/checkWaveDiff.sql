SELECT
    NW.ExchangeGUID,
    NW.PrimarySmtpAddress,
    NW.Department NewDepartment,
    OW.Department OldDepartment,
    NW.AssignedWave NewWave,
    OW.AssignedWave OldWave
FROM
    dbo.MigrationList NW
    JOIN dbo.MigrationListStatic OW ON NW.ExchangeGUID = OW.ExchangeGUID
WHERE
    NW.AssignedWave <> OW.AssignedWave
ORDER BY NW.ExchangeGUID