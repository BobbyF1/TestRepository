SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[sp_get_spreadsheet_for_job] @JobId int 
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Get any spreadsheet reports that are part of this job
---------------------------------------------------------------------------------------------------------  

	DECLARE @SourceFolder varchar(MAX)

	SELECT @SourceFolder  = ReportsDirectory FROM dbo.Config

	SELECT s.id as SpreadsheetId,
		dbo.ufn_String_Dynamic( j.TargetFilename) as ReportTargetFilename,
		(Select ReportTargetDirectory FROM dbo.Config) + (SELECT ReportDatabaseName FROM dbo.Job WHERE Id = @JobId) as ReportTargetDirectory,
		(Select ReportTargetDirectory FROM dbo.Config) + (SELECT ReportDatabaseName FROM dbo.Job WHERE Id = @JobId) + '\' + dbo.ufn_String_Dynamic( j.TargetFilename) as ReportTargetFullFilename,
		(SELECT ReportDatabaseName FROM dbo.Job WHERE Id = @JobId) + '.' + SQLQuery  as SQLQuery,
		IsNull(s.OverrideDefaultTimeout, (SELECT DefaultTimeout from dbo.Config)) as Timeout,
		CASE IsNull(s.Description, '') WHEN '' THEN 'Report' ELSE IsNull(s.Description, '') END AS Description
	FROM dbo.JobSpreadsheetDetail j
	inner join dbo.Spreadsheet s on j.SpreadsheetId = s.Id 
	WHERE s.Enabled = 'Y'
	AND j.JobId = @JobId

END
GO
