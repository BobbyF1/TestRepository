CREATE TABLE [dbo].[FastReport]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[FRFileName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Enabled] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ForceFileFolder] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OverrideDefaultDelphiWait] [int] NULL,
[creation_date] [datetime] NOT NULL CONSTRAINT [DF_FastReport_creation_date] DEFAULT (getdate()),
[last_updated_date] [datetime] NOT NULL CONSTRAINT [DF_FastReport_last_updated_date] DEFAULT (getdate())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[trg_FastReport_updated]
ON [dbo].[FastReport]
FOR UPDATE
AS
--start_autogenerated_trigger_text  - do not edit comments or code!
IF (suser_name() = 'svc_sync_user') OR (suser_name() = 'svc_agent_user')  RETURN
--end_autogenerated_trigger_text

BEGIN

 SET NOCOUNT ON 

 UPDATE dbo.FastReport SET dbo.FastReport.last_updated_date = GETDATE()
 FROM inserted
 WHERE inserted.Id = dbo.FastReport.Id

END
GO
ALTER TABLE [dbo].[FastReport] ADD CONSTRAINT [CK_FastReport_ForceFileFolder] CHECK ((right([ForceFileFolder],(1))='\'))
GO
ALTER TABLE [dbo].[FastReport] ADD CONSTRAINT [PK_FastReport] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
