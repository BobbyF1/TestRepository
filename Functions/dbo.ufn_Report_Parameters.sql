SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[ufn_Report_Parameters] ( @JobId int, @ParameterId int, @Parameter VARCHAR(MAX)) RETURNS varchar(max)
AS
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Get Config options
-- v02 07/07/2015 PF Added Ids 9,10,11, 12, 13
-- v03 12/08/2015 PF Change DB connection string
-- v04 13/08/2015 PF Add Ids 14 and 15
-- v05 16/08/2015 PF Add Ids 16 and 18
-- v06 20/08/2015 PF Allow for "hard" parameter @Parameter to be passed
---------------------------------------------------------------------------------------------------------  

IF @ParameterId IS NULL RETURN @Parameter

IF NOT EXISTS (SELECT 1 FROM ArgumentValues WHERE Id = @ParameterId)
BEGIN
	DECLARE @error NVARCHAR(200)
	SET @error = 'Invalid argument ' + cast(@ParameterId as varchar(10))+ ' passed to [ufn_Report_Parameters]'
	 return cast(@error as int);
END	

/*1	Yesterday's Date
2	Connection String
3	Today's Date
4	Start of previous week - date
5	End of previous week - date
6	Start of previous week - datetime
7 	End of previous week - datetime
8	Hardcoded date - 31/3/2014
9	'02'
10	20
11	110
12	120
13	130
14	Empty String
15	0
16	1
18	'[sql-p02]'
*/

	DECLARE @Return varchar(max) = NULL

	IF @ParameterId = 1
	BEGIN
		--1 is Yesterday's Date
		SELECT @Return = CONVERT(VARCHAR(10), DATEADD(dd, -1, cast(getdate() as DATE)), 103)
	END
	
	IF @ParameterId = 2
	BEGIN
		--2	is the Connection String for use by Fast Reports
		DECLARE @DB varchar(100), @DBUser varchar(100), @DBServer varchar(100), @DBPassword varchar(100)
		--Data Source=VAIO\sqlexpress;AttachDbFilename=;Initial Catalog=ppg_head;Integrated Security=True;Persist Security Info=False;User ID=;Password=
		SELECT @DB = ReportDatabaseName FROM dbo.Job WHERE Id = @JobId
		SELECT @DBUser = DBUser, @DBPassword = DBPassword , @DBServer = DBServer FROM dbo.Config
--		SELECT @Return = 'Data Source=' + @DBServer+';Initial Catalog=' + @DB+';Integrated Security=False;User ID=' + @DBUser+';Password='+@DBPassword			
		SELECT @Return = 'Provider=SQLOLEDB.1;Password=' + @DBPassword+';User ID='+@DBUser+';Initial Catalog='+@DB+';Data Source='+@DBServer
		
	END

	IF @ParameterId = 3
	BEGIN
		--1 is Today's Date
		SELECT @Return = CONVERT(VARCHAR(10), cast(getdate() as DATE), 103)
	END
	
	IF @ParameterId = 4
	BEGIN
		--3: Start of last week (date)
		SELECT @Return = CONVERT(VARCHAR(10), DateAdd(dd, -6, Week_End_Date), 103) 
		FROM Dim_Calendar WHERE Date = DATEADD(dd, -7, CAST(GETDATE() as date))
	END

	IF @ParameterId = 5
	BEGIN
		--3: End of last week (date)
		SELECT @Return = CONVERT(VARCHAR(10), Week_End_Date, 103) 
		FROM Dim_Calendar WHERE Date = DATEADD(dd, -7, CAST(GETDATE() as date))
	END

	IF @ParameterId = 6
	BEGIN
		--6: Start of last week (datetime)
		SELECT @Return = CONVERT(VARCHAR(20), DateAdd(dd, -6, Week_End_Date), 103)  + ' 04:00'
		FROM Dim_Calendar WHERE Date = DATEADD(dd, -7, CAST(GETDATE() as date))
	END

	IF @ParameterId = 7
	BEGIN
		--7: End of last week (datetime)
		SELECT @Return = CONVERT(VARCHAR(20), Week_End_Date, 103)  + ' 04:00'
		FROM Dim_Calendar WHERE Date = DATEADD(dd, -7, CAST(GETDATE() as date))
	END
	
	IF @ParameterId = 8
	BEGIN
		--8 is a hardcoded date :( 31/3/14
		SELECT @Return = CONVERT(VARCHAR(20), cast ('20140331' as date), 103) 
	END

	IF @ParameterId = 9
	BEGIN
		--9 is string '02'
		SELECT @Return = '02'
	END

	IF @ParameterId = 10
	BEGIN
		--10 is integer 20
		SELECT @Return = '20'
	END

	IF @ParameterId = 11
	BEGIN
		--11 is integer 110
		SELECT @Return = '110'
	END

	IF @ParameterId = 12
	BEGIN
		--12 is integer 120
		SELECT @Return = '120'
	END

	IF @ParameterId = 13
	BEGIN
		--13 is integer 130
		SELECT @Return = '130'
	END

	IF @ParameterId = 14
	BEGIN
		--14 is empty string
		SELECT @Return = ''
	END

	IF @ParameterId = 15
	BEGIN
		--15 is integer zero 
		SELECT @Return = '0'
	END

	IF @ParameterId = 16
	BEGIN
		--16 is integer 1
		SELECT @Return = '1'
	END

	IF @ParameterId = 18
	BEGIN
		--16 is string 'sql-p02'
		SELECT @Return = '[sql-p02]'
	END
	
	RETURN @Return 
	
END
GO
