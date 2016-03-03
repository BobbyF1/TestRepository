SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_update_custom_report_args]
		@CustomReportId int = null,
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

IF EXISTS(SELECT 1 FROM CustomReportArgs WHERE CustomReportId = @CustomReportId and Sequence = @OldSequence)
BEGIN
	UPDATE CustomReportArgs
	SET Sequence = @Sequence,
		Name = @Name,
		DataType = @DataType,
		ArgValueId = @ArgValueId,
		ArgValue = @ArgValue
	WHERE CustomReportId = @CustomReportId AND Sequence = @OldSequence
END
ELSE
BEGIN
	INSERT INTO CustomReportArgs
	(CustomReportId, Sequence, Name, DataType, ArgValueId, ArgValue)
	VALUES (@CustomReportId,  @Sequence, @Name, @DataType, @ArgValueId, @ArgValue)
END	
END
GO
