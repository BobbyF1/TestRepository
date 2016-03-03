SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[sp_get_system_user_companies] @search VARCHAR(100) = ''
AS
BEGIN
	SELECT [COMPANYID]
		  ,[COMPANY]
		  ,[REMOTESERVER]
		  ,[REMOTEDATABASE]
	  FROM [KEYSTONE].[dbo].[COMPANY]
	WHERE @search = '' OR ( COMPANY LIKE '%' + @search + '%'  OR REMOTEDATABASE LIKE '%' + @search + '%' )
	ORDER BY CAST( COMPANYID as int)
END
GO
