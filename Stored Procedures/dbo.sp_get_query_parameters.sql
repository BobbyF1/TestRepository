SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--SpreadsheetArgs
CREATE PROC [dbo].[sp_get_query_parameters] @SpreadsheetId int, @JobId int
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Get parameters for a spreadsheet query
-- v02 20/08/2015 PF Introduce SpreadsheetArgs.ArgValue
---------------------------------------------------------------------------------------------------------  

	SELECT 
		a.SpreadsheetId,
		a.Sequence,
		a.Name as ArgumentName,
		a.DataType,
		IsNull(av.Description, 'Hard coded ' + a.Name + ' ' + IsNull(dbo.ufn_Report_Parameters (@JobId, a.ArgValueId, a.ArgValue), 'NULL') ) as ArgumentDescription,
		dbo.ufn_Report_Parameters (@JobId, a.ArgValueId, a.ArgValue) as ArgumentValue
		INTO #Work		
	FROM dbo.SpreadsheetArgs a LEFT OUTER join dbo.ArgumentValues av on a.ArgValueId = av.Id
	WHERE a.SpreadsheetId = @SpreadsheetId

	SELECT * from #work order by SpreadsheetId, Sequence

END
GO
