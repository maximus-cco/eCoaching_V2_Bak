SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/03/2021
--	Description: *	This procedure returns the Submitted QN logs for logged in user.
--  Initial Revision. Quality Now workflow enhancement. TFS 22187 - 08/03/2021
--	=====================================================================

CREATE OR ALTER PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_Count_QN] 
@nvcUserIdin nvarchar(10),
@intStatusIdin int,
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

SET @where = ' AND convert(varchar(8), [cl].[SubmittedDate], 112) >= ''' + @strSDate + '''' +  @NewLineChar +
			 ' AND convert(varchar(8), [cl].[SubmittedDate], 112) <= ''' + @strEDate + ''''
			

IF @intStatusIdin  <> -1
BEGIN
	SET @where = @where + @NewLineChar + 'AND  [cl].[StatusID] = ''' + CONVERT(nvarchar,@intStatusIdin) + ''''
END


IF @nvcSupIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[Sup_ID] = ''' + @nvcSupIdin  + '''' 
END

IF @nvcMgrIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[Mgr_ID] = ''' + @nvcMgrIdin  + '''' 
END

IF @nvcEmpIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [cl].[EmpID] = ''' + @nvcEmpIdin  + '''' 
END


 SET @nvcSQL = 'WITH TempMain 
AS 
(
  SELECT  x.strFormID
  FROM 
  (
    SELECT DISTINCT [cl].[FormName] strFormID
    FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
	JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
	JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON cl.SubmitterID = vehs.EMP_ID 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID 
	WHERE  [cl].[SubmitterID] = '''+@nvcUserIdin+''' '+ @NewLineChar +
	' AND [cl].[StatusID] <> 2' + @NewLineChar +
	' AND [cl].[SourceID] IN (235, 236) ' + @NewLineChar +
	@where + ' ' + '
    ) x 
) SELECT count(strFormID) FROM TempMain';

		
EXEC (@nvcSQL)	
--PRINT @nvcSQL	    

If @@ERROR <> 0 GoTo ErrorHandler;

SET NOCOUNT OFF;

Return(0);
  
ErrorHandler:
Return(@@ERROR);
	    
END --sp_SelectFrom_Coaching_Log_MySubmitted_Count_QN
GO


