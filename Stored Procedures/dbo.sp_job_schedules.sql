SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_job_schedules]
	@Id int 
AS
BEGIN
	SELECT 
		CAST ( CASE WHEN js.Id IS NULL THEN 0 ELSE 1 END as Bit) as Checked,
		s.Id as ScheduleId, 
		Description as ScheduleDescription		
	FROM Schedule s
	LEFT OUTER JOIN JobSchedule js ON s.Id = js.ScheduleId AND js.JobId = @Id
	ORDER BY Checked DESC, ScheduleId

END
GO
