/*
fn_strCheckIf_HRUser(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strCheckIf_HRUser' 
)
   DROP FUNCTION [EC].[fn_strCheckIf_HRUser]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		Susmitha Palacherla
-- Create date:  6/7/2016
-- Description:	Given an Employee ID returns whether the user is a HR user.
-- Last Modified By:
-- Revision History:
--  Created per TFS 2332- Separate solution for HR access
-- =============================================

CREATE FUNCTION [EC].[fn_strCheckIf_HRUser] 
(
	@strEmpID nvarchar(10) 
)
RETURNS nvarchar(10)
AS
BEGIN
	DECLARE 
	@strEmpJobCode nvarchar(20),
	@nvcActive nvarchar(1),
	@strHRUser nvarchar(10)
	
SET @strEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @strEmpID)

SET @nvcActive = (SELECT Active From EC.Employee_Hierarchy
WHERE Emp_ID = @strEmpID)

IF @nvcActive = 'A'	AND @strEmpJobCode LIKE 'WH%'

 SET @strHRUser = 'YES'
  ELSE
 SET    @strHRUser = N'NO'
  
  RETURN   @strHRUser
  
END --fn_strCheckIf_HRUser


GO

