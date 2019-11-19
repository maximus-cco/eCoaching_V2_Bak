/*
sp_SelectFrom_Coaching_Log_MyPending_Count(05).sql
Last Modified Date: 11/18/2019
Last Modified By: Susmitha Palacherla

Version 05: Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019
Version 04: Updated to support QM Bingo eCoaching logs. TFS 15465 - 09/23/2019
Version 03: Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  09/03/2019
Version 02: Modified to support QN Bingo eCoaching logs. TFS 15063 - 08/15/2019
Version 01: Document Initial Revision created during My dashboard redesign.  TFS 7137 - 05/20/2018

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MyPending_Count' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyPending_Count]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	05/22/2018
--	Description: *	This procedure returns the count of Pending logs for logged in user.
--  Initial Revision created during MyDashboard redesign.  TFS 7137 - 05/22/2018
--  Modified to support QN Bingo eCoaching logs. TFS 15063 - 08/12/2019
--  Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
--  Updated to support QM Bingo eCoaching logs. TFS 15465 - 09/23/2019
--  Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyPending_Count] 
@nvcUserIdin nvarchar(10),
@nvcEmpIdin nvarchar(10),
@nvcSupIdin nvarchar(10)

AS
BEGIN

SET NOCOUNT ON

DECLARE	
@nvcSQL nvarchar(max),
@nvcSQL1 nvarchar(max),
@nvcSQL2 nvarchar(max),
@nvcSQL3 nvarchar(max),
@nvcEmpRole nvarchar(40),
@NewLineChar nvarchar(2),
@where nvarchar(max)        

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];
SET @nvcEmpRole = [EC].[fn_strGetUserRole](@nvcUserIdin)

SET @NewLineChar = CHAR(13) + CHAR(10)
SET @where = 'WHERE [cl].[StatusID] <> 2'

IF @nvcSupIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[Sup_ID] = ''' + @nvcSupIdin  + '''' 
END

IF @nvcEmpIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [cl].[EmpID] = ''' + @nvcEmpIdin  + '''' 
END	


IF @nvcEmpRole NOT IN ('CSR', 'ARC', 'Employee','Supervisor', 'Manager', 'SrManager' )
RETURN 1

IF @nvcEmpRole in ('CSR', 'ARC', 'Employee')
BEGIN
SET @where = @where + ' AND (cl.[EmpID] = ''' + @nvcUserIdin + '''  AND cl.[StatusID] in (3,4))'
END



IF @nvcEmpRole = 'Supervisor'
BEGIN
SET @where = @where + ' AND ((cl.[EmpID] = ''' + @nvcUserIdin + '''  AND cl.[StatusID] in (3,4))' +  @NewLineChar +
		       ' OR ((cl.[ReassignCount]= 0 AND eh.[Sup_ID] = ''' + @nvcUserIdin + ''' AND cl.[StatusID] in (3,6,8,10)))' +  @NewLineChar +
		       ' OR (cl.[ReassignedToId] = ''' + @nvcUserIdin + '''  AND [ReassignCount] <> 0 AND cl.[StatusID] in (3,6,8,10)))'
END

IF @nvcEmpRole in ( 'Manager', 'SrManager')
BEGIN
SET @where = @where + ' AND ((cl.[EmpID] = ''' + @nvcUserIdin + '''  AND cl.[StatusID] in (3,4)) ' +  @NewLineChar +
			  ' OR (ISNULL([cl].[strReportCode], '' '') NOT LIKE ''LCS%'' AND ISNULL([cl].[strReportCode], '' '') NOT LIKE ''BQ%''  AND cl.ReassignCount= 0 AND eh.Sup_ID = ''' + @nvcUserIdin + ''' AND  cl.[StatusID] in (3,5,6,8)  ' +  @NewLineChar +
			  ' OR (ISNULL([cl].[strReportCode], '' '') NOT LIKE ''LCS%'' AND cl.ReassignCount= 0 AND  eh.Mgr_ID = '''+ @nvcUserIdin + ''' AND cl.[StatusID] in (5,7,9)) ' +  @NewLineChar +
			  ' OR ([cl].[strReportCode] LIKE ''LCS%'' AND [ReassignCount] = 0 AND cl.[MgrID] = ''' + @nvcUserIdin + ''' AND [cl].[StatusID]= 5) )' +  @NewLineChar +
			  ' OR (cl.ReassignCount <> 0 AND cl.ReassignedToID = ''' + @nvcUserIdin + ''' AND  cl.[StatusID] in (5,7,9)) ) '
		     

             
END

SET @nvcSQL = 'WITH TempMain 
AS 
(
  SELECT DISTINCT x.strFormID
  FROM 
  (
    SELECT DISTINCT [cl].[FormName]	strFormID
    FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
	JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
	LEFT JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON cl.SubmitterID = vehs.EMP_ID 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID '+ @NewLineChar +
	@where + ' ' + @NewLineChar +
	'UNION
     SELECT DISTINCT [wl].[FormName]	strFormID
   FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
   JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
   JOIN [EC].[Warning_Log] wl WITH(NOLOCK) ON wl.EmpID = eh.Emp_ID 
   LEFT JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON wl.SubmitterID = vehs.EMP_ID 
   JOIN [EC].[DIM_Status] s ON wl.StatusID = s.StatusID 
   JOIN [EC].[DIM_Source] so ON wl.SourceID = so.SourceID
   WHERE [wl].[StatusID]	= 4
   AND [wl].[EmpID] = ''' + @nvcUserIdin + '''
   GROUP BY [wl].[FormName], [wl].[WarningID], [veh].[Emp_Name], [veh].[Sup_Name], [veh].[Mgr_Name], [s].[Status], [so].[SubCoachingSource], [wl].[SubmittedDate], [vehs].[Emp_Name]
   ) x 
)

SELECT count(strFormID) FROM TempMain'



EXEC (@nvcSQL)	
--PRINT @nvcSQL

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
END -- sp_SelectFrom_Coaching_Log_MyPending_Count
GO




