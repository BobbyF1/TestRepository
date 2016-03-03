SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_get_argument_values] @IncludeNoneValue bit = 1
As BEGIN

	SELECT	
		ID, Description
	FROM ArgumentValues 
	UNION 
	SELECT -1, '<None>'
	WHERE @IncludeNoneValue = 1
	ORDER BY Description

END
GO
