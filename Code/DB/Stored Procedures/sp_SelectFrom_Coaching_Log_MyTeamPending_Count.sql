IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MyTeamPending_Count' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyTeamPending_Count]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	05/22/2018
--	Description: *	This procedure returns the Count of Completed logs for logged in user.
--  Initial Revision created during MyDashboard redesign.  TFS 7137 - 05/22/2018
--  Modified to exclude QN Logs. TFS 22187 - 08/03/2021
--  Modified logic for My Teams Pending dashboard counts. TFS 23868 - 01/05/2022
--	=====================================================================

CREATE OR ALTER PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyTeamPending_Count] 
@nvcUserIdin nvarchar(10),
@intSourceIdin int,
@nvcEmpIdin nvarchar(10),
@nvcSupIdin nvarchar(10)

AS


BEGIN

SET NOCOUNT ON

DECLARE	
@nvcSubSource nvarchar(100),
@NewLineChar nvarchar(2),
@where nvarchar(max),
@nvcSQL nvarchar(max);


SET @NewLineChar = CHAR(13) + CHAR(10)
SET @where = 'WHERE [cl].[StatusID] NOT IN (1,2) AND [cl].[SourceID] NOT IN (235,236) '

IF @intSourceIdin  <> -1
BEGIN
    SET @nvcSubSource = (SELECT SubCoachingSource FROM DIM_Source WHERE SourceID = @intSourceIdin)
	SET @where = @where + @NewLineChar + 'AND [so].[SubCoachingSource] =  ''' + @nvcSubSource + ''''
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
	AND (eh.Sup_ID = ''' + @nvcUserIdin + ''' OR eh.Mgr_ID = '''+ @nvcUserIdin +''' OR eh.SrMgrLvl1_ID = '''+ @nvcUserIdin +''' OR eh.SrMgrLvl2_ID = '''+ @nvcUserIdin +''')
    ) x 
) SELECT count(strFormID) FROM TempMain';

		
EXEC (@nvcSQL)	
--PRINT @nvcSQL	    

If @@ERROR <> 0 GoTo ErrorHandler;

SET NOCOUNT OFF;

Return(0);
  
ErrorHandler:
Return(@@ERROR);
	    
END --sp_SelectFrom_Coaching_Log_MyTeamPending_Count
GO



