SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_job_detail] 
	@Id int
as
BEGIN

SELECT [Id]
      ,[Name]
      ,CAST ( CASE [Enabled] WHEN 'Y' then 1 ELSE 0 END as bit) as Enabled
      ,[EmailProfileId]
      ,[AlertEmailProfileId]
      ,[ChecksDatabaseName]
      ,[LastRun]
      ,[NextRun]
      ,[TryUntil]
      ,CAST ( IsNull(IgnoreChecksNextRun, 0) as bit) as [IgnoreChecksNextRun]
      ,[creation_date]
      ,[last_updated_date]
      ,[ReportDatabaseName]
      ,[SpecialParameterId]
      ,CAST ( IsNull(SuppressCheckFailureAlert, 0) as bit) as SuppressCheckFailureAlert
      ,CAST ( IsNull(SuppressSendIfNoData, 0) as bit) as SuppressSendIfNoData
      ,[NextRunMailComments]
      ,CAST ( IsNull(SuppressMailSendNextRun, 0) as bit) as SuppressMailSendNextRun
      ,[CategoryId]
  FROM [Job]
  WHERE Id = @Id

END
GO
