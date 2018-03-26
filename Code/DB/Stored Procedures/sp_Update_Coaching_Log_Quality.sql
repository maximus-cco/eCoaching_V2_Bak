/*
sp_Update_Coaching_Log_Quality(02).sql
Last Modified Date: 03/26/2018
Last Modified By: Susmitha Palacherla



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








--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      04/23/2014
--    Description:     This procedure updates the Quality scorecards into the Coaching_Log table. 
--                     The txtdescription is updated in the Coaching_Log table.
-- Last Updated By: Susmitha Palacherla
-- Modified per TFS 283 to force CRLF in Description value when viewed in UI - 08/31/2015
-- Modified per TFS 3757 to update isCoachingMonitor - 11/10/2016
-- Modified to handle inactive evaluations. TFS 9204 - 03/26/2018
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update_Coaching_Log_Quality]
  
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY


--Inactivate Logs for Inactive Evaluations
BEGIN

	  INSERT INTO [EC].[AT_Coaching_Inactivate_Reactivate_Audit]
           ([CoachingID],[FormName],[LastKnownStatus],[Action]
           ,[ActionTimestamp] ,[RequesterID] ,[Reason],[RequesterComments])
      SELECT F.[CoachingID], F.[Formname], F.[StatusID],  'Inactivate',
      Getdate(), '999998','Evaluation Inactive', 'Quality Load Process' 
   FROM [EC].[Quality_Coaching_Stage]S INNER JOIN [EC].[Coaching_Log]F
   ON S.[Eval_ID] = F.[VerintEvalID]
   WHERE F.StatusID <> 2
   AND S.EvalStatus = 'Inactive'
   AND F.FormName NOT IN 
   (SELECT FormName FROM [EC].[AT_Coaching_Inactivate_Reactivate_Audit]
    WHERE [Reason] = 'Evaluation Inactive' AND [RequesterComments] = 'Quality Load Process'
	AND FormName IS NOT NULL)

UPDATE [EC].[Coaching_Log]
SET StatusID = 2
FROM [EC].[Coaching_Log] F JOIN [EC].[Quality_Coaching_Stage]S 
ON S.[Eval_ID] = F.[VerintEvalID]
WHERE F.StatusID <> 2
AND S.EvalStatus = 'Inactive'

OPTION (MAXDOP 1)
END

      
-- Update txtDescription for existing records

 UPDATE [EC].[Coaching_Log]
 SET [Description] = REPLACE(EC.fn_nvcHtmlEncode(S.[Summary_CallerIssues]), CHAR(13) + CHAR(10) ,'<br />'),
 isCoachingMonitor = S.isCoachingMonitor
 FROM [EC].[Quality_Coaching_Stage]S INNER JOIN [EC].[Coaching_Log]F
 ON S.[Eval_ID] = F.[VerintEvalID]
 AND S.[Journal_ID] = F.[VerintID]
 WHERE F.[VerintEvalID] is NOT NULL
 OPTION (MAXDOP 1)       
           

WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms


 -- Update Oppor/Re-In value in Coaching_Log_reason table for each record updated in Coaching_log table.

 UPDATE [EC].[Coaching_Log_reason]
 SET  [Value]= S.[Oppor_Rein]        
 FROM [EC].[Quality_Coaching_Stage] S JOIN  [EC].[Coaching_Log] F 
    ON S.[Eval_ID] = F.[VerintEvalID]  JOIN  [EC].[Coaching_Log_Reason] R
    ON F.[CoachingID] = R.[CoachingID]  
    WHERE S.[Oppor_Rein] <> [Value]
 OPTION (MAXDOP 1)   
 
                  
COMMIT TRANSACTION
END TRY

      
      BEGIN CATCH
      IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION


    DECLARE @ErrorMessage NVARCHAR(4000)
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE()

    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               )
      
    IF ERROR_NUMBER() IS NULL
      RETURN 1
    ELSE IF ERROR_NUMBER() <> 0 
      RETURN ERROR_NUMBER()
    ELSE
      RETURN 1
  END CATCH  
END -- sp_Update_Coaching_Log_Quality






GO


