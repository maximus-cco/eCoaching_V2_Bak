/*
sp_Dashboard_Director_Site_Warning(01).sql
Last Modified Date: 05/28/2018
Last Modified By: Susmitha Palacherla


Version 01: Document Initial Revision created during My dashboard redesign.  TFS 7137 - 05/28/2018

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Dashboard_Director_Site_Warning' 
)
   DROP PROCEDURE [EC].[sp_Dashboard_Director_Site_Warning]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	05/22/2018
--	Description: *	This procedure returns the Active Warning logs at a given site 
--  For Employees within the Director's Hierarchy.
--  Initial Revision created during MyDashboard redesign.  TFS 7137 - 05/22/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Dashboard_Director_Site_Warning] 
@intSiteIdin int,
@nvcUserIdin nvarchar(10),
@strSDatein datetime,
@strEDatein datetime,
@PageSize int,
@startRowIndex int, 
@sortBy nvarchar(100),
@sortASC nvarchar(1)
AS


BEGIN


SET NOCOUNT ON

DECLARE	
@nvcSQL nvarchar(max),
@strSDate nvarchar(10),
@strEDate nvarchar(10),
@UpperBand int,
@LowerBand int,
@SortExpression nvarchar(100),
@SortOrder nvarchar(10) ,
@OrderKey nvarchar(10)
  

SET @LowerBand  = @startRowIndex 
SET @UpperBand  = @startRowIndex + @PageSize 


--PRINT @UpperBand

IF @sortASC = 'y' 
SET @SortOrder = ' ASC' ELSE 
SET @SortOrder = ' DESC' 
SET  @SortExpression = @sortBy +  @SortOrder
--PRINT @SortExpression

SET @strSDate = convert(varchar(8), @strSDatein,112)
Set @strEDate = convert(varchar(8), @strEDatein,112)

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

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
				,ROW_NUMBER() OVER (ORDER BY '+ @SortExpression +' ) AS RowNumber    
  FROM 
  (
    SELECT DISTINCT [wl].[FormName] strFormID
      ,[wl].[WarningID] strLogID
      ,[veh].[Emp_Name]	strEmpName
	  ,[veh].[Sup_Name]	strEmpSupName
	  ,[veh].[Mgr_Name] strEmpMgrName
	  ,[s].[Status] strFormStatus
	  ,[so].[SubCoachingSource]	strSource
	  ,[wl].[SubmittedDate]	SubmittedDate
	  ,[vehs].[Emp_Name] strSubmitterName
    FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
	JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Warning_Log] wl WITH(NOLOCK) ON wl.EmpID = eh.Emp_ID 
	LEFT JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON wl.SubmitterID = vehs.EMP_ID 
	JOIN [EC].[DIM_Status] s ON wl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON wl.SourceID = so.SourceID 
	WHERE wl.StatusID = 1
	AND wl.SiteID = '''+CONVERT(NVARCHAR,@intSiteIdin)+'''
	AND wl.Active = 1
	AND wl.siteID <> -1
	AND (eh.SrMgrLvl1_ID = '''+ @nvcUserIdin+ ''' OR eh.SrMgrLvl2_ID = '''+ @nvcUserIdin +''' OR eh.SrMgrLvl3_ID = '''+ @nvcUserIdin +''')
	AND convert(varchar(8), [wl].[SubmittedDate], 112) >= ''' + @strSDate + '''
    AND convert(varchar(8), [wl].[SubmittedDate], 112) <= ''' + @strEDate + '''
	GROUP BY [wl].[FormName], [wl].[WarningID], [veh].[Emp_Name], [veh].[Sup_Name], [veh].[Mgr_Name], [s].[Status], [so].[SubCoachingSource], [wl].[SubmittedDate], [vehs].[Emp_Name]
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
  ,[EC].[fn_strCoachingReasonFromWarningID](T.strLogID) strCoachingReason
  ,[EC].[fn_strSubCoachingReasonFromWarningID](T.strLogID) strSubCoachingReason
  ,[EC].[fn_strValueFromWarningID](T.strLogID) strValue
  ,RowNumber                 
FROM TempMain T
WHERE RowNumber >= ''' + CONVERT(VARCHAR, @LowerBand) + '''  AND RowNumber < ''' + CONVERT(VARCHAR, @UpperBand) + '''
ORDER BY ' + @SortExpression  



EXEC (@nvcSQL)	
--PRINT @nvcSQL

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
END -- sp_Dashboard_Director_Site_Warning




GO





