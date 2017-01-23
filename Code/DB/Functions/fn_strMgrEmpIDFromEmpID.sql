/*
fn_strMgrEmpIDFromEmpID(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strMgrEmpIDFromEmpID' 
)
   DROP FUNCTION [EC].[fn_strMgrEmpIDFromEmpID]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 07/23/2013
-- Description:	Given an Employee ID returns the Manager Employee ID.
-- Last Modified by: Susmitha Palacherla
-- Last update: 12/19/2013
-- Updated per SCR 11855 to use supervisors supervisor as Manager employee id.
-- =============================================
CREATE FUNCTION [EC].[fn_strMgrEmpIDFromEmpID] 
(
	@strEmpID nvarchar(10) 
)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE 
	  @strSupEmpID nvarchar(10),
	  @strMgrEmpID nvarchar(10)

  SELECT   @strSupEmpID = [Sup_Emp_ID]
  FROM [EC].[Employee_Hierarchy_Stage]
  WHERE [Emp_ID] = @strEmpID

  
  SELECT   @strMgrEmpID =[Sup_Emp_ID]
  FROM [EC].[Employee_Hierarchy_Stage]
  WHERE [Emp_ID] = @strSupEmpID 
  
  IF    @strMgrEmpID IS NULL 
  SET   @strMgrEmpID= N'999999'
  
  RETURN  @strMgrEmpID
  
END --fn_strMgrEmpIDFromEmpID

GO

