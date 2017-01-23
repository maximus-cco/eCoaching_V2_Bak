/*
sp_AT_Select_Action_Reasons(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Action_Reasons' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Action_Reasons]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/18/2016
--	Description: *	This procedure takes a value of either Coaching or Warning and 
-- the Action Type and returns the Reasons for that Action Type.
-- Last Modified By:
-- Last Modified Date: 
-- Initial revision to set up admin tool - TFS 1709 - 4/18/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Action_Reasons] 
@strType nvarchar(20), @strAction nvarchar(20)
AS
BEGIN
	DECLARE	
	
	@nvcSQL nvarchar(max)
	
	

SET @nvcSQL = 'Select [ReasonID],[Reason] FROM [EC].[AT_Action_Reasons]
Where ' + @strType +' = 1 
and ' + @strAction +'= 1
Order by CASE WHEN [Reason]= ''Other'' THEN 1 ELSE 0 END'


--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_AT_Select_Action_Reasons

GO

