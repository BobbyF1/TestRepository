SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_update_job_spreadsheets]
	@JobId int,
	@Id int,
	@Checked bit,
	@TargetFilename varchar(100)
	
AS
BEGIN

	IF @TargetFilename IS NULL SET @TargetFilename = 'Untitled.pdf'

	IF @Checked = 1
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM JobSpreadsheetDetail jc WHERE JobId = @JobId AND SpreadsheetId = @Id)
		BEGIN
			INSERT INTO JobSpreadsheetDetail (JobId, SpreadsheetId, TargetFilename) VALUES (@JobId, @Id, @TargetFilename)
		END
		ELSE
			UPDATE JobSpreadsheetDetail SET TargetFilename = @TargetFilename WHERE JobId = @JobId AND SpreadsheetId = @Id
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM JobSpreadsheetDetail jr WHERE JobId = @JobId AND SpreadsheetId = @Id)
		BEGIN
			DELETE FROM JobSpreadsheetDetail WHERE JobId = @JobId AND SpreadsheetId = @Id
		END
	END

END
GO
