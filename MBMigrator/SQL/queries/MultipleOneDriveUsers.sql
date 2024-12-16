SELECT  [Owner]
            ,Count([Url]) DriveCount

  FROM [Migration].[dbo].[stagingUserDriveDetail] 
  Group By Owner
  having count(url) > 1
  ORDER BY DriveCount desc
  
