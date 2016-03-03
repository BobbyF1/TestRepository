SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_insert_argument_values] @Description varchar(512)
As BEGIN

	DECLARE @Id int
	
	SELECT @Id = 1 + IsNull(MAX(Id), 0) FROM ArgumentValues

	INSERT INTO ArgumentValues (Id, Description)
	VALUES(@Id, @Description)

END
GO
