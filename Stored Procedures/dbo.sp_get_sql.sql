SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [dbo].[sp_get_sql]
as begin


       SELECT TOP 1000 * FROM(SELECT COALESCE( OBJECT_NAME ( s2. objectid),'Ad-Hoc' ) AS ProcName,
        execution_count ,s2. objectid,
             (SELECT TOP 1 SUBSTRING (s2 . TEXT ,statement_start_offset / 2+ 1 ,
              ( ( CASE WHEN statement_end_offset = -1
        THEN ( LEN(CONVERT (NVARCHAR ( MAX ),s2 . TEXT )) * 2 )
       ELSE statement_end_offset END )- statement_start_offset ) / 2 +1 )) AS sql_statement,
               last_execution_time
       FROM sys .dm_exec_query_stats AS s1
       CROSS APPLY sys. dm_exec_sql_text( sql_handle ) AS s2 ) x
       WHERE sql_statement NOT like 'SELECT TOP 1000 * FROM(SELECT %'
       and sql_statement NOT like 'update Tmp_LastRunStatement %'
       --and OBJECTPROPERTYEX(x.objectid,'IsProcedure') = 1
       and last_execution_time >= (Select dt from Tmp_LastRunStatement )
       and sql_statement not like '%TBL1001%' --exclude our dynamic data load from shipped databases
       ORDER BY last_execution_time ASC
     
       update Tmp_LastRunStatement set dt = GETDATE()

END
GO
