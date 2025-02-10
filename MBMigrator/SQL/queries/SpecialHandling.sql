SELECT     SourceMail, EmployeeID, STRING_AGG(Note,' | ') WITHIN GROUP ( ORDER BY Note ASC) SpecialHandlingNotes
FROM        dbo.stagingSpecialHandling
GROUP BY  SourceMail, EmployeeID
