SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_update_job_schedules]
	@JobId int,
	@ScheduleId int,
	@Enabled bit
	
AS
BEGIN

	IF @Enabled = 1
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM JobSchedule js WHERE JobId = @JobId AND ScheduleId = @ScheduleId)
		BEGIN
			INSERT INTO JobSchedule (JobId, ScheduleId) VALUES (@JobId, @ScheduleId)
		END
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM JobSchedule js WHERE JobId = @JobId AND ScheduleId = @ScheduleId)
		BEGIN
			DELETE FROM JobSchedule WHERE JobId = @JobId AND ScheduleId = @ScheduleId
		END
	END

END
GO
