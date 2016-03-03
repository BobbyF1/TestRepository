SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[sp_delete_job] @JobId INTEGER, @Confirm bit = 0 
AS
BEGIN

---------------------------------------------------------------------------------------------------------    
-- v01 15/09/2015 PF Initial Version.     
---------------------------------------------------------------------------------------------------------    

	IF NOT EXISTS(SELECT 1 FROM Job WHERE Id = @JobId)
	BEGIN
		Print 'Job doesn''t exist.'
		RETURN
	END

	BEGIN TRAN
	
	DELETE FROM Job WHERE Id = @JobId
	
	DELETE FROM JobReportDetail WHERE JobId = @JobId
	
	DELETE FROM JobSpreadsheetDetail WHERE JobId = @JobId

	DELETE FROM JobCustomReportDetail WHERE JobId = @JobId
	
	DELETE FROM JobSchedule WHERE JobId = @JobId

	DELETE FROM JobCheckList WHERE JobId = @JobId

	IF @Confirm = 1
	BEGIN
		COMMIT 
		Print 'Done.'
	END
	ELSE
	BEGIN
		ROLLBACK
		Print 'Rolled back.'
	END
END
GO
