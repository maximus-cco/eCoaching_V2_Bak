/*
sp_SelectFrom_Coaching_Log_Historical_Export(07).sql
Last Modified Date: 07/05/2019
Last Modified By: Susmitha Palacherla

Version 07: Modified to incorporate new logic for OMR Short CallsLogs. TFS 14108 - 06/25/2019
Version 06: Additional Changes from V&V - TFS 13332 - 04/20/2019
Version 05: Modified to incorporate Quality Now. TFS 13332 - 03/19/2019
Version 04 : Modified during Hist dashboard move to new architecture - TFS 7138 - 04/30/2018
Version 03: Encrypt/decrypt - TFS 7856  - 12/1/2017
Version 02: Modified per SCR 14893 dashboard redesign performance round 2 - 06/2/2015
Version 01: Document Initial Revision - 04/14/2015
*/


IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_Historical_Export' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Historical_Export]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/14/2015
--	Description: *	This procedure selects the  e-Coaching completed records for export.
-- Last Modified Date:06/2/2015
-- Last Updated By: Susmitha Palacherla
-- Modified per SCR 14893 dashboard redesign performance round 2.
-- TFS 7856 encrypt/decrypt - names
-- Created during Hist dashboard move to new architecture - TFS 7138 - 04/24/2018
-- Modified to incorporate QualityNow Logs. TFS 13332 -  03/15/2019
-- Modified to incorporate new logic for OMR Short CallsLogs. TFS 14108 - 06/25/2019
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Historical_Export] 

@nvcUserIdin nvarchar(10),
@intSourceIdin int,
@intSiteIdin int,
@nvcEmpIdin nvarchar(10),
@nvcSupIdin nvarchar(10),
@nvcMgrIdin nvarchar(10),
@nvcSubmitterIdin nvarchar(10),
@strSDatein datetime,
@strEDatein datetime,
@intStatusIdin int, 
@nvcValue  nvarchar(30),
@intEmpActive int


AS

BEGIN


DECLARE	
@nvcSQL1 nvarchar(max),
@nvcSQL2 nvarchar(max),
@nvcSQL3 nvarchar(max),
@nvcSubSource nvarchar(100),
@strSDate nvarchar(8),
@strEDate nvarchar(8),
@NewLineChar nvarchar(2),
@where nvarchar(max);  

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @NewLineChar = CHAR(13) + CHAR(10)
SET @strSDate = convert(varchar(8), @strSDatein,112)
SET @strEDate = convert(varchar(8), @strEDatein,112)
SET @where = 'WHERE 1 = 1 '
			 

-- 1 for Active 2 for Inactive 3 for All

IF @intEmpActive  <> 3
BEGIN
    IF @intEmpActive = 1
	SET @where = @where + @NewLineChar + ' AND [eh].[Active] NOT IN (''T'',''D'')'
	ELSE
	SET @where = @where + @NewLineChar + ' AND [eh].[Active] IN (''T'',''D'')'
END


			 
IF @intSourceIdin  <> -1
BEGIN
	SET @nvcSubSource = (SELECT SubCoachingSource FROM DIM_Source WHERE SourceID = @intSourceIdin)
	SET @where = @where + @NewLineChar + 'AND [so].[SubCoachingSource] =  ''' + @nvcSubSource + ''''
END

IF @intStatusIdin  <> -1
BEGIN
	SET @where = @where + @NewLineChar + 'AND  [cl].[StatusID] = ''' + CONVERT(nvarchar,@intStatusIdin) + ''''
END

IF @nvcValue   <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [clr].[value] = ''' + @nvcValue   + ''''
END

IF @nvcEmpIdin <> '-1' 
BEGIN
	SET @where = @where + @NewLineChar + ' AND [cl].[EmpID] =   ''' + @nvcEmpIdin  + '''' 
END

IF @nvcSupIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[Sup_ID] = ''' + @nvcSupIdin  + '''' 
END

IF @nvcMgrIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[Mgr_ID] = ''' + @nvcMgrIdin  + '''' 
END	

IF @nvcSubmitterIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar +  ' AND [cl].[SubmitterID] = ''' + @nvcSubmitterIdin  + '''' 
END

IF @intSiteIdin  <> -1
BEGIN
	SET @where = @where + @NewLineChar + ' AND [cl].[SiteID] = ''' + CONVERT(nvarchar, @intSiteIdin) + ''''
END			 

	 		 

SET @nvcSQL1 = ';WITH CL 
AS 
(
  SELECT * From [EC].[Coaching_Log] WITH (NOLOCK)
  WHERE convert(varchar(8), [SubmittedDate], 112) >= ''' + @strSDate + '''
    AND convert(varchar(8), [SubmittedDate], 112) <= ''' + @strEDate + '''
    AND [StatusID] <> 2
	AND [SourceID] NOT IN (235,236)
	AND SUBSTRING(strReportCode, 1, 3) <> ''ISQ'' 
)
SELECT [cl].[CoachingID] CoachingID
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
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
JOIN [EC].[Employee_Hierarchy] eh WITH (NOLOCK) ON eh.[EMP_ID] = veh.[EMP_ID]
JOIN cl ON cl.EmpID = eh.Emp_ID 
JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON cl.SubmitterID = vehs.EMP_ID 
JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID 
JOIN [EC].[DIM_Site] si ON cl.SiteID = si.SiteID 
JOIN [EC].[Coaching_Log_Reason]clr WITH (NOLOCK) ON cl.CoachingID = clr.CoachingID 
JOIN [EC].[DIM_Coaching_Reason]dcr ON clr.CoachingReasonID = dcr.CoachingReasonID
JOIN [EC].[DIM_Sub_Coaching_Reason]dscr ON clr.SubCoachingReasonID = dscr.SubCoachingReasonID ' +
+ @NewLineChar + @where + ' ' + '
ORDER BY [cl].[CoachingID];'



SET @nvcSQL2 = ';WITH CL 
AS 
(
  SELECT * From [EC].[Coaching_Log] WITH (NOLOCK)
  WHERE convert(varchar(8), [SubmittedDate], 112) >= ''' + @strSDate + '''
    AND convert(varchar(8), [SubmittedDate], 112) <= ''' + @strEDate + '''
    AND [StatusID] <> 2
	AND [SourceID] IN (235,236)
	AND [QNBatchStatus] = ''Active''
)
SELECT [cl].[CoachingID] CoachingID
  ,[cl].[FormName] FormName
  ,[cl].[QNBatchID] QNBatchID
  ,[cl].[QNBatchStatus] QNBatchStatus
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
  ,[cl].[CSRComments] EmpComments
  ,[qne].[VerintFormName] EvaluationForm
  ,[qne].[Journal_ID] VerintID
  ,[qne].[isCoachingMonitor] isCoachingMonitor
  ,[qne].[Program] ProgramName
  ,[qne].[Call_Date] EventDate
  ,[vehs].[Emp_Name] SubmitterName
  ,[qne].[EvalStatus] EvaluationStatus
  ,[dcr].[CoachingReason] CoachingReason
  ,[dscr].[SubCoachingReason] SubCoachingReason
  ,[cl].[Description] Description
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
FROM cl JOIN [EC].[Coaching_Log_Quality_Now_Evaluations]qne WITH (NOLOCK) 
ON cl.CoachingID = qne.CoachingID JOIN [EC].[Coaching_Log_Reason]clr WITH (NOLOCK) 
ON cl.CoachingID = clr.CoachingID JOIN [EC].[DIM_Coaching_Reason]dcr
ON clr.CoachingReasonID = dcr.CoachingReasonID JOIN [EC].[DIM_Sub_Coaching_Reason]dscr
ON clr.SubCoachingReasonID = dscr.SubCoachingReasonID  JOIN [EC].[DIM_Status] s 
ON cl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so 
ON cl.SourceID = so.SourceID JOIN [EC].[DIM_Site] si 
ON cl.SiteID = si.SiteID JOIN [EC].[Employee_Hierarchy] eh
ON cl.EmpID = eh.Emp_ID  JOIN [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
ON eh.[EMP_ID] = veh.[EMP_ID] JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK)
ON qne.Evaluator_ID = vehs.EMP_ID ' +
+ @NewLineChar + @where + ' ' +
'AND qne.[EvalStatus] = ''Active''
ORDER BY [cl].[CoachingID];'


SET @nvcSQL3 = ';WITH CL 
AS 
(
  SELECT * From [EC].[Coaching_Log] WITH (NOLOCK)
  WHERE convert(varchar(8), [SubmittedDate], 112) >= ''' + @strSDate + '''
    AND convert(varchar(8), [SubmittedDate], 112) <= ''' + @strEDate + '''
    AND [StatusID] <> 2
	AND [SourceID] = 212
	AND SUBSTRING(strReportCode, 1, 3) = ''ISQ'' 
)

SELECT [cl].[CoachingID] CoachingID
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
  ,[sce].[EventDate]	EventDate
  ,[cl].[CoachingDate] CoachingDate
  ,[sce].[VerintCallID] VerintID
  ,[cl].[Description] Description
  ,[sce].[CoachingNotes]	CoachingNotes
  ,[cl].[SubmittedDate]	SubmittedDate
  ,[cl].[SupReviewedAutoDate] SupReviewedAutoDate
  ,[cl].[MgrReviewManualDate] MgrReviewManualDate
  ,[cl].[MgrReviewAutoDate]	MgrReviewAutoDate
  ,[sce].[MgrAgreed]
  ,[sce].[MgrComments]
  ,[cl].[MgrNotes] MgrNotes
FROM cl JOIN [EC].[ShortCalls_Evaluations] sce WITH (NOLOCK) 
ON cl.CoachingID = sce.CoachingID JOIN [EC].[Coaching_Log_Reason]clr WITH (NOLOCK) 
ON cl.CoachingID = clr.CoachingID JOIN [EC].[DIM_Coaching_Reason]dcr
ON clr.CoachingReasonID = dcr.CoachingReasonID JOIN [EC].[DIM_Sub_Coaching_Reason]dscr
ON clr.SubCoachingReasonID = dscr.SubCoachingReasonID  JOIN [EC].[DIM_Status] s 
ON cl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so 
ON cl.SourceID = so.SourceID JOIN [EC].[DIM_Site] si 
ON cl.SiteID = si.SiteID JOIN [EC].[Employee_Hierarchy] eh
ON cl.EmpID = eh.Emp_ID  JOIN [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
ON eh.[EMP_ID] = veh.[EMP_ID] JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK)
ON cl.SubmitterId = vehs.EMP_ID ' +
+ @NewLineChar + @where + ' ' +
'ORDER BY [cl].[CoachingID];'


SET NOCOUNT ON;  
EXEC (@nvcSQL1)	
--PRINT @nvcSQL1

EXEC (@nvcSQL2)	
--PRINT @nvcSQL2

EXEC (@nvcSQL3)	
--PRINT @nvcSQL3

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey] 		    
END -- sp_SelectFrom_Coaching_Log_Historical_Export
GO
