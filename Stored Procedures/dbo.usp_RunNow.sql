SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROC [dbo].[usp_RunNow] @JobId int, @IgnoreChecks bit = 0, @NextRunMailComments VARCHAR(MAX) = NULL, 
@SuppressMail bit = NULL
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Call this to run a job immediately
-- v02 25/08/2015 PF Add NextRunMailComments
-- v03 31/08/2015 PF Add SuppressMailSendNextRun
---------------------------------------------------------------------------------------------------------  
	UPDATE Job
	SET NextRun = getdate(), IgnoreChecksNextRun = @IgnoreChecks, NextRunMailComments = @NextRunMailComments, 
		SuppressMailSendNextRun = @SuppressMail 
	WHERE Id = @JobId
END
GO
