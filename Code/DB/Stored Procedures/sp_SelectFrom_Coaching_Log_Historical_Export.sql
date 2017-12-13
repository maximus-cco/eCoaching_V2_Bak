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
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Historical_Export] 

@strSourcein nvarchar(100),
@strCSRSitein nvarchar(30),
@strCSRin nvarchar(30),
@strSUPin nvarchar(30),
@strMGRin nvarchar(30),
@strSubmitterin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@strStatusin nvarchar(30), 
@strvalue  nvarchar(30)

AS

BEGIN

DECLARE	
@nvcSQL nvarchar(max),
@strSDate nvarchar(8),
@strEDate nvarchar(8),
@where nvarchar(max);  

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @strSDate = convert(varchar(8), @strSDatein,112)
SET @strEDate = convert(varchar(8), @strEDatein,112)
SET @where = ' '
			 
IF @strSourcein <> '%'
BEGIN
	SET @where = @where + ' AND [so].[SubCoachingSource] = ''' + @strSourcein + ''''
END
IF @strStatusin <> '%'
BEGIN
	SET @where = @where + ' AND [s].[Status] = ''' + @strStatusin + ''''
END
IF @strvalue <> '%'
BEGIN
	SET @where = @where + ' AND [clr].[value] = ''' + @strvalue + ''''
END
IF @strCSRin <> '%' 
BEGIN
	SET @where = @where + ' AND [cl].[EmpID] =   ''' + @strCSRin + '''' 
END
IF @strSUPin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Sup_ID] = ''' + @strSUPin + '''' 
END
IF @strMGRin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Mgr_ID] = ''' + @strMGRin + '''' 
END	
IF @strSubmitterin <> '%'
BEGIN
	SET @where = @where + ' AND [cl].[SubmitterID] = ''' + @strSubmitterin + '''' 
END
IF @strCSRSitein <> '%'
BEGIN
	SET @where = @where + ' AND CONVERT(varchar, [cl].[SiteID]) = ''' + @strCSRSitein + ''''
END			 

SET @nvcSQL = ';WITH CL 
AS 
(
  SELECT * From [EC].[Coaching_Log] WITH (NOLOCK)
  WHERE convert(varchar(8), [SubmittedDate], 112) >= ''' + @strSDate + '''
    AND convert(varchar(8), [SubmittedDate], 112) <= ''' + @strEDate + '''
    AND [StatusID] <> 2
)
SELECT [cl].[CoachingID] CoachingID
  ,[cl].[FormName] FormName
  ,[cl].[ProgramName] ProgramName
  ,[cl].[EmpID]	EmpID
  ,[veh].[Emp_Name]	CSRName
  ,[veh].[Sup_Name]	CSRSupName
  ,[veh].[Mgr_Name]	CSRMgrName
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
  ,[cl].[CSRReviewAutoDate]	CSRReviewAutoDate
  ,[cl].[CSRComments] CSRComments
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
@where + ' ' + '
ORDER BY [cl].[CoachingID]'

EXEC (@nvcSQL)	

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey] 	
	    
END -- sp_SelectFrom_Coaching_Log_Historical_Export
GO