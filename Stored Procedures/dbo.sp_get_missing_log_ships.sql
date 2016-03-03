SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[sp_get_missing_log_ships]
AS
BEGIN

---------------------------------------------------------------------------------------------------------    
-- v01 15/09/2015 PF Initial Version. Identify log shipments that haven't loaded for a perdiod of time.
---------------------------------------------------------------------------------------------------------    

	if object_id('tempdb..#db') is not null drop table #db
	if object_id('tempdb..#lastloads') is not null drop table #lastloads

	select distinct databasename into #db from ks_log_shipping.dbo.restore_history

	delete from #db 
	where databasename in 
	(select IDValue FROM SpecialParameters WHERE IDString = 'sp_get_missing_log_ships' and IDParam = 'Ignore DB')

	select d.DatabaseName, MAX(r.CreationDate) as LastLoad
	INTO #LastLoads
	from #db d left outer join ks_log_shipping.dbo.Restore_History r on d.DatabaseName = r.DatabaseName
	group by d.DatabaseName

	DECLARE @mins INTEGER
	SELECT @mins = IsNull(CAST(IDValue as INTEGER), 30) 
	FROM SpecialParameters WHERE IDString = 'sp_get_missing_log_ships' AND IDParam = 'Look back minutes'

	DELETE FROM #LastLoads
	WHERE LastLoad > DateAdd(mi, -@mins, getdate())

	SELECT * FROM #LastLoads
END
GO
