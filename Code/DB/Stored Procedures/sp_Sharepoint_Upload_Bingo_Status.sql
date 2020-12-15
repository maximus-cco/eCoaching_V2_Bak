/*
Last Modified Date: 12/8/2020
Last Modified By: Susmitha Palacherla

Version 01: Document Initial Revision - TFS 19526 - 12/8/2020
*/

IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_Sharepoint_Upload_Bingo_Status' 
)
   DROP PROCEDURE [EC].[sp_Sharepoint_Upload_Bingo_Status]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	12/8/2020
--	Description:    Updates the matching Bingo logs in init Upload table with upload status and load datetime.
-- Initial Revision. Extract bingo logs from ecl and post to share point sites. TFS 19526 - 12/8/2020
-- ================================================================
CREATE PROCEDURE [EC].[sp_Sharepoint_Upload_Bingo_Status]
  @records [EC].[SharepointUploadBingoTableType] READONLY
AS

SET NOCOUNT ON;
SET XACT_ABORT,
    QUOTED_IDENTIFIER,
    ANSI_NULLS,
    ANSI_PADDING,
    ANSI_WARNINGS,
    ARITHABORT,
    CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
 
DECLARE @localTran bit
IF @@TRANCOUNT = 0
BEGIN
    SET @localTran = 1
    BEGIN TRANSACTION LocalTran
END

BEGIN TRY
	-------------------------------------------------------------------------------------
	-- *** BEGIN: INSERT CUSTOM CODE HERE ***
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

	DECLARE @Currdatetime datetime = GETDATE();

	-- Update the matching Bingo logs in init Upload table

	UPDATE app
		SET Upload_Status = r.[Upload_Status],
			Initial_UploadDate = COALESCE(Initial_UploadDate, @Currdatetime),
			Last_UploadDate =  @Currdatetime
     	FROM [EC].[Coaching_Log_Bingo_SharePoint_Uploads] app
		INNER JOIN @records r ON (app. [Employee_ID] = r. [Employee_ID] AND app.[Employee_Site] = r.[Employee_Site] AND app.[Month_Year]= r.[Month_Year])


	-- *** END: INSERT CUSTOM CODE HERE ***
	-------------------------------------------------------------------------------------
	-- Commit transaction only if it was started locally
    IF @localTran = 1 AND XACT_STATE() = 1
        COMMIT TRAN LocalTran
END TRY
BEGIN CATCH
    IF @localTran = 1 AND XACT_STATE() <> 0
        ROLLBACK TRAN;
 
	THROW;
END CATCH
GO


