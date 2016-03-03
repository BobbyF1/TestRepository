SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_get_delphi_call]  @id int
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Get details for running the Delphi program
---------------------------------------------------------------------------------------------------------  
	DECLARE @Wait int
	SELECT @Wait = OverrideDefaultDelphiWait 
	FROM FastReport fr inner join FastReportRequest frr on fr.id = frr.ReportId
	and frr.id = @id
	
	IF @Wait IS NULL SELECT @Wait = DefaultDelphiWaitTime FROM Config

	SELECT DelphiApplicationPath ,
		convert(varchar(5), @id) as Arg,
		@Wait as WaitTime, 
		DelphiPollResponseTime
	FROM Config

	
END
GO
