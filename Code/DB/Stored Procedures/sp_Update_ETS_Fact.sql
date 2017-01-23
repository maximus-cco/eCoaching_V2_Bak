/*
sp_Update_ETS_Fact(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_ETS_Fact' 
)
   DROP PROCEDURE [EC].[sp_Update_ETS_Fact]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      11/11/2014
--    Description:     This procedure inserts new ETS records into Fact table.
--   Modified Date:    
--   Description:    
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update_ETS_Fact]
  
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY
      

 -- Append new records to ETS Fact Table

INSERT INTO [EC].[ETS_Coaching_Fact]
           ([Report_Code]
           ,[Event_Date]
           ,[Emp_ID]
           ,[Project_Number]
           ,[Task_Number]
           ,[Task_Name]
           ,[Time_Code]
           ,[Associated_Person]
           ,[Hours]
           ,[Sat]
           ,[Sun]
           ,[Mon]
           ,[Tue]
           ,[Wed]
           ,[Thu]
           ,[Fri]
           ,[Exemp_Status]
           ,[Inserted_Date]
           ,[FileName])
   SELECT S.[Report_Code]
      ,S.[Event_Date]
      ,S.[Emp_ID]
      ,S.[Project_Number]
      ,S.[Task_Number]
      ,S.[Task_Name]
      ,S.[Time_Code]
      ,S.[Associated_Person]
      ,S.[Hours]
      ,S.[Sat]
      ,S.[Sun]
      ,S.[Mon]
      ,S.[Tue]
      ,S.[Wed]
      ,S.[Thu]
      ,S.[Fri]
      ,S.[Exemp_Status]
      ,GETDATE()
      ,S.[FileName]
  FROM [EC].[ETS_Coaching_Stage]S LEFT OUTER JOIN [EC].[ETS_Coaching_Fact]F
  ON S.[Report_Code] = F.[Report_Code]
  AND S.[Emp_ID]= F.[Emp_ID]
  AND S.[Event_Date]= F.[Event_Date]
  WHERE  F.[Report_Code]IS NULL AND F.[Emp_ID]IS NULL AND F.[Event_Date]IS NULL
                  
COMMIT TRANSACTION
END TRY

      
      BEGIN CATCH
      IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION


    DECLARE @ErrorMessage NVARCHAR(4000)
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE()

    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               )
      
    IF ERROR_NUMBER() IS NULL
      RETURN 1
    ELSE IF ERROR_NUMBER() <> 0 
      RETURN ERROR_NUMBER()
    ELSE
      RETURN 1
  END CATCH  
END -- sp_Update_ETS_Fact


GO

