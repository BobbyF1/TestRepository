SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_update_job_email_details]
	@JobId int,
	@ErrorProfile bit = 0,
	@EmailProfileId int
As
BEGIN

	IF @ErrorProfile = 0 
		UPDATE Job SET EmailProfileId = @EmailProfileId WHERE Id = @JobId
	ELSE
		UPDATE Job SET AlertEmailProfileId = @EmailProfileId WHERE Id = @JobId
	

END
GO
