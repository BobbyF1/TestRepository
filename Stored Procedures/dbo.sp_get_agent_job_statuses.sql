SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_get_agent_job_statuses]
	@Days int = -1,
	@FromDateTime datetime = null,
	@Status int = -1,
	@JobId uniqueidentifier = null, 
	@SinceLastRun bit = 0,
	@ServerName nvarchar(100)
as
BEGIN
---------------------------------------------------------------------------------------------------------    
-- v01 17/08/2015 PF Initial Version.     
-- v02 21/09/2015 PF Log the command we're running
---------------------------------------------------------------------------------------------------------    

	SET NOCOUNT ON 

	DECLARE @StartDateTime DATETIME
	SELECT @StartDateTime = GETDATE()

	IF @SinceLastRun = 1
	BEGIN
		SELECT @FromDateTime = IDValueDateTime FROM SpecialParameters 
		WHERE IDString = 'sp_get_agent_job_statuses' 
		AND IDParam = @ServerName
		IF @@ROWCOUNT = 0 
		BEGIN
			SET @FromDateTime = DateAdd(dd, -1, getdate())
			INSERT INTO SpecialParameters (IDString, IDParam, IDValueDateTime)
			VALUES ('sp_get_agent_job_statuses' , @Servername, @FromDateTime)
		END
	END
	


	DECLARE @cmd NVARCHAR(MAX)

	IF OBJECT_ID ('tempdb..##temptable') IS NOT NULL DROP TABLE ##temptable

	SET @cmd = 'SELECT * INTO ##temptable FROM OPENQUERY (' + @ServerName+',''SELECT * FROM msdb.dbo.[ufn_GetJobHistory](' + 
		CAST(@days AS VARCHAR(4)) + ', '+
		CASE WHEN @FromDateTime IS NULL THEN 'null, ' ELSE '''''' + CONVERT(VARCHAR(26), @FromDateTime, 120)+''''', ' END+
		CAST (@Status AS VARCHAR(5)) + ', ' +
		CASE WHEN @JobId IS NULL THEN 'null ' ELSE '''' + CONVERT(VARCHAR(40), @JobId) + ''' ' END+
		')'')'
	SET @cmd =  REPLACE(@cmd, N'<server>', @ServerName)

	EXEC [svc].[sp_save_service_log] @Source = 'Keystone.Services.ReportEngine', 
									@SubSource = 'dbo.sp_get_agent_job_statuses',
									@Severity = 0,
									@Detail = 'Checking for job failures',
									@LongDescription = @cmd , @Type = '', @Exception = ''

	PRINT @cmd
	EXEC(@cmd)

	DELETE FROM ##temptable WHERE jobid IN
		(SELECT IDValue FROM SpecialParameters 
		WHERE IDString = 'sp_get_agent_job_statuses' AND IDParam = 'Omit Job Id')

	SELECT * FROM ##temptable ORDER BY [Run Time]
	DROP TABLE ##temptable

	IF @SinceLastRun = 1
	BEGIN	
		UPDATE SpecialParameters 
		SET IDValueDateTime = @StartDateTime
		WHERE IDString = 'sp_get_agent_job_statuses' 
		AND IDParam = @ServerName
	END

END
GO
