SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_job_custom_reports]
	@JobId int
As
BEGIN

	select 
		fr.Id,
		fr.Name,
		fr.Description,
		@JobId as JobId,
		IsNull(jc.TargetFilename, '') as TargetFilename,
		CAST ( CASE WHEN jc.JobId IS NULL THEN 0 ELSE 1 END as bit) as Checked
	from CustomReport fr LEFT OUTER JOIN JobCustomReportDetail jc
	ON fr.Id = jc.CustomReportId AND jc.JobId = @JobId
	WHERE fr.Enabled = 'Y'
END
GO
