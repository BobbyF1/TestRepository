SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_get_report_for_job] @JobId int 
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Get any due Fast Report reports.
---------------------------------------------------------------------------------------------------------  

	DECLARE @SourceFolder varchar(MAX)

	SELECT @SourceFolder  = ReportsDirectory FROM dbo.Config

	SELECT r.id as ReportId,
			r.FRFileName as Filename,
			CASE WHEN ForceFileFolder IS NULL THEN @SourceFolder + FRFileName ELSE ForceFileFolder + FRFileName	END as FullFilename
	FROM dbo.JobReportDetail j
	inner join dbo.FastReport r on j.reportId = r.Id 
	WHERE r.Enabled = 'Y' AND j.JobId = @JobId


END
GO
