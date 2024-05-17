SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER     VIEW [EC].[View_Employee_Hierarchy]
AS  
SELECT [Emp_ID]
      ,[Emp_Site]
  	  ,CONVERT(nvarchar(70),DecryptByKey(Emp_Name)) AS [Emp_Name]
	  ,CONVERT(nvarchar(70),DecryptByKey(Emp_Pri_Name)) AS [Emp_Pri_Name]
      ,CONVERT(nvarchar(250),DecryptByKey(Emp_Email)) AS [Emp_Email]
	  ,CONVERT(nvarchar(30),DecryptByKey(Emp_LanID)) AS [Emp_LanID]
	  ,[Emp_Job_Code]
	  ,[Active]
	  ,[isSub]
	  ,[isISG]
	  ,[Sup_ID]
      ,CONVERT(nvarchar(70),DecryptByKey(Sup_Name)) AS [Sup_Name]
	  ,CONVERT(nvarchar(250),DecryptByKey(Sup_Email)) AS [Sup_Email]
	  ,CONVERT(nvarchar(30),DecryptByKey(Sup_LanID)) AS [Sup_LanID]
	  ,[Mgr_ID]
   	  ,CONVERT(nvarchar(70),DecryptByKey(Mgr_Name)) AS [Mgr_Name]
	  ,CONVERT(nvarchar(250),DecryptByKey(Mgr_Email)) AS [Mgr_Email]
	  ,CONVERT(nvarchar(30),DecryptByKey(Mgr_LanID)) AS [Mgr_LanID]
	  ,[SrMgrLvl1_ID]
	  ,[EC].[fn_strEmpNameFromEmpID]([SrMgrLvl1_ID]) AS [SrMgrLvl1_Name]
	  ,[EC].[fn_strEmpLanIDFromEmpID] ([SrMgrLvl1_ID]) AS [SrMgrLvl1_LanID]
	  ,[SrMgrLvl2_ID]
	  ,[EC].[fn_strEmpNameFromEmpID]([SrMgrLvl2_ID]) AS [SrMgrLvl2_Name]
	  ,[EC].[fn_strEmpLanIDFromEmpID] ([SrMgrLvl2_ID]) AS [SrMgrLvl2_LanID]
	  ,[SrMgrLvl3_ID]
	  ,[EC].[fn_strEmpNameFromEmpID]([SrMgrLvl3_ID]) AS [SrMgrLvl3_Name]
	  ,[EC].[fn_strEmpLanIDFromEmpID] ([SrMgrLvl3_ID]) AS [SrMgrLvl3_LanID]
    FROM [EC].[Employee_Hierarchy];

GO