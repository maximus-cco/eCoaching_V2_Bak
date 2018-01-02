/*
view_Historical_Dashboard_ACL.sql(01).sql
Last Modified Date: 11/27/2017
Last Modified By: Susmitha Palacherla



Version 01: Initial Revision - Created Modified to support Encrypted attributes. TFS 7856 - 11/27/2017
*/


IF EXISTS (
  SELECT 1
    FROM SYS.VIEWS
   WHERE NAME = N'View_Historical_Dashboard_ACL'
     AND TYPE = 'V'
)
DROP VIEW [EC].[View_Historical_Dashboard_ACL]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [EC].[View_Historical_Dashboard_ACL]
AS  
SELECT 
       [Row_ID]
      ,[Role]
      ,[End_Date]
      ,[IsAdmin]
      ,CONVERT(nvarchar(30),DecryptByKey([User_LanID])) AS [User_LanID]
      ,CONVERT(nvarchar(30),DecryptByKey([USER_NAME])) AS [User_Name]
   FROM [EC].[Historical_Dashboard_ACL]


GO

