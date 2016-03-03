SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[sp_get_custom_reports]
as
BEGIN

	SELECT
		Id,
		Name,
		CAST (CASE Enabled WHEN 'Y' THEN 1 ELSE 0 END as bit) as Enabled,
		Description
	FROM CustomReport
	ORDER BY Id

END
GO
