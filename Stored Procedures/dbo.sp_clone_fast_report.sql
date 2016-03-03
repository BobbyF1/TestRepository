SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_clone_fast_report]
	@FastReportId int
as
BEGIN

	DECLARE @NewId int

	INSERT INTO FastReport (FRFileName, Enabled, ForceFileFolder, Description, OverrideDefaultDelphiWait)
	SELECT FRFileName, 'N', ForceFileFolder, '*CLONED* ' + Description, OverrideDefaultDelphiWait
	FROM FastReport WHERE Id = @FastReportId
	
	SET @NewId  = SCOPE_IDENTITY()
	
	INSERT INTO ReportArgs (ReportId, Sequence, Name, Description, DataType, ArgValueId, ArgValue)
	SELECT @NewId, Sequence, Name, Description, DataType, ArgValueId, ArgValue
	FROM ReportArgs WHERE ReportId = @FastReportId
	
END
GO
