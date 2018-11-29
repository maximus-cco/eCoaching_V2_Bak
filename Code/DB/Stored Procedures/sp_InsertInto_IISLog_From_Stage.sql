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
  WHERE SPECIFIC_SCHEMA = N'ec' AND SPECIFIC_NAME = N'sp_InsertInto_IISLog_From_Stage' 
)
BEGIN
	EXEC sp_executeSQL N'CREATE PROCEDURE ec.sp_InsertInto_IISLog_From_Stage AS SELECT ''Procedure Stub'';';
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
ALTER PROCEDURE [EC].[sp_InsertInto_IISLog_From_Stage]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

	INSERT INTO EC.IISLog (UserID, IISLogDateTime, [Target], PageName, StatusCode)
	SELECT EncryptByKey(Key_GUID('CoachingKey'), UserName) , IISLogDateTime, [Target], PageName, StatusCode
	FROM EC.IISLog_Stage

	CLOSE SYMMETRIC KEY [CoachingKey]; 
END
GO