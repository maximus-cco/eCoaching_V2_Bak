/*
File: CCO_eCoaching_Historical_Dashboard_Tables_Create(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



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

CREATE TABLE [EC].[Historical_Dashboard_ACL](
	[Row_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_LanID] [nvarchar](30) NOT NULL,
	[User_Name] [nvarchar](30) NOT NULL,
	[Role] [nvarchar](30) NOT NULL,
	[End_Date] [nvarchar](10) NOT NULL,
	[Updated_By] [nvarchar](30) NULL,
	[IsAdmin] [nvarchar](1) NULL,
 CONSTRAINT [PK_Historical_Dashboard_ACL] PRIMARY KEY CLUSTERED 
(
	[Row_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[User_LanID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [EC].[Historical_Dashboard_ACL] ON


INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (1, N'acosir', N'Acosta, Irving O', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (2, N'amayro', N'Amaya, Ronald A', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (3, N'arguma', N'Argus, Maureen E', N'ECL', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (4, N'augujo', N'Augustin, Jourdain M', N'ECL', N'99991231', N'augujo', N'Y')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (5, N'Baezad', N'Baeza, Adriana', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (6, N'barnge', N'Barnett, Geneva L', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (7, N'beauda', N'Beaulieu, Daniel J', N'ECL', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (8, N'bolina', N'Bolinas, Nancy P', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (9, N'boulsh', N'Boultinghouse, Shawn R', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (10, N'brunB1', N'Brunk, Bonnie S', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (11, N'carvmi', N'Carvelli, Michael R', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (12, N'castd1', N'Castro, Dulce G', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (13, N'castm4', N'Castillo, Maria', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (14, N'catopa', N'Caton, Patsy A', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (15, N'clutpe', N'Cluthe, Peter H', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (16, N'colwmi', N'Colwell, Michael G', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (17, N'cortco', N'Cortez, Corey C', N'ECL', N'99991231', N'cortco', N'Y')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (18, N'cmsprod', N'CMS Production ID', N'ECL', N'99991231', N'cougbr', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (19, N'curtja', N'Curtis, Jared A', N'ECL', N'99991231', N'cortco', N'Y')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (20, N'daviev', N'Davis, Evan', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (21, N'delgba', N'Delgado, Baldemar', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (22, N'demesa', N'De Merieux, Sara', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (23, N'doolst', N'Doolin, Stephanie A', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (24, N'dougei', N'Dougherty, Eileen M', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (25, N'dupesu', N'DuPere, Suzann M', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (26, N'dyexbr', N'Dye, Brian A', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (27, N'esqumo', N'Esquibel, Monica E', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (28, N'favelu', N'Favela Stremel, Lupe', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (29, N'findan', N'Findlay, Robert A', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (30, N'FitzDr', N'Fitzwater, Drex', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (31, N'fjorbj', N'Fjordholm, Bjorn E', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (32, N'fostm1', N'Foster, Mark S', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (33, N'garcvi', N'Garcia, Vianey', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (34, N'garns1', N'Farrant, Shadow D', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (35, N'Gonzar', N'Unknown', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (36, N'grifpa', N'Griffith, Pamela A', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (37, N'harkda', N'Harkess, David T', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (38, N'harvan', N'Harvey, Anthony C', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (39, N'hatcki', N'Hatch, Kimberly K', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (40, N'hernlu', N'Hernandez, Luis A', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (41, N'HessJo', N'Hess, John P', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (42, N'horrta', N'Horrigan, Tara A', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (43, N'howare', N'Howard, Renee', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (44, N'jackky', N'Jackson, Kylie K', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (45, N'jacqst', N'Jacques, Stacy E', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (46, N'jakuas', N'Jakupovic, Asmirka', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (47, N'jonetr', N'Jones, Travis D', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (48, N'kinckr', N'Kincaid, Kristopher D', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (49, N'klicwa', N'Klick, Harvey W', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (50, N'lapkca', N'Austin, Carol J', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (51, N'lemuce', N'Lemus, Cecilia', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (52, N'lindlo', N'Lindstrom, Lori S', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (53, N'mainsc', N'Mainwaring, Scott', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (54, N'marmli', N'Marman, Linda L', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (55, N'martb1', N'Marten, Bradley J', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (56, N'martt2', N'Martinovich, Timothy M', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (57, N'mccoal', N'Miranda, Allison L', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (58, N'mcgey9', N'McGee, Yvonne', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (59, N'mcphvi', N'McPherson, Vicky L', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (60, N'medlwa', N'Medlock, Waletta J', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (61, N'medrru', N'Unknown', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (62, N'mitcre', N'Mitchell, Rebecca D', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (63, N'morglo', N'Morgan, Lori J', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (64, N'navave', N'Navarro, Veronica M', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (65, N'nevavi', N'Nevarez, Vianey D', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (66, N'orties', N'Ortiz, Esperanza', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (67, N'pachsa', N'Pacheco, Sarai', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (68, N'paqusa', N'Paquette, Sara E', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (69, N'pattb1', N'Patterson, Rebecca S', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (70, N'pezzni', N'Pezzella, Nicole M', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (71, N'pittgl', N'Pittman, Gloria J', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (72, N'reynsc', N'Reynolds, Scott D', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (73, N'riddju', N'Riddell, Julie R', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (74, N'rodrgr', N'Rodriguez, Griselda', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (75, N'rodrl1', N'Rodriguez, Lindsey M', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (76, N'rosije', N'Rosiles, Jeanette', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (77, N'ryanel', N'Ryan, Elizabeth A', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (78, N'sampjo', N'Sampson, Joanna L', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (79, N'schrst', N'Schreiber, Steven P', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (80, N'sigama', N'Sigala, Mary L', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (81, N'slavda', N'Slavik, Daniel', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (82, N'stewci', N'Steward, Ciera', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (83, N'stonsa', N'Stonecipher, Sara M', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (84, N'sumnlo', N'Summers-Hernandez, Lourdes', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (85, N'thommi', N'Thompson, Michelle L', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (86, N'ThyeCh', N'Thyes, Chad D', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (87, N'timmap', N'Timmons, April D', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (88, N'turnna', N'Turner, Nancy L', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (89, N'velado', N'Velazquez, Domenica', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (90, N'waleti', N'Wales, Timothy C', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (91, N'walll1', N'Walling, Laura A', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (92, N'warrsc', N'Warren, Scotty R', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (93, N'woodma', N'Wood, Mark R', N'ARC', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (94, N'zeitsh', N'Zeithamel, Sheila K', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (95, N'maddra', N'Unknown', N'ECL', N'99991231', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (96, N'deusde', N'Unknown', N'ECL', N'20120924', N'geilde', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (97, N'pasama', N'Pasapula, Madhavi', N'ECL', N'99991231', N'cortco', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (98, N'palasu', N'Palacherla, Susmitha C', N'ECL', N'99991231', N'augujo', N'Y')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (99, N'auguj2', N'Unknown', N'ECL', N'20120921', N'augujo', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (100, N'cougbr', N'Coughlin, Brian E', N'ARC', N'99991231', N'cougbr', N'Y')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (101, N'geilde', N'Geils, Larry D', N'ECL', N'20120924', N'geilde', N'Y')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (102, N'ericto', N'Erickson, William T', N'ECL', N'99991231', N'augujo', N'Y')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (103, N'eclCSR3', N'eclCSR3', N'ARC', N'99991231', N'cougbr', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (104, N'123456', N'UnKnown', N'ECL', N'20120924', N'geilde', N'N')
INSERT [EC].[Historical_Dashboard_ACL] ([Row_ID], [User_LanID], [User_Name], [Role], [End_Date], [Updated_By], [IsAdmin]) VALUES (105, N'duesde', N'Duesenberg, Derric D', N'ECL', N'99991231', N'geilde', N'N')
SET IDENTITY_INSERT [EC].[Historical_Dashboard_ACL] OFF

ALTER TABLE [EC].[Historical_Dashboard_ACL] ADD  DEFAULT (N'ECL') FOR [Role]
GO

ALTER TABLE [EC].[Historical_Dashboard_ACL] ADD  DEFAULT (N'99991231') FOR [End_Date]
GO

ALTER TABLE [EC].[Historical_Dashboard_ACL] ADD  DEFAULT (N'N') FOR [IsAdmin]
GO




--*********************************************************

