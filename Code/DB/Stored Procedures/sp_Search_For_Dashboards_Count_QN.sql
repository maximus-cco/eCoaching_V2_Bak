SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/3/2021
--	Description: *	This procedure returns the total count QN Coaching records that will be returned
--  for the selected criteria for the requested dashboard page.
--  Initial Revision. Quality Now workflow enhancement - TFS 22187 - 8/3/2021
--	=====================================================================

CREATE OR ALTER PROCEDURE [EC].[sp_Search_For_Dashboards_Count_QN] 

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

IF @nvcWhichDashboard = N'MyPendingReview'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyPending_Count_QN] @nvcUserIdin
END

IF @nvcWhichDashboard = N'MyPendingFollowupReview'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyPending_FollowupPrep_Count_QN] @nvcUserIdin
END

IF @nvcWhichDashboard = N'MyPendingFollowupCoach'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyPending_FollowupCoach_Count_QN] @nvcUserIdin
END

IF @nvcWhichDashboard = N'MyTeamPending'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyTeamPending_Count_QN] @nvcUserIdin, @intStatusIdin, @nvcEmpIdin,  @nvcSupIdin
END


IF @nvcWhichDashboard = N'MyTeamCompleted'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyTeamCompleted_Count_QN] @nvcUserIdin, @nvcEmpIdin,  @nvcSupIdin,  @strSDatein, @strEDatein
END


IF @nvcWhichDashboard = N'MyCompleted'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyCompleted_Count_QN] @nvcUserIdin, @strSDatein, @strEDatein
END

IF @nvcWhichDashboard = N'MySubmitted'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_Count_QN] @nvcUserIdin, @intStatusIdin, @nvcEmpIdin, @nvcSupIdin,
@nvcMgrIdin, @strSDatein, @strEDatein
END


END --sp_Search_For_Dashboards_Count_QN
GO

