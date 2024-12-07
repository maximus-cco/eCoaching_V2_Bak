
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_rptCoachingSummaryForModule' 
)
   DROP PROCEDURE [EC].[sp_rptCoachingSummaryForModule]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************* 
--	Author:			Susmitha Palacherla
-- Create date:       10/5/2017
-- Description:	
--  Given a Module and Begin and End Dates 
--  Selects list of Coaching Log Attributes for Coaching Summary Report.
-- Revision History
-- Initial Revision. Created during summary report scheduling. TFS 6066 - 10/05/2017
-- Modified to support Encryption of sensitive data. TFS 7856 - 11/28/2017
-- Modified to support Quality Now. TFS 13333 - 04/02/2019
--  Updated to support New Coaching Reason for Quality - 23051 - 09/29/2021

 *******************************************************************************/

CREATE OR ALTER PROCEDURE [EC].[sp_rptCoachingSummaryForModule] 
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

  SELECT DISTINCT p.ModuleID AS [Module ID]
              ,c.Module AS [Module Name]
              ,p.CoachingID AS [Coaching ID]
			  ,p.FormName AS [Form Name]
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
		       ,LTRIM(RTRIM(REPLACE(lEFT(p.Description,4000), '<br />', ''))) AS [Description]
			   ,COALESCE(p.CoachingNotes,'-') AS [Coaching Notes]    
              ,ISNULL(CONVERT(varchar,p.EventDate,20),'-') AS [Event Date]
              ,ISNULL(CONVERT(varchar,p.CoachingDate,20),'-') AS [Coaching Date]
              ,ISNULL(CONVERT(varchar,p.SubmittedDate,20),'-') AS [Submitted Date]
         	   ,ISNULL(CONVERT(varchar,p.PFDCompletedDate,20),'-') AS [PFD CompletedDate Date]
		      ,c.Source AS [Coaching Source]
		      ,c.SubSource AS [Sub Coaching Source]
		      ,[EC].[fn_strCoachingReasonFromCoachingID](c.CoachingID) AS [Coaching Reason]
	          ,[EC].[fn_strSubCoachingReasonFromCoachingID](c.CoachingID)AS [SubCoaching Reason]
	          ,[EC].[fn_strValueFromCoachingID](c.CoachingID)AS [Value]
		      ,c.SubmitterID AS [Submitter ID]
		        ,CONVERT(nvarchar(50),DecryptByKey(c.SubmitterName)) AS [Submitter Name]
		     ,ISNULL(CONVERT(varchar,p.SupReviewedAutoDate,20),'-') AS [Supervisor Reviewed Date]
              ,ISNULL(CONVERT(varchar,p.MgrReviewManualDate,20),'-') AS [Manager Reviewed Manual Date]
			  ,ISNULL(CONVERT(varchar,p.MgrReviewAutoDate,20),'-') AS [Manager Reviewed Auto Date]
              ,COALESCE(p.MgrNotes,'-') AS [Manager Notes]
              ,ISNULL(CONVERT(varchar,p.CSRReviewAutoDate,20),'-') AS [Employee Reviewed Date]
              ,COALESCE(p.CSRComments,'-') AS [Employee Comments]
              ,ISNULL(p.ProgramName ,'-') AS [ProgramName]
              ,ISNULL(p.Behavior,'-')AS [Behavior]
              ,ISNULL(p.strReportCode,'-') AS [Report Code]
              ,ISNULL(p.VerintID,'-') AS [Verint ID]
              ,ISNULL(p.VerintFormName,'-') AS [Verint Form Name]
              ,ISNULL(p.isCoachingMonitor,'-') AS [Coaching Monitor]
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
		WHERE [EC].[fn_intDatetime_to_YYYYMMDD]([cl].[SubmittedDate]) between @intBeginDate and @intEndDate
		AND [cl].[StatusID] <> 2
		AND [cl].[SourceID] NOT IN (235,236)
  	    AND  ([cl].[ModuleID] =(@intModulein) or @intModulein = -1) 
     GROUP BY [cl].[ModuleID],[mo].[Module],[cl].[CoachingID],[cl].[FormName],[s].[Status]	
			  ,[cl].[EmpID],[eh].[Emp_Name],[si].[City],[cl].[SupID],[suph].[Emp_Name],[cl].[MgrID]	
			  ,[mgrh].[Emp_Name],[eh].[Sup_ID],[eh].[Sup_Name] ,[eh].[Mgr_ID],[eh].[Mgr_Name]	
		      ,[cl].[Review_SupID],[rsuph].[Emp_Name],[cl].[Review_MgrID],[rmgrh].[Emp_Name]	
		      ,[so].[CoachingSource],[so].[SubCoachingSource],[dcr].[CoachingReason]
		      ,[dscr].[SubCoachingReason],[clr].[Value],[cl].[SubmitterID],[sh].[Emp_Name])c
		ON p.CoachingID = c.CoachingID
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


