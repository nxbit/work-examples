/*VM0PWOWMMSDVS0.corp.chartercom.com*/
SET NOCOUNT ON;
;
/*
090622:	Updated UCID formatting to behave properly with web based QMS searches;
		;
082322:	Confirmed 5950 listed as Spanish per migration docs;  Labeled as non-assist
		but only Spanish non-reescalation skill documented;   Appears to be used by the agents
		;
		Updated to include table bottleneck logic;
		;
061522: Updated to use the Traffic tables and accounts for the server migration;
		Per Brandon El Paso Airport Lead skill will be targeted as Accessibility as of the migration;
		That should be skill 5903;
		;
040622:	Modeled off the LeadQueue Accessibility Misuse query
		;
		Per Brandon, looking for agent calls targeting the 5905 Spanish leadQueue skill;
		;
*/
;
DECLARE @sDate datetime;
DECLARE @eDate datetime;
;
SET @eDate = CAST(FLOOR(CAST(getutcdate() - 0 as float)) as datetime);
SET @sDate = DATEADD(d,-8,@eDate);
;
SET @eDate = DATEADD(s,-1,@eDate);
;
IF OBJECT_ID('tempdb..#LDS_AG_Spanish') IS NOT NULL BEGIN DROP table #LDS_AG_Spanish END;
IF OBJECT_ID('tempdb..#LDS_AG_Spanish_Summ') IS NOT NULL BEGIN DROP table #LDS_AG_Spanish_Summ END;
;
IF OBJECT_ID('tempdb..#LDS_AG_BASE') IS NOT NULL BEGIN DROP table #LDS_AG_BASE END;
IF OBJECT_ID('tempdb..#LDS_AG_MA') IS NOT NULL BEGIN DROP table #LDS_AG_MA END;
IF OBJECT_ID('tempdb..#LDS_AG_JC') IS NOT NULL BEGIN DROP table #LDS_AG_JC END;
;
/*==================*/
/*082322:	Stage swaps of the roster detail to avoid table bottlenecks on Traffic;*/
;;with LDS_AG_MA as (
	SELECT ma.MANAGEMENTAREAID
		,ma.MGMTAREANAME
	FROM UXID.REF.Management_Areas ma with(nolock)
), LDS_AG_JC as (
	SELECT jc.JOBCODEID
		,jc.TITLE
	FROM UXID.REF.Job_Codes jc with(nolock)
), LDS_AG_BASE as (
	SELECT w.WORKERID
		,w.SUPERVISORID
		,case when w.PREFFNAME is null then w.FIRSTNAME else w.PREFFNAME END+' '+w.LASTNAME EmpName
		,w.NETIQWORKERID
		,w.JOBCODEID
		,w.MANAGEMENTAREAID
	FROM UXID.EMP.Workers w with(nolock)
	WHERE w.WORKERTYPE='E'
		and w.BUSINESSUNITID = 6
		AND CASE
			WHEN w.TERMINATEDDATE is null THEN 1
			WHEN w.TERMINATEDDATE >= @sDate THEN 1
			ELSE 0
		END = 1
), p as (
	SELECT --CAST('12/29/2021' as datetime) sDate
		@sDate sDate
		,@eDate eDate
), LDS_AdvStream_Invalid as (
/*Now see if we can find the originating agent segment;*/
SELECT l.AgentPSID
	,case when l.AgentUCID=0 THEN NULL ELSE FORMAT(l.AgentUCID,'0000000000000000000#') END AgUCID
	,l.AgentAvaya CALLING_PTY
	,l.LeadRealStartTime_UTC LdsAnsStart
	,l.AgentRealEndTime_UTC AgSegEnd
    ,DATEDIFF(s,l.AgentRealStartTime_UTC,l.AgentRealEndTime_UTC) AgHandleTime
    ,l.AgentDISPSPLIT DISPSPLIT
    ,r.BLGVENDOR AGBILLER
	/*011922:	Added field for Agent Forecast Group*/
	,r.FACENM
	,r.FCSTGRP AGFCSTGRP
	,r.LANG
    /*Try using the end of the talk period of each call to determine Xfr vs just a question;*/
    ,case 
        when l.AgentRealEndTime_UTC is NULL THEN NULL
        WHEN l.AgentRealEndTime_UTC < l.LeadRealEndTime_UTC THEN 1
        ELSE 0
    END PossibleXfr    
    ,l.LeadAvaya ANSLOGIN
	,l.LeadDIALED_NUM
	,case when l.LeadUCID=0 THEN NULL ELSE FORMAT(l.LeadUCID,'0000000000000000000#') END LdUCID
FROM SwitchData.ECH.Lead_Calls l with(nolock)
INNER JOIN p on l.LeadSEGSTART_UTC between p.sDate and p.eDate
/*011922:	Adding AG FGrp*/
LEFT OUTER JOIN DimensionalMapping.DIM.RDM_Call_Skill_Split r with(nolock) on r.ACD=l.AgentACD
	and r.QUEUEID=l.AgentDISPSPLIT and l.AgentCMSSERVER in (r.SWITCHNM,r.SECONDARYSWITCHNM)
/*013122:	Only those calls where the call was answered;*/
WHERE l.LeadAvaya is not null
	/* Pulled List of Splits Off the Adv Stream Report */
	and l.AgentDISPSPLIT in ('3026', '3027', '3146', '3147', '5120', '5121', '5420', '5421', '6026', '6027', '6146', '6147', '5130', '5131', '3016', '3017', '3018', '3019', '5430', '5431', '6016', '6017', '6018', '6019')
	/* Pulling any Dials other than the Correct */
	and l.LeadDIALED_NUM <> 8895023
)
/*Use folks from the summary to filter the detail*/
SELECT 
	cast(REPLACE(ma.MGMTAREANAME,'CC-','') as nvarchar(150)) [Agent Site]
	,cast(bb.EmpName as nvarchar(150)) [BossBoss Name]
	,cast(b.EmpName as nvarchar(150)) [Boss Name]
	,cast(w.EmpName as nvarchar(150)) [Agent Name]
	,cast(jc.TITLE as nvarchar(150)) [Agent Title]
	,w.NETIQWORKERID HRNum
	,DATEDIFF(s,q.LdsAnsStart,q.AgSegEnd) SEC_UntilAgDisco
	,q.LdsAnsStart [Lead Start UTC]
	,CAST(q.AgSegEnd as date) [Ag EndDate]
	,q.AgSegEnd [Agent End UTC]
	,cast(q.AgUCID as nvarchar(150)) [Agent UCID]
	,cast(q.AgHandleTime as nvarchar(150)) [Agent Handle Time]
	,cast(case when q.LANG LIKE '%Spanish%' THEN 'Spanish' ELSE 'Non-Spanish' END as nvarchar(150)) [Ag Call Grp]
	,cast(q.FACENM as nvarchar(150)) [Agent Call Type]
	,cast(q.LANG as nvarchar(150)) [Agent Lang]
	,cast(q.LdUCID as nvarchar(150)) [Lead UCID]
	,q.LeadDIALED_NUM
FROM LDS_AdvStream_Invalid q with(nolock)
INNER JOIN LDS_AG_BASE w with(nolock) on w.NETIQWORKERID=q.AgentPSID
/*051922:	Per Brandon, adding agent title*/
LEFT OUTER JOIN LDS_AG_JC jc with(nolock) on w.JOBCODEID=jc.JOBCODEID
LEFT OUTER JOIN LDS_AG_MA ma with(nolock) on w.MANAGEMENTAREAID=ma.MANAGEMENTAREAID
LEFT OUTER JOIN LDS_AG_BASE b with(nolock) on w.SUPERVISORID=b.WORKERID
LEFT OUTER JOIN LDS_AG_BASE bb with(nolock) on b.SUPERVISORID=bb.WORKERID
/*040722:	Updated to just show history; Avoid calls that ended after date boundary of newest date;*/
WHERE q.AgSegEnd between @sDate and @eDate
ORDER BY 1,2,3,4
	,q.LdsAnsStart
;
;
IF OBJECT_ID('tempdb..#LDS_AG_Spanish') IS NOT NULL BEGIN DROP table #LDS_AG_Spanish END;
IF OBJECT_ID('tempdb..#LDS_AG_Spanish_Summ') IS NOT NULL BEGIN DROP table #LDS_AG_Spanish_Summ END;
;
IF OBJECT_ID('tempdb..#LDS_AG_BASE') IS NOT NULL BEGIN DROP table #LDS_AG_BASE END;
IF OBJECT_ID('tempdb..#LDS_AG_MA') IS NOT NULL BEGIN DROP table #LDS_AG_MA END;
IF OBJECT_ID('tempdb..#LDS_AG_JC') IS NOT NULL BEGIN DROP table #LDS_AG_JC END;
;