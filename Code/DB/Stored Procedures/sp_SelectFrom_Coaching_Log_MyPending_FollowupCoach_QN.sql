SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/03/2021
--	Description: *	This procedure returns the Pending Followup Coaching QN logs for logged in user.
--  Initial Revision. Quality Now workflow enhancement. TFS 22187 - 08/03/2021
--  Updated to support the highlighting of the Prepare or Coach links. TFS 26382 - 03/21/2023
--	=====================================================================

CREATE OR ALTER PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyPending_FollowupCoach_QN] 
@nvcUserIdin nvarchar(10),
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
@nvcEmpRole nvarchar(40),
@UpperBand int,
@LowerBand int,
@SortExpression nvarchar(100),
@SortOrder nvarchar(10) ,
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
SET @SortExpression =  @sortBy +  @SortOrder
--PRINT @SortExpression

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];
SET @nvcEmpRole = [EC].[fn_strGetUserRole](@nvcUserIdin)


SET @NewLineChar = CHAR(13) + CHAR(10)
SET @where = 'WHERE cl.[SourceID] in (235) '


IF @nvcEmpRole NOT IN ('Supervisor' )
RETURN 1


IF @nvcEmpRole = 'Supervisor'
BEGIN
SET @where = @where + ' AND ((cl.[ReassignCount]= 0 AND eh.[Sup_ID] = ''' + @nvcUserIdin + ''' AND cl.[StatusID] = 12 )' +  @NewLineChar +
		       ' OR (cl.[ReassignedToId] = ''' + @nvcUserIdin + '''  AND [ReassignCount] <> 0 AND cl.[StatusID] = 12))'
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
				,CASE WHEN x.SummaryID > 0 THEN 1 ELSE 0 END SummaryExists 
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
    ,COUNT(sid.SummaryID) SummaryID
  	FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
	JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
	LEFT JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON cl.SubmitterID = vehs.EMP_ID 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID 
	LEFT JOIN [EC].[Coaching_Log_Quality_Now_Summary] sid ON cl.CoachingID = sid.CoachingID '+ @NewLineChar +
	@where + ' ' + '
	GROUP BY [cl].[FormName], [cl].[CoachingID], [veh].[Emp_Name], [veh].[Sup_Name], [veh].[Mgr_Name], [s].[Status],
	 [so].[SubCoachingSource], [cl].[SubmittedDate], [vehs].[Emp_Name], [cl].[IsFollowupRequired], [cl].[FollowupDueDate],[cl].[FollowupActualDate], sid.SummaryID '


SET @nvcSQL2 = ' 
  ) x 
)

SELECT DISTINCT strLogID,
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
  ,SummaryExists
  ,[EC].[fn_strCoachingReasonFromCoachingID](T.strLogID) strCoachingReason
  ,[EC].[fn_strSubCoachingReasonFromCoachingID](T.strLogID) strSubCoachingReason
 , '''' strValue
  ,RowNumber                 
FROM TempMain T
WHERE RowNumber >= ''' + CONVERT(VARCHAR, @LowerBand) + '''  AND RowNumber < ''' + CONVERT(VARCHAR, @UpperBand) + '''
ORDER BY ' + @SortExpression  


SET @nvcSQL = @nvcSQL1 + @nvcSQL2; 
EXEC (@nvcSQL)	
--PRINT @nvcSQL

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
END -- sp_SelectFrom_Coaching_Log_MyPending_FollowupCoach_QN
GO


