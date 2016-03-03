SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_get_email_details] @EmailProfileId int, @JobId int = -1
as
BEGIN

---------------------------------------------------------------------------------------------------------    
-- v02 09/02/2015 PF Strip trailing semicolon delimiters from email address lists
-- v03 25/08/2015 PF Override the email message if this is a job run with an email message override
---------------------------------------------------------------------------------------------------------    

	DECLARE @BCC Varchar(MAX), @AppendBCC VARCHAR(MAX), @InternalOnly bit
	
	SELECT @BCC = IsNull(Bcc, '')
	FROM dbo.EmailProfile p
	inner join dbo.SMTPProfile s on p.FromSMTPProfileId = S.Id	
	WHERE P.Id = @EmailProfileId
	
	SELECT @AppendBCC = IsNull(BCCAllReports, ''),
		@InternalOnly = IsNull(MailInternallyOnly, 0)
	FROM Config

	IF @AppendBCC <> '' 
	BEGIN
		IF @Bcc <> ''
		BEGIN
			IF @InternalOnly = 1
				SELECT @BCC = @AppendBCC
			ELSE
			BEGIN
				IF (Right(@BCC, 1) <> ';') 
					SELECT @BCC = RTRIM(@Bcc) + ';' + @AppendBCC
				ELSE
					SELECT @BCC = RTRIM(@Bcc)+ @AppendBCC
			END
		END
		ELSE
			SELECT @BCC = @AppendBCC	
	END

	SELECT 
		dbo.ufn_String_Dynamic(Subject) as Subject ,
		dbo.ufn_String_Dynamic(Message) as Message ,
		CASE WHEN @InternalOnly = 1 THEN @AppendBCC ELSE MailTo END as MailTo,
		FromSMTPProfileId ,
		CASE WHEN @InternalOnly = 1 THEN '' ELSE Cc END AS Cc,
		@Bcc as Bcc,
		S.Port,
		S.Server,
		S.Username,
		S.Password,
		S.UseSSL, 
		(SELECT FromMailAddress FROM dbo.Config) AS FromMailAddress,
		(SELECT FromMailName FROM dbo.Config) AS FromMailName
	INTO #Mail
	FROM dbo.EmailProfile p
	inner join dbo.SMTPProfile s on p.FromSMTPProfileId = S.Id	
	WHERE P.Id = @EmailProfileId
	
	--PF 25/08/2015 Override the email message if this is a job run with an email message override
	IF EXISTS (SELECT 1 FROM Job WHERE Id = @JobId AND NextRunMailComments IS NOT NULL)
	BEGIN
		UPDATE #Mail
		SET Message = (SELECT NextRunMailComments FROM Job WHERE Id = @JobId )
	END	

	--PF 09/02/2015 - strip trailing semicolon delimiters
	UPDATE #Mail SET MailTo = LEFT(MailTo, Len(MailTo) - 1) WHERE SUBSTRING(MAILTo, Len(MailTo), 1) = ';'	
	UPDATE #Mail SET CC = LEFT(Cc, Len(Cc) - 1) WHERE SUBSTRING(Cc, Len(Cc), 1) = ';'	
	UPDATE #Mail SET Bcc = LEFT(Bcc, Len(Bcc) - 1) WHERE SUBSTRING(Bcc, Len(Bcc), 1) = ';'	
	
	SELECT * FROM #Mail
	
END
GO
