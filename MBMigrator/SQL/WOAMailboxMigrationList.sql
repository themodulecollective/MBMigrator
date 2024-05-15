SELECT
  dbo.viewMailboxList.Alias
, dbo.viewMailboxList.Name
, dbo.viewMailboxList.DisplayName
, dbo.viewMailboxList.PreferredLastName
, dbo.viewMailboxList.PreferredFirstName
, dbo.viewMailboxList.PrimarySmtpAddress
, dbo.viewMailboxList.UserPrincipalName
, dbo.viewMailboxList.ExchangeGuid
, dbo.viewMailboxList.BusinessUnit
, dbo.viewMailboxList.Department
, CASE
    WHEN dbo.WOAWaveExceptions.NewWave IS NULL THEN dbo.WaveAssignments.AssignedWave
    ELSE dbo.WOAWaveExceptions.NewWave
  END AS AssignedWave
, CASE
    WHEN dbo.WOAWaveExceptions.NewWave IS NULL THEN 'WaveAssignments'
    ELSE 'WaveExceptions'
  END AS WaveAssignmentSource
, dbo.viewMailboxList.ExtensionCustomAttribute2
, dbo.viewMailboxList.TotalItemSizeInGB
, dbo.viewMailboxList.TotalDeletedItemSizeInGB
, dbo.viewMailboxList.ItemCount
, dbo.viewMailboxList.DeletedItemCount
, dbo.viewMailboxList.RemoteRoutingAddress
, dbo.viewMailboxList.RecipientTypeDetails
, dbo.viewMailboxList.ArchiveName
, dbo.viewMailboxList.ArchiveDomain
, dbo.viewMailboxList.ArchiveStatus
, dbo.viewMailboxList.ArchiveState
, dbo.viewMailboxList.RetentionPolicy
, dbo.viewMailboxList.RetainDeletedItemsFor
, dbo.viewMailboxList.WhenCreatedUTC
, dbo.viewMailboxList.EmailAddresses
, dbo.viewMailboxList.LitigationHoldEnabled
, dbo.viewMailboxList.SingleItemRecoveryEnabled
, dbo.viewMailboxList.TargetAddress
, dbo.SpecialHandling.Description AS SpecialHandling
, dbo.viewMailboxList.OrganizationalUnit
FROM
  dbo.viewMailboxList
  LEFT OUTER JOIN dbo.SpecialHandling ON dbo.viewMailboxList.PrimarySmtpAddress = dbo.SpecialHandling.EmailAddress
  LEFT OUTER JOIN dbo.WOAWaveExceptions ON dbo.viewMailboxList.PrimarySmtpAddress = dbo.WOAWaveExceptions.EmailAddress
  LEFT OUTER JOIN dbo.WaveAssignments ON dbo.viewMailboxList.BusinessUnit = dbo.WaveAssignments.BusinessUnit
  AND dbo.viewMailboxList.Department = dbo.WaveAssignments.Department