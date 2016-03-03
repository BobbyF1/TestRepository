SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_job_checklist]
	@JobId int
As
BEGIN

	SELECT 
		c.Id,
		c.Description,
		@JobId as JobId,
		CAST ( CASE WHEN jc.CheckId IS NULL THEN 0 ELSE 1 END as bit) as Checked
	FROM Checks c LEFT OUTER JOIN JobCheckList jc
	ON c.Id = jc.CheckId AND jc.JobId = @JobId
END
GO
