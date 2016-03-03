SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROC [dbo].[sp_set_delphi_report_parameters] @ReportId int, @JobId int
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Record the parameters for a given Fast Report, so they can be 
--                   later requested by the Delphi program 
---------------------------------------------------------------------------------------------------------  

	DECLARE @id int

	INSERT INTO FastReportRequest (JobId, ReportId, FullFilename, OutputFileType, OutputFilename, Status, StatusChanged,
		DelphiRead, DelphiMessage)
	SELECT @JobId, @ReportId, ISNULL(fr.ForceFileFolder, (SELECT ReportsDirectory FROM Config)) + fr.FRFileName,
		'PDF', 
		(Select ReportTargetDirectory FROM dbo.Config) + j.ReportDatabaseName + '\' + dbo.ufn_String_Dynamic( jd.TargetFilename),
		NULL, NULL, NULL, NULL		
	FROM FastReport fr inner join JobReportDetail jd on jd.ReportId = fr.Id
	inner join Job j on j.Id = jd.JobId
	WHERE j.Id = @JobId and jd.ReportId = @ReportId
	
	SELECT  @id = SCOPE_IDENTITY() 
	
	INSERT INTO FastReportRequestArgs( FastReportRequestId, Sequence , ArgumentName , ArgumentDesc , ArgumentType,
	ArgumentValue , SupplyArgument , DelphiRead)
	SELECT @id, ra.Sequence, 'var'+convert(varchar(5), ra.Sequence), IsNull(ra.Name, ''), ra.DataType, 
		dbo.ufn_Report_Parameters (@JobId, ArgValueId, ArgValue), 'Y', NULL
	FROM ReportArgs ra
	WHERE ReportId = @ReportId
	
	SELECT @id as ReturnValue

END
GO
