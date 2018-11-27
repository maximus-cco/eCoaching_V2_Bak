-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================

IF NOT EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'ec' AND SPECIFIC_NAME = N'sp_GetPageCountByMonth' 
)
BEGIN
	EXEC sp_executeSQL N'CREATE PROCEDURE ec.sp_GetPageCountByMonth AS SELECT ''Procedure Stub'';';
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [EC].[sp_GetPageCountByMonth]
	-- Add the parameters for the stored procedure here
	@startDay nvarchar(50),
	@endDay nvarchar(50),
	-------------------------------------------------------------------
	-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
	@returnCode int OUTPUT,
	@returnMessage nvarchar(250) OUTPUT
AS
    DECLARE @storedProcedureName nvarchar(100)
	-- THE PRECEDING CODE SHOULD NOT BE MODIFIED
	-------------------------------------------------------------------
	SET @returnCode = 0;
	SET @storedProcedureName = 'sp_GetPageCountByMonth';
	SET @returnMessage = @storedProcedureName + ' completed successfully';

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (ISDATE(@startDay) != 1 OR ISDATE(@endDay) != 1)
	BEGIN
		SET @returnCode = 99;
		SET @returnMessage = @storedProcedureName + ': invalid date(s) passed in.';
		RETURN -1;
	END;
	
	WITH 
	HitCount_CTE (YearMonth, Hits, PageName)
	AS
	(
		SELECT 
			FORMAT(IISLogDateTime, 'MM/yyyy'),
			COUNT(*) Hits, 
			iis.PageName + 'Hits'
		FROM ec.iislog iis
		WHERE IISLogDateTime BETWEEN @startDay AND @endDay
		GROUP BY FORMAT(IISLogDateTime, 'MM/yyyy'), iis.PageName 
	),

	UserCount_CTE (YearMonth, Users, PageName)
	AS 
	(
		SELECT 
			FORMAT(IISLogDateTime, 'MM/yyyy'),
			COUNT(distinct(EmployeeID)), 
			iis.PageName + 'Users'
		FROM ec.iislog iis
		WHERE IISLogDateTime BETWEEN @startDay AND @endDay
		GROUP BY FORMAT(IISLogDateTime, 'MM/yyyy'), iis.PageName
	),

	HitCount_Pivot 
	AS 
	(
		-- pivot
		SELECT YearMonth, [HistoricalDashboardHits], [MyDashboardHits], [NewSubmissionHits], [ReviewHits]
		FROM HitCount_CTE
		PIVOT (
			SUM(hits)
			FOR PageName IN ([HistoricalDashboardHits], [MyDashboardHits], [NewSubmissionHits], [ReviewHits])
		) hcp
	),

	UserCount_Pivot 
	AS 
	(
	    -- pivot
		SELECT YearMonth, [HistoricalDashboardUsers], [MyDashboardUsers], [NewSubmissionUsers], [ReviewUsers]
		FROM UserCount_CTE
		PIVOT (
			SUM(Users)
			FOR PageName IN ([HistoricalDashboardUsers], [MyDashboardUsers], [NewSubmissionUsers], [ReviewUsers])
		) ucp
	)

	SELECT hcp.YearMonth AS [TimeSpan]
	  ,hcp.HistoricalDashboardHits
	  ,hcp.MyDashboardHits
	  ,hcp.NewSubmissionHits
	  ,hcp.ReviewHits
	  ,ucp.HistoricalDashboardUsers
	  ,ucp.MyDashboardUsers
	  ,ucp.NewSubmissionUsers
	  ,ucp.ReviewUsers 
	FROM HitCount_Pivot hcp
	JOIN UserCount_Pivot ucp ON hcp.YearMonth = ucp.YearMonth
	ORDER BY hcp.YearMonth;
	
	SET @returnCode = @@ERROR;
	IF @returnCode <> 0
	BEGIN
		SET @returnMessage = @storedProcedureName + ' Error occurred.';
		RETURN -1;
	END
	ELSE
	BEGIN
	    RETURN 0;
    END
END;

GO