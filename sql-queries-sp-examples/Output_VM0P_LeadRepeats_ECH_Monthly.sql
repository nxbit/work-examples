/*VM0PWOWMMSDVS0.corp.chartercom.com*/
SET NOCOUNT ON;
/*
Modeled based on the original lead repeats monthly query;
;
Updated to use the new Traffic table format;
=======================
083022: Added back the leading zeroes in detail results to ensure use in web-based QMS searches as intended;
082322:	Added table bottleneck logic;

*/
IF OBJECT_ID('tempdb..#lastLeadPerUCID') IS NOT NULL BEGIN DROP TABLE #lastLeadPerUCID END;
IF OBJECT_ID('tempdb..#joinedData') IS NOT NULL BEGIN DROP TABLE #joinedData END;
IF OBJECT_ID('tempdb..#LeadTotals') IS NOT NULL BEGIN DROP TABLE #LeadTotals END;
IF OBJECT_ID('tempdb..#AgentCallGrouped') IS NOT NULL BEGIN DROP TABLE #AgentCallGrouped END;
IF OBJECT_ID('tempdb..#leadCallsHandled') IS NOT NULL BEGIN DROP TABLE #leadCallsHandled END;
IF OBJECT_ID('tempdb..#weSatData') IS NOT NULL BEGIN DROP TABLE #weSatData END;
IF OBJECT_ID('tempdb..#ldsRepeatData') IS NOT NULL BEGIN DROP TABLE #ldsRepeatData END;
IF OBJECT_ID('tempdb..#StackedData') IS NOT NULL BEGIN DROP TABLE #StackedData END;
;
IF OBJECT_ID('tempdb..#LR_BASE') IS NOT NULL BEGIN DROP TABLE #LR_BASE END;
IF OBJECT_ID('tempdb..#LR_MA') IS NOT NULL BEGIN DROP TABLE #LR_MA END;
;
DECLARE @chkDate datetime;
;
/*Offset since DEV is a snapshot of history*/
SET @chkDate = DATEADD(d,DATEDIFF(d,0,getutcdate()),0);
;
/*======================*/
/*082322:	Avoid table bottle necks by swapping detail before join*/
SELECT ma.MANAGEMENTAREAID
	,ma.MGMTAREANAME
INTO #LR_MA
FROM UXID.REF.Management_Areas ma with(nolock)
;
SELECT w.WORKERID
	,w.NETIQWORKERID
	,w.MANAGEMENTAREAID
	,case when w.PREFFNAME is null then w.FIRSTNAME else w.PREFFNAME END+' '+w.LASTNAME EmpName
INTO #LR_BASE
FROM UXID.EMP.Workers w with(nolock)
WHERE w.WORKERTYPE = 'E'
	and w.BUSINESSUNITID = 6
	AND CASE
		WHEN w.TERMINATEDDATE is NULL THEN 1
		WHEN w.TERMINATEDDATE >= DATEADD(m,-4,@chkDate) THEN 1
		ELSE 0
	END = 1
;
/*======================*/
;
;
/* eDate will be Last Saturday From Todays Date  */
/* sDate will be the Start of the current fiscal and eDate will be the end of the
		Current Fiscal															 */
with params as (
	SELECT
	/*Offset because data is datetime;*/
	DATEADD(s,-1,DATEADD(d,1,CASE
        WHEN DATEPART(dd,@chkDate) < 29 THEN DATEADD(d,28-DATEPART(dd,@chkDate),@chkDate)
        ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,@chkDate)-28),@chkDate))
    END)) as eDate
	/* Pulling the last 4 Months of Data the Oldest Month may not be fully populated */
	,DateAdd(month,-3,DateAdd(day,1,DateAdd(month,-1,CASE
        WHEN DATEPART(dd,@chkDate) < 29 THEN DATEADD(d,28-DATEPART(dd,@chkDate),@chkDate)
        ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,@chkDate)-28),@chkDate))
    END))) as sDate
)
,ldSK as (
/*Use the summary of the lead calls to build a skill mapping from the period;*/
SELECT  [LOB_TYPE]
      ,[FCSTGRP]
      ,[BLGVENDOR]
      ,[CUSTTYPE]
      ,[CMSSERVER]
      ,[ACD]
      ,[DISPSPLIT]
      ,[FACENM]
      ,SUM([CallCount])[CallCount]
	  
FROM [SwitchData].[ECH].[Lead_Calls_Summary] s with(nolock)
INNER JOIN params p on s.SEGSTOP_Date between p.sDate and p.eDate
WHERE s.FCSTGRP LIKE '%Escal%Video%'
and s.CUSTTYPE='Residential'
and s.CMSSERVER NOT IN ('cmseastcdp01','cmsosnce01','kstllcmsp01','r3timfl')
GROUP BY [LOB_TYPE]
    ,[FCSTGRP]
    ,[BLGVENDOR]
    ,[CUSTTYPE]
    ,[CMSSERVER]
    ,[ACD]
    ,[DISPSPLIT]
    ,[FACENM]
)
/*Params Check
select eDate, sDate from params;
return
*/
/* Grabbing a Swap of Grouped Agent and Lead Calls as a Base */
/* Looking for Calls to Lead Line that Occured Between the SegStart of the Agent Call
	and the Calculated End of the Agent Call */
SELECT 
	c.AgentUCID AgUCID
	,Cast(c.LeadPSID as decimal(10,0)) [WORKERID]
	,c.AgentRealStartTime AgSegStart
	,c.AgentRealEndTime AgSegEnd
    ,case 
        when c.AgentRealEndTime is NULL THEN NULL
        WHEN c.AgentRealEndTime < c.LeadRealEndTime THEN 1
        ELSE 0
    END PossibleXfr    
	,c.LeadPSID ANSLOGIN
    ,pw.EmpName leadName
	,w.CODE WAH
	,ma.MGMTAREANAME [site]
	,c.LeadSEGSTART SEGSTART
	,c.LeadPSID ldsID
	,c.LeadUCID ldsUCID
	,DateDiff(second,c.LeadRealStartTime_UTC,c.LeadRealEndTime_UTC) ldsDuration
	/* Grabbing Order Leads were contected for each UCID */
	,Row_Number() over (partition by c.AgentUCID order by c.LeadSEGSTART_UTC ASC) leadCallOrder
INTO #AgentCallGrouped
FROM SwitchData.ech.Lead_Calls c with(nolock)
INNER JOIN params p on c.LeadSEGSTART between p.sDate and p.eDate
INNER JOIN ldSK ls on c.LeadDISPSPLIT=ls.DISPSPLIT
and c.LeadCMSSERVER=ls.CMSSERVER
and c.LeadACD=ls.ACD
LEFT OUTER JOIN #LR_BASE pw with(nolock)
	on c.LeadPSID = pw.netiqworkerid
LEFT OUTER JOIN #LR_MA ma with(nolock)
	on pw.MANAGEMENTAREAID = ma.MANAGEMENTAREAID
LEFT OUTER JOIN GVPOperations.VID.ATT_EMP e with(nolock)
	on pw.NETIQWORKERID = e.ID
LEFT OUTER JOIN GVPOperations.VID.ATT_WAH w with(nolock)
	on e.EMP_SK = w.EMP_SK 
	and DateDiff(d,'18991230',DateAdd(d,-1,getDate())) between w.START_NOM_DATE and case when w.STOP_NOM_DATE is null then datediff(d,'18991230',DateAdd(d,1,getDate())) else w.STOP_NOM_DATE end
WHERE c.AgentUCID IS NOT NULL
	/*050422:	Traffic tables show missing agent UCID as a 0, not a null;*/
	and c.AgentUCID not in (0)
	and c.LeadPSID is not null

/*082322:	Housekeeping after tables not needed;*/
IF OBJECT_ID('tempdb..#LR_BASE') IS NOT NULL BEGIN DROP TABLE #LR_BASE END;
IF OBJECT_ID('tempdb..#LR_MA') IS NOT NULL BEGIN DROP TABLE #LR_MA END;
;
/*Joined Data Check
select * from #AgentCallGrouped;
return;
*/


/* Grabbing Swap of Last Lead Order of each UCID */
SELECT 
acc.AgUCID agentCallUCID
,max(acc.leadCallOrder) lastLeadInt
INTO #lastLeadPerUCID
FROM #AgentCallGrouped acc with(nolock)
GROUP BY acc.AgUCID

/* Creating Table with Repeat Flags. Flags are identified when the lead Call order doesn't match
the max Lead Interaction count for that Call. Example if an agent called the lead line twice, 2 will 
be in the lastLeadInt column, for the first interaction LeadCallORder #1 will not match to that of the leadLastInt
therefor identifing a repeat on the same call */
SELECT 
acg.*, ll.lastLeadInt
,case when acg.leadCallOrder != ll.lastLeadInt then 1 else 0 end repeatFlag
INTO #joinedData
FROM #AgentCallGrouped acg
LEFT JOIN #lastLeadPerUCID ll with(nolock)
on acg.AgUCID = ll.agentCallUCID

/*joined Data check
select * from #joinedData;
return;*/


/* Grabbing Lead repleat Count Across A */
SELECT 
jd.ANSLOGIN leadLoginID
,sum(jd.repeatFlag) repeatCount
INTO #LeadTotals
FROM #joinedData jd with(nolock)
WHERE jd.ANSLOGIN IS NOT NULL
GROUP BY jd.ANSLOGIN



SELECT 
jd.AgUCID
,jd.WORKERID ldsPSID
,jd.AgSegStart
,jd.AgSegEnd
,jd.[site] [Site]
,jd.leadName
,jd.WAH [WorkLocation]
,jd.SEGSTART [leadSegStart]
,CASE
    WHEN DATEPART(dd,CAST(jd.SEGSTART AS DATE)) < 29 THEN DATEADD(d,28-DATEPART(dd,CAST(jd.SEGSTART AS DATE)),CAST(jd.SEGSTART AS DATE))
    ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,CAST(jd.SEGSTART AS DATE))-28),CAST(jd.SEGSTART AS DATE)))
END weSat
--,DATEADD(DAY, 7 - DATEPART(WEEKDAY, jd.SEGSTART), CAST(jd.SEGSTART AS DATE)) weSat
,jd.ldsDuration
,jd.ldsUCID
,jd.ldsID
,jd.leadCallOrder
,jd.repeatFlag
INTO #weSatData
FROM #joinedData jd with(nolock)
ORDER BY 1, 5


SELECT 
cast(wd.Site as nvarchar) site
,cast(wd.leadName as nvarchar) leadName
,cast(wd.ldsPSID as nvarchar) PSID
,cast(wd.WorkLocation as nvarchar) WorkLocation
,cast(wd.weSat as date) weSat
,cast(sum(case when wd.ldsDuration > 30 and wd.repeatFlag = 1 then 1 else 0 end) as int) gt30Sec
,cast(round((cast(sum(case when wd.ldsDuration > 30 and wd.repeatFlag = 1 then 1 else 0 end) as float)/
nullif(cast(count(distinct wd.ldsUCID) as float),0))*100,2) as float) gt30SecPct
,cast(sum(case when wd.ldsDuration <= 30 and wd.repeatFlag = 1 then 1 else 0 end) as int) lt30Sec
,cast(round((cast(sum(case when wd.ldsDuration <= 30 and wd.repeatFlag = 1 then 1 else 0 end) as float)/
nullif(cast(count(distinct wd.ldsUCID) as float),0))*100,2) as float) lt30SecPct
,cast(count(distinct wd.ldsUCID) as int) callsHandled
,cast(round((cast(count(distinct case when wd.repeatFlag = 1 then wd.ldsUCID else null end) as float)/
nullif(cast(count(distinct wd.ldsUCID) as float),0))*100,2) as float) leadRepeat

,cast(round(cast(sum(case when wd.repeatFlag = 1 then wd.ldsDuration else 0 end) as float)/
nullif(cast(count(distinct case when wd.repeatFlag = 1 then wd.ldsUCID else null end) as float),0),0) as int) repeatAHT

,cast(round(cast(sum(wd.ldsDuration) as float)/
nullif(cast(count(distinct wd.ldsUCID) as float),0),0) as int) overallAHT

,cast(sum(wd.ldsDuration) as float) ldsTotalDur
,cast(sum(case when wd.repeatFlag = 1 then wd.ldsDuration else 0 end) as float) ldsRepeatDur

INTO #ldsRepeatData
FROM #weSatData wd with(nolock)
WHERE wd.ldsID is not null
GROUP BY wd.Site
,wd.leadName
,wd.ldsPSID
,wd.WorkLocation
,wd.weSat

/*083022: Updated output formatted to keep leading zeroes; web-based QMS searches fail without the leading values;*/
select 
case when [AgUCID]=0 THEN NULL ELSE FORMAT([AgUCID],'0000000000000000000#') END AgUCID,
[weSat] [FiscalMth],
DATEADD(DAY, 7 - DATEPART(WEEKDAY, [leadSegStart]), CAST([leadSegStart] AS DATE)) weSat,
[AgSegStart],
[AgSegEnd],
[leadSegStart],
[Site],
[leadName],
[ldsPSID],
case when [ldsUCID]=0 THEN NULL ELSE FORMAT([ldsUCID],'0000000000000000000#') END [ldsUCID],
[ldsDuration],
[leadCallOrder],
[repeatFlag]
FROM #weSatData
where 
case when repeatFlag = 1 then 1
when repeatFlag = 0 and leadCallOrder > 1 then 1
else 0 end = 1








select 
cast(a.site as nvarchar) [site]
,cast('Site' as nvarchar) leadName
,cast('' as nvarchar) PSID
,cast('' as nvarchar) WorkLocation
,a.weSat
,sum(a.gt30Sec) gt30Sec
,round((cast(sum(a.gt30Sec) as float)/nullif(cast(sum(a.callsHandled) as float),0))*100,2) gt30SecPct
,sum(a.lt30Sec) lt30Sec
,round((cast(sum(a.lt30Sec) as float)/nullif(cast(sum(a.callsHandled) as float),0))*100,2) lt30SecPct
,sum(a.callsHandled) callsHandled
,round((cast(sum(a.gt30Sec)+sum(a.lt30Sec) as float)/
nullif(cast(sum(a.callsHandled) as float),0))*100,2) leadRepeat
,round(cast(sum(a.ldsRepeatDur)/nullif((sum(a.gt30Sec)+sum(a.lt30Sec)),0) as float),0) repeatAHT
,round(cast(sum(a.ldsTotalDur)/nullif((sum(a.callsHandled)),0) as float),0) overallAHT
,sum(a.ldsTotalDur) ldsTotalDur
,sum(a.ldsRepeatDur) ldsRepeatDur
INTO #StackedData
from #ldsRepeatData a with(nolock)
where a.site is not null
group by a.site, a.weSat

INSERT INTO #StackedData
select 
cast('All-VR' as nvarchar) [site]
,cast('All-VR' as nvarchar) leadName
,cast('' as nvarchar) PSID
,cast('' as nvarchar) WorkLocation
,a.weSat
,sum(a.gt30Sec) gt30Sec
,round((cast(sum(a.gt30Sec) as float)/nullif(cast(sum(a.callsHandled) as float),0))*100,2) gt30SecPct
,sum(a.lt30Sec) lt30Sec
,round((cast(sum(a.lt30Sec) as float)/nullif(cast(sum(a.callsHandled) as float),0))*100,2) lt30SecPct
,sum(a.callsHandled) callsHandled
,round((cast(sum(a.gt30Sec)+sum(a.lt30Sec) as float)/
nullif(cast(sum(a.callsHandled) as float),0))*100,2) leadRepeat
,round(cast(sum(a.ldsRepeatDur)/nullif((sum(a.gt30Sec)+sum(a.lt30Sec)),0) as float),0) repeatAHT
,round(cast(sum(a.ldsTotalDur)/nullif((sum(a.callsHandled)),0) as float),0) overallAHT
,sum(a.ldsTotalDur) ldsTotalDur
,sum(a.ldsRepeatDur) ldsRepeatDur

from #ldsRepeatData a with(nolock)
where a.site is not null
group by a.weSat
;
;
;
insert into #StackedData
select *
from #ldsRepeatData b with(nolock)
where b.site is not null
;
;
select s.* 
from #StackedData s with(nolock)
ORDER BY s.PSID
	,s.leadName
	,s.weSat
	,s.site
;
IF OBJECT_ID('tempdb..#StackedData') IS NOT NULL BEGIN DROP TABLE #StackedData END;
IF OBJECT_ID('tempdb..#ldsRepeatData') IS NOT NULL BEGIN DROP TABLE #ldsRepeatData END;
IF OBJECT_ID('tempdb..#weSatData') IS NOT NULL BEGIN DROP TABLE #weSatData END;
IF OBJECT_ID('tempdb..#leadCallsHandled') IS NOT NULL BEGIN DROP TABLE #leadCallsHandled END;
IF OBJECT_ID('tempdb..#lastLeadPerUCID') IS NOT NULL BEGIN DROP TABLE #lastLeadPerUCID END;
IF OBJECT_ID('tempdb..#joinedData') IS NOT NULL BEGIN DROP TABLE #joinedData END;
IF OBJECT_ID('tempdb..#LeadTotals') IS NOT NULL BEGIN DROP TABLE #LeadTotals END;
IF OBJECT_ID('tempdb..#AgentCallGrouped') IS NOT NULL BEGIN DROP TABLE #AgentCallGrouped END;
;
IF OBJECT_ID('tempdb..#LR_BASE') IS NOT NULL BEGIN DROP TABLE #LR_BASE END;
IF OBJECT_ID('tempdb..#LR_MA') IS NOT NULL BEGIN DROP TABLE #LR_MA END;
;