/*
sp_Dashboard_Director_Site_Completed_Count(01).sql
Last Modified Date: 05/28/2018
Last Modified By: Susmitha Palacherla


Version 01: Document Initial Revision created during My dashboard redesign.  TFS 7137 - 05/28/2018

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Dashboard_Director_Site_Completed_Count' 
)
   DROP PROCEDURE [EC].[sp_Dashboard_Director_Site_Completed_Count]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	05/22/2018
--	Description: *	This procedure returns the Count of Completed logs at a given site 
--  For Employees within the Director's Hierarchy.
--  Initial Revision created during MyDashboard redesign.  TFS 7137 - 05/22/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Dashboard_Director_Site_Completed_Count] 
@intSiteIdin int,
@nvcUserIdin nvarchar(10),
@intSourceIdin int,
@nvcEmpIdin nvarchar(10),
@nvcSupIdin nvarchar(10),
@nvcMgrIdin nvarchar(10),
@strSDatein datetime,
@strEDatein datetime

AS


BEGIN


SET NOCOUNT ON

DECLARE	
@nvcSubSource nvarchar(100),
@NewLineChar nvarchar(2),
@strSDate nvarchar(10),
@strEDate nvarchar(10),
@where nvarchar(max),
@nvcSQL nvarchar(max)


SET @NewLineChar = CHAR(13) + CHAR(10)
SET @strSDate = convert(varchar(8), @strSDatein,112)
Set @strEDate = convert(varchar(8), @strEDatein,112)

SET @where = ' WHERE convert(varchar(8), [cl].[SubmittedDate], 112) >= ''' + @strSDate + '''' +  @NewLineChar +
			 ' AND convert(varchar(8), [cl].[SubmittedDate], 112) <= ''' + @strEDate + '''' + @NewLineChar +
			 ' AND [cl].[StatusID] = 1 '


IF @intSourceIdin  <> -1
BEGIN
    SET @nvcSubSource = (SELECT SubCoachingSource FROM DIM_Source WHERE SourceID = @intSourceIdin)
	SET @where = @where + @NewLineChar + 'AND [so].[SubCoachingSource] =  ''' + @nvcSubSource + ''''
END

IF @nvcMgrIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[Mgr_ID] = ''' + @nvcMgrIdin  + '''' 
END


IF @nvcSupIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[Sup_ID] = ''' + @nvcSupIdin  + '''' 
END

IF @nvcEmpIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [cl].[EmpID] = ''' + @nvcEmpIdin  + '''' 
END	

SET @nvcSQL = 'WITH TempMain 
AS 
(
  SELECT DISTINCT x.strFormID
  FROM 
  (
    SELECT DISTINCT [cl].[FormName] strFormID
    FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
	JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
	LEFT JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON cl.SubmitterID = vehs.EMP_ID 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID '+ @NewLineChar +
	@where + ' ' + '
	AND cl.SiteID = '''+CONVERT(NVARCHAR,@intSiteIdin)+'''
	AND (eh.SrMgrLvl1_ID = '''+ @nvcUserIdin+ ''' OR eh.SrMgrLvl2_ID = '''+ @nvcUserIdin +''' OR eh.SrMgrLvl3_ID = '''+ @nvcUserIdin +''')
   	GROUP BY [cl].[FormName], [cl].[CoachingID], [veh].[Emp_Name], [veh].[Sup_Name], [veh].[Mgr_Name], [s].[Status], [so].[SubCoachingSource], [cl].[SubmittedDate], [vehs].[Emp_Name]
   ) x 
) SELECT count(strFormID) FROM TempMain';




EXEC (@nvcSQL)	
--PRINT @nvcSQL

    
END -- sp_Dashboard_Director_Site_Completed_Count


GO




