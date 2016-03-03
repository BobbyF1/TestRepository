SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_job_email_details]
	@JobId int,
	@ErrorProfile bit = 0
As
BEGIN

	DECLARE @EmailProfileId int
	
	IF @ErrorProfile = 0
		SELECT @EmailProfileId = EmailProfileId FROM Job WHERE Id = @JobId
	ELSE
		SELECT @EmailProfileId = AlertEmailProfileId FROM Job WHERE Id = @JobId
	
	SELECT Id,
			Description,
			Subject,
			Message,
			MailTo,
			Cc,
			Bcc
	FROM EmailProfile
	WHERE Id = @EmailProfileId


END
GO
