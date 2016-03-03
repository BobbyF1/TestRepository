SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_spreadsheets]
as
BEGIN

	SELECT
		Id,
		SQLQuery,
		CAST (CASE Enabled WHEN 'Y' THEN 1 ELSE 0 END as bit) as Enabled,
		Description,
		IsNull(OverrideDefaultTimeout, 0) as OverrideDefaultTimeout
	FROM Spreadsheet
	ORDER BY Id

END
GO
