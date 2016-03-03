SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_delphi_request_set_status]  @id int, @status int, @message varchar(max)
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Set status for the Delphi program's work
---------------------------------------------------------------------------------------------------------  
	
	UPDATE FastReportRequest
	SET 	Status = @status, 
		DelphiMessage = @message,
		StatusChanged = getdate()
	WHERE Id = @id

END
GO
