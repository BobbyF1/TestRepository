SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[sp_clone_company] @CloneCompanyId varchar(10), @NewCompanyName varchar(50), @NewDatabaseName varchar(50)
AS
BEGIN

	DECLARE @NewId VARCHAR(50)
	
	SELECT @NewId = CAST ( 1 + MAX(CAST (CompanyId as INT)) as VARCHAR(10)) FROM KEYSTONE.dbo.COMPANY
	
	INSERT INTO [KEYSTONE].[dbo].[COMPANY]
           ([COMPANYID]           ,[COMPANY]           ,[REMOTESERVER]           ,[REMOTEDATABASE]           ,[USERNAME]           ,[PASSWORD]           ,[GL]
           ,[AP]           ,[AR]           ,[OE]           ,[CM]           ,[CM1]           ,[CM2]           ,[CM3]           ,[IP]           ,[FB]
           ,[PS]           ,[SM]           ,[PR]           ,[BQ]           ,[HM]           ,[PRODUCTKEY]           ,[USERS]           ,[VALID])
	SELECT @NewId, @NewCompanyName, [REMOTESERVER], @NewDatabaseName, [USERNAME]           ,[PASSWORD]           ,[GL]
           ,[AP]           ,[AR]           ,[OE]           ,[CM]           ,[CM1]           ,[CM2]           ,[CM3]           ,[IP]           ,[FB]
           ,[PS]           ,[SM]           ,[PR]           ,[BQ]           ,[HM]           ,[PRODUCTKEY]           ,[USERS]           ,[VALID]
	FROM KEYSTONE.dbo.COMPANY WHERE COMPANYID = @CloneCompanyId
	
	IF @@ERROR != 0	
		SELECT -1 AS Ret
	ELSE
		SELECT 1 AS Ret

END
GO
