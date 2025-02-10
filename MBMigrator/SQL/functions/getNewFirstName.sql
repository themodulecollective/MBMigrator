SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Description:	gets or calculates New FirstName
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[getNewFirstName]
(
	-- Add the parameters for the function here
	@GivenName nvarchar(255)
	,@WDEmployeeID nvarchar(12)
	,@OtherType nvarchar(10) NULL
)
RETURNS nvarchar(255)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(255)

	IF @WDEmployeeID IN (SELECT EmployeeID FROM CT_UserExceptions) --EmployeeID Is in the CT_UserExceptions Table so we use the Exception values
        BEGIN
            SELECT @Result = (SELECT NewFirstName FROM CT_UserExceptions WHERE EmployeeID = @WDEmployeeID)
        END
	ELSE -- EmployeeID was not in the CT_UserExceptions Table so we calculate the values
	IF @OtherType = 'Resource'
		BEGIN
			SELECT @Result = @GivenName
		END
	ELSE
        BEGIN
            SELECT @Result = (SELECT dbo.ProperCase(RTRIM(@GivenName,'-123456789')))
        END
	-- Return the result of the function
	RETURN @Result
END
GO


