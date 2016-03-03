SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_create_job_special_parameter]
	@JobId int ,
	@IDParam varchar(256),
	@IDValue varchar(256),
	@IDValueDateTime datetime = null
As
BEGIN

	DECLARE @IDString varchar(256)
	
	SELECT @IDString = SpecialParameterId FROM Job WHERE ID = @JobId
	
	IF @IDString IS NULL RETURN

	INSERT INTO SpecialParameters(IDString, IDParam, IDValue, IDValueDateTime)
	VALUES (@IDString, @IDParam, @IDValue, @IDValueDateTime)

END
GO
