SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_get_dropdown_names] 
AS
BEGIN
	SELECT DISTINCT DropDownName
	FROM Dropdowns
	ORDER BY DropDownName
END
GO
