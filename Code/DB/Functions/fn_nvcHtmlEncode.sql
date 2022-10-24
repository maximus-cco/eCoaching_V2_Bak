SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		    Susmitha Palacherla
-- Create date:     06/08/2012
-- Last update by:  Susmitha Palacherla
-- Encodes special characters that can pose a security risk when sent to front end.
-- Last update:   09/22/2013  
-- Description:   Modified per SCR 11115 to accept Summary of Caller issues upto 7000 chars. had to use nvarchar(max)
-- Modified to sanitize data before displaying. TFS 25634 - 10/21/2022
-- =============================================
CREATE OR ALTER   FUNCTION [EC].[fn_nvcHtmlEncode] 
( 
    @UnEncoded as nvarchar(max) 
) 
RETURNS nvarchar(max) 
AS 
BEGIN 
    -- Declare the return variable here 
    DECLARE @Encoded as nvarchar(max) 
 
    -- Add the T-SQL statements to compute the return value here 
    SELECT @Encoded =  
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
       Replace(@UnEncoded,'&','&amp;'), 
	   '<script', '&lt; script'), 
	   '<form', '&lt; form'),
       '<', '&lt;'), 
       '>', '&gt;'), 
	   '`', '&#39;'), 
	   '"', '&quot;'), 
       '‘', '&lsquo;'), 
	   '’', '&rsquo;'), 
	   '′', '&prime;'), 
       '″', '&Prime;'), 
       '“', '&ldquo;'), 
	   '”', '&rdquo;'),
	   '-', '&ndash;')   

 
    -- Return the result of the function 
    RETURN @Encoded 
 
END 
GO

