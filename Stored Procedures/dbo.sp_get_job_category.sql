SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_job_category] 
	@JobId int
as
BEGIN

SELECT CategoryId, CatDesc
FROM JobCategory
WHERE CategoryId = (SELECT CategoryId FROM Job WHERE Id = @JobId)

END
GO
