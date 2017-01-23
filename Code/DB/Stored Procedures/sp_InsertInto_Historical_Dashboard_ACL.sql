/*
sp_InsertInto_Historical_Dashboard_ACL(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Historical_Dashboard_ACL' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Historical_Dashboard_ACL]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--    ====================================================================
--    Author:                 Susmitha Palacherla
--    Create Date:     09/06/2012
--    Description:     This procedure inserts user records into the Historical_Dashboard_ACL table. 
--	  Last Update:	10/18/2013
--    last Modified by: Susmitha Palacherla
--    Modified per SCR 10617 to removed hard coded authorized users and look at the Isadmin flag in the ACL Table.
--    =====================================================================
CREATE  PROCEDURE [EC].[sp_InsertInto_Historical_Dashboard_ACL]
  (
    @nvcACTION Nvarchar(10),
	@nvcLANID	Nvarchar(30),
	@nvcUserLANID	Nvarchar(30),
	@nvcRole	Nvarchar(30),
	@nvcErrorMsgForEndUser Nvarchar(180) OUT

)
AS
BEGIN
	

	DECLARE @nvcHierarchyLevel	Nvarchar(20),
	        @nvcSQL Nvarchar(max),
	        @ROWID int,
	        @ENDDATE nvarchar(10),
	        @nvcIsAdmin Nvarchar(1)
	SET @nvcErrorMsgForEndUser = N''


   -- Removing the domain name from the Lanid.
	  SET @nvcLANID = SUBSTRING(@nvcLANID, CHARINDEX('\', @nvcLANID) + 1, LEN(@nvcLANID))
   -- Checking the App Role of the User
	  SET @nvcIsAdmin = (SELECT CASE WHEN End_Date = '99991231' THEN [ISADMIN] ELSE 'N'  END
                        FROM [EC].[Historical_Dashboard_ACL]WHERE [User_LanID] = @nvcLANID)
	  
	
			
--	Checking if the Inserter is authorized to insert.

IF @nvcIsAdmin = 'Y'
BEGIN

      IF @nvcACTION = 'ADD'  
      BEGIN
      
           IF EXISTS (SELECT Emp_LANID From [EC].[Employee_Hierarchy] WHERE Emp_LANID = @nvcUserLANID)
           BEGIN
           
			SELECT @ROWID = ROW_ID from [EC].[Historical_Dashboard_ACL]
			WHERE [User_LanID]=@nvcUserLANID
			
			SELECT @ENDDATE = End_Date from [EC].[Historical_Dashboard_ACL]
			WHERE [User_LanID]=@nvcUserLANID
						
                IF @ROWID IS NULL 
                BEGIN
                        					  
							 INSERT INTO [EC].[Historical_Dashboard_ACL]
							 ([User_LanID]
							 ,[User_Name]
							 ,[Role]
							 ,[Updated_By])
							 VALUES
							 (@nvcUserLanID ,EC.fn_strUserName(@nvcUserLanID),
							 @nvcRole, @nvcLANID
							  ) 
			SET @nvcErrorMsgForEndUser = N'Requested user ' + EC.fn_strUserName(@nvcUserLanID) + N' successfully added.'
			     END   --@ROWID IS NULL 			    			     
			ELSE
			
			IF @ENDDATE = '99991231'
				BEGIN
				SET @nvcErrorMsgForEndUser = N'Requested user ' + EC.fn_strUserName(@nvcUserLanID) + N' already exists in the system. You may select the existing record and update the Role.'
				END --@ENDDATE = '99991231'
			ELSE
			IF @ENDDATE <> '99991231'
				BEGIN
				UPDATE [EC].[Historical_Dashboard_ACL]
				SET End_Date = '99991231' ,
				    [Role]= @nvcRole
				WHERE [User_LanID]=@nvcUserLANID
				SET @nvcErrorMsgForEndUser = N'Requested user ' + EC.fn_strUserName(@nvcUserLanID) + N' has been Re-activated as an ' + @nvcRole + N' user.'
			END --@ENDDATE <> '99991231'
						 
			END	
			
			
			     ELSE
			     BEGIN
			     SET @nvcErrorMsgForEndUser = N'Requested user ' + @nvcUserLANID + N' is not a valid user'
			    
			     END --EXISTS @nvcUserLANID
		END	--@nvcACTION = 'ADD'  		
     ELSE
 
 
    IF @nvcACTION = 'REMOVE'  
         UPDATE [EC].[Historical_Dashboard_ACL]
         SET [END_DATE] = CONVERT(nvarchar(10),getdate(),112),
         [Updated_By] = @nvcLANID 
         Where User_LanID = @nvcUserLANID
    
    
	 END --@nvcACTION = 'REMOVE' 
 
ELSE		
		
BEGIN
SET @nvcErrorMsgForEndUser = N'Requester ' + @nvclanid + N' is not authorized to ADD/REMOVE Records.'

END	--@nvcIsAdmin = 'Y'		
	
END --sp_InsertInto_Historical_Dashboard_ACL

GO

