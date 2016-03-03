SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_job_spreadsheets]
	@JobId int
As
BEGIN

	select 
		fr.Id,
		fr.Description,
		@JobId as JobId,
		IsNull(js.TargetFilename, '') as TargetFilename,
		CAST ( CASE WHEN js.JobId IS NULL THEN 0 ELSE 1 END as bit) as Checked
	from Spreadsheet fr LEFT OUTER JOIN JobSpreadsheetDetail js
	ON fr.Id = js.SpreadsheetId AND js.JobId = @JobId
	WHERE fr.Enabled = 'Y'
END
GO
