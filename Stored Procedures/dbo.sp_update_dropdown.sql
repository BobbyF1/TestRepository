SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_update_dropdown] @DropDownName VARCHAR(20) , @OldValue VARCHAR(100), @NewValue VARCHAR(100) 
AS
BEGIN

	IF EXISTS (SELECT 1 FROM DropDowns WHERE DropDownName = @DropDownName
			AND Value = @NewValue)
		SELECT 0 AS RetValue
	ELSE
	BEGIN
		UPDATE DropDowns SET Value = @NewValue, DisplayAs = @NewValue 
		WHERE DropDownName = @DropDownName AND Value = @OldValue
		SELECT 1 AS RetValue
	END
END
GO
