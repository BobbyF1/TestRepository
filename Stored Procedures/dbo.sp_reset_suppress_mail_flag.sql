SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[sp_reset_suppress_mail_flag] @JobId int
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/09/2015 PF Original Version. 
---------------------------------------------------------------------------------------------------------  

	UPDATE Job SET SuppressMailSendNextRun = 0 WHERE Id = @JobId
END
GO
