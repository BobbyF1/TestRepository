CREATE TABLE [dbo].[CustomReportArgs]
(
[CustomReportId] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ArgValueId] [int] NULL,
[creation_date] [datetime] NOT NULL CONSTRAINT [DF_CustomReportArgs_creation_date] DEFAULT (getdate()),
[last_updated_date] [datetime] NOT NULL CONSTRAINT [DF_CustomReportArgs_last_updated_date] DEFAULT (getdate()),
[ArgValue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[trg_CustomReportArgs_updated]
ON [dbo].[CustomReportArgs]
FOR UPDATE
AS
--start_autogenerated_trigger_text  - do not edit comments or code!
IF (suser_name() = 'svc_sync_user') OR (suser_name() = 'svc_agent_user')  RETURN
--end_autogenerated_trigger_text

BEGIN

 SET NOCOUNT ON 

 UPDATE dbo.CustomReportArgs SET dbo.CustomReportArgs.last_updated_date = GETDATE()
 FROM inserted
 WHERE inserted.CustomReportId = dbo.CustomReportArgs.CustomReportId

END
GO
ALTER TABLE [dbo].[CustomReportArgs] ADD CONSTRAINT [PK_CustomReportArgs] PRIMARY KEY CLUSTERED  ([CustomReportId], [Sequence]) ON [PRIMARY]
GO