CREATE TABLE [dbo].[debugschedule]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RunDailyTime] [time] NULL,
[RunDailyMon] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RunDailyTue] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RunDailyWed] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RunDailyThu] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RunDailyFri] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RunDailySat] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RunDailySun] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RepeatTryDuration] [int] NULL,
[RepeatTryPause] [int] NULL
) ON [PRIMARY]
GO
