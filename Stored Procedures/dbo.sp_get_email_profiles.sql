SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_email_profiles]
	@Id INT = null
as
BEGIN

	SELECT
		Id,
		Description, 
		Subject, 
		Message, 
		FromSMTPProfileId
	FROM EmailProfile
	WHERE (@Id IS NULL OR Id = @Id)
	ORDER BY Id

END
GO
