CREATE TABLE [dbo].[EmailProfileAddresses]
(
[EmailProfileId] [int] NOT NULL,
[EmailAddressId] [int] NOT NULL,
[MailPart] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Enabled] [bit] NOT NULL CONSTRAINT [DF_EmailProfileAddresses_Enabled] DEFAULT ((1)),
[last_updated_date] [datetime] NULL CONSTRAINT [DF_EmailProfileAddresses_last_updated_date] DEFAULT (getdate()),
[creation_date] [datetime] NULL CONSTRAINT [DF_EmailProfileAddresses_creation_date] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmailProfileAddresses] ADD CONSTRAINT [CK_EmailProfileAddresses_MailPart] CHECK (([MailPart]='To' OR [MailPart]='Cc' OR [MailPart]='Bcc'))
GO
ALTER TABLE [dbo].[EmailProfileAddresses] ADD CONSTRAINT [PK__EmailPro__C9773CBE2BE97B0D] PRIMARY KEY CLUSTERED  ([EmailProfileId], [EmailAddressId], [MailPart]) ON [PRIMARY]
GO
