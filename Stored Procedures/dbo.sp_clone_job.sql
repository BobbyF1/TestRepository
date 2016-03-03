SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_clone_job] 
			@JobId INTEGER, 
			@NewSpecialParameterName VARCHAR(256) = NULL,
			@EmailCampaignFilename VARCHAR(256) = NULL,
			@EmailCampaignId INTEGER = NULL,
			@EmailCampaignReplyToAddress VARCHAR(256) = NULL
AS
---------------------------------------------------------------------------------------------------------  
-- v01 11/09/2015 PF Original Version
---------------------------------------------------------------------------------------------------------  

/*
e.g

EXEC [sp_clone_job] 
	@JobId = 22, 
	@NewSpecialParameterName = 'SpecialParameter999',
	@EmailCampaignFilename = 'TestFileName.xls',
	@EmailCampaignId = 123456,
	@EmailCampaignReplyToAddress = 'paul@here.com'
*/

BEGIN

	SET NOCOUNT ON 

	DECLARE @NewJobId INTEGER, @CurrentSpecialParameterName VARCHAR(256)

	IF NOT EXISTS (SELECT 1 FROM Job WHERE Id = @JobId)
	BEGIN
		Print 'The job doesn''t exist.'
		RETURN
	END

	INSERT INTO [Job]
           ([Name]
           ,[Enabled]
           ,[EmailProfileId]
           ,[AlertEmailProfileId]
           ,[ChecksDatabaseName]
           ,[LastRun]
           ,[NextRun]
           ,[TryUntil]
           ,[IgnoreChecksNextRun]
           ,[creation_date]
           ,[last_updated_date]
           ,[ReportDatabaseName]
           ,[SpecialParameterId]
           ,[SuppressCheckFailureAlert]
           ,[SuppressSendIfNoData]
           ,[NextRunMailComments]
           ,[SuppressMailSendNextRun])
	SELECT
			[Name]
           ,'N'
           ,[EmailProfileId]
           ,[AlertEmailProfileId]
           ,[ChecksDatabaseName]
           ,[LastRun]
           ,[NextRun]
           ,[TryUntil]
           ,[IgnoreChecksNextRun]
           ,GETDATE()
           ,GETDATE()
           ,[ReportDatabaseName]
           ,[SpecialParameterId]
           ,[SuppressCheckFailureAlert]
           ,[SuppressSendIfNoData]
           ,[NextRunMailComments]
           ,[SuppressMailSendNextRun]
	FROM Job WHERE Id = @JobId
	
	SELECT @NewJobId = @@IDENTITY	

	INSERT INTO [JobCheckList]
           ([JobId]
           ,[CheckId]
           ,[Enabled]
           ,[creation_date]
           ,[last_updated_date])
	SELECT @NewJobId
           ,[CheckId]
           ,[Enabled]
           ,GETDATE()
           ,GETDATE()
	FROM [JobCheckList]
	WHERE JobId = @JobId
	
	INSERT INTO [JobCustomReportDetail]
           ([JobId]
           ,[CustomReportId]
           ,[TargetFilename]
           ,[creation_date]
           ,[last_updated_date])
	SELECT @NewJobId
           ,[CustomReportId]
           ,[TargetFilename]
           ,GETDATE()
           ,GETDATE()
	FROM JobCustomReportDetail WHERE JobId = @JobId
	
	INSERT INTO [JobReportDetail]
           ([JobId]
           ,[ReportId]
           ,[SaveAs]
           ,[TargetFilename]
           ,[creation_date]
           ,[last_updated_date])
	SELECT @NewJobId
           ,[ReportId]
           ,[SaveAs]
           ,[TargetFilename]
           ,GETDATE()
           ,GETDATE()
	FROM JobReportDetail WHERE JobId = @JobId
	
	INSERT INTO [JobSchedule]
           ([JobId]
           ,[ScheduleId]
           ,[last_updated_date]
           ,[creation_date])
	SELECT  @NewJobId
           ,[ScheduleId]
           ,GETDATE()
           ,GETDATE()
	FROM JobSchedule WHERE JobId = @JobId
	
	INSERT INTO [JobSpreadsheetDetail]
           ([JobId]
           ,[SpreadsheetId]
           ,[TargetFilename]
           ,[creation_date]
           ,[last_updated_date])
	SELECT  @NewJobId
           ,[SpreadsheetId]
           ,[TargetFilename]
           ,GETDATE()
           ,GETDATE()
	FROM JobSpreadsheetDetail WHERE JobId = @JobId
	
	IF @NewSpecialParameterName IS NOT NULL
	BEGIN
		SELECT @CurrentSpecialParameterName = [SpecialParameterId]
		FROM Job WHERE Id = @JobId
		
		UPDATE Job SET SpecialParameterId = @NewSpecialParameterName
		WHERE Id = @NewJobId
		
		INSERT INTO [SpecialParameters]
			   ([IDString]
			   ,[IDParam]
			   ,[IDValue]
			   ,[creation_date]
			   ,[last_updated_date]
			   ,[IDValueDateTime])
		SELECT
				@NewSpecialParameterName
			   ,[IDParam]
			   ,[IDValue]
			   ,GETDATE()
			   ,GETDATE()
			   ,[IDValueDateTime]
           FROM SpecialParameters
           WHERE IDString = @CurrentSpecialParameterName
	END
	
	IF @EmailCampaignFilename IS NOT NULL
		UPDATE [JobCustomReportDetail] SET TargetFilename = @EmailCampaignFilename WHERE JobId = @NewJobId

	IF @EmailCampaignId IS NOT NULL
		UPDATE SpecialParameters SET IDValue = CAST (@EmailCampaignId  AS VARCHAR(10)) 
		WHERE IDString = @NewSpecialParameterName AND IDParam = 'CampaignId'
	
	IF @EmailCampaignReplyToAddress  IS NOT NULL
		UPDATE SpecialParameters SET IDValue = '%'+@EmailCampaignReplyToAddress+'%'
		WHERE IDString = @NewSpecialParameterName AND IDParam = 'Like Email Address'
	
	IF @EmailCampaignFilename IS NOT NULL OR @EmailCampaignId IS NOT NULL OR @EmailCampaignReplyToAddress IS NOT NULL
		UPDATE SpecialParameters SET IDValue = CONVERT(VARCHAR(8), GETDATE(), 112)
		WHERE IDString = @NewSpecialParameterName AND IDParam = 'Replies Start Date'
	
	
	EXEC sp_show_job @NewJobId
	 
END
GO
