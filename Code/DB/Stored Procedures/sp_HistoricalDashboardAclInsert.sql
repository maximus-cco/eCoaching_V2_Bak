SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id('[EC].[sp_HistoricalDashboardAclInsert]') and OBJECTPROPERTY(id, 'IsProcedure') = 1)
drop procedure EC.sp_HistoricalDashboardAclInsert
GO

/***************************************************************** 
sp_HistoricalDashboardAclInsert
Description:
	Inserts a record into Historical_Dashboard_ACL table.

Tables:
	Historical_Dashboard_ACL

Input Parameters:
	@userLanId
	@userName
	@userRole
	@CreatedBy
	@rowId

Resultset:
	None
	
*****************************************************************/

CREATE  PROCEDURE [EC].[sp_HistoricalDashboardAclInsert]
(
    @userLanId        varchar(20),
    @userName         varchar(20),
    @userRole         varchar(10),
    @createdBy        varchar(20),
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
        SELECT @rowId = Row_ID FROM Historical_Dashboard_ACL WHERE User_LanID = @userLanId AND End_Date <> '99991231'; 
        IF (@rowId IS NULL)
        BEGIN
            INSERT INTO Historical_Dashboard_ACL 
            VALUES 
            (
                @userLanId,
                @userName,
                @userRole,
                '99991231',
                @createdBy,
                'N'
            );
            SELECT @rowId = SCOPE_IDENTITY();
        END -- IF
        ELSE
        BEGIN
            UPDATE Historical_Dashboard_ACL SET End_Date = '99991231' WHERE User_LanID = @userLanId;
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