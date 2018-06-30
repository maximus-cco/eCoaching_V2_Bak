IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctCSR' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
--  Last Updated By: Susmitha Palacherla
--  Last Modified Date: 08/25/2015
--  Modified per TFS 599 to fix typo for 'All Employees'
--  TFS 7856 encryption/decryption - emp name
--  My Dashboard move to new architecture. TFS 7137 - 06/01/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSR] @strCSRMGRIDin nvarchar(10)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@NewLineChar nvarchar(2)


-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];
SET @NewLineChar = CHAR(13) + CHAR(10)

SET @nvcSQL = '
SELECT X.EmpText, X.EmpValue 
FROM (
       SELECT ''All Employees'' EmpText, ''-1'' EmpValue, 01 Sortorder
       UNION
       SELECT DISTINCT veh.Emp_Name EmpText, eh.Emp_ID EmplValue, 02 Sortorder
       FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
	   JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	   JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
	   JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
       WHERE  ((cl.[EmpID] = ''' + @strCSRMGRIDin  + '''  AND cl.[StatusID] in (3,4)) ' +  @NewLineChar +
			  ' OR (ISNULL([cl].[strReportCode], '' '') NOT LIKE ''LCS%'' AND cl.ReassignCount= 0 AND eh.Sup_ID = ''' + @strCSRMGRIDin  + ''' AND  cl.[StatusID] in (3,5,6,8) ' +  @NewLineChar +
			  ' OR (ISNULL([cl].[strReportCode], '' '') NOT LIKE ''LCS%'' AND cl.ReassignCount= 0 AND  eh.Mgr_ID = '''+ @strCSRMGRIDin  + ''' AND cl.[StatusID] in (5,7,9)) ' +  @NewLineChar +
			  ' OR ([cl].[strReportCode] LIKE ''LCS%'' AND [ReassignCount] = 0 AND cl.[MgrID] = ''' + @strCSRMGRIDin  + ''' AND [cl].[StatusID]= 5) )' +  @NewLineChar +
			  ' OR (cl.ReassignCount <> 0 AND cl.ReassignedToID = ''' + @strCSRMGRIDin  + ''' AND  cl.[StatusID] in (5,7,9)) ) 
         AND veh.Emp_Name IS NOT NULL
         AND ([eh].[Mgr_ID] <> ''999999'' AND [eh].[Sup_ID] <> ''999999'')
) X
ORDER BY X.Sortorder, X.EmpText';
		
EXEC (@nvcSQL)
--PRINT @nvcSQL
	
-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 

End --sp_SelectFrom_Coaching_LogMgrDistinctCSR




GO


