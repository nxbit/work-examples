/*VM0PWOWMMSDVS1.corp.chartercom.com*/
SET NOCOUNT ON;
;
IF OBJECT_ID('tempdb..#LQ_Detail') IS NOT NULL BEGIN DROP TABLE #LQ_Detail END;
IF OBJECT_ID('tempdb..#LQ_LeadCMS') IS NOT NULL BEGIN DROP TABLE #LQ_LeadCMS END;
IF OBJECT_ID('tempdb..#LQ_AgentCMS') IS NOT NULL BEGIN DROP TABLE #LQ_AgentCMS END;
;
IF OBJECT_ID('tempdb..#LQ_UXID_BASE') IS NOT NULL BEGIN DROP TABLE #LQ_UXID_BASE END;
IF OBJECT_ID('tempdb..#LQ_UXID_LOC') IS NOT NULL BEGIN DROP TABLE #LQ_UXID_LOC END;
;
;
/*
Remodel to use the Traffic sources of Lead Calls; Generates a previous day listing
of call detail specific to the Video Lead lines;
===========================
082322:	Updated from daily LeadQueue_Detail query; Revised to return the 7 day WESat detail;
082222:	Added additional criteria for join to Switch_Call_Data to clean results when multiple 
		segments in same switch;
*/
;
DECLARE @sDate datetime;
DECLARE @eDate datetime;
;
SET @eDate = DATEADD(d,DATEDIFF(d,0,GETUTCDATE()),0);
/*Offset to WESat*/
SET @eDate = DATEADD(d,-1*DATEPART(dw,@eDate),@eDate)
;
SET @sDate = DATEADD(d,-6,@eDate);
;
/*Offset for datetime*/
SET @eDate = DATEADD(s,-1,DATEADD(d,1,@eDate));
;
;
/*Use the summary table to build a skill list; Escalation Video;*/
SELECT s.ACD
	,s.DISPSPLIT
	,s.CMSSERVER
INTO #LQ_LeadCMS
FROM SwitchData.ECH.Lead_Calls_Summary s with(nolock)
WHERE s.SEGSTOP_Date between @sDate and @eDate
	and s.FCSTGRP = 'Escalations Video'
	and s.CUSTTYPE = 'Residential'
GROUP BY s.ACD
	,s.DISPSPLIT
	,s.CMSSERVER
;
/*Build a listing of which skills need their mapping from RDM for the Agent values;*/
SELECT s.Sending_DISPSPLIT
	,s.SendingACD
	,s.Sending_CMSSERVER
	,CAST(NULL as varchar(255)) Sending_LOB
	,CAST(NULL as varchar(255)) Sending_FG
INTO #LQ_AgentCMS
FROM SwitchData.ECH.Lead_Calls_Summary s with(nolock)
WHERE s.SEGSTOP_Date between @sDate and @eDate
	and s.FCSTGRP = 'Escalations Video'
	and s.CUSTTYPE = 'Residential'
	and s.Sending_DISPSPLIT > 0
GROUP BY s.Sending_DISPSPLIT
	,s.SendingACD
	,s.Sending_CMSSERVER
;
/*Build swap of call detail to minimize bottlenecks;*/
SELECT c.*
INTO #LQ_Detail
FROM SwitchData.ECH.Lead_Calls c with(nolock)
INNER JOIN #LQ_LeadCMS s with(nolock) on s.CMSSERVER=c.LeadCMSSERVER
	and s.ACD=c.LeadACD
	and s.DISPSPLIT=c.LeadDISPSPLIT
WHERE c.LeadSEGSTART between @sDate and @eDate
;
IF OBJECT_ID('tempdb..#LQ_LeadCMS') IS NOT NULL BEGIN DROP TABLE #LQ_LeadCMS END;
;
/*Lookup and apply the active FG value for the agent skills*/
UPDATE a
SET a.Sending_FG=r.FCSTGRP
	,a.Sending_LOB=r.LOB_TYPE
FROM #LQ_AgentCMS a
	,DimensionalMapping.DIM.RDM_Call_Skill_Split r
WHERE a.SendingACD=r.ACD
	and a.Sending_DISPSPLIT=r.QUEUEID
	and a.Sending_CMSSERVER IN (r.SWITCHNM,r.SECONDARYSWITCHNM)
	/*Active mapping the day of the call*/
	AND r.END_DATE >= @sDate
;
;
/*============================*/
/*081922: Now prep the roster values; Active as of the day of the calls;*/
SELECT w.NETIQWORKERID PSID
	,case when w.PREFFNAME is null then w.FIRSTNAME else w.PREFFNAME END+' '+w.LASTNAME EmpName
	,w.WORKERID
	,w.SUPERVISORID
	,w.LOCATIONID
INTO #LQ_UXID_BASE
FROM UXID.EMP.Workers w with(nolock)
WHERE CASE
	WHEN w.TERMINATEDDATE is NULL THEN 1
	WHEN w.TERMINATEDDATE >= @sDate THEN 1
	ELSE 0
END = 1
;
SELECT l.LOCATIONID
	,l.STATE+' '+l.CITY WorkLocation
INTO #LQ_UXID_LOC
FROM UXID.REF.Locations l with(nolock)
;
/*============================*/
;
;
/*Fields inherited from original detail file, updated for the new QMS behaviors and removed biller;*/
SELECT  1 IsData
	,case when c.AgentUCID=0 THEN NULL ELSE FORMAT(c.AgentUCID,'0000000000000000000#') END [Agent UCID]
	/*
	=====================
	Call tracker v Leads only uses the Agent UCID;
	=====================
	*/
	--,DATEDIFF(s,c.AgentRealStartTime,c.AgentRealEndTime) [Handle Time]
	--,c.AgentRealStartTime [Agent Start_EST]
	--,c.AgentDISPSPLIT [Agent Skill]
	--,s.Sending_LOB [Agent Skill LOB]
	--,s.Sending_FG [Agent Skill FG]
	--,case when c.AgentAvaya is null then e.CALLING_PTY else CAST(c.AgentAvaya as bigint) end [Called Lead]
	--,case when c.AgentAvaya is null then '*Not UXID Assigned*' ELSE a.EmpName END [Caller Name]
	--,case when c.AgentAvaya is null then '*Not UXID Assigned*' ELSE aSup.EmpName END [Caller Sup]
	--,case when c.AgentAvaya is null then '*Not UXID Assigned*' ELSE aLoc.WorkLocation END [Caller Site]
	--,c.LeadDIALED_NUM [Dialed Num]
	--,c.LeadSEGSTART [Lead Start_EST]
	--,case when c.LeadUCID=0 THEN NULL ELSE FORMAT(c.LeadUCID,'0000000000000000000#') END [Lead UCID]
	--,case when e.DISPOSITION = 3 THEN 'Abandoned' ELSE 'Answered' END [Lead Call State]
	--,c.LeadDISPSPLIT [Lead SkillNum]
	--,c.LeadFACENM [Lead Skill]
	--,e.QUEUETIME [Lead Queue Time]
	--,c.LeadAvaya [Answering Lead]
	--,l.EmpName [Lead Name]
	--,lSup.EmpName [Lead Sup]
	--,lLoc.WorkLocation [Lead Site]
FROM #LQ_Detail c with(nolock)
	/*
	=====================
	Call tracker v Leads only uses the Agent UCID;
	=====================
	*/
--LEFT OUTER JOIN #LQ_AgentCMS s with(nolock) on c.AgentACD=s.SendingACD
--	and c.AgentCMSSERVER=s.Sending_CMSSERVER
--	and c.AgentDISPSPLIT=s.Sending_DISPSPLIT
--/*====Agent====*/
--LEFT OUTER JOIN #LQ_UXID_BASE a with(nolock) on c.AgentPSID=a.PSID
--LEFT OUTER JOIN #LQ_UXID_BASE aSup with(nolock) on a.SUPERVISORID=aSup.WORKERID
--LEFT OUTER JOIN #LQ_UXID_LOC aLoc with(nolock) on a.LOCATIONID=aLoc.LOCATIONID
--/*====Lead====*/
--LEFT OUTER JOIN #LQ_UXID_BASE l with(nolock) on c.LeadPSID=l.PSID
--LEFT OUTER JOIN #LQ_UXID_BASE lSup with(nolock) on l.SUPERVISORID=lSup.WORKERID
--LEFT OUTER JOIN #LQ_UXID_LOC lLoc with(nolock) on l.LOCATIONID=lLoc.LOCATIONID
--/*Proper QUEUETIME and dispo*/
--LEFT OUTER JOIN SwitchData.ECH.Switch_Call_Data e with(nolock) on e.UCID=c.LeadUCID
--	and e.CMSSERVER=c.LeadCMSSERVER
--	and e.ACD=c.LeadACD
--	and e.SEGSTOP=c.LeadSEGSTOP
--	/*082222:	Ensure only matches to the same lead, if multiple segments exist;*/
--	and CASE
--		WHEN c.LeadAvaya iS NOT NULL AND c.LeadAvaya=e.ANSLOGIN THEN 1
--		WHEN c.LeadAvaya iS NOT NULL THEN 0
--		ELSE 1
--	END=1
/*Only need the AgentUCIDs of when the call matches a Lead Call;*/
WHERE c.AgentUCID  > 0
--ORDER BY c.LeadDISPSPLIT
--	,c.AgentAvaya
--	,c.LeadSEGSTART_UTC
;
IF OBJECT_ID('tempdb..#LQ_Detail') IS NOT NULL BEGIN DROP TABLE #LQ_Detail END;
IF OBJECT_ID('tempdb..#LQ_LeadCMS') IS NOT NULL BEGIN DROP TABLE #LQ_LeadCMS END;
IF OBJECT_ID('tempdb..#LQ_AgentCMS') IS NOT NULL BEGIN DROP TABLE #LQ_AgentCMS END;
;
IF OBJECT_ID('tempdb..#LQ_UXID_BASE') IS NOT NULL BEGIN DROP TABLE #LQ_UXID_BASE END;
IF OBJECT_ID('tempdb..#LQ_UXID_LOC') IS NOT NULL BEGIN DROP TABLE #LQ_UXID_LOC END;
;
;