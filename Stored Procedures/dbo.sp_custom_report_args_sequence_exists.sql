SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_custom_report_args_sequence_exists]
	@CustomReportId int,
	@Sequence int
as
begin

	if exists(Select 1 FROM CustomReportArgs WHERE CustomReportId = @CustomReportId AND Sequence = @Sequence)
		SELECT 1 as res
	ELSE
		SELECT 0 as res

end
GO
