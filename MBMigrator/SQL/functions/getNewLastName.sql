SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Description:	gets or calculates New lastName
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[getNewLastName]
(
	-- Add the parameters for the function here
	@SurName nvarchar(255)
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
            SELECT @Result = (SELECT NewLastName FROM CT_UserExceptions WHERE EmployeeID = @WDEmployeeID)
        END
	ELSE -- EmployeeID was not in the CT_UserExceptions Table so we calculate the values
	IF @OtherType = 'Resource'
		BEGIN
			SELECT @Result = @SurName
		END
	ELSE
        BEGIN
            SELECT @Result = (SELECT dbo.ProperCase(@SurName))
        END
	-- Return the result of the function
	RETURN @Result
END
GO


