SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Description:	gets or calculates Firstname.Lastname for SamAccountName (limits to 20 char)
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[getNewSamAccountName]
(
	-- Add the parameters for the function here
	@GivenName nvarchar(255)
	,@SurName nvarchar(255)
	,@WDEmployeeID nvarchar(12)
	,@EmployeeType nvarchar(10)
	,@OtherType nvarchar(10) NULL
	,@CurrentSAM nvarchar(20) NULL
)
RETURNS nvarchar(255)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(255)
	DECLARE @BaseAlias nvarchar(255)
    DECLARE @NewGiven NVARCHAR(255)
    DECLARE @NewSur NVARCHAR(255)
    DECLARE @Number NVARCHAR(1)
    DECLARE @ext NVARCHAR(4)
    DECLARE @lext INT
    DECLARE @lNG INT
    DECLARE @lNS INT
    DECLARE @lSAM INT
    DECLARE @tNG INT
    DECLARE @tNS INT


	IF @WDEmployeeID IN (SELECT EmployeeID FROM CT_UserExceptions) --EmployeeID Is in the CT_UserExceptions Table so we use the Exception values
        BEGIN
            SELECT @Result = (SELECT NewSamAccountName FROM CT_UserExceptions WHERE EmployeeID = @WDEmployeeID)
        END
	ELSE -- EmployeeID was not in the CT_UserExceptions Table so we calculate the values
		IF @OtherType = 'Resource'
			BEGIN
				SELECT @Result = (SELECT lower(@CurrentSAM))
			END
		ELSE
        BEGIN
            SELECT @NewGiven = (SELECT dbo.ProperCase(replace(RTRIM(@GivenName,'-123456789'),' ','')))
            SELECT @NewSur = (SELECT dbo.ProperCase(replace(@SurName,' ','')))
            SELECT @lext = 0
            SELECT @Number = (SELECT
                CASE
                    WHEN @GivenName LIKE '%-[1-9]%' --scenario: User has duplicate
                        THEN RIGHT(@GivenName,1)
                    ELSE ''
                END
            )
            SELECT @ext = (SELECT
                CASE
                    WHEN @EmployeeType = 'External'
                        THEN '.ext'
                    ELSE ''
                END
            )
            SELECT @lext = LEN(@number + @ext)
            SELECT @lNG = LEN(@NewGiven)
            SELECT @lNS = LEN(@NewSur)
            SELECT @lSAM = (@lNG + 1 + @lNS + @lext)
            SELECT @tNG = (SELECT CASE WHEN @lNG >= 8 THEN 8 ELSE @lNG END)
            SELECT @tNS = (20 - (@tNG + 1 + @lext))
            IF @lSAM > 20
                SELECT @Result = (SELECT SUBSTRING(@NewGiven,1,@tNG) + '.' + SUBSTRING(@NewSur,1,@tNS) + @Number + @ext)
                --SELECT @Result = 'Trimming'
            ELSE
                SELECT @Result = (SELECT @NewGiven + '.' + @NewSur + @Number + @ext )
                --SELECT @Result = 'Not Trimming'
        END
	-- Return the result of the function
	RETURN @Result
END
GO


