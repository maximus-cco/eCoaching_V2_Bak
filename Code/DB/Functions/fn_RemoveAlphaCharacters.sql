/*
RemoveAlphaCharacters(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'RemoveAlphaCharacters' 
)
   DROP FUNCTION [EC].[RemoveAlphaCharacters]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         07/20/2013
-- Last modified by:    
-- Last modified date:  
-- Description:	 
--  *  Given an Employee ID or Other String removes the alpha characters 
-- If they exist in the first 2 Positions. 
-- =============================================
CREATE Function [EC].[RemoveAlphaCharacters](@Temp VarChar(10))
Returns VarChar(10)
AS
Begin

    Declare @RemoveValues as varchar(10) = '%[A-Za-z]%'
    While PatIndex(@RemoveValues, @Temp) > 0 and PatIndex(@RemoveValues, @Temp) <= 2
        Set @Temp = Stuff(@Temp, PatIndex(@RemoveValues, @Temp), 1, '')

    Return @Temp
End -- RemoveAlphaCharacters


GO

