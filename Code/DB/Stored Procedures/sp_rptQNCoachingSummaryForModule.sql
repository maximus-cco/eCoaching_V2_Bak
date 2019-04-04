/*
sp_rptQNCoachingSummaryForModule(01).sql
Last Modified Date: 04/02/2019
Last Modified By: Susmitha Palacherla

Version 01: Document Initial Revision - TFS 13333 - 04/02/2019
*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_rptQNCoachingSummaryForModule' 
)
   DROP PROCEDURE [EC].[sp_rptQNCoachingSummaryForModule]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************* 
--	Author:			Susmitha Palacherla
--	Create Date:	3/27/2019
--	Description: Selects list of Quality Now Coaching Log Attributes for Coaching Summary Report.
--  Revision History:
--  Initial Revision: Quality Now Initiative TFS 13333 -  03/27/2019

 *******************************************************************************/
CREATE PROCEDURE [EC].[sp_rptQNCoachingSummaryForModule] 
(
@intModulein int = -1,
@intBeginDate int = NULL,  -- YYYYMMDD
@intEndDate int = NULL,     -- YYYYMMDD
 ------------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
   @returnCode int = NULL OUTPUT ,
   @returnMessage varchar(80) = NULL OUTPUT
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

-- Uncomment below lines for Testing 
--SET @intBeginDate = 20170901  -- YYYYMMDD
--SET @intEndDate = 20170930     -- YYYYMMDD

-- Open Symmetric Key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]  

  SELECT DISTINCT p.ModuleID AS [Employee Level ID]
              ,c.Module AS [Employee Level Name]
              ,p.CoachingID AS [Coaching ID]
			  ,p.FormName AS [Form Name]
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
		      ,COALESCE(p.CoachingNotes,'-') AS [Coaching Notes]    
              ,ISNULL(CONVERT(varchar,p.CoachingDate,121),'-') AS [Coaching Date]
              ,ISNULL(CONVERT(varchar,p.SubmittedDate,121),'-') AS [Submitted Date]
		      ,c.Source AS [Coaching Source]
		      ,c.SubSource AS [Sub Coaching Source]  
		      ,ISNULL(CONVERT(varchar,p.SupReviewedAutoDate,121),'-') AS [Supervisor Reviewed Date]
              ,ISNULL(CONVERT(varchar,p.MgrReviewManualDate,121),'-') AS [Manager Reviewed Manual Date]
			  ,ISNULL(CONVERT(varchar,p.MgrReviewAutoDate,121),'-') AS [Manager Reviewed Auto Date]
              ,COALESCE(p.MgrNotes,'-') AS [Manager Notes]
              ,ISNULL(CONVERT(varchar,p.CSRReviewAutoDate,121),'-') AS [Employee Reviewed Date]
              ,COALESCE(p.CSRComments,'-') AS [Employee Comments]
			  ,ISNULL(CONVERT(varchar,q.Call_Date,121),'-') AS [Event Date]
			  ,q.[Summary_CallerIssues] AS Description
		      ,[EC].[fn_strCoachingReasonFromCoachingID](c.CoachingID) AS [Coaching Reason]
	          ,[EC].[fn_strSubCoachingReasonFromCoachingID](c.CoachingID)AS [SubCoaching Reason]
			  ,'NA' AS [Value]
			   ,q.Evaluator_ID AS [Submitter ID]
		        ,CONVERT(nvarchar(50),DecryptByKey(qs.Emp_Name)) AS [Submitter Name]
				,q.Program AS [Program]
			  ,ISNULL(q.Journal_ID,'-') AS [Verint ID]
              ,ISNULL(q.VerintFormName,'-') AS [Verint Form Name]
              ,ISNULL(q.isCoachingMonitor,'-') AS [Coaching Monitor]
			  ,ISNULL(q.EvalStatus,'-') AS [Evaluation Status]
			  ,q.Business_Process AS [Business Process]
			,q.Business_Process_Reason AS [Business Process Reason]
			,q.Business_Process_Comment AS [Business Process Comment]
			,q.Info_Accuracy AS [Info Accuracy]
			,q.Info_Accuracy_Reason AS [Info Accuracy Reason]
			,q.Info_Accuracy_Comment AS [Info Accuracy Comment]
			,q.Privacy_Disclaimers AS [Privacy Disclaimers]
			,q.Privacy_Disclaimers_Reason AS [Privacy Disclaimers Reason]
			,q.Privacy_Disclaimers_Comment AS [Privacy Disclaimers Comment]
			,q.Issue_Resolution AS [Issue Resolution]
			,q.Issue_Resolution_Comment AS [Issue Resolution Comment]
			,q.Call_Efficiency AS [Call Efficiency]
			,q.Call_Efficiency_Comment AS [Call Efficiency Comment]
			,q.Active_Listening AS [Active Listening]
			,q.Active_Listening_Comment AS [Active Listening Comment]
			,q.Personality_Flexing AS [Personality Flexing]
			,q.Personality_Flexing_Comment AS [Personality Flexing Comment]
			,q.Customer_Temp_Start AS [Customer Temp Start]
			,q.Customer_Temp_Start_Comment AS [Customer Temp Start Comment]
			,q.Customer_Temp_End AS [Customer Temp End]
			,q.Customer_Temp_End_Comment AS [Customer Temp End Comment]
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
		ON cl.EmpID = eh.Emp_ID LEFT JOIN [EC].[Employee_Hierarchy] suph
		ON cl.SupID = suph.EMP_ID LEFT JOIN [EC].[Employee_Hierarchy] mgrh 
		ON cl.MgrID = mgrh.EMP_ID  LEFT JOIN [EC].[Employee_Hierarchy] rsuph
		ON cl.Review_SupID = rsuph.EMP_ID  LEFT JOIN [EC].[Employee_Hierarchy] rmgrh
		ON cl.Review_MgrID = rmgrh.EMP_ID 
		WHERE [EC].[fn_intDatetime_to_YYYYMMDD]([cl].[SubmittedDate]) between @intBeginDate and @intEndDate
		AND [cl].[StatusID] <> 2
		AND [cl].[SourceID] IN (235,236)
	   AND [cl].[QNBatchStatus] = 'Active'
  	    AND  ([cl].[ModuleID] =(@intModulein) or @intModulein = -1) 
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
        ORDER BY [Submitted Date] DESC

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



