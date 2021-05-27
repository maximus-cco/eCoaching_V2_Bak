/*
sp_Dashboard_Director_Site_Export(05).sql
Last Modified Date: 5/24/2021
Last Modified By: Susmitha Palacherla

Version 05: Updated to support QN Alt Channels compliance and mastery levels. TFS 21276 - 5/19/2021
Version 04: Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  09/03/2019
Version 03A: Updated from UAT Feedback - TFS 14108 - 08/01/2019
Version 03: Modified to support new handling for Short Calls. TFS 14108 - 07/09/2019
Version 02: Modified to incorporate Quality Now. TFS 13332 - 03/19/2019
Version 01: Document Initial Revision created during Hist dashboard move to new architecture - TFS 7138 - 04/30/2018
*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Dashboard_Director_Site_Export' 
)
   DROP PROCEDURE [EC].[sp_Dashboard_Director_Site_Export]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	07/12/2018
--	Description: *	This procedure is used for Export of Coaching data from Director Dashboard.
--  Created during My dashboard move to new architecture - TFS 7137 - 07/12/2018
--  Modified to incorporate QualityNow Logs. TFS 13332 -  03/15/2019
--  Modified to incorporate new logic for OMR Short CallsLogs. TFS 14108 - 06/25/2019
--  Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
--  Updated to support QN Alt Channels compliance and mastery levels. TFS 21276 - 5/19/2021
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Dashboard_Director_Site_Export] 
@nvcUserIdin nvarchar(10),
@intSiteIdin int,
@strSDatein datetime,
@strEDatein datetime,
@nvcStatus nvarchar(50)
AS


BEGIN


SET NOCOUNT ON

DECLARE	
@strSDate nvarchar(10),
@strEDate nvarchar(10),
@nvcSQL1 nvarchar(max),
@nvcSQL2 nvarchar(max),
@nvcSQL2All nvarchar(max),
@nvcSQL2Phone nvarchar(max),
@nvcSQL2AllPhone nvarchar(max),
@nvcSQL2WebChat nvarchar(max),
@nvcSQL2AllWebChat nvarchar(max),
@nvcSQL2WrittenCorr nvarchar(max),
@nvcSQL2AllWrittenCorr nvarchar(max),
@nvcSQL3 nvarchar(max),
@NewLineChar nvarchar(2),
@where nvarchar(1000)


-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];


SET @NewLineChar = CHAR(13) + CHAR(10)
SET @strSDate = convert(varchar(8), @strSDatein,112)
SET @strEDate = convert(varchar(8), @strEDatein,112)

SET @where = ''

IF @nvcStatus  =  N'MySitePending' 
BEGIN
SET @where = @where +  ' AND [cl].[StatusID] NOT IN (-1,1,2) '
END

IF @nvcStatus  =   N'MySiteCompleted'
BEGIN
SET @where = @where +  ' AND [cl].[StatusID] = 1 '
END

-- Non QN Logs	

SET @nvcSQL1 = 'SELECT [cl].[CoachingID] strLogID
  ,[cl].[FormName] FormName
  ,[cl].[ProgramName] ProgramName
  ,[cl].[EmpID]	EmpID
  ,[veh].[Emp_Name]	EmpName
  ,[veh].[Sup_Name]	EmpSupName
  ,[veh].[Mgr_Name]	EmpMgrName
  ,[si].[City] FormSite
  ,[so].[CoachingSource] FormSource
  ,[so].[SubCoachingSource]	FormSubSource
  ,[dcr].[CoachingReason] CoachingReason
  ,[dscr].[SubCoachingReason] SubCoachingReason
  ,[clr].[Value] Value
  ,[s].[Status] FormStatus
  ,[vehs].[Emp_Name] SubmitterName
  ,[cl].[EventDate]	EventDate
  ,[cl].[CoachingDate] CoachingDate
  ,[cl].[VerintID] VerintID
  ,[cl].[Description] Description
  ,[cl].[CoachingNotes]	CoachingNotes
  ,[cl].[SubmittedDate]	SubmittedDate
  ,[cl].[SupReviewedAutoDate] SupReviewedAutoDate
  ,[cl].[MgrReviewManualDate] MgrReviewManualDate
  ,[cl].[MgrReviewAutoDate]	MgrReviewAutoDate
  ,[cl].[MgrNotes] MgrNotes
  ,[cl].[CSRReviewAutoDate]	EmpReviewAutoDate
  ,[cl].[CSRComments] EmpComments
 ,CASE WHEN [cl].[IsFollowupRequired] = 1 THEN ''Yes'' ELSE ''No'' END FollowupRequired
,[cl].[FollowupDueDate] FollowupDate
,[cl].[FollowupActualDate]FollowupCoachingDate
,[cl].[SupFollowupAutoDate] SupervisorFollowupAutoDate
,[cl].[SupFollowupCoachingNotes] FollowupCoachingNotes
,[cl].[EmpAckFollowupAutoDate] CSRFollowupAutoDate
,[cl].[EmpAckFollowupComments] CSRFollowupComments
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
JOIN [EC].[Coaching_Log] cl WITH (NOLOCK)  ON cl.EmpID = veh.Emp_ID 
LEFT JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON cl.SubmitterID = vehs.EMP_ID 
JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID 
JOIN [EC].[DIM_Site] si ON cl.SiteID = si.SiteID 
JOIN [EC].[Coaching_Log_Reason]clr WITH (NOLOCK) ON cl.CoachingID = clr.CoachingID 
JOIN [EC].[DIM_Coaching_Reason]dcr ON clr.CoachingReasonID = dcr.CoachingReasonID
JOIN [EC].[DIM_Sub_Coaching_Reason]dscr ON clr.SubCoachingReasonID = dscr.SubCoachingReasonID 
WHERE convert(varchar(8), [SubmittedDate], 112) >= ''' + @strSDate + '''
AND convert(varchar(8), [SubmittedDate], 112) <= ''' + @strEDate + ''' 
AND [cl].[SourceID] NOT IN (235,236) ' +
@where + ' ' + '
AND cl.SiteID = '''+CONVERT(NVARCHAR,@intSiteIdin)+'''
AND (veh.SrMgrLvl1_ID = '''+ @nvcUserIdin +''' OR veh.SrMgrLvl2_ID = '''+ @nvcUserIdin +''' OR veh.SrMgrLvl3_ID = '''+ @nvcUserIdin +''')
ORDER BY [cl].[CoachingID];'
 
 
-- QN Logs

 SET @nvcSQL2All = 'SELECT [cl].[CoachingID] strLogID
  ,[cl].[FormName] FormName
  ,[cl].[QNBatchID] QNBatchID
  ,[cl].[QNBatchStatus] QNBatchStatus
  ,[qne].[Channel]
  ,[cl].[EmpID]	EmpID
  ,[veh].[Emp_Name]	EmpName
  ,[veh].[Sup_Name]	EmpSupName
  ,[veh].[Mgr_Name]	EmpMgrName
  ,[si].[City] FormSite
  ,[so].[CoachingSource] FormSource
  ,[so].[SubCoachingSource]	FormSubSource
  ,[s].[Status] FormStatus
  ,[cl].[QNStrengthsOpportunities] QNStrengthsOpportunities
  ,[cl].[CoachingDate] CoachingDate
   ,[cl].[CoachingNotes] CoachingNotes
  ,[cl].[SubmittedDate]	SubmittedDate
  ,[cl].[SupReviewedAutoDate] SupReviewedAutoDate
  ,[cl].[MgrReviewManualDate] MgrReviewManualDate
  ,[cl].[MgrReviewAutoDate]	MgrReviewAutoDate
  ,[cl].[MgrNotes] MgrNotes
  ,[cl].[CSRReviewAutoDate]	EmpReviewAutoDate
  ,[cl].[CSRComments] EmpComments '


  SET @nvcSQL2Phone =  ' ,[qne].[VerintFormName] EvaluationForm
  ,[qne].[Channel] Channel
  ,[qne].[Journal_ID] VerintID
  ,[qne].[isCoachingMonitor] isCoachingMonitor
  ,[qne].[Program] ProgramName
  ,[qne].[Call_Date] EventDate
  ,[vehs].[Emp_Name] SubmitterName
  ,[qne].[EvalStatus] EvaluationStatus
  ,[dcr].[CoachingReason] CoachingReason
  ,[dscr].[SubCoachingReason] SubCoachingReason
 ,''NA'' Description
 ,[qne].[Reason_For_Contact] ReasonForContact
,[qne].[Contact_Reason_Comment] ReasonForContactComments
,[qne].[Business_Process] BusinessProcess
,[qne].[Business_Process_Reason] BusinessProcessReason
,[qne].[Business_Process_Comment] BusinessProcessComment
,[qne].[Info_Accuracy] InfoAccuracy
,[qne].[Info_Accuracy_Reason] InfoAccuracyReason
,[qne].[Info_Accuracy_Comment] InfoAccuracyComment
,[qne].[Privacy_Disclaimers] PrivacyDisclaimers
,[qne].[Privacy_Disclaimers_Reason] PrivacyDisclaimersReason
,[qne].[Privacy_Disclaimers_Comment] PrivacyDisclaimersComment
,[qne].[Issue_Resolution] IssueResolution
,[qne].[Issue_Resolution_Comment] IssueResolutionComment
,[qne].[Call_Efficiency] CallEfficiency
,[qne].[Call_Efficiency_Comment] CallEfficiencyComment
,[qne].[Active_Listening] ActiveListening
,[qne].[Active_Listening_Comment] ActiveListeningComment
,[qne].[Personality_Flexing] PersonalityFlexing
,[qne].[Personality_Flexing_Comment] PersonalityFlexingComment
,[qne].[Customer_Temp_Start] CustomerTempStart
,[qne].[Customer_Temp_Start_Comment] CustomerTempStartComment
,[qne].[Customer_Temp_End] CustomerTempEnd
,[qne].[Customer_Temp_End_Comment] CustomerTempEndComment
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
JOIN [EC].[Coaching_Log] cl WITH (NOLOCK)  ON cl.EmpID = veh.Emp_ID 
JOIN [EC].[Coaching_Log_Quality_Now_Evaluations]qne  WITH (NOLOCK) ON cl.CoachingID = qne.CoachingID
LEFT JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON qne.Evaluator_ID = vehs.EMP_ID 
JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID 
JOIN [EC].[DIM_Site] si ON cl.SiteID = si.SiteID 
JOIN [EC].[Coaching_Log_Reason]clr WITH (NOLOCK) ON cl.CoachingID = clr.CoachingID 
JOIN [EC].[DIM_Coaching_Reason]dcr ON clr.CoachingReasonID = dcr.CoachingReasonID
JOIN [EC].[DIM_Sub_Coaching_Reason]dscr ON clr.SubCoachingReasonID = dscr.SubCoachingReasonID 
WHERE convert(varchar(8), [SubmittedDate], 112) >= ''' + @strSDate + '''
AND convert(varchar(8), [SubmittedDate], 112) <= ''' + @strEDate + ''' 
AND [cl].[SourceID] IN (235,236)
AND [QNBatchStatus] = ''Active'' ' +
+ @NewLineChar + @where + ' ' + @NewLineChar +
+ 'AND cl.SiteID = '''+CONVERT(NVARCHAR,@intSiteIdin)+'''
AND (veh.SrMgrLvl1_ID = '''+ @nvcUserIdin +''' OR veh.SrMgrLvl2_ID = '''+ @nvcUserIdin +''' OR veh.SrMgrLvl3_ID = '''+ @nvcUserIdin +''')
AND qne.[Channel] NOT IN (''Web Chat'',''Written Correspondence'')
ORDER BY [cl].[CoachingID]'

SET @nvcSQL2AllPhone  = @nvcSQL2All +  @NewLineChar + @nvcSQL2Phone;

SET @nvcSQL2WebChat = '  ,[qne].[VerintFormName] EvaluationForm
  ,[qne].[Channel] Channel
  ,[qne].[Journal_ID] VerintID
  ,[qne].[ActivityID] ActivityIDID
  ,[qne].[isCoachingMonitor] isCoachingMonitor
  ,[qne].[Program] ProgramName
  ,[qne].[Call_Date] EventDate
  ,[vehs].[Emp_Name] SubmitterName
  ,[qne].[EvalStatus] EvaluationStatus
  ,[dcr].[CoachingReason] CoachingReason
  ,[dscr].[SubCoachingReason] SubCoachingReason
 ,''NA'' Description
 ,[qne].[Reason_For_Contact] ReasonForContact
,[qne].[Contact_Reason_Comment] ReasonForContactComments
,[qne].[Business_Process] BusinessProcess
,[qne].[Business_Process_Reason] BusinessProcessReason
,[qne].[Business_Process_Comment] BusinessProcessComment
,[qne].[Info_Accuracy] InfoAccuracy
,[qne].[Info_Accuracy_Reason] InfoAccuracyReason
,[qne].[Info_Accuracy_Comment] InfoAccuracyComment
,[qne].[Privacy_Disclaimers] PrivacyDisclaimers
,[qne].[Privacy_Disclaimers_Reason] PrivacyDisclaimersReason
,[qne].[Privacy_Disclaimers_Comment] PrivacyDisclaimersComment
,[qne].[Issue_Resolution] IssueResolution
,[qne].[Issue_Resolution_Comment] IssueResolutionComment
,[qne].[Call_Efficiency] ChatEfficiency
,[qne].[Call_Efficiency_Comment] ChatEfficiencyComment
,[qne].[Active_Listening] IssueDiagnosis
,[qne].[Active_Listening_Comment] IssueDiagnosisComment
,[qne].[Personality_Flexing] ProfessionalCommunication
,[qne].[Personality_Flexing_Comment] ProfessionalCommunicationComment
,[qne].[Customer_Temp_Start] CustomerTempStart
,[qne].[Customer_Temp_Start_Comment] CustomerTempStartComment
,[qne].[Customer_Temp_End] CustomerTempEnd
,[qne].[Customer_Temp_End_Comment] CustomerTempEndComment
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
JOIN [EC].[Coaching_Log] cl WITH (NOLOCK)  ON cl.EmpID = veh.Emp_ID 
JOIN [EC].[Coaching_Log_Quality_Now_Evaluations]qne  WITH (NOLOCK) ON cl.CoachingID = qne.CoachingID
LEFT JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON qne.Evaluator_ID = vehs.EMP_ID 
JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID 
JOIN [EC].[DIM_Site] si ON cl.SiteID = si.SiteID 
JOIN [EC].[Coaching_Log_Reason]clr WITH (NOLOCK) ON cl.CoachingID = clr.CoachingID 
JOIN [EC].[DIM_Coaching_Reason]dcr ON clr.CoachingReasonID = dcr.CoachingReasonID
JOIN [EC].[DIM_Sub_Coaching_Reason]dscr ON clr.SubCoachingReasonID = dscr.SubCoachingReasonID 
WHERE convert(varchar(8), [SubmittedDate], 112) >= ''' + @strSDate + '''
AND convert(varchar(8), [SubmittedDate], 112) <= ''' + @strEDate + ''' 
AND [cl].[SourceID] IN (235,236)
AND [QNBatchStatus] = ''Active'' ' +
+ @NewLineChar + @where + ' ' + @NewLineChar +
+ 'AND cl.SiteID = '''+CONVERT(NVARCHAR,@intSiteIdin)+'''
AND (veh.SrMgrLvl1_ID = '''+ @nvcUserIdin +''' OR veh.SrMgrLvl2_ID = '''+ @nvcUserIdin +''' OR veh.SrMgrLvl3_ID = '''+ @nvcUserIdin +''')
AND qne.[Channel] = ''Web Chat''
ORDER BY [cl].[CoachingID]'

SET @nvcSQL2AllWebChat  = @nvcSQL2All +  @NewLineChar + @nvcSQL2WebChat;


SET @nvcSQL2WrittenCorr = '  ,[qne].[VerintFormName] EvaluationForm
  ,[qne].[Channel] Channel
  ,[qne].[Journal_ID] VerintID
  ,[qne].[DCN] DCN
  ,[qne].[isCoachingMonitor] isCoachingMonitor
  ,[qne].[Program] ProgramName
  ,[qne].[Call_Date] EventDate
  ,[vehs].[Emp_Name] SubmitterName
  ,[qne].[EvalStatus] EvaluationStatus
  ,[dcr].[CoachingReason] CoachingReason
  ,[dscr].[SubCoachingReason] SubCoachingReason
 ,''NA'' Description
 ,[qne].[Reason_For_Contact] ReasonForContact
,[qne].[Contact_Reason_Comment] ReasonForContactComments
,[qne].[Business_Process] BusinessProcess
,[qne].[Business_Process_Reason] BusinessProcessReason
,[qne].[Business_Process_Comment] BusinessProcessComment
,[qne].[Info_Accuracy] InfoAccuracy
,[qne].[Info_Accuracy_Reason] InfoAccuracyReason
,[qne].[Info_Accuracy_Comment] InfoAccuracyComment
,[qne].[Privacy_Disclaimers] PrivacyDisclaimers
,[qne].[Privacy_Disclaimers_Reason] PrivacyDisclaimersReason
,[qne].[Privacy_Disclaimers_Comment] PrivacyDisclaimersComment
,[qne].[Issue_Resolution] BusinessCorrespondence 
,[qne].[Issue_Resolution_Comment] BusinessCorrespondenceComment
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
JOIN [EC].[Coaching_Log] cl WITH (NOLOCK)  ON cl.EmpID = veh.Emp_ID 
JOIN [EC].[Coaching_Log_Quality_Now_Evaluations]qne  WITH (NOLOCK) ON cl.CoachingID = qne.CoachingID
LEFT JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON qne.Evaluator_ID = vehs.EMP_ID 
JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID 
JOIN [EC].[DIM_Site] si ON cl.SiteID = si.SiteID 
JOIN [EC].[Coaching_Log_Reason]clr WITH (NOLOCK) ON cl.CoachingID = clr.CoachingID 
JOIN [EC].[DIM_Coaching_Reason]dcr ON clr.CoachingReasonID = dcr.CoachingReasonID
JOIN [EC].[DIM_Sub_Coaching_Reason]dscr ON clr.SubCoachingReasonID = dscr.SubCoachingReasonID 
WHERE convert(varchar(8), [SubmittedDate], 112) >= ''' + @strSDate + '''
AND convert(varchar(8), [SubmittedDate], 112) <= ''' + @strEDate + ''' 
AND [cl].[SourceID] IN (235,236)
AND [QNBatchStatus] = ''Active'' ' +
+ @NewLineChar + @where + ' ' + @NewLineChar +
+ 'AND cl.SiteID = '''+CONVERT(NVARCHAR,@intSiteIdin)+'''
AND (veh.SrMgrLvl1_ID = '''+ @nvcUserIdin +''' OR veh.SrMgrLvl2_ID = '''+ @nvcUserIdin +''' OR veh.SrMgrLvl3_ID = '''+ @nvcUserIdin +''')
AND qne.[Channel] = ''Written Correspondence''
ORDER BY [cl].[CoachingID]'

SET @nvcSQL2AllWrittenCorr  = @nvcSQL2All +  @NewLineChar + @nvcSQL2WrittenCorr;

-- ISQ Logs

SET @nvcSQL3 = 
'SELECT [cl].[CoachingID] CoachingID
  ,[cl].[FormName] FormName
  ,[cl].[ProgramName] ProgramName
  ,[cl].[EmpID]	EmpID
  ,[veh].[Emp_Name]	EmpName
  ,[veh].[Sup_Name]	EmpSupName
  ,[veh].[Mgr_Name]	EmpMgrName
  ,[si].[City] FormSite
  ,[so].[CoachingSource] FormSource
  ,[so].[SubCoachingSource]	FormSubSource
  ,[dcr].[CoachingReason] CoachingReason
  ,[dscr].[SubCoachingReason] SubCoachingReason
  ,[clr].[Value] Value
  ,[s].[Status] FormStatus
  ,[vehs].[Emp_Name] SubmitterName
  ,[sce].[EventDate] EventDate
  ,[cl].[CoachingDate] CoachingDate
  ,[cl].[CoachingNotes]	CoachingNotes
  ,[sce].[VerintCallID] VerintID
  ,[b].[Description] Behavior
  ,CASE WHEN [sce].[Valid] = 1 THEN ''Yes'' ELSE ''No'' END ValidBehavior
  ,[sce].[Action] Action
  ,[cl].[Description] Description
  ,[sce].[CoachingNotes] ShortCallCoachingNotes
  ,CASE WHEN [sce].[LSAInformed] = 1 THEN ''Yes'' ELSE ''No'' END LSAInformed
  ,[cl].[SubmittedDate]	SubmittedDate
  ,[cl].[SupReviewedAutoDate] SupReviewedAutoDate
  ,[cl].[MgrReviewManualDate] MgrReviewManualDate
  ,[cl].[MgrReviewAutoDate]	MgrReviewAutoDate
  ,CASE WHEN [sce].[MgrAgreed] = 1 THEN ''Yes'' ELSE ''No'' END MgrAgreed
  ,[sce].[MgrComments]
  ,[cl].[MgrNotes] MgrNotes
FROM [EC].[ShortCalls_Evaluations] sce WITH (NOLOCK)  LEFT JOIN [EC].[ShortCalls_Behavior] b
ON b.ID = sce.BehaviorID JOIN  [EC].[Coaching_Log] cl WITH (NOLOCK)
ON cl.CoachingID = sce.CoachingID JOIN [EC].[Coaching_Log_Reason]clr WITH (NOLOCK) 
ON cl.CoachingID = clr.CoachingID JOIN [EC].[DIM_Coaching_Reason]dcr
ON clr.CoachingReasonID = dcr.CoachingReasonID JOIN [EC].[DIM_Sub_Coaching_Reason]dscr
ON clr.SubCoachingReasonID = dscr.SubCoachingReasonID  JOIN [EC].[DIM_Status] s 
ON cl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so 
ON cl.SourceID = so.SourceID JOIN [EC].[DIM_Site] si 
ON cl.SiteID = si.SiteID JOIN [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
ON cl.[EMPID] = veh.[EMP_ID] JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK)
ON cl.SubmitterId = vehs.EMP_ID 
WHERE convert(varchar(8), [SubmittedDate], 112) >= ''' + @strSDate + '''
AND convert(varchar(8), [SubmittedDate], 112) <= ''' + @strEDate + ''' 
AND [cl].[SourceID] = 212
AND SUBSTRING([cl].[strReportCode], 1, 3) = ''ISQ'' ' +
@where + ' ' + '
AND cl.SiteID = '''+CONVERT(NVARCHAR,@intSiteIdin)+'''
AND (veh.SrMgrLvl1_ID = '''+ @nvcUserIdin +''' OR veh.SrMgrLvl2_ID = '''+ @nvcUserIdin +''' OR veh.SrMgrLvl3_ID = '''+ @nvcUserIdin +''')
ORDER BY [cl].[CoachingID]'

SET NOCOUNT ON;  
EXEC (@nvcSQL1)	
--PRINT @nvcSQL1

EXEC (@nvcSQL2AllPhone);
--PRINT @nvcSQL2AllPhone;

EXEC (@nvcSQL2AllWebChat);	
--PRINT @nvcSQL2AllWebChat;

EXEC (@nvcSQL2AllWrittenCorr);	
--PRINT @nvcSQL2AllWrittenCorr;

EXEC (@nvcSQL3)	
--PRINT @nvcSQL3

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
END -- sp_Dashboard_Director_Site_Coaching_Export
GO


