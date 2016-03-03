CREATE TABLE [dbo].[EmailAddress]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[EmailCoId] [int] NOT NULL,
[Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Email] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Enabled] [bit] NOT NULL CONSTRAINT [DF_EmailAddress_Enabled] DEFAULT ((1)),
[last_updated_date] [datetime] NULL CONSTRAINT [DF_EmailAddress_last_updated_date] DEFAULT (getdate()),
[creation_date] [datetime] NULL CONSTRAINT [DF_EmailAddress_creation_date] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmailAddress] ADD CONSTRAINT [PK__EmailAdd__3214EC07253C7D7E] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_EmailAddress_Co] ON [dbo].[EmailAddress] ([EmailCoId]) ON [PRIMARY]
GO
