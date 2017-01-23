/*
eCoaching_Admin_Tool_Create(03).sql
Last Modified Date:12/2/2016
Last Modified By: Susmitha Palacherla

Version 03: Update to SPs # 1,2,4,7,9 from V&V feedback . TFS 3027 SMgr Dashboard setup - 12/2/2016 - SCP
added event date to coaching review #7
csr auto date for comp #1,2,4,9


Version 02: Update to SP #7 from V&V feedback . TFS 3027 SMgr Dashboard setup - 12/1/2016 - SCP
Added review sup and mgr in # 7

Version 01: Initial Revision . TFS 3027 SMgr Dashboard setup - 11/17/2016 - SCP

Summary

Tables
None

Procedures

1.[EC].[sp_SelectFrom_SRMGR_Count] 

2.[EC].[sp_SelectFrom_SRMGR_Detail_Count] 
3.[EC].[sp_SelectFrom_SRMGR_Details] 
4.[EC].[sp_SelectFrom_SRMGR_EmployeeCoaching] 
5.[EC].[sp_SelectFrom_SRMGR_EmployeeWarning]

6. [EC].[sp_SelectFrom_SRMGR_Review]
7. [EC].[sp_SelectFrom_SRMGR_EmployeeCoaching_Review]
8. [EC].[sp_SelectFrom_SRMGR_EmployeeWarning_Review]	

9.[EC].[sp_SelectFrom_SRMGR_Completed_CoachingByWeek]
10. [EC].[sp_SelectFrom_SRMGR_Pending_CoachingByWeek]	
11. [EC].[sp_SelectFrom_SRMGR_Active_WarningByWeek]	




 --Details

**************************************************************
--Tables
**************************************************************

-- None 


--***************************************






**************************************************************

--Procedures

**************************************************************/

--1.[EC].[sp_SelectFrom_SRMGR_Count] 


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






--**********************************

--2.[EC].[sp_SelectFrom_SRMGR_Detail_Count] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_Detail_Count' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_Detail_Count]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure returns the Count of  Coaching or warning logs that will be returned for 
--  the selected parameters in the Senior leadeship dashboard. 
--  Last Updated By: 
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_Detail_Count] 
@strEMPSRMGRin nvarchar(30),
@bitisCoaching bit,
@strStatus nvarchar(30) = NULL,
@strSDatein datetime,
@strEDatein datetime,
@Count INT OUTPUT,
@searchBy nvarchar(30)



AS

BEGIN
	DECLARE	
	@nvcSQL nvarchar(max),
	@strSrMgrEmpID nvarchar(10),
	@strFormStatus nvarchar(30),
	@strSDate nvarchar(8),
	@strEDate nvarchar(8),
	@intStatusID INT,
	@whereStatus nvarchar(200),
	@SearchExpression nvarchar(200) 
	
	DECLARE @CountResults TABLE (CountReturned INT) 
	


SET @strSDate = convert(varchar(8),@strSDatein,112)
SET @strEDate = convert(varchar(8),@strEDatein,112)

--PRINT @strSDate
--PRINT @strEDate

SET @strSrMgrEmpID = (SELECT [EC].[fn_nvcGetEmpIdFromLanId] (@strEMPSRMGRin, GETDATE()))

SET @searchBy = '%' + @searchBy + '%'
--PRINT @searchBy

SET @SearchExpression = ' AND ([eh].[Emp_Name] LIKE '''+@searchBy+''' OR [eh].[Sup_Name] LIKE '''+@searchBy+'''' + 
' OR [eh].[Mgr_Name] LIKE '''+@searchBy+''')'


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
+   @SearchExpression 
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
	AND [wl].[ModuleID] in (1,2) '
	+ @SearchExpression +
    ' AND '''+@strSrMgrEmpID+''' <> ''999999''
	GROUP BY [wl].[FormName]) x)
	SELECT count(strFormID) FROM TempMain'
	
INSERT @CountResults	
EXEC (@nvcSQL)
SET @Count = (SELECT CountReturned FROM @CountResults)
 
END --sp_SelectFrom_SRMGR_Detail_Count

GO











--**********************************

--3.[EC].[sp_SelectFrom_SRMGR_Details] 


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_Details' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_Details]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure calls the procedure(s) for Coaching or Warning details based on the 
--  user selection in the Sr mgr dashboard. 
--  Last Updated By: Susmitha Palacherla
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_Details] 
@strEMPSRMGRin nvarchar(30),
@bitisCoaching bit,
@strStatus nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@PageSize int,
@startRowIndex int, 
@sortBy nvarchar(100),
@sortASC nvarchar(1),
@searchBy nvarchar(30)
AS


BEGIN

IF @bitisCoaching = 1
BEGIN 
EXEC [EC].[sp_SelectFrom_SRMGR_EmployeeCoaching]  @strEMPSRMGRin ,@strStatus , @strSDatein,
@strEDatein, @PageSize, @startRowIndex, @sortBy, @sortASC, @searchBy 
END

IF @bitisCoaching = 0
BEGIN 
EXEC [EC].[sp_SelectFrom_SRMGR_EmployeeWarning] @strEMPSRMGRin, @strSDatein,
@strEDatein, @PageSize, @startRowIndex, @sortBy, @sortASC, @searchBy 
END



END --sp_SelectFrom_SRMGR_Details

GO






--**********************************


--4.[EC].[sp_SelectFrom_SRMGR_EmployeeCoaching] 



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_EmployeeCoaching' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_EmployeeCoaching]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure returns the Details for Coaching logs in given status
--  that fall under the logged in Sr Mgr.
--  Last Updated By: 
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_EmployeeCoaching] 
@strEMPSRMGRin nvarchar(30),
@strStatus nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@PageSize int,
@startRowIndex int, 
@sortBy nvarchar(100)= 'strFormStatus',
@sortASC nvarchar(1),
@searchBy nvarchar(30)
AS

BEGIN
	DECLARE	
	@nvcSQL nvarchar(max),
	@nvcSQL1 nvarchar(max),
	@nvcSQL2 nvarchar(max),
	@strSrMgrEmpID nvarchar(10),
	@strSDate nvarchar(8),
	@strEDate nvarchar(8),
	@UpperBand int,
	@LowerBand int,
	@SortExpression nvarchar(100),
	@SortOrder nvarchar(10) ,
	@where nvarchar(max),
	@SearchExpression nvarchar(200) 



SET @strSDate = convert(varchar(8),@strSDatein,112)
SET @strEDate = convert(varchar(8),@strEDatein,112)

--PRINT @strSDate
--PRINT @strEDate

SET @strSrMgrEmpID = (SELECT [EC].[fn_nvcGetEmpIdFromLanId] (@strEMPSRMGRin, GETDATE()))
SET @LowerBand  = @startRowIndex 
SET @UpperBand  = @startRowIndex + @PageSize 

		 
IF @strStatus = 'Completed'
BEGIN
	SET @where =   ' AND convert(varchar(8),[cl].[CSRReviewAutoDate],112) >= '''+@strSDate+'''' +  
	               ' AND convert(varchar(8),[cl].[CSRReviewAutoDate],112) <= '''+@strEDate+'''' +
	               ' AND [cl].[StatusID] = 1' + 
	               ' AND [cl].[ModuleID] in (1,2) '
END

IF @strStatus = 'Pending'
BEGIN
	SET @where =   ' AND convert(varchar(8),[cl].[SubmittedDate],112) >= '''+@strSDate+'''' +  
	               ' AND convert(varchar(8),[cl].[SubmittedDate],112) <= '''+@strEDate+'''' +
                   ' AND [cl].[StatusID] NOT IN (1,2)' +
                   ' AND [cl].[ModuleID] in (1,2) '
END


SET @searchBy = '%' + @searchBy + '%'
--PRINT @searchBy

SET @SearchExpression = ' AND ([eh].[Emp_Name] LIKE '''+@searchBy+''' OR [eh].[Sup_Name] LIKE '''+@searchBy+'''' + 
' OR [eh].[Mgr_Name] LIKE '''+@searchBy+''')'

	
--PRINT  @UpperBand

IF @sortBy = 'strFormStatus'
BEGIN
SET @sortBy = ' CASE WHEN strFormStatus = ''Pending Sr. Manager Review''  Then 0 Else 1 END, strFormStatus'
END

IF @sortASC = 'y' 
SET @SortOrder = ' ASC' ELSE 
SET @SortOrder = ' DESC' 
SET  @SortExpression =  @sortBy +  @SortOrder

--PRINT @SortExpression


SET @nvcSQL1 = 'WITH TempMain AS 
				(SELECT DISTINCT x.strFormID
				,x.strID
				,x.strEmpName
				,x.strEmpSupName
				,x.strEmpMgrName
				,x.strSubmitterName
				,x.strFormStatus
				,x.strSource
				,x.SubmittedDate
				,ROW_NUMBER() OVER (ORDER BY '+ @SortExpression +' ) AS RowNumber      
	 FROM 
	 (SELECT [cl].[FormName]	strFormID,
	        [cl].[CoachingID]	strID,
			[eh].[Emp_Name]	strEmpName,
			[eh].[Sup_Name]	strEmpSupName, 
			[eh].[Mgr_Name]	strEmpMgrName, 
			[sh].[Emp_Name]	strSubmitterName,
			[s].[Status]	strFormStatus,
			[so].[SubCoachingSource] strSource,
			[cl].[SubmittedDate]	SubmittedDate
	FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON
	[cl].[EmpID] = [eh].[Emp_ID] JOIN [EC].[Employee_Hierarchy] sh ON
	ISNULL([cl].[SubmitterID],''999999'') = [sh].[Emp_ID] JOIN [EC].[DIM_Status] s ON
	[cl].[StatusID] = [s].[StatusID] JOIN  [EC].[DIM_Source] so ON
	[cl].[SourceID] = [so].[SourceID]
	WHERE (eh.SrMgrLvl1_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl2_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl3_ID = '''+@strSrMgrEmpID+''')
    AND '''+@strSrMgrEmpID+''' <> ''999999'''
	+ @where +
	+ @SearchExpression +
	+ ' GROUP BY [cl].[FormName],[cl].[CoachingID],[eh].[Emp_Name],[eh].[Sup_Name],[eh].[Mgr_Name], 
	[sh].[Emp_Name],[s].[Status],[so].[SubCoachingSource],[cl].[SubmittedDate]) x)'


SET @nvcSQL2 = 'SELECT strFormID
		,strID
		,strEMPName
	    ,strEMPSupName
		,strEMPMgrName
		,strSubmitterName
		,strFormStatus
		,strSource
		,SubmittedDate
	    ,[EC].[fn_strCoachingReasonFromCoachingID](T.strID) strCoachingReason
	    ,[EC].[fn_strSubCoachingReasonFromCoachingID](T.strID)strSubCoachingReason
	    ,[EC].[fn_strValueFromCoachingID](T.strID)strValue
		,RowNumber                 
		FROM TempMain T
		WHERE RowNumber >= '''+CONVERT(VARCHAR,@LowerBand)+'''  AND RowNumber < '''+CONVERT(VARCHAR, @UpperBand) +
        ''' ORDER BY ' + @SortExpression  


SET @nvcSQL = @nvcSQL1 + @nvcSQL2

EXEC (@nvcSQL)
--Print @nvcSQL	   
END --sp_SelectFrom_SRMGR_EmployeeCoaching

GO







--**********************************

--5.[EC].[sp_SelectFrom_SRMGR_EmployeeWarning]



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_EmployeeWarning' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_EmployeeWarning]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure returns the Details for Active warning logs
--  that fall under the logged in Sr Mgr.
--  Last Updated By: 
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_EmployeeWarning] 
@strEMPSRMGRin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@PageSize int,
@startRowIndex int, 
@sortBy nvarchar(100),
@sortASC nvarchar(1),
@searchBy nvarchar(30)

AS

BEGIN
DECLARE	
	@nvcSQL nvarchar(max),
	@strSrMgrEmpID nvarchar(10),
	@strSDate nvarchar(8),
	@strEDate nvarchar(8),
	@UpperBand int,
	@LowerBand int,
	@SortExpression nvarchar(100),
	@SortOrder nvarchar(10),
	@SearchExpression nvarchar(200) 

SET @strSDate = convert(varchar(8),@strSDatein,112)
SET @strEDate = convert(varchar(8),@strEDatein,112)

--PRINT @strSDate
--PRINT @strEDate

SET @strSrMgrEmpID = (SELECT [EC].[fn_nvcGetEmpIdFromLanId] (@strEMPSRMGRin, GETDATE()))

SET @LowerBand  = @startRowIndex 
SET @UpperBand  = @startRowIndex + @PageSize 

SET @searchBy = '%' + @searchBy + '%'
--PRINT @searchBy

SET @SearchExpression = ' AND ([eh].[Emp_Name] LIKE '''+@searchBy+''' OR [eh].[Sup_Name] LIKE '''+@searchBy+'''' + 
' OR [eh].[Mgr_Name] LIKE '''+@searchBy+''')'


--PRINT  @UpperBand

IF @sortASC = 'y' 
SET @SortOrder = ' ASC' ELSE 
SET @SortOrder = ' DESC' 
SET  @SortExpression =  @sortBy +  @SortOrder

--PRINT @SortExpression

SET @nvcSQL =  'WITH TempMain AS 
				(SELECT DISTINCT x.strFormID
				,x.strID
				,x.strEmpName
				,x.strEmpSupName
				,x.strEmpMgrName
				,x.strSubmitterName
				,x.strFormStatus
				,x.strSource
				,x.SubmittedDate
				,ROW_NUMBER() OVER (ORDER BY '+ @SortExpression +' ) AS RowNumber      
FROM 
        (SELECT [wl].[FormName]	strFormID,
            [wl].[WarningID]	strID,
			[eh].[Emp_Name]	strEmpName,
			[eh].[Sup_Name]	strEmpSupName, 
			[eh].[Mgr_Name]	strEmpMgrName, 
			[sh].[Emp_Name]	strSubmitterName,
			[s].[Status]	strFormStatus,
			[sc].[SubCoachingSource] strSource,
			[wl].[SubmittedDate]	SubmittedDate
        FROM [EC].[Employee_Hierarchy] eh WITH (NOLOCK) JOIN [EC].[Warning_Log] wl WITH (NOLOCK) ON
			[wl].[EmpID] = [eh].[Emp_ID] JOIN [EC].[Employee_Hierarchy] sh ON
	        ISNULL([wl].[SubmitterID],''999999'') = [sh].[Emp_ID] JOIN [EC].[DIM_Status] s ON
			[wl].[StatusID] = [s].[StatusID] JOIN  [EC].[DIM_Source] sc ON
			[wl].[SourceID] = [sc].[SourceID] 
		WHERE (eh.SrMgrLvl1_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl2_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl3_ID = '''+@strSrMgrEmpID+''')
             AND convert(varchar(8),[wl].[SubmittedDate],112) >= '''+@strSDate+''' 
			 AND convert(varchar(8),[wl].[SubmittedDate],112) <= '''+@strEDate+'''
			 AND [wl].[StatusID] = 1
			 AND [wl].[Active] = 1
			 AND [wl].[ModuleID] in (1,2) '
			+ @SearchExpression +
			' AND '''+@strSrMgrEmpID+''' <> ''999999''
	GROUP BY [wl].[FormName],[wl].[WarningID],[eh].[Emp_Name],[eh].[Sup_Name],[eh].[Mgr_Name], [sh].[Emp_name]
	,[s].[Status],[sc].[SubCoachingSource],[wl].[SubmittedDate])
 x)
		SELECT strFormID
		,strID
		,strEMPName
	    ,strEMPSupName
		,strEMPMgrName
		,strSubmitterName
		,strSource
		,strFormStatus
		,SubmittedDate
		,[EC].[fn_strCoachingReasonFromWarningID](T.strID) strCoachingReason
	    ,[EC].[fn_strSubCoachingReasonFromWarningID](T.strID)strSubCoachingReason
	    ,[EC].[fn_strValueFromWarningID](T.strID)strValue
		,RowNumber                 
		FROM TempMain T
		WHERE RowNumber >= '''+CONVERT(VARCHAR,@LowerBand)+'''  AND RowNumber < '''+CONVERT(VARCHAR, @UpperBand) +
        ''' ORDER BY ' + @SortExpression  

		
EXEC (@nvcSQL)
--Print @nvcSQL	   
END --sp_SelectFrom_SRMGR_EmployeeWarning


GO





--**********************************

--6. [EC].[sp_SelectFrom_SRMGR_Review]



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_Review' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_Review]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure calls Procedure(s) to dosplay the review details for 
--  the Coaching or Warning log selected by the user.
--  Last Updated By: 
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_Review] @intFormIDin BIGINT, @bitisCoaching bit
AS

BEGIN


IF @bitisCoaching = 1
BEGIN 
EXEC  [EC].[sp_SelectFrom_SRMGR_EmployeeCoaching_Review]  @intFormIDin 
END

IF @bitisCoaching = 0
BEGIN 
EXEC  [EC].[sp_SelectFrom_SRMGR_EmployeeWarning_Review] @intFormIDin 
END

	    
END --sp_SelectFrom_SRMGR_Review

GO








--**********************************

--7. [EC].[sp_SelectFrom_SRMGR_EmployeeCoaching_Review]



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_EmployeeCoaching_Review' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_EmployeeCoaching_Review]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure returns the Review Details for Coaching log selected.
--  Last Updated By: 
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_EmployeeCoaching_Review] @intFormIDin BIGINT
AS

BEGIN
DECLARE	

@nvcSQL nvarchar(max),
@nvcSQL1 nvarchar(max),
@nvcSQL2 nvarchar(max),
@nvcSQL3 nvarchar(max),
@nvcEmpID nvarchar(10),
@nvcMgrID nvarchar(10)


SET @nvcEmpID = (SELECT [EmpID] From [EC].[Coaching_Log] WHERE [CoachingID]= @intFormIDin)	 
SET @nvcMgrID = (SELECT [Mgr_ID] From [EC].[Employee_Hierarchy] WHERE [Emp_ID] = @nvcEmpID)

  SET @nvcSQL = 'SELECT DISTINCT cl.CoachingID 	numID,
		cl.FormName	strFormID,
		sc.CoachingSource	strFormType,
		sc.SubCoachingSource	strSource,
		s.Status	strFormStatus,
		cl.SubmittedDate	SubmittedDate,
		cl.CoachingDate	CoachingDate,
		cl.EventDate	EventDate,
		sh.Emp_Name	strSubmitterName,
		eh.Emp_Name	strCSRName,
		st.City	strCSRSite,
		eh.Sup_Name strCSRSupName,
	CASE 
	     WHEN (cl.[statusId]in (6,8) AND cl.[ModuleID] in (1,3,4,5) AND cl.[ReassignedToID]is NOT NULL and [ReassignCount]<> 0)
		 THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
		 WHEN (cl.[statusId]= 5 AND cl.[ModuleID] = 2 AND cl.[ReassignedToID]is NOT NULL and [ReassignCount]<> 0)
		 THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
		 WHEN (cl.[Review_SupID]is NOT NULL and cl.[Review_SupID] = cl.[ReassignedToID] and [ReassignCount]= 0)
		 THEN [EC].[fn_strEmpNameFromEmpID](cl.[Review_SupID])
		 ELSE ''NA''
	END  strReassignedSupName,	
	CASE
		WHEN cl.[Review_SupID] IS NOT NULL THEN ISNULL(suph.Emp_Name,''Unknown'')
		ELSE ''NA'' END strReviewSup,
	CASE
		 WHEN cl.[strReportCode] like ''LCS%'' AND cl.[MgrID] <> '''+@nvcMgrID+'''
		 THEN [EC].[fn_strEmpNameFromEmpID](cl.[MgrID])+ '' (Assigned Reviewer)''
		 ELSE eh.Mgr_Name 
	END strCSRMgrName,
	CASE 
	     WHEN (cl.[statusId]= 5  AND cl.[ModuleID] in (1,3,4,5) AND cl.[ReassignedToID]is NOT NULL and [ReassignCount]<> 0)
		 THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
		 WHEN (cl.[statusId]= 7  AND cl.[ModuleID] = 2 AND cl.[ReassignedToID]is NOT NULL and [ReassignCount]<> 0)
		 THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
		 WHEN (cl.[Review_MgrID]is NOT NULL AND cl.[Review_MgrID] = cl.[ReassignedToID]and [ReassignCount]= 0)
		 THEN [EC].[fn_strEmpNameFromEmpID](cl.[Review_MgrID])
		 ELSE ''NA''
	END strReassignedMgrName, 
	CASE
		WHEN cl.[Review_MgrID] IS NOT NULL THEN ISNULL(mgrh.Emp_Name,''Unknown'')
		ELSE ''NA'' END strReviewMgr,
	    CASE WHEN sc.SubCoachingSource in (''Verint-GDIT'',''Verint-TQC'',''LimeSurvey'',''IQS'',''Verint-GDIT Supervisor'')
		THEN 1 ELSE 0 END 	isIQS,
		CASE WHEN sc.SubCoachingSource = ''Coach the coach''
		THEN 1 ELSE 0 END 	isCTC,
		cl.isUCID    isUCID,
		cl.UCID	strUCID,
		cl.isVerintID	isVerintMonitor,
		cl.VerintID	strVerintID,
		cl.VerintFormName VerintFormName,
		cl.isCoachingMonitor isCoachingMonitor,
		cl.isAvokeID	isBehaviorAnalyticsMonitor,
		cl.AvokeID	strBehaviorAnalyticsID,
		cl.isNGDActivityID	isNGDActivityID,
		cl.NGDActivityID	strNGDActivityID,      
       	cl.Description txtDescription,
		cl.CoachingNotes txtCoachingNotes,
		cl.SubmittedDate,
		cl.SupReviewedAutoDate,
		cl.isCSE,
		cl.MgrReviewManualDate,
		cl.MgrReviewAutoDate,
		cl.MgrNotes txtMgrNotes,
		cl.CSRReviewAutoDate,
		cl.CSRComments txtCSRComments,
		[EC].[fn_strCoachingReasonFromCoachingID](cl.CoachingID) strCoachingReason,
		[EC].[fn_strSubCoachingReasonFromCoachingID](cl.CoachingID)strSubCoachingReason,
		[EC].[fn_strValueFromCoachingID](cl.CoachingID)strValue
	    FROM  [EC].[Coaching_Log] cl JOIN  [EC].[Coaching_Log_Reason] clr
	    ON [cl].[CoachingID] = [clr].[CoachingID] JOIN  [EC].[Employee_Hierarchy] eh
	    ON [cl].[EMPID] = [eh].[Emp_ID] JOIN [EC].[Employee_Hierarchy] sh
	    ON [cl].[SubmitterID] = [sh].[Emp_ID] JOIN [EC].[Employee_Hierarchy] suph
	    ON ISNULL([cl].[Review_SupID],''999999'') = [suph].[Emp_ID] JOIN [EC].[Employee_Hierarchy] mgrh
	    ON ISNULL([cl].[Review_MgrID],''999999'') = [mgrh].[Emp_ID]JOIN [EC].[DIM_Status] s
	    ON [cl].[StatusID] = [s].[StatusID] JOIN [EC].[DIM_Source] sc
        ON [cl].[SourceID] = [sc].[SourceID] JOIN [EC].[DIM_Site] st
	    ON [cl].[SiteID] = [st].[SiteID] JOIN [EC].[DIM_Module] m ON [cl].[ModuleID] = [m].[ModuleID]
	    Where [cl].[CoachingID] = '''+CONVERT(NVARCHAR(20),@intFormIDin) + ''''
		

EXEC (@nvcSQL)
--Print (@nvcSQL)
	    
END --sp_SelectFrom_SRMGR_EmployeeCoaching_Review
GO


--**********************************

--8. [EC].[sp_SelectFrom_SRMGR_EmployeeWarning_Review]


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_EmployeeWarning_Review' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_EmployeeWarning_Review]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure returns the Review Details for Warning log selected.
--  Last Updated By: 
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_EmployeeWarning_Review] @intFormIDin nvarchar(50)
AS

BEGIN
DEClARE	

@nvcSQL nvarchar(max),
@nvcEmpID nvarchar(10),
@nvcMgrID nvarchar(10)


SET @nvcEmpID = (SELECT [EmpID] From [EC].[warning_Log] WHERE [FormName]= @intFormIDin)	 
SET @nvcMgrID = (SELECT [Mgr_ID] From [EC].[Employee_Hierarchy] WHERE [Emp_ID] = @nvcEmpID)

  SET @nvcSQL = 'SELECT DISTINCT wl.warningID 	numID,
		wl.FormName	strFormID,
		''Direct''	strFormType,
		''Completed''	strFormStatus,
		sc.SubCoachingSource	strSource,
		wl.SubmittedDate	SubmittedDate,
		wl.WarningGivenDate	warningDate,
		sh.Emp_Name	strSubmitterName,
		eh.Emp_Name	strCSRName,
		st.City	strCSRSite,
		eh.Sup_Name strCSRSupName,
        eh.Mgr_Name strCSRMgrName,	  
       	[EC].[fn_strCoachingReasonFromwarningID](wl.warningID) strCoachingReason,
		[EC].[fn_strSubCoachingReasonFromwarningID](wl.warningID)strSubCoachingReason,
		[EC].[fn_strValueFromwarningID](wl.warningID)strValue
	    FROM  [EC].[warning_Log] wl JOIN  [EC].[warning_Log_Reason] wlr
	    ON [wl].[warningID] = [wlr].[warningID] JOIN  [EC].[Employee_Hierarchy] eh
	    ON [wl].[EMPID] = [eh].[Emp_ID] JOIN [EC].[Employee_Hierarchy] sh
	    ON [wl].[SubmitterID] = [sh].[Emp_ID] JOIN [EC].[DIM_Status] s
	    ON [wl].[StatusID] = [s].[StatusID] JOIN [EC].[DIM_Source] sc
        ON [wl].[SourceID] = [sc].[SourceID] JOIN [EC].[DIM_Site] st
	    ON [wl].[SiteID] = [st].[SiteID] JOIN [EC].[DIM_Module] m ON [wl].[ModuleID] = [m].[ModuleID]
	     Where [wl].[WarningID] = '''+CONVERT(NVARCHAR(20),@intFormIDin) + ''''
		

EXEC (@nvcSQL)
--Print (@nvcSQL)
	    
END --sp_SelectFrom_SRMGR_EmployeeWarning_Review

GO









--**********************************

--9.[EC].[sp_SelectFrom_SRMGR_Completed_CoachingByWeek]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_Completed_CoachingByWeek' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_Completed_CoachingByWeek]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure returns the Count of completed Coaching logs for selected month
--  that fall under the logged in Sr Mgr.
--  Last Updated By: 
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_Completed_CoachingByWeek] 
@strEMPSRMGRin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime

AS

BEGIN
	DECLARE	
	@nvcSQL nvarchar(max),
	@strSrMgrEmpID nvarchar(10),
    @strSDate nvarchar(8),
	@strEDate nvarchar(8),
	@intStatusID INT,
	@whereStatus nvarchar(200) 


SET @strSDate = convert(varchar(8),@strSDatein,112)
SET @strEDate = convert(varchar(8),@strEDatein,112)

PRINT @strSDate
PRINT @strEDate

SET @strSrMgrEmpID = (SELECT [EC].[fn_nvcGetEmpIdFromLanId] (@strEMPSRMGRin, GETDATE()))

SET @nvcSQL = 'WITH CompletedByWeeks AS 
(
Select x.WeekNum, x.Value
 FROM (SELECT * FROM 
  (Select FullDate,
datediff(week, dateadd(month, datediff(month, 0, FullDate), 0), FullDate) +1 WeekNum
FROM EC.DIM_Date
WHERE convert(varchar(8),Datekey) >= '''+@strSDate+''' 
	AND convert(varchar(8),Datekey) <= '''+@strEDate+''' )Dates,
  (Select Distinct Value from EC.Coaching_Log_Reason
  WhERe Value in (''Met goal'',''Did not meet goal'',''Opportunity'',''Reinforcement'') )ReasonValues)x
GROUP BY x.WeekNum, x.Value
), Selected AS
 (SELECT cl.CoachingID,  cl.CSRReviewAutoDate, datediff(week, dateadd(month, datediff(month, 0, [cl].[CSRReviewAutoDate]), 0), [cl].[CSRReviewAutoDate]) +1 WeekNum, clr.Value
  FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log]cl
  ON eh.Emp_ID = cl.EmpID JOIN [EC].[Coaching_Log_Reason]clr 
  ON cl.CoachingID = clr.CoachingID 
  WHERE convert(varchar(8),[cl].[CSRReviewAutoDate],112) >= '''+@strSDate+''' 
	AND convert(varchar(8),[cl].[CSRReviewAutoDate],112) <= '''+@strEDate+'''
  AND cl.StatusId = 1
  AND cl.ModuleID in (1,2)
  AND (eh.SrMgrLvl1_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl2_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl3_ID = '''+@strSrMgrEmpID+''')
  AND '''+@strSrMgrEmpID+''' <> ''999999''
  )  
  Select CompletedByWeeks.WeekNum, CompletedByWeeks.Value, Count(Selected.CoachingID)LogCount
  From CompletedByWeeks LEFT OUTER JOIN Selected
  ON CompletedByWeeks.WeekNum = Selected.WeekNum
   AND CompletedByWeeks.Value = Selected.Value
  GROUP BY CompletedByWeeks.WeekNum, CompletedByWeeks.Value 
  ORDER BY CompletedByWeeks.WeekNum, CompletedByWeeks.Value '

  

--Print @nvcSQL	  
Exec (@nvcSQL) 
END --sp_SelectFrom_SRMGR_Completed_CoachingByWeek


GO





--**********************************
--10. [EC].[sp_SelectFrom_SRMGR_Pending_CoachingByWeek]


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_Pending_CoachingByWeek' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_Pending_CoachingByWeek]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure returns the Count of Pending Coaching logs for selected month
--  that fall under the logged in Sr Mgr.
--  Last Updated By: 
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--	====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_Pending_CoachingByWeek] 
@strEMPSRMGRin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime

AS

BEGIN
	DECLARE	
	@nvcSQL nvarchar(max),
	@strSrMgrEmpID nvarchar(10),
	@strSDate nvarchar(8),
	@strEDate nvarchar(8),
	@intStatusID INT,
	@whereStatus nvarchar(200) 
	
SET @strSDate = convert(varchar(8),@strSDatein,112)
SET @strEDate = convert(varchar(8),@strEDatein,112)

PRINT @strSDate
PRINT @strEDate

SET @strSrMgrEmpID = (SELECT [EC].[fn_nvcGetEmpIdFromLanId] (@strEMPSRMGRin, GETDATE()))

SET @nvcSQL = 'WITH PendingByWeeks AS 
(
Select x.WeekNum, x.Status
 FROM (SELECT * FROM 
  (Select FullDate,
datediff(week, dateadd(month, datediff(month, 0, FullDate), 0), FullDate) +1 WeekNum
FROM EC.DIM_Date
WHERE convert(varchar(8),Datekey) >= '''+@strSDate+''' 
	AND convert(varchar(8),Datekey) <= '''+@strEDate+''' )Dates,
 (Select Status from EC.DIM_Status
Where StatusId in (3,4,5,6,7))Pending)x
GROUP BY x.WeekNum, x.Status
), Selected AS
 (SELECT cl.CoachingID,  cl.submitteddate, datediff(week, dateadd(month, datediff(month, 0, [cl].[SubmittedDate]), 0), [cl].[SubmittedDate]) +1 WeekNum, s.Status
  FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log]cl
  ON eh.Emp_ID = cl.EmpID JOIN [EC].[DIM_Status]s
  ON cl.StatusID = s.StatusID 
  WHERE convert(varchar(8),[cl].[SubmittedDate],112) >= '''+@strSDate+''' 
  AND convert(varchar(8),[cl].[SubmittedDate],112) <= '''+@strEDate+'''
  AND cl.StatusId in (3,4,5,6,7)
  AND cl.ModuleID in (1,2)
  AND (eh.SrMgrLvl1_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl2_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl3_ID = '''+@strSrMgrEmpID+''')
  AND '''+@strSrMgrEmpID+''' <> ''999999''
  ) 
  
  Select PendingByWeeks.WeekNum, PendingByWeeks.Status, Count(Selected.CoachingID)LogCount
  From PendingByWeeks LEFT OUTER JOIN Selected
  ON PendingByWeeks.WeekNum = Selected.WeekNum
   AND PendingByWeeks.Status = Selected.Status
  GROUP BY PendingByWeeks.WeekNum, PendingByWeeks.Status 
  ORDER BY PendingByWeeks.WeekNum, PendingByWeeks.Status '

  

--Print @nvcSQL	  
Exec (@nvcSQL) 
END --sp_SelectFrom_SRMGR_Pending_CoachingByWeek

GO







--**********************************


	
--11. [EC].[sp_SelectFrom_SRMGR_Active_WarningByWeek]


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_Active_WarningByWeek' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_Active_WarningByWeek]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure returns the Count of Active Warning logs for selected month
--  that fall under the logged in Sr Mgr.
--  Last Updated By: 
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_Active_WarningByWeek] 
@strEMPSRMGRin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime

AS

BEGIN
	DECLARE	
	@nvcSQL nvarchar(max),
	@strSrMgrEmpID nvarchar(10),
	@strSDate nvarchar(8),
	@strEDate nvarchar(8),
	@intStatusID INT,
	@whereStatus nvarchar(200) 
	
SET @strSDate = convert(varchar(8),@strSDatein,112)
SET @strEDate = convert(varchar(8),@strEDatein,112)

PRINT @strSDate
PRINT @strEDate

SET @strSrMgrEmpID = (SELECT [EC].[fn_nvcGetEmpIdFromLanId] (@strEMPSRMGRin, GETDATE()))

SET @nvcSQL = 'WITH ReasonsByWeeks AS 
(
Select x.WeekNum, x.CoachingReason
 FROM (SELECT * FROM 
  (Select FullDate,
datediff(week, dateadd(month, datediff(month, 0, FullDate), 0), FullDate) +1 WeekNum
FROM EC.DIM_Date
WHERE convert(varchar(8),Datekey) >= '''+@strSDate+''' 
	AND convert(varchar(8),Datekey) <= '''+@strEDate+''' )Dates,
 (Select CoachingReason from EC.DIM_Coaching_Reason
Where CoachingReasonID in (28,29,30))Reasons)x
GROUP BY x.WeekNum, x.CoachingReason
), Selected AS
 (SELECT wl.warningID,  wl.submitteddate, datediff(week, dateadd(month, datediff(month, 0, [wl].[SubmittedDate]), 0), [wl].[SubmittedDate]) +1 WeekNum, dcr.CoachingReason
  FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Warning_Log]wl
  ON eh.Emp_ID = wl.EmpID JOIN [EC].[Warning_Log_Reason]wlr 
  ON wl.WarningID = wlr.WarningID JOIN EC.DIM_Coaching_Reason dcr 
  ON dcr.CoachingReasonID = wlr.CoachingReasonID
  WHERE convert(varchar(8),[wl].[SubmittedDate],112) >= '''+@strSDate+''' 
	AND convert(varchar(8),[wl].[SubmittedDate],112) <= '''+@strEDate+'''
  AND wl.Active = 1
  AND wl.StatusID = 1
  AND wl.ModuleID in (1,2)
  AND (eh.SrMgrLvl1_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl2_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl3_ID = '''+@strSrMgrEmpID+''')
  AND '''+@strSrMgrEmpID+''' <> ''999999''
  AND wlr.CoachingReasonID in (28,29,30)) 
  
  Select ReasonsByWeeks.WeekNum, ReasonsByWeeks.CoachingReason, Count(Selected.WarningID)LogCount
  From ReasonsByWeeks LEFT OUTER JOIN Selected
  ON ReasonsByWeeks.WeekNum = Selected.WeekNum
   AND ReasonsByWeeks.CoachingReason = Selected.CoachingReason
  GROUP BY ReasonsByWeeks.WeekNum, ReasonsByWeeks.CoachingReason 
  ORDER BY ReasonsByWeeks.WeekNum, ReasonsByWeeks.CoachingReason '

  

--Print @nvcSQL	  
Exec (@nvcSQL) 
END --sp_SelectFrom_SRMGR_Active_WarningByWeek


GO
--*******************************************************************************************************


