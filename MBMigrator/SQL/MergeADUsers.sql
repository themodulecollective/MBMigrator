MERGE dbo.ADUsers AS Target USING [dbo].[IncomingADUsers] AS Source ON (Target.ObjectGUID = Source.ObjectGUID)
WHEN MATCHED THEN
UPDATE
SET
    [DomainName] = Source.[DomainName],
    [Name] = Source.[Name],
    [DisplayName] = Source.[DisplayName],
    [SamAccountName] = Source.[SamAccountName],
    [UserPrincipalName] = Source.[UserPrincipalName],
    [mailnickname] = Source.[mailnickname],
    [Mail] = Source.[Mail],
    [ProxyAddresses] = Source.[ProxyAddresses],
    [AzureADSync] = Source.[AzureADSync],
    [DistinguishedName] = Source.[DistinguishedName],
    [mS-DS-ConsistencyGUID] = Source.[mS-DS-ConsistencyGUID],
    [SID] = Source.[SID],
    [msExchMailboxGuid] = Source.[msExchMailboxGuid],
    [msExchMasterAccountSID] = Source.[msExchMasterAccountSID],
    [Company] = Source.[Company],
    [Department] = Source.[Department],
    [Enabled] = Source.[Enabled],
    [ObjectClass] = Source.[ObjectClass],
    [objectSID] = Source.[objectSID],
    [GivenName] = Source.[GivenName],
    [Surname] = Source.[Surname]
WHEN NOT MATCHED BY TARGET THEN
    INSERT
        (
            [DomainName],
            [Name],
            [DisplayName],
            [SamAccountName],
            [UserPrincipalName],
            [mailnickname],
            [Mail],
            [ProxyAddresses],
            [AzureADSync],
            [DistinguishedName],
            [ObjectGUID],
            [mS-DS-ConsistencyGUID],
            [SID],
            [msExchMailboxGuid],
            [msExchMasterAccountSID],
            [Company],
            [Department],
            [Enabled],
            [ObjectClass],
            [objectSID],
            [GivenName],
            [Surname]
        )
    VALUES
        (
            Source.[DomainName],
            Source.[Name],
            Source.[DisplayName],
            Source.[SamAccountName],
            Source.[UserPrincipalName],
            Source.[mailnickname],
            Source.[Mail],
            Source.[ProxyAddresses],
            Source.[AzureADSync],
            Source.[DistinguishedName],
            Source.[ObjectGUID],
            Source.[mS-DS-ConsistencyGUID],
            Source.[SID],
            Source.[msExchMailboxGuid],
            Source.[msExchMasterAccountSID],
            Source.[Company],
            Source.[Department],
            Source.[Enabled],
            Source.[ObjectClass],
            Source.[objectSID],
            Source.[GivenName],
            Source.[Surname]
        )
WHEN NOT MATCHED BY SOURCE THEN DELETE

OUTPUT $action,
DELETED.ObjectGUID AS DeletedTargetObjectGUID,
DELETED.UserPrincipalName AS DeletedTargetUserPrincipalName,
DELETED.objectSID AS DeletedTargetObjectSID,
INSERTED.ObjectGUID AS InsertedTargetObjectGUID,
INSERTED.UserPrincipalName AS InsertedTargetUserPrincipalName,
INSERTED.objectSID AS InsertedTargetObjectSID;