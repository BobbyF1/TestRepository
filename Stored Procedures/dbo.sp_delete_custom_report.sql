SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_delete_custom_report] @Id int
as
BEGIN

	DELETE FROM CustomReport WHERE Id = @Id 
	DELETE FROM CustomReportArgs WHERE CustomReportId = @Id 

END
GO
