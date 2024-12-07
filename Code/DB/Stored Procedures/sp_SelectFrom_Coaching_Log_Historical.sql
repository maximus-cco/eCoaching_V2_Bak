SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/24/2018
--	Description: *	This procedure selects the CSR e-Coaching completed records to display on SUP historical page
--  Created during Hist dashboard move to new architecture - TFS 7138 - 04/24/2018
--  Modified to support Quality Now TFS 13332 -  03/01/2019
--  Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
--  Updated to display MyFollowup for CSRs. TFS 15621 - 09/17/2019
--  Update to fix HC users receiving error on Historical Dashboard - TFS 15974
--  Modified to support Quality Now workflow enhancement . TFS 22187 - 09/22/2021
--  Updated to support New Coaching Reason for Quality - 23051 - 09/29/2021
-- Modified to add Coaching and Sub Coaching Reason filters. TFS 25387 - 09/26/2022
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Historical] 

@nvcUserIdin nvarchar(10),
@intSourceIdin int,
@intSiteIdin int,
@nvcEmpIdin nvarchar(10),
@nvcSupIdin nvarchar(10),
@nvcMgrIdin nvarchar(10),
@nvcSubmitterIdin nvarchar(10),
@strSDatein datetime,
@strEDatein datetime,
@intStatusIdin int, 
@intCoachingReasonIdin int,
@intSubCoachingReasonIdin int,
@nvcValue  nvarchar(30),
@nvcSearch nvarchar(50),
@intEmpActive int,
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
@nvcSQL4 nvarchar(max),
@nvcSQL5 nvarchar(max),
@NewLineChar nvarchar(2),
@strSDate nvarchar(10),
@strEDate nvarchar(10),
@nvcSubSource nvarchar(100),
@nvcDisplayWarnings nvarchar(5),
@UpperBand int,
@LowerBand int,
@SortExpression nvarchar(100),
@SortOrder nvarchar(10) ,
@OrderKey nvarchar(10),
@where nvarchar(max);        

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @NewLineChar = CHAR(13) + CHAR(10)
SET @strSDate = convert(varchar(8), @strSDatein,112)
Set @strEDate = convert(varchar(8), @strEDatein,112)
SET @LowerBand  = @startRowIndex 
SET @UpperBand  = @startRowIndex + @PageSize 


SET @nvcDisplayWarnings = (SELECT ISNULL (EC.fn_strCheckIf_HRUser(@nvcUserIdin), 'NO')) 
SET @where = ' WHERE convert(varchar(8), [cl].[SubmittedDate], 112) >= ''' + @strSDate + '''' +  @NewLineChar +
			 ' AND convert(varchar(8), [cl].[SubmittedDate], 112) <= ''' + @strEDate + '''' + @NewLineChar +
			 ' AND [cl].[StatusID] <> 2 ' 

-- 1 for Active 2 for Inactive 3 for All

IF @intEmpActive  <> 3
BEGIN
    IF @intEmpActive = 1
	SET @where = @where + @NewLineChar + ' AND [eh].[Active] NOT IN (''T'',''D'')'
	ELSE
	SET @where = @where + @NewLineChar + ' AND [eh].[Active] IN (''T'',''D'')'
END


/*
-1 All Sites
-3 Sub Sites
-4 Maximus Sites
*/

IF @intSiteIdin NOT IN (-1,-3,-4)
BEGIN
	SET @where = @where +  @NewLineChar + ' AND [cl].[SiteID] =   '''+CONVERT(NVARCHAR,@intSiteIdin)+'''';
END

IF @intSiteIdin = -3
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[isSub] =   ''Y''' ;
END

IF @intSiteIdin = -4
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[isSub] =   ''N''' ;
END

			 
IF @intSourceIdin  <> -1
BEGIN
    SET @nvcSubSource = (SELECT SubCoachingSource FROM ec.DIM_Source WHERE SourceID = @intSourceIdin)
	SET @where = @where + @NewLineChar + 'AND [so].[SubCoachingSource] =  ''' + @nvcSubSource + ''''
END

IF @intStatusIdin  <> -1
BEGIN
	SET @where = @where + @NewLineChar + 'AND  [cl].[StatusID] = ''' + CONVERT(nvarchar,@intStatusIdin) + ''''
END

IF @intCoachingReasonIdin    <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [clr].[CoachingReasonId] = ''' + CONVERT(nvarchar,@intCoachingReasonIdin) + ''''
END

IF @intSubCoachingReasonIdin    <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [clr].[SubCoachingReasonId] = ''' + CONVERT(nvarchar,@intSubCoachingReasonIdin) + ''''
END

IF @nvcValue   <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [clr].[value] = ''' + @nvcValue   + ''''
END

IF @nvcEmpIdin <> '-1' 
BEGIN
	SET @where = @where + @NewLineChar + ' AND [cl].[EmpID] =   ''' + @nvcEmpIdin  + '''' 
END

IF @nvcSupIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[Sup_ID] = ''' + @nvcSupIdin  + '''' 
END

IF @nvcMgrIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[Mgr_ID] = ''' + @nvcMgrIdin  + '''' 
END	

IF @nvcSubmitterIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar +  ' AND [cl].[SubmitterID] = ''' + @nvcSubmitterIdin  + '''' 
END

--IF @intSiteIdin  <> -1
--BEGIN
--	SET @where = @where + @NewLineChar + ' AND [cl].[SiteID] = ''' + CONVERT(nvarchar, @intSiteIdin) + ''''
--END			 

IF @nvcSearch   <> ' '
BEGIN
	SET @where = @where + @NewLineChar +  ' AND ([veh].[Emp_Name] LIKE ''' +  @nvcSearch + 
	                      '%'' OR [veh].[Sup_Name] LIKE ''' +  @nvcSearch +
						   '%'' OR [veh].[Mgr_Name] LIKE ''' +  @nvcSearch +
						  '%'' OR [vehs].[Emp_Name] LIKE '''  +  @nvcSearch + '%'' )'
END			 


--PRINT @UpperBand

IF @sortASC = 'y' 
SET @SortOrder = ' ASC' ELSE 
SET @SortOrder = ' DESC' 
SET @OrderKey = 'orderkey, '
SET  @SortExpression = @OrderKey + @sortBy +  @SortOrder

--PRINT @SortExpression

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
				,x.SupervisorFollowupAutoDate
				,x.FollowupCoachingNotes
				,x.CSRFollowupAcknowledged
				,x.CSRFollowupAutoDate
				,x.CSRFollowupComments
				,x.FollowupSupervisorID
				,x.SupervisorFollowupReviewAutoDate
				,x.SupervisorFollowupReviewCoachingNotes
				,x.FollowupReviewMonitoredLogs
				,x.FollowupReviewSupervisorID 
				,x.PFDCompletedDate
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
	  ,[cl].[SupFollowupAutoDate] SupervisorFollowupAutoDate
      ,[cl].[SupFollowupCoachingNotes] FollowupCoachingNotes
      ,CASE WHEN [cl].[IsEmpFollowupAcknowledged] = 1 THEN ''Yes'' ELSE ''No'' END CSRFollowupAcknowledged
      ,[cl].[EmpAckFollowupAutoDate] CSRFollowupAutoDate
      ,[cl].[EmpAckFollowupComments] CSRFollowupComments
      ,[cl].[FollowupSupID] FollowupSupervisorID
      ,[cl].[SupFollowupReviewAutoDate] SupervisorFollowupReviewAutoDate
      ,[cl].[SupFollowupReviewCoachingNotes] SupervisorFollowupReviewCoachingNotes
      ,[cl].[SupFollowupReviewMonitoredLogs] FollowupReviewMonitoredLogs
     ,[cl].[FollowupReviewSupID] FollowupReviewSupervisorID 
	 ,[cl].[PFDCompletedDate]
	  ,''ok1'' orderkey
    FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
	JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
	JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON cl.SubmitterID = vehs.EMP_ID 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID 
	JOIN [EC].[Coaching_Log_Reason] clr WITH (NOLOCK) ON cl.CoachingID = clr.CoachingID' +  @NewLineChar +
	@where + ' ' + '
	GROUP BY [cl].[FormName], [cl].[CoachingID], [veh].[Emp_Name], [veh].[Sup_Name], [veh].[Mgr_Name], [s].[Status], [so].[SubCoachingSource], [cl].[SubmittedDate], [vehs].[Emp_Name],
	 [cl].[IsFollowupRequired], [cl].[FollowupDueDate], [cl].[FollowupActualDate], [cl].[SupFollowupAutoDate], 
	 [cl].[SupFollowupCoachingNotes], [cl].[IsEmpFollowupAcknowledged], [cl].[EmpAckFollowupAutoDate], [cl].[EmpAckFollowupComments],
     [cl].[FollowupSupID], [cl].[SupFollowupReviewAutoDate], [cl].[SupFollowupReviewCoachingNotes], [cl].[SupFollowupReviewMonitoredLogs], [cl].[FollowupReviewSupID], [cl].[PFDCompletedDate]
'

SET @where = 
' WHERE convert(varchar(8),[wl].[SubmittedDate],112) >= ''' + @strSDate + '''' +  @NewLineChar +
' AND convert(varchar(8),[wl].[SubmittedDate],112) <= ''' + @strEDate + '''' + @NewLineChar +
' AND [wl].[StatusID] <> 2';

IF @intEmpActive  <> 3
BEGIN
    IF @intEmpActive = 1
	SET @where = @where + @NewLineChar + ' AND [eh].[Active] NOT IN (''T'',''D'')'
	ELSE
	SET @where = @where + @NewLineChar + ' AND [eh].[Active] IN (''T'',''D'')'
END

IF @intSiteIdin NOT IN (-1,-3,-4)
BEGIN
	SET @where = @where + @NewLineChar + 'AND [wl].[SiteID] = ''' + CONVERT(nvarchar,@intSiteIdin) + ''''
END	

IF @intSiteIdin = -3
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[isSub] =   ''Y''' ;
END

IF @intSiteIdin = -4
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[isSub] =   ''N''' ;
END
			 
IF @intSourceIdin  <> -1
BEGIN
    SET @nvcSubSource = (SELECT SubCoachingSource FROM ec.DIM_Source WHERE SourceID = @intSourceIdin)
	SET @where = @where + @NewLineChar + 'AND [so].[SubCoachingSource] =  ''' + @nvcSubSource + ''''
END

IF @intStatusIdin  <> -1
BEGIN
	SET @where = @where + @NewLineChar + 'AND  [wl].[StatusID] = ''' + CONVERT(nvarchar,@intStatusIdin) + ''''
END

IF @intCoachingReasonIdin    <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [wlr].[CoachingReasonId] = ''' + CONVERT(nvarchar,@intCoachingReasonIdin) + ''''
END

IF @intSubCoachingReasonIdin    <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [wlr].[SubCoachingReasonId] = ''' + CONVERT(nvarchar,@intSubCoachingReasonIdin) + ''''
END

IF @nvcValue   <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [wlr].[value] = ''' + @nvcValue   + ''''
END

IF @nvcEmpIdin <> '-1' 
BEGIN
	SET @where = @where + @NewLineChar + ' AND [wl].[EmpID] =   ''' + @nvcEmpIdin  + '''' 
END

IF @nvcSupIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[Sup_ID] = ''' + @nvcSupIdin  + '''' 
END

IF @nvcMgrIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[Mgr_ID] = ''' + @nvcMgrIdin  + '''' 
END	

IF @nvcSubmitterIdin  <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [wl].[SubmitterID] = ''' + @nvcSubmitterIdin  + '''' 
END

IF @nvcSearch   <> ' '
BEGIN
	SET @where = @where + @NewLineChar +  ' AND ([veh].[Emp_Name] LIKE ''' +  @nvcSearch + 
	                      '%'' OR [veh].[Sup_Name] LIKE ''' +  @nvcSearch +
						   '%'' OR [veh].[Mgr_Name] LIKE ''' +  @nvcSearch +
						  '%'' OR [vehs].[Emp_Name] LIKE '''  +  @nvcSearch + '%'' )'
END			 
			 
	

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
	,'''' SupervisorFollowupAutoDate
    ,''NA'' FollowupCoachingNotes
    ,''NA'' CSRFollowupAcknowledged
    ,'''' CSRFollowupAutoDate
    ,''NA'' CSRFollowupComments
    ,''NA'' FollowupSupervisorID
    ,'''' SupervisorFollowupReviewAutoDate
    ,''NA'' SupervisorFollowupReviewCoachingNotes
    ,''NA'' FollowupReviewMonitoredLogs
    ,''NA'' FollowupReviewSupervisorID 
	,'''' PFDCompletedDate
	,''ok2'' orderkey
  FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
  JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
  JOIN [EC].[Warning_Log] wl WITH(NOLOCK) ON wl.EmpID = eh.Emp_ID 
  JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON wl.SubmitterID = vehs.EMP_ID 
  JOIN [EC].[DIM_Status] s ON wl.StatusID = s.StatusID 
  JOIN [EC].[DIM_Source] so ON wl.SourceID = so.SourceID
  JOIN [EC].[Warning_Log_Reason] wlr WITH (NOLOCK) ON wl.WarningID = wlr.WarningID' + @NewLineChar +
  @where + ' ' + '
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
  ,SupervisorFollowupAutoDate
  ,FollowupCoachingNotes
  ,CSRFollowupAcknowledged
  ,CSRFollowupAutoDate
  ,CSRFollowupComments
  ,FollowupSupervisorID
  ,SupervisorFollowupReviewAutoDate
  ,SupervisorFollowupReviewCoachingNotes
  ,FollowupReviewMonitoredLogs
  ,FollowupReviewSupervisorID 
  ,PFDCompletedDate
  ,CASE WHEN T.orderkey = ''ok1'' THEN [EC].[fn_strCoachingReasonFromCoachingID](T.strLogID)
	 ELSE [EC].[fn_strCoachingReasonFromWarningID](T.strLogID) 
   END strCoachingReason
  ,CASE WHEN T.orderkey = ''ok1'' THEN [EC].[fn_strSubCoachingReasonFromCoachingID](T.strLogID)
	 ELSE [EC].[fn_strSubCoachingReasonFromWarningID](T.strLogID) 
   END strSubCoachingReason
 ,CASE WHEN T.orderkey = ''ok1'' 
 THEN CASE WHEN strSource in (''Verint-CCO'', ''Verint-CCO Supervisor'') THEN ''''
 ELSE [EC].[fn_strValueFromCoachingID](T.strLogID) END 
	 ELSE [EC].[fn_strValueFromWarningID](T.strLogID)
   END strValue
  ,RowNumber                 
FROM TempMain T
WHERE RowNumber >= ''' + CONVERT(VARCHAR, @LowerBand) + '''  AND RowNumber < ''' + CONVERT(VARCHAR, @UpperBand) + '''
ORDER BY ' + @SortExpression  

--print @nvcDisplayWarnings
IF @nvcDisplayWarnings = 'YES'
  SET @nvcSQL = @nvcSQL1 + @nvcSQL2 +  @nvcSQL3; 
ELSE
  SET @nvcSQL = @nvcSQL1 + @nvcSQL3;

EXEC (@nvcSQL)	
--PRINT @nvcSQL

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
END -- SelectFrom_Coaching_Log_Historical
GO


