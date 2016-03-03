SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_schedules]
as
BEGIN

SELECT 
	ID, Description, CAST(RunDailyTime as CHAR(5)) as RunDailyTime
	FROM Schedule

END
GO
