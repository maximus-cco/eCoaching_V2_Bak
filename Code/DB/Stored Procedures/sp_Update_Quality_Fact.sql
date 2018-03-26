/*
sp_Update_Quality_Fact(02).sql
Last Modified Date: 03/26/2018
Last Modified By: Susmitha Palacherla



Version 02: Modified to handle inactive evaluations. TFS 9204 - 03/26/2018

Version 01: Document Initial Revision - Mass check-in. TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_Quality_Fact' 
)
   DROP PROCEDURE [EC].[sp_Update_Quality_Fact]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









--    ====================================================================
--  Author:           Susmitha Palacherla
--  Create Date:      05/14/2014
--  Description:     This procedure updates the existing records in the Quality Fact table
--                     and inserts new records.
--  Updated per SCR 13054 to add additional column VerintFormName - 07/18/2014
--  Updated per TFS 3757 to add isCoachingMonitor attribute - 10/28/2016
--  Modified to handle inactive evaluations. TFS 9204 - 03/26/2018
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update_Quality_Fact]
  
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY
      
-- Update existing records in quality Fact Table

 UPDATE [EC].[Quality_Coaching_Fact]
 SET [Summary_CallerIssues] = S.[Summary_CallerIssues],
     [Date_Inserted]=S.[Date_Inserted],
     [Oppor_Rein]= S.[Oppor_Rein]
	,[EvalStatus] = S.[EvalStatus]
 FROM [EC].[Quality_Coaching_Stage]S INNER JOIN [EC].[Quality_Coaching_Fact]F
 ON S.[Eval_ID] = F.[Eval_ID]
 AND S.[Journal_ID] = F.[Journal_ID]
 WHERE F.[Eval_ID] is NOT NULL
 OPTION (MAXDOP 1)       
           
        

WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms


 -- Append new records to Quality Fact Table

INSERT INTO [EC].[Quality_Coaching_Fact]
           ([Eval_ID]
           ,[Eval_Date]
           ,[Eval_Site_ID]
           ,[User_ID]
           ,[User_EMPID]
           ,[SUP_ID]
           ,[SUP_EMPID]
           ,[MGR_ID]
           ,[MGR_EMPID]
           ,[Journal_ID]
           ,[Call_Date]
           ,[Summary_CallerIssues]
           ,[Coaching_Goal_Discussion]
           ,[CSE]
           ,[Evaluator_ID]
           ,[Program]
           ,[Source]
           ,[Oppor_Rein]
           ,[Date_Inserted]
           ,[VerintFormName]
           ,[isCoachingMonitor]
		   ,[EvalStatus])
     SELECT
       S.[Eval_ID]
      ,S.[Eval_Date]
      ,S.[Eval_Site_ID]
      ,S.[User_ID]
      ,S.[User_EMPID]
      ,S.[SUP_ID]
      ,S.[SUP_EMPID]
      ,S.[MGR_ID]
      ,S.[MGR_EMPID]
      ,S.[Journal_ID]
      ,S.[Call_Date]
      ,S.[Summary_CallerIssues]
      ,S.[Coaching_Goal_Discussion]
      ,S.[CSE]
      ,S.[Evaluator_ID]
      ,S.[Program]
      ,S.[Source]
      ,S.[Oppor_Rein]
      ,S.[Date_Inserted]
      ,S.[VerintFormName]
      ,S.[isCoachingMonitor]
	  ,S.[EvalStatus]
      FROM
	[EC].[Quality_Coaching_Stage] S LEFT OUTER JOIN
	[EC].[Quality_Coaching_Fact] F ON 
	S.[Eval_ID] = F.[Eval_ID]
    WHERE(F.[Eval_ID] IS NULL) 
	AND S.[EvalStatus]= 'Active'

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
END -- sp_Update_Quality_Fact







GO


