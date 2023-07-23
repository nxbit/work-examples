/*VM0PWOWMMSD0001.corp.chartercom.com*/
SET NOCOUNT ON;
;
IF OBJECT_ID('tempdb..#AG2Plus_rpts') IS NOT NULL BEGIN DROP TABLE #AG2Plus_rpts END;
IF OBJECT_ID('tempdb..#AG2Plus_MA') IS NOT NULL BEGIN DROP TABLE #AG2Plus_MA END;
IF OBJECT_ID('tempdb..#AG2Plus_LOC') IS NOT NULL BEGIN DROP TABLE #AG2Plus_LOC END;
IF OBJECT_ID('tempdb..#AG2Plus_BASE') IS NOT NULL BEGIN DROP TABLE #AG2Plus_BASE END;
;
DECLARE @sDate date;
DECLARE @eDate date;
;
/*Rolling 7 days, 2 day offset for day boundary;*/
SET @eDate = DATEADD(d,-2,DATEADD(hh,-5,GETUTCDATE()));
SET @sDate = DATEADD(d,-6,@eDate);
;
/*
SET @sDate = '7/10/2022';
SET @eDate = '7/23/2022';
*/
;
/*
Remodel of Agent2Plus data from the Traffic source data;
;
==============================;
	At launch logic by Traffic will hide some McAllen behaviors since
	they have Lead and Escalations skills, and Escalations are ignored;  :(
==============================;
Updates
---------
062222: Updated for table bottleneck workaround;
051922:	Updated fields to closer align to the original CSV fields; Will be key for eventually
		migrating to a Traffic version of the job;
072121: Display just agents with a pattern of two or more during the period;
*/
;
/*062222: Moved to temps to work around table bottlenecks*/
SELECT ma.*
INTO #AG2Plus_MA
FROM UXID.REF.Management_Areas ma with(nolock)
;
;
SELECT l.LOCATIONID
	,CAST(l.STATE+' '+l.CITY as nvarchar(125)) WorkLocation
INTO #AG2Plus_LOC
FROM UXID.REF.Locations l with(nolock)
;
SELECT w.NETIQWORKERID
	,w.ENTITYACCOUNT
	,w.WORKERID
	,case when w.PREFFNAME is null then w.FIRSTNAME else w.PREFFNAME end+' '+w.LASTNAME EmpName
	,CASE
	WHEN DATEDIFF(m, w.SERVICEDATE, DATEADD(hh,-5,GETUTCDATE())) between 0 and 3 THEN '<01 to 03 mos'
	WHEN DATEDIFF(m, w.SERVICEDATE, DATEADD(hh,-5,GETUTCDATE())) between 4 and 6 THEN '>03 to 06 mos'
	WHEN DATEDIFF(m, w.SERVICEDATE, DATEADD(hh,-5,GETUTCDATE())) between 7 and 9 THEN '>06 to 09 mos'
	WHEN DATEDIFF(m, w.SERVICEDATE, DATEADD(hh,-5,GETUTCDATE())) between 10 and 12 THEN '>09 to 12 mos'
	WHEN DATEDIFF(m, w.SERVICEDATE, DATEADD(hh,-5,GETUTCDATE())) between 13 and 24 THEN '>12 to 24 mos'
	WHEN DATEDIFF(m, w.SERVICEDATE, DATEADD(hh,-5,GETUTCDATE())) between 25 and 36 THEN '>24 to 36 mos'
	WHEN DATEDIFF(m, w.SERVICEDATE, DATEADD(hh,-5,GETUTCDATE())) between 37 and 48 THEN '>36 to 48 mos'
	WHEN DATEDIFF(m, w.SERVICEDATE, DATEADD(hh,-5,GETUTCDATE())) > 48 THEN '>48 mos'
	ELSE '' END [Service Tenure]
	,w.MANAGEMENTAREAID
	,w.LOCATIONID
	,w.SUPERVISORID
INTO #AG2Plus_BASE
FROM UXID.EMP.Workers w with(nolock)
WHERE CASE
	WHEN w.TERMINATEDDATE is null THEN 1
	WHEN w.TERMINATEDDATE >= @sDate THEN 1
	ELSE 0
	END = 1
	and w.WORKERTYPE = 'E'
	and w.BUSINESSUNITID = 6
;
WITH vidSK as (

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
WHERE s.LOB_TYPE LIKE 'Video'
and s.CUSTTYPE='Residential'
/*062122: No need to include NA since we are looking at Video, not leads*/
and s.BLGVENDOR in ('CSG','ICOMS')
and s.SEGSTOP_Date between @sDate and @eDate
GROUP BY [LOB_TYPE]
    ,[FCSTGRP]
    ,[BLGVENDOR]
    ,[CUSTTYPE]
    ,[CMSSERVER]
    ,[ACD]
    ,[DISPSPLIT]
    ,[FACENM]
)
,ldSK as (

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
WHERE s.FCSTGRP LIKE '%Escal%Vid%'
and s.CUSTTYPE='Residential'
and s.CMSSERVER NOT IN ('cmseastcdp01','cmsosnce01','kstllcmsp01','r3timfl')
and s.SEGSTOP_Date between @sDate and @eDate
GROUP BY [LOB_TYPE]
    ,[FCSTGRP]
    ,[BLGVENDOR]
    ,[CUSTTYPE]
    ,[CMSSERVER]
    ,[ACD]
    ,[DISPSPLIT]
    ,[FACENM]
)
,agCalls as (
SELECT [AgentUCID]
	,l.AgentAvaya ANSLOGIN
      ,COUNT(DISTINCT l.LeadUCID) LeadCalls
  FROM [SwitchData].[ECH].[Lead_Calls] l with(nolock)
  INNER JOIN vidSK sk on l.AgentDISPSPLIT=sk.DISPSPLIT
	and l.AgentCMSSERVER=sk.CMSSERVER
	and l.AgentACD=sk.ACD
  INNER JOIN ldSK ls on l.LeadDISPSPLIT=ls.DISPSPLIT
	and l.LeadCMSSERVER=ls.CMSSERVER
	and l.LeadACD=ls.ACD
/*050222:	Updated to avoid StdDate in this query since it's based on the Lead and not the Agent;*/
/*Offset date to filter against datetime;*/
where l.AgentRealStartTime between @sDate and DATEADD(d,1,@eDate)
and l.LeadAvaya is not null
GROUP BY l.AgentUCID
	,l.AgentAvaya
HAVING COUNT(DISTINCT l.LeadUCID) > 1
),
 agChk as (
	SELECT a.ANSLOGIN
	FROM agCalls a with(nolock)
	GROUP BY ANSLOGIN
	/*072221: Per Michele threshold only folks with 2 or more*/
	HAVING COUNT(*) > 1
)
,rptList as (
SELECT CAST(CASE WHEN w.ENTITYACCOUNT is null THEN '*Not UXID Assigned*' ELSE l.WorkLocation END as nvarchar(125)) [Caller Site]
	,CAST(CASE WHEN w.ENTITYACCOUNT is null THEN '*Not UXID Assigned*' ELSE ma.MGMTAREANAME END as nvarchar(50)) [Caller MA]
	/* 110321 - Added Mgr as per request */
	,CAST(CASE WHEN w.ENTITYACCOUNT is null THEN '*Not UXID Assigned*' ELSE bb.EmpName END as nvarchar(125)) [Caller Mgr]
	,CAST(CASE WHEN w.ENTITYACCOUNT is null THEN '*Not UXID Assigned*' ELSE b.EmpName END as nvarchar(125)) [Caller Sup]
	,CAST(CASE WHEN w.ENTITYACCOUNT is null THEN '*Not UXID Assigned*' ELSE w.EmpName END as nvarchar(125)) [Caller Name]
	,CAST(ISNULL(w.ENTITYACCOUNT,'') as nvarchar(25)) [Caller PID]
	,w.[Service Tenure]
	,lc.AgentPSID
	,lc.AgentAvaya
	,DATEDIFF(s,lc.AgentRealStartTime_UTC,lc.AgentRealEndTime_UTC) HANDLETIME
	,lc.AgentUCID
	,lc.AgentDISPSPLIT
	,lc.AgentSEGSTART
	,lc.AgentSEGSTOP
	,lc.AgentRealStartTime_UTC
	,a.LeadCalls
	,ROW_NUMBER() OVER(PARTITION BY lc.AgentUCID,lc.AgentSEGSTART ORDER BY lc.LeadSEGSTART) ldOrd
	,lc.LeadUCID
	,lc.LeadSEGSTART
	,lc.LeadRealEndTime
	--,lc.LeadDIALED_NUM
	--,lc.TransferVDN_Description
	--,lc.LeadPSID
	--,lc.LeadAvaya
	--,lc.LeadDISPSPLIT
	--,lc.*
FROM SwitchData.ECH.Lead_Calls lc with(nolock)
INNER JOIN agCalls a on lc.AgentUCID=a.AgentUCID
INNER JOIN agChk c on lc.AgentAvaya=c.ANSLOGIN
LEFT OUTER JOIN #AG2Plus_BASE w with(nolock) on w.netiqworkerid=lc.AgentPSID
LEFT OUTER JOIN #AG2Plus_MA ma with(nolock) on w.MANAGEMENTAREAID=ma.MANAGEMENTAREAID
LEFT OUTER JOIN #AG2Plus_LOC l with(nolock) on w.LOCATIONID=l.LOCATIONID
LEFT OUTER JOIN #AG2Plus_BASE b with(nolock) on w.SUPERVISORID=b.WORKERID
LEFT OUTER JOIN #AG2Plus_BASE bb with(nolock) on b.SUPERVISORID=bb.WORKERID
)
SELECT b.[Caller Site]
	,b.[Caller MA]
	,b.[Caller Mgr]
	,b.[Caller Sup]
	,b.[Caller Name]
	,b.[Caller PID]
	,ISNULL(CAST(b.AgentPSID as nvarchar(25)),'') [Caller HRNum]
	,b.[Service Tenure]
	/*Format for display*/
	,CHAR(39)+REPLICATE('0',20-len(b.AgentUCID))+CAST(b.AgentUCID as varchar(20)) AGUCID
	,b.AgentAvaya ANSLOGIN
	,b.HANDLETIME
	,b.AgentSEGSTART AGSEGSTART
	,b.AgentSEGSTOP AGSEGEND
	,b.AgentRealStartTime_UTC AGSEGSTART_UTC
	,b.AgentDISPSPLIT DISPSPLIT
	,AVG(a.LeadCalls)LeadCalls
	,MIN(DATEDIFF(n,b.LeadRealEndTime,a.LeadSEGSTART)) CB_Intv_MIN
	,AVG(DATEDIFF(n,b.LeadRealEndTime,a.LeadSEGSTART)) CB_Intv_Avg
	,CASE
		WHEN MIN(DATEDIFF(n,b.LeadRealEndTime,a.LeadSEGSTART)) < 1 THEN 0
		ELSE (FLOOR(MIN(DATEDIFF(n,b.LeadRealEndTime,a.LeadSEGSTART)) / 5.0) * 5)
	END CB_Intv_Bucket_MIN
	,CASE
		WHEN AVG(DATEDIFF(n,b.LeadRealEndTime,a.LeadSEGSTART)) < 1 THEN 0
		ELSE (FLOOR(AVG(DATEDIFF(n,b.LeadRealEndTime,a.LeadSEGSTART)) / 5.0) * 5)
	END CB_Intv_Bucket_Avg
INTO #AG2Plus_rpts
FROM rptList b
/*Compare the various Lead calls...*/
INNER JOIN rptList a on b.AgentUCID=a.AgentUCID
	and b.AgentSEGSTART=a.AgentSEGSTART
	/*... but only look at direct consecutive calls; Each has at least one consecutive since we already checked for repeats; */
	AND b.ldOrd = (a.ldOrd-1)
GROUP BY b.[Caller Site]
	,b.[Caller MA]
	,b.[Caller Mgr]
	,b.[Caller Sup]
	,b.[Caller Name]
	,b.[Caller PID]
	,b.AgentPSID
	,b.[Service Tenure]
	,b.AgentAvaya
	,b.AgentUCID
	,b.HANDLETIME
	,b.AgentSEGSTART 
	,b.AgentSEGSTOP 
	,b.AgentRealStartTime_UTC 
	,b.AgentDISPSPLIT 
;
IF OBJECT_ID('tempdb..#AG2Plus_MA') IS NOT NULL BEGIN DROP TABLE #AG2Plus_MA END;
IF OBJECT_ID('tempdb..#AG2Plus_LOC') IS NOT NULL BEGIN DROP TABLE #AG2Plus_LOC END;
IF OBJECT_ID('tempdb..#AG2Plus_BASE') IS NOT NULL BEGIN DROP TABLE #AG2Plus_BASE END;
;
/*Output all results*/
SELECT r.*
FROM #AG2Plus_rpts r with(nolock)
ORDER BY 1,2,3,4,5
	,r.AGSEGSTART
;
;
IF OBJECT_ID('tempdb..#AG2Plus_rpts') IS NOT NULL BEGIN DROP TABLE #AG2Plus_rpts END;
IF OBJECT_ID('tempdb..#AG2Plus_MA') IS NOT NULL BEGIN DROP TABLE #AG2Plus_MA END;
IF OBJECT_ID('tempdb..#AG2Plus_LOC') IS NOT NULL BEGIN DROP TABLE #AG2Plus_LOC END;
IF OBJECT_ID('tempdb..#AG2Plus_BASE') IS NOT NULL BEGIN DROP TABLE #AG2Plus_BASE END;
;