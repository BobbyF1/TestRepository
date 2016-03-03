SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[sp_show_job] @JobId int, @Print bit = 1 WITH ENCRYPTION
as
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Displays all details of a job
-- v02 21/03/2015 PF Introduce JobSchedule table
-- v03 27/03/2015 PF Add Special Parameter; display Ignore Checks Next run correctly
-- v04 05/05/2015 PF Show any Special Parameters
-- v05 07/08/2015 PF Add SuppressCheckFailureAlert
-- v06 16/08/2015 PF Add SuppressSendIfNoData
-- v07 31/08/2015 PF Add SuppressMailSendNextRun
-- v08 24/09/2015 PF OUJER JOINs for argument values
-- v09 05/01/2016 PF SELECT option instead of PRINTs at the end
---------------------------------------------------------------------------------------------------------  

	SET NOCOUNT ON 
	
	DECLARE @ScheduleId int
	DECLARE @SaveAs varchar(max), @TargetFileName varchar(max), @FRFileName varchar(max), @Enabled varchar(max), @ForceFIleFolder varchar(max), @Description varchar(max)
	DECLARE @count int, @FRId int, @SpreadsheetId int, @CustomReportId int, @Name varchar(max)
	DECLARE @SQLQuery varchar(max)
	DECLARE @var varchar(max) = '', @sp varchar(max)

	CREATE TABLE #print (Id int identity(1,1), val varchar(max), data varchar(max))

	INSERT INTO #print (val, data) VALUES ('Job Details' , '')
	INSERT INTO #print (val, data) VALUES ('===========' , '')
	
	INSERT INTO #print (val, data) VALUES ('JobId' , convert(varchar(5), @JobId))
	INSERT INTO #print (val, data) SELECT 'Name' , Name FROM Job WHERE Id = @JobId
	INSERT INTO #print (val, data) SELECT 'Enabled' , Enabled FROM Job WHERE Id = @JobId
	INSERT INTO #print (val, data) SELECT 'Checks Database' , ChecksDatabaseName FROM Job WHERE Id = @JobId
	INSERT INTO #print (val, data) SELECT 'Report Database' , ReportDatabaseName FROM Job WHERE Id = @JobId
	INSERT INTO #print (val, data) SELECT 'Last Run' , IsNull(convert(varchar(23), LastRun, 100), '-') FROM Job WHERE Id = @JobId
	INSERT INTO #print (val, data) SELECT 'Next Run' , IsNull(convert(varchar(23), NextRun, 100), '-') FROM Job WHERE Id = @JobId
	INSERT INTO #print (val, data) SELECT 'Try Until' , IsNull(convert(varchar(23), TryUntil, 100), '-') FROM Job WHERE Id = @JobId
	INSERT INTO #print (val, data) SELECT 'Ignore Checks Next Run' ,  convert(varchar(10), IgnoreChecksNextRun) FROM Job WHERE Id = @JobId
	INSERT INTO #print (val, data) SELECT 'Special Parameter' , IsNull(SpecialParameterId, '-') FROM Job WHERE Id = @JobId
	INSERT INTO #print (val, data) SELECT 'Suppress Check Failure Alert' , IsNull(SuppressCheckFailureAlert, '-') FROM Job WHERE Id = @JobId
	INSERT INTO #print (val, data) SELECT 'Suppress Send If No Data' , IsNull(SuppressSendIfNoData, '0') FROM Job WHERE Id = @JobId
	INSERT INTO #print (val, data) SELECT 'Suppress Mail Send Next Run' , IsNull(SuppressMailSendNextRun, '0') FROM Job WHERE Id = @JobId

	INSERT INTO #print (val, data) VALUES ('' , '')
	INSERT INTO #print (val, data) VALUES ('Schedule' , '')
	INSERT INTO #print (val, data) VALUES ('===========' , '')
	
	declare @SId varchar(max), @RunDailyTime varchar(max), @RunDailyMon varchar(max), @RunDailyTue varchar(max), @RunDailyWed varchar(max), 
		@RunDailyThu varchar(max), @RunDailyFri varchar(max), @RunDailySat varchar(max), @RunDailySun varchar(max), @RepeatTryDuration varchar(max), @RepeatTryPause  varchar(max)

	declare schedules cursor for SELECT convert(varchar(5), s.Id), IsNull(Description, '-'), convert(varchar(5), RunDailyTime), RunDailyMon, RunDailyTue, RunDailyWed, 
		RunDailyThu, RunDailyFri, RunDailySat, RunDailySun, convert(varchar(10), RepeatTryDuration), convert(varchar(10), RepeatTryPause)
	FROM Job j 
	inner join JobSchedule js on j.Id = js.JobId
	inner join Schedule s on js.ScheduleId = s.Id
	WHERE j.Id = @JobId
	
	OPEN schedules
	FETCH schedules INTO @SId, @Description, @RunDailyTime, @RunDailyMon, @RunDailyTue, @RunDailyWed, @RunDailyThu, @RunDailyFri, @RunDailySat, 
		@RunDailySun, @RepeatTryDuration, @RepeatTryPause
	WHILE @@FETCH_STATUS = 0
	BEGIN


		INSERT INTO #print (val, data) VALUES ( 'Description' , @Description)
		INSERT INTO #print (val, data) VALUES ( 'Id' , @SId)
		INSERT INTO #print (val, data) VALUES ( 'Run Daily Time' , @RunDailyTime)
		INSERT INTO #print (val, data) VALUES ( 'Run Monday' , @RunDailyMon )
		INSERT INTO #print (val, data) VALUES ( 'Run Tuesday' , @RunDailyTue )
		INSERT INTO #print (val, data) VALUES ( 'Run Wednesday' , @RunDailyWed )
		INSERT INTO #print (val, data) VALUES ( 'Run Thursday' , @RunDailyThu )
		INSERT INTO #print (val, data) VALUES ( 'Run Friday' , @RunDailyFri )
		INSERT INTO #print (val, data) VALUES ( 'Run Saturday' , @RunDailySat )
		INSERT INTO #print (val, data) VALUES ( 'Run Sunday' , @RunDailySun )
		INSERT INTO #print (val, data) VALUES ( 'Repeat Try Duration' , @RepeatTryDuration)
		INSERT INTO #print (val, data) VALUES ( 'Repeat Try Pause' , @RepeatTryPause) 

		FETCH schedules INTO @SId, @Description, @RunDailyTime, @RunDailyMon, @RunDailyTue, @RunDailyWed, @RunDailyThu, @RunDailyFri, @RunDailySat, 
			@RunDailySun, @RepeatTryDuration, @RepeatTryPause

	END
	
	CLOSE schedules
	DEALLOCATE schedules
	

	INSERT INTO #print (val, data) VALUES ('' , '')
	INSERT INTO #print (val, data) VALUES ('Fast Reports' , '')
	INSERT INTO #print (val, data) VALUES ('============' , '')
	
	declare reports cursor for select jrd.saveas, jrd.targetfilename, fr.frfilename, fr.enabled, IsNull(fr.forcefilefolder, '-'), IsNull(fr.description, '-'), fr.Id
	FROM JobReportDetail jrd inner join FastReport fr on jrd.reportid = fr.id
	WHERE JobId = @JobId

	select @count = 0
	open reports
	fetch reports into @SaveAs, @TargetFileName, @FRFileName, @Enabled, @ForceFIleFolder, @Description, @FRId
	
	while @@FETCH_STATUS = 0
	begin
		SET @count = @count + 1

		INSERT INTO #print (val, data) VALUES ('' , '')
		INSERT INTO #print (val, data) VALUES ('Report '+ CONVERT(varchar(2), @count)  , '')
		INSERT INTO #print (val, data) VALUES ('----------' , '')
		INSERT INTO #print (val, data) VALUES ('Fast Report' , @FRFileName)
		INSERT INTO #print (val, data) VALUES ('Description' , @Description)
		INSERT INTO #print (val, data) VALUES ('Save As' , @SaveAs)
		INSERT INTO #print (val, data) VALUES ('Target Filename' , @TargetFileName)
		INSERT INTO #print (val, data) VALUES ('Enabled' , @Enabled)
		INSERT INTO #print (val, data) VALUES ('Force File Folder' , @ForceFIleFolder)
		
		SET @var = ''
		select @var = @var + 'var' + CONVERT(varchar(1), sequence) + ' = [' + IsNull(av.description, ra.ArgValue) +'] ' 
		from reportargs ra LEFT OUTER join argumentvalues av on ra.argvalueid = av.id
		where ra.reportid = @FRId
		order by sequence
		INSERT INTO #print (val, data) VALUES ('Arguments' , @var)

		
		fetch reports into @SaveAs, @TargetFileName, @FRFileName, @Enabled, @ForceFIleFolder, @Description, @FRId
	end
	
	if @count = 0  INSERT INTO #print (val, data) VALUES ('(None)' , '')

	close reports 
	deallocate reports

	INSERT INTO #print (val, data) VALUES ('' , '')
	INSERT INTO #print (val, data) VALUES ('Spreadsheets' , '')
	INSERT INTO #print (val, data) VALUES ('============' , '')


	declare spreadsheets cursor for select jrd.targetfilename, fr.sqlquery , fr.enabled, IsNull(fr.forcefilefolder, '-'), IsNull(fr.description, '-'),
	fr.id
	FROM JobSpreadsheetDetail jrd inner join Spreadsheet fr on jrd.spreadsheetId = fr.id
	WHERE JobId = @JobId

	select @count = 0
	open spreadsheets
	fetch spreadsheets into @TargetFileName, @SQLQuery, @Enabled, @ForceFIleFolder, @Description, @SpreadsheetId
	
	while @@FETCH_STATUS = 0
	begin
		SET @count = @count + 1

		INSERT INTO #print (val, data) VALUES ('' , '')
		INSERT INTO #print (val, data) VALUES ('Spreadsheet '+ CONVERT(varchar(2), @count)  , '')
		INSERT INTO #print (val, data) VALUES ('----------' , '')
		INSERT INTO #print (val, data) VALUES ('SQL Query' , @SQLQuery)
		INSERT INTO #print (val, data) VALUES ('Description' , @Description)
		INSERT INTO #print (val, data) VALUES ('Target Filename' , @TargetFileName)
		INSERT INTO #print (val, data) VALUES ('Enabled' , @Enabled)
		INSERT INTO #print (val, data) VALUES ('Force File Folder' , @ForceFIleFolder)

		SET @var = ''
		select @var = @var + 'var' + CONVERT(varchar(1), sequence) + ' = [' + IsNull(av.description, ra.ArgValue) +'] ' 
		from SpreadsheetArgs ra LEFT OUTER join argumentvalues av on ra.argvalueid = av.id
		where ra.Spreadsheetid = @SpreadsheetId
		order by sequence
		INSERT INTO #print (val, data) VALUES ('Arguments' , @var)
		
		fetch spreadsheets into @TargetFileName,  @SQLQuery, @Enabled, @ForceFIleFolder, @Description, @SpreadsheetId
	end
	
	if @count = 0  INSERT INTO #print (val, data) VALUES ('(None)' , '')

	close spreadsheets
	deallocate spreadsheets
	
	
	INSERT INTO #print (val, data) VALUES ('' , '')
	INSERT INTO #print (val, data) VALUES ('Custom Reports' , '')
	INSERT INTO #print (val, data) VALUES ('==============' , '')
	
	
	declare customreports cursor for select jrd.targetfilename, fr.Name , fr.enabled, IsNull(fr.description, '-'),
	fr.id
	FROM JobCustomReportDetail jrd inner join CustomReport fr on jrd.CustomReportId = fr.id
	WHERE JobId = @JobId

	select @count = 0
	open customreports
	fetch customreports into @TargetFileName, @Name, @Enabled, @Description, @CustomReportId
	
	while @@FETCH_STATUS = 0
	begin
		SET @count = @count + 1

		INSERT INTO #print (val, data) VALUES ('' , '')
		INSERT INTO #print (val, data) VALUES ('Custom Report '+ CONVERT(varchar(2), @count)  , '')
		INSERT INTO #print (val, data) VALUES ('---------------' , '')
		INSERT INTO #print (val, data) VALUES ('Name' , @Name)
		INSERT INTO #print (val, data) VALUES ('Description' , @Description)
		INSERT INTO #print (val, data) VALUES ('Target Filename' , @TargetFileName)
		INSERT INTO #print (val, data) VALUES ('Enabled' , @Enabled)

		SET @var = ''
		select @var = @var + 'var' + CONVERT(varchar(1), sequence) + ' = [' + IsNull(av.description, ra.ArgValue) +'] ' 
		from CustomReportArgs ra LEFT OUTER join argumentvalues av on ra.argvalueid = av.id
		where ra.CustomReportid = @CustomReportId
		order by sequence
		INSERT INTO #print (val, data) VALUES ('Arguments' , @var)
		
		fetch customreports into @TargetFileName, @Name, @Enabled, @Description, @CustomReportId
	end
	
	if @count = 0  INSERT INTO #print (val, data) VALUES ('(None)' , '')

	close customreports
	deallocate customreports

	INSERT INTO #print (val, data) VALUES ('' , '')
	INSERT INTO #print (val, data) VALUES ('Checks' , '')
	INSERT INTO #print (val, data) VALUES ('======' , '')
	
	--checks
	declare Checks cursor for select jrd.Enabled, fr.Description
	FROM JobCheckList jrd inner join Checks fr on jrd.CheckId = fr.id
	WHERE JobId = @JobId

	select @count = 0
	open Checks
	fetch Checks into @Name, @Description
	
	while @@FETCH_STATUS = 0
	begin
	
			SET @count = @count + 1

			INSERT INTO #print (val, data) VALUES ('' , '')
			INSERT INTO #print (val, data) VALUES ('Description ',  @Description  )
			INSERT INTO #print (val, data) VALUES ('Enabled',  @Enabled )

			fetch Checks into @Name, @Description
	END
	
	close checks
	deallocate checks
	

	INSERT INTO #print (val, data) VALUES ('' , '')
	INSERT INTO #print (val, data) VALUES ('Email Profile' , '')
	INSERT INTO #print (val, data) VALUES ('=============' , '')
	
	INSERT INTO #print (val, data) SELECT 'Description' , IsNull(Description, '-') FROM Job j inner join EmailProfile e on j.EmailProfileId = e.Id WHERE j.Id = @JobId	
	INSERT INTO #print (val, data) SELECT 'Subject' , IsNull(Subject, '-') FROM Job j inner join EmailProfile e on j.EmailProfileId = e.Id WHERE j.Id = @JobId
	INSERT INTO #print (val, data) SELECT 'Message' , IsNull(Message, '-') FROM Job j inner join EmailProfile e on j.EmailProfileId = e.Id WHERE j.Id = @JobId
	INSERT INTO #print (val, data) SELECT 'To' , IsNull(MailTo, '-') FROM Job j inner join EmailProfile e on j.EmailProfileId = e.Id WHERE j.Id = @JobId
	INSERT INTO #print (val, data) SELECT 'Cc' , IsNull(cc, '-') FROM Job j inner join EmailProfile e on j.EmailProfileId = e.Id WHERE j.Id = @JobId
	INSERT INTO #print (val, data) SELECT 'Bcc' , IsNull(Bcc, '-') FROM Job j inner join EmailProfile e on j.EmailProfileId = e.Id WHERE j.Id = @JobId
	
	INSERT INTO #print (val, data) VALUES ('' , '')
	INSERT INTO #print (val, data) VALUES ('Special Parameters' , '')
	INSERT INTO #print (val, data) VALUES ('==================' , '')	

	SELECT @sp = IsNull(SpecialParameterId, '-') FROM Job WHERE Id = @JobId

	IF @sp = ''
	BEGIN
		INSERT INTO #print (val, data) VALUES ('(None)' , '')
	END
	ELSE
	BEGIN
		INSERT INTO #print (val, data) 
		SELECT IDParam, IDValue FROM SpecialParameters WHERE IDString = @sp
	END
	
	DECLARE @id INT, @Output varchar(max)

	IF @Print = 1
	BEGIN
		SELECT @id = 1
		
		while(@id <= ( Select MAX(id) from #print))
		BEGIN
			SELECT @Output = Rtrim(val) + Replicate(' ', 34- LEN(Rtrim(val))) + data FROM #print WHERE ID = @id
			Print @output
			SELECT @id = @id + 1
		END	
	END
	ELSE
	BEGIN
		ALTER TABLE #print ADD SelectCol VARCHAR(MAX)
		UPDATE #print SET SelectCol = Rtrim(val) + Replicate(' ', 34- LEN(Rtrim(val))) + data 
		SELECT SelectCol FROM #print ORDER BY Id
	END
END
GO
