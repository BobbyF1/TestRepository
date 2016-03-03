SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[sp_confirm_target_db_not_loading_logs] @JobId int
AS BEGIN
---------------------------------------------------------------------------------------------------------    
-- v01 21/09/2015 PF Initial Version.     
-- v02 24/09/2015 PF Correct name = @DBName in read-only check
---------------------------------------------------------------------------------------------------------    

	DECLARE @DBName sysname

	SELECT @DBName = ReportDatabaseName FROM Job WHERE Id = @JobId

	IF @DbName like '$sql-p02%'
	BEGIN
		SELECT 0, 'OK - SQL-P02'
		RETURN
	END
	 
	IF EXISTS(SELECT 1 FROM sys.databases WHERE name = @DBName AND is_read_only = 0 ) 
	BEGIN
		SELECT 0, 'Not Read-Only'
		RETURN
	END
 
	--read-only DB on PPG-SQL-01 so we need to be sure it's not loading logs now	
	EXEC ks_report_engine.dbo.sp_confirm_db_not_loading_logs --PF 21/09/2015 wait until we're not loading logs
	
	SELECT 0, 'Not loading logs.'
	
END
GO
