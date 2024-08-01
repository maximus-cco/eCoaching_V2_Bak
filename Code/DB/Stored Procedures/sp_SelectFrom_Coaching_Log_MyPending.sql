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
--  Updated to support QM Bingo eCoaching logs. TFS 15465 - 09/23/2019
--  Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019
--  Removed references to SrMgr Role. TFS 18062 - 08/18/2020
--  Modified to exclude QN Logs. TFS 22187 - 08/03/2021
--  Modified to Support ISG Alignment Project. TFS 28026 - 05/06/2024
--  Modified to add the Production Planning Module to eCoaching. TFS 28361 - 07/24/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyPending] 
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
@nvcSQL1 nvarchar(max),
@nvcSQL2 nvarchar(max),
@nvcSQL3 nvarchar(max),
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
SET @OrderKey = 'orderkey, '
SET @SortExpression = @OrderKey + @sortBy +  @SortOrder
--PRINT @SortExpression

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];
SET @nvcEmpRole = [EC].[fn_strGetUserRole](@nvcUserIdin)

--print @nvcEmpRole

SET @NewLineChar = CHAR(13) + CHAR(10)
SET @where = 'WHERE [cl].[StatusID] <> 2 AND [cl].[SourceID] NOT IN (235, 236) '


IF @nvcSupIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[Sup_ID] = ''' + @nvcSupIdin  + '''' 
END

IF @nvcEmpIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [cl].[EmpID] = ''' + @nvcEmpIdin  + '''' 
END	


IF @nvcEmpRole NOT IN ('CSR', 'ARC', 'ISG', 'Employee','Supervisor', 'Manager' )
RETURN 1

IF @nvcEmpRole in ('CSR', 'ISG', 'ARC', 'Employee')
BEGIN
SET @where = @where + ' AND (cl.[EmpID] = ''' + @nvcUserIdin + '''  AND cl.[StatusID] in (3,4))'
END


IF @nvcEmpRole = 'Supervisor'
BEGIN
SET @where = @where + ' AND ((cl.[EmpID] = ''' + @nvcUserIdin + '''  AND cl.[StatusID] in (3,4))' +  @NewLineChar +
		       ' OR ((cl.[ReassignCount]= 0 AND eh.[Sup_ID] = ''' + @nvcUserIdin + ''' AND cl.[StatusID] in (3,6,8,10)))' +  @NewLineChar +
		       ' OR (cl.[ReassignedToId] = ''' + @nvcUserIdin + '''  AND [ReassignCount] <> 0 AND cl.[StatusID] in (3,6,8,10)))'
END

IF @nvcEmpRole = 'Manager'
BEGIN
SET @where = @where + ' AND ((cl.[EmpID] = ''' + @nvcUserIdin + '''  AND cl.[StatusID] in (3,4)) ' +  @NewLineChar +
			  ' OR (ISNULL([cl].[strReportCode], '' '') NOT LIKE ''LCS%'' AND ISNULL([cl].[strReportCode], '' '') NOT LIKE ''BQ%'' AND cl.ReassignCount= 0 AND eh.Sup_ID = ''' + @nvcUserIdin + ''' AND  cl.[StatusID] in (3,5,6,8,10) ' +  @NewLineChar +
			  ' OR (ISNULL([cl].[strReportCode], '' '') NOT LIKE ''LCS%'' AND cl.ReassignCount= 0 AND  eh.Mgr_ID = '''+ @nvcUserIdin + ''' AND cl.[StatusID] in (5,7,9)) ' +  @NewLineChar +
			  ' OR ([cl].[strReportCode] LIKE ''LCS%'' AND [ReassignCount] = 0 AND cl.[MgrID] = ''' + @nvcUserIdin + ''' AND [cl].[StatusID]= 5)) ' +  @NewLineChar +
			  ' OR (cl.ReassignCount <> 0 AND cl.ReassignedToID = ''' + @nvcUserIdin + ''' AND  cl.[StatusID] in (5,7,9)) ) '
		     

             
END

SET @nvcSQL1 = 'WITH TempMain 
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
				,x.orderkey
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
     ,''ok2'' orderkey
	FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
	JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
	LEFT JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON cl.SubmitterID = vehs.EMP_ID 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID '+ @NewLineChar +
	@where + ' ' + '
	GROUP BY [cl].[FormName], [cl].[CoachingID], [veh].[Emp_Name], [veh].[Sup_Name], [veh].[Mgr_Name], [s].[Status],
	 [so].[SubCoachingSource], [cl].[SubmittedDate], [vehs].[Emp_Name], [cl].[IsFollowupRequired], [cl].[FollowupDueDate],[cl].[FollowupActualDate] '

SET @nvcSQL2 = ' 
UNION
  SELECT DISTINCT [wl].[FormName]	strFormID
    ,[wl].[WarningID]	strLogID
    ,[veh].[Emp_Name]	strEmpName
	,[veh].[Sup_Name]	strEmpSupName
	,[veh].[Mgr_Name]	strEmpMgrName
	,[s].[Status]		strFormStatus
	,[so].[SubCoachingSource]	strSource
	,[wl].[SubmittedDate]	SubmittedDate
	,[vehs].[Emp_Name]	strSubmitterName
	,''NA'' IsFollowupRequired
    ,'''' FollowupDueDate
	,''NA'' IsFollowupcompleted
	,''ok1'' orderkey
  FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
  JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
  JOIN [EC].[Warning_Log] wl WITH(NOLOCK) ON wl.EmpID = eh.Emp_ID 
  JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON wl.SubmitterID = vehs.EMP_ID 
  JOIN [EC].[DIM_Status] s ON wl.StatusID = s.StatusID 
  JOIN [EC].[DIM_Source] so ON wl.SourceID = so.SourceID
  JOIN [EC].[Warning_Log_Reason] wlr WITH (NOLOCK) ON wl.WarningID = wlr.WarningID
  WHERE [wl].[StatusID]	= 4
  AND [wl].[EmpID] = ''' + @nvcUserIdin + '''
  GROUP BY [wl].[FormName], [wl].[WarningID], [veh].[Emp_Name], [veh].[Sup_Name], [veh].[Mgr_Name], [s].[Status], [so].[SubCoachingSource], [wl].[SubmittedDate], [vehs].[Emp_Name]'


SET @nvcSQL3 = ' 
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
  ,CASE WHEN T.orderkey = ''ok2'' THEN [EC].[fn_strCoachingReasonFromCoachingID](T.strLogID)
	 ELSE [EC].[fn_strCoachingReasonFromWarningID](T.strLogID) 
   END strCoachingReason
  ,CASE WHEN T.orderkey = ''ok2'' THEN [EC].[fn_strSubCoachingReasonFromCoachingID](T.strLogID)
	 ELSE [EC].[fn_strSubCoachingReasonFromWarningID](T.strLogID) 
   END strSubCoachingReason
 ,CASE WHEN T.orderkey = ''ok2'' 
 THEN CASE WHEN strSource in (''Verint-CCO'', ''Verint-CCO Supervisor'') THEN ''''
 ELSE [EC].[fn_strValueFromCoachingID](T.strLogID) END 
	 ELSE [EC].[fn_strValueFromWarningID](T.strLogID)
   END strValue
  ,RowNumber                 
FROM TempMain T
WHERE RowNumber >= ''' + CONVERT(VARCHAR, @LowerBand) + '''  AND RowNumber < ''' + CONVERT(VARCHAR, @UpperBand) + '''
ORDER BY ' + @SortExpression  


SET @nvcSQL = @nvcSQL1 + @nvcSQL2 +  @nvcSQL3; 
EXEC (@nvcSQL)	
--PRINT @nvcSQL

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
END -- sp_SelectFrom_Coaching_Log_MyPending
GO


