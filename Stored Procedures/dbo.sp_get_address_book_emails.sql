SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_address_book_emails] @EmailCoId int
as
BEGIN

	SELECT ID,
			EmailCoId,
			Name,
			Email,
			Enabled
	FROM EmailAddress
	WHERE EmailCoId = @EmailCoId
	ORDER BY Id

END
GO
