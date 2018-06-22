/*
sp_SelectFrom_Coaching_Log_MyCompleted_Count(01).sql
Last Modified Date: 05/20/2018
Last Modified By: Susmitha Palacherla


Version 01: Document Initial Revision created during My dashboard redesign.  TFS 7137 - 05/20/2018

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MyCompleted_Count' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyCompleted_Count]
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
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyCompleted_Count] 
@nvcUserIdin nvarchar(10),
@strSDatein datetime,
@strEDatein datetime
AS


BEGIN

SET NOCOUNT ON

DECLARE	
@nvcSQL nvarchar(max),
@strSDate nvarchar(10),
@strEDate nvarchar(10)

SET @strSDate = convert(varchar(8), @strSDatein,112)
Set @strEDate = convert(varchar(8), @strEDatein,112)

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
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID 
	WHERE  cl.EmpID = '''+@nvcUserIdin+''' 
    AND [cl].[StatusID] = 1
	AND convert(varchar(8), [cl].[SubmittedDate], 112) >= ''' + @strSDate + '''
	AND convert(varchar(8), [cl].[SubmittedDate], 112) <= ''' + @strEDate + '''
	AND [cl].[EmpID] <> ''999999''
    ) x 
)

SELECT count(strFormID) FROM TempMain'


		
EXEC (@nvcSQL)	
--PRINT @nvcSQL	    

If @@ERROR <> 0 GoTo ErrorHandler;

SET NOCOUNT OFF;

Return(0);
  
ErrorHandler:
Return(@@ERROR);
	    
END --sp_SelectFrom_Coaching_Log_MyCompleted_Count
GO