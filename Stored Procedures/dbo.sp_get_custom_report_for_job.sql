SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[sp_get_custom_report_for_job] @JobId int 
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Get any custom reports that are part of the current job
-- v02 26/03/2015 PF Add SpecialParameter
---------------------------------------------------------------------------------------------------------  

	DECLARE @SourceFolder varchar(MAX)

	SELECT @SourceFolder  = ReportsDirectory FROM dbo.Config

	SELECT s.id as CustomReportId,
		dbo.ufn_String_Dynamic (j.TargetFilename) as ReportTargetFilename,
		(Select ReportTargetDirectory FROM dbo.Config) + (SELECT ReportDatabaseName FROM dbo.Job WHERE Id = @JobId) as ReportTargetDirectory,
		(Select ReportTargetDirectory FROM dbo.Config) + (SELECT ReportDatabaseName FROM dbo.Job WHERE Id = @JobId)  + '\' + dbo.ufn_String_Dynamic (j.TargetFilename) as ReportTargetFullFilename,
		s.Name,
		(SELECT ReportDatabaseName FROM dbo.Job WHERE Id = @JobId) as DatabaseName,
		(SELECT SpecialParameterId FROM dbo.Job WHERE Id = @JobId) as SpecialParameter
	FROM dbo.JobCustomReportDetail j
	inner join dbo.CustomReport s on j.CustomReportId = s.Id 
	WHERE s.Enabled = 'Y'
	AND j.JobId = @JobId
	

	
END
GO
