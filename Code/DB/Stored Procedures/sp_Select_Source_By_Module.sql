/*
sp_Select_Source_By_Module(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Source_By_Module' 
)
   DROP PROCEDURE [EC].[sp_Select_Source_By_Module]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/01/14
--	Description: *	This procedure takes a Module and Source (Direct or Indirect)
--  and returns the Source IDis for the coresponding Sub Coaching Source.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Source_By_Module] 
@strModulein nvarchar(30), @strSourcein nvarchar(30)

AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)

SET @nvcSQL = 'Select [SourceID] as SourceID, [SubCoachingSource]as Source from [EC].[DIM_Source]
Where ' + @strModulein +' = 1 and 
IsActive = 1 and 
CoachingSource =  '''+@strSourcein+'''
Order by [SubCoachingSource] '


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Source_By_Module


GO

