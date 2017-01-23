/*
sp_AT_Select_Status_By_Module(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Status_By_Module' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Status_By_Module]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/21/2016
--	Description: *	This procedure returns the list of Status(es) for a selected Module 
--  Last Modified By: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/27/12016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Status_By_Module] 
@intModuleIdin INT

AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max)




SET @nvcSQL = 'SELECT StatusId, Status
			   FROM [EC].[AT_Reassign_Status_For_Module]
			   WHERE [ModuleID]= '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
			   AND [isActive]=1'

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_AT_Select_Status_By_Module


GO

