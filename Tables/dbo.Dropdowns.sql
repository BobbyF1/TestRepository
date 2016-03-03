CREATE TABLE [dbo].[Dropdowns]
(
[DropDownName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DisplayAs] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SortOrder] [int] NULL
) ON [PRIMARY]
GO
