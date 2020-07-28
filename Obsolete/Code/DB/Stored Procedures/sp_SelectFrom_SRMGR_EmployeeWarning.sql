IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_EmployeeWarning' 
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
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
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
  @SearchExpression nvarchar(200);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

SET @strSDate = convert(varchar(8),@strSDatein,112)
SET @strEDate = convert(varchar(8),@strEDatein,112)
SET @strSrMgrEmpID = (SELECT [EC].[fn_nvcGetEmpIdFromLanId] (@strEMPSRMGRin, GETDATE()))
SET @LowerBand  = @startRowIndex 
SET @UpperBand  = @startRowIndex + @PageSize 
SET @searchBy = '%' + @searchBy + '%'
SET @SearchExpression = ' AND ([veh].[Emp_Name] LIKE '''+@searchBy+''' OR [veh].[Sup_Name] LIKE '''+@searchBy+'''' + 
' OR [veh].[Mgr_Name] LIKE '''+@searchBy+''')'

IF @sortASC = 'y' 
  SET @SortOrder = ' ASC';
ELSE 
  SET @SortOrder = ' DESC';

SET  @SortExpression =  @sortBy +  @SortOrder
--PRINT @SortExpression

SET @nvcSQL =  'WITH TempMain 
AS 
(
  SELECT DISTINCT x.strFormID
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
  (
    SELECT [wl].[FormName] strFormID,
      [wl].[WarningID] strID,
      [veh].[Emp_Name] strEmpName,
      [veh].[Sup_Name] strEmpSupName, 
      [veh].[Mgr_Name] strEmpMgrName, 
      [vehs].[Emp_Name] strSubmitterName,
      [s].[Status] strFormStatus,
      [sc].[SubCoachingSource] strSource,
      [wl].[SubmittedDate] SubmittedDate
    FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
    JOIN [EC].[Employee_Hierarchy] eh WITH (NoLOCK) ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Warning_Log] wl WITH (NOLOCK) ON [wl].[EmpID] = [eh].[Emp_ID] 
	JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON ISNULL([wl].[SubmitterID],''999999'') = [vehs].[Emp_ID] 
	JOIN [EC].[DIM_Status] s ON [wl].[StatusID] = [s].[StatusID] 
	JOIN  [EC].[DIM_Source] sc ON [wl].[SourceID] = [sc].[SourceID] 
    WHERE (eh.SrMgrLvl1_ID = ''' + @strSrMgrEmpID + ''' OR eh.SrMgrLvl2_ID = ''' + @strSrMgrEmpID + ''' OR eh.SrMgrLvl3_ID = ''' + @strSrMgrEmpID + ''')
      AND convert(varchar(8), [wl].[SubmittedDate],112) >= ''' + @strSDate + ''' 
      AND convert(varchar(8), [wl].[SubmittedDate],112) <= ''' + @strEDate + '''
      AND [wl].[StatusID] = 1
      AND [wl].[Active] = 1
      AND [wl].[ModuleID] in (1, 2) '
      + @SearchExpression + ' 
	  AND ''' + @strSrMgrEmpID + ''' <> ''999999''
    GROUP BY [wl].[FormName], [wl].[WarningID], [veh].[Emp_Name], [veh].[Sup_Name], [veh].[Mgr_Name], [vehs].[Emp_name], [s].[Status], [sc].[SubCoachingSource], [wl].[SubmittedDate]
  ) x
)

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
WHERE RowNumber >= ''' + CONVERT(VARCHAR, @LowerBand) + '''  AND RowNumber < ''' + CONVERT(VARCHAR, @UpperBand) + ''' 
ORDER BY ' + @SortExpression  

EXEC (@nvcSQL)

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 
	   
END --sp_SelectFrom_SRMGR_EmployeeWarning
GO