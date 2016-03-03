SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[sp_rebuild_emailprofile] @EmailProfileId int, @MailPart varchar(3) = null
AS
BEGIN

	DECLARE @To VARCHAR(MAX) = '', @cc  VARCHAR(MAX) = '',  @bcc VARCHAR(MAX) = ''
	
	SELECT @To = @To + ea.Name+'<'+ea.Email+'>; '
	FROM EmailProfileAddresses epa 
	INNER JOIN EmailAddress ea ON epa.EmailAddressId = ea.Id
	WHERE epa.EmailProfileId = @EmailProfileId
	AND epa.MailPart = 'To'
	AND ea.Enabled = 1

	SELECT @Cc = @Cc + ea.Name+'<'+ea.Email+'>; '
	FROM EmailProfileAddresses epa 
	INNER JOIN EmailAddress ea ON epa.EmailAddressId = ea.Id
	WHERE epa.EmailProfileId = @EmailProfileId
	AND epa.MailPart = 'Cc'
	AND ea.Enabled = 1

	SELECT @bcc = @bcc + ea.Name+'<'+ea.Email+'>; '
	FROM EmailProfileAddresses epa 
	INNER JOIN EmailAddress ea ON epa.EmailAddressId = ea.Id
	WHERE epa.EmailProfileId = @EmailProfileId
	AND epa.MailPart = 'Bcc'
	AND ea.Enabled = 1	
	
	IF Len(@to) > 1 SET @To = LEFT(@To, Len(@To) - 1)
	IF Len(@cc) > 1 SET @Cc = LEFT(@Cc, Len(@Cc) - 1)
	IF Len(@Bcc) > 1 SET @bcc = LEFT(@Bcc, Len(@Bcc) - 1)

	IF @MailPart IS NULL OR @MailPart = 'To'
		UPDATE EmailProfile 
		SET MailTo = @To
		WHERE Id = @EmailProfileId

	IF @MailPart IS NULL OR @MailPart = 'Cc'
		UPDATE EmailProfile 
		SET Cc = @cc
		WHERE Id = @EmailProfileId

	IF @MailPart IS NULL OR @MailPart = 'Bcc'
		UPDATE EmailProfile 
		SET Bcc = @bcc
		WHERE Id = @EmailProfileId
	

END
GO
