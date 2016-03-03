SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_spreadsheet_args] @SpreadsheetId int
as
BEGIN

	SELECT
		SpreadsheetId, 
		Sequence,
		Name,
		DataType,
		IsNull(ArgValueId, -1) as ArgValueId,
		ArgValue
	FROM SpreadsheetArgs
	WHERE SpreadsheetId = @SpreadsheetId
	ORDER BY SpreadsheetId, Sequence

END
GO
