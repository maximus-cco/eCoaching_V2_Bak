IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_Details' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_Details]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure calls the procedure(s) for Coaching or Warning details based on the 
--  user selection in the Sr mgr dashboard. 
--  Last Updated By: Susmitha Palacherla
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_Details] 
@strEMPSRMGRin nvarchar(30),
@bitisCoaching bit,
@strStatus nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@PageSize int,
@startRowIndex int, 
@sortBy nvarchar(100),
@sortASC nvarchar(1),
@searchBy nvarchar(30)
AS

BEGIN

IF @bitisCoaching = 1
  EXEC [EC].[sp_SelectFrom_SRMGR_EmployeeCoaching]  @strEMPSRMGRin ,@strStatus , @strSDatein, @strEDatein, @PageSize, @startRowIndex, @sortBy, @sortASC, @searchBy;
ELSE
  EXEC [EC].[sp_SelectFrom_SRMGR_EmployeeWarning] @strEMPSRMGRin, @strSDatein, @strEDatein, @PageSize, @startRowIndex, @sortBy, @sortASC, @searchBy;

END --sp_SelectFrom_SRMGR_Details
GO