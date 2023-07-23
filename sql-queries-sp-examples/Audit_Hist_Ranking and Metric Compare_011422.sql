SET NOCOUNT ON;
;
IF OBJECT_ID('tempdb..#R_roster') IS NOT NULL BEGIN DROP table #R_roster END;
IF OBJECT_ID('tempdb..#R_roster_tmp') IS NOT NULL BEGIN DROP table #R_roster_tmp END;
;
;
DECLARE @fMonth int;
DECLARE @compareDt date;
;
SET @fMonth = 202112;
SET @compareDt = '1/7/2022'; /*Which snapshot should be checked*/
;
/*Build a distinct listing of folks who have Dec data in either table*/
/*Rankings*/
SELECT r.id,r.fiscalMth,r.posLevel
	,0 mID
INTO #R_roster
FROM MiningSwap.dbo.R_Ranking_Hist r with(nolock)
WHERE r.fiscalMth=@fMonth
GROUP BY r.id,r.fiscalMth,r.posLevel
;
INSERT INTO #R_roster
SELECT r.id,r.fiscalMth,r.posLevel
	,0 mID
FROM MiningSwap.dbo.R_Ranking r with(nolock)
WHERE r.fiscalMth=@fMonth
GROUP BY r.id,r.fiscalMth,r.posLevel
;
/*====================================*/
/*Clean dupes*/
SELECT DISTINCT *
INTO #R_roster_tmp
FROM #R_roster r with(nolock)
;
TRUNCATE TABLE #R_roster;
;
INSERT INTO #R_roster
SELECT *
FROM #R_roster_tmp t with(nolock)
;
/*====================================*/
;
SELECT r.*
	,n.fiscalPctRank N_PctRank
	,h.fiscalPctRank H_PctRank
	,n.fiscalRank N_FiscalRank
	,h.fiscalRank H_FiscalRank
	,n.weightTotal N_wt
	,h.weightTotal H_wt
FROM #R_roster r with(nolock)
LEFT OUTER JOIN MiningSwap.dbo.R_Ranking n with(nolock) on r.id=n.id
	AND r.fiscalMth=n.fiscalMth
	and r.posLevel=n.posLevel
LEFT OUTER JOIN MiningSwap.dbo.R_Ranking_Hist h with(nolock) on r.id=h.id
	and r.fiscalMth=h.fiscalMth 
	and r.posLevel=h.posLevel
	and CAST(h.ChangedOn as date) = @compareDt
ORDER BY 3,1,2
;
/*Metrics*/
TRUNCATE TABLE #R_roster;
;
INSERT INTO #R_roster
SELECT r.id,r.fiscalMth,r.posLevel
	,r.metricID
FROM MiningSwap.dbo.R_Metrics_Hist r with(nolock)
WHERE r.fiscalMth=@fMonth
GROUP BY r.id,r.fiscalMth,r.posLevel
	,r.metricID
;
INSERT INTO #R_roster
SELECT r.id,r.fiscalMth,r.posLevel
	,r.metricID
FROM MiningSwap.dbo.R_Metrics r with(nolock)
WHERE r.fiscalMth=@fMonth
GROUP BY r.id,r.fiscalMth,r.posLevel
	,r.metricID
;
/*====================================*/
/*Clean dupes*/
INSERT INTO #R_roster_tmp
SELECT DISTINCT *
FROM #R_roster r with(nolock)
;
TRUNCATE TABLE #R_roster;
;
INSERT INTO #R_roster
SELECT *
FROM #R_roster_tmp t with(nolock)
;
/*====================================*/
;
;
SELECT r.*
	,n.metricRank N_mRank
	,h.metricRank H_mRank
	,n.metricVal N_mVal
	,h.metricVal H_mVal
FROM #R_roster r with(nolock)
LEFT OUTER JOIN MiningSwap.dbo.R_Metrics n with(nolock) on r.id=n.id
	AND r.fiscalMth=n.fiscalMth
	and r.mID=n.metricID
	and r.posLevel=n.posLevel
LEFT OUTER JOIN MiningSwap.dbo.R_Metrics_Hist h with(nolock) on r.id=h.id
	and r.fiscalMth=h.fiscalMth 
	and r.mID=h.metricID
	and r.posLevel=h.posLevel
	and CAST(h.ChangedOn as date) = @compareDt
ORDER BY 3,4,1,2
;
IF OBJECT_ID('tempdb..#R_roster') IS NOT NULL BEGIN DROP table #R_roster END;
IF OBJECT_ID('tempdb..#R_roster_tmp') IS NOT NULL BEGIN DROP table #R_roster_tmp END;
;
return
;
--INSERT INTO MiningSwap.dbo.R_Ranking_Hist
SELECT 
r.id
,r.fiscalMth
,r.weightTotal
,r.fiscalRank
,r.fiscalPctRank
,r.rankType
,r.posLevel
,CURRENT_TIMESTAMP ChangedOn
FROM MiningSwap.dbo.R_Ranking r with(nolock)
WHERE r.fiscalMth = @fMonth

--INSERT INTO MiningSwap.dbo.R_Metrics_Hist
SELECT
m.id
,m.fiscalMth
,m.metricID
,m.metricVal
,m.metricRank
,m.rankType
,m.posLevel
,CURRENT_TIMESTAMP ChangedOn
FROM MiningSwap.dbo.R_Metrics m with(nolock)
WHERE m.fiscalMth = @fMonth