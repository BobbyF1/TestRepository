SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_get_dropdown] @DropDownName varchar(20) = 'Database Name'
AS
BEGIN
	SELECT DropDownName, Value, DisplayAs
	FROM Dropdowns
	WHERE DropDownName = @DropDownName
	ORDER BY SortOrder, DisplayAs

END
GO
