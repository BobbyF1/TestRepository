CREATE TABLE [svc].[service_log]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[creation_date] [datetime] NULL,
[source] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sub_source] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[severity] [int] NULL,
[detail] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[long_description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[exception] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [svc].[service_log] ADD CONSTRAINT [PK_FastReport] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
