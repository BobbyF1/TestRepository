SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_delphi_get_response] @id int
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Get details of a Fast Report request in the Delphi program
---------------------------------------------------------------------------------------------------------  

	SELECT	
	[JobId]
      ,[ReportId]
      ,[OutputFilename]
      ,IsNull([Status], 999) as Status
      ,[StatusChanged]
      ,[DelphiRead]
      ,[DelphiMessage]
	  FROM FastReportRequest WHERE id = @id


END
GO
