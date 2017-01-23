/*
sp_Select_Email_Attributes(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Email_Attributes' 
)
   DROP PROCEDURE [EC].[sp_Select_Email_Attributes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/1814
--	Description: *	This procedure takes a Module, Source(Direct/Indirect), SubCoachingSource and isCSE and returns the  
--                  Status and Email attributes.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Email_Attributes] 
@strModulein NVARCHAR(30), @intSourceIDin INT, @bitisCSEin BIT

AS
BEGIN
	DECLARE	
	@Source nvarchar(30),
	@SubSource nvarchar(100),
	@nvcSQL nvarchar(max)
	
	SET @Source = (Select [CoachingSource] from [EC].[DIM_Source]WHERE [SourceID]=  @intSourceIDin)
	SET @SubSource = (Select [SubCoachingSource] from [EC].[DIM_Source]WHERE [SourceID]=  @intSourceIDin)

SET @nvcSQL = 'Select [EC].[fn_strStatusIDFromStatus]([Status]) as StatusID, [Status]as StatusName, [Recipient] as Receiver,
 [Body] as EmailText, [isCCRecipient] as isCCReceiver, [CCRecipient] as CCReceiver
 from [EC].[Email_Notifications]
Where [Module]= '''+@strModulein+'''
and [Source] = '''+@Source+'''
and [SubSource] = '''+@SubSource+'''
and [isCSE] = '''+CONVERT(NVARCHAR(1),@bitisCSEin)+''''

--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_Email_Attributes

GO

