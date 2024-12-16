SELECT ID FROM spoListItems WHERE SourceEntraID IN (

SELECT 
    LI.[SourceEntraID]
    --,count([sourceEntraID]) EntryCount
  FROM [Migration].[dbo].[spoListItems] LI
  GROUP BY SourceEntraID
  HAVING count(LI.id) > 1
  )