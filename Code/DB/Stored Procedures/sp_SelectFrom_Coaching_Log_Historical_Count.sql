SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/24/2018
--	Description: *	This procedure returns the count of e-Coaching  records that will be 
--  displayed for the selected criteria on the  historical dashboard page.
--  Created during Hist dashboard move to new architecture - TFS 7138 - 04/24/2018
-- Modified to add Coaching and Sub Coaching Reason filters. TFS 25387 - 09/26/2022
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Historical_Count] 

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
@intEmpActive int


AS

BEGIN

SET NOCOUNT ON;

DECLARE	
@nvcSQL nvarchar(max),
@nvcSQL1 nvarchar(max),
@nvcSQL2 nvarchar(max),
@nvcSQL3 nvarchar(max),
@NewLineChar nvarchar(2),
@nvcSubSource nvarchar(100),
@strSDate nvarchar(8),
@strEDate nvarchar(8),
@nvcDisplayWarnings nvarchar(5),
@where nvarchar(max); 

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @NewLineChar = CHAR(13) + CHAR(10)
SET @strSDate = convert(varchar(8), @strSDatein,112)
Set @strEDate = convert(varchar(8), @strEDatein,112)   

SET @nvcDisplayWarnings = (SELECT ISNULL (EC.fn_strCheckIf_HRUser(@nvcUserIdin),'NO')); 
   
SET @where = ' WHERE convert(varchar(8), [cl].[SubmittedDate], 112) >= ''' + @strSDate + '''' +  @NewLineChar +
			 ' AND convert(varchar(8), [cl].[SubmittedDate], 112) <= ''' + @strEDate + '''' + @NewLineChar +
			 ' AND [cl].[StatusID] <> 2'


-- 1 for Active 2 for Inactive 3 for All

IF @intEmpActive  <> 3
BEGIN
    IF @intEmpActive = 1
	SET @where = @where + @NewLineChar + ' AND [eh].[Active] NOT IN (''T'',''D'')'
	ELSE
	SET @where = @where + @NewLineChar + ' AND [eh].[Active] IN (''T'',''D'')'
END


			 
IF @intSourceIdin  <> -1
BEGIN
    SET @nvcSubSource = (SELECT SubCoachingSource FROM DIM_Source WHERE SourceID = @intSourceIdin)
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

IF @intSiteIdin  <> -1
BEGIN
	SET @where = @where + @NewLineChar + ' AND [cl].[SiteID] = ''' + CONVERT(nvarchar, @intSiteIdin) + ''''
END			 

IF @nvcSearch   <> ' '
BEGIN
	SET @where = @where + @NewLineChar +  ' AND ([veh].[Emp_Name] LIKE ''' +  @nvcSearch + 
	                      '%'' OR [veh].[Sup_Name] LIKE ''' +  @nvcSearch +
						   '%'' OR [veh].[Mgr_Name] LIKE ''' +  @nvcSearch +
						  '%'' OR [vehs].[Emp_Name] LIKE '''  +  @nvcSearch + '%'' )'
END			 

SET @nvcSQL1 = 'WITH TempCoaching
AS 
(
  SELECT DISTINCT x.strFormID
  FROM 
  (
    SELECT DISTINCT [cl].[FormName]	strFormID
	     FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
	JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
	JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON cl.SubmitterID = vehs.EMP_ID 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID 
	JOIN [EC].[Coaching_Log_Reason] clr WITH (NOLOCK) ON cl.CoachingID = clr.CoachingID' + @NewLineChar +
    @where

-- Warning Logs

SET @where = ' WHERE convert(varchar(8), [wl].[SubmittedDate],112) >= ''' + @strSDate + '''' +  
			 ' AND convert(varchar(8), [wl].[SubmittedDate],112) <= ''' + @strEDate + '''' +
			 ' AND [wl].[StatusID] <> 2';
			 
-- 1 for Active 2 for Inactive 3 for All

IF @intEmpActive  <> 3
BEGIN
    IF @intEmpActive = 1
	SET @where = @where + @NewLineChar + ' AND [eh].[Active] NOT IN (''T'',''D'')'
	ELSE
	SET @where = @where + @NewLineChar + ' AND [eh].[Active] IN (''T'',''D'')'
END

			 
IF @intSourceIdin  <> -1
BEGIN
	SET @nvcSubSource = (SELECT SubCoachingSource FROM DIM_Source WHERE SourceID = @intSourceIdin)
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

IF @intSiteIdin  <> -1
BEGIN
	SET @where = @where + @NewLineChar + 'AND [wl].[SiteID] = ''' + CONVERT(nvarchar,@intSiteIdin) + ''''
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
  FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
  JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
  JOIN [EC].[Warning_Log] wl WITH(NOLOCK) ON wl.EmpID = eh.Emp_ID 
  JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON wl.SubmitterID = vehs.EMP_ID 
  JOIN [EC].[DIM_Status] s ON wl.StatusID = s.StatusID 
  JOIN [EC].[DIM_Source] so ON wl.SourceID = so.SourceID
  JOIN [EC].[Warning_Log_Reason] wlr WITH (NOLOCK) ON wl.WarningID = wlr.WarningID' + @NewLineChar +
  @where 

SET @nvcSQL3 = '
  ) x
) SELECT count(strFormID) FROM TempCoaching';
	   
IF @nvcDisplayWarnings = 'YES'
  SET @nvcSQL = @nvcSQL1 + @nvcSQL2 +  @nvcSQL3; 
ELSE
  SET @nvcSQL = @nvcSQL1 + @nvcSQL3;

--print @nvcSQL;
EXEC (@nvcSQL);	

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey] 	 
    
END; -- sp_SelectFrom_Coaching_Log_Historical_Count
GO


