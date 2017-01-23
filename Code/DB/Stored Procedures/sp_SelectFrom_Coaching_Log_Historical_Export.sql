/*
sp_SelectFrom_Coaching_Log_Historical_Export(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_Historical_Export' 
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
@where nvarchar(max)  


Set @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)

SET @where = ' '
			 
IF @strSourcein <> '%'
BEGIN
	SET @where = @where + ' AND [so].[SubCoachingSource] = '''+@strSourcein+''''
END
IF @strStatusin <> '%'
BEGIN
	SET @where = @where + ' AND [s].[Status] = '''+@strStatusin+''''
END
IF @strvalue <> '%'
BEGIN
	SET @where = @where + ' AND [clr].[value] = '''+@strvalue+''''
END
IF @strCSRin <> '%' 
BEGIN
	SET @where = @where + ' AND [cl].[EmpID] =   '''+@strCSRin+'''' 
END
IF @strSUPin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Sup_ID] = '''+@strSUPin+'''' 
END
IF @strMGRin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Mgr_ID] = '''+@strMGRin+'''' 
END	
IF @strSubmitterin <> '%'
BEGIN
	SET @where = @where + ' AND [cl].[SubmitterID] = '''+@strSubmitterin+'''' 
END
IF @strCSRSitein <> '%'
BEGIN
	SET @where = @where + ' AND CONVERT(varchar,[cl].[SiteID]) = '''+@strCSRSitein+''''
END			 


SET @nvcSQL = ';WITH CL AS
(SELECT * From [EC].[Coaching_Log]WITH (NOLOCK)
WHERE convert(varchar(8),[SubmittedDate],112) >= '''+@strSDate+'''
and convert(varchar(8),[SubmittedDate],112) <= '''+@strEDate+'''
AND [StatusID] <> 2
)
SELECT [cl].[CoachingID]	CoachingID
        ,[cl].[FormName]	FormName
        ,[cl].[ProgramName]	ProgramName
        ,[cl].[EmpID]	EmpID
		,[eh].[Emp_Name]	CSRName
		,[eh].[Sup_Name]	CSRSupName
		,[eh].[Mgr_Name]	CSRMgrName
		,[si].[City]		FormSite
		,[so].[CoachingSource]		FormSource
		,[so].[SubCoachingSource]	FormSubSource
		,[dcr].[CoachingReason]	CoachingReason
		,[dscr].[SubCoachingReason]	SubCoachingReason
		,[clr].[Value]	Value
		,[s].[Status]		FormStatus
		,[sh].[Emp_Name]	SubmitterName
		,[cl].[EventDate]	EventDate
		,[cl].[CoachingDate]	CoachingDate
		,[cl].[VerintID]	VerintID
		,[cl].[Description]	Description
		,[cl].[CoachingNotes]	CoachingNotes
		,[cl].[SubmittedDate]	SubmittedDate
		,[cl].[SupReviewedAutoDate]	SupReviewedAutoDate
		,[cl].[MgrReviewManualDate]	MgrReviewManualDate
		,[cl].[MgrReviewAutoDate]	MgrReviewAutoDate
		,[cl].[MgrNotes]	MgrNotes
		,[cl].[CSRReviewAutoDate]	CSRReviewAutoDate
		,[cl].[CSRComments]	CSRComments
		FROM [EC].[Employee_Hierarchy] eh WITH (NOLOCK) JOIN cl
ON cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh
ON cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s
ON cl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so
ON cl.SourceID = so.SourceID JOIN [EC].[DIM_Site] si
ON cl.SiteID = si.SiteID JOIN [EC].[Coaching_Log_Reason]clr WITH (NOLOCK) 
ON cl.CoachingID = clr.CoachingID JOIN [EC].[DIM_Coaching_Reason]dcr
ON clr.CoachingReasonID = dcr.CoachingReasonID JOIN [EC].[DIM_Sub_Coaching_Reason]dscr
ON clr.SubCoachingReasonID = dscr.SubCoachingReasonID '
+ @where + 
' ORDER BY [cl].[CoachingID]'

EXEC (@nvcSQL)	

--PRINT @nvcSQL
	    
END -- sp_SelectFrom_Coaching_Log_Historical_Export





GO

