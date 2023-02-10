SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/3/2021
--	Description: *	This procedure returns the QN Coaching records that will be returned
--  for the selected criteria for the requested dashboard page.
--  Initial Revision. Quality Now workflow enhancement - TFS 22187 - 8/3/2021
--  Updated to support QN Supervisor evaluation changes. TFS 26002 - 02/02/2023
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Search_For_Dashboards_Details_QN] 

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
DECLARE	
@nvcEmpRole nvarchar(40);

SET @nvcEmpRole = (SELECT [EC].[fn_strGetUserRole](@nvcUserIdin));

IF @nvcWhichDashboard = N'MyPendingReview' and @nvcEmpRole <> 'Supervisor'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyPending_QN] @nvcUserIdin, @PageSize, @startRowIndex, @sortBy, @sortASC
END

IF @nvcWhichDashboard = N'MyPendingReview' and @nvcEmpRole = 'Supervisor'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyPending_QNS] @nvcUserIdin, @intSourceIdin, @PageSize, @startRowIndex, @sortBy, @sortASC
END

IF @nvcWhichDashboard = N'MyPendingFollowupReview'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyPending_FollowupPrep_QN] @nvcUserIdin, @PageSize, @startRowIndex, @sortBy, @sortASC
END

IF @nvcWhichDashboard = N'MyPendingFollowupCoach'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyPending_FollowupCoach_QN] @nvcUserIdin, @PageSize, @startRowIndex, @sortBy, @sortASC
END

IF @nvcWhichDashboard = N'MyTeamPending' 
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyTeamPending_QN] @nvcUserIdin, @intStatusIdin, @nvcEmpIdin,  @nvcSupIdin, @PageSize,@startRowIndex, @sortBy, @sortASC
END

IF @nvcWhichDashboard = N'MyTeamCompleted'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyTeamCompleted_QN] @nvcUserIdin,  @nvcEmpIdin,  @nvcSupIdin,  @strSDatein, @strEDatein, @PageSize,@startRowIndex, @sortBy, @sortASC
END

IF @nvcWhichDashboard = N'MyCompleted'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MyCompleted_QN] @nvcUserIdin, @strSDatein, @strEDatein, @PageSize,@startRowIndex, @sortBy, @sortASC
END

IF @nvcWhichDashboard =  N'MySubmitted'
BEGIN 
EXEC [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_QN] @nvcUserIdin, @intStatusIdin, @nvcEmpIdin, @nvcSupIdin,
@nvcMgrIdin, @strSDatein, @strEDatein,@PageSize,@startRowIndex, @sortBy, @sortASC
END

END --sp_Search_For_Dashboards_Details_QN

GO


