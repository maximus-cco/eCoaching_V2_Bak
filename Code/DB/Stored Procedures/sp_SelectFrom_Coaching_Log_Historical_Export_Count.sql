/*
sp_SelectFrom_Coaching_Log_Historical_Export_Count(01).sql
Last Modified Date: 08/14/2018
Last Modified By: Susmitha Palacherla


Version 01: Initial Revision. - TFS 11743 - 08/14/2018
*/


IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_Historical_Export_Count' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Historical_Export_Count]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/14/2018
--	Description: *	This procedure selects the count of e-Coaching records for export.
-- Last Modified Date:
-- Last Updated By: 
-- Initial Revision. - TFS 11743 - 08/14/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Historical_Export_Count] 

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
@nvcValue  nvarchar(30),
@intEmpActive int


AS

BEGIN

DECLARE	
@nvcSQL nvarchar(max),
@nvcSubSource nvarchar(100),
@strSDate nvarchar(8),
@strEDate nvarchar(8),
@NewLineChar nvarchar(2),
@where nvarchar(max);  

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @NewLineChar = CHAR(13) + CHAR(10)
SET @strSDate = convert(varchar(8), @strSDatein,112)
SET @strEDate = convert(varchar(8), @strEDatein,112)
SET @where = ' '
			 

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

	 		 

SET @nvcSQL = ' SELECT count(cl.CoachingID) 
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
JOIN [EC].[Employee_Hierarchy] eh WITH (NOLOCK) ON eh.[EMP_ID] = veh.[EMP_ID]
JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON cl.SubmitterID = vehs.EMP_ID 
JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID 
JOIN [EC].[DIM_Site] si ON cl.SiteID = si.SiteID 
JOIN [EC].[Coaching_Log_Reason]clr WITH (NOLOCK) ON cl.CoachingID = clr.CoachingID 
JOIN [EC].[DIM_Coaching_Reason]dcr ON clr.CoachingReasonID = dcr.CoachingReasonID
JOIN [EC].[DIM_Sub_Coaching_Reason]dscr ON clr.SubCoachingReasonID = dscr.SubCoachingReasonID 
WHERE convert(varchar(8), cl.[SubmittedDate], 112) >= ''' + @strSDate + '''
AND convert(varchar(8), cl.[SubmittedDate], 112) <= ''' + @strEDate + '''
AND cl.[StatusID] <> 2 ' + @NewLineChar +   @where 

EXEC (@nvcSQL)	
--PRINT @nvcSQL
-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey] 	
	    
END -- sp_SelectFrom_Coaching_Log_Historical_Export_Count
GO




