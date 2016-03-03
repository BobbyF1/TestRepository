SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_get_document_properties] 
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Get document properties to put on generated Excel spreadsheets
---------------------------------------------------------------------------------------------------------  

	SELECT 
		DocumentPropsCreator ,
		DocumentPropsTitle ,
		DocumentPropsSubject ,
		DocumentPropsAuthors ,
		DocumentPropsProgramName ,
		DocumentPropsCompany
	FROM CONFIG

END
GO
