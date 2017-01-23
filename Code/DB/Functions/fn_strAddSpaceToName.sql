/*
fn_strAddSpaceToName(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strAddSpaceToName' 
)
   DROP FUNCTION [EC].[fn_strAddSpaceToName]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         07/30/2013
-- Last modified by:    
-- Last modified date:  
-- Description:	 
--  *  Given an Employee Name Adds a space after the comma.

-- =============================================
CREATE Function [EC].[fn_strAddSpaceToName](@Name VarChar(50))
RETURNS VarChar(50)
AS
BEGIN

	--SET @NAME = REPLACE(@NAME, ',' ,', ')
	SET @NAME=
	SUBSTRING(@NAME,1,(CHARINDEX(',',@NAME))) + ' ' + SUBSTRING(@NAME,(CHARINDEX(',',@NAME )+1),40)   
	                
       
	RETURN @NAME
    
END -- fn_strAddSpaceToName


GO

