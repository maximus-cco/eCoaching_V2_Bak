/*
sp_SelectReviewFrom_Coaching_Log_Quality_Now(03).sql
Last Modified Date: 04/04/2019
Last Modified By: Susmitha Palacherla

Version 03: Additional Changes from V&V - TFS 13332 - 04/04/2019
Version 02: Additional Changes - TFS 13332 - 03/28/2019
Version 01: Document Initial Revision - TFS 13332 - 03/19/2019
*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectReviewFrom_Coaching_Log_Quality_Now' 
)
   DROP PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_Quality_Now]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
-- Author:           Susmitha Palacherla
-- Create Date:      03/01/2019
--	Description: 	This procedure displays the Quality Now Evluations for a Coaching Log
-- Initial revision. TFS 13332 -  03/01/2019
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_Quality_Now] @intLogId BIGINT
AS

BEGIN
	DECLARE	

@nvcSQL nvarchar(max)


-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

SET @nvcSQL = 'SELECT  ''Evaluation '' + CONVERT(NVARCHAR(1),ROW_NUMBER() OVER(ORDER BY qne.[Eval_Date] ASC)) [Evaluation],
qne.[VerintFormName] [Form Name] 
      ,qne.[Journal_ID] [Call ID]
	  ,qne.[isCoachingMonitor] [Coaching Monitor]
	  ,qne.[Program] strProgram
	  ,qne.[Call_Date] [Date of Event]
	  ,CONVERT(nvarchar(70),DecryptByKey(sub.Emp_Name)) [Submitter]
	  ,qne.[Business_Process] + ''<br />'' + qne.[Business_Process_Reason] + ''<br />'' + qne.[Business_Process_Comment] [Business Process]
	  ,qne.[Info_Accuracy]  + ''<br />'' + qne.[Info_Accuracy_Reason] + ''<br />'' + qne.[Info_Accuracy_Comment] [Info Accuracy]
	  ,qne.[Privacy_Disclaimers] + ''<br />'' + qne.[Privacy_Disclaimers_Reason] + ''<br />'' + qne.[Privacy_Disclaimers_Comment] [Privacy Disclaimers]
	  ,qne.[Issue_Resolution]  + ''<br />'' + qne.[Issue_Resolution_Comment] [Issue Resolution]
	  ,qne.[Call_Efficiency]  + ''<br />'' + qne.[Call_Efficiency_Comment] [Call Efficiency]
	  ,qne.[Active_Listening]  + ''<br />'' + qne.[Active_Listening_Comment] [Active Listening]
	  ,qne.[Personality_Flexing]  + ''<br />'' + qne.[Personality_Flexing_Comment] [Personality Flexing]
	  ,CONVERT(NVARCHAR(1),qne.[Customer_Temp_Start])   + ''<br />'' + qne.[Customer_Temp_Start_Comment] [Start Temperature]
	  ,CONVERT(NVARCHAR(1),qne.[Customer_Temp_End]) + ''<br />'' + qne.[Customer_Temp_End_Comment] [End Temperature]
 FROM [EC].[Coaching_Log_Quality_Now_Evaluations] qne JOIN [EC].[Coaching_Log] cl
 ON qne.CoachingID = cl.CoachingID JOIN EC.Employee_Hierarchy sub 
 ON qne.Evaluator_ID = sub.Emp_ID
 Where qne.CoachingID = '''+CONVERT(NVARCHAR(20),@intLogId) + '''
 AND qne.EvalStatus = ''Active''
 ORDER BY qne.[Eval_Date]'

		
EXEC (@nvcSQL)	
--Print (@nvcSQL)


-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];
	    
END --sp_SelectReviewFrom_Coaching_Log_Quality_Now
GO




