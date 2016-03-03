SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_delphi_request_details]  @id int, @CallFromService bit = 0
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Get Fast Report request details
---------------------------------------------------------------------------------------------------------  

	IF @CallFromService = 0
		UPDATE FastReportRequest
		SET  DelphiRead = getdate()
		WHERE Id = @id

	SELECT 	[FullFilename] as FastReportFullFilename,
		[OutputFileType],
		[OutputFilename]
	FROM FastReportRequest
	WHERE Id = @id
	
END
GO
