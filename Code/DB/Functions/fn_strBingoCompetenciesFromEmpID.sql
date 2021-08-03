/*
Last Modified Date: 8/2/2021
Last Modified By: Susmitha Palacherla

Version 02: Updated to improve performance for Bingo upload job - TFS 22443 - 8/2/2021
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
-- Add trigger and review performance for Bingo upload job - TFS 22443 - 8/2/2021
-- =============================================
CREATE FUNCTION [EC].[fn_strBingoCompetenciesFromEmpID] (
  @EmpID nvarchar(10), @BingoType nvarchar(2)
)
RETURNS NVARCHAR(1000)
AS
BEGIN
  DECLARE @strValue NVARCHAR(1000)
  
  IF @EmpID IS NOT NULL
  BEGIN
		  SET @strValue = (SELECT STRING_AGG([Competency],  ' | ') WITHIN GROUP (ORDER BY [Competency] ASC) AS Competencies
			  FROM [EC].[View_Coaching_Log_Bingo]
				 WHERE [EmpID] =   @EmpID AND [BingoType] = @BingoType
		  GROUP BY [EmpID], [BingoType]) 
  END
    ELSE
  SET @strValue = NULL
        
RETURN @strValue

END  -- fn_strBingoCompetenciesFromEmpID
GO





