/*
Last Modified Date:  12/21/2020
Last Modified By: Susmitha Palacherla


Version 01: Document Initial Revision - TFS 19526 - 12/8/2020

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strBingoCompetenciesFromEmpID' 
)
   DROP FUNCTION [EC].[fn_strBingoCompetenciesFromEmpID]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:           Susmitha Palacherla
-- Create date:      12/8/2020
-- Description:	     Given an EmployeeID and Bingo Type returns the Bingo Competency Values for the Employee
--                   concatenated as a single string of values separated by a '|'
-- Initial Revision. Extract bingo logs from ecl and post to share point sites. TFS 19526 - 12/8/2020
-- =============================================
ALTER FUNCTION [EC].[fn_strBingoCompetenciesFromEmpID] (
  @EmpID nvarchar(10), @BingoType nvarchar(2)
)
RETURNS NVARCHAR(1000)
AS
BEGIN
  DECLARE @strValue NVARCHAR(1000)
  
  IF @EmpID IS NOT NULL
  BEGIN
  SET @strValue = (SELECT  DISTINCT STUFF((SELECT  ' | ' + CAST([Competency] AS VARCHAR(1000)) [text()]
            FROM [EC].[View_Coaching_Log_Bingo]
         WHERE EmpID = b.[EmpID] AND [BingoType] = @BingoType
	     FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ') List_Output
FROM [EC].[View_Coaching_Log_Bingo] b INNER JOIN EC.Coaching_Log cl
ON cl.CoachingID = b.CoachingID
  where b.[EmpID]= @EmpID
GROUP BY b.[EmpID])       
	END
    ELSE
    SET @strValue = NULL
        
RETURN @strValue

END  -- fn_strValueFromCoachingID

GO




