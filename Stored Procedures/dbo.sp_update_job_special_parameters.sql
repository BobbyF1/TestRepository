SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[sp_update_job_special_parameters]
	@Id int = null,
	@IDString varchar(256),
	@IDParam varchar(256),
	@IDValue varchar(256),
	@IDValueDateTime datetime
As
BEGIN

	IF EXISTS (SELECT 1 FROM SpecialParameters WHERE ID = @Id)
		UPDATE SpecialParameters
		SET IDString = @IDString, IDParam = @IDParam, IDValue = @IDValue, IDValueDateTime = @IDValueDateTime
		WHERE ID = @ID
	ELSE
		INSERT INTO SpecialParameters(IDString, IDParam, IDValue, IDValueDateTime)
		VALUES (@IDString, @IDParam, @IDValue, @IDValueDateTime)

END
GO
