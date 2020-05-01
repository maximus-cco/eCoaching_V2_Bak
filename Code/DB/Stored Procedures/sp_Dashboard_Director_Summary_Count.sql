/*
sp_Dashboard_Director_Summary_Count(02).sql
Last Modified Date: 05/01/2020
Last Modified By: Susmitha Palacherla

Version 02: Modified to support additional statuses for warnings. TFS 17102 - 5/1/2020 
Version 01: Document Initial Revision created during My dashboard redesign.  TFS 7137 - 05/20/2018

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Dashboard_Director_Summary_Count' 
)
   DROP PROCEDURE [EC].[sp_Dashboard_Director_Summary_Count]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	05/22/2018
--  Description: Retrieves Count of Pending, MTD Completed and Active Warning Logs to be displayed
--  on the Director Dashboard.
--  Initial Revision created during MyDashboard redesign.  TFS 7137 - 05/22/2018
--  Modified to support additional statuses for warnings. TFS 17102 - 5/1/2020 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Dashboard_Director_Summary_Count] 
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

SET @nvcSQL = '
	  --SELECT si.siteid, si.City, 
			--   COALESCE(b.PendingCount, 0 ) PendingCount,
			--   COALESCE(c.CompletedCount, 0 )CompletedCount,
			--   COALESCE(d.WarningCount, 0 ) WarningCount
	  -- FROM (SELECT DISTINCT City FROM EC.DIM_Site
	  -- WHERE isActive = 1 
	  -- AND SiteID  <> -1) si

	  	  SELECT si.siteid, si.City, 
				 COALESCE(b.PendingCount, 0 ) PendingCount,
				 COALESCE(c.CompletedCount, 0 )CompletedCount,
				 COALESCE(d.WarningCount, 0 ) WarningCount
	    FROM 
		(SELECT DISTINCT si.siteid, eh.Emp_Site City
		FROM EC.Employee_Hierarchy eh JOIN EC.DIM_Site si
        ON eh.Emp_Site = si.City
        WHERE (eh.SrMgrLvl1_ID = '''+ @nvcEmpID + ''' OR eh.SrMgrLvl2_ID = '''+ @nvcEmpID + ''' OR eh.SrMgrLvl3_ID = '''+ @nvcEmpID + ''')) si

	    LEFT JOIN
	    (
	 		   SELECT site.City, Count(CoachingID) AS PendingCount
			   FROM EC.Coaching_Log cl WITH (NOLOCK) JOIN EC.DIM_Site site
			   ON site.SiteID = cl.SiteID  JOIN EC.Employee_Hierarchy eh
			   ON cl.EmpID = eh.Emp_ID 	
			   WHERE convert(varchar(8), [cl].[SubmittedDate], 112) >= ''' + @strSDate + '''
			   AND convert(varchar(8), [cl].[SubmittedDate], 112) <= ''' + @strEDate + '''
			   AND (eh.SrMgrLvl1_ID = '''+ @nvcEmpID + ''' OR eh.SrMgrLvl2_ID = '''+ @nvcEmpID + ''' OR eh.SrMgrLvl3_ID = '''+ @nvcEmpID + ''')
			   AND cl.StatusID NOT IN (1,2)
			   AND NOT (cl.siteID = -1 OR cl.StatusID = -1)
			   GROUP BY site.City) b ON si.City = b.City
       LEFT JOIN
	   (
		   SELECT site.City, Count(CoachingID) AS CompletedCount
		   FROM EC.Coaching_Log cl WITH (NOLOCK) JOIN EC.DIM_Site site
		   ON site.SiteID = cl.SiteID JOIN EC.Employee_Hierarchy eh
           ON cl.EmpID = eh.Emp_ID
		   WHERE convert(varchar(8), [cl].[SubmittedDate], 112) >= ''' + @strSDate + '''
		   AND convert(varchar(8), [cl].[SubmittedDate], 112) <= ''' + @strEDate + '''
		   AND (eh.SrMgrLvl1_ID = '''+ @nvcEmpID + ''' OR eh.SrMgrLvl2_ID = '''+ @nvcEmpID + '''OR eh.SrMgrLvl3_ID = '''+ @nvcEmpID + ''')
		   AND cl.StatusID = 1
		   AND NOT (cl.siteID = -1 OR cl.StatusID = -1)
		   GROUP BY site.City) c ON si.City = c.City
      LEFT JOIN
	  (
	  	     SELECT site.City, Count(WarningID) AS WarningCount
			     FROM  EC.Warning_Log wl WITH (NOLOCK) JOIN EC.DIM_Site site
				 ON site.SiteID = wl.SiteID JOIN EC.Employee_Hierarchy eh
                 ON wl.EmpID = eh.Emp_ID
		         WHERE convert(varchar(8), [wl].[SubmittedDate], 112) >= ''' + @strSDate + '''
			     AND convert(varchar(8), [wl].[SubmittedDate], 112) <= ''' + @strEDate + '''
				 AND (eh.SrMgrLvl1_ID = '''+ @nvcEmpID + ''' OR eh.SrMgrLvl2_ID = '''+ @nvcEmpID + '''OR eh.SrMgrLvl3_ID = '''+ @nvcEmpID + ''')
				 AND wl.siteID <> -1 
				 AND wl.StatusID <> 2
				 AND wl.Active = 1
				 GROUP BY site.City) d ON si.City = d.City
     ORDER BY si.City'

		
EXEC (@nvcSQL)
--PRINT @nvcSQL
 
	    
If @@ERROR <> 0 GoTo ErrorHandler;

SET NOCOUNT OFF;

Return(0);
  
ErrorHandler:
Return(@@ERROR);

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];
	    
END --sp_Dashboard_Director_Summary_Count
GO



