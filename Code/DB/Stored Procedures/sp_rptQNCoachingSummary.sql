DROP PROCEDURE IF EXISTS [EC].[sp_rptQNCoachingSummary]; 
GO

/******************************************************************************* 
--	Author:			Susmitha Palacherla
--	Create Date:	3/27/2019
--	Description: Selects list of Quality Now Coaching Log Attributes for Coaching Summary Report.
--  Revision History:
--  Initial Revision: Quality Now Initiative TFS 13333 -  03/27/2019
--  Updated to support QN Alt Channels compliance and mastery levels. TFS 21276 - 5/19/2021
--  Modified to support Quality Now workflow enhancement . TFS 22187 - 08/03/2021
--  Added paging. TFS 26819 - 07/18/2023 LH
 *******************************************************************************/
CREATE PROCEDURE [EC].[sp_rptQNCoachingSummary] 
(
@intModulein int = -1,
@intStatusin int = -1, 
@intSitein int = -1,
@strEmpin nvarchar(10)= '-1',
@intCoachReasonin int = -1,
@intSubCoachReasonin int = -1,
@strSDatein datetime,
@strEDatein datetime,

@PageSize int,
@startRowIndex int, 
 ------------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
   @returnCode int OUTPUT,
   @returnMessage varchar(80) OUTPUT
)
AS
   DECLARE @storedProcedureName varchar(80)
   DECLARE @transactionCount int

   SET @transactionCount = @@TRANCOUNT
   SET @returnCode = 0

   --Only start a transaction if one has not already been started
   IF @transactionCount = 0
   BEGIN
      BEGIN TRANSACTION currentTransaction
   END
-- THE PRECEDING CODE SHOULD NOT BE MODIFIED
-------------------------------------------------------------------------------------
   SET @storedProcedureName = OBJECT_NAME(@@PROCID)
   SET @returnMessage = @storedProcedureName + ' completed successfully'
-------------------------------------------------------------------------------------
-- *** BEGIN: INSERT CUSTOM CODE HERE ***

SET NOCOUNT ON

DECLARE	
@strSDate nvarchar(10),
@strEDate nvarchar(10)


SET @strSDate = convert(varchar(8),@strSDatein,112)
SET @strEDate = convert(varchar(8),@strEDatein,112)

-- Open Symmetric Key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]  

;with a as (
 SELECT DISTINCT p.ModuleID AS [Employee Level ID]
                          ,c.Module AS [Employee Level Name]
              ,p.CoachingID AS [Coaching ID]
			  ,p.FormName AS [Log Name]
			   ,p.QNBatchID [Quality Now Batch ID]
               ,p.QNBatchStatus [Quality Now Batch Status]
			   ,c.Status
			  ,p.EmpID AS [Employee ID]
    	      ,CONVERT(nvarchar(50),DecryptByKey(c.EmpName)) AS [Employee Name]
    	      ,c.Site 
    	      ,ISNULL(c.LogSupID,'-') AS [Supervisor Employee ID]
			  ,CASE WHEN c.LogSupID IS NULL THEN '-'
			    ELSE CONVERT(nvarchar(50),DecryptByKey(c.LogSupName)) END AS [Supervisor Name]
			  ,ISNULL(c.LogMgrID,'-') AS [Manager Employee ID]
			  ,CASE WHEN c.LogMgrID IS NULL THEN '-'
			     ELSE CONVERT(nvarchar(50),DecryptByKey(c.LogMgrName))  END AS [Manager Name]
			  ,ISNULL(c.HierarchySupID,'-') AS [Current Supervisor Employee ID]
			  ,ISNULL(CONVERT(nvarchar(50),DecryptByKey( c.HierarchySupName)),'-')  AS [Current Supervisor Name]
			  ,ISNULL(c.HierarchyMgrID,'-') AS [Current Manager Employee ID]
			  ,ISNULL(CONVERT(nvarchar(50),DecryptByKey(c.HierarchyMgrName)),'-')  AS [Current Manager Name]
		      ,ISNULL(c.ReviewSupID,'-')AS [Review Supervisor Employee ID]
	          ,CASE 
	           WHEN c.ReviewSupID IS NULL THEN '-' 
	          ELSE CONVERT(nvarchar(50),DecryptByKey(c.ReviewSupName)) END AS [Review Supervisor Name]
	          ,ISNULL(c.ReviewMgrID,'-')AS [Review Manager Employee ID]
		      ,CASE 
		       WHEN c.ReviewMgrID IS NULL  THEN '-'
		         ELSE CONVERT(nvarchar(50),DecryptByKey(c.ReviewMgrName)) END AS [Review Manager Name]
			 -- ,q.[Summary_CallerIssues] AS Description
			   ,p.QNStrengthsOpportunities AS [Strength and Opportunities]
			   ,[EC].[fn_strQNEvalSummaryFromCoachingID](c.CoachingID) AS [Evaluation Summary]
			  ,COALESCE(p.CoachingNotes,'-') AS [Coaching Notes]    
			  ,ISNULL(CONVERT(varchar,q.Call_Date,121),'-') AS [Event Date]
              ,ISNULL(CONVERT(varchar,p.CoachingDate,121),'-') AS [Coaching Date]
              ,ISNULL(CONVERT(varchar,p.SubmittedDate,121),'-') AS [Submitted Date]
		      ,c.Source AS [Coaching Source]
		      ,c.SubSource AS [Sub Coaching Source]  
			   ,[EC].[fn_strCoachingReasonFromCoachingID](c.CoachingID) AS [Coaching Reason]
	          ,[EC].[fn_strSubCoachingReasonFromCoachingID](c.CoachingID)AS [SubCoaching Reason]
			  ,'NA' AS [Value]
			   ,q.Evaluator_ID AS [Submitter ID]
		        ,CONVERT(nvarchar(50),DecryptByKey(qs.Emp_Name)) AS [Submitter Name]
		      ,ISNULL(CONVERT(varchar,p.SupReviewedAutoDate,121),'-') AS [Supervisor Reviewed Date]
              ,ISNULL(CONVERT(varchar,p.MgrReviewManualDate,121),'-') AS [Manager Reviewed Manual Date]
			  ,ISNULL(CONVERT(varchar,p.MgrReviewAutoDate,121),'-') AS [Manager Reviewed Auto Date]
              ,COALESCE(p.MgrNotes,'-') AS [Manager Notes]
              ,ISNULL(CONVERT(varchar,p.CSRReviewAutoDate,121),'-') AS [Employee Reviewed Date]
              ,COALESCE(p.CSRComments,'-') AS [Employee Comments]
			   ,p.IsFollowupRequired AS [Follow-up Required]
			  ,ISNULL(CONVERT(varchar,p.FollowupDueDate,121),'-') AS [Follow-up Date]
			  ,ISNULL(CONVERT(varchar,p.FollowupActualDate,121),'-') AS [Follow-up Coaching Date]
			  ,p.SupFollowupCoachingNotes AS [Follow-up Coaching Notes]
			  ,ISNULL(CONVERT(varchar,p.SupFollowupAutoDate,121),'-') AS [Supervisor Follow-up Auto Date]
			  ,p.IsEmpFollowupAcknowledged AS [CSR Follow-up Acknowledged]
			  ,ISNULL(CONVERT(varchar,p.EmpAckFollowupAutoDate,121),'-') AS [CSR Follow-up Auto Date]
			  ,p.EmpAckFollowupComments AS [CSR Follow-up Comments]
			  ,p.FollowupSupID AS [Follow-up Supervisor ID]
		      ,p.SupFollowupReviewAutoDate AS [Supervisor Follow-up Review Auto Date]
			  ,p.SupFollowupReviewCoachingNotes AS [Supervisor Follow-up Review Coaching Notes]
			  ,p.SupFollowupReviewMonitoredLogs AS [Follow-up Review Monitored Logs]
			  ,p.FollowupReviewSupID  AS [Follow-up Review Supervisor ID]
			  ,q.Program AS [Program]
			  ,q.[Channel] AS [Channel]
			  ,ISNULL(q.Journal_ID,'-') AS [Verint ID]
			  ,CASE q.[Channel] WHEN 'Web Chat' THEN q.ActivityID ELSE '' END AS [ActivityID]
			  ,CASE q.[Channel] WHEN 'Written Correspondence' THEN q.DCN ELSE '' END AS [DCN]
			  ,COALESCE(q.VerintFormName,'-') AS [Verint Form Name]
              ,COALESCE(q.isCoachingMonitor,'-') AS [Coaching Monitor]
			  ,COALESCE(q.EvalStatus,'-') AS [Evaluation Status]
			  ,q.[Reason_For_Contact] AS [Reason For Contact]
		 	  ,q.[Contact_Reason_Comment] AS [Reason For Contact Comments]
			  ,q.Business_Process AS [Business Process]
			,q.Business_Process_Reason AS [Business Process Reason]
			,q.Business_Process_Comment AS [Business Process Comment]
			,q.Info_Accuracy AS [Info Accuracy]
			,q.Info_Accuracy_Reason AS [Info Accuracy Reason]
			,q.Info_Accuracy_Comment AS [Info Accuracy Comment]
			,q.Privacy_Disclaimers AS [Privacy Disclaimers]
			,q.Privacy_Disclaimers_Reason AS [Privacy Disclaimers Reason]
			,q.Privacy_Disclaimers_Comment AS [Privacy Disclaimers Comment]
			,CASE [q].[Channel] WHEN 'Written Correspondence'  THEN '' ELSE q.Issue_Resolution END AS [Issue Resolution]
			,CASE [q].[Channel] WHEN 'Written Correspondence'  THEN '' ELSE q.Issue_Resolution_Comment END AS  [Issue Resolution Comment]
			,CASE [q].[Channel] WHEN 'Written Correspondence'  THEN q.Issue_Resolution ELSE '' END AS [Business Correspondence]
			,CASE [q].[Channel] WHEN 'Written Correspondence'  THEN q.Issue_Resolution_Comment ELSE '' END AS  [Business Correspondence Comment]
			,CASE WHEN [q].[Channel] IN ('Written Correspondence', 'Web Chat')  THEN '' ELSE q.Call_Efficiency END AS [Call Efficiency]
			,CASE WHEN [q].[Channel] IN ('Written Correspondence', 'Web Chat')   THEN '' ELSE q.Call_Efficiency_Comment  END AS  [Call Efficiency Comment]
			,CASE [q].[Channel] WHEN 'Web Chat'  THEN q.Call_Efficiency ELSE '' END AS [Chat Efficiency]
			,CASE [q].[Channel] WHEN 'Web Chat'   THEN q.Call_Efficiency_Comment ELSE ''  END AS  [Chat Efficiency Comment]
			,CASE  WHEN [q].[Channel] IN ('Written Correspondence', 'Web Chat')  THEN '' ELSE q.Active_Listening END AS [Active Listening]
			,CASE  WHEN [q].[Channel] IN ('Written Correspondence', 'Web Chat')   THEN '' ELSE q.Active_Listening_Comment  END AS [Active Listening Comment]
			,CASE [q].[Channel] WHEN 'Web Chat'  THEN q.Active_Listening ELSE '' END AS [Issue Diagnosis]
			,CASE [q].[Channel] WHEN 'Web Chat'   THEN q.Active_Listening_Comment ELSE ''  END AS  [Issue Diagnosis Comment]
			,CASE  WHEN [q].[Channel] IN ('Written Correspondence', 'Web Chat')  THEN '' ELSE q.Personality_Flexing END AS [Personality Flexing]
			,CASE  WHEN [q].[Channel] IN ('Written Correspondence', 'Web Chat')   THEN '' ELSE q.Personality_Flexing_Comment  END AS [Personality Flexing Comment]
			,CASE [q].[Channel] WHEN 'Web Chat'  THEN q.Personality_Flexing ELSE '' END AS [Professional Communication]
			,CASE [q].[Channel] WHEN 'Web Chat'   THEN q.Personality_Flexing_Comment ELSE ''  END AS [Professional Communication Comment]
			,CASE  WHEN  [q].[Channel] =  'Written Correspondence'  THEN '' ELSE q.Customer_Temp_Start END AS  [Customer Temp Start]
			,CASE  WHEN  [q].[Channel] =  'Written Correspondence'  THEN '' ELSE q.Customer_Temp_Start_Comment END AS  [Customer Temp Start Comment]
			,CASE  WHEN  [q].[Channel] = 'Written Correspondence'  THEN '' ELSE q.Customer_Temp_End END AS [Customer Temp End]
			,CASE  WHEN  [q].[Channel] = 'Written Correspondence'  THEN '' ELSE q.Customer_Temp_End_Comment END AS  [Customer Temp End Comment]
      FROM [EC].[Coaching_Log] p WITH(NOLOCK)
      JOIN  (SELECT distinct [cl].[ModuleID] ModuleID
              ,[mo].[Module]Module
              ,[cl].[CoachingID] CoachingID
			  ,[cl].[FormName]	FormName
			  ,[s].[Status]	Status
			  ,[cl].[EmpID]	EmpID
    	      ,[eh].[Emp_Name]	EmpName
    	      ,[si].[City]	Site
    	      ,[cl].[SupID]	LogSupID
			  ,[suph].[Emp_Name]	LogSupName
			  ,[cl].[MgrID]	LogMgrID
			  ,[mgrh].[Emp_Name]	LogMgrName
			  ,[eh].[Sup_ID]	HierarchySupID
			  ,[eh].[Sup_Name]	HierarchySupName
			  ,[eh].[Mgr_ID]	HierarchyMgrID
			  ,[eh].[Mgr_Name]	HierarchyMgrName
		      ,[cl].[Review_SupID]	ReviewSupID
	          ,[rsuph].[Emp_Name]	ReviewSupName
	          ,[cl].[Review_MgrID]	ReviewMgrID
		      ,[rmgrh].[Emp_Name]	ReviewMgrName
		      ,[so].[CoachingSource] Source
		      ,[so].[SubCoachingSource]	SubSource
		      ,[dcr].[CoachingReason] CoachingReason
		      ,[dscr].[SubCoachingReason] SubCoachingReason
		      ,[clr].[Value] Value
		FROM [EC].[Coaching_Log] cl WITH(NOLOCK)JOIN [EC].[DIM_Status] s 
		ON cl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so 
		ON cl.SourceID = so.SourceID JOIN [EC].[DIM_Module] mo
		ON cl.ModuleID = mo.ModuleID JOIN [EC].[DIM_Site] si 
		ON cl.SiteID = si.SiteID JOIN [EC].[Coaching_Log_Reason] clr WITH (NOLOCK)
		ON cl.CoachingID = clr.CoachingID JOIN [EC].[DIM_Coaching_Reason]dcr 
		ON dcr.CoachingReasonID = clr.CoachingReasonID JOIN [EC].[DIM_Sub_Coaching_Reason]dscr
		ON dscr.SubCoachingReasonID = clr.SubCoachingReasonID JOIN [EC].[Employee_Hierarchy] eh 
		ON cl.EmpID = eh.Emp_ID  LEFT JOIN [EC].[Employee_Hierarchy] suph
		ON cl.SupID = suph.EMP_ID LEFT JOIN [EC].[Employee_Hierarchy] mgrh 
		ON cl.MgrID = mgrh.EMP_ID  LEFT JOIN [EC].[Employee_Hierarchy] rsuph
		ON cl.Review_SupID = rsuph.EMP_ID  LEFT JOIN [EC].[Employee_Hierarchy] rmgrh
		ON cl.Review_MgrID = rmgrh.EMP_ID 
		WHERE convert(varchar(8),[cl].[SubmittedDate],112) >= @strSDate
	    AND convert(varchar(8),[cl].[SubmittedDate],112) <= @strEDate
		AND [cl].[StatusID] <> 2
		AND [cl].[SourceID] IN (235,236)
	   AND [cl].[QNBatchStatus] = 'Active'
  	    AND  (([cl].[ModuleID] =(@intModulein) or @intModulein = -1) 
		AND  ([cl].[StatusID] =(@intStatusin) or @intStatusin = -1) 
		AND  ([cl].[SiteID] =(@intSitein) or @intSitein = -1) 
        AND  ([clr].[CoachingReasonID] = (@intCoachReasonin) or @intCoachReasonin = -1) 
        AND  ([clr].[SubCoachingReasonID] = (@intSubCoachReasonin)or @intSubCoachReasonin = -1)
        AND ([cl].[EmpID]= (@strEmpin)or @strEmpin = '-1'))
            GROUP BY [cl].[ModuleID],[mo].[Module],[cl].[CoachingID],[cl].[FormName],[s].[Status]	
			  ,[cl].[EmpID],[eh].[Emp_Name],[si].[City],[cl].[SupID],[suph].[Emp_Name],[cl].[MgrID]	
			  ,[mgrh].[Emp_Name],[eh].[Sup_ID],[eh].[Sup_Name] ,[eh].[Mgr_ID],[eh].[Mgr_Name]	
		      ,[cl].[Review_SupID],[rsuph].[Emp_Name],[cl].[Review_MgrID],[rmgrh].[Emp_Name]	
		      ,[so].[CoachingSource],[so].[SubCoachingSource],[dcr].[CoachingReason]
		      ,[dscr].[SubCoachingReason],[clr].[Value])c
		ON p.CoachingID = c.CoachingID JOIN [EC].[Coaching_Log_Quality_Now_Evaluations]q WITH (NOLOCK) 
		ON p.CoachingID = q.CoachingID LEFT JOIN [EC].[Employee_Hierarchy] qs
		ON q.Evaluator_ID = qs.EMP_ID 
        WHERE q.EvalStatus = 'Active'
),
b as (
	select ROW_NUMBER() over (order by [Submitted Date] desc) as RowNumber, Count(*) over () as TotalRows, * from a
)
select * from b
where RowNumber between @startRowIndex and @startRowIndex + @PageSize - 1;

  -- Clode Symmetric Key
  CLOSE SYMMETRIC KEY [CoachingKey] 
  
  	    
-- *** END: INSERT CUSTOM CODE HERE ***
-------------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
ENDPROC:
--  Commit or Rollback Transaction Only If We were NOT already in a Transaction
IF @transactionCount = 0
BEGIN
	IF @returnCode = 0
	BEGIN
		-- Commit Transaction
		commit transaction currentTransaction
	END
	ELSE 
	BEGIN
		-- Rollback Transaction
		rollback transaction currentTransaction
	END
END

PRINT STR(@returnCode) + ' ' + @returnMessage
RETURN @returnCode

-- THE PRECEDING CODE SHOULD NOT BE MODIFIED
-------------------------------------------------------------------------------------


GO
