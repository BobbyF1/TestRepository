SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_add_dropdown] @DropDownName VARCHAR(20) , @Value VARCHAR(100), @DisplayAs VARCHAR(100) 
AS
BEGIN

	IF IsNull(@DisplayAs, '') = ''
		SELECT 0 AS RetValue
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM DropDowns WHERE DropDownName = @DropDownName
				AND Value = @Value)
			SELECT 0 AS RetValue
		ELSE
		BEGIN
			INSERT INTO DropDowns (DropDownName, Value, DisplayAs)
			VALUES (@DropDownName, @Value, @DisplayAs)
			SELECT 1 AS RetValue
		END
	END
END
GO
