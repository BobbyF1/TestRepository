SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_update_job_custom_reports]
	@JobId int,
	@Id int,
	@Checked bit,
	@TargetFilename varchar(100)
	
AS
BEGIN

	IF @TargetFilename IS NULL SET @TargetFilename = 'Untitled.pdf'

	IF @Checked = 1
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM JobCustomReportDetail jc WHERE JobId = @JobId AND CustomReportId = @Id)
		BEGIN
			INSERT INTO JobCustomReportDetail (JobId, CustomReportId, TargetFilename) VALUES (@JobId, @Id, @TargetFilename)
		END
		ELSE
			UPDATE JobCustomReportDetail SET TargetFilename = @TargetFilename WHERE JobId = @JobId AND CustomReportId = @Id
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM JobCustomReportDetail jr WHERE JobId = @JobId AND CustomReportId = @Id)
		BEGIN
			DELETE FROM JobCustomReportDetail WHERE JobId = @JobId AND CustomReportId = @Id
		END
	END

END
GO
