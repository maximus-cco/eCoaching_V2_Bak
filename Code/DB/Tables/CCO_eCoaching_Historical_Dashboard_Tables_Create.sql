/*
File: CCO_eCoaching_Historical_Dashboard_Tables_Create(02).sql
Last Modified Date: 04/02/2018
Last Modified By: Susmitha Palacherla

version 02: Updated to document changes for data encrryption TFS 7856.

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


**************************************************************

--Table list

**************************************************************

1. [EC].[Historical_Dashboard_ACL]
 
 

**************************************************************

--Table creates

**************************************************************/

-- 1. Table [EC].[Historical_Dashboard_ACL]


-- =============================================
-- Author:Susmitha Palacherla
-- Create Date: 09/02/2012
-- Last Modified Date:09/20/2012
-- Last Modified By: Susmitha Palacherla
-- Description: Used to store the list of users with access to the Historical Dashboard and ARC CSRs
--
-- =============================================
/****** Object:  Table [EC].[Historical_Dashboard_ACL]    Script Date: 10/10/2012 11:13:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [EC].[Historical_Dashboard_ACL](
	[Row_ID] [int] IDENTITY(1,1) NOT NULL,
	[Role] [nvarchar](30) NOT NULL DEFAULT (N'ECL'),
	[End_Date] [nvarchar](10) NOT NULL DEFAULT (N'99991231'),
	[IsAdmin] [nvarchar](1) NULL DEFAULT (N'N'),
	[User_LanID] [varbinary](128) NULL,
	[User_Name] [varbinary](256) NULL,
	[Updated_By] [varbinary](256) NULL,
 CONSTRAINT [PK_Historical_Dashboard_ACL] PRIMARY KEY CLUSTERED 
(
	[Row_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[User_LanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO




ALTER TABLE [EC].[Historical_Dashboard_ACL] ADD  DEFAULT (N'ECL') FOR [Role]
GO

ALTER TABLE [EC].[Historical_Dashboard_ACL] ADD  DEFAULT (N'99991231') FOR [End_Date]
GO

ALTER TABLE [EC].[Historical_Dashboard_ACL] ADD  DEFAULT (N'N') FOR [IsAdmin]
GO




--*********************************************************

