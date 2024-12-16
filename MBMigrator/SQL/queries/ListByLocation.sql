SELECT Count(WDEmployeeID) UserCount, Location
from staticMigrationList
GROUP BY Location
ORDER BY UserCount DESC