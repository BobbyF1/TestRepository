SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[sp_rebuild_emailprofiles_for_addressid] @EmailAddressId int
AS
BEGIN

	DECLARE @EmailProfileId int, @MailPart varchar(3)

	DECLARE rebuildProfiles CURSOR FOR 
	SELECT DISTINCT EmailProfileId, MailPart
	FROM EmailProfileAddresses
	WHERE EmailAddressId = @EmailAddressId
	
	OPEN rebuildProfiles
	FETCH rebuildProfiles INTO @EmailProfileId, @MailPart
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		Print 'Rebuild ' 
		Print cast (@EmailProfileId as varchar(4)) 
		Print @Mailpart
		EXEC [sp_rebuild_emailprofile] @EmailProfileId = @EmailProfileId, @MailPart = @MailPart
		FETCH rebuildProfiles INTO @EmailProfileId, @MailPart	
	END

	CLOSE rebuildProfiles 
	DEALLOCATE rebuildProfiles 

END
GO
