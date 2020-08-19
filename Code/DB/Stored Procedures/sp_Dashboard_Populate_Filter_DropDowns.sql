/*
sp_Dashboard_Populate_Filter_DropDowns(02).sql
Last Modified Date: 08/18/2020
Last Modified By: Susmitha Palacherla

Version 02: Removed references to SrMgr Role. TFS 18062 - 08/18/2020
Version 01: Document Initial Revision created during My dashboard redesign.  TFS 7137 - 05/28/2018

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Dashboard_Populate_Filter_DropDowns' 
)
   DROP PROCEDURE [EC].[sp_Dashboard_Populate_Filter_DropDowns]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	6/12/2018
--	Description: *	This procedure calls the appropriate sps 
--  to populate the filter drop downs given the logged in user ID and type of drop down.
--  Created during Myt dashboard move to new architecture - TFS 7137 - 6/12/2018
--  Removed references to SrMgr Role. TFS 18062 - 08/18/2020
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Dashboard_Populate_Filter_DropDowns] 
@nvcUserIdin nvarchar(10),
@nvcWhichDropDown nvarchar(20)
AS


BEGIN
DECLARE	
@nvcEmpRole nvarchar(40),
@nvcSQL nvarchar(max)




OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert] 
SET @nvcEmpRole = [EC].[fn_strGetUserRole](@nvcUserIdin)
--PRINT @nvcEmpRole

IF @nvcEmpRole = 'Supervisor'
BEGIN

		IF @nvcWhichDropDown = N'Manager'
		BEGIN 
		EXEC [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGR] @nvcUserIdin
		END

		IF @nvcWhichDropDown = N'Supervisor'
		BEGIN 
		EXEC [EC].[sp_SelectFrom_Coaching_LogSupDistinctSUP] @nvcUserIdin
		END

		IF @nvcWhichDropDown = N'Employee'
		BEGIN 
		EXEC [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSR] @nvcUserIdin 
		END

END

IF @nvcEmpRole = 'Manager'
BEGIN

		IF @nvcWhichDropDown = N'Manager'
		BEGIN 
		EXEC [EC].[sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted] @nvcUserIdin
		END

		IF @nvcWhichDropDown = N'Supervisor'
		BEGIN 
		EXEC [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted] @nvcUserIdin
		END

		IF @nvcWhichDropDown = N'Employee'
		BEGIN 
		EXEC [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRSubmitted] @nvcUserIdin
		END

END

IF @nvcEmpRole NOT IN ('Supervisor', 'Manager')
BEGIN

		IF @nvcWhichDropDown = N'Manager'
		BEGIN 
		EXEC [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingMGRSubmitted] @nvcUserIdin
		END

		IF @nvcWhichDropDown = N'Supervisor'
		BEGIN 
		EXEC [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingSUPSubmitted] @nvcUserIdin
		END

		IF @nvcWhichDropDown = N'Employee'
		BEGIN 
		EXEC [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingCSRSubmitted] @nvcUserIdin
		END

END

END --sp_Dashboard_Populate_Filter_DropDowns

GO



