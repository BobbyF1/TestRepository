SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_update_fast_report_args]
		@ReportId int = null,
		@Sequence int,
		@OldSequence int = null,
		@Name VARCHAR(100),
		@Description varchar(512),
		@DataType VARCHAR(20),
		@ArgValueId int,
		@ArgValue varchar(max)

as
BEGIN

IF @ArgValueId = -1 SET @ArgValueId = NULL
IF @ArgValue = '' SET @ArgValue = NULL

IF EXISTS(SELECT 1 FROM ReportArgs WHERE ReportId = @ReportId and Sequence = @OldSequence)
BEGIN
	UPDATE ReportArgs
	SET Sequence = @Sequence,
		Name = @Name,
		Description = @Description,
		DataType = @DataType,
		ArgValueId = @ArgValueId,
		ArgValue = @ArgValue
	WHERE ReportId = @ReportId AND Sequence = @OldSequence
END
ELSE
BEGIN
	INSERT INTO ReportArgs
	(ReportId, Sequence, Name, Description, DataType, ArgValueId, ArgValue)
	VALUES (@ReportId,  @Sequence, @Name, @Description, @DataType, @ArgValueId, @ArgValue)
END	
END
GO
