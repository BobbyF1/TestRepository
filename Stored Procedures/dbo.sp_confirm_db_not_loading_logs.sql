SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[sp_confirm_db_not_loading_logs] 
AS
BEGIN

	DECLARE @Long_Description VARCHAR(MAX), @not_loading bit = 0, @Result int, @Waited int = 0 

	WHILE @not_loading = 0
	BEGIN

		EXEC [sql-p02].ks_utils.dbo. usp_is_job_running @JobName = 'Load Shipped Logs', @StepNumber = 1, @Result = @Result OUTPUT
		
		IF (@Result = 1)
		BEGIN
			--step 1 is running -  need to wait for it to stop.
			Print 'Waiting for log load process to finish.'
			EXEC [svc].[sp_save_service_log] @Source = 'Keystone.Services.ReportEngine', 
											@SubSource = 'dbo.sp_confirm_db_not_loading_logs',
											@Severity = 0,
											@Detail = 'Waiting for log load process to finish.',
											@LongDescription = '', @Type = '', @Exception = ''
			WAITFOR DELAY '00:00:15' --15 seconds
			SET @Waited  = @Waited  + 15
		END
		ELSE
		BEGIN
			--not running
			EXEC [svc].[sp_save_service_log] @Source = 'Keystone.Services.ReportEngine', 
											@SubSource = 'dbo.sp_confirm_db_not_loading_logs',
											@Severity = 0,
											@Detail = 'Log load process is not running.',
											@LongDescription = '', @Type = '', @Exception = ''
			SET @not_loading  = 1
		END
			
	END

	IF @Waited 	>0
	BEGIN
	
		SET @Long_Description = 'Total wait time was [' + cast(@Waited as varchar(5)) +'] seconds.'
		Print @Long_Description
		EXEC [svc].[sp_save_service_log] @Source = 'Keystone.Services.ReportEngine', 
										@SubSource = 'dbo.sp_confirm_db_not_loading_logs',
										@Severity = 0,
										@Detail = 'Log load process finished.',
										@LongDescription = @Long_Description, @Type = '', @Exception = ''
	END	

END
GO
