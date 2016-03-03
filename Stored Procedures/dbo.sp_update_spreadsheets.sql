SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_update_spreadsheets]
		@Id int = null,
		@SQLQuery VARCHAR(256),
		@Enabled bit,
		@Description VARCHAR(512),
		@OverrideDefaultTimeout int

as
BEGIN

DECLARE @cEnabled CHAR(1) = 'Y'
IF @Enabled = 0 SET @cEnabled = 'N'

IF @OverrideDefaultTimeout = 0 OR @OverrideDefaultTimeout = @ID
	SET @OverrideDefaultTimeout = NULL --asp.net bug?????
	

IF EXISTS(SELECT 1 FROM Spreadsheet WHERE Id = @Id)
	UPDATE Spreadsheet
	SET SQLQuery = @SQLQuery,
		Enabled = @cEnabled,
		Description = @Description,
		OverrideDefaultTimeout = @OverrideDefaultTimeout
	WHERE ID = @Id
ELSE
	INSERT INTO Spreadsheet
	(SQLQuery , Enabled, ForceFileFolder, Description, OverrideDefaultTimeout)
	VALUES (@SQLQuery, @cEnabled, NULL, @Description, @OverrideDefaultTimeout)
	
END
GO
