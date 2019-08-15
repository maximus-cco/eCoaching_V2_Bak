/*
fn_strQNBDescriptionFromCompDesc(01).sql
Last Modified Date: 08/15/2018
Last Modified By: Susmitha Palacherla

Version 01: Created to support QN Bingo eCoaching logs. TFS 15063 - 08/15/2019

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strQNBDescriptionFromCompDesc' 
)
   DROP FUNCTION [EC].[fn_strQNBDescriptionFromCompDesc]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         08/12/2019
-- Description:	        Consolidates individual Descriptions for each competency to a single value for each Employee.
-- Quality Now Rewards and Recognition (Bingo). TFS 15063 - 08/12/2019
-- =============================================
CREATE FUNCTION [EC].[fn_strQNBDescriptionFromCompDesc] (
  @strEmpID NVARCHAR(10)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @strDescription NVARCHAR(MAX)
  
SET @strDescription = (SELECT STUFF((SELECT  CHAR(13) + CHAR(10) + [TextDescription] AS [text()]
            FROM [EC].[Quality_Other_Coaching_Stage]
         WHERE [EMP_ID] = @strEmpID
	     FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,'') List_Output) 
                      
    IF @strDescription IS NULL
    SET @strDescription = ''
    

        
RETURN @strDescription

END  -- fn_strQNBDescriptionFromCompDesc
GO








