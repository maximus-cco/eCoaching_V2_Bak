
if exists (select * from dbo.sysobjects where id = object_id('[EC].[sp_HistoricalDashboardAclInsert]') and OBJECTPROPERTY(id, 'IsProcedure') = 1)
drop procedure EC.sp_HistoricalDashboardAclInsert
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

-- =============================================
-- Author:           Lili Huang
-- Revision History
--  Modified to support Encryption of sensitive data - Open key - TFS 7856 - 10/23/2017
-- =============================================

CREATE PROCEDURE [EC].[sp_HistoricalDashboardAclInsert]
(
    @userLanId        nvarchar(30),
    @userName         nvarchar(50),
    @userRole         nvarchar(30),
    @createdBy        nvarchar(30),
    @rowId            int OUTPUT,
-------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
    @returnCode       int OUTPUT,
    @returnMessage    varchar(300) OUTPUT        
)
AS
    DECLARE @storedProcedureName  varchar(80)

    SET @storedProcedureName = 'sp_HistoricalDashboardAclInsert'
    SET @returnCode = 0
    SET @returnMessage = @storedProcedureName + ' completed successfuly.'
-- THE PRECEDING CODE SHOULD NOT BE MODIFIED    
-------------------------------------------------------------------------------    
-- *** BEGIN: INSERT CUSTOM CODE HERE ***
BEGIN
  


    BEGIN TRY

OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]

        SELECT @rowId = Row_ID FROM View_Historical_Dashboard_ACL WHERE User_LanID = @userLanId AND End_Date <> '99991231'; 
        IF (@rowId IS NULL)
        BEGIN
            INSERT INTO Historical_Dashboard_ACL 
			(  [User_LanID]
               ,[User_Name]
			   ,[Role]
               ,[End_Date]
               ,[IsAdmin]
			   ,[Updated_By])
            VALUES 
            (
                  EncryptByKey(Key_GUID('CoachingKey'), @userLanId),
				  EncryptByKey(Key_GUID('CoachingKey'), @userName),
                  @userRole,
				  '99991231',
				  'N',
		        EncryptByKey(Key_GUID('CoachingKey'), @createdBy)
			  --    [EC].[fn_Encrypt_CoachingKey](@userLanId),
				 --[EC].[fn_Encrypt_CoachingKey](@userName),
     --             @userRole,
				 -- '99991231',
				 -- 'N',
		   --     [EC].[fn_Encrypt_CoachingKey]( @createdBy)
             );
CLOSE SYMMETRIC KEY [CoachingKey] 

            SELECT @rowId = SCOPE_IDENTITY();
        END -- IF
        ELSE
        BEGIN
            UPDATE Historical_Dashboard_ACL SET End_Date = '99991231', Role = @userRole 
			WHERE CONVERT(nvarchar(30),DecryptByKey([User_LanID])) = @userLanId;
        END; -- ELSE
    END TRY
    
    BEGIN CATCH
        --TODO: Log error in a table
        --ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE() 
        SET @returnCode = ERROR_NUMBER();
        SET @returnMessage = @storedProcedureName + ' Failed to insert into HistoricalDashboarACL table.';
    END CATCH
 
    RETURN @returnCode; 

END
-- *** END: INSERT CUSTOM CODE HERE ***



GO
