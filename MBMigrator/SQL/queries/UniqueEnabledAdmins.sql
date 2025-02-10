SELECT EmployeeID, count(EmployeeID) AS AdminAccountCount
  FROM [Migration].[dbo].[stagingADUser]
  where DomainName IN ('dc1','dc2') AND SamAccountName LIKE 'AA%' AND Enabled = 1
  Group BY EmployeeID

