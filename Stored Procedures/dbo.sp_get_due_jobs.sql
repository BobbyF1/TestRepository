SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_get_due_jobs]
as
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Return any jobs that are due to run now
-- v02 21/03/2015 PF Remove ScheduleId
-- v03 03/08/2015 PF Add SuppressCheckFailureAlert
-- v04 16/08/2015 PF Add SuppressSendIfNoData
-- v05 31/08/2015 PF Add SuppressMailSendNextRun
---------------------------------------------------------------------------------------------------------  

BEGIN
	SELECT 
	Id ,
	Name,
	EmailProfileId ,
	ChecksDatabaseName ,
	LastRun ,
	NextRun ,
	IsNull(AlertEmailProfileId, -1) as AlertEmailProfileId,
	ReportDatabaseName,
	IsNull(SuppressCheckFailureAlert, 0) as SuppressCheckFailureAlert,
	IsNull(SuppressSendIfNoData, 0) as SuppressSendIfNoData, 
	ISNULL(SuppressMailSendNextRun, 0) as SuppressMailSendNextRun
	FROM dbo.Job
	WHERE NextRun <= getdate()
	AND Enabled = 'Y'


END
GO
