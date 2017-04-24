/*
sp_rptWarningSummary(03).sql
Last Modified Date: 04/19/2017
Last Modified By: Susmitha Palacherla

Version 03: Updated Joins to use left join - Suzy -  TFS 5621 - 04/19/2017

Version 02: Added State - TFS 5621 - 04/10/2017

Version 01: Document Initial Revision - Suzy Palacherla -  TFS 5621 - 03/27/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_rptWarningSummary' 
)
   DROP PROCEDURE [EC].[sp_rptWarningSummary]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/******************************************************************************* 
--	Author:			Susmitha Palacherla
--	Create Date:	3/27/2017
--	Description: Selects list of Warning Log Attributes for Warning Summary Report.
--  Last Modified: 
--  Last Modified By:
--  Revision History:
--  Initial Revision - TFS 5621 - 03/27/2017 (Modified 04/19/2017)
 *******************************************************************************/

CREATE PROCEDURE [EC].[sp_rptWarningSummary] 
(
@intModulein int = -1,
@intStatusin int = -1, 
@intSitein int = -1,
@strEmpin nvarchar(10)= '-1',
@intWarnReasonin int = -1,
@intSubWarnReasonin int = -1,
@strActive nvarchar(3) = '-1',
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
              ,w.Module AS [Module Name]
              ,p.WarningID AS [Warning ID]
			  ,p.FormName AS [Form Name]
			  ,w.Status
			  ,p.EmpID AS [Employee ID]
    	      ,w.EmpName AS [Employee Name]
    	      ,w.Site
    	      ,ISNULL(w.LogSupID,'-') AS [Supervisor Employee ID]
			  ,CASE WHEN w.LogSupID IS NULL THEN '-'
			   ELSE w.LogSupName END AS [Supervisor Name]
			  ,ISNULL(w.LogMgrID,'-') AS [Manager Employee ID]
			  ,CASE WHEN w.LogMgrID IS NULL THEN '-'
			   ELSE w.LogMgrName END AS [Manager Name]
			  ,ISNULL(w.HierarchySupID,'-') AS [Current Supervisor Employee ID]
			  ,ISNULL(w.HierarchySupName,'-')  AS [Current Supervisor Name]
			  ,ISNULL(w.HierarchyMgrID,'-') AS [Current Manager Employee ID]
			  ,ISNULL(w.HierarchyMgrName,'-')  AS [Current Manager Name]
		      ,ISNULL(CONVERT(varchar,w.WarningGivenDate,121),'-') AS [Warning given Date]
              ,ISNULL(CONVERT(varchar,w.SubmittedDate,121),'-') AS [Submitted Date]
              ,ISNULL(CONVERT(varchar,w.WarningExpiryDate,121),'-') AS [Expiration Date]
		      ,w.Source AS [Warning Source]
		      ,w.SubSource AS [Sub Warning Source]
		      ,[EC].[fn_strCoachingReasonFromWarningID](w.WarningID) AS [Warning Reason]
	          ,[EC].[fn_strSubCoachingReasonFromWarningID](w.WarningID)AS [Warning SubReason]
	          ,[EC].[fn_strValueFromwarningID](w.WarningID)AS [Value]
		      ,ISNULL(w.SubmitterID,'Unknown') AS [Submitter ID]
		      ,ISNULL(w.SubmitterName,'Unknown') AS [Submitter Name]
		      ,ISNULL(w.ProgramName,'-') AS [Program Name]
              ,ISNULL(w.Behavior,'-')AS [Behavior]
              ,ISNULL(w.[State],'-')AS [State]
      FROM [EC].[Warning_Log] p WITH(NOLOCK)
      JOIN  (SELECT [wl].[ModuleID] ModuleID
              ,[mo].[Module]Module
              ,[wl].[WarningID] WarningID
			  ,[wl].[FormName]	FormName
			  ,[s].[Status]	Status
			  ,[wl].[EmpID]	EmpID
    	      ,[eh].[Emp_Name]	EmpName
    	      ,[si].[City]	Site
    	      ,[wl].[SupID]	LogSupID
			  ,[suph].[Emp_Name]	LogSupName
			  ,[wl].[MgrID]	LogMgrID
			  ,[mgrh].[Emp_Name]	LogMgrName
			  ,[eh].[Sup_ID]	HierarchySupID
			  ,[eh].[Sup_Name]	HierarchySupName
			  ,[eh].[Mgr_ID]	HierarchyMgrID
			  ,[eh].[Mgr_Name]	HierarchyMgrName
		      ,[wl].[WarningGivenDate]	WarningGivenDate
		      ,[wl].[SubmittedDate]	SubmittedDate
		      ,DATEADD(D,91,[wl].[WarningGivenDate])	WarningExpiryDate
		      ,[so].[CoachingSource] Source
		      ,[so].[SubCoachingSource]	SubSource
		      ,[dcr].[CoachingReason]WarningReason
		      ,[dscr].[SubCoachingReason]SubWarnReason
		      ,[wlr].[Value]Value
		      ,[wl].[SubmitterID]	SubmitterID
		      ,[sh].[Emp_Name]	SubmitterName
		      ,[wl].[ProgramName]	ProgramName
              ,[wl].[Behavior]	Behavior
              ,CASE WHEN [wl].[Active] = 1 THEN 'Active' 
               ELSE 'Expired' END AS [State]
        FROM [EC].[Warning_Log] wl WITH(NOLOCK) JOIN [EC].[DIM_Status] s 
		ON wl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so 
		ON wl.SourceID = so.SourceID JOIN [EC].[DIM_Module] mo
		ON wl.ModuleID = mo.ModuleID JOIN [EC].[DIM_Site] si 
		ON wl.SiteID = si.SiteID JOIN [EC].[Warning_Log_Reason] wlr WITH (NOLOCK)
		ON wl.WarningID = wlr.WarningID JOIN [EC].[DIM_Coaching_Reason]dcr 
		ON dcr.CoachingReasonID = wlr.CoachingReasonID JOIN [EC].[DIM_Sub_Coaching_Reason]dscr 
		ON dscr.SubCoachingReasonID = wlr.SubCoachingReasonID JOIN [EC].[Employee_Hierarchy] eh 
		ON wl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh
		ON wl.SubmitterID = sh.EMP_ID LEFT JOIN [EC].[Employee_Hierarchy] suph
		ON wl.SupID = suph.EMP_ID LEFT JOIN [EC].[Employee_Hierarchy] mgrh
		ON wl.MgrID = mgrh.EMP_ID 
		WHERE convert(varchar(8),[wl].[SubmittedDate],112) >= @strSDate
	    AND convert(varchar(8),[wl].[SubmittedDate],112) <= @strEDate
	    AND  (([wl].[ModuleID] =(@intModulein) or @intModulein = -1) 
		AND  ([wl].[StatusID] =(@intStatusin) or @intStatusin = -1) 
		AND  ([wl].[SiteID] =(@intSitein) or @intSitein = -1) 
		AND (CONVERT(NVARCHAR,[wl].[Active]) = (@strActive)or @strActive = '-1')
	    AND  ([wlr].[CoachingReasonID] = (@intWarnReasonin) or @intWarnReasonin = -1) 
        AND  ([wlr].[SubCoachingReasonID] = (@intSubWarnReasonin)or @intSubWarnReasonin = -1)
        AND ([wl].[EmpID]= (@strEmpin)or @strEmpin = '-1'))
		)w
		ON p.WarningID = w.WarningID
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


