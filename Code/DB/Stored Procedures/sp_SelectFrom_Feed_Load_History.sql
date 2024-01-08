SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      01/02/2024
--    Description:     Used to retrieve data from Feed Load History Table for given parameters.
--    Initial Revision. 
--    Created  to support Feed Load Dashboard - TFS 27523 - 01/02/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_SelectFrom_Feed_Load_History] 
@intCategoryID INT,
@intReportID INT,
@strSDatein datetime,
@strEDatein datetime,
@PageSize int,
@startRowIndex int

AS

BEGIN
SET NOCOUNT ON

DECLARE	
@nvcCategory nvarchar(20),
@nvcCode nvarchar(10),
@strSDate nvarchar(10),
@strEDate nvarchar(10)
       



SET @strSDate = convert(varchar(8), @strSDatein,112)
SET @strEDate = convert(varchar(8), @strEDatein,112)

		 
IF @intCategoryID  <> -1
BEGIN 
    SET @nvcCategory = (SELECT DISTINCT [Category] FROM [EC].[DIM_Feed_List] WHERE [CategoryID] = @intCategoryID)
END

--PRINT @nvcCategory

IF @intReportID <> -1
BEGIN
    SET @nvcCode = (SELECT DISTINCT [ReportCode] FROM [EC].[DIM_Feed_List] WHERE [ReportID] = @intReportID )
END

--PRINT @nvcCode
;with a as (
SELECT [LoadDate] AS [Load Date]
       ,[Category]
      ,[Code] AS [Report Code]
      ,[Description]
      ,[FileName] AS [File Name]
      ,[CountStaged] AS [Total Staged]
      ,[CountLoaded] AS [Total Loaded]
      ,[CountRejected] AS [Total Rejected]    
  FROM [EC].[Feed_Load_History]   
 WHERE convert(varchar(8),[LoadDate],112) >= @strSDate
 AND convert(varchar(8),[LoadDate],112) <= @strEDate
 AND ([Category]= @nvcCategory  OR @intCategoryID = -1)
 AND ([Code]=  @nvcCode OR @intReportID = -1)
 ),
b as (
select ROW_NUMBER() over (order by [Load Date] desc) as RowNumber, Count(*) over () as TotalRows, * from a
)
select * from b
where RowNumber between @startRowIndex and @startRowIndex + @PageSize - 1;

	    
END -- sp_SelectFrom_Feed_Load_History
GO


