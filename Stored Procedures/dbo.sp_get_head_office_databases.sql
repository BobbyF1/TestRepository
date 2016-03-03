SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [dbo].[sp_get_head_office_databases] as
BEGIN

	SELECT name FROM sys.databases
	WHERE name like '%HEAD%'
	AND name NOT LIKE '%_BACKUP_TABLES'

END
GO
