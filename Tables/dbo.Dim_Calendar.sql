CREATE TABLE [dbo].[Dim_Calendar]
(
[Calendar_Key] [int] NOT NULL,
[Date] [date] NULL,
[Day_Of_Week] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Week_End_Date] [date] NULL,
[Week_Number] [smallint] NULL,
[Month_Char] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Month_Int] [smallint] NULL,
[Month_Day] [tinyint] NULL,
[Month_End_Date] [date] NULL,
[Month_End_I] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UK_Holiday] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Weekend] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quarter] [smallint] NULL,
[Calendar_Year] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dim_Calendar] ADD CONSTRAINT [PK_Dim_Calendar] PRIMARY KEY CLUSTERED  ([Calendar_Key]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
