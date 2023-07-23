SET NOCOUNT ON;
;
;
IF OBJECT_ID('tempdb..#LeadQueue_AG_ByFiscal') IS NOT NULL BEGIN DROP TABLE #LeadQueue_AG_ByFiscal END;
IF OBJECT_ID('tempdb..#AG_LeadCall_Dates') IS NOT NULL BEGIN DROP table #AG_LeadCall_Dates END;
IF OBJECT_ID('tempdb..#vid_lead_Sg') IS NOT NULL BEGIN DROP TABLE #vid_lead_Sg END;
IF OBJECT_ID('tempdb..#vid_Leads') IS NOT NULL BEGIN DROP TABLE #vid_Leads END;
IF OBJECT_ID('tempdb..#AG_LeadCall_Location') IS NOT NULL BEGIN DROP TABLE #AG_LeadCall_Location END;
;
DECLARE @sDate datetime;
DECLARE @eDate datetime;
;
/*Determine dates for the current fiscal expected; Offset by a day*/
SET @eDate = CAST(FLOOR(CAST(DATEADD(hh,-5,GETUTCDATE()-1) as float)) as datetime);
SET @eDate=CASE
		WHEN DATEPART(d,@eDate) < 29 THEN DATEADD(m,0,DATEADD(d,28-DATEPART(d,@eDate),@eDate))
		ELSE DATEADD(m,1,DATEADD(d,-1 * (DATEPART(d,@eDate)-28),@eDate))
	END
;
SET @sDate = DATEADD(d,1,DATEADD(m,-2,@eDate));
;

select 
	sg.StaffGroup
	,sg.STF_GRP_SK
	,sg.StartDate
	,sg.EndDate
into #vid_lead_Sg
from DimensionalMapping.DIM.Staff_Group_to_LOB sg with(nolock)
where sg.FG_Alias in ('Video Lead') 
group by
	sg.StaffGroup
	,sg.STF_GRP_SK
	,sg.StartDate
	,sg.EndDate

select
	sg.EMP_SK
	,cast(null as numeric(10)) PSID
	,sg.StartDate
	,sg.EndDate
into #vid_Leads
from DimensionalMapping.DIM.Historical_Agent_Staff_Group sg with(nolock)
inner join #vid_lead_Sg g on sg.STF_GRP_SK = g.STF_GRP_SK and sg.StartDate between g.StartDate and g.EndDate
where 
	case
		when sg.StartDate >= @sDate and sg.EndDate >= @eDate then 1
		when sg.StartDate >= @sdate and sg.EndDate <= @eDate then  1
		when sg.StartDate <= @sdate and sg.EndDate >= @sDate then  1
		else 0
	end = 1
;
;
update a
set a.PSID = da.EmpID
from #vid_Leads a with(nolock)
inner join Aspect.WFM.Daily_Agents da with(nolock)
	on a.EMP_SK = da.EMP_SK
where dateadd(day,da.NomDate,'12/30/1899') between @sDate and @eDate
;
;
/*Prep a swap for which fiscals are part of the data*/
SELECT CAST(MIN(l.LeadSEGSTART) as date) fMIN
	,CAST(MAX(l.LeadSEGSTART) as date) fMAX
	,CAST(CASE
		WHEN DATEPART(d,l.LeadSEGSTART) < 29 THEN DATEADD(m,0,DATEADD(d,28-DATEPART(d,l.LeadSEGSTART),l.LeadSEGSTART))
		ELSE DATEADD(m,1,DATEADD(d,-1 * (DATEPART(d,l.LeadSEGSTART)-28),l.LeadSEGSTART))
	END as date) FMonth
INTO #AG_LeadCall_Dates
FROM SwitchData.ECH.Lead_Calls l with(nolock)
inner join #vid_Leads vl with(nolock) on l.LeadPSID = vl.PSID and l.StdDate between vl.StartDate and vl.EndDate
WHERE l.StdDate between @sDate and @eDate
GROUP BY CAST(CASE
		WHEN DATEPART(d,l.LeadSEGSTART) < 29 THEN DATEADD(m,0,DATEADD(d,28-DATEPART(d,l.LeadSEGSTART),l.LeadSEGSTART))
		ELSE DATEADD(m,1,DATEADD(d,-1 * (DATEPART(d,l.LeadSEGSTART)-28),l.LeadSEGSTART))
	END as date)
;
/*Delete any period that don't start on the 29th; Denotes incomplete data for the fiscal;*/
DELETE d
FROM #AG_LeadCall_Dates d
/*Offset to check for date next to end of a fiscal;Accounts for leapyear*/
WHERE DATEPART(d,DATEADD(d,-1,d.fMIN)) <> 28
;
/*Validate the newest partial items are for current MTD, otherwise also delete*/
DELETE d
FROM #AG_LeadCall_Dates d
WHERE DATEPART(d,d.fMAX) <> 28
	AND d.fMAX not between @sDate and @eDate
;
;
;
SELECT 
	l.LeadPSID
	,CAST(CASE
		WHEN DATEPART(d,l.LeadSEGSTART) < 29 THEN DATEADD(m,0,DATEADD(d,28-DATEPART(d,l.LeadSEGSTART),l.LeadSEGSTART))
		ELSE DATEADD(m,1,DATEADD(d,-1 * (DATEPART(d,l.LeadSEGSTART)-28),l.LeadSEGSTART))
	END as date) FMonth
    ,CAST(FLOOR(CAST(l.LeadSEGSTART as float)) as datetime) CallDate
    ,COUNT(DISTINCT l.LeadUCID) LeadCalls
    ,COUNT(DISTINCT case when l.TransferVDN_Description is null THEN l.LeadUCID ELSE NULL END)InvalidDial
INTO #LeadQueue_AG_ByFiscal
FROM SwitchData.ECH.Lead_Calls l with(nolock)
INNER JOIN #AG_LeadCall_Dates p on l.LeadSEGSTART BETWEEN p.fMIN and p.fMAX
GROUP BY l.LeadPSID
	,CAST(CASE
		WHEN DATEPART(d,l.LeadSEGSTART) < 29 THEN DATEADD(m,0,DATEADD(d,28-DATEPART(d,l.LeadSEGSTART),l.LeadSEGSTART))
		ELSE DATEADD(m,1,DATEADD(d,-1 * (DATEPART(d,l.LeadSEGSTART)-28),l.LeadSEGSTART))
	END as date)
    ,CAST(FLOOR(CAST(l.LeadSEGSTART as float)) as datetime)
;
;
 SELECT e.STARTDATE
 ,l.DepartmentID
 ,e.DEPARTMENT
 ,e.LOC
 ,e.PEOPLESOFTID
 INTO #AG_LeadCall_Location
 FROM [DimensionalMapping].[DIM].[PeopleSoft_Locations] l WITH (NOLOCK)
 INNER JOIN [UXID].[EMP].[Enterprise_Historical_Daily_Indexed] e with(nolock) ON l.Department = e.DEPARTMENT
 WHERE l.DepartmentID = '640'
 AND e.STARTDATE BETWEEN @sDate AND @eDate
 GROUP BY e.STARTDATE
 ,l.DepartmentID
 ,e.DEPARTMENT
 ,e.LOC
 ,e.PEOPLESOFTID

 SELECT * FROM #AG_LeadCall_Location

 SELECT DATEPART(yyyy,a.FMonth) [Year]
	,a.FMonth
	,l.LOC
    ,SUM(a.LeadCalls)LeadCalls
    ,SUM(a.InvalidDial)InvalidDial
FROM #LeadQueue_AG_ByFiscal a with(nolock)
INNER JOIN UXID.EMP.Workers w with(nolock) on a.LeadPSID=w.NETIQWORKERID
INNER JOIN #AG_LeadCall_Location l with(nolock) on l.PEOPLESOFTID=w.NETIQWORKERID
	AND a.CallDate = l.STARTDATE 
GROUP BY l.LOC
	,a.FMonth
/*Now using the WORKERID we can join to find the history of their locations */
/*SELECT DATEPART(yyyy,a.FMonth) [Year]
	,a.FMonth
	,e.LOC
    ,SUM(a.LeadCalls)LeadCalls
    ,SUM(a.InvalidDial)InvalidDial
FROM #LeadQueue_AG_ByFiscal a with(nolock)
INNER JOIN UXID.EMP.Workers w with(nolock) on a.LeadPSID=w.NETIQWORKERID
INNER JOIN UXID.EMP.Enterprise_Historical_Daily_Indexed e with(nolock) on e.PEOPLESOFTID=w.NETIQWORKERID
	AND a.CallDate = e.STARTDATE
GROUP BY e.LOC
	,a.FMonth*/
;
IF OBJECT_ID('tempdb..#LeadQueue_AG_ByFiscal') IS NOT NULL BEGIN DROP TABLE #LeadQueue_AG_ByFiscal END;
IF OBJECT_ID('tempdb..#AG_LeadCall_Dates') IS NOT NULL BEGIN DROP table #AG_LeadCall_Dates END;
IF OBJECT_ID('tempdb..#vid_lead_Sg') IS NOT NULL BEGIN DROP TABLE #vid_lead_Sg END;
IF OBJECT_ID('tempdb..#vid_Leads') IS NOT NULL BEGIN DROP TABLE #vid_Leads END;
IF OBJECT_ID('tempdb..#AG_LeadCall_Location') IS NOT NULL BEGIN DROP TABLE #AG_LeadCall_Location END;
;