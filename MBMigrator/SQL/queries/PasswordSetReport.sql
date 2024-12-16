SELECT[SourceADID]
      ,[TargetADID]
      ,[WDEmployeeID]
      ,[SourceADEnabled]
      ,[TargetADEnabled]
      ,[SourcePasswordLastSet]
      ,[TargetPasswordLastSet]
      ,[SourceDisplayName]
      ,[TargetDisplayName]
      ,[SourceMail]
      ,[TargetMail]
      ,[SourceADUPN]
      ,[TargetADUPN]
      ,[AssignedWave]
      ,[TargetDate]
      ,[AssignmentType]
      ,[usageLocation]
      ,[Country]
      ,[Location]
      ,[LocationCountry]
      ,[Region]
      ,[msExchExtensionAttribute20]
      ,[msExchExtensionAttribute21]
      ,[msExchExtensionAttribute22]
      ,[SourceEntraLastSyncTime]
      ,[TargetEntraLastSyncTime]
      ,[SourceEntraLastSigninTime]
      ,[TargetEntraLastSigninTime]
      ,[SourceADDomain]
      ,[TargetADDomain]
      ,[MatchScenario]
      ,[SourceMFARegistered]
      ,[TargetMFARegistered]
      
  FROM [Migration].[dbo].[staticPasswordLastSetReporting]
  Where 
	SourcepasswordLastSet is not null
	AND targetPasswordLastSet IS NOT NULL
	AND TargetADEnabled = 1
	AND CAST(sourcepasswordlastset AS DATE) <> CAST(targetpasswordlastset AS DATE)
	--AND (SourcePasswordLastSet > '11/15/2024'  OR TargetPasswordLastSet > '11/15/2024')

