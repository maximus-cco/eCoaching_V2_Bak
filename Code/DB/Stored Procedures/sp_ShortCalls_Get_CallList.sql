/*
sp_ShortCalls_Get_CallList(01).sql
Last Modified Date:  07/05/2019
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision. New logic for handling Short calls - TFS 14108 - 07/05/2019

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_ShortCalls_Get_CallList' 
)
   DROP PROCEDURE [EC].[sp_ShortCalls_Get_CallList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	06/25/2019
--	Description: *	This procedure takes a log id and return a list of Verint Ids that are short calls.
--  Last Modified By:
--  Last Modified Date: 
--  Initial revision. New process for short calls. TFS 14108 - 06/25/2019
--	=====================================================================
CREATE PROCEDURE [EC].[sp_ShortCalls_Get_CallList] 
@intLogId bigint
AS
BEGIN
DECLARE	@nvcSQL nvarchar(max)


SET @nvcSQL = 'Select DISTINCT VerintCallId AS VerintId
FROM [EC].[ShortCalls_Evaluations]
WHERE CoachingId = ''' + CONVERT(NVARCHAR, @intLogId) + '''
ORDER BY VerintCallId'


--Print @nvcSQL
EXEC (@nvcSQL)	
END -- sp_ShortCalls_Get_CallList
GO
