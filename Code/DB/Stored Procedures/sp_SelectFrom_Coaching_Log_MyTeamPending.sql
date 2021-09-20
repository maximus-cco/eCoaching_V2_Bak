IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MyTeamPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyTeamPending]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	05/22/2018
--	Description: *	This procedure returns the Completed logs for logged in user.
--  Initial Revision created during MyDashboard redesign.  TFS 7137 - 05/22/2018
--  Modified to support Quality Now  TFS 13332 -  03/01/2019
--  Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
--  Updated to display MyFollowup for CSRs. TFS 15621 - 09/17/2019
--  Modified to exclude QN Logs. TFS 22187 - 08/03/2021
--	=====================================================================

CREATE OR ALTER PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyTeamPending] 
@nvcUserIdin nvarchar(10),
@intSourceIdin int,
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
@nvcSubSource nvarchar(100),
@nvcEmpRole nvarchar(40),
@nvcSQL nvarchar(max),
@UpperBand int,
@LowerBand int,
@SortExpression nvarchar(100),
@SortOrder nvarchar(10) ,
@OrderKey nvarchar(10),
@NewLineChar nvarchar(2),
@where nvarchar(max);
  

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

IF @nvcEmpRole NOT IN ('Manager','Supervisor' )
RETURN 1

SET @NewLineChar = CHAR(13) + CHAR(10)
SET @where = 'WHERE cl.[SourceID] not in (235, 236) '

IF @nvcEmpRole = 'Supervisor'
BEGIN
SET @where = @where + ' AND eh.[Sup_ID] = ''' + @nvcUserIdin + ''' AND cl.[StatusID] IN (4,5,10) ' 
END


IF @nvcEmpRole = 'Manager'
BEGIN
SET @where = @where + ' AND (eh.[Mgr_ID] = ''' + @nvcUserIdin + '''  OR eh.[SrMgrLvl1_ID] = ''' + @nvcUserIdin + '''  OR eh.[SrMgrLvl1_ID] = ''' + @nvcUserIdin + ''' )' +  @NewLineChar +
                      ' AND cl.[StatusID] IN (3,4,6,8,10) ' 
END



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
	AND (eh.Sup_ID = ''' + @nvcUserIdin + ''' OR eh.Mgr_ID = '''+ @nvcUserIdin +''' OR eh.SrMgrLvl1_ID = '''+ @nvcUserIdin +''' OR eh.SrMgrLvl2_ID = '''+ @nvcUserIdin +''')
    GROUP BY [cl].[FormName], [cl].[CoachingID], [veh].[Emp_Name], [veh].[Sup_Name], [veh].[Mgr_Name], [s].[Status]
	, [so].[SubCoachingSource], [cl].[SubmittedDate], [vehs].[Emp_Name], [cl].[IsFollowupRequired], [cl].[FollowupDueDate],[cl].[FollowupActualDate]

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
	    
END -- sp_SelectFrom_Coaching_Log_MyTeamPending

GO




