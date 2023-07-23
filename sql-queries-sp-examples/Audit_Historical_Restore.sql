/* 
	110921 - Restore Metric Data From Historical
		lvl - Set Position Level to 1, 2, 3, 4
		d - Set to the Date to Restore Data to
		f - Set to the Fiscal neeeding to be restored
		i - Set to the instance number
*/
DECLARE @lvl as int = 3;
DECLARE @d as date = '11/05/2021';
DECLARE @f as int = 202109;
IF OBJECT_ID('tempdb..#QParams') IS NOT NULL BEGIN DROP TABLE #QParams END;
IF OBJECT_ID('tempdb..#stagedSwap') IS NOT NULL BEGIN DROP TABLE #stagedSwap END;

/*	Grab Table with Ranking ReStages
  	for the day	*/
SELECT 
cast(h.ChangedOn as date) stdDate
,h.ChangedOn
,row_number() over(partition by cast(h.ChangedOn as date) order by h.ChangedOn DESC) rn
INTO #QParams
FROM MiningSwap.dbo.R_Metrics_Hist h with(nolock)
WHERE h.posLevel = 3 and cast(h.ChangedOn as date) = @d and h.fiscalMth = @f
GROUP BY cast(h.ChangedOn as date), h.ChangedOn


/* Grab Swap of Staged Metric Ranks */
SELECT id, fiscalMth, metricID, metricVal, metricRank, rankType, posLevel
INTO #stagedSwap
FROM MiningSwap.dbo.R_Metrics_Hist h with(nolock)
WHERE	h.fiscalMth = @f and 
		h.posLevel = @lvl and 
		h.ChangedOn in (select ChangedOn from #QParams where rn = 1)

/* Trim out Metric Data about to be reloaded */
DELETE FROM MiningSwap.dbo.R_Metrics WHERE fiscalMth = @f and posLevel = @lvl

/* Insert Historical Data into Prod Table */
INSERT INTO MiningSwap.dbo.R_Metrics (id, fiscalMth, metricID, metricVal, metricRank, rankType, posLevel)
SELECT id, fiscalMth, metricID, metricVal, metricRank, rankType, posLevel FROM #stagedSwap




/* Update the Fiscal Mth Ranks With the Updated Metrics */
DECLARE @RC int
DECLARE @fiscal nvarchar(10) = @f
EXECUTE @RC = MiningSwap.[dbo].[R_Manager_FiscalRanks] 
   @fiscal

/* Update the Display Table */
EXECUTE @RC = MiningSwap.[dbo].[R_Manager_Disp_Update] 




/* Clean Up Temp Tables */
IF OBJECT_ID('tempdb..#QParams') IS NOT NULL BEGIN DROP TABLE #QParams END;
IF OBJECT_ID('tempdb..#stagedSwap') IS NOT NULL BEGIN DROP TABLE #stagedSwap END;