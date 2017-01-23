/*
sp_CheckIf_HRUser(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_CheckIf_HRUser' 
)
   DROP PROCEDURE [EC].[sp_CheckIf_HRUser]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/6/2016
--	Description: *	This procedure takes the lan ID of the HR user and looks up the job code.
--  If Job code exists in the HR access table and HistDashboard = 1 then returns 'YES' else 'NO'
--  Last Modified By: 
--  Last Modified Date: 
--  Created to replace hardcoding in UI code with table lookup. TFS 2232. - 4/6/2016 
 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_CheckIf_HRUser] 
@nvcEmpLanIDin nvarchar(30)

AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@nvcEmpID nvarchar(10),
	@nvcEmpJobCode nvarchar(30),
	@nvcActive nvarchar(1),
		@dtmDate datetime

SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanIDin,@dtmDate)

SET @nvcSQL = 'SELECT  ISNULL(EC.fn_strCheckIf_HRUser('''+@nvcEmpID+'''),''NO'') AS isHRUser'


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_CheckIf_HRUser






GO

