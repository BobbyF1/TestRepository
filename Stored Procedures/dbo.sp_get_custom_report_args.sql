SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_custom_report_args] @CustomReportId int
as
BEGIN

	SELECT
		CustomReportId, 
		Sequence,
		Name,
		DataType,
		IsNull(ArgValueId, -1) as ArgValueId,
		ArgValue
	FROM CustomReportArgs
	WHERE CustomReportId = @CustomReportId
	ORDER BY CustomReportId, Sequence

END
GO
