CREATE TABLE [dbo].[JobCheckList]
(
[JobId] [int] NOT NULL,
[CheckId] [int] NOT NULL,
[Enabled] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[creation_date] [datetime] NOT NULL CONSTRAINT [DF_JobCheckList_creation_date] DEFAULT (getdate()),
[last_updated_date] [datetime] NOT NULL CONSTRAINT [DF_JobCheckList_last_updated_date] DEFAULT (getdate())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[trg_JobCheckList_updated]
ON [dbo].[JobCheckList]
FOR UPDATE
AS
--start_autogenerated_trigger_text  - do not edit comments or code!
IF (suser_name() = 'svc_sync_user') OR (suser_name() = 'svc_agent_user')  RETURN
--end_autogenerated_trigger_text

BEGIN

 SET NOCOUNT ON 

 UPDATE dbo.JobCheckList SET dbo.JobCheckList.last_updated_date = GETDATE()
 FROM inserted
 WHERE inserted.JobId = dbo.JobCheckList.JobId

END
GO
ALTER TABLE [dbo].[JobCheckList] ADD CONSTRAINT [PK_JobCheckList] PRIMARY KEY CLUSTERED  ([JobId], [CheckId]) ON [PRIMARY]
GO