/*
Last Modified Date: 12/21/2020
Last Modified By: Susmitha Palacherla

Version 02: Updated to remove CoachingLogID - TFS 19526 - 12/21/2020
Version 01: Document Initial Revision - TFS 19526 - 12/15/2020


**************************************************************

--Table list

**************************************************************


1. CREATE TABLE EC.Coaching_Log_Bingo_SharePoint_Uploads
2. CREATE TABLE TYPE EC.SharepointUploadBingoTableType


**************************************************************

--Table creates

**************************************************************/


-- 1. EC.Coaching_Log_Bingo_SharePoint_Uploads


/*
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[EC].[Coaching_Log_Bingo_SharePoint_Uploads]') AND type in (N'U'))
DROP Table [EC].[Coaching_Log_Bingo_SharePoint_Uploads]
*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Coaching_Log_Bingo_SharePoint_Uploads](
	[Employee_ID] [nvarchar](10) NOT NULL,
	[Employee_Site] [nvarchar](50) NOT NULL,
	[Month_Year] [nvarchar](7) NOT NULL,
	[EventDate] [datetime] NOT NULL,
	[Upload_Status] [nvarchar](50) NULL,
	[Initial_UploadDate] [datetime] NULL,
	[Last_UploadDate] [datetime] NULL,
 CONSTRAINT [PK_Coaching_Log_Bingo_SharePoint_Uploads] PRIMARY KEY CLUSTERED 
(
	[Employee_ID] ASC,
	[Employee_Site] ASC,
	[Month_Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO



--******************************

--Table Type creates

--******************************

--1. Create User defined Table TYPE [EC].[SharepointUploadBingoTableType] 

CREATE TYPE [EC].[SharepointUploadBingoTableType] AS TABLE(
	[Title] [nvarchar](50) NOT NULL,
	[Employee_Name] [nvarchar](50) NOT NULL,
	[Employee_ID] [nvarchar](10) NOT NULL,
	[Employee_Site] [nvarchar](50) NOT NULL,
	[Competencies] [nvarchar](500) NOT NULL,
	[Month_Year] [nvarchar](7) NOT NULL,
	[Employee_Email] [nvarchar](50) NULL,
	[Upload_Status] [nvarchar](50) NULL
)
GO





	    
