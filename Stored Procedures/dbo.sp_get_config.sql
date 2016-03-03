SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_get_config]
as
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Get Config options
-- v02 11/08/2015 PF Added ServiceRestartEmailProfileId, ServiceShutdownEmailProfileId
-- v03 10/10/2015 PF Added MinFastReportPDFSize
---------------------------------------------------------------------------------------------------------  

BEGIN
	SELECT 
		[PollTimeSeconds] ,
		[ReportsDirectory] ,
		[DBUser] ,
		[DBPassword] ,
		[DBServer] ,
		[ReportTargetDirectory],
		[FromMailAddress] ,
		[FromMailName] ,
		[DefaultTimeOut] ,
		[FilenameDateFormat] ,
		[DelphiApplicationPath] ,
		[DefaultDelphiWaitTime] ,
		[DelphiPollResponseTime] ,
		[BCCAllReports] ,
		[DocumentPropsCreator] ,
		[DocumentPropsTitle] ,
		[DocumentPropsSubject] ,
		[DocumentPropsAuthors] ,
		[DocumentPropsProgramName] ,
		[DocumentPropsCompany] ,
		[MailInternallyOnly] ,
		[CheckListTimeout],
		SMTPClientTimeout,
		GlobalAlertEmailProfileId,
		LoyaltyTrackerTemplate,
		IsNull(ServiceRestartEmailProfileId, -1) as ServiceRestartEmailProfileId,
		IsNull(ServiceShutdownEmailProfileId, -1) as ServiceShutdownEmailProfileId,
		MinFastReportPDFSize
	FROM dbo.Config

END



GO
