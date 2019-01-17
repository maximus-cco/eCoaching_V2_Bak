/*
sp_Update_Coaching_Log_Quality(04).sql
Last Modified Date: 1/15/2019
Last Modified By: Lili Huang

Version 04: Modified to decrease coaching_log table locking time TFS 13282 - 1/15/2019
Version 03: Modified to add delay between update statements. TFS 12841 - 12/03/2018
Version 02: Modified to handle inactive evaluations. TFS 9204 - 03/26/2018
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017
*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_Coaching_Log_Quality' 
)
   DROP PROCEDURE [EC].[sp_Update_Coaching_Log_Quality]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ===========================================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      04/23/2014
--    Description:     This procedure updates the Quality scorecards into the Coaching_Log table. 
--                     The txtdescription is updated in the Coaching_Log table.
-- Last Updated By: Susmitha Palacherla
-- Modified per TFS 283 to force CRLF in Description value when viewed in UI - 08/31/2015
-- Modified per TFS 3757 to update isCoachingMonitor - 11/10/2016
-- Modified to handle inactive evaluations. TFS 9204 - 02/08/2018
-- Modified to add delay between update statements. TFS 12841 - 12/03/2018
-- Modified to decrease coaching_log table locking time TFS 13282 - 1/15/2019 LH
--    ===========================================================================================
CREATE PROCEDURE [EC].[sp_Update_Coaching_Log_Quality] AS
BEGIN

BEGIN TRY
  CREATE TABLE #Temp_Logs_To_Inactivate (
    CoachingLogID bigint
  );

  CREATE TABLE #Temp_Logs_To_Inactivate_Archive (
    CoachingLogID bigint,
	FormName nvarchar(50),
	LastKnownStatus int
  );

  CREATE TABLE #Temp_Logs_To_Update_Description (
    CoachingLogID bigint,
	CallerIssues nvarchar(max)
  );

  CREATE TABLE #Temp_Logs_To_Update_Opportunity_Reinforce (
    CoachingLogID bigint,
	OpportunityReinforceText nvarchar(30) 
  );

  -- Populates #Temp_Logs_To_Inactive
  INSERT INTO #Temp_Logs_To_Inactivate 
  SELECT cl.CoachingID
  FROM EC.Quality_Coaching_Stage qcs 
  JOIN EC.Coaching_Log cl WITH (NOLOCK) ON qcs.Eval_ID = cl.VerintEvalID  
  WHERE cl.StatusID <> 2 AND qcs.EvalStatus = 'Inactive';

  -- Populates #Temp_Logs_To_Inactivate_Archive
  INSERT INTO #Temp_Logs_To_Inactivate_Archive 
  SELECT cl.CoachingID, cl.Formname, cl.StatusID
  FROM EC.Quality_Coaching_Stage qcs 
  JOIN EC.Coaching_Log cl WITH (NOLOCK) ON qcs.Eval_ID = cl.VerintEvalID
  WHERE cl.StatusID <> 2
  AND qcs.EvalStatus = 'Inactive'
  AND cl.FormName NOT IN 
  (SELECT FormName FROM EC.AT_Coaching_Inactivate_Reactivate_Audit 
    WHERE Reason = 'Evaluation Inactive' AND RequesterComments = 'Quality Load Process' 
	AND FormName IS NOT NULL
  );

  -- Populates #Temp_Logs_To_Update_Description
  INSERT INTO #Temp_Logs_To_Update_Description
  SELECT cl.CoachingID, replace(EC.fn_nvcHtmlEncode(qcs.Summary_CallerIssues), CHAR(13) + CHAR(10) ,'<br />')
  FROM EC.Quality_Coaching_Stage qcs
  JOIN EC.Coaching_Log cl WITH (NOLOCK) ON qcs.Eval_ID = cl.VerintEvalID and qcs.Journal_ID = cl.VerintID
  WHERE cl.VerintEvalID IS NOT NULL;

  -- Populates #Temp_Logs_To_Update_Opportunity_Reinforce 
  INSERT INTO #Temp_Logs_To_Update_Opportunity_Reinforce 
  SELECT cl.CoachingID, qcs.Oppor_Rein
  FROM EC.Quality_Coaching_Stage qcs 
  JOIN EC.Coaching_Log cl WITH (NOLOCK) ON qcs.Eval_ID = cl.VerintEvalID  
  JOIN EC.Coaching_Log_Reason clr WITH (NOLOCK) ON cl.CoachingID = clr.CoachingID  
  WHERE qcs.Oppor_Rein <> clr.Value

  BEGIN TRANSACTION
    -- Inactivates Logs for Inactive Evaluations
	-- Step 1: Archives logs to be inactivated that are not already in the archive table
	INSERT INTO EC.AT_Coaching_Inactivate_Reactivate_Audit 
    SELECT *, 'Inactivate',  Getdate(), '999998', 'Evaluation Inactive', 'Quality Load Process' 
	FROM #Temp_Logs_To_Inactivate_Archive;
	-- Step 2: Inactivates all logs with 'Inactive' status in the stage table
	UPDATE EC.Coaching_Log SET StatusID = 2
    FROM #Temp_Logs_To_Inactivate temp 
	JOIN EC.Coaching_Log cl ON temp.CoachingLogID = cl.CoachingID;
	
	-- Updates Description for existing records
	UPDATE EC.Coaching_Log SET [Description] = temp.CallerIssues
	FROM #Temp_Logs_To_Update_Description temp 
	JOIN EC.Coaching_Log cl ON temp.CoachingLogID = cl.CoachingID;

	-- Updates Oppor/Re-In value in Coaching_Log_reason table for each record updated in Coaching_log table.
	UPDATE EC.Coaching_Log_reason SET Value= temp.OpportunityReinforceText
	FROM #Temp_Logs_To_Update_Opportunity_Reinforce temp
	JOIN EC.Coaching_Log_reason clr ON clr.CoachingID = temp.CoachingLogID;
  COMMIT TRANSACTION
END TRY
BEGIN CATCH
  IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
	
  DECLARE @ErrorMessage nvarchar(4000), @ErrorSeverity int, @ErrorState int;
  SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
      
  IF ERROR_NUMBER() IS NULL RETURN 1
  ELSE IF ERROR_NUMBER() <> 0 RETURN ERROR_NUMBER() 
  ELSE RETURN 1
END CATCH 

END -- [EC].[sp_Update_Coaching_Log_Quality]


GO



