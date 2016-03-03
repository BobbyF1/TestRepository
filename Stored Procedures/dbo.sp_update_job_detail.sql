SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_update_job_detail] 
@Id			int,
@Name		varchar(256),
@Enabled	bit = null,
@EmailProfileId	int = null,
@AlertEmailProfileId	int = null,
@ChecksDatabaseName	varchar(256) = null,
@LastRun	datetime = null,
@NextRun	datetime = null,
@TryUntil	datetime = null,
@IgnoreChecksNextRun	bit = null,
@Creation_Date datetime = null,
@last_updated_date datetime = null,
@ReportDatabaseName	varchar(256) = null,
@SpecialParameterId	varchar(256) = null,
@SuppressCheckFailureAlert	int = null,
@SuppressSendIfNoData	bit = null,
@NextRunMailComments	varchar(max) = null,
@SuppressMailSendNextRun	bit = null,
@CategoryId	int = null
as
BEGIN

IF @EmailProfileId IS NULL SELECT @EmailProfileId = EmailProfileId FROM Job WHERE Id = @Id
IF @AlertEmailProfileId IS NULL SELECT @AlertEmailProfileId = EmailProfileId FROM Job WHERE Id = @Id
IF @CategoryId IS NULL SELECT @CategoryId = CategoryId FROM Job WHERE Id = @Id
IF @TryUntil = '1900-1-1' SET @TryUntil = NULL

UPDATE [Job]
   SET [Name] = @Name
      ,[Enabled] = CASE @Enabled WHEN 1 THEN 'Y' ELSE 'N' END
      ,[EmailProfileId] = @EmailProfileId
      ,[AlertEmailProfileId] = @AlertEmailProfileId
      ,[ChecksDatabaseName] = @ChecksDatabaseName
      ,[LastRun] = @LastRun
      ,[NextRun] = @NextRun
      ,[TryUntil] = @TryUntil
      ,[IgnoreChecksNextRun] = @IgnoreChecksNextRun
      ,[ReportDatabaseName] = @ReportDatabaseName
      ,[SpecialParameterId] = @SpecialParameterId
      ,[SuppressCheckFailureAlert] = @SuppressCheckFailureAlert
      ,[SuppressSendIfNoData] = @SuppressSendIfNoData
      ,[NextRunMailComments] = @NextRunMailComments
      ,[SuppressMailSendNextRun] = @SuppressMailSendNextRun
      ,[CategoryId] = @CategoryId
 WHERE Id = @Id
END
 
GO
