SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_update_job_fast_reports]
	@JobId int,
	@Id int,
	@Checked bit,
	@SaveAs varchar(10) = 'PDF',
	@TargetFilename varchar(100)
	
AS
BEGIN

	IF @TargetFilename IS NULL SET @TargetFilename = 'Untitled.pdf'

	IF @Checked = 1
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM JobReportDetail jr WHERE JobId = @JobId AND ReportId = @Id)
		BEGIN
			INSERT INTO JobReportDetail (JobId, ReportId, SaveAs, TargetFilename) VALUES (@JobId, @Id, @SaveAs, @TargetFilename)
		END
		ELSE
			UPDATE JobReportDetail SET TargetFilename = @TargetFilename WHERE JobId = @JobId AND ReportId = @Id
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM JobReportDetail jr WHERE JobId = @JobId AND ReportId = @Id)
		BEGIN
			DELETE FROM JobReportDetail WHERE JobId = @JobId AND ReportId = @Id
		END
	END

END
GO
