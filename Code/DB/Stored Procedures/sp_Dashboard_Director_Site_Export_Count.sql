/*
sp_Dashboard_Director_Site_Export_Count(01).sql
Last Modified Date: 08/14/2018
Last Modified By: Susmitha Palacherla


Version 01: Initial Revision. - TFS 11743 - 08/14/2018
*/


IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_Dashboard_Director_Site_Export_Count' 
)
   DROP PROCEDURE [EC].[sp_Dashboard_Director_Site_Export_Count]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/14/2018
--	Description: *	This procedure selects the count of e-Coaching records for export
--  in Director Dashboard.
--  Last Modified Date:
--  Last Updated By: 
--  Initial Revision. - TFS 11743 - 08/14/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Dashboard_Director_Site_Export_Count] 
@nvcUserIdin nvarchar(10),
@intSiteIdin int,
@strSDatein datetime,
@strEDatein datetime,
@nvcStatus nvarchar(50)
AS


BEGIN


SET NOCOUNT ON

DECLARE	
@strSDate nvarchar(10),
@strEDate nvarchar(10),
@nvcSQL nvarchar(max),
@where nvarchar(1000)


-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @strSDate = convert(varchar(8), @strSDatein,112)
SET @strEDate = convert(varchar(8), @strEDatein,112)

SET @where = ''

IF @nvcStatus  =  N'MySitePending' 
BEGIN
SET @where = @where +  ' AND [cl].[StatusID] NOT IN (-1,1,2) '
END

IF @nvcStatus  =   N'MySiteCompleted'
BEGIN
SET @where = @where +  ' AND [cl].[StatusID] = 1 '
END


SET @nvcSQL = 'SELECT Count([cl].[CoachingID])
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
JOIN [EC].[Employee_Hierarchy] eh WITH (NOLOCK) ON eh.[EMP_ID] = veh.[EMP_ID]
JOIN [EC].[Coaching_Log] cl WITH (NOLOCK)  ON cl.EmpID = eh.Emp_ID 
LEFT JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON cl.SubmitterID = vehs.EMP_ID 
JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID 
JOIN [EC].[DIM_Site] si ON cl.SiteID = si.SiteID 
JOIN [EC].[Coaching_Log_Reason]clr WITH (NOLOCK) ON cl.CoachingID = clr.CoachingID 
JOIN [EC].[DIM_Coaching_Reason]dcr ON clr.CoachingReasonID = dcr.CoachingReasonID
JOIN [EC].[DIM_Sub_Coaching_Reason]dscr ON clr.SubCoachingReasonID = dscr.SubCoachingReasonID 
WHERE convert(varchar(8), [SubmittedDate], 112) >= ''' + @strSDate + '''
AND convert(varchar(8), [SubmittedDate], 112) <= ''' + @strEDate + ''' ' +
@where + ' ' + '
AND cl.SiteID = '''+CONVERT(NVARCHAR,@intSiteIdin)+'''
AND (eh.SrMgrLvl1_ID = '''+ @nvcUserIdin +''' OR eh.SrMgrLvl2_ID = '''+ @nvcUserIdin +''' OR eh.SrMgrLvl3_ID = '''+ @nvcUserIdin +''') '
 


EXEC (@nvcSQL)	
--PRINT @nvcSQL

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
END -- sp_Dashboard_Director_Site_Export_Count

GO



