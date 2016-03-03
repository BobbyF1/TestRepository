SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_update_email_profile_description]
	@Id int = NULL,
	@Description varchar(512)
as
BEGIN
	UPDATE EmailProfile 
	SET Description = @Description
	WHERE Id = @Id
END
GO
