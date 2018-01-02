/*
view_EmployeeID_To_LanID.sql(01).sql
Last Modified Date: 11/27/2017
Last Modified By: Susmitha Palacherla



Version 01: Initial Revision - Created Modified to support Encrypted attributes. TFS 7856 - 11/27/2017
*/


IF EXISTS (
  SELECT 1
    FROM SYS.VIEWS
   WHERE NAME = N'View_EmployeeID_To_LanID'
     AND TYPE = 'V'
)
DROP VIEW [EC].[View_EmployeeID_To_LanID]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [EC].[View_EmployeeID_To_LanID]
AS  
SELECT [EmpID]
      ,[StartDate]
      ,[EndDate]
      ,CONVERT(nvarchar(30),DecryptByKey(LanID)) AS [LanID]
      ,[DatetimeInserted]
      ,[DatetimeLastUpdated]
   FROM [EC].[EmployeeID_To_LanID]


GO

