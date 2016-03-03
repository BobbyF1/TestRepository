SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_get_custom_report_parameters] @CustomReportId int, @JobId int
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Get parameters for a given Custom Report
-- v02 26/03/2015 PF Also get Special Parameter
-- v03 20/08/2015 PF Introduce CustomReportArgs.ArgValue
---------------------------------------------------------------------------------------------------------  
	SELECT 
		a.CustomReportId,
		a.Sequence,
		a.Name as ArgumentName,
		a.DataType,
		IsNull(av.Description, 'Hard coded ' + a.Name + ' ' + IsNull(dbo.ufn_Report_Parameters (@JobId, a.ArgValueId, a.ArgValue), 'NULL') ) as ArgumentDescription,
		dbo.ufn_Report_Parameters (@JobId, a.ArgValueId, a.ArgValue) as ArgumentValue, 
		(SELECT SpecialParameterId FROM Job WHERE Id = @JobId) as SpecialParameter
		INTO #Work		
	FROM dbo.CustomReportArgs a LEFT OUTER join dbo.ArgumentValues av on a.ArgValueId = av.Id
	WHERE a.CustomReportId = @CustomReportId

	DECLARE @ConnString varchar(max), @DB varchar(100), @DBUser varchar(100), @DBServer varchar(100), @DBPassword varchar(100)
	SELECT @DB = ReportDatabaseName FROM dbo.Job WHERE Id = @JobId
	SELECT @DBUser = DBUser, @DBPassword = DBPassword , @DBServer = DBServer FROM dbo.Config
	SELECT @ConnString = 'Data Source=' + @DBServer+';Initial Catalog=' + @DB+';Integrated Security=False;User ID=' + @DBUser+';Password='+@DBPassword

	UPDATE #Work
	SET ArgumentValue = @ConnString
	WHERE ArgumentDescription = 'Connection String'

	SELECT * from #work order by CustomReportId, Sequence

END
GO
