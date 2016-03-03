CREATE TABLE [dbo].[FastReportRequest]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[JobId] [int] NOT NULL,
[ReportId] [int] NOT NULL,
[FullFilename] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OutputFileType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OutputFilename] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NULL,
[StatusChanged] [datetime] NULL,
[DelphiRead] [datetime] NULL,
[DelphiMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[creation_date] [datetime] NOT NULL CONSTRAINT [DF_FastReportRequest_creation_date] DEFAULT (getdate()),
[last_updated_date] [datetime] NOT NULL CONSTRAINT [DF_FastReportRequest_last_updated_date] DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[FastReportRequest] ADD CONSTRAINT [PK_FastReportRequest] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
