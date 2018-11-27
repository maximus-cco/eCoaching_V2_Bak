IF EXISTS (
    SELECT table_name FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_NAME = N'IISLog_Stage')
BEGIN
    DROP TABLE ec.IISLog_Stage;
END;
GO

IF EXISTS (
    SELECT table_name FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_NAME = N'IISLog_FileImport')
BEGIN
    DROP TABLE ec.IISLog_FileImport;
END;
GO

IF EXISTS (
    SELECT table_name FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_NAME = N'IISLog')
BEGIN
    DROP TABLE ec.IISLog;
END;
GO

CREATE TABLE EC.IISLog_Stage
(
	UserName nvarchar(50),
	IISLogDateTime datetime,
	[Target] nvarchar(100),
	PageName nvarchar(50),
	StatusCode int
);
GO

CREATE TABLE ec.IISLog_FileImport
(
    FileImportID INT IDENTITY PRIMARY KEY NOT NULL,
	[FileName] NVARCHAR(100) NOT NULL,
	ImportDate DATETIME NULL,
    ImportFlag BIT NULL
);
GO

CREATE TABLE EC.IISLog
(
    IISLogID INT IDENTITY PRIMARY KEY NOT NULL,
	EmployeeID nvarchar(16),
	IISLogDateTime datetime,
	[Target] nvarchar(100),
	PageName nvarchar(50),
	StatusCode int
);
GO