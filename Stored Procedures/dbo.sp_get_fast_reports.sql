SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_fast_reports]
as
BEGIN

	SELECT
		Id,
		FRFileName,
		CAST (CASE Enabled WHEN 'Y' THEN 1 ELSE 0 END as bit) as Enabled,
		Description,
		OverrideDefaultDelphiWait 
	FROM FastReport
	ORDER BY Id

END
GO
