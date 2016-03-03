SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[sp_check_company_database_deletable] @CompanyID VARCHAR(10)
AS BEGIN

	DECLARE @DB VARCHAR(50)

	SELECT @DB = RemoteDatabase FROM KEYSTONE.dbo.COMPANY WHERE COMPANYID = @CompanyID

	IF EXISTS(SELECT 1 FROM sys.databases s WHERE s.name = @DB)
		SELECT -1 as result
	ELSE
		SELECT 0 as result

END
GO
