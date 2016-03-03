SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[SP_BACKUP] @BackupLocation VARCHAR(MAX) = null, @Compress tinyint = 1
AS
BEGIN
---------------------------------------------------------------------------------------------------------    
-- v01 10/08/2015 PF First released version.
---------------------------------------------------------------------------------------------------------    

	SET NOCOUNT ON 
	
	DECLARE @StartTime DATETIME
	SET @StartTime = getdate()

	IF OBJECT_ID('tempdb..#locations') IS NOT NULL DROP TABLE #locations
	IF OBJECT_ID('tempdb..#output') IS NOT NULL DROP TABLE #output

	CREATE TABLE #Locations (Id int identity(1,1), Loc varchar(200))
	INSERT INTO #Locations (Loc) VALUES ( 'c:\keystone\backup\')
	INSERT INTO #Locations (Loc) VALUES ( 'c:\keystone\backups\')
	INSERT INTO #Locations (Loc) VALUES ( 'f:\MSSQL10_50.KEYSTONE\MSSQL\Backup\')
	INSERT INTO #Locations (Loc) VALUES ( 'e:\keystone\backups\')
	INSERT INTO #Locations (Loc) VALUES ( 'E:\MSSQL\Backup\')
	INSERT INTO #Locations (Loc) VALUES ( 'c:\keystone files\backup\')
	INSERT INTO #Locations (Loc) VALUES ( 'C:\Keystone\Databases\Backup\')
	INSERT INTO #Locations (Loc) VALUES ( 'd:\keystone\backups\')
	INSERT INTO #Locations (Loc) VALUES ( 'e:\ftp\log_shipping\')
	INSERT INTO #Locations (Loc) VALUES ( 'c:\temp\')


	declare @cmd varchar(max)
	declare @BackupName nvarchar(200) 
	declare @Success int = 0
	declare @Try int = 1
	declare @LocationsToTry int
	declare @location varchar(max)
	declare @BackupFileName  varchar(max)
	DECLARE @WinCmd varchar(255), @rc  INT, @ArchiveName VARCHAR(MAX)
	
	IF @BackupLocation IS NOT NULL
	BEGIN
		DELETE FROM #locations
		IF RIGHT(@BackupLocation , 1) <> '\' SET @BackupLocation = @BackupLocation  + '\'
		TRUNCATE TABLE #Locations
		INSERT INTO #Locations (Loc) VALUES (@BackupLocation)
	END

	SELECT @LocationsToTry = MAX(ID) FROM #Locations

	WHILE(@Success = 0 AND @Try <=  @LocationsToTry )
	BEGIN
		SELECT @BackupName = Loc +  DB_NAME()  + '_'+Replace(Replace(Replace(CONVERT(VARCHAR(16), GETDATE(), 120), '-', ''), ':', ''), ' ', '_') + '_C.bak' , 
			@location  = Loc,
			@BackupFileName = DB_NAME()  + '_'+Replace(Replace(Replace(CONVERT(VARCHAR(16), GETDATE(), 120), '-', ''), ':', ''), ' ', '_') + '_C.bak' 
		FROM #Locations WHERE ID = @Try
		SELECT @cmd = 'BACKUP DATABASE ' + DB_Name() + ' TO  DISK = ''' + @BackupName
			+''' WITH  NOFORMAT, NOINIT,  NAME = N''Full Database Backup Name'', NOSKIP,NOREWIND, NOUNLOAD,  STATS = 10, COMPRESSION'
		from #Locations WHERE ID = @Try
		begin try
			Print 'Attempting backup with compression to ' + @BackupName
			EXEC (@CMD)
			SELECT @Success = 1
			Print 'Backed up database to ' + @BackupName+' with compression'
		End Try
		begin catch
			SELECT @BackupName = Loc +  DB_NAME()  + '_'+Replace(Replace(Replace(CONVERT(VARCHAR(16), GETDATE(), 120), '-', ''), ':', ''), ' ', '_') + '.bak' ,
				@location  = Loc,
				@BackupFileName = DB_NAME()  + '_'+Replace(Replace(Replace(CONVERT(VARCHAR(16), GETDATE(), 120), '-', ''), ':', ''), ' ', '_') + '.bak' 
			FROM #Locations WHERE ID = @Try
			SELECT @cmd = 'BACKUP DATABASE ' + DB_Name() + ' TO  DISK = ''' + @BackupName
				+''' WITH  NOFORMAT, NOINIT,  NAME = N''Full Database Backup Name'', NOSKIP,NOREWIND, NOUNLOAD,  STATS = 10'
			from #Locations WHERE ID = @Try
			begin try
				Print 'Attempting backup without compression to ' + @BackupName
				EXEC (@CMD)
				SELECT @Success = 1
				Print 'Backed up database to ' + @BackupName+' without compression'
			End Try
			begin catch
				Print 'Cannot back up to  ' + @BackupName
				SELECT @Try = @Try + 1
			End Catch
		End Catch
	END

	DROP TABLE #Locations

	IF @Success = 0 
	BEGIN
		Print '**Could not find a suitable backup destination**'
		RETURN
	END

	--WAITFOR DELAY '00:00:10';

	IF @Compress = 1
	BEGIN

		SET @ArchiveName = REPLACE(@BackupName, '.bak', '.rar')

		SELECT @WinCmd = 'cd /d "' + @location + '" && "C:\Program Files\WinRAR\rar.exe" a ' + @ArchiveName + ' ' + @BackupFileName

		CREATE TABLE #output (id INT IDENTITY(1,1), output NVARCHAR(255) NULL)
		Print 'Trying ' + @WinCmd
		INSERT #output EXEC @rc = master..xp_cmdshell @WinCmd

		IF NOT EXISTS(SELECT 1 FROM #output WHERE output = 'Done')
		BEGIN
			SELECT @WinCmd = 'cd /d "' + @location + '" && "C:\Program Files (x86)\WinRAR\rar.exe" a ' + @ArchiveName + ' ' + @BackupFileName
			set @WinCmd = 'CMD /S /C " ' + @WinCmd+ ' " '
			INSERT #output EXEC @rc = master..xp_cmdshell @WinCmd
		END

		IF EXISTS(SELECT 1 FROM #output WHERE output = 'Done')
		BEGIN
			Print 'RAR''d the backup file to become ' + @ArchiveName
			SELECT @WinCmd = 'del ' + @BackupName
			Print 'Attempting to delete the original file with : ' + @WinCmd
			INSERT #output EXEC @rc = master..xp_cmdshell @WinCmd
		END
		ELSE
			Print 'Couldn''t compress the file with RAR'

		DROP TABLE #output

	END

	SET NOCOUNT OFF

	PRINT 'Time taken: ' + cast(datediff(ss, @StartTime, getdate()) as varchar(10)) + ' seconds.'

END
GO
