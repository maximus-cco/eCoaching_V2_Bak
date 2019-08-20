/*
fn_nvcHtmlDecode(01).sql
Last Modified Date: 08/20/2019
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 15063 - 08/20/2019

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_nvcHtmlDecode' 
)
   DROP FUNCTION [EC].[fn_nvcHtmlDecode]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		    Susmitha Palacherla
-- Create date:     08/20/2019
-- Decodes html characters for Export to Excel
-- Description:   Initial revision. TFS 15063 - 08/20/2019

-- =============================================
CREATE FUNCTION [EC].[fn_nvcHtmlDecode] 
( 
    @Encoded as nvarchar(max) 
) 
RETURNS nvarchar(max) 
AS 
BEGIN 
    -- Declare the return variable here 
    DECLARE @Decoded as nvarchar(max) 
 
    -- Add the T-SQL statements to compute the return value here 
    SELECT @Decoded =  
         Replace( 
         Replace( 
	   Replace( 
	   Replace( 
	   Replace( 
	   Replace( 
	   Replace( 
	   Replace( 
	   Replace( 
	   Replace( 
	   Replace( 
	   Replace(@Encoded,'&amp;','&'), 
      '&lt;', '<'), 
      '&gt;', '>'), 
	  '&#39;','`'), 
	  '&quot;','"'), 
      '&lsquo;','‘'), 
	  '&rsquo;','’'), 
	  '&prime;',''), 
      '&Prime;','″'), 
      '&ldquo;','“'), 
	  '&rdquo;','”'),
	  '&ndash;','-')  
    -- Return the result of the function 
    RETURN @Decoded 
 
END --fn_nvcHtmlDecode

GO



