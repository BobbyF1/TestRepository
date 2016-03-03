SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_schedule_detail] @ScheduleId int
as
BEGIN

	SELECT 
		Id,
		Description,
		cast(RunDailyTime as varchar(5)) as RunDailyTime,
		cast ( case RunDailyMon when 'N' then 0 else 1 end as bit) as RunDailyMon,
		cast ( case RunDailyTue when 'N' then 0 else 1 end as bit) as RunDailyTue ,
		cast ( case RunDailyWed when 'N' then 0 else 1 end as bit) as RunDailyWed,
		cast ( case RunDailyThu when 'N' then 0 else 1 end as bit) as RunDailyThu,
		cast ( case RunDailyFri when 'N' then 0 else 1 end as bit) as RunDailyFri,
		cast ( case RunDailySat when 'N' then 0 else 1 end as bit) as RunDailySat,
		cast ( case RunDailySun when 'N' then 0 else 1 end as bit) as RunDailySun,
		IsNull(RepeatTryDuration, 0) as RepeatTryDuration,
		IsNull(RepeatTryPause, 0) as RepeatTryPause
	FROM Schedule
	WHERE Id = @ScheduleId

END
GO
