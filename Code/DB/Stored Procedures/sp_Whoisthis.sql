/*
sp_Whoisthis(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Whoisthis' 
)
   DROP PROCEDURE [EC].[sp_Whoisthis]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	<7/23/13>
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 06/12/2015
-- Updated per SCR 14966 to use the Employee ID as input parameter instead of Emp Lan ID 
-- and added SupID and MgrID to the return.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Whoisthis] 


(
 @strUserIDin	Nvarchar(30)
)
AS

BEGIN
DECLARE	

@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT [Sup_LanID] + ''$'' + [Sup_ID]+ 
		 	  ''$'' + [Mgr_LanID] + ''$'' + [Mgr_ID] Flow
              FROM [EC].[Employee_Hierarchy]
              WHERE [Emp_ID] = '''+ @strUserIDin+''''

		
EXEC (@nvcSQL)	


END






GO

