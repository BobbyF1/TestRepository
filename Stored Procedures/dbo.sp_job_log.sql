SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[sp_job_log]
	@Id int = null,
	@LimitRows int = 20
AS
BEGIN
---------------------------------------------------------------------------------------------------------    
-- v01 15/09/2015 PF Initial Version.     
-- v02 05/02/2016 PF Add JobId to results, plus argument
---------------------------------------------------------------------------------------------------------    
	SELECT	TOP (@LimitRows)
			j.Id as JobId,
			j.Name, 
			l.JobStartTime,
			CASE Status WHEN 0 THEN 'Running' WHEN -1 THEN 'Error' WHEN 2 THEN 'Done' ELSE '???' END as Status,
			MailSendTime,
			CallbackConfirmed,
			ErrorTime,
			ErrorMessage
	FROM JobLog l LEFT OUTER JOIN Job j on l.JobId = j.Id
	WHERE (@Id IS NULL OR JobId = @Id)
	ORDER BY l.creation_date DESC
END
GO
