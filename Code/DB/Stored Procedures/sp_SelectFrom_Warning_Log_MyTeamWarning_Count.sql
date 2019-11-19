/*
sp_SelectFrom_Warning_Log_MyTeamWarning_Count(02).sql
Last Modified Date: 11/18/2019
Last Modified By: Susmitha Palacherla

Version 02: Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019
Version 01: Document Initial Revision created during My dashboard redesign.  TFS 7137 - 05/20/2018

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Warning_Log_MyTeamWarning_Count' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Warning_Log_MyTeamWarning_Count]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	05/22/2018
--	Description: *	This procedure returns the Count of warning logs for employees reporting to logged in user.
--  Initial Revision created during MyDashboard redesign.  TFS 7137 - 05/22/2018
--  Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Warning_Log_MyTeamWarning_Count] 
@nvcUserIdin nvarchar(10),
@intStatusIdin int,
@strSDatein datetime,
@strEDatein datetime
AS


BEGIN

SET NOCOUNT ON

DECLARE	
@strSDate nvarchar(10),
@strEDate nvarchar(10),
@nvcSQL nvarchar(max)

SET @strSDate = convert(varchar(8), @strSDatein,112)
Set @strEDate = convert(varchar(8), @strEDatein,112)


SET @nvcSQL = 'WITH TempMain 
AS 
(
  SELECT DISTINCT x.strFormID
  FROM 
  (
    SELECT DISTINCT [wl].[FormName] strFormID
    FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
	JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Warning_Log] wl WITH(NOLOCK) ON wl.EmpID = eh.Emp_ID 
	LEFT JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON wl.SubmitterID = vehs.EMP_ID 
	JOIN [EC].[DIM_Status] s ON wl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON wl.SourceID = so.SourceID 
	WHERE wl.Active = 1
	AND (wl.Statusid = '''+CONVERT(VARCHAR,@intStatusIdin)+''' OR   '''+CONVERT(VARCHAR,@intStatusIdin)+''' = ''-1'')
	AND wl.siteID <> -1
	AND (eh.Sup_ID = ''' + @nvcUserIdin + ''' OR eh.Mgr_ID = '''+ @nvcUserIdin +''' OR eh.SrMgrLvl1_ID = '''+ @nvcUserIdin +''' OR eh.SrMgrLvl2_ID = '''+ @nvcUserIdin +''')
	AND convert(varchar(8), [wl].[SubmittedDate], 112) >= ''' + @strSDate + '''
    AND convert(varchar(8), [wl].[SubmittedDate], 112) <= ''' + @strEDate + '''
  ) x 
) SELECT count(strFormID) FROM TempMain';
		
EXEC (@nvcSQL)	
--PRINT @nvcSQL	    

If @@ERROR <> 0 GoTo ErrorHandler;

SET NOCOUNT OFF;

Return(0);
  
ErrorHandler:
Return(@@ERROR);
	    
END --sp_SelectFrom_Warning_Log_MyTeamWarning_Count
GO





