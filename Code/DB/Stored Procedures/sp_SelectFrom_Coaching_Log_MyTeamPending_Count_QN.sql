
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/03/2021
--	Description: *	This procedure returns the count of pending QN logs for employees reporting to the logged in user.
--  Initial Revision. Quality Now workflow enhancement. TFS 22187 - 08/03/2021
--  Modified logic for My Teams Pending dashboard counts. TFS 23868 - 01/05/2022
--  Updated to support QN Supervisor evaluation changes. TFS 26002 - 02/02/2023
--	=====================================================================

CREATE OR ALTER PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyTeamPending_Count_QN] 
@nvcUserIdin nvarchar(10),
@intStatusIdin int,
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
SET @where = 'WHERE [cl].[StatusID] NOT IN (1,2) AND [cl].[SourceID] IN (235,236) '

IF @intStatusIdin  <> -1
BEGIN
	SET @where = @where + @NewLineChar + 'AND  [cl].[StatusID] = ''' + CONVERT(nvarchar,@intStatusIdin) + ''''
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
	    
END --sp_SelectFrom_Coaching_Log_MyTeamPending_Count_QN
GO


