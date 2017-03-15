/*
sp_rptCoachingSummary(02).sql
Last Modified Date: 03/14/2017
Last Modified By: Susmitha Palacherla


Version 02: Document Initial Revision - Suzy -  TFS 5621 - 03/14/2017

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



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	3/14/2017
--	Description: Selects list of Coaching Log Attributes for Coaching Summary Report.
--  Last Modified: 
--  Last Modified By:
--  Revision History:
--  Initial Revision - TFS 5621 - 03/14/2017
--	=====================================================================
CREATE PROCEDURE [EC].[sp_rptCoachingSummary] 



@intModulein int = -1,
@intStatusin int = -1, 
@intSitein int = -1,
@strEmpin nvarchar(10)= '-1',
@intCoachReasonin int = -1,
@intSubCoachReasonin int = -1,
@strSDatein datetime,
@strEDatein datetime

AS


BEGIN

SET NOCOUNT ON

DECLARE	
@strSDate nvarchar(10),
@strEDate nvarchar(10)
       

SET @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)

  SELECT p.ModuleID AS [Module ID]
              ,c.Module AS [Module Name]
              ,p.CoachingID AS [Coaching ID]
			  ,p.FormName AS [Form Name]
			  ,c.Status
			  ,p.EmpID AS [Employee ID]
    	      ,c.EmpName AS [Employee Name]
    	      ,c.Site
    	      ,c.LogSupID AS [Supervisor Employee ID]
			  ,c.LogSupName AS [Supervisor Name]
			  ,c.LogMgrID AS [Manager Employee ID]
			  ,c.LogMgrName AS [Manager Name]
			  ,c.HierarchySupID AS [Current Supervisor Employee ID]
			  ,c.HierarchySupName  AS [Current Supervisor Name]
			  ,c.HierarchyMgrID AS [Current Manager Employee ID]
			  ,c.HierarchyMgrName  AS [Current Manager Name]
		      ,ISNULL(c.ReviewSupID,'-')AS [Review Supervisor Employee ID]
	          ,ISNULL(c.ReviewSupName,'-')AS [Review Supervisor Name]
	          ,ISNULL(c.ReviewMgrID,'-')AS [Review Manager Employee ID]
		      ,ISNULL(c.ReviewMgrName,'-')AS [Review Manager Name]
	          ,LTRIM(RTRIM(REPLACE(c.Description, '<br />', ''))) AS [Description]
              ,COALESCE(c.CoachingNotes,'-') AS [Coaching Notes]    
              ,ISNULL(CONVERT(varchar,c.EventDate,121),'-') AS [Event Date]
              ,ISNULL(CONVERT(varchar,c.CoachingDate,121),'-') AS [Coaching Date]
              ,ISNULL(CONVERT(varchar,c.SubmittedDate,121),'-') AS [Submitted Date]
		      ,c.Source AS [Coaching Source]
		      ,c.SubSource AS [Sub Coaching Source]
		      ,[EC].[fn_strCoachingReasonFromCoachingID](c.CoachingID) AS [Coaching Reason]
	          ,[EC].[fn_strSubCoachingReasonFromCoachingID](c.CoachingID)AS [SubCoaching Reason]
	          ,[EC].[fn_strValueFromCoachingID](c.CoachingID)AS [Value]
		      ,c.SubmitterID AS [Submitter ID]
		      ,c.SubmitterName AS [Submitter Name]
		      ,ISNULL(CONVERT(varchar,c.SupReviewedDate,121),'-') AS [Supervisor Reviewed Date]
              ,ISNULL(CONVERT(varchar,c.MgrReviewedMDate,121),'-') AS [Manager Reviewed Manual Date]
			  ,ISNULL(CONVERT(varchar,c.MgrReviewedADate,121),'-') AS [Manager Reviewed Auto Date]
              ,ISNULL(c.MgrNotes,'-') AS [Manager Notes]
              ,ISNULL(CONVERT(varchar,c.EmpReviewedDate,121),'-') AS [Employee Reviewed Date]
              ,ISNULL(c.EmpComments,'-') AS [Employee Comments]
              ,c.ProgramName 
              ,ISNULL(c.Behavior,'-')AS [Behavior]
              ,ISNULL(c.ReportCode,'-') AS [Report Code]
              ,ISNULL(c.VerintID,'-') AS [Verint ID]
              ,ISNULL(c.VerintFormName,'-') AS [Verint Form Name]
              ,ISNULL(c.isCoachingMonitor,'-') AS [Coaching Monitor]
      FROM [EC].[Coaching_Log] p 
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
		      ,[cl].[Description]	Description
		      ,[cl].[CoachingNotes]	CoachingNotes
		      ,[cl].[EventDate]	EventDate
		      ,[cl].[CoachingDate]	CoachingDate
		      ,[cl].[SubmittedDate]	SubmittedDate
		      ,[so].[CoachingSource] Source
		      ,[so].[SubCoachingSource]	SubSource
		      ,[dcr].[CoachingReason]CoachingReason
		      ,[dscr].[SubCoachingReason]SubCoachingReason
		      ,[clr].[Value]Value
		      ,[cl].[SubmitterID]	SubmitterID
		      ,[sh].[Emp_Name]	SubmitterName
		      ,[cl].[SupReviewedAutoDate] SupReviewedDate
              ,[cl].[MgrReviewManualDate] MgrReviewedMDate
			  ,[cl].[MgrReviewAutoDate] MgrReviewedADate
              ,[cl].[MgrNotes] MgrNotes
              ,[cl].[CSRReviewAutoDate] EmpReviewedDate
              ,[cl].[CSRComments] EmpComments
              ,[cl].[ProgramName]	ProgramName
              ,[cl].[Behavior]	Behavior
              ,[cl].[strReportCode]	ReportCode
              ,[cl].[VerintID]	VerintID
              ,[cl].[VerintFormName]	VerintFormName
              ,[cl].[isCoachingMonitor]	isCoachingMonitor
		FROM [EC].[Employee_Hierarchy] eh 
		JOIN [EC].[Coaching_Log] cl WITH(NOLOCK)ON cl.EmpID = eh.Emp_ID
		JOIN [EC].[Employee_Hierarchy] sh ON ISNULL(cl.SubmitterID,'999999') = sh.EMP_ID 
		JOIN [EC].[Employee_Hierarchy] suph ON ISNULL(cl.SupID,'999999') = suph.EMP_ID 
		JOIN [EC].[Employee_Hierarchy] mgrh ON ISNULL(cl.MgrID, '999999') = mgrh.EMP_ID 
		JOIN [EC].[Employee_Hierarchy] rsuph ON ISNULL(cl.Review_SupID,'999999') = rsuph.EMP_ID 
		JOIN [EC].[Employee_Hierarchy] rmgrh ON ISNULL(cl.Review_MgrID, '999999') = rmgrh.EMP_ID 
		JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
		JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID 
		JOIN [EC].[DIM_Module] mo ON cl.ModuleID = mo.ModuleID 
		JOIN [EC].[DIM_Site] si ON cl.SiteID = si.SiteID 
		JOIN [EC].[Coaching_Log_Reason] clr WITH (NOLOCK)ON cl.CoachingID = clr.CoachingID
		JOIN [EC].[DIM_Coaching_Reason]dcr ON dcr.CoachingReasonID = clr.CoachingReasonID
		JOIN [EC].[DIM_Sub_Coaching_Reason]dscr ON dscr.SubCoachingReasonID = clr.SubCoachingReasonID 
		WHERE convert(varchar(8),[cl].[SubmittedDate],112) >= @strSDate
	    AND convert(varchar(8),[cl].[SubmittedDate],112) <= @strEDate
		AND [cl].[StatusID] <> 2
  	    AND  (([cl].[ModuleID] =(@intModulein) or @intModulein = -1) 
		AND  ([cl].[StatusID] =(@intStatusin) or @intStatusin = -1) 
		AND  ([cl].[SiteID] =(@intSitein) or @intSitein = -1) 
        AND  ([clr].[CoachingReasonID] = (@intCoachReasonin) or @intCoachReasonin = -1) 
        AND  ([clr].[SubCoachingReasonID] = (@intSubCoachReasonin)or @intSubCoachReasonin = -1)
        AND ([cl].[EmpID]= (@strEmpin)or @strEmpin = '-1'))
		)c
		ON p.CoachingID = c.CoachingID
        ORDER BY p.SubmittedDate DESC

	    
END -- sp_rptCoachingSummary



GO

