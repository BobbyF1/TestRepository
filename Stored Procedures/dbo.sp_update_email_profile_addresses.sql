SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_update_email_profile_addresses]
	@EmailProfileId int,
	@EmailAddressId int,
	@MailPart varchar(3),
	@Enabled bit
As
BEGIN

	IF EXISTS(SELECT 1 FROM EmailProfileAddresses WHERE EmailProfileId = @EmailProfileId
		AND EmailAddressId = @EmailAddressId AND MailPart = @MailPart)
	BEGIN
		IF @Enabled = 0 
			DELETE FROM EmailProfileAddresses WHERE EmailProfileId = @EmailProfileId
				AND EmailAddressId = @EmailAddressId AND MailPart = @MailPart
	END
	ELSE
	BEGIN
		IF @Enabled = 1
			INSERT INTO EmailProfileAddresses(EmailProfileId, EmailAddressId, MailPart, Enabled)
			VALUES (@EmailProfileId, @EmailAddressId, @MailPart, @Enabled)
	END
END
GO
