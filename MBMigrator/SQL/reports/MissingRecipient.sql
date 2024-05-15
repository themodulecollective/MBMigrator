SELECT
      OPR.[ExchangeGuid]
      ,OPR.[Guid]
      ,OPR.[Alias]
      ,OPR.[DisplayName]
      ,OPR.[PrimarySmtpAddress]
      ,OPR.[RecipientType]
      ,OPR.[RecipientTypeDetails]
      ,OPR.[Department]
      ,OPR.[Company]
      ,OPR.[Office]
      ,OPR.[City]
      ,OPR.[DistinguishedName]
      ,OPR.[Manager]
      ,OPR.[WhenCreatedUTC]
      ,OPR.[WhenChangedUTC]

  FROM [dbo].[stagingRecipientOP] OPR
  LEFT JOIN stagingRecipientOL OLR ON OPR.PrimarySmtpAddress = OLR.PrimarySmtpAddress
  WHERE OLR.PrimarySmtpAddress IS NULL
  AND OPR.RecipientTypeDetails <> 'DynamicDistributionGroup'
