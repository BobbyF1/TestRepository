SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [svc].[sp_save_service_log]
	@Source VARCHAR(150),
	@SubSource VARCHAR(150),
	@Severity INT,
	@Detail NVARCHAR(50),
	@LongDescription NVARCHAR(MAX),
	@Type NVARCHAR(3),
	@Exception NVARCHAR(MAX) = ''
AS
BEGIN
	INSERT INTO svc.[service_log]
           ([source]
           ,[sub_source]
           ,[type]
           ,[severity]
           ,[detail]
		  ,long_description
           ,[exception]
           ,[creation_date])
     VALUES
           (@Source
           ,@SubSource
           ,@Type
           ,@Severity
           ,@Detail
 	   ,@LongDescription
           ,@Exception
           ,GETDATE())
END
GO
