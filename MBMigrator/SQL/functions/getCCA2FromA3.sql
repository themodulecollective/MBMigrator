SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER FUNCTION [dbo].[getCCA2FromA3]
(
	@Alpha3 nchar(3)
)
RETURNS nchar(2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Alpha2 nchar(2)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Alpha2 = (SELECT [alpha-2] FROM CT_ISO3166 WHERE [alpha-3] = @Alpha3)

	-- Return the result of the function
	RETURN @Alpha2

END
GO