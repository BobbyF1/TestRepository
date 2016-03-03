SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_clone_spreadsheet]
	@SpreadsheetId int
as
BEGIN

	DECLARE @NewId int
	
	INSERT INTO Spreadsheet(SQLQuery, Enabled, ForceFileFolder, Description, OverrideDefaultTimeout)
	SELECT SQLQuery, 'N', ForceFileFolder, '*CLONE* ' + Description, OverrideDefaultTimeout
	FROM Spreadsheet WHERE Id = @SpreadsheetId
	
	SET @NewId  = SCOPE_IDENTITY()
	
	INSERT INTO SpreadsheetArgs (SpreadsheetId, Sequence, Name, DataType, ArgValueId, ArgValue)
	SELECT @NewId, Sequence, Name, DataType, ArgValueId, ArgValue
	FROM SpreadsheetArgs
	WHERE SpreadsheetId = @SpreadsheetId
	
END
GO
