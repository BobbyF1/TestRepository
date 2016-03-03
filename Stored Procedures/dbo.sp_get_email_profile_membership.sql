SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_email_profile_membership]
	@EmailProfileId int,
	@MailPart varchar(3)
As
BEGIN

	SELECT
		ec.Id as EmailCoId,
		ec.Name as EmailCo,
		@MailPart as EmailPart,
		ea.Name,
		ea.Email,
		ea.Id as EmailAddressId,
		CAST ( CASE WHEN epa.MailPart IS NULL THEN 0 ELSE 1 END as bit) as Checked
	FROM EmailCo ec INNER JOIN EmailAddress ea on ea.EmailCoId = ec.Id
	LEFT OUTER JOIN EmailProfileAddresses epa 
		ON epa.EmailProfileId = @EmailProfileId AND ea.Id = epa.EmailAddressId AND epa.MailPart = @MailPart
	WHERE ec.Enabled = 1
	AND ea.Enabled = 1
	ORDER BY EmailCo, ea.Name

END
GO
