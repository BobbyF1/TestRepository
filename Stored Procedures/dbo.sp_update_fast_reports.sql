SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_update_fast_reports]
		@Id int = null,
		@FRFileName VARCHAR(256),
		@Enabled bit,
		@Description VARCHAR(512),
		@OverrideDefaultDelphiWait int

as
BEGIN

DECLARE @cEnabled CHAR(1) = 'Y'
IF @Enabled = 0 SET @cEnabled = 'N'

IF EXISTS(SELECT 1 FROM FastReport WHERE Id = @Id)
	UPDATE FastReport
	SET FRFileName = @FRFileName,
		Enabled = @cEnabled,
		Description = @Description,
		OverrideDefaultDelphiWait = @OverrideDefaultDelphiWait
	WHERE ID = @Id
ELSE
	INSERT INTO FastReport
	(FRFileName, Enabled, ForceFileFolder, Description, OverrideDefaultDelphiWait)
	VALUES (@FRFileName, @cEnabled, NULL, @Description, @OverrideDefaultDelphiWait)
	
END
GO
