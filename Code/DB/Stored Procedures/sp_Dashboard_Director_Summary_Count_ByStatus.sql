SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	05/22/2018
--  Description: Retrieves Count of Logs by Status to be displayed
--  on the Director Dashboard.
--  Initial Revision created during MyDashboard redesign.  TFS 7137 - 05/22/2018
--  Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
--  Modified to support additional statuses for warnings. TFS 17102 - 5/1/2020 
--  Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Dashboard_Director_Summary_Count_ByStatus] 
@nvcEmpID nvarchar(10),
@strSDatein datetime,
@strEDatein datetime

AS

BEGIN
DECLARE	
@nvcEmpRole nvarchar(40),
@strSDate nvarchar(10),
@strEDate nvarchar(10),
@nvcSQL nvarchar(max)

SET @strSDate = convert(varchar(8), @strSDatein,112)
SET @strEDate = convert(varchar(8), @strEDatein,112)
 
 -- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

SET @nvcEmpRole = [EC].[fn_strGetUserRole](@nvcEmpID)

IF @nvcEmpRole <> 'Director' RETURN 1

SET @nvcSQL = ';WITH IncludeStatus AS
                 (SELECT DISTINCT  StatusID, Status
				 FROM EC.DIM_Status
				 WHERE statusID NOT IN (-1,2)
				 ),

                  Counts AS
				 (SELECT si.City, st.Status AS Status, Count(CoachingID) AS LogCount
			     FROM EC.DIM_Status st LEFT JOIN EC.Coaching_Log cl WITH (NOLOCK) 
				 ON st.StatusID = cl.StatusID JOIN EC.DIM_Site si 
				 ON si.SiteID = cl.SiteID JOIN EC.Employee_Hierarchy eh
			     ON cl.EmpID = eh.Emp_ID
			     WHERE convert(varchar(8), [cl].[SubmittedDate], 112) >= ''' + @strSDate + '''
			     AND convert(varchar(8), [cl].[SubmittedDate], 112) <= ''' + @strEDate + '''
                 AND(eh.SrMgrLvl1_ID = '''+ @nvcEmpID + ''' OR eh.SrMgrLvl2_ID = '''+ @nvcEmpID + '''OR eh.SrMgrLvl3_ID = '''+ @nvcEmpID + ''')
				 AND cl.StatusID not in (1,2)
				 AND NOT (cl.siteID = -1 OR cl.StatusID = -1)
				 GROUP BY si.City, st.Status
				 			               
			     UNION

				 SELECT si.City, st.Status AS Status, Count(WarningID) AS LogCount
			     FROM EC.DIM_Site si JOIN EC.Warning_Log wl WITH (NOLOCK) 
				 ON si.SiteID = wl.SiteID JOIN EC.DIM_STATUS st
				 ON wl.StatusID = st.StatusID JOIN EC.Employee_Hierarchy eh
			     ON wl.EmpID = eh.Emp_ID
				 WHERE convert(varchar(8), [wl].[SubmittedDate], 112) >= ''' + @strSDate + '''
			     AND convert(varchar(8), [wl].[SubmittedDate], 112) <= ''' + @strEDate + '''
                 AND (eh.SrMgrLvl1_ID = '''+ @nvcEmpID + ''' OR eh.SrMgrLvl2_ID = '''+ @nvcEmpID + '''OR eh.SrMgrLvl3_ID = '''+ @nvcEmpID + ''')
				 AND wl.StatusID <> 2
				 AND wl.siteID <> -1 
				 AND wl.Active = 1
				 GROUP BY si.City, st.Status)


				 SELECT DISTINCT site.City AS Site, site.isSub,
				 CASE WHEN st.status = ''Completed'' THEN ''Active Warnings'' ELSE st.status END AS CountType, COALESCE(wc.LogCount,0) AS LogCount
				 FROM 
				 (SELECT DISTINCT eh.Emp_Site City, si.isSub
		         FROM EC.Employee_Hierarchy eh JOIN EC.DIM_Site si
                 ON eh.Emp_Site = si.City
		         WHERE (eh.SrMgrLvl1_ID = '''+ @nvcEmpID + ''' OR eh.SrMgrLvl2_ID = '''+ @nvcEmpID + ''' OR eh.SrMgrLvl3_ID = '''+ @nvcEmpID + '''))  site CROSS JOIN IncludeStatus st LEFT JOIN Counts wc
				 ON site.City = wc.City  
				 AND st.Status = wc.status 
				 ORDER BY site.City'

		
EXEC (@nvcSQL)
	--PRINT @nvcSQL

If @@ERROR <> 0 GoTo ErrorHandler;

SET NOCOUNT OFF;

Return(0);
  
ErrorHandler:
    Return(@@ERROR);

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];
	    
END --sp_Dashboard_Director_Summary_Count_ByStatus


GO


