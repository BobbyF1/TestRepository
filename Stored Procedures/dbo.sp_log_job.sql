SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_log_job] @JobId int, @JobStartTime datetime, @Status int, @MailSendTime datetime, @JobLogId int = null
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Log details of the current job
---------------------------------------------------------------------------------------------------------  

	IF @JobLogId IS NULL
	BEGIN
		INSERT INTO dbo.JobLog (JobId, JobStartTime, Status, MailSendTime)
		VALUES(@JobId, @JobStartTime, @Status, @MailSendTime)

		SELECT @@IDENTITY as JobLogId
	END
	ELSE
	BEGIN
		UPDATE dbo.JobLog 
		SET 	JobStartTime = @JobStartTime, 
			Status = @Status,
			MailSendTime = @MailSendTime 
		WHERE Id = @JobLogId

		SELECT @JobLogId as JobLogId
				
	END
	
END
GO
