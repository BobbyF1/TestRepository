SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_SMTP_Profiles]
as
BEGIN

	SELECT
		Id,
		IsNull(Description, '<Default>') as Description
	FROM SMTPProfile
	ORDER BY Id

END
GO
