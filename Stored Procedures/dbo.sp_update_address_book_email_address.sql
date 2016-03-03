SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_update_address_book_email_address]
		@Id int = null,
		@EmailCoId int,
		@Name VARCHAR(256),
		@Email VARCHAR(256),
		@Enabled bit

as
BEGIN

IF EXISTS(SELECT 1 FROM EmailAddress WHERE Id = @Id AND EmailCoId = @EmailCoId)
BEGIN
	UPDATE EmailAddress
	SET Name = @Name,
		Email = @Email,
		Enabled = @Enabled
	WHERE ID = @Id AND @EmailCoId = @EmailCoId
	
	EXEC sp_rebuild_emailprofiles_for_addressid @EmailAddressId = @Id

END
ELSE
	INSERT INTO EmailAddress(EmailCoId, Name, Email, Enabled)
	VALUES (@EmailCoId, @Name, @Email, @Enabled)

	
END
GO
