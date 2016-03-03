SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_email_profile_usage]
	@EmailProfileId int
As
BEGIN

insert into debug (message) values (CAST (@EmailProfileId as varchar(10)))

	SELECT jc.CatDesc as [Job Category], 
			ID as JobId,
			Name as [Job Name]
			
	FROM Job j
	INNER JOIN JobCategory jc on j.CategoryId = jc.CategoryId
	WHERE j.EmailProfileId = @EmailProfileId

END
GO
