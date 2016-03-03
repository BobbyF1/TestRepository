SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_update_argument_values] @Id int, @Description varchar(512)
As BEGIN

	UPDATE ArgumentValues SET Description = @Description WHERE Id = @Id

END
GO
