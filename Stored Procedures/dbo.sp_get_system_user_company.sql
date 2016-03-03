SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_get_system_user_company] @CompanyId VARCHAR(10)
As BEGIN

	SELECT [COMPANYID]
		  ,[COMPANY]
		  ,[REMOTESERVER]
		  ,[REMOTEDATABASE]
		  ,[USERNAME]
		  ,[PASSWORD]
		  ,cast([GL] as bit) as GL
		  ,cast([AP] as bit) as AP
		  ,cast([AR] as bit) as AR
		  ,cast([OE] as bit) as OE
		  ,cast([CM] as bit) as CM
		  ,cast([CM1] as bit) as CM1
		  ,cast([CM2] as bit) as CM2
		  ,cast([CM3] as bit) as CM3
		  ,cast([IP] as bit) as IP
		  ,cast([FB] as bit) as FB
		  ,cast([PS] as bit) as PS
		  ,cast([SM] as bit) as SM
		  ,cast([PR] as bit) as PR
		  ,cast([BQ] as bit) as BQ
		  ,cast([HM] as bit) as HM
		  ,cast(IsNull(PRODUCTKEY, 0) as bit) as PRODUCTKEY
		  ,cast(IsNull(USERS, 0) as bit) as USERS
	  FROM [KEYSTONE].[dbo].[COMPANY]
	  WHERE COMPANYID = @CompanyId

END
GO
