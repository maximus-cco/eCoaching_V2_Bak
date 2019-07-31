/*
sp_ShortCalls_Get_BehaviorList(01A).sql
Last Modified Date:  07/31/2019
Last Modified By: Susmitha Palacherla


Version 01A: Updated from UAT Feedback - TFS 14108 - 07/31/2019
Version 01: Document Initial Revision. New logic for handling Short calls - TFS 14108 - 07/05/2019

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_ShortCalls_Get_BehaviorList' 
)
   DROP PROCEDURE [EC].[sp_ShortCalls_Get_BehaviorList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	06/25/2019
--	Description: *	This procedure takes a value of valid or not valid and returns a list of behaviors.
--  Last Modified By:
--  Last Modified Date: 
--  Initial revision. New process for short calls. TFS 14108 - 06/25/2019
--	=====================================================================
CREATE PROCEDURE [EC].[sp_ShortCalls_Get_BehaviorList] 
@isValid bit
AS
BEGIN
DECLARE	@nvcSQL nvarchar(max)


SET @nvcSQL = 'Select [ID] AS BehaviorId, [Description] AS BehaviorText 
FROM [EC].[ShortCalls_Behavior] 
Where Valid = '''+ CONVERT(NVARCHAR,@isValid) + '''
and Active = 1
Order by [Description]'


--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_ShortCalls_Get_BehaviorList
GO




