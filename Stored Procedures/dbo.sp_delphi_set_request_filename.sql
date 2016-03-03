SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_delphi_set_request_filename]  @id int, @Filename varchar(max)
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Set the filename to request that a Fast Report is saved as
---------------------------------------------------------------------------------------------------------  

	UPDATE FastReportRequest
	SET OutputFilename = @Filename WHERE Id = @id

END
GO
