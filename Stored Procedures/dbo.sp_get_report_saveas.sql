SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[sp_get_report_saveas] @JobId int, @ReportId int
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Get Save As details for a Fast Report report
---------------------------------------------------------------------------------------------------------  

	SELECT 
		dbo.ufn_String_Dynamic(TargetFilename) as ReportTargetFilename,
		(Select ReportTargetDirectory FROM dbo.Config) + (SELECT ReportDatabaseName FROM dbo.Job WHERE Id = @JobId) as ReportTargetDirectory,
		j.SaveAs
	FROM dbo.JobReportDetail j
	inner join dbo.FastReport r on j.reportId = r.Id 
	and j.ReportId = @ReportId
	and j.JobId = @JobId
	WHERE r.Enabled = 'Y'


END
GO
