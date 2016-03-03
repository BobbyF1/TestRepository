SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_job_categories] 
as
BEGIN

SELECT CategoryId, CatDesc
FROM JobCategory
UNION
SELECT 0, ''
ORDER BY CatDesc 

END
GO
