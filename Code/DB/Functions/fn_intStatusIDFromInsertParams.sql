/*
fn_intStatusIDFromInsertParams(01).sql
Last Modified Date: 04/10/2018
Last Modified By: Susmitha Palacherla


Version 01: Initial Revision. Created during Submissions move to new architecture - TFS 7136 - 04/10/2018 


*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intStatusIDFromInsertParams' 
)
   DROP FUNCTION [EC].[fn_intStatusIDFromInsertParams]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:        04/17/2018
-- Last modified by:    
-- Last modified date:  
-- Description:	 Given a Module, isCSE and Source returns StatusID
-- Created during Submissions move to new architecture - TFS 7136 - 04/10/2018. 
-- =============================================
CREATE FUNCTION [EC].[fn_intStatusIDFromInsertParams]
 (
@intModuleID INT, 
@intSourceID INT,
@bitisCSE bit
)

RETURNS INT
AS
BEGIN

  DECLARE 
  @strStatus nvarchar(30),
  @strModule nvarchar(30),
  @strSource nvarchar(10),
  @strSubSource nvarchar(40),
  @intStatusID INT 
   
  SET @strModule = (SELECT [Module] FROM [EC].[DIM_Module] WHERE [ModuleID] = @intModuleID)
  SET @strSource = (SELECT [CoachingSource] FROM [EC].[DIM_Source] WHERE [SourceID]= @intSourceID)
  SET @strSubSource = (SELECT [SubCoachingSource] FROM [EC].[DIM_Source] WHERE [SourceID]= @intSourceID)

  SET  @strStatus = (SELECT DISTINCT [Status] FROM [EC].[Email_Notifications] WHERE [Module] = @strModule
  AND [Source] = @strSource  AND [SubSource] = @strSubSource AND [isCSE] = @bitisCSE
  AND [Submission] = 'UI'
  )

  IF @strStatus = '' OR @strStatus IS NULL
  SET @strStatus = 'Unknown'
  SET @intStatusID = (SELECT [StatusID] FROM [EC].[DIM_Status] WHERE Status = @strStatus)

  
      
  RETURN @intStatusID
  
END  -- fn_intStatusIDFromInsertParams()





GO



