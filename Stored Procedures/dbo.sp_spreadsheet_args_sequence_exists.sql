SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_spreadsheet_args_sequence_exists]
	@SpreadsheetId int,
	@Sequence int
as
begin

	if exists(Select 1 FROM SpreadsheetArgs WHERE SpreadsheetId = @SpreadsheetId AND Sequence = @Sequence)
		SELECT 1 as res
	ELSE
		SELECT 0 as res

end
GO
