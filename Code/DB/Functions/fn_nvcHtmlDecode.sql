SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		    Susmitha Palacherla
-- Create date:     08/20/2019
-- Decodes html characters for Export to Excel
-- Description:   Initial revision. TFS 15063 - 08/20/2019
-- Modified to sanitize data before displaying. TFS 25634 - 10/21/2022
-- =============================================
CREATE OR ALTER   FUNCTION [EC].[fn_nvcHtmlDecode] 
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
	   Replace( 
	   Replace( 
	   Replace(@Encoded,'&amp;','&'), 
	   '&lt; script', '<script'), 
	   '&lt; form', '<form'),
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
