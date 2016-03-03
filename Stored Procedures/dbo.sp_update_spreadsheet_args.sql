SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_update_spreadsheet_args]
		@SpreadsheetId int = null,
		@Sequence int,
		@OldSequence int = null,
		@Name VARCHAR(100),
		@DataType VARCHAR(20),
		@ArgValueId int,
		@ArgValue varchar(max)

as
BEGIN

IF @ArgValueId = -1 SET @ArgValueId = NULL
IF @ArgValue = '' SET @ArgValue = NULL

IF EXISTS(SELECT 1 FROM SpreadsheetArgs WHERE SpreadsheetId = @SpreadsheetId and Sequence = @OldSequence)
BEGIN
	UPDATE SpreadsheetArgs
	SET Sequence = @Sequence,
		Name = @Name,
		DataType = @DataType,
		ArgValueId = @ArgValueId,
		ArgValue = @ArgValue
	WHERE SpreadsheetId = @SpreadsheetId AND Sequence = @OldSequence
END
ELSE
BEGIN
	INSERT INTO SpreadsheetArgs
	(SpreadsheetId, Sequence, Name, DataType, ArgValueId, ArgValue)
	VALUES (@SpreadsheetId,  @Sequence, @Name, @DataType, @ArgValueId, @ArgValue)
END	
END
GO
