/*
sp_Search_For_Dashboards_Count(02).sql
Last Modified Date: 09/17/2019
Last Modified By: Susmitha Palacherla

Version 02: Updated to display MyFollowup for CSRs. TFS 15621 - 09/17/2019
Version 01: Document Initial Revision created during hist dashboard redesign.  TFS 7138 - 05/08/2018

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Search_For_Dashboards_Count' 
)
   DROP PROCEDURE [EC].[sp_Search_For_Dashboards_Count]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/24/2018
--	Description: *	This procedure returns the total count of records that will be returned
--  for the selected criteria for the requested dashboard page.
--  Created during Hist dashboard move to new architecture - TFS 7138 - 04/24/2018
-- Updated to display MyFollowup for CSRs. TFS 15621 - 09/17/2019
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Search_For_Dashboards_Count] 

@nvcUserIdin nvarchar(10),
@intSourceIdin int = NULL,
@intSiteIdin int = NULL,
@nvcEmpIdin nvarchar(10),
@nvcSupIdin nvarchar(10) = NULL,
@nvcMgrIdin nvarchar(10) = NULL,
@nvcSubmitterIdin nvarchar(10) = NULL,
@strSDatein datetime = NULL,
@strEDatein datetime = NULL,
@intStatusIdin int = NULL, 
@nvcValue  nvarchar(30) = NULL,
@nvcSearch nvarchar(50) = NULL,
@intEmpActive int = NULL,
@nvcWhichDashboard nvarchar(100)
AS


BEGIN

IF @nvcWhichDashboard = N'Historical'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_Historical_Count] @nvcUserIdin, @intSourceIdin, @intSiteIdin, @nvcEmpIdin, @nvcSupIdin,
@nvcMgrIdin, @nvcSubmitterIdin, @strSDatein, @strEDatein, @intStatusIdin, @nvcValue, @nvcSearch, @intEmpActive
END

IF @nvcWhichDashboard = N'MyPending'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyPending_Count] @nvcUserIdin, @nvcEmpIdin, @nvcSupIdin
END

IF @nvcWhichDashboard = N'MyFollowup'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyFollowup_Count] @nvcUserIdin
END


IF @nvcWhichDashboard = N'MyCompleted'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyCompleted_Count] @nvcUserIdin, @strSDatein, @strEDatein
END


IF @nvcWhichDashboard = N'MySubmitted'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_Count] @nvcUserIdin, @intStatusIdin, @nvcEmpIdin, @nvcSupIdin,
@nvcMgrIdin, @strSDatein, @strEDatein
END

IF @nvcWhichDashboard = N'MyTeamCompleted'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyTeamCompleted_Count] @nvcUserIdin, @intSourceIdin, @nvcEmpIdin,  @nvcSupIdin,  @strSDatein, @strEDatein
END

IF @nvcWhichDashboard = N'MyTeamPending'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyTeamPending_Count] @nvcUserIdin, @intSourceIdin, @nvcEmpIdin,  @nvcSupIdin
END

IF @nvcWhichDashboard = N'MyTeamWarning'
BEGIN 
EXEC [EC].[sp_SelectFrom_Warning_Log_MyTeamWarning_Count] @nvcUserIdin, @intStatusIdin, @strSDatein, @strEDatein
END

IF @nvcWhichDashboard = N'MySiteCompleted'
BEGIN 
EXEC [EC].[sp_Dashboard_Director_Site_Completed_Count] @intSiteIdin, @nvcUserIdin,  @intSourceIdin, @nvcEmpIdin,  @nvcSupIdin,  @nvcMgrIdin, @strSDatein, @strEDatein
END

IF @nvcWhichDashboard = N'MySitePending'
BEGIN 
EXEC [EC].[sp_Dashboard_Director_Site_Pending_Count] @intSiteIdin, @nvcUserIdin,  @strSDatein, @strEDatein, @intSourceIdin, @nvcEmpIdin,  @nvcSupIdin, @nvcMgrIdin
END

IF @nvcWhichDashboard = N'MySiteWarning'
BEGIN 
EXEC [EC].[sp_Dashboard_Director_Site_Warning_Count] @intSiteIdin, @nvcUserIdin, @strSDatein, @strEDatein
END

END --sp_Search_For_Dashboards_Count
GO


