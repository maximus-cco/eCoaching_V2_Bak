/*
sp_SelectFrom_Historical_Dashboard_ACL(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Historical_Dashboard_ACL' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Historical_Dashboard_ACL]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	09/2012
--	Last Update:	<>
--	Description: *	This procedure selects the user records from the Historical_Dashboard_ACL table
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Historical_Dashboard_ACL] 

(
 @nvcRole Nvarchar(30)


)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max)


SET @nvcSQL = 'SELECT [Row_ID],[User_LanID],[User_Name],[Role]
FROM [EC].[Historical_Dashboard_ACL]
where (Role = '''+@nvcRole+''' AND End_Date > getdate())
Order by [User_LanID]'
		
EXEC (@nvcSQL)		
	    
END -- [sp_SelectFrom_Historical_Dashboard_ACL] 

GO

