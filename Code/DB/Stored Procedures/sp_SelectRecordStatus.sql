/*
sp_SelectRecordStatus(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectRecordStatus' 
)
   DROP PROCEDURE [EC].[sp_SelectRecordStatus]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	12/13/13
--	Description: 	This procedure selects the status of a record from the Coaching_Log table
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectRecordStatus] @strFormID nvarchar(50)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT s.Status	strFormStatus
      FROM [EC].[Coaching_Log] cl WITH (NOLOCK),
			[EC].[DIM_Status] s
		Where cl.StatusID = s.StatusID 	
		And cl.FormName = 	'''+@strFormID+''''	
		
EXEC (@nvcSQL)	
	    
END --sp_SelectRecordStatus

GO

