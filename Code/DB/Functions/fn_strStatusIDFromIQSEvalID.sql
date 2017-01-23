/*
fn_strStatusIDFromIQSEvalID(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strStatusIDFromIQSEvalID' 
)
   DROP FUNCTION [EC].[fn_strStatusIDFromIQSEvalID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         02/23/2014
-- Last modified by:    
-- Last modified date:  
-- Description:	 
--  *  Given an IQS Eval ID determines the Status for the Coaching Log.
--  The Status is then used to look up the Status ID.

-- =============================================
CREATE FUNCTION [EC].[fn_strStatusIDFromIQSEvalID] (
 @strCSE NVARCHAR(20),@strOppor_Rein NVARCHAR(20)
)
RETURNS NVARCHAR(50)
AS
BEGIN
  DECLARE  @strStatus NVARCHAR(50),
           @strStatusID INT 
  
 
  IF @strCSE ='' and @strOppor_Rein in ('Opportunity','Opportunity-PWC','Did Not Meet Goal')
  SET @strStatus = 'Pending Supervisor Review'
  ELSE 
  IF @strCSE in ('1','2','3','4','5','6','7','8') and @strOppor_Rein in ('Opportunity','Opportunity-PWC','Did Not Meet Goal')
  SET @strStatus = 'Pending Manager Review'
  ELSE 
  IF @strOppor_Rein in ('Reinforcement','Met Goal')
  SET @strStatus= 'Pending Acknowledgement'
  
  IF @strStatus is NULL
  SET @strStatus = 'Unknown'
  
  SELECT @strStatusID = [StatusID] FROM [EC].[DIM_Status]
  WHERE [Status]= @strStatus
  
      
  RETURN @strStatusID
  
END  -- fn_strStatusIDFromIQSEvalID()

GO

