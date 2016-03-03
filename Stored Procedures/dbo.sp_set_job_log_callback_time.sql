SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_set_job_log_callback_time] @JobLogId int
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Record time that we receive a callback confirmation message from 
--                   the SMTP server
-- v02 25/08/2015 PF Reset NextRunMailComments if it was set and we've sent a mail successfully.
---------------------------------------------------------------------------------------------------------  

	UPDATE dbo.JobLog SET CallbackConfirmed = getdate(), Status = 2
	WHERE Id = @JobLogId 
	
	DECLARE @JobId INTEGER
	
	SELECT @JobId = JobId FROM JobLog WHERE Id = @JobLogId 
	
	IF EXISTS (SELECT 1 FROM Job WHERE Id = @JobId AND NextRunMailComments IS NOT NULL)
	BEGIN
		UPDATE Job SET NextRunMailComments  = NULL WHERE Id = @JobId 
	END


		
END
GO
