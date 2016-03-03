SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_update_custom_reports]
		@Id int = null,
		@Name VARCHAR(256),
		@Enabled bit,
		@Description VARCHAR(512)

as
BEGIN

DECLARE @cEnabled CHAR(1) = 'Y'
IF @Enabled = 0 SET @cEnabled = 'N'

IF EXISTS(SELECT 1 FROM CustomReport WHERE Id = @Id)
	UPDATE CustomReport 
	SET Name = @Name,
		Enabled = @cEnabled,
		Description = @Description
	WHERE ID = @Id
ELSE
	INSERT INTO CustomReport 
	(Name, Enabled, Description)
	VALUES (@Name, @cEnabled, @Description)
	
END
GO
