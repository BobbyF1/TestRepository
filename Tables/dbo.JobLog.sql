CREATE TABLE [dbo].[JobLog]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[JobId] [int] NOT NULL,
[JobStartTime] [datetime] NULL,
[Status] [int] NOT NULL,
[MailSendTime] [datetime] NULL,
[CallbackConfirmed] [datetime] NULL,
[creation_date] [datetime] NOT NULL CONSTRAINT [DF_JobLog_creation_date] DEFAULT (getdate()),
[last_updated_date] [datetime] NOT NULL CONSTRAINT [DF_JobLog_last_updated_date] DEFAULT (getdate()),
[ErrorTime] [datetime] NULL,
[ErrorMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobLog] ADD CONSTRAINT [PK_JobLog] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
