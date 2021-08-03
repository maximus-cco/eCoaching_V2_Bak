/*
fn_strBingoCompetenciesFromCoachingID(02).sql
Last Modified Date: 8/2/2021
Last Modified By: Susmitha Palacherla

Version 02: Updated to improve performance for Bingo upload job - TFS 22443 - 8/2/2021
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strBingoCompetenciesFromCoachingID' 
)
   DROP FUNCTION [EC].[fn_strBingoCompetenciesFromCoachingID]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:           Susmitha Palacherla
-- Create date:      12/8/2020
-- Description:	     Given a CoachingID returns the Bingo Competency Values 
--                   concatenated as a single string of values separated by a '|'
-- Initial Revision. Extract bingo logs from ecl and post to share point sites. TFS 19526 - 12/8/2020
-- Add trigger and review performance for Bingo upload job - TFS 22443 - 8/2/2021
-- =============================================
CREATE FUNCTION [EC].[fn_strBingoCompetenciesFromCoachingID] (
  @bigintCoachingID bigint
)
RETURNS NVARCHAR(1000)
AS
BEGIN
  DECLARE @strValue NVARCHAR(1000)
  
  IF @bigintCoachingID IS NOT NULL
  BEGIN
		  SET @strValue = (SELECT STRING_AGG([Competency],  ' | ') WITHIN GROUP (ORDER BY [Competency] ASC) AS Competencies
					FROM [EC].[Coaching_Log_Bingo]
				 WHERE [CoachingID] = @bigintCoachingID
			GROUP BY [CoachingID])       
	END
  ELSE
    SET @strValue = NULL
        
RETURN @strValue

END  -- fn_strValueFromCoachingID

GO


