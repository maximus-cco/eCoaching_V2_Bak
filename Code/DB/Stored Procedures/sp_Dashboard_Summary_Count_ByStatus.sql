SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	05/22/2018
--  Description: Retrieves Count of Logs by Status to be displayed
--  on the My Dashboard.
--  Initial Revision created during MyDashboard redesign.  TFS 7137 - 05/22/2018
--  Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
--  Removed references to SrMgr Role. TFS 18062 - 08/18/2020
--  Modified to exclude QN Logs. TFS 22187 - 08/03/2021
--  Modified to Support ISG Alignment Project. TFS 28026 - 05/06/2024
--  Modified to add the Production Planning Module to eCoaching. TFS 28361 - 07/24/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Dashboard_Summary_Count_ByStatus] 
@nvcEmpID nvarchar(10)

AS

BEGIN
DECLARE	
@nvcEmpRole nvarchar(40),
@nvcSQL nvarchar(max)




OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert] 
SET @nvcEmpRole = [EC].[fn_strGetUserRole](@nvcEmpID)
--PRINT @nvcEmpRole

--3 - Pending Acknowledgement
--4 - Pending Employee Review
--5 - Pending Manager Review
--6 - Pending Supervisor Review
--7 - Pending Sr. Manager Review
--8 - Pending Quality Lead Review
--9 - Pending Deputy Program Manager Review
--10 - Pending Follow-up


IF @nvcEmpRole in ('CSR','ISG', 'ARC', 'Employee')

SET @nvcSQL = ' ;WITH SelectedStatus AS
				(SELECT StatusID, Status FROM EC.DIM_Status WHERE StatusID in (3,4)),
			
               
			    SelectedLogs AS
				(SELECT i.StatusID, SUM(i.LogCount) LogCount FROM 
                (SELECT StatusID, Count(cl.CoachingID) LogCount
				FROM [EC].[Coaching_Log] cl WITH(NOLOCK)  
			    WHERE   (cl.[EmpID] = ''' + @nvcEmpID + '''  AND cl.[StatusID] in (3,4))
				AND cl.[SourceID] NOT IN (235, 236)
		   	    GROUP BY [cl].[StatusID]
				UNION
				SELECT StatusID, Count(wl.WarningID) LogCount
				FROM [EC].[Warning_Log] wl WITH(NOLOCK)  
			    WHERE   (wl.[EmpID] = ''' + @nvcEmpID + '''  AND wl.[StatusID] = 4)
				GROUP BY [wl].[StatusID])i
				GROUP BY i.StatusID)

				SELECT s.Status, COALESCE(cl.LogCount,0) AS LogCount
				FROM SelectedStatus s left join SelectedLogs cl
				ON s.statusid = cl.StatusID '



IF @nvcEmpRole = 'Supervisor'

SET @nvcSQL = ';WITH SelectedStatus AS
				(SELECT StatusID, Status FROM EC.DIM_Status WHERE StatusID in (3,4,6,8,10)),

                SelectedLogs AS
			   (SELECT [cl].[StatusID], Count(CoachingID) LogCount
               FROM [EC].[Coaching_Log] cl WITH(NOLOCK) JOIN [EC].[Employee_Hierarchy] eh 
			   ON eh.[EMP_ID] = cl.[EmpID] 
			   WHERE ((cl.[EmpID] = ''' + @nvcEmpID + '''  AND cl.[StatusID] in (3,4))
		       OR ((cl.[ReassignCount]= 0 AND eh.[Sup_ID] = ''' + @nvcEmpID + ''' AND cl.[StatusID] in (3,6,8,10)))
		       OR (cl.[ReassignedToId] = ''' + @nvcEmpID + '''  AND [ReassignCount] <> 0 AND cl.[StatusID]in (3,6,8,10)))
		       AND cl.[EmpID]  <> ''999999''
			   AND cl.[SourceID] NOT IN (235, 236)
			   GROUP BY [cl].[StatusID])
			   
			   	SELECT s.Status, COALESCE(cl.LogCount,0) AS LogCount
				FROM SelectedStatus s left join SelectedLogs cl
				ON s.statusid = cl.StatusID '


IF @nvcEmpRole = 'Manager'


SET @nvcSQL = ';WITH SelectedStatus AS
				(SELECT StatusID, Status FROM EC.DIM_Status WHERE StatusID in (3,4,5,6,7,8,9)),

			   SelectedLogs AS
			   (SELECT [cl].[StatusID], Count(CoachingID) LogCount
               FROM [EC].[Coaching_Log] cl WITH(NOLOCK) JOIN [EC].[Employee_Hierarchy] eh 
			   ON eh.[EMP_ID] = cl.[EmpID] 
			   WHERE ((cl.[EmpID] = ''' + @nvcEmpID + '''  AND cl.[StatusID] in (3,4)) 
			OR (ISNULL([cl].[strReportCode], '' '') NOT LIKE ''LCS%'' AND cl.ReassignCount= 0 AND eh.Sup_ID = ''' + @nvcEmpID + ''' AND cl.[StatusID] in (3,5,6,8,10) 
			  OR (ISNULL([cl].[strReportCode], '' '') NOT LIKE ''LCS%'' AND cl.ReassignCount= 0 AND  eh.Mgr_ID = '''+  @nvcEmpID + ''' AND cl.[StatusID] in (5,7,9))
			  OR ([cl].[strReportCode] LIKE ''LCS%'' AND [ReassignCount] = 0 AND cl.[MgrID] = ''' + @nvcEmpID + ''' AND [cl].[StatusID]= 5) )
			  OR (cl.ReassignCount <> 0 AND cl.ReassignedToID = ''' +  @nvcEmpID + ''' AND  cl.[StatusID] in (5,7,9))  
              ) AND ''' + @nvcEmpID + ''' <> ''999999''
			  AND cl.[SourceID] NOT IN (235, 236)
			  GROUP BY [cl].[StatusID])
			  
			   SELECT s.Status, COALESCE(cl.LogCount,0) AS LogCount
			   FROM SelectedStatus s left join SelectedLogs cl
			   ON s.statusid = cl.StatusID '
	
EXEC (@nvcSQL);
--PRINT @nvcSQL
-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
If @@ERROR <> 0 GoTo ErrorHandler;

SET NOCOUNT OFF;

Return(0);
  
ErrorHandler:
    Return(@@ERROR);
	    
END --sp_Dashboard_Summary_Count_ByStatus
GO


