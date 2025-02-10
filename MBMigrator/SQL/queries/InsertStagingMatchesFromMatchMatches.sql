INSERT stagingMatches (WDEmployeeID,SourceMail,TargetMail)

SELECT
	[WDEmployeeID]
	, SADU.Mail SourceMail
	, TADU.Mail TargetMail
      --,[SourceADUPN]
      --,[SourceADID]
      --,[MatchType]
      --,[IntendedTargetADID]
      --,[IntendedTargetADUPN]
      --,[IntendedTargetLastADLogon]
      --,[IntendedTargetPasswordExpired]
      --,[IntendedTargetLastEntraLogon]
  FROM [Migration].[dbo].[stagingMatchMatches] MM
  JOIN stagingADUser SADU
  ON MM.SourceADID = SADU.ObjectGUID
  JOIN stagingADUser TADU
  ON MM.IntendedTargetADID = TADU.ObjectGUID
  WHERE WDEmployeeID NOT IN (SELECT WDEmployeeID FROM stagingMatches)

