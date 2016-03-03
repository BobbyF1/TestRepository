SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_job_by_category] @JobCategoryId int, @EnabledOnly bit = 0
as
BEGIN

SELECT Id, Name, Enabled
FROM Job
WHERE CategoryId = @JobCategoryId
AND ( @EnabledOnly = 0 OR (Enabled = 'Y' AND @EnabledOnly = 1) ) 
UNION SELECT 0, '', 'Y'
ORDER BY Id

END
GO
