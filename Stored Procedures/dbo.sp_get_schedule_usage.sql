SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_schedule_usage]
@ScheduleId int
as
BEGIN

	SELECT 
		j.Id as [Job Id], jc.CatDesc as Category, j.Name, j.Enabled
	INTO #jobs
	FROM JobSchedule js INNER JOIN Job j ON js.JobId = j.Id
	INNER JOIN JobCategory jc on j.CategoryId = jc.CategoryId
	WHERE js.ScheduleId = @ScheduleId
	
/*	IF @@ROWCOUNT = 0 
		INSERT INTO #jobs ([Job Id], Name, Enabled, Category)
		VALUES ( -1, '(None)', '', '(None)')
*/
	SELECT * FROM #jobs ORDER BY [job id]
	
	
	
END
GO
