SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_fast_report_args] @ReportId int
as
BEGIN

	SELECT
		ReportId, 
		Sequence,
		Name,
		DataType,
		IsNull(ArgValueId, -1) as ArgValueId,
		ArgValue
	FROM ReportArgs
	WHERE ReportId = @ReportId
	ORDER BY ReportId, Sequence

END
GO
