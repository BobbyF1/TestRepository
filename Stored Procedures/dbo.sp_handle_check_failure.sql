SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_handle_check_failure] @JobId int
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Logic for when pre-report checks fail. We may fail immediately, or
--                   try repeatedly until a given period is over.
-- v02 21/03/2015 PF Introduce JobSchedule table
---------------------------------------------------------------------------------------------------------  

	DECLARE @ReturnValue varchar(20), @TryUntil datetime , @RepeatTryPause int, @NextRun datetime
	DECLARE @TryAgainUntil varchar(24), @LongDesc nvarchar(max)
	
	SELECT @TryUntil = TryUntil
	FROM Job
	WHERE Id = @JobId

	SET @TryAgainUntil = convert(varchar(24), @TryUntil,113)
	
	IF (@TryUntil IS NULL)
	BEGIN
		--no further attempts.... so log the failure
		EXEC [svc].[sp_save_service_log] @Source = 'Keystone.Services.ReportEngine',
		@SubSource = 'dbo.sp_handle_check_failure', @Severity = 1, @Detail = 'Checks failed', 	
		@LongDescription = 'Checks failed and the job is not set to try again until the checks succeed.',
		@Type = 'svc'
		
		--set the next attempt time
		EXEC dbo.sp_set_next_trigger_time @JobId = @JobId 
		
		SELECT @ReturnValue = 'no_try_again_set'
	END
	ELSE IF @TryUntil < getdate()
	BEGIN
		SET @LongDesc = 'Checks failed and the "try again until" time [' + @TryAgainUntil +'] has passed.'
	
		--we could try again but we've run out of repeat attempts.... so log the failure
		EXEC [svc].[sp_save_service_log] @Source = 'Keystone.Services.ReportEngine',
		@SubSource = 'dbo.sp_handle_check_failure', @Severity = 1, @Detail = 'Checks failed', 	
		@LongDescription = @LongDesc, @Type = 'svc'

		--set the next attempt time
		EXEC dbo.sp_set_next_trigger_time @JobId = @JobId 
		
		SELECT @ReturnValue = 'after_try_again'
	END
	ELSE
	BEGIN
		--checks failed but we can keep trying
		SELECT TOP 1 @RepeatTryPause = IsNull(RepeatTryPause, 5) 
		FROM Job j 
		inner join JobSchedule js on j.Id = js.JobId
		inner join Schedule s on js.ScheduleId = s.Id
		WHERE j.Id = @JobId
		AND RepeatTryPause IS NOT NULL
		
		IF @RepeatTryPause IS NULL SET @RepeatTryPause = 5
		
		SET @NextRun = DateAdd( mi, @RepeatTryPause, getdate())
		IF @NextRun < GETDATE() SELECT @NextRun = GETDATE()

		SET @LongDesc = 'Checks failed but we can try again until [' + @TryAgainUntil +']. Next attempt will be at ['+
			convert(varchar(24), @NextRun , 113)+']'
	
		--we could try again but we've run out of repeat attempts.... so log the failure
		EXEC [svc].[sp_save_service_log] @Source = 'Keystone.Services.ReportEngine',
		@SubSource = 'dbo.sp_handle_check_failure', @Severity = 1, @Detail = 'Checks failed', 	
		@LongDescription = @LongDesc, @Type = 'svc'
		
		--set NextRun time
		UPDATE Job 
		SET NextRun = @NextRun
		WHERE Id = @JobId
		
		SELECT @ReturnValue = 'will_try_again'
	
	END

	UPDATE Job 
	SET LastRun = getdate()
	WHERE Id = @JobId
	

	EXEC [svc].[sp_save_service_log] @Source = 'Keystone.Services.ReportEngine',
	@SubSource = 'dbo.sp_handle_check_failure', @Severity = 0, @Detail = @ReturnValue, 	
	@LongDescription = @LongDesc, @Type = 'dbg'
	
	
	SELECT @ReturnValue as ReturnValue
	
END
GO
