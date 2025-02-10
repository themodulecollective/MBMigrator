SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Description:	gets or calculates DisplayName
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[getNewDisplayName]
(
	-- Add the parameters for the function here
	@GivenName nvarchar(255)
	,@SurName nvarchar(255)
	,@WDEmployeeID nvarchar(12)
	,@EmployeeType nvarchar(10)
	,@OtherType nvarchar(10) NULL
	,@CurrentDisplay nvarchar(255) NULL
)
RETURNS nvarchar(255)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(255)
	DECLARE @BaseDisplayName nvarchar(255)


	IF @WDEmployeeID IN (SELECT EmployeeID FROM CT_UserExceptions)
	BEGIN
		SELECT @Result = (SELECT NewDisplayName FROM CT_UserExceptions WHERE EmployeeID = @WDEmployeeID)
	END

	ELSE
	IF @OtherType = 'Resource'
		BEGIN
			SELECT @Result = @CurrentDisplay
		END
	ELSE
	BEGIN
	SELECT @BaseDisplayName = (SELECT
		CASE
			WHEN @GivenName LIKE '%-[1-9]%' --scenario: User has duplicate
				THEN dbo.ProperCase(@SurName) + ', ' + dbo.ProperCase(RTRIM(@GivenName,'-123456789')) + ' (' + RIGHT(@GivenName,1) + ')'
			ELSE --scenario: User has no duplicate
				dbo.ProperCase(@SurName) + ', ' + dbo.ProperCase(@GivenName)
		END
	)

	SELECT @Result = (SELECT
		CASE
			WHEN @EmployeeType = 'Internal'
				THEN @BaseDisplayName
			WHEN @EmployeeType = 'External'
				THEN @BaseDisplayName + ' (EXT)'
			ELSE @BaseDisplayName
		END
		)

	END
	-- Return the result of the function
	RETURN @Result

END
GO


