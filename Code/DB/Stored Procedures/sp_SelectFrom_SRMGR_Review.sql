/*
sp_SelectFrom_SRMGR_Review(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_Review' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_Review]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure calls Procedure(s) to dosplay the review details for 
--  the Coaching or Warning log selected by the user.
--  Last Updated By: 
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_Review] @intFormIDin BIGINT, @bitisCoaching bit
AS

BEGIN


IF @bitisCoaching = 1
BEGIN 
EXEC  [EC].[sp_SelectFrom_SRMGR_EmployeeCoaching_Review]  @intFormIDin 
END

IF @bitisCoaching = 0
BEGIN 
EXEC  [EC].[sp_SelectFrom_SRMGR_EmployeeWarning_Review] @intFormIDin 
END

	    
END --sp_SelectFrom_SRMGR_Review


GO

