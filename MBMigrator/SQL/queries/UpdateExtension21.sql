select WD.EmployeeID,C.SourcesamAccountname,wd.EmailAddress,L.SourceADDomain,l.SourceADID,L.SourceDC,L.SourceCanonicalName
from stagingCheck4Workday C 
JOIN vStagingWorkday WD ON C.SourcesamAccountname = WD.AEmployeeID1 OR C.SourcesamAccountname = WD.AEmployeeID2
JOIN staticMigrationList L ON C.SourcesamAccountname = L.SourceSAM