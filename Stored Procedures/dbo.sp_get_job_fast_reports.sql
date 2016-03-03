SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_job_fast_reports]
	@JobId int
As
BEGIN

	select 
		fr.Id,
		fr.Description,
		@JobId as JobId,
		IsNull(jd.SaveAs,'PDF') as SaveAs,
		IsNull(jd.TargetFilename, '') as TargetFilename,
		CAST ( CASE WHEN jd.JobId IS NULL THEN 0 ELSE 1 END as bit) as Checked
	from FastReport fr LEFT OUTER JOIN JobReportDetail jd
	ON fr.Id = jd.ReportId AND jd.JobId = @JobId
	WHERE fr.Enabled = 'Y'
END
GO
