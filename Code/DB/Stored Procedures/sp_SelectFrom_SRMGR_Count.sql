/*
sp_SelectFrom_SRMGR_Count(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_Count' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_Count]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure returns the Count of  Coaching or Warning logs that will be returned for 
--  the selected parameters in the Senior leadeship dashboard. 
--  Last Updated By: 
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_Count] 
@strEMPSRMGRin nvarchar(30),
@bitisCoaching bit,
@strStatus nvarchar(30) = NULL,
@strSDatein datetime,
@strEDatein datetime,
@Count INT OUTPUT



AS

BEGIN
	DECLARE	
	@nvcSQL nvarchar(max),
	@strSrMgrEmpID nvarchar(10),
	@strFormStatus nvarchar(30),
	@strSDate nvarchar(8),
	@strEDate nvarchar(8),
	@intStatusID INT,
	@whereStatus nvarchar(200)
	
	DECLARE @CountResults TABLE (CountReturned INT) 


--PRINT @strSDatein
--PRINT @strEDatein

SET @strSDate = convert(varchar(8),@strSDatein,112)
SET @strEDate = convert(varchar(8),@strEDatein,112)

PRINT @strSDate
PRINT @strEDate

SET @strSrMgrEmpID = (SELECT [EC].[fn_nvcGetEmpIdFromLanId] (@strEMPSRMGRin, GETDATE()))

IF @strStatus = 'Pending'
BEGIN
	SET @whereStatus = ' AND convert(varchar(8),[cl].[SubmittedDate],112) >= '''+@strSDate+'''  
	AND convert(varchar(8),[cl].[SubmittedDate],112) <= '''+@strEDate+'''
	AND [cl].[StatusId] NOT IN (1,2) '
END


IF @strStatus = 'Completed'
BEGIN
	SET @whereStatus = ' AND convert(varchar(8),[cl].[CSRReviewAutoDate],112) >= '''+@strSDate+'''  
	AND convert(varchar(8),[cl].[CSRReviewAutoDate],112) <= '''+@strEDate+'''
	AND [cl].[StatusId] = 1 '
END

IF @bitisCoaching = 1

SET @nvcSQL = 'WITH TempMain AS 
	(SELECT DISTINCT x.strFormID 
	FROM 
	(SELECT DISTINCT [cl].[FormName]	strFormID
	FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON
	[cl].[EmpID] = [eh].[Emp_ID] 
	WHERE (eh.SrMgrLvl1_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl2_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl3_ID = '''+@strSrMgrEmpID+''')'
+   @whereStatus 
+ ' AND [cl].[ModuleID] in (1,2)
    AND '''+@strSrMgrEmpID+''' <> ''999999''
	 GROUP BY [cl].[FormName]) x)
	SELECT count(strFormID) FROM TempMain'
	
ELSE

SET @nvcSQL = 'WITH TempMain AS 
	(SELECT DISTINCT x.strFormID 
	FROM 
	(SELECT DISTINCT [wl].[FormName]	strFormID
	FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Warning_Log] wl WITH (NOLOCK) ON
	[wl].[EmpID] = [eh].[Emp_ID] 
	WHERE (eh.SrMgrLvl1_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl2_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl3_ID = '''+@strSrMgrEmpID+''')
    AND convert(varchar(8),[wl].[SubmittedDate],112) >= '''+@strSDate+'''  
	AND convert(varchar(8),[wl].[SubmittedDate],112) <= '''+@strEDate+''' 
	AND [wl].StatusID = 1
	AND [wl].[Active] = 1
	AND [wl].[ModuleID] in (1,2)
    AND '''+@strSrMgrEmpID+''' <> ''999999''
	GROUP BY [wl].[FormName]) x)
	SELECT count(strFormID) FROM TempMain'
	
INSERT @CountResults	
EXEC (@nvcSQL)
SET @Count = (SELECT CountReturned FROM @CountResults)
 
END --sp_SelectFrom_Log_SRMGR_Count




GO

