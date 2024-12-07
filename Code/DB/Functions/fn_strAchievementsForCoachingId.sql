/*
fn_strAchievementsForCoachingId(04).sql
Last Modified Date: 8/2/2021
Last Modified By: Susmitha Palacherla

Version 04: Updated to improve performance for Bingo upload job - TFS 22443 - 8/2/2021
Version 03: Updated to support WC Bingo records in Bingo feeds. TFS 21493 - 6/8/2021
Version 02: Updated to support QM Bingo eCoaching logs. TFS 15465 - 09/23/2019
Version 01: Created to support QN Bingo eCoaching logs. TFS 15063 - 08/15/2019

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strAchievementsForCoachingId' 
)
   DROP FUNCTION [EC].[fn_strAchievementsForCoachingId]
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
-- Updated to support QM Bingo eCoaching logs. TFS 15465 - 09/23/2019
-- Updated to support WC Bingo records in Bingo feeds. TFS 21493 - 6/8/2021
-- Add trigger and review performance for Bingo upload job - TFS 22443 - 8/2/2021
-- =============================================
CREATE FUNCTION [EC].[fn_strAchievementsForCoachingId] (
  @CoachingID BIGINT
)
RETURNS NVARCHAR(1000)
AS
BEGIN
  DECLARE @strAchievements NVARCHAR(1000)


  SET @strAchievements =  (SELECT STRING_AGG([CompImage],  ' &nbsp ') WITHIN GROUP (ORDER BY [CompImage] ASC) AS Competencies
FROM [EC].[Coaching_Log_Bingo]
WHERE [Include] = 1
AND CoachingID =   @CoachingID
GROUP BY CoachingID) 

    IF @strAchievements IS NULL
    SET @strAchievements = ''
    

        
RETURN @strAchievements
END  -- fn_strAchievementsForCoachingId
GO


