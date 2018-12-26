-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================

IF NOT EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'ec' AND SPECIFIC_NAME = N'sp_LoadTestGetUsers' 
)
BEGIN
	EXEC sp_executeSQL N'CREATE PROCEDURE ec.sp_LoadTestGetUsers AS SELECT ''Procedure Stub'';';
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [EC].[sp_LoadTestGetUsers]
	-- Add the parameters for the stored procedure here

	-------------------------------------------------------------------
	-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
	@returnCode int OUTPUT,
	@returnMessage nvarchar(250) OUTPUT
AS
    DECLARE @storedProcedureName nvarchar(100)
	-- THE PRECEDING CODE SHOULD NOT BE MODIFIED
	-------------------------------------------------------------------
	SET @returnCode = 0;
	SET @storedProcedureName = 'sp_LoadTestGetUsers';
	SET @returnMessage = @storedProcedureName + ' completed successfully';

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

	SELECT CONVERT(nvarchar(30), DecryptByKey(Emp_LanID)) AS [UserLanID]
		,CONVERT(nvarchar(50), DecryptByKey(Emp_Name)) AS [UserName]
		,[EC].[fn_strGetUserRole](EmpID) AS Role
	FROM ec.LoadTest_User ltu
	JOIN ec.Employee_Hierarchy eh ON ltu.EmpID = eh.Emp_ID;

	CLOSE SYMMETRIC KEY [CoachingKey];
	
	SET @returnCode = @@ERROR;
	IF @returnCode <> 0
	BEGIN
		SET @returnMessage = @storedProcedureName + ' Error occurred.';
		RETURN -1;
	END
	ELSE
	BEGIN
	    RETURN 0;
    END
END;

GO