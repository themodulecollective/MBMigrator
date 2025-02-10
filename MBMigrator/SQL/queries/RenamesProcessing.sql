select 
WDEmployeeID
, NewDisplayName
, NewAlias
, dbo.getNewSamAccountName(NewFirstName,NewLastName,WDEmployeeID,'Internal') NewSamAccountName
, NewFirstName
, NewLastName
from EURenames