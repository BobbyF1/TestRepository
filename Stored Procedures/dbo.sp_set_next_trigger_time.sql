SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[sp_set_next_trigger_time] @JobId int
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Set next trigger time on a job
-- v02 21/03/2015 PF Introduce JobSchedule table
---------------------------------------------------------------------------------------------------------  

	DECLARE @lastRunTime datetime = getdate(), @NextDayFire int, @NextFireDate DATE, @NextFireTime Time, @NextFireDateTime DateTime
	DECLARE @todayDayOfWeek int = DatePart(dw, getdate()) --Sunday = day 1 of the week
	DECLARE @RepeatTryDuration int, @TryUntil datetime
	--select @todayDayOfWeek = 5
	
	DECLARE @RunDailyTime time, @RunDailyMon char(1) , @RunDailyTue char(1) , @RunDailyWed char(1), @RunDailyThu char(1) , 
				@RunDailyFri char(1) , @RunDailySat char(1) , @RunDailySun char(1), @ScheduleId int
				
	DECLARE @Outcome TABLE ( ScheduleId int, LastRun datetime, NextRun datetime, TryUntil datetime, NextOne bit NULL)

	DECLARE @Schedule TABLE (DayOfWeek int, FireTime time)

	DECLARE eachSchedule CURSOR FOR 
	SELECT 	js.ScheduleId, RunDailyTime , RunDailyMon  , RunDailyTue  , RunDailyWed , RunDailyThu , RunDailyFri  , RunDailySat, RunDailySun			  
	FROM dbo.Job j 
	inner Join JobSchedule js on j.Id = js.JobId
	inner join dbo.Schedule s on js.ScheduleId = s.Id
	WHERE j.Id = @JobId

	OPEN eachSchedule

	FETCH eachSchedule INTO @ScheduleId , @RunDailyTime , @RunDailyMon , @RunDailyTue , @RunDailyWed , @RunDailyThu , @RunDailyFri , @RunDailySat , @RunDailySun 

	WHILE @@FETCH_STATUS = 0
	BEGIN

		DELETE FROM @Schedule
		IF @RunDailyMon = 'Y' INSERT INTO @Schedule (DayOfWeek , FireTime ) VALUES (2, @RunDailyTime)
		IF @RunDailyTue = 'Y' INSERT INTO @Schedule (DayOfWeek , FireTime ) VALUES (3, @RunDailyTime)
		IF @RunDailyWed = 'Y' INSERT INTO @Schedule (DayOfWeek , FireTime ) VALUES (4, @RunDailyTime)
		IF @RunDailyThu = 'Y' INSERT INTO @Schedule (DayOfWeek , FireTime ) VALUES (5, @RunDailyTime)
		IF @RunDailyFri = 'Y' INSERT INTO @Schedule (DayOfWeek , FireTime ) VALUES (6, @RunDailyTime)
		IF @RunDailySat = 'Y' INSERT INTO @Schedule (DayOfWeek , FireTime ) VALUES (7, @RunDailyTime)
		IF @RunDailySun = 'Y' INSERT INTO @Schedule (DayOfWeek , FireTime ) VALUES (1, @RunDailyTime)

--select * from @Schedule

		SELECT @NextDayFire = MIN(DayOfWeek) FROM @Schedule WHERE 
			(DayOfWeek >= @todayDayOfWeek AND FireTime > Cast(@lastRunTime as time))
			OR
			(DayOfWeek > @todayDayOfWeek )
		IF @NextDayFire IS NOT NULL
		BEGIN
			SELECT @NextFireDate= DATEADD(dd, (@NextDayFire - @todayDayOfWeek), cast(getdate() as DATE))
			SELECT @NextFireTime = FireTime FROM @Schedule WHERE DayOfWeek = @NextDayFire
		END
		ELSE
		BEGIN
			SELECT @NextDayFire = MIN(DayOfWeek) FROM @Schedule WHERE DayOfWeek <= @todayDayOfWeek 
			--but this is NEXT WEEK!
			SELECT @NextFireDate= DATEADD(dd, @NextDayFire + (7- @todayDayOfWeek), cast(getdate() as DATE))
			SELECT @NextFireTime = FireTime FROM @Schedule WHERE DayOfWeek = @NextDayFire		
		END

		SELECT @NextFireDateTime = CONVERT(DATETIME, CONVERT(CHAR(8), @NextFireDate, 112) 
			+ ' ' + CONVERT(CHAR(8), @NextFireTime, 108))

--print @NextFireDate
--print @NextFireTime
--print @NextFireDateTime

		SELECT @RepeatTryDuration = RepeatTryDuration
		FROM dbo.Job j 
		inner join JobSchedule js on j.Id = js.JobId
		inner join dbo.Schedule s on js.ScheduleId = s.Id
		WHERE j.Id = @JobId

		SELECT @TryUntil = DateAdd(mi, @RepeatTryDuration, @NextFireDateTime)	
		
		INSERT INTO @Outcome (ScheduleId , LastRun , NextRun , TryUntil ) VALUES (@ScheduleId , @lastRunTime , @NextFireDateTime , @TryUntil )

		FETCH eachSchedule INTO @ScheduleId , @RunDailyTime , @RunDailyMon , @RunDailyTue , @RunDailyWed , @RunDailyThu , @RunDailyFri , @RunDailySat , @RunDailySun 

	END
	
	CLOSE eachSchedule
	DEALLOCATE eachSchedule
	
--	select * from @outcome

	;WITH NextOne AS (SELECT TOP 1 ScheduleId FROM @Outcome ORDER BY NextRun ASC)
	UPDATE @Outcome 
	SET NextOne = 1 
	FROM @Outcome o inner join NextOne n on o.ScheduleId = n.ScheduleID
	
	SELECT @NextFireDateTime = NextRun, 
		@TryUntil = TryUntil 
	FROM @Outcome WHERE NextOne = 1

	UPDATE dbo.Job
	SET LastRun = @lastRunTime, NextRun = @NextFireDateTime, TryUntil = @TryUntil
	WHERE Id = @JobId

	DECLARE @Detail varchar(150), @LongDesc nvarchar(max)
	SET @Detail = 'Setting trigger time for JobId = [' + convert(varchar(5), @JobId)+']'
	SET @LongDesc = 'NextRun = [' + convert(varchar(24), @NextFireDateTime, 113)+']'
	IF @TryUntil IS NULL 
		SET @LongDesc = @LongDesc + ', TryUntil=[n/a]'
	ELSE
		SET @LongDesc = @LongDesc + ', TryUntil=[' + convert(varchar(24), @TryUntil, 113) + ']'
	
	EXEC [svc].[sp_save_service_log] @Source = 'Keystone.Services.ReportEngine',
	@SubSource = 'dbo.sp_set_next_trigger_time', @Severity = 0, @Detail = @Detail, 	
	@LongDescription = @LongDesc, @Type = 'dbg'

	
END
GO
