SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_update_schedule] 
@Id int,
@Description varchar(512),
@RunDailyTime time,
@RunDailyMon bit,
@RunDailyTue bit,
@RunDailyWed bit,
@RunDailyThu bit,
@RunDailyFri bit,
@RunDailySat bit,
@RunDailySun bit,
@RepeatTryDuration int,
@RepeatTryPause int
as
BEGIN

insert into debugschedule(Description, RunDailyTime, RunDailyMon, RunDailyTue, RunDailyWed, RunDailyThu, 
		RunDailyFri, RunDailySat, RunDailySun, RepeatTryDuration, RepeatTryPause)
	VALUES ( @Description, @RunDailyTime, @RunDailyMon, @RunDailyTue, @RunDailyWed, @RunDailyThu, 
	@RunDailyFri, @RunDailySat, @RunDailySun, @RepeatTryDuration, @RepeatTryPause)


DECLARE 
@cRunDailyMon char(1) = 'Y',
@cRunDailyTue char(1) = 'Y',
@cRunDailyWed char(1) = 'Y',
@cRunDailyThu char(1) = 'Y',
@cRunDailyFri char(1) = 'Y',
@cRunDailySat char(1) = 'Y',
@cRunDailySun char(1) = 'Y'


IF @RunDailyMon = 0 SET @cRunDailyMon = 'N'
IF @RunDailyTue = 0 SET @cRunDailyTue = 'N'
IF @RunDailyWed = 0 SET @cRunDailyWed = 'N'
IF @RunDailyThu = 0 SET @cRunDailyThu = 'N'
IF @RunDailyFri = 0 SET @cRunDailyFri = 'N'
IF @RunDailySat = 0 SET @cRunDailySat = 'N'
IF @RunDailySun = 0 SET @cRunDailySun = 'N'

IF @RunDailyTime IS NULL SET @RunDailyTime = '08:00'
IF @RepeatTryDuration = 0 SET @RepeatTryDuration = NULL
IF @RepeatTryPause = 0 SET @RepeatTryPause = NULL


IF EXISTS(SELECT 1 FROM Schedule WHERE ID = @Id)
	UPDATE Schedule
	SET
	Description = @Description,
	RunDailyTime = @RunDailyTime,
	RunDailyMon = @cRunDailyMon,
	RunDailyTue = @cRunDailyTue,
	RunDailyWed = @cRunDailyWed,
	RunDailyThu = @cRunDailyThu,
	RunDailyFri = @cRunDailyFri,
	RunDailySat = @cRunDailySat,
	RunDailySun = @cRunDailySun,
	RepeatTryDuration = @RepeatTryDuration,
	RepeatTryPause = @RepeatTryPause
	WHERE ID = @Id
ELSE
	INSERT INTO Schedule(Description, RunDailyTime, RunDailyMon, RunDailyTue, RunDailyWed, RunDailyThu, 
		RunDailyFri, RunDailySat, RunDailySun, RepeatTryDuration, RepeatTryPause)
		VALUES ( @Description, @RunDailyTime, @cRunDailyMon, @cRunDailyTue, @cRunDailyWed, @cRunDailyThu, 
		@cRunDailyFri, @cRunDailySat, @cRunDailySun, @RepeatTryDuration, @RepeatTryPause)
END
GO
