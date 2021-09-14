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

-- =============================================
-- Author:           Susmitha Palacherla
-- Create Date:      03/01/2019
-- Description:      This procedure displays the Quality Now Evluations for a Coaching Log
-- LAdded EvalID to the return. TFS 17030 - 04/20/2020
-- Updated to support QN Alt Channels compliance and mastery levels. TFS 21276 - 5/19/2021
-- Modified to add QN Eval Summary. TFS 22187 - 08/13/2021
-- =============================================
CREATE OR ALTER PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_Quality_Now] @intLogId BIGINT
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

    -- Insert statements for procedure here
	SELECT  'Evaluation ' + CONVERT(NVARCHAR(1),ROW_NUMBER() OVER(ORDER BY qne.[Eval_Date] ASC)) [Evaluation],
		 qne.[VerintFormName] [Form Name] 
		,qne.[Eval_ID] [Evaluation ID]
		,qne.[Channel]
		,qne.[Reason_For_Contact]  + '<br />' + qne.[Contact_Reason_Comment] [Reason For Contact]
		,qne.[Journal_ID] [Call ID]
		,CASE qne.[Channel]  
			WHEN 'Web Chat' THEN qne.[ActivityID] 
			WHEN 'Written Correspondence' THEN qne.[DCN] 
			ELSE '' END AS [Activity ID]
		,qne.[CaseNumber] [Case Number]
		,qne.[isCoachingMonitor] [Coaching Monitor]
		,qne.[Program] strProgram
		,qne.[Call_Date] [Date of Event]
		,ISNULL(CONVERT(nvarchar(70), DecryptByKey(sub.Emp_Name)),'unknown') [Submitter]
		,qne.[Business_Process] + '<br />' + qne.[Business_Process_Reason] [Business Process]
		,qne.[Business_Process_Comment] [Business Process Comments]
		,qne.[Info_Accuracy]  + '<br />' + qne.[Info_Accuracy_Reason] [Info Accuracy]
		,qne.[Info_Accuracy_Comment] [Info Accuracy Comments]
		,qne.[Privacy_Disclaimers] + '<br />' + qne.[Privacy_Disclaimers_Reason] [Privacy Disclaimers]
		,qne.[Privacy_Disclaimers_Comment]  [Privacy Disclaimers Comments]
		,qne.[Issue_Resolution] [Issue Resolution]
		,qne.[Issue_Resolution_Comment] [Issue Resolution Comments]
		,qne.[Call_Efficiency] [Call Efficiency]
		,qne.[Call_Efficiency_Comment] [Call Efficiency Comments]
		,qne.[Active_Listening] [Active Listening]
		,qne.[Active_Listening_Comment] [Active Listening Comments]
		,qne.[Personality_Flexing] [Personality Flexing]
		,qne.[Personality_Flexing_Comment]  [Personality Flexing Comments]
		,qne.[Customer_Temp_Start] [Start Temperature]
		,qne.[Customer_Temp_Start_Comment] [Start Temperature Comments]
		,qne.[Customer_Temp_End] [End Temperature]
		,qne.[Customer_Temp_End_Comment] [End Temperature Comments]
	FROM [EC].[Coaching_Log_Quality_Now_Evaluations] qne  WITH (NOLOCK) 
		JOIN [EC].[Coaching_Log] cl  WITH (NOLOCK) ON qne.CoachingID = cl.CoachingID 
		LEFT JOIN EC.Employee_Hierarchy sub  WITH (NOLOCK) ON qne.Evaluator_ID = sub.Emp_ID
	WHERE qne.CoachingID = @intLogId
		AND qne.EvalStatus = 'Active'
	ORDER BY qne.[Eval_Date];

	select * from [EC].[Coaching_Log_Quality_Now_Summary]
	where coachingid = @intLogId;

	CLOSE SYMMETRIC KEY [CoachingKey];
END
GO


