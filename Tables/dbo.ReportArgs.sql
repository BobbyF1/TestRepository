CREATE TABLE [dbo].[ReportArgs]
(
[ReportId] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ArgValueId] [int] NULL,
[creation_date] [datetime] NOT NULL CONSTRAINT [DF_ReportArgs_creation_date] DEFAULT (getdate()),
[last_updated_date] [datetime] NOT NULL CONSTRAINT [DF_ReportArgs_last_updated_date] DEFAULT (getdate()),
[ArgValue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[trg_ReportArgs_updated]
ON [dbo].[ReportArgs]
FOR UPDATE
AS
--start_autogenerated_trigger_text  - do not edit comments or code!
IF (suser_name() = 'svc_sync_user') OR (suser_name() = 'svc_agent_user')  RETURN
--end_autogenerated_trigger_text

BEGIN

 SET NOCOUNT ON 

 UPDATE dbo.ReportArgs SET dbo.ReportArgs.last_updated_date = GETDATE()
 FROM inserted
 WHERE inserted.ReportId = dbo.ReportArgs.ReportId

END
GO
ALTER TABLE [dbo].[ReportArgs] ADD CONSTRAINT [PK_ReportArgs] PRIMARY KEY CLUSTERED  ([ReportId], [Sequence]) ON [PRIMARY]
GO