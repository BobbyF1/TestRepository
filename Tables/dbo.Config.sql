CREATE TABLE [dbo].[Config]
(
[PollTimeSeconds] [int] NOT NULL,
[ReportsDirectory] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DBUser] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DBPassword] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DBServer] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReportTargetDirectory] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FromMailAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FromMailName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DefaultTimeOut] [int] NOT NULL,
[FilenameDateFormat] [int] NOT NULL,
[DelphiApplicationPath] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DefaultDelphiWaitTime] [int] NOT NULL,
[DelphiPollResponseTime] [int] NOT NULL,
[BCCAllReports] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentPropsCreator] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentPropsTitle] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentPropsSubject] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentPropsAuthors] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentPropsProgramName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentPropsCompany] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MailInternallyOnly] [bit] NULL,
[CheckListTimeout] [int] NULL,
[SMTPClientTimeout] [int] NULL,
[GlobalAlertEmailProfileId] [int] NULL,
[LoyaltyTrackerTemplate] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceRestartEmailProfileId] [int] NULL,
[ServiceShutdownEmailProfileId] [int] NULL,
[MinFastReportPDFSize] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Config] ADD CONSTRAINT [CK_Config_ReportTargetDirectory] CHECK ((right([ReportTargetDirectory],(1))='\'))
GO
ALTER TABLE [dbo].[Config] ADD CONSTRAINT [CONFIG_Reports_Ends_Slash] CHECK ((right([ReportTargetDirectory],(1))='\'))
GO
