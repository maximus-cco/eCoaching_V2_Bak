/*
sp_AT_Select_Employees_Inactivation_Reactivation(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Employees_Inactivation_Reactivation' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Employees_Inactivation_Reactivation]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/21/2016
--	Description: *	This procedure calls the Coaching or Warning Inactivation 
--  Reactivation procedure based on the strType passed in.
--  Last Modified By: 
--  Last Modified date: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/20/12016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Employees_Inactivation_Reactivation] 

@strRequesterLanId nvarchar(30),@strTypein nvarchar(10), @strActionin nvarchar(10), @intModulein int
AS


BEGIN

IF @strTypein = N'Coaching'
BEGIN 
EXEC [EC].[sp_AT_Select_Employees_Coaching_Inactivation_Reactivation] @strRequesterLanId ,@strActionin , @intModulein 
END

IF @strTypein = N'Warning'
BEGIN 
EXEC [EC].[sp_AT_Select_Employees_Warning_Inactivation_Reactivation]@strRequesterLanId ,@strActionin , @intModulein 
END


END --sp_AT_Select_Employees_Inactivation_Reactivation

GO

