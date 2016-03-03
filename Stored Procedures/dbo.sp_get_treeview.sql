SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[sp_get_treeview] @parentId int
AS BEGIN

	CREATE TABLE #tv
	(
		Id int NOT NULL,
		ParentId int NULL,
		[Desc] varchar(256) NOT NULL,
		TargetPage varchar(256) NOT NULL,
		ItemId INT NULL,
		ToolTip varchar(256) NULL
		)
		
	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (10, 0, 'Head Office Data Refresh', '~/DataRefreshPage.aspx')
	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (20, 0, 'Maintain System Users', '')
	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (21, 20, 'Companies', '~/SystemCompanies.aspx')
	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (22, 20, 'Dropdown Static', '~/SystemDropdowns.aspx')
	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (23, 20, 'Users', '~/SystemUsers.aspx')



	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (30, 0, 'Report Engine', '')

	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (40, 30, 'Maintain Static', '~/REMaintainStatic.aspx')
	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (50, 40, 'Schedules', '~/REMaintainSchedules.aspx')
	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (60, 40, 'Fast Reports', '~/REMaintainFastReports.aspx')
	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (70, 40, 'Argument Values', '~/REMaintainArgValues.aspx')
	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (80, 40, 'Spreadsheets', '~/REMaintainSpreadsheets.aspx')
	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (90, 40, 'Custom Reports', '~/REMaintainCustomReports.aspx')
--	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (100, 40, 'Checks', '~/REMaintainChecks.aspx')
	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (105, 40, 'Address Book', '~/REMaintainAddressBook.aspx')
	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (110, 40, 'Email Profiles', '~/REMaintainEmailProfiles.aspx')
--	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (120, 40, 'Global Configuration', '~/REMaintainConfig.aspx')

	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (130, 30, 'Jobs', '')
		
	INSERT INTO #tv (Id, ParentId, [desc], TargetPage, ItemId) 
	SELECT 130 + CategoryId, 130, CatDesc, '', CategoryId FROM JobCategory
		
	INSERT INTO #tv (Id, ParentId, [desc], TargetPage, ItemId, ToolTip) 
	SELECT 300 + j.Id, 130 + CategoryId, CASE WHEN LEN(j.Name)<26 THEN j.Name ELSE LEFT(j.Name, 25)+ '...' END, '~/REMaintainJob.aspx?JobId=' + CAST(j.Id as VARCHAR(10)), j.Id, j.Name
	FROM Job j INNER JOIN #tv ON j.CategoryId = #tv.ItemId
	WHERE --j.Enabled = 'Y'
	j.deleted = 0 

	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (20000, 30, 'Run Job', '~/REJobs.aspx')
	INSERT INTO #tv (Id, ParentId, [desc], TargetPage) VALUES (20010, 30, 'Show Job Summary', '~/REJobSummary.aspx')

	UPDATE #tv SET ToolTip = [desc] WHERE ToolTip IS NULL

	SELECT * FROM #tv 
	WHERE ParentId = @parentId 
	ORDER BY Id

END
GO
