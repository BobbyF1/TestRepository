SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_delete_address_book_company] @Id int
as
BEGIN

	DELETE FROM EmailCo WHERE Id = @Id 
	DELETE FROM EmailProfileAddresses WHERE EmailAddressId IN (SELECT Id FROM EmailAddress WHERE EmailCoId = @Id)
	DELETE FROM EmailAddress WHERE EmailCoId = @id

END
GO
