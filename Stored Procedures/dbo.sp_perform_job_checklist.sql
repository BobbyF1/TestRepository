SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[sp_perform_job_checklist] @JobId int
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Perform any checks necessary before a report can run
-- v02 04/02/2015 PF Exclude location 00 from CheckId 3 (stock counts are posted)
-- v03 10/02/2015 PF Exclude location 20 from CheckId 3 (stock counts are posted)
-- v04 03/08/2015 PF Added Check 4 - check for new CM_Applications rows
-- v05 15/08/2015 PF Added CHeck 5 - check for discount discrepencies for today
-- v06 29/10/2015 PF Check deleted = 0 on LOCATIONS
-- v07 08/12/2015 PF Pass @Full to discount discrepency check; also it wasn't checking yesterday's data
---------------------------------------------------------------------------------------------------------  

	DECLARE @Description varchar(256), @DB varchar(256), @IgnoreNextRun bit, @Rows int
	
	SELECT @DB = ChecksDatabaseName , @IgnoreNextRun = IgnoreChecksNextRun
	FROM Job 
	WHERE Id = @JobId
	
	IF @IgnoreNextRun = 1
	BEGIN

		DECLARE @LongDesc varchar(max)
		SELECT @LongDesc = 'JobId [' + convert(varchar(5), @JobId) +'] is set to ignore any checks on the next run ONLY.'
	
		EXEC [svc].[sp_save_service_log] @Source = 'Keystone.Services.ReportEngine',
		@SubSource = 'dbo.sp_perform_job_checklist', @Severity = 0, @Detail = 'Checks IGNORED', 	
		@LongDescription = @LongDesc, @Type = 'svc'

		UPDATE Job 
		SET IgnoreChecksNextRun = 0 
		WHERE Id = @JobId
	
		SELECT 0 AS Result, 0 as CheckId , 'None' as Description, 'OK' as CheckResult
		RETURN

	END	
	

	SELECT j.CheckId, c.Description, convert(varchar(256), null) as CheckResult
	into #Checks
	FROM dbo.JobCheckList j 
	inner join dbo.Checks c on j.CheckId = c.Id
	WHERE j.Enabled = 'Y'
	AND j.JobId = @JobId
	
	IF @@ROWCOUNT=0
	BEGIn
		INSERT INTO #Checks (CheckId, Description, CheckResult)
		VALUES(0, 'None', 'OK')
	END
	
	DECLARE @today datetime , @TodayString varchar(20), @ZIDFail int, @TodayDataIntegrityFail int, @NowString varchar(23)
	DECLARE @Yesterday date, @YesterdayString varchar(20)
	DECLARE @cmd nvarchar(max)
	DECLARE @Now datetime 
	
	SET @today = cast(getdate() as date)
	SET @TodayString = CONVERT(VARCHAR(8), @today,  112) 
	SET @Now = getdate()
	SET @NowString = CONVERT(VARCHAR(23), @Now,  121) 
	SET @Yesterday = DateAdd(dd, -1, @Now)
	SET @YesterdayString = CONVERT(VARCHAR(23), @Yesterday,  121) 
		
	IF EXISTS (SELECT 1 FROM #Checks WHERE CheckId = 1)
	BEGIN
		--Check ZIDs rolled for today''s date

		SELECT @LongDesc = 'JobId [' + convert(varchar(5), @JobId) +'] Running check that ZID rolled.'
	
		EXEC [svc].[sp_save_service_log] @Source = 'Keystone.Services.ReportEngine',
		@SubSource = 'dbo.sp_perform_job_checklist', @Severity = 0, @Detail = 'Job Checklist', 	
		@LongDescription = @LongDesc, @Type = 'svc'
				
		SELECT @Cmd = '
			IF EXISTS (
				SELECT 1 
				from ' + @DB+'.dbo.POSZREPORT z inner join ' + @DB+'.dbo.LOCATIONS l on z.LOCATION = l.LOCATION
				WHERE IsNull(l.deleted, 0) = 0
				group by z.LOCATION, l.adesc
				having MAX(Startdatetime) < ''' + @TodayString+'''
				) SELECT @ZIDFail = 1
			ELSE
				SELECT @ZIDFail = 0'
		print @CMD		
		EXECUTE sp_executesql @Cmd, N'@ZIDFail INT OUTPUT', @ZIDFail OUTPUT
		
		IF @ZIDFail = 1
		BEGIN
			SELECT @Description = Description from #Checks WHERE Checkid = 1
			DELETE FROM #Checks WHERE Checkid = 1

			SELECT @CMD = '
			INSERT INTO #Checks (Checkid, Description, CheckResult)
			SELECT 1, ''' + @Description+''', ''ZID has not rolled for '' + l.adesc + '' ['' + z.LOCATION + '']''
			from ' + @DB+'.dbo.POSZREPORT z inner join ' + @DB+'.dbo.LOCATIONS l on z.LOCATION = l.LOCATION
			WHERE IsNull(l.deleted, 0) = 0
			group by z.LOCATION, l.adesc
			having MAX(Startdatetime) < ''' + @todaystring+''''
			
			print @CMD
			EXEC(@CMD)
		END
		ELSE
		BEGIN
			UPDATE #Checks SET CheckResult = 'OK' WHERE CheckId = 1
		END
	END

	IF EXISTS (SELECT 1 FROM #Checks WHERE CheckId = 2) 
	BEGIN
		--Check zero data integriy errors for today's date

		SELECT @LongDesc = 'JobId [' + convert(varchar(5), @JobId) +'] Running data integrity check.'
	
		EXEC [svc].[sp_save_service_log] @Source = 'Keystone.Services.ReportEngine',
		@SubSource = 'dbo.sp_perform_job_checklist', @Severity = 0, @Detail = 'Job Checklist', 	
		@LongDescription = @LongDesc, @Type = 'svc'
		
		SELECT @cmd = '
			exec ' + @DB+'.dbo.SP_DATA_INTEGRITY @StartFullCheck = ''' +@YesterdayString + '''
			IF EXISTS (SELECT 1 FROM ' + @DB+'.dbo.DataIntegrityLog
			WHERE event_datetime >= ''' + @NowString+''' AND detail like ''POS:%'')
				SELECT @TodayDataIntegrityFail = 1
			ELSE
				SELECT @TodayDataIntegrityFail = 0'		

		print @CMD
		EXECUTE sp_executesql @Cmd, N'@TodayDataIntegrityFail INT OUTPUT', @TodayDataIntegrityFail OUTPUT
			
		IF @TodayDataIntegrityFail = 1
			BEGIN

				SELECT @Description = Description from #Checks WHERE Checkid = 2
				DELETE FROM #Checks WHERE Checkid = 2

				SELECT @CMD = '
				INSERT INTO #Checks (Checkid, Description, CheckResult)
				SELECT DISTINCT 2, ''' + @Description+ ''', ''Data check error: '' + detail 
				FROM ' + @DB+'.dbo.DataIntegrityLog
				WHERE event_datetime >= ''' + @NowString +''' AND detail like ''POS:%'''
				
				print @CMD
				EXEC(@Cmd)

			END
		ELSE
		BEGIN
			UPDATE #Checks set CheckResult = 'OK' WHERE CheckId = 2
		END			
	END

	IF EXISTS (SELECT 1 FROM #Checks WHERE CheckId = 3) 
	BEGIN
		--Check for Oasys reports - that all counts have been posted

		SELECT @LongDesc = 'JobId [' + convert(varchar(5), @JobId) +'] Running check on posted counts.'
	
		EXEC [svc].[sp_save_service_log] @Source = 'Keystone.Services.ReportEngine',
		@SubSource = 'dbo.sp_perform_job_checklist', @Severity = 0, @Detail = 'Job Checklist', 	
		@LongDescription = @LongDesc, @Type = 'svc'
		
		SELECT @Description = Description from #Checks WHERE Checkid = 3

		SELECT @cmd = '
		;WITH Counts as (
			select ROW_NUMBER() OVER (PARTITION BY i.LOCATION ORDER BY COUNTNO DESC) as RowNo, i.* , l.ADESC
			from ' + @DB + '.dbo.ITEMCOUNT i inner join ' + @DB + '.dbo.LOCATIONS l on i.LOCATION = l.LOCATION
			WHERE l.LOCATION <> ''00'' AND l.LOCATION <> ''20'')
			INSERT INTO #Checks (CheckId, Description, CheckResult)
		SELECT 3, ''' + @Description+''', Replace(adesc, ''PPG '', '''')  + '' ['' + location+''] - Count ['' + countno +''] is not posted.''
		FROM Counts WHERE RowNo < 3
		AND Posted <> 1
		SELECT @rows = @@rowcount'
		
		print @CMD
		EXECUTE sp_executesql @Cmd, N'@Rows INT OUTPUT', @Rows OUTPUT
		
		IF @Rows > 0
		BEGIN
			--fail
			DELETE FROM #Checks WHERE Checkid = 3 AND CheckResult IS NULL
		END
		ELSE
			UPDATE #Checks set CheckResult = 'OK' WHERE CheckId = 3

		
	END


	IF EXISTS (SELECT 1 FROM #Checks WHERE CheckId = 4) 
	BEGIN
		--Check for new CM applications

		SELECT @LongDesc = 'JobId [' + convert(varchar(5), @JobId) +'] Running check for new CM Applications'
	
		EXEC [svc].[sp_save_service_log] @Source = 'Keystone.Services.ReportEngine',
		@SubSource = 'dbo.sp_perform_job_checklist', @Severity = 0, @Detail = 'Job Checklist', 	
		@LongDescription = @LongDesc, @Type = 'svc'
		
		
		SELECT @Description = Description from #Checks WHERE Checkid = 4

		SELECT @cmd = '
			IF NOT EXISTS( 
				SELECT 1
				FROM ' + @DB+'.dbo.CM_Applications WHERE creation_date > (SELECT checked FROM ' + @DB+'.dbo.CM_APPLICATIONS_last_checked)
			)				
			INSERT INTO #Checks (CheckId, Description, CheckResult)
			SELECT DISTINCT 4, ''' + @Description+''', ''No new data''
			SELECT @rows = @@rowcount'
		
	
		print @CMD
		EXECUTE sp_executesql @Cmd, N'@Rows INT OUTPUT', @Rows OUTPUT
		
		IF @Rows > 0
		BEGIN
			--fail
			DELETE FROM #Checks WHERE Checkid = 4 AND CheckResult IS NULL
		END
		ELSE
			UPDATE #Checks set CheckResult = 'OK' WHERE CheckId = 4

		
	END

	IF EXISTS (SELECT 1 FROM #Checks WHERE CheckId = 5) 
	BEGIN
		--Check for Discount Discrepencies

		SELECT @LongDesc = 'JobId [' + convert(varchar(5), @JobId) +'] Running check on discount discrepencies.'
	
		EXEC [svc].[sp_save_service_log] @Source = 'Keystone.Services.ReportEngine',
		@SubSource = 'dbo.sp_perform_job_checklist', @Severity = 0, @Detail = 'Job Checklist', 	
		@LongDescription = @LongDesc, @Type = 'svc'

		CREATE TABLE #output (id int , Description varchar(Max))

		SET @cmd = '
		INSERT INTO #output
		EXEC ' + @DB+'.dbo.SP_CHECK_DISCOUNT_DISCREPENCIES @StartDate = ''' + @YesterdayString + ''', @EndDate = '''+ @TodayString+''', @Full = 0
		'

		EXEC(@cmd)

		SELECT @Description = Description from #Checks WHERE Checkid = 5

		IF EXISTS (SELECT 1 FROM #output WHERE Description = 'No Problems.')
			UPDATE #Checks set CheckResult = 'OK' WHERE CheckId = 5
		ELSE
		BEGIN
			DELETE FROM #Checks WHERE Checkid = 5 AND CheckResult IS NULL
			INSERT INTO #Checks (CheckId, Description, CheckResult)
			SELECT DISTINCT 5, @Description, Description
			FROM #output
		END		
		
		DROP TABLE #output
		
	END
	
	DECLARE @Result int
	SELECT @Result = 0
	IF EXISTS(SELECT 1 FROM #Checks WHERE CheckResult <> 'OK') SELECT @Result = -1
	
	SELECT @Result as Result, * from #Checks

END
GO
