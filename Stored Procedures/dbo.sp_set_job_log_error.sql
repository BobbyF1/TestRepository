SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_set_job_log_error] @JobLogId int, @ErrorMessage varchar(max)
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 13/04/2015 PF Original Version. Record an email error message 
---------------------------------------------------------------------------------------------------------  

	UPDATE dbo.JobLog SET ErrorTime = getdate(), Status = -1, ErrorMessage = @ErrorMessage
	WHERE Id = @JobLogId 
	
END
GO
