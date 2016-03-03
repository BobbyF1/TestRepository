SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_fast_report_args_sequence_exists]
	@ReportId int,
	@Sequence int
as
begin

	if exists(Select 1 FROM ReportArgs WHERE ReportId = @ReportId AND Sequence = @Sequence)
		SELECT 1 as res
	ELSE
		SELECT 0 as res

end
GO
