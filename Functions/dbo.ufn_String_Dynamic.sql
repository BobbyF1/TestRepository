SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ufn_String_Dynamic] ( @Filename varchar(max)) RETURNS varchar(max)
AS
BEGIN
---------------------------------------------------------------------------------------------------------  
-- v01 01/12/2014 PF Original Version. Edit a given string replacing placeholder expressions
-- v02 19/02/2015 PF Added TodaysDate
-- v03 20/03/2015 PF Added CurrentDateTime
-- v04 13/08/2015 PF Correct TodaysDate
---------------------------------------------------------------------------------------------------------  

	DECLARE @YesterdaysDateString varchar(12), @DateFormat int, @PreviousWeekEnd varchar(12)
	DECLARE @TodayDateTimeString varchar(17)
	
	SELECT @DateFormat = FilenameDateFormat FROM Config

	--[YesterdaysDate]
	SELECT @YesterdaysDateString = Replace (convert(varchar(25), DateAdd(dd, -1, getdate()), @DateFormat), ',', '')
	SET @Filename = REPLACE(@Filename, '[YesterdaysDate]', @YesterdaysDateString)

	--[PreviousWeekEnd]
	SELECT @PreviousWeekEnd = Replace(Convert(varchar(25), DateAdd( dd, -7, Week_End_Date), @Dateformat), ',', '')
	FROM Dim_Calendar WHERE [Date] = Cast(getdate() as Date)
	SET @Filename = REPLACE(@Filename, '[PreviousWeekEnd]', @PreviousWeekEnd)

	--[TodaysDate]
	SELECT @YesterdaysDateString = Replace (convert(varchar(25), getdate(), @DateFormat), ',', '')
	SET @Filename = REPLACE(@Filename, '[TodaysDate]', @YesterdaysDateString)

	--[CurrentDateTime]
	SELECT @TodayDateTimeString = Replace(CONVERT(VARCHAR(17), GETDATE(), 113), ':', '')
	SET @Filename = REPLACE(@Filename, '[CurrentDateTime]', @TodayDateTimeString)
		
	RETURN @Filename

END
GO
