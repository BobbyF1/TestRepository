CREATE TABLE [dbo].[FastReportRequestArgs]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[FastReportRequestId] [int] NOT NULL,
[Sequence] [smallint] NOT NULL,
[ArgumentName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ArgumentDesc] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ArgumentType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ArgumentValue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SupplyArgument] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DelphiRead] [datetime] NULL,
[creation_date] [datetime] NOT NULL CONSTRAINT [DF_FastReportRequestArgs_creation_date] DEFAULT (getdate()),
[last_updated_date] [datetime] NOT NULL CONSTRAINT [DF_FastReportRequestArgs_last_updated_date] DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[FastReportRequestArgs] ADD CONSTRAINT [PK_FastReportRequestArgs] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
