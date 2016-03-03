SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_get_user_applications] @UserName VARCHAR(100) = NULL, @CompanyId VARCHAR(10) = NULL, 
@ID int = null
AS
BEGIN


	SELECT [SingleSignInCode]
		  ,[App_Type]
		  ,[DB_Server]
		  ,UPPER([DB_Name]) AS DB_Name
		  ,[DB_Username]
		  ,[DB_Password]
		  ,u.[CompanyID]
		  ,u.[Company]
		  ,Lower([ApplicationPath]) as [ApplicationPath]
		  ,[ID]
		  ,[AppActive]
		  ,[Location]
		  ,c.COMPANY as COMPANYNAME
	  FROM [KEYSTONE].[dbo].[USER_APPLICATIONS] u INNER JOIN [KEYSTONE].[dbo].COMPANY c ON u.CompanyID = c.COMPANYID
	  WHERE (@UserName IS NULL OR SingleSignInCode LIKE '%'+@UserName+'%')
	  AND (@CompanyId IS NULL OR @CompanyId = '0' OR u.CompanyID = @CompanyId)
	  AND (@ID IS NULL OR ID = @ID)
	  ORDER BY SingleSignInCode
	

END
GO
