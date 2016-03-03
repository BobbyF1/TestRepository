SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [dbo].[sp_get_head_office_refresh_types] as
BEGIN

	SELECT RefreshType, Command
	FROM DataRefreshTypes
	ORDER BY RefreshType

END
GO
