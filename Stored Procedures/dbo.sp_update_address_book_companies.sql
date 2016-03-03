SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_update_address_book_companies]
		@Id int = null,
		@Name VARCHAR(256),
		@Enabled bit

as
BEGIN

IF EXISTS(SELECT 1 FROM EmailCo WHERE Id = @Id)
	UPDATE EmailCo
	SET Name = @Name,
		Enabled = @Enabled
	WHERE ID = @Id
ELSE
	INSERT INTO EmailCo(Name, Enabled)
	VALUES (@Name, @Enabled)
	
END
GO
