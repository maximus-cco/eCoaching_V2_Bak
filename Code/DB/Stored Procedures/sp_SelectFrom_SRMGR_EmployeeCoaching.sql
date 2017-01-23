/*
sp_SelectFrom_SRMGR_EmployeeCoaching(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


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

