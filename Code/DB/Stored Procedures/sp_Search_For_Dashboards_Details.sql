/*
sp_Search_For_Dashboards_Details(01).sql
Last Modified Date: 05/08/2018
Last Modified By: Susmitha Palacherla


Version 01: Document Initial Revision created during hist dashboard redesign.  TFS 7138 - 05/08/2018

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Search_For_Dashboards_Details' 
)
   DROP PROCEDURE [EC].[sp_Search_For_Dashboards_Details]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/24/2018
--	Description: *	This procedure returns the Coaching or Warning records that will be returned
--  for the selected criteria for the requested dashboard page.
--  Created during Hist dashboard move to new architecture - TFS 7138 - 04/24/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Search_For_Dashboards_Details] 

@nvcUserIdin nvarchar(10),
@intSourceIdin int = NULL,
@intSiteIdin int = NULL,
@nvcEmpIdin nvarchar(10) = NULL,
@nvcSupIdin nvarchar(10) = NULL,
@nvcMgrIdin nvarchar(10) = NULL,
@nvcSubmitterIdin nvarchar(10) = NULL,
@strSDatein datetime = NULL,
@strEDatein datetime = NULL,
@intStatusIdin int = NULL, 
@nvcValue  nvarchar(30) = NULL,
@nvcSearch nvarchar(50) = NULL,
@intEmpActive int = NULL,
@PageSize int = NULL,
@startRowIndex int = NULL, 
@sortBy nvarchar(100) = NULL,
@sortASC nvarchar(1) = NULL,
@nvcWhichDashboard nvarchar(100)
AS


BEGIN

IF @nvcWhichDashboard = N'Historical'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_Historical] @nvcUserIdin, @intSourceIdin, @intSiteIdin, @nvcEmpIdin, @nvcSupIdin,
@nvcMgrIdin, @nvcSubmitterIdin, @strSDatein, @strEDatein, @intStatusIdin, @nvcValue, @nvcSearch, @intEmpActive, 
@PageSize,@startRowIndex, @sortBy, @sortASC
END

IF @nvcWhichDashboard = N'MyPending'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyPending] @nvcUserIdin, @nvcEmpIdin, @nvcSupIdin,
 @PageSize, @startRowIndex, @sortBy, @sortASC
END

IF @nvcWhichDashboard = N'MyCompleted'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyCompleted] @nvcUserIdin, @strSDatein, @strEDatein, @PageSize,@startRowIndex, @sortBy, @sortASC
END

IF @nvcWhichDashboard = N'MySubmitted'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MySubmitted] @nvcUserIdin, @intStatusIdin, @nvcEmpIdin, @nvcSupIdin,
@nvcMgrIdin, @strSDatein, @strEDatein,@PageSize,@startRowIndex, @sortBy, @sortASC
END

IF @nvcWhichDashboard = N'MyTeamCompleted'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyTeamCompleted] @nvcUserIdin, @intSourceIdin, @nvcEmpIdin,  @nvcSupIdin,  @strSDatein, @strEDatein, @PageSize,@startRowIndex, @sortBy, @sortASC
END

IF @nvcWhichDashboard = N'MyTeamPending'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyTeamPending] @nvcUserIdin, @intSourceIdin, @nvcEmpIdin,  @nvcSupIdin, @PageSize,@startRowIndex, @sortBy, @sortASC
END

IF @nvcWhichDashboard = N'MyTeamWarning'
BEGIN 
EXEC [EC].[sp_SelectFrom_Warning_Log_MyTeamWarning] @nvcUserIdin, @intStatusIdin, @strSDatein, @strEDatein, @PageSize, @startRowIndex, @sortBy, @sortASC
END

IF @nvcWhichDashboard = N'MySiteCompleted'
BEGIN 
EXEC [EC].[sp_Dashboard_Director_Site_Completed] @intSiteIdin, @nvcUserIdin, @intSourceIdin, @nvcEmpIdin,  @nvcSupIdin,  @nvcMgrIdin, @strSDatein, @strEDatein, @PageSize,@startRowIndex, @sortBy, @sortASC
END

IF @nvcWhichDashboard = N'MySitePending'
BEGIN 
EXEC [EC].[sp_Dashboard_Director_Site_Pending] @intSiteIdin, @nvcUserIdin, @strSDatein, @strEDatein, @intSourceIdin, @nvcEmpIdin,  @nvcSupIdin, @nvcMgrIdin, @PageSize,@startRowIndex, @sortBy, @sortASC
END

IF @nvcWhichDashboard = N'MySiteWarning'
BEGIN 
EXEC [EC].[sp_Dashboard_Director_Site_Warning] @intSiteIdin, @nvcUserIdin, @strSDatein, @strEDatein, @PageSize, @startRowIndex, @sortBy, @sortASC
END




END --sp_Search_For_Dashboards_Details

GO


