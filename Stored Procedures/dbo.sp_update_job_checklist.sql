SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_update_job_checklist]
	@JobId int,
	@Id int,
	@Checked bit	
AS
BEGIN

	IF @Checked = 1
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM JobCheckList jc WHERE JobId = @JobId AND CheckId = @Id)
		BEGIN
			INSERT INTO JobCheckList (JobId, CheckId, Enabled) VALUES (@JobId, @Id, 'Y')
		END
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM JobCheckList jr WHERE JobId = @JobId AND CheckId = @Id)
		BEGIN
			DELETE FROM JobCheckList WHERE JobId = @JobId AND CheckId = @Id
		END
	END

END
GO
