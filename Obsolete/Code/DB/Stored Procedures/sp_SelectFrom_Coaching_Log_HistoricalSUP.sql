IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_HistoricalSUP' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	4/30/2012
--	Description: *	This procedure selects the CSR e-Coaching completed records to display on SUP historical page
--  Last Modified: 4/6/2016
--  Last Modified By: Susmitha Palacherla
--  Modified to add additional HR job code WHHR70 - TFS 1423 - 12/15/2015
--  Modified to reference table for HR job codes - TFS 2332 - 4/6/2016
--  TFS 7856 encrypt/decrypt - emp name
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP] 

@strUserin nvarchar(30),
@strSourcein nvarchar(100),
@strCSRSitein nvarchar(30),
@strCSRin nvarchar(30),
@strSUPin nvarchar(30),
@strMGRin nvarchar(30),
@strSubmitterin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@strStatusin nvarchar(30), 
@strjobcode  nvarchar(20),
@strvalue  nvarchar(30),
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
@nvcEmpID nvarchar(10),
@dtmDate datetime,
@strSDate nvarchar(10),
@strEDate nvarchar(10),
@nvcDisplayWarnings nvarchar(5),
@UpperBand int,
@LowerBand int,
@SortExpression nvarchar(100),
@SortOrder nvarchar(10) ,
@OrderKey nvarchar(10),
@where nvarchar(max);        

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @strSDate = convert(varchar(8), @strSDatein,112)
Set @strEDate = convert(varchar(8), @strEDatein,112)
SET @LowerBand  = @startRowIndex 
SET @UpperBand  = @startRowIndex + @PageSize 

SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@strUserin,@dtmDate)
SET @nvcDisplayWarnings = (SELECT ISNULL (EC.fn_strCheckIf_HRUser(@nvcEmpID), 'NO')) 
SET @where = ' WHERE convert(varchar(8), [cl].[SubmittedDate], 112) >= ''' + @strSDate + '''' +  
			 ' AND convert(varchar(8), [cl].[SubmittedDate], 112) <= ''' + @strEDate + '''' +
			 ' AND [cl].[StatusID] <> 2'
			 
IF @strSourcein <> '%'
BEGIN
	SET @where = @where + ' AND [so].[SubCoachingSource] = ''' + @strSourcein + ''''
END
IF @strStatusin <> '%'
BEGIN
	SET @where = @where + ' AND [s].[Status] = ''' + @strStatusin + ''''
END
IF @strvalue <> '%'
BEGIN
	SET @where = @where + ' AND [clr].[value] = ''' + @strvalue + ''''
END
IF @strCSRin <> '%' 
BEGIN
	SET @where = @where + ' AND [cl].[EmpID] =   ''' + @strCSRin + '''' 
END
IF @strSUPin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Sup_ID] = ''' + @strSUPin + '''' 
END
IF @strMGRin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Mgr_ID] = ''' + @strMGRin + '''' 
END	
IF @strSubmitterin <> '%'
BEGIN
	SET @where = @where + ' AND [cl].[SubmitterID] = ''' + @strSubmitterin + '''' 
END
IF @strCSRSitein <> '%'
BEGIN
	SET @where = @where + ' AND CONVERT(varchar,[cl].[SiteID]) = ''' + @strCSRSitein + ''''
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
    ,x.strCoachingID
    ,x.strCSRName
    ,x.strCSRSupName
    ,x.strCSRMgrName
    ,x.strFormStatus
    ,x.strSource
    ,x.SubmittedDate
    ,x.strSubmitterName
    ,x.orderkey
    ,ROW_NUMBER() OVER (ORDER BY '+ @SortExpression +' ) AS RowNumber    
  FROM 
  (
    SELECT DISTINCT [cl].[FormName] strFormID
      ,[cl].[CoachingID] strCoachingID
      ,[veh].[Emp_Name]	strCSRName
	  ,[veh].[Sup_Name]	strCSRSupName
	  ,[veh].[Mgr_Name] strCSRMgrName
	  ,[s].[Status] strFormStatus
	  ,[so].[SubCoachingSource]	strSource
	  ,[cl].[SubmittedDate]	SubmittedDate
	  ,[vehs].[Emp_Name] strSubmitterName
	  ,''ok1'' orderkey
    FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
	JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
	JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON cl.SubmitterID = vehs.EMP_ID 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID 
	JOIN [EC].[Coaching_Log_Reason] clr WITH (NOLOCK) ON cl.CoachingID = clr.CoachingID' +  
	@where + ' ' + '
	GROUP BY [cl].[FormName], [cl].[CoachingID], [veh].[Emp_Name], [veh].[Sup_Name], [veh].[Mgr_Name], [s].[Status], [so].[SubCoachingSource], [cl].[SubmittedDate], [vehs].[Emp_Name]'

SET @where = 
' WHERE convert(varchar(8),[wl].[SubmittedDate],112) >= ''' + @strSDate + '''' +  
' AND convert(varchar(8),[wl].[SubmittedDate],112) <= ''' + @strEDate + '''' +
' AND [wl].[StatusID] <> 2';
			 
IF @strSourcein <> '%'
BEGIN
	SET @where = @where + ' AND [so].[SubCoachingSource] = ''' + @strSourcein + ''''
END
IF @strStatusin <> '%'
BEGIN
	SET @where = @where + ' AND [s].[Status] = ''' + @strStatusin + ''''
END
IF @strvalue <> '%'
BEGIN
	SET @where = @where + ' AND [wlr].[value] = ''' + @strvalue + ''''
END
IF @strCSRin <> '%' 
BEGIN
	SET @where = @where + ' AND [wl].[EmpID] = ''' + @strCSRin + '''' 
END
IF @strSUPin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Sup_ID] = ''' + @strSUPin + '''' 
END
IF @strMGRin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Mgr_ID] = ''' + @strMGRin + ''''
END	
IF @strSubmitterin <> '%'
BEGIN
	SET @where = @where + ' AND [wl].[SubmitterID] = ''' + @strSubmitterin + '''' 
END
IF @strCSRSitein <> '%'
BEGIN
	SET @where = @where + ' AND CONVERT(varchar,[wl].[SiteID]) = ''' + @strCSRSitein + '''';
END	

SET @nvcSQL2 = ' 
UNION
  SELECT DISTINCT [wl].[FormName]	strFormID
    ,[wl].[WarningID]	strCoachingID
    ,[veh].[Emp_Name]	strCSRName
	,[veh].[Sup_Name]	strCSRSupName
	,[veh].[Mgr_Name]	strCSRMgrName
	,[s].[Status]		strFormStatus
	,[so].[SubCoachingSource]	strSource
	,[wl].[SubmittedDate]	SubmittedDate
	,[vehs].[Emp_Name]	strSubmitterName
	,''ok2'' orderkey
  FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
  JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
  JOIN [EC].[Warning_Log] wl WITH(NOLOCK) ON wl.EmpID = eh.Emp_ID 
  JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON wl.SubmitterID = vehs.EMP_ID 
  JOIN [EC].[DIM_Status] s ON wl.StatusID = s.StatusID 
  JOIN [EC].[DIM_Source] so ON wl.SourceID = so.SourceID
  JOIN [EC].[Warning_Log_Reason] wlr WITH (NOLOCK) ON wl.WarningID = wlr.WarningID' + 
  @where + ' ' + '
  GROUP BY [wl].[FormName], [wl].[WarningID], [veh].[Emp_Name], [veh].[Sup_Name], [veh].[Mgr_Name], [s].[Status], [so].[SubCoachingSource], [wl].[SubmittedDate], [vehs].[Emp_Name]'

SET @nvcSQL3 = ' 
  ) x 
)

SELECT strFormID
  ,strCSRName
  ,strCSRSupName
  ,strCSRMgrName
  ,strFormStatus
  ,strSource
  ,SubmittedDate
  ,strSubmitterName
  ,CASE WHEN T.orderkey = ''ok1'' THEN [EC].[fn_strCoachingReasonFromCoachingID](T.strCoachingID)
	 ELSE [EC].[fn_strCoachingReasonFromWarningID](T.strCoachingID) 
   END strCoachingReason
  ,CASE WHEN T.orderkey = ''ok1'' THEN [EC].[fn_strSubCoachingReasonFromCoachingID](T.strCoachingID)
	 ELSE [EC].[fn_strSubCoachingReasonFromWarningID](T.strCoachingID) 
   END strSubCoachingReason
  ,CASE WHEN T.orderkey = ''ok1'' THEN [EC].[fn_strValueFromCoachingID](T.strCoachingID)
	 ELSE [EC].[fn_strValueFromWarningID](T.strCoachingID)
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
PRINT @nvcSQL

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
END -- SelectFrom_Coaching_Log_HistoricalSUP
GO