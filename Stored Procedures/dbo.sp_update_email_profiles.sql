SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_update_email_profiles]
	@Id int = NULL,
	@Description varchar(512),
	@Subject varchar(max),
	@Message varchar(max),
	@FromSMTPProfileId int = null
as
BEGIN

	IF @Message IS NULL SET @Message = ''
	IF @Subject IS NULL SET @Subject = ''
	IF @FromSMTPProfileId IS NULL SET @FromSMTPProfileId = 1

	IF EXISTS (SELECT 1 FROM EmailProfile WHERE Id = @Id)
	BEGIN
	
		UPDATE EmailProfile 
		SET Description = @Description,
			Subject = @Subject, 
			Message = @Message,
			FromSMTPProfileId = @FromSMTPProfileId
		WHERE Id = @Id
	END
	ELSE
	BEGIN
	
		INSERT INTO EmailProfile (Description, Subject, Message, FromSMTPProfileId, MailTo, Cc, Bcc)
		VALUES (@Description, @Subject, @Message, @FromSMTPProfileId, '', '', '')
	
	END

END
GO
