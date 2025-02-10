TRUNCATE TABLE staticMigrationList
GO
INSERT INTO
    staticMigrationList (
        SourceEntraID,
        TargetEntraID,
        SourceADID,
        TargetADID,
        SourceConsistency,
        TargetConsistency,
        WDEmployeeID,
        SourceEntraIDEnabled,
        TargetEntraIDEnabled,
        SourceADEnabled,
        TargetADEnabled,
        LeaveStatus,
        SourcePasswordLastSet,
        TargetPasswordLastSet,
        TargetGoodForKerb,
        SourceCanonicalName,
        TargetCanonicalName,
        SourceFirstName,
        TargetFirstName,
        SourceLastName,
        TargetLastName,
        SourceDisplayName,
        TargetDisplayName,
        SourceMail,
        TargetMail,
		TargetRewriteAddress,
        SourceRecipientType,
        TargetRecipientType,
        SourceTargetAddress,
        TargetTargetAddress,
        SourceForwardingSMTPAddress,
        TargetForwardingSMTPAddress,
        SourceAlias,
        TargetAlias,
        SourceSAM,
        TargetSAM,
        SourceADUPN,
        TargetADUPN,
        SourceEntraUPN,
        TargetEntraUPN,
        TargetGuestUPN,
        SpecialHandlingNotes,
        AssignedWave,
        TargetDate,
        AssignmentType,
        SourceLitigationHoldEnabled,
        TargetLitigationHoldEnabled,
        SourceMailboxGB,
        SourceMailboxDeletedGB,
        SourceMailboxItemCount,
        SourceDriveGB,
        SourceDriveURL,
        SourceDriveCount,
        TargetDriveURL,
        WorkFolders,
        usageLocation,
        Country,
        Location,
        LocationCountry,
        Region,
        SourceLicensing,
        TargetLicensing,
        SourceMobileDevices,
        msExchExtensionAttribute16,
        msExchExtensionAttribute17,
        msExchExtensionAttribute18,
        msExchExtensionAttribute20,
        msExchExtensionAttribute21,
        msExchExtensionAttribute22,
        msExchExtensionAttribute23,
        SourceEntraLastSyncTime,
        TargetEntraLastSyncTime,
        SourceEntraLastSigninTime,
        TargetEntraLastSigninTime,
        SourceEntraType,
        TargetEntraType,
        SourceADDomain,
        TargetADDomain,
        SourceDC,
        TargetDC,
        MatchScenario,
        spoitemid,
        MigrationStatus,
        ManagerEmail,
        SourceMFARegistered,
        TargetMFARegistered,
        FlyOneDrive,
        FlyTeamsChat,
        FlyExchange
    )
SELECT DISTINCT
    SEIDU.id SourceEntraID,
    TEIDU.id TargetEntraID,
    SADU.ObjectGUID SourceADID,
    TADU.ObjectGUID TargetADID,
    SADU.[mS-DS-ConsistencyGUID] SourceConsistency,
    TADU.[mS-DS-ConsistencyGUID] TargetConsistency,
    WD.EmployeeID WDEmployeeID,
    SEIDU.accountEnabled SourceEntraIDEnabled,
    TEIDU.accountEnabled TargetEntraIDEnabled,
    SADU.Enabled SourceADEnabled,
    TADU.Enabled TargetADEnabled,
    wd.LeaveStatus,
    SADU.PasswordLastSet SourcePasswordLastSet,
    TADU.PasswordLastSet TargetPasswordLastSet,
    CASE
        WHEN TADU.PasswordLastSet > '11/14/2024' THEN 1
        WHEN TADU.PasswordLastSet <= '11/14/2024' THEN 0
        ELSE NULL
    END TargetGoodForKerb,
    SADU.CanonicalName SourceCanonicalName,
    TADU.CanonicalName TargetCanonicalName,
    SEIDU.givenName SourceFirstName,
    TEIDU.givenName TargetFirstName,
    SEIDU.surname SourceLastName,
    TEIDU.surname TargetLastName,
    SEIDU.displayName SourceDisplayName,
    TEIDU.displayName TargetDisplayName,
    CASE
        WHEN SADU.mail IS NOT NULL THEN SADU.Mail
        WHEN SADU.mail IS NULL
        AND SMB.PrimarySmtpAddress IS NOT NULL THEN SMB.PrimarySmtpAddress
        ELSE NULL
    END SourceMail,
    CASE
        WHEN TADU.mail IS NOT NULL THEN TADU.Mail
        WHEN TADU.mail IS NULL
        AND TMB.PrimarySmtpAddress IS NOT NULL THEN TMB.PrimarySmtpAddress
        ELSE NULL
    END TargetMail,
	A.RequiredAddress TargetTARGETCOM,
    smb.RecipientTypeDetails SourceRecipientType,
    tmb.RecipientTypeDetails TargetRecipientType,
    SMB.TargetAddress SourceTargetAddress,
    TMB.TargetAddress TargetTargetAddress,
    SMB.ForwardingSmtpAddress SourceForwardingSMTPAddress,
    TMB.ForwardingSmtpAddress TargetForwardingSMTPAddress,
    SADU.mailNickname SourceAlias,
    TADU.MailNickName TargetAlias,
    SADU.SamAccountName SourceSAM,
    TADU.SamAccountName TargetSAM,
    SADU.UserPrincipalName SourceADUPN,
    TADU.UserPrincipalName TargetADUPN,
    SEIDU.userPrincipalName SourceEntraUPN,
    TEIDU.userPrincipalName TargetEntraUPN,
    TEXTU.userPrincipalName TargetGuestUPN,
    SH.SpecialHandlingNotes,
    AW.AssignedWave,
    WP.TargetDate,
    AW.AssignmentType,
    CASE SMB.LitigationHoldEnabled
        WHEN 0 THEN 'FALSE'
        WHEN 1 THEN 'TRUE'
    END SourceLitigationHoldEnabled,
    CASE TMB.LitigationHoldEnabled
        WHEN 0 THEN 'FALSE'
        WHEN 1 THEN 'TRUE'
    END TargetLitigationHoldEnabled,
    MBS.TotalItemSizeInGB SourceMailboxGB,
    MBS.TotalDeletedItemSizeInGB SourceMailboxDeletedGB,
    MBS.ItemCount SourceMailboxItemCount,
    SUDD.TotalUsageInGB SourceDriveGB,
    SUDD.DriveURL SourceDriveURL,
    sudd.DriveCount SourceDriveCount,
    TUDD.DriveURL TargetDriveURL,
    WF.WorkFolders AS WorkFolders,
    SEIDU.usageLocation,
    sadu.Country,
    WD.[Location],
    WD.LocationCountry,
    wd.Region,
    SL.LicenseNames SourceLicensing,
    TL.LicenseNames TargetLicensing,
    MD.MobileDevices AS SourceMobileDevices,
    SADU.msExchExtensionAttribute16,
    SADU.msExchExtensionAttribute17,
    SADU.msExchExtensionAttribute18,
    sadu.msExchExtensionAttribute20,
    sadu.msExchExtensionAttribute21,
    sadu.msExchExtensionAttribute22,
    sadu.msExchExtensionAttribute23,
    SEIDU.onPremisesLastSyncDateTime SourceEntraLastSyncTime,
    TEIDU.onPremisesLastSyncDateTime TargetEntraLastSyncTime,
    SEIDU.lastSignInDateTime SourceEntraLastSigninTime,
    TEIDU.lastSignInDateTime TargetEntraLastSigninTime,
    SEIDU.userType SourceEntraType,
    TEIDU.userType TargetEntraType,
    SADU.DomainName SourceADDomain,
    TADU.DomainName TargetADDomain,
    CASE SADU.DomainName
        WHEN 'd1' THEN 'dc.d1'
        WHEN 'd2' THEN 'dc.d2'
        WHEN 'd3' THEN 'dc.d3'
        ELSE NULL
    END AS SourceDC,
    'targetdc' AS TargetDC,
    CASE
        WHEN M.WDEmployeeID IS NOT NULL
        AND SADU.msExchExtensionAttribute20 IS NULL THEN 'MatchUpdate'
        WHEN M.WDEmployeeID IS NOT NULL
        AND SADU.msExchExtensionAttribute21 = M.WDEmployeeID
        AND (
            SADU.msExchExtensionAttribute20 <> 'BT_MatchUpdate'
            OR SADU.msExchExtensionAttribute20 IS NULL
        ) THEN 'MatchUpdate'
        WHEN SADU.msExchExtensionAttribute20 = 'BT_Sync'
        AND SADU.msExchExtensionAttribute21 = TADU.EmployeeID
        AND SADU.msExchExtensionAttribute21 = TADU.msExchExtensionAttribute21 THEN 'CreatedSynced'
        WHEN SADU.msExchExtensionAttribute21 = TADU.msExchExtensionAttribute21
        AND SADU.msExchExtensionAttribute20 = 'BT_MatchUpdate' THEN 'MatchSynced'
        WHEN SADU.msExchExtensionAttribute20 = 'BT_MatchOnly'
        AND SADU.msExchExtensionAttribute21 = TADU.EmployeeID THEN 'MatchOnly'
    END AS MatchScenario,
    spo.id SPOItemID,
    spo.MigrationStatus,
    wd.ManagerEmail,
    RS.isMfaRegistered SourceMFARegistered,
    RT.isMfaRegistered TargetMFARegistered,
    FOD.ProjectName FlyOneDrive,
    FTC.ProjectName FlyTeamsChat,
    FEX.ProjectName FlyExchange
    --INTO staticMigrationList
FROM
    vEntraIDUsers_SOURCE SEIDU
    LEFT JOIN vADUsers_SOURCE SADU ON SEIDU.ConsistencyGUID = sadu.[mS-DS-ConsistencyGUID]
    LEFT JOIN vADUsers_TARGET TADU ON (
        SADU.msExchExtensionAttribute22 = TADU.msExchExtensionAttribute22
    )
    OR (
        SADU.msExchExtensionAttribute21 = TADU.msExchExtensionAttribute21
        AND SADU.msExchExtensionAttribute21 = TADU.EmployeeID
    )
    LEFT JOIN vEntraIDUsers_TARGET TEIDU ON TEIDU.ConsistencyGUID = TADU.[mS-DS-ConsistencyGUID]
    LEFT JOIN vMailboxes_SOURCE SMB ON SEIDU.id = SMB.ExternalDirectoryObjectID
    LEFT JOIN vMailboxes_TARGET TMB ON TEIDU.id = TMB.ExternalDirectoryObjectID
    LEFT JOIN stagingMailboxStats MBS ON Smb.ExchangeGuid = mbs.MailboxGuid
	LEFT JOIN vMailboxPrimaryAddress_TARGET A ON TEIDU.id = A.ExternalDirectoryObjectID
    LEFT JOIN vStagingWorkday WD ON SEIDU.Mail = WD.EmailAddress
    OR (
        SEIDU.employeeId = WD.AEmployeeID1
        OR SEIDU.employeeId = WD.AEmployeeID2
    )
    LEFT JOIN vAssignedWave AW ON SEIDU.id = AW.id
    LEFT JOIN vUserDriveDetail SUDD ON SUDD.[Owner] = SEIDU.userPrincipalName
    LEFT JOIN vUserDriveDetail TUDD ON TUDD.[Owner] = TEIDU.userPrincipalName
    LEFT JOIN vWorkFolders WF ON WF.Email = SEIDU.mail
    LEFT JOIN stagingUserLicensing SL ON SL.ID = SEIDU.id
    LEFT JOIN stagingUserLicensing TL ON TL.ID = TEIDU.id
    LEFT JOIN vMobileOSDevicesPerSOURCEUser MD ON SEIDU.id = MD.userID
    LEFT JOIN vEntraIDUsers_TARGET TEXTU ON SEIDU.mail = TEXTU.mail
    LEFT JOIN vSpecialHandling SH ON SEIDU.mail = SH.SourceMail
    LEFT JOIN stagingSPOUserMigrationListIDs spo ON spo.SourceEntraID = SEIDU.id OR spo.SourceADID = SADU.ObjectGUID
    LEFT JOIN stagingMatches M ON smb.PrimarySmtpAddress = M.SourceMail
    LEFT JOIN stagingWavePlan WP ON AW.AssignedWave = Wp.Wave
    LEFT JOIN stagingUserRegistrationDetail RS ON SEIDU.id = RS.id
    LEFT JOIN stagingUserRegistrationDetail RT ON TEIDU.id = RT.id
    LEFT JOIN vFlyOneDrive FOD ON SEIDU.userPrincipalName = FOD.Source
    LEFT JOIN vFlyTeamsChat FTC ON SEIDU.userPrincipalName = FTC.Source
    OUTER APPLY (
        SELECT
            TOP 1 ProjectName
        FROM
            vFlyExchangeByAnyAddress FEX
        WHERE
            SEIDU.id = FEX.ExternalDirectoryObjectID
    ) FEX
WHERE
    (
        SL.LicenseNames IS NOT NULL
        OR SMB.RecipientTypeDetails IS NOT NULL
        OR SADU.msExchExtensionAttribute23 = 'Resource'
    )
    AND (
        TADU.SamAccountName NOT LIKE 'adminprefix_%'
        OR TADU.SamAccountName IS NULL
    )
    AND (
        SADU.SamAccountName NOT LIKE 'AA%'
        OR SADU.SamAccountName IS NULL
    )
    AND (
        SADU.SamAccountName NOT LIKE '[_]%'
        OR SADU.SamAccountName IS NULL
    )
    AND (
        SEIDU.userPrincipalName NOT LIKE '%admin@sourcedomain.onmicrosoft.com'
    )