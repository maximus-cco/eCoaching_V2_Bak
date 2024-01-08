SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      01/02/2024
--    Description:     Used to store consolidated results from File list Tables.
--    Initial Revision. 
--    Created  to support Feed Load Dashboard - TFS 27523 - 01/02/2024
--    =====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_InsertInto_Feed_Load_History]
   
AS
BEGIN
   
BEGIN TRANSACTION
BEGIN TRY  

-- Log the results of the Notification attempts
 


  WITH Selected AS (
  SELECT fl.[File_Name], CAST(fl.[File_LoadDate] AS DATE) AS LoadDate, fl.[File_LoadDate], fl.[Count_Staged], fl.[Count_Loaded], fl.[Count_Rejected], fl.[Category], fl.[Code]
  FROM [EC].[OutLier_FileList] fl LEFT OUTER JOIN [EC].[Feed_Load_History]fh
  ON fl.[File_Name] = fh.[FileName] AND fl.[File_LoadDate]= fh.[LoadTime]
  WHERE fh.[FileName] IS NULL and fh.[LoadTime] IS NULL 
  AND fl.[Category] IS NOT NULL AND fl.[Code] IS NOT NULL
  
  UNION ALL

    SELECT fl.[File_Name], CAST(fl.[File_LoadDate] AS DATE) AS LoadDate, fl.[File_LoadDate], fl.[Count_Staged], fl.[Count_Loaded], fl.[Count_Rejected], fl.[Category], fl.[Code]
  FROM [EC].[Generic_FileList] fl LEFT OUTER JOIN [EC].[Feed_Load_History]fh
  ON fl.[File_Name] = fh.[FileName] AND fl.[File_LoadDate]= fh.[LoadTime]
  WHERE fh.[FileName] IS NULL and fh.[LoadTime] IS NULL 
  AND fl.[Category] IS NOT NULL AND fl.[Code] IS NOT NULL
  

  UNION ALL

    SELECT fl.[File_Name], CAST(fl.[File_LoadDate] AS DATE) AS LoadDate, fl.[File_LoadDate], fl.[Count_Staged], fl.[Count_Loaded], fl.[Count_Rejected], fl.[Category], fl.[Code]
  FROM [EC].[Quality_Other_FileList] fl LEFT OUTER JOIN [EC].[Feed_Load_History]fh
  ON fl.[File_Name] = fh.[FileName] AND fl.[File_LoadDate]= fh.[LoadTime]
  WHERE fh.[FileName] IS NULL and fh.[LoadTime] IS NULL 
  AND fl.[Category] IS NOT NULL AND fl.[Code] IS NOT NULL
  
  UNION ALL

    SELECT fl.[File_Name], CAST(fl.[File_LoadDate] AS DATE) AS LoadDate, fl.[File_LoadDate], fl.[Count_Staged], fl.[Count_Loaded], fl.[Count_Rejected], fl.[Category], fl.[Code]
  FROM [EC].[Quality_Now_FileList] fl LEFT OUTER JOIN [EC].[Feed_Load_History]fh
  ON fl.[File_Name] = fh.[FileName] AND fl.[File_LoadDate]= fh.[LoadTime]
  WHERE fh.[FileName] IS NULL and fh.[LoadTime] IS NULL 
  AND fl.[Category] IS NOT NULL AND fl.[Code] IS NOT NULL )

   INSERT INTO [EC].[Feed_Load_History]
  ([FileName], [LoadDate], [LoadTime], [CountStaged], [CountLoaded], [CountRejected], [Category], [Code])
   SELECT * FROM Selected;
  
  UPDATE [EC].[Feed_Load_History]
  SET [Description] = fc.ReportDescription
  FROM [EC].[Feed_Load_History] fh INNER JOIN [EC].[Feed_Contacts] fc
  ON fh.[Category]= fc.Category AND fh.Code = fc.ReportCode
  WHERE [Description]  IS NULL;

 UPDATE [EC].[Feed_Load_History]
SET [Code] = fd.[Code], [Description] = fd.[Description]
FROM [EC].[Feed_Load_History] fh OUTER APPLY [EC].[fn_GetFeedDetailsFromFileName] (fh.[FileName])fd
WHERE (fh.[Code] is NULL OR fh.[Code] = '')

 
COMMIT TRANSACTION
END TRY
      
  BEGIN CATCH
	--PRINT 'Rollback Transaction'
	ROLLBACK TRANSACTION
	
 END CATCH  

  END -- InsertInto_Feed_Load_History
GO


