SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_address_book_companies]
as
BEGIN

	SELECT
		Id,
		Name,
		Enabled
	FROM EmailCo
	ORDER BY Id

END
GO
