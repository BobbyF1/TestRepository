CREATE TABLE [dbo].[EmailCo]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Enabled] [bit] NOT NULL CONSTRAINT [DF_EmailCo_Enabled] DEFAULT ((1)),
[last_updated_date] [datetime] NULL CONSTRAINT [DF_EmailCo_last_updated_date] DEFAULT (getdate()),
[creation_date] [datetime] NULL CONSTRAINT [DF_EmailCo_creation_date] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmailCo] ADD CONSTRAINT [PK__EmailCo__3214EC071E8F7FEF] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
