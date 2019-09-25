/*
sp_SelectFrom_Coaching_Log_MyPending(06).sql
Last Modified Date: 09/23/2019
Last Modified By: Susmitha Palacherla

Version 06: Updated to support QM Bingo eCoaching logs. TFS 15465 - 09/23/2019
Version 05: Updated to display MyFollowup for CSRs. TFS 15621 - 09/17/2019
Version 04: Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  09/03/2019
Version 03: Modified to support QN Bingo eCoaching logs. TFS 15063 - 08/15/2019
Version 02: Modified to incorporate Quality Now. TFS 13332 - 03/19/2019
Version 01: Document Initial Revision created during My dashboard redesign.  TFS 7137 - 05/20/2018

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MyPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyPending]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	05/22/2018
--	Description: *	This procedure returns the Pending logs for logged in user.
--  Initial Revision created during MyDashboard redesign.  TFS 7137 - 05/22/2018
--  Modified to support Quality Now TFS 13332 -  03/01/2019
--  Modified to support QN Bingo eCoaching logs. TFS 15063 - 08/12/2019
--  Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
--  Updated to display MyFollowup for CSRs. TFS 15621 - 09/17/2019
--   Updated to support QM Bingo eCoaching logs. TFS 15465 - 09/23/2019
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyPending] 
@nvcUserIdin nvarchar(10),
@nvcEmpIdin nvarchar(10),
@nvcSupIdin nvarchar(10),
@PageSize int,
@startRowIndex int, 
@sortBy nvarchar(100),
@sortASC nvarchar(1)
AS


BEGIN


SET NOCOUNT ON

DECLARE	
@nvcSQL nvarchar(max),
@nvcEmpRole nvarchar(40),
@UpperBand int,
@LowerBand int,
@SortExpression nvarchar(100),
@SortOrder nvarchar(10) ,
@OrderKey nvarchar(10),
@NewLineChar nvarchar(2),
@where nvarchar(max);        

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];


SET @LowerBand  = @startRowIndex 
SET @UpperBand  = @startRowIndex + @PageSize 


--PRINT @UpperBand

IF @sortASC = 'y' 
SET @SortOrder = ' ASC' ELSE 
SET @SortOrder = ' DESC' 
SET  @SortExpression = @sortBy +  @SortOrder
--PRINT @SortExpression

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
			  ' OR (ISNULL([cl].[strReportCode], '' '') NOT LIKE ''LCS%'' AND ISNULL([cl].[strReportCode], '' '') NOT LIKE ''BQ%'' AND cl.ReassignCount= 0 AND eh.Sup_ID = ''' + @nvcUserIdin + ''' AND  cl.[StatusID] in (3,5,6,8) ' +  @NewLineChar +
			  ' OR (ISNULL([cl].[strReportCode], '' '') NOT LIKE ''LCS%'' AND cl.ReassignCount= 0 AND  eh.Mgr_ID = '''+ @nvcUserIdin + ''' AND cl.[StatusID] in (5,7,9)) ' +  @NewLineChar +
			  ' OR ([cl].[strReportCode] LIKE ''LCS%'' AND [ReassignCount] = 0 AND cl.[MgrID] = ''' + @nvcUserIdin + ''' AND [cl].[StatusID]= 5)) ' +  @NewLineChar +
			  ' OR (cl.ReassignCount <> 0 AND cl.ReassignedToID = ''' + @nvcUserIdin + ''' AND  cl.[StatusID] in (5,7,9)) ) '
		     

             
END

SET @nvcSQL = 'WITH TempMain 
AS 
(
  SELECT DISTINCT x.strFormID
				,x.strLogID
				,x.strEmpName
				,x.strEmpSupName
				,x.strEmpMgrName
				,x.strFormStatus
				,x.strSource
				,x.SubmittedDate
				,x.strSubmitterName
				,x.IsFollowupRequired
				,x.FollowupDueDate
				,x.IsFollowupCompleted
			    ,ROW_NUMBER() OVER (ORDER BY '+ @SortExpression +' ) AS RowNumber    
  FROM 
  (
    SELECT DISTINCT [cl].[FormName] strFormID
      ,[cl].[CoachingID] strLogID
      ,[veh].[Emp_Name]	strEmpName
	  ,[veh].[Sup_Name]	strEmpSupName
	  ,[veh].[Mgr_Name] strEmpMgrName
	  ,[s].[Status] strFormStatus
	  ,[so].[SubCoachingSource]	strSource
	  ,[cl].[SubmittedDate]	SubmittedDate
	  ,[vehs].[Emp_Name] strSubmitterName
	  ,CASE WHEN [cl].[IsFollowupRequired] = 1 THEN ''Yes'' ELSE ''No'' END IsFollowupRequired
     ,[cl].[FollowupDueDate] FollowupDueDate
	 ,CASE WHEN [cl].[IsFollowupRequired] = 1 AND [cl].[FollowupActualDate] IS NOT NULL THEN ''Yes'' ELSE ''No'' END IsFollowupCompleted
    FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
	JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
	LEFT JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON cl.SubmitterID = vehs.EMP_ID 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID '+ @NewLineChar +
	@where + ' ' + '
	GROUP BY [cl].[FormName], [cl].[CoachingID], [veh].[Emp_Name], [veh].[Sup_Name], [veh].[Mgr_Name], [s].[Status],
	 [so].[SubCoachingSource], [cl].[SubmittedDate], [vehs].[Emp_Name], [cl].[IsFollowupRequired], [cl].[FollowupDueDate],[cl].[FollowupActualDate]
  ) x 
)

SELECT strLogID,
   strFormID
  ,strEmpName
  ,strEmpSupName
  ,strEmpMgrName
  ,strFormStatus
  ,strSource
  ,SubmittedDate
  ,strSubmitterName
  ,IsFollowupRequired
  ,FollowupDueDate
  ,IsFollowupCompleted
  ,[EC].[fn_strCoachingReasonFromCoachingID](T.strLogID) strCoachingReason
  ,[EC].[fn_strSubCoachingReasonFromCoachingID](T.strLogID) strSubCoachingReason
  ,CASE WHEN strSource in (''Verint-CCO'', ''Verint-CCO Supervisor'') THEN ''''
 ELSE [EC].[fn_strValueFromCoachingID](T.strLogID) END strValue
  ,RowNumber                 
FROM TempMain T
WHERE RowNumber >= ''' + CONVERT(VARCHAR, @LowerBand) + '''  AND RowNumber < ''' + CONVERT(VARCHAR, @UpperBand) + '''
ORDER BY ' + @SortExpression  



EXEC (@nvcSQL)	
--PRINT @nvcSQL

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
END -- sp_SelectFrom_Coaching_Log_MyPending
GO



