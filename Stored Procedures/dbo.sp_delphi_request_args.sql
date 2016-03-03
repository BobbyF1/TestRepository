SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_delphi_request_args]  @id int
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Retrieve parameters for a requested Fast Report report
---------------------------------------------------------------------------------------------------------  

	UPDATE FastReportRequestArgs
	SET  DelphiRead = getdate()
	WHERE FastReportRequestId = @id

	UPDATE FastReportRequest
	SET  DelphiRead = getdate()
	WHERE Id = @id

	SELECT 
		ArgumentName,
		ArgumentDesc,
		ArgumentType,
		ArgumentValue,
		SupplyArgument
	FROM FastReportRequestArgs
	WHERE FastReportRequestId = @id
	ORDER BY Sequence


END
GO
