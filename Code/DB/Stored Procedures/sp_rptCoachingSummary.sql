SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id('[EC].[sp_rptCoachingSummary]') and OBJECTPROPERTY(id, 'IsProcedure') = 1)
drop procedure EC.sp_rptCoachingSummary
GO

/******************************************************************************* 
sp_rptCoachingSummary
Description:
	Returns a list of coaching logs for a given time period and given module(s)

Tables:


Input Parameters:

Resultset:
	
 *******************************************************************************/

CREATE  PROCEDURE [EC].[sp_rptCoachingSummary]
(
   @StartDate datetime,
   @EndDate datetime,
   @JobCode varchar(10),
   @ModuleId int,
 --@userEmployeeId	varchar(20),
 
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

-- Create a temp table to hold resultset from sp_rptGetModules
CREATE TABLE #modules (ModuleId int, ModuleName varchar(20))

INSERT INTO #modules EXEC [EC].sp_rptGetModules @JobCode, @returnCode, @returnMessage

SELECT cl.ModuleID
      ,m.Module 
      ,cl.CoachingID
      ,FormName
      ,s.Status
      ,ProgramName
      ,EmpID
      ,eh.Emp_Name
      ,site.City
      ,SupID
      ,eh1.Emp_Name AS SupName
      ,MgrID
      ,eh2.Emp_Name AS MgrName
      ,eh.Sup_ID AS CurrentSupID
      ,eh.Sup_Name AS CurrentSupName
      ,eh.Mgr_ID AS CurrentMgrID
      ,eh.Mgr_Name AS CurrentMgrName
      ,cl.Review_SupID AS RvwSupID
      ,eh3.Emp_Name AS RvwSupName
      ,eh4.Emp_ID AS RvwMgrID
      ,eh4.Emp_Name AS RvwMgrName
      ,LTRIM(RTRIM(REPLACE(Description, '<br />', ''))) AS Description
      ,COALESCE(CoachingNotes,'-') AS CoachingNotes    
      ,ISNULL(CONVERT(varchar(20),EventDate,121),'-') AS EventDate
      ,ISNULL(CONVERT(varchar(20),CoachingDate,121),'-') AS CoachingDate
      ,ISNULL(CONVERT(varchar(20),SubmittedDate,121),'-') AS SubmittedDate
      ,src.CoachingSource
      ,src.SubCoachingSource
      ,cr.CoachingReason
      ,sr.SubCoachingReason
      ,clr.Value
      ,SubmitterID
      ,eh5.Emp_Name AS SubmitterName
      ,ISNULL(CONVERT(varchar(20),SupReviewedAutoDate,121),'-') AS SupRvwDate
      ,ISNULL(CONVERT(varchar(20),MgrReviewManualDate,121),'-') AS MgrRvwManualDate
      ,ISNULL(CONVERT(varchar(20),MgrReviewAutoDate,121),'-') AS MgrRvwAutoDate
      ,COALESCE(MgrNotes,'-') AS MgrNotes
      ,ISNULL(CONVERT(varchar(20),CSRReviewAutoDate,121),'-') AS EmpRvwDate
      ,REPLACE(COALESCE(CSRComments,'-'), CHAR(13) + char(10) + '<br />', '') AS EmpComments     
      ,Behavior
      ,strReportCode AS rptCode
      ,ISNULL(CONVERT(varchar(20),VerintID),'-') AS VerintID
      ,VerintFormName
      ,isCoachingMonitor
  FROM Coaching_Log cl
  JOIN DIM_Module m ON m.ModuleID = cl.ModuleID  
  JOIN Employee_Hierarchy eh ON eh.Emp_ID = cl.EmpID
  JOIN Employee_Hierarchy eh1 ON eh1.Emp_ID = cl.SupID
  JOIN Employee_Hierarchy eh2 ON eh2.Emp_ID = cl.MgrID 
  JOIN Employee_Hierarchy eh3 ON eh3.Emp_ID = cl.Review_SupID
  JOIN Employee_Hierarchy eh4 ON eh4.Emp_ID = cl.Review_MgrID 
  JOIN Employee_Hierarchy eh5 on eh5.Emp_ID = cl.SubmitterID
  JOIN DIM_Site site ON site.SiteID = cl.SiteID
  JOIN DIM_Source src ON src.SourceID = cl.SourceID
  JOIN DIM_Status s ON s.StatusID = cl.StatusID
  JOIN Coaching_Log_Reason clr ON clr.CoachingID = cl.CoachingID
  JOIN DIM_Coaching_Reason cr ON cr.CoachingReasonID = clr.CoachingReasonID		 
  JOIN DIM_Sub_Coaching_Reason sr ON sr.SubCoachingReasonID = clr.SubCoachingReasonID
  WHERE
  SubmittedDate BETWEEN (@StartDate) AND (@EndDate) AND
  ((@ModuleId = -1 AND cl.ModuleID in (SELECT ModuleId FROM #modules)) OR cl.ModuleID = @ModuleId)
  ORDER BY cl.CoachingID
  
  -- Drop the temp table
  DROP TABLE #modules

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

