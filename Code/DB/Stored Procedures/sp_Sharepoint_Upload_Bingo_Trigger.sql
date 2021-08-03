/*
sp_Sharepoint_Upload_Bingo_Trigger(01).sql
Last Modified Date: 8/2/2021
Last Modified By: Susmitha Palacherla

Version 01: Updated to improve performance for Bingo upload job - TFS 22443 - 8/2/2021


*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Sharepoint_Upload_Bingo_Trigger' 
)
   DROP PROCEDURE [EC].[sp_Sharepoint_Upload_Bingo_Trigger]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	7/30/2021
--	Description:    Triggers the bingo Upload job one day after the bingo file load.
-- Initial Revision. Add trigger and review performance for Bingo upload job. TFS 22443 - 7/30/2021
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Sharepoint_Upload_Bingo_Trigger] 
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

DECLARE @BQNFileCount int,
        @LoadedCount int,
        @JobName nvarchar(100),
        @BeginDate datetime = (SELECT BeginDate FROM [EC].[View_Coaching_Log_Bingo_Upload_Dates]),
        @EndDate datetime = (SELECT EndDate FROM [EC].[View_Coaching_Log_Bingo_Upload_Dates]);



SET @BQNFileCount = (SELECT Count([FILE_NAME])  FROM [EC].[Quality_Other_FileList]
WHERE DATEADD(day, DATEDIFF(day, 0, [File_LoadDate]), 0) > DATEADD(day, DATEDIFF(day, 0, GETDATE()),-1)
AND [FILE_NAME] like '%BQN%');

SET @LoadedCount = (SELECT COUNT(*) FROM [EC].[Coaching_Log_Bingo_SharePoint_Uploads]
WHERE [Upload_Status] = N'Loaded' AND [EventDate] BETWEEN @BeginDate AND @EndDate);

SET @JobName = (SELECT CASE @@SERVERNAME WHEN N'UVAAPADSQL50CCO' THEN N'CoachingSharepointUploadBingo' ELSE N'CoachingSharepointUploadBingo--STEP_01 (Stage Logs for Upload)' END);


PRINT @BQNFileCount;
PRINT @JobName;
PRINT @LoadedCount;


-- If any Bingo QN files loaded in the last one day and no logs uploaded to SharePoint for the month call the Bingo upload job
     
IF (@BQNFileCount > 0 AND @LoadedCount = 0)
BEGIN

	DECLARE @JobId binary(16);
	SELECT @JobId = job_id FROM msdb.dbo.sysjobs WHERE name = @JobName;
	EXEC msdb.dbo.sp_start_job @job_id = @JobId;

END	 


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

