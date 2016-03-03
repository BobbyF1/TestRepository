SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_get_job] @JobId int
as
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Get Config options
-- v02 21/03/2015 PF Remove ScheduleId
---------------------------------------------------------------------------------------------------------  

BEGIN
	SELECT 
		[Id] ,
		[Name] ,
		[Enabled] ,
		[EmailProfileId] ,
		[AlertEmailProfileId] ,
		[ChecksDatabaseName] ,
		[LastRun] ,
		[NextRun] ,
		[TryUntil] ,	
		[IgnoreChecksNextRun] ,
		[creation_date] ,
		[last_updated_date] ,
		[ReportDatabaseName]
	FROM dbo.Job WHERE Id = @JobId

END
GO
