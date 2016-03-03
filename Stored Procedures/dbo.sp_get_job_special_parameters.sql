SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_get_job_special_parameters]
	@JobId int
As
BEGIN

	DECLARE @IDString varchar(256)
	
	SELECT @IDString = SpecialParameterId FROM Job WHERE Id = @JobId
	
	SELECT
		ID,
		IDString,
		IDParam,
		IDValue,
		IDValueDateTime
	FROM SpecialParameters
	WHERE IDString = @IDString
	
END
GO
