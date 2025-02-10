SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Description:	gets or calculates Firstname.Lastname for email Alias/UPN Prefix
-- =============================================
CREATE OR ALTER   FUNCTION [dbo].[getNewAlias]
(
	-- Add the parameters for the function here
	@GivenName nvarchar(255)
	,@SurName nvarchar(255)
	,@WDEmployeeID nvarchar(12)
	,@EmployeeType nvarchar(10)
	,@OtherType nvarchar(10) NULL
	,@CurrentAlias nvarchar(255) NULL
	,@CurrentSAM nvarchar(255) NULL
)
RETURNS nvarchar(255)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(255)
	DECLARE @BaseAlias nvarchar(255)

	IF @WDEmployeeID IN (SELECT EmployeeID FROM CT_UserExceptions) --EmployeeID Is in the CT_UserExceptions Table so we use the Exception values
        BEGIN
            SELECT @Result = (SELECT NewAlias FROM CT_UserExceptions WHERE EmployeeID = @WDEmployeeID)
        END
	ELSE -- EmployeeID was not in the CT_UserExceptions Table so we calculate the values
	IF @OtherType = 'Resource'
		BEGIN
			SELECT @Result =
				CASE WHEN @CurrentAlias IS NOT NULL THEN lower(@CurrentAlias)
				  	WHEN @CurrentAlias IS NULL THEN lower(@CurrentSAM)
				END
		END
	 ELSE
        BEGIN
            SELECT @BaseAlias = (SELECT
                CASE
                    WHEN @GivenName LIKE '%-[1-9]%' --scenario: User has duplicate
                        THEN lower(Replace(RTRIM(@GivenName,'-123456789'),' ','')) + '.' + lower(Replace(@SurName,' ',''))  + RIGHT(@GivenName,1)
                    ELSE --scenario: User has no duplicate
                        lower(replace(@GivenName,' ','')) + '.' + lower(replace(@SurName,' ',''))
                END
            )
            SELECT @Result = (SELECT
                CASE
                    WHEN @EmployeeType = 'Internal'
                        THEN @BaseAlias
                    WHEN @EmployeeType = 'External'
                        THEN (SELECT @BaseAlias + '.ext')
                    ELSE @BaseAlias
                END
            )
        END
	-- Return the result of the function
	RETURN @Result
END
GO


