SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_delete_spreadsheet] @Id int
as
BEGIN

	DELETE FROM Spreadsheet WHERE Id = @Id 
	DELETE FROM SpreadsheetArgs WHERE SpreadsheetId = @Id 

END
GO
