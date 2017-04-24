/*
sp_rptCoachingSummary(04).sql
Last Modified Date: 04/19/2017
Last Modified By: Susmitha Palacherla

Version 04: Updated Joins to use left join - Suzy -  TFS 5621 - 04/19/2017

Version 03: Updated formatting - Suzy -  TFS 5621 - 03/17/2017

Version 02: Updated parameters - Suzy -  TFS 5621 - 03/14/2017

Version 01: Document Initial Revision - Lili -  TFS 5621 - 03/09/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_rptCoachingSummary' 
)
   DROP PROCEDURE [EC].[sp_rptCoachingSummary]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







/******************************************************************************* 
--	Author:			Susmitha Palacherla
--	Create Date:	3/14/2017
--	Description: Selects list of Coaching Log Attributes for Coaching Summary Report.
--  Last Modified: 
--  Last Modified By:
--  Revision History:
--  Initial Revision - TFS 5621 -  03/14/2017 (Modified 04/19/2017)
 *******************************************************************************/

CREATE PROCEDURE [EC].[sp_rptCoachingSummary] 
(
@intModulein int = -1,
@intStatusin int = -1, 
@intSitein int = -1,
@strEmpin nvarchar(10)= '-1',
@intCoachReasonin int = -1,
@intSubCoachReasonin int = -1,
@strSDatein datetime,
@strEDatein datetime,
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

  SELECT p.ModuleID AS [Module ID]
              ,c.Module AS [Module Name]
              ,p.CoachingID AS [Coaching ID]
			  ,p.FormName AS [Form Name]
			  ,c.Status
			  ,p.EmpID AS [Employee ID]
    	      ,c.EmpName AS [Employee Name]
    	      ,c.Site
    	      ,ISNULL(c.LogSupID,'-') AS [Supervisor Employee ID]
			  ,CASE WHEN c.LogSupID IS NULL THEN '-'
			   ELSE c.LogSupName END AS [Supervisor Name]
			  ,ISNULL(c.LogMgrID,'-') AS [Manager Employee ID]
			  ,CASE WHEN c.LogMgrID IS NULL THEN '-'
			   ELSE c.LogMgrName END AS [Manager Name]
			  ,ISNULL(c.HierarchySupID,'-') AS [Current Supervisor Employee ID]
			  ,ISNULL(c.HierarchySupName,'-')  AS [Current Supervisor Name]
			  ,ISNULL(c.HierarchyMgrID,'-') AS [Current Manager Employee ID]
			  ,ISNULL(c.HierarchyMgrName,'-')  AS [Current Manager Name]
		      ,ISNULL(c.ReviewSupID,'-')AS [Review Supervisor Employee ID]
	          ,CASE 
	           WHEN c.ReviewSupID IS NULL THEN '-' 
	           ELSE c.ReviewSupName END AS [Review Supervisor Name]
	          ,ISNULL(c.ReviewMgrID,'-')AS [Review Manager Employee ID]
		      ,CASE 
		       WHEN c.ReviewMgrID IS NULL  THEN '-'
		       ELSE c.ReviewMgrName END AS [Review Manager Name]
		       ,LTRIM(RTRIM(REPLACE(p.Description, '<br />', ''))) AS [Description]
              ,COALESCE(p.CoachingNotes,'-') AS [Coaching Notes]    
              ,ISNULL(CONVERT(varchar,p.EventDate,121),'-') AS [Event Date]
              ,ISNULL(CONVERT(varchar,p.CoachingDate,121),'-') AS [Coaching Date]
              ,ISNULL(CONVERT(varchar,p.SubmittedDate,121),'-') AS [Submitted Date]
		      ,c.Source AS [Coaching Source]
		      ,c.SubSource AS [Sub Coaching Source]
		      ,[EC].[fn_strCoachingReasonFromCoachingID](c.CoachingID) AS [Coaching Reason]
	          ,[EC].[fn_strSubCoachingReasonFromCoachingID](c.CoachingID)AS [SubCoaching Reason]
	          ,[EC].[fn_strValueFromCoachingID](c.CoachingID)AS [Value]
		      ,c.SubmitterID AS [Submitter ID]
		      ,c.SubmitterName AS [Submitter Name]
		      ,ISNULL(CONVERT(varchar,p.SupReviewedAutoDate,121),'-') AS [Supervisor Reviewed Date]
              ,ISNULL(CONVERT(varchar,p.MgrReviewManualDate,121),'-') AS [Manager Reviewed Manual Date]
			  ,ISNULL(CONVERT(varchar,p.MgrReviewAutoDate,121),'-') AS [Manager Reviewed Auto Date]
              ,COALESCE(p.MgrNotes,'-') AS [Manager Notes]
              ,ISNULL(CONVERT(varchar,p.CSRReviewAutoDate,121),'-') AS [Employee Reviewed Date]
              ,COALESCE(p.CSRComments,'-') AS [Employee Comments]
              ,ISNULL(p.ProgramName ,'-') AS [ProgramName]
              ,ISNULL(p.Behavior,'-')AS [Behavior]
              ,ISNULL(p.strReportCode,'-') AS [Report Code]
              ,ISNULL(p.VerintID,'-') AS [Verint ID]
              ,ISNULL(p.VerintFormName,'-') AS [Verint Form Name]
              ,ISNULL(p.isCoachingMonitor,'-') AS [Coaching Monitor]
      FROM [EC].[Coaching_Log] p WITH(NOLOCK)
      JOIN  (SELECT [cl].[ModuleID] ModuleID
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
		      ,[dcr].[CoachingReason]CoachingReason
		      ,[dscr].[SubCoachingReason]SubCoachingReason
		      ,[clr].[Value]Value
		      ,[cl].[SubmitterID]	SubmitterID
		      ,[sh].[Emp_Name]	SubmitterName
		FROM [EC].[Coaching_Log] cl WITH(NOLOCK)JOIN [EC].[DIM_Status] s 
		ON cl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so 
		ON cl.SourceID = so.SourceID JOIN [EC].[DIM_Module] mo
		ON cl.ModuleID = mo.ModuleID JOIN [EC].[DIM_Site] si 
		ON cl.SiteID = si.SiteID JOIN [EC].[Coaching_Log_Reason] clr WITH (NOLOCK)
		ON cl.CoachingID = clr.CoachingID JOIN [EC].[DIM_Coaching_Reason]dcr 
		ON dcr.CoachingReasonID = clr.CoachingReasonID JOIN [EC].[DIM_Sub_Coaching_Reason]dscr
		ON dscr.SubCoachingReasonID = clr.SubCoachingReasonID JOIN [EC].[Employee_Hierarchy] eh 
		ON cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh
		ON cl.SubmitterID = sh.EMP_ID LEFT JOIN [EC].[Employee_Hierarchy] suph
		ON cl.SupID = suph.EMP_ID LEFT JOIN [EC].[Employee_Hierarchy] mgrh 
		ON cl.MgrID = mgrh.EMP_ID  LEFT JOIN [EC].[Employee_Hierarchy] rsuph
		ON cl.Review_SupID = rsuph.EMP_ID  LEFT JOIN [EC].[Employee_Hierarchy] rmgrh
		ON cl.Review_MgrID = rmgrh.EMP_ID 
		WHERE convert(varchar(8),[cl].[SubmittedDate],112) >= @strSDate
	    AND convert(varchar(8),[cl].[SubmittedDate],112) <= @strEDate
		AND [cl].[StatusID] <> 2
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
		      ,[dscr].[SubCoachingReason],[clr].[Value],[cl].[SubmitterID],[sh].[Emp_Name])c
		ON p.CoachingID = c.CoachingID
        ORDER BY p.SubmittedDate DESC

	    
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



