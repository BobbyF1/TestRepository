SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_delete_fast_report] @Id int
as
BEGIN

	DELETE FROM ReportArgs WHERE ReportId = @Id
	DELETE FROM FastReport WHERE Id = @Id

END
GO
