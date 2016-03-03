SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_update_user_application] 
@ID int = null,
@SingleSignInCode varchar(100),
@App_Type varchar(50) = null,
@DB_Server varchar(100)= null,
@DB_Name varchar(100),
@DB_Username varchar(100)= null,
@DB_Password varchar(100)= null,
@CompanyID varchar(10),
@Company varchar(50),
@ApplicationPath varchar(255),
@Location varchar(10)

AS
BEGIN

	IF @App_Type IS NULL SET @App_Type = 'CONTROL'
	IF @DB_Server IS NULL SET @DB_Server = 'PPG-SQL-01'
	IF @DB_Username IS NULL SET @DB_Username= 'ppg_user'
	IF @DB_Password IS NULL SET @DB_Password= 'Temp@123'
	
	IF IsNull(@ID, -1) = -1
		INSERT INTO KEYSTONE.dbo.USER_APPLICATIONS
		(SingleSignInCode, App_Type, DB_Server, DB_Name, DB_Username, DB_Password, CompanyID,
		Company, ApplicationPath, Location)
		VALUES (@SingleSignInCode, @App_Type, @DB_Server, @DB_Name, @DB_Username, @DB_Password, 
		@CompanyID, @Company, @ApplicationPath, @Location)
	ELSE
		UPDATE KEYSTONE.dbo.USER_APPLICATIONS
		SET 
			SingleSignInCode = @SingleSignInCode,
			App_Type =  @App_Type,
			DB_Server = @DB_Server, 
			DB_Name = @DB_Name, 
			DB_Username = @DB_Username, 
			DB_Password =  @DB_Password, 
			CompanyID = @CompanyID,
			Company = @Company,
			ApplicationPath = @ApplicationPath,
			Location = @Location
		WHERE ID = @ID

END
GO
