/*VM0PWOWMMSDVS0.corp.chartercom.com*/
if object_id('tempdb..#reescc_skills') is not null begin drop table #reescc_skills end;
if object_id('tempdb..#reEsccallData_Detail') is not null begin drop table #reEsccallData_Detail end;
if object_id('tempdb..#Caller_callData_Detail') is not null begin drop table #Caller_callData_Detail end;
if object_id('tempdb..#tempWorkerA') is not null begin drop table #tempWorkerA end;
if object_id('tempdb..#leadCallsSwap') is not null begin drop table #leadCallsSwap end;

declare @eDate datetime; 
declare @sDate datetime; 
declare @tDay datetime;
;
/* @tDay gets set to the Last Minute of Yesterday   Yesterday Date @ 11:59 pm */
SET @tDay = dateadd(day,-1,cast(dateadd(hour,-4,getutcdate()) as date));
SET @tDay = dateadd(second,-1,@tDay);

--SET @tDay = cast('06/29/2022' as date);

/* Sets  the End Date to the last Minute of the fiscal ex: 06/28/2022 11:59pm */
SET @eDate = cast(CASE
        WHEN DATEPART(dd,@tDay) < 29 THEN DATEADD(d,28-DATEPART(dd,@tDay),@tDay)
        ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,@tDay)-28),@tDay))
    END as date);
;

declare @fiscal as date = @eDate;


/* Sets the Start Date two Months back from the start of the fiscal  at Midnight */
SET @sDate = cast(dateadd(day,1,dateadd(month,-1,@eDate)) as date);

if @eDate > dateadd(day,-1,dateadd(hour,-4,GETUTCDATE()))
begin
	set @eDate = cast(dateadd(day,-1,dateadd(hour,-4,GETUTCDATE())) as date);
end;

set @eDate = Dateadd(day,1,@eDate);
set @eDate = DateAdd(second,-1,@eDate);




/* If the End Date requested is before the ReEscalation Queues usage, Dates 
			are set to produce a blank return	*/
/* ReEscalation Queues were setup on 06/12/2022  */
if cast('06/12/2022' as date) between @sDate and @eDate begin
	set @sDate = '06/12/2022';
end;
if @eDate < cast('06/12/2022' as date) begin
	set @sDate = '12/30/1899';
	set @eDate = @sDate;
end;



/* Temp for ReEscc Skills, casting for DataType Matching  */
select 
	cast(rdm.[SWITCHNM] as varchar(24)) [SWITCHNM]
	,rdm.DISPLAYNM
	,cast(rdm.[ACD] as tinyint) [ACD]
	/* QUEUE ID 5999 was Re-Purposed, Only Caputuring Data from 7/14/22 and on  */
	,case 
		when QUEUEID in (5999) then  cast('07/14/2022' as datetime)
		else cast(rdm.[START_DATE] as datetime) end [START_DATE]
	,cast(rdm.[END_DATE] as datetime) [END_DATE]
	,CAST(rdm.[QUEUEID] as smallint) [QUEUEID]
	,cast(rdm.[SECONDARYSWITCHNM] as varchar(24)) [SECONDARYSWITCHNM]
into #reescc_skills
from [DimensionalMapping].[DIM].[RDM_Call_Skill_Split] rdm with(nolock)
where 
	/* Intending to pull Skill #'s (5723, 5703, 5737, 5751, 5799, 5709, 5739, 5713, 5750)*/
	--[DISPLAYNM] like '%Es1%'
	 [QUEUEID] in (5723, 5703, 5737, 5751, 5799, 5709, 5739, 5713, 5750, 5999)
	and [DISPLAYNM] like '%Vid%'
	and [LOB_TYPE] = 'Escalations'
GROUP BY
	rdm.[SWITCHNM]
	,rdm.DISPLAYNM
	,rdm.[ACD]
	,rdm.[START_DATE]
	,rdm.[END_DATE]
	,rdm.[QUEUEID]
	,rdm.[SECONDARYSWITCHNM]



/* Swap of Call Data with Placeholders */
select 
	--r.DISPLAYNM, 
	cd.ANSLOGIN,
	--cast(' ' as varchar(50)) [ANSSite],
	--cast(' ' as varchar(50)) [ANSName],
	--cast(' ' as varchar(50)) [ANSTitle],
	cast(0 as numeric(10,0)) [ANSPSID],
	cast(0 as numeric(10,0)) [ANSWORKERID],
	cd.CALLING_PTY,
	CAST(NULL as varchar(30)) [CALLINGAvaya],
	--cast(' ' as varchar(50)) [CALLINGSite],
	--cast(' ' as varchar(50)) [CALLINGName],
	--cast(' ' as varchar(50)) [CALLINGTitle],
	cast(0 as numeric(10,0)) [CALLINGPSID],
	cast(0 as numeric(10,0)) [CALLINGSUPPSID],
	cast(0 as numeric(10,0)) [CALLINGWORKERID],
	--cd.ACD,
	cd.UCID,
	--dateadd(hour,-4,cd.SEGSTART_UTC) SEGSTART,
	dateadd(hour,-4,cd.SEGSTOP_UTC) SEGSTOP,
	--cast(null as int) pXfr,
	/* Time Stamp Math for Xfr  */
	--dateadd(s,(cd.DISPTIME + cd.TALKTIME + cd.ANSHOLDTIME),cd.SEGSTART_UTC) reXfrEnd,
	--dateadd(s,cd.DISPTIME,cd.SEGSTART_UTC) reJoinStart,
	--dateadd(s,(cd.DISPTIME + cd.TALKTIME + cd.ANSHOLDTIME + cd.ACWTIME),cd.SEGSTART_UTC) reJoinEnd,
	cd.SEGSTART_UTC,
	--cd.TALKTIME,
	--cd.ANSHOLDTIME,
	--cd.ACWTIME,
	--cd.RINGTIME,
	--cd.QUEUETIME,
	--cd.DISPTIME,
	--cd.TRANSFERRED,
	--cd.DISPSPLIT QUEUEID,
	cast(CASE
    WHEN DATEPART(dd,cd.SEGSTOP_UTC) < 29 THEN DATEADD(d,28-DATEPART(dd,cd.SEGSTOP_UTC),cd.SEGSTOP_UTC)
    ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,cd.SEGSTOP_UTC)-28),cd.SEGSTOP_UTC))
	END as date) [FiscalMth],
	cast(dateadd(hour,-4,cd.SEGSTOP_UTC) as date) cDate
into #reEsccallData_Detail
from SwitchData.ECH.Switch_Call_Data cd with(nolock)
inner join #reescc_skills r with(nolock)	
on cd.DISPSPLIT = r.QUEUEID
	and cd.ACD = r.ACD
	and cd.CMSSERVER in (r.SWITCHNM, r.SECONDARYSWITCHNM)
	and cd.SEGSTOP_UTC between r.[START_DATE] and r.[END_DATE]
where
	/* 08082022 - Updated to Look at SegStop Eastern Shift not UTC */
	cd.SEGSTOP between @sDate and @eDate
	

/*Bounce the detail through the login data to find the Avaya IDs...*/
UPDATE s
SET [CALLINGAvaya] = h.LOGID
FROM #reEsccallData_Detail s
INNER JOIN SwitchData.CMS.HAGLOG h on 
	s.SEGSTART_UTC between h.LOGIN_UTC and ISNULL(h.LOGOUT_UTC,GETUTCDATE())
	/*...stations first...*/
	AND s.CALLING_PTY = h.EXTN
WHERE s.[CALLINGAvaya] IS NULL


/*...then a check for the remainder not updated above...*/
UPDATE s
SET [CALLINGAvaya] = h.LOGID
FROM #reEsccallData_Detail s
INNER JOIN SwitchData.CMS.HAGLOG h on
	s.SEGSTART_UTC between h.LOGIN_UTC and ISNULL(h.LOGOUT_UTC,GETUTCDATE())
	/*...validating any direct AvayaID matches*/
	AND s.CALLING_PTY = h.LOGID
WHERE s.[CALLINGAvaya] IS NULL

/*Clean the LOGID values*/
UPDATE s
SET s.[CALLINGAvaya] = LTRIM(RTRIM(s.[CALLINGAvaya]))
FROM #reEsccallData_Detail s
;
;
/* Grabbing a Swap of Avaya Worker Accounts for whom data is pulled*/
select 
WORKERID
,ACCOUNTIDVALUE
,STARTDATE
,case when ENDDATE is null then dateadd(day,1,@tDay) else ENDDATE END ENDDATE
into #tempWorkerA
from UXID.EMP.Worker_Accounts a with(nolock)
where 
	((a.ACCOUNTIDVALUE in (select dd.ANSLOGIN from #reEsccallData_Detail dd with(nolock) group by dd.ANSLOGIN)) or
	(a.ACCOUNTIDVALUE in (select dd.CALLINGAvaya from #reEsccallData_Detail dd with(nolock) group by dd.CALLINGAvaya))) 
	and a.ACCOUNTTYPEID = 7
	and isnumeric(a.ACCOUNTIDVALUE) = 1
	and a.STARTDATE < @eDate 
	and case 
			when a.ENDDATE is null then 1 
			when a.ENDDATE > @sDate then 1
			else 0
		end = 1;



/* Applying Worker ID's from tempWorkers */
update #reEsccallData_Detail
set ANSWORKERID = a.WORKERID
from #tempWorkerA a
where #reEsccallData_Detail.ANSLOGIN = a.ACCOUNTIDVALUE and #reEsccallData_Detail.SEGSTOP between a.STARTDATE and a.ENDDATE


update #reEsccallData_Detail
set CALLINGWORKERID = a.WORKERID
from #tempWorkerA a
where #reEsccallData_Detail.CALLINGAvaya = a.ACCOUNTIDVALUE and #reEsccallData_Detail.SEGSTOP between a.STARTDATE and a.ENDDATE
	



if object_id('tempdb..#ma_swap') is not null begin drop table #ma_swap end;
if object_id('tempdb..#jc_swap') is not null begin drop table #jc_swap end;
if object_id('tempdb..#pw_swap') is not null begin drop table #pw_swap end;


select
	m.MANAGEMENTAREAID
	,m.MGMTAREANAME
into #ma_swap
from UXID.REF.Management_Areas m with(nolock)
group by
	m.MANAGEMENTAREAID
	,m.MGMTAREANAME

select
	j.JOBCODEID,
	j.TITLE
into #jc_swap
from UXID.REF.Job_Codes j with(nolock)
group by
	j.JOBCODEID,
	j.TITLE

select 
	w.WORKERID,
	w.NETIQWORKERID, 
	case when w.PREFFNAME is null then w.FIRSTNAME else w.PREFFNAME end + ' ' + w.LASTNAME empName,
	m.MGMTAREANAME,
	j.TITLE
into #pw_swap
from UXID.EMP.Workers w with(nolock)
inner join #ma_swap m with(nolock) on w.MANAGEMENTAREAID = m.MANAGEMENTAREAID
inner join #jc_swap j with(nolock) on w.JOBCODEID = j.JOBCODEID



/* Applying PSIDs */
update #reEsccallData_Detail
set ANSPSID = a.NETIQWORKERID
from #pw_swap a
where #reEsccallData_Detail.ANSWORKERID = a.WORKERID
update #reEsccallData_Detail
set CALLINGPSID = a.NETIQWORKERID
from #pw_swap a
where #reEsccallData_Detail.CALLINGWORKERID = a.WORKERID
/* Update Historical Sup */
update a
	set a.CALLINGSUPPSID = shd.SUPPEOPLESOFTID
from #reEsccallData_Detail a with(nolock)
inner join UXID.EMP.Supervisor_Historical_Daily shd with(nolock)
	on a.CALLINGPSID = shd.PEOPLESOFTID
	and a.cDate between shd.STARTDATE and case when shd.ENDDATE is null then dateadd(day,1,getutcdate()) else shd.ENDDATE end


if object_id('tempdb..#ma_swap') is not null begin drop table #ma_swap end;
if object_id('tempdb..#jc_swap') is not null begin drop table #jc_swap end;
if object_id('tempdb..#pw_swap') is not null begin drop table #pw_swap end;




select 
	LeadPSID,
	cast(CASE
    WHEN DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP)) < 29 THEN DATEADD(d,28-DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP)),dateadd(hour,-4,lc.LeadSEGSTOP))
    ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP))-28),dateadd(hour,-4,lc.LeadSEGSTOP)))
	END as date) [FiscalMth],
	count(distinct lc.LeadUCID) cCount
into #leadCallsSwap
from SwitchData.ECH.Lead_Calls lc with(nolock)
where 
cast(CASE
    WHEN DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP)) < 29 THEN DATEADD(d,28-DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP)),dateadd(hour,-4,lc.LeadSEGSTOP))
    ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP))-28),dateadd(hour,-4,lc.LeadSEGSTOP)))
	END as date) = @fiscal
and lc.LeadPSID in (select d.CALLINGPSID from #reEsccallData_Detail d with(nolock) group by d.CALLINGPSID)
group by 
	LeadPSID,
	cast(CASE
    WHEN DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP)) < 29 THEN DATEADD(d,28-DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP)),dateadd(hour,-4,lc.LeadSEGSTOP))
    ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP))-28),dateadd(hour,-4,lc.LeadSEGSTOP)))
	END as date)



/* Return of Lead Call Counts */
;;with l_cte as (
select
	FiscalMth,
	CALLINGPSID,
	count(distinct UCID) cCount
from #reEsccallData_Detail
where FiscalMth = @fiscal
group by 
	FiscalMth,
	CALLINGPSID
)
select c.*,
cast(c.cCount as float) / cast(lc.cCount as float) reEscalationPct
from l_cte c
left join #leadCallsSwap lc with(nolock)
on c.CALLINGPSID = lc.LeadPSID and c.FiscalMth = lc.FiscalMth
where c.cCount <= lc.cCount and c.FiscalMth = @fiscal

if object_id('tempdb..#leadSupCallsSwap') is not null begin drop table #leadSupCallsSwap end;


select 
	sh.SUPPEOPLESOFTID
	,cast(CASE
    WHEN DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP)) < 29 THEN DATEADD(d,28-DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP)),dateadd(hour,-4,lc.LeadSEGSTOP))
    ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP))-28),dateadd(hour,-4,lc.LeadSEGSTOP)))
	END as date) [FiscalMth],
	count(distinct lc.LeadUCID) cCount
into #leadSupCallsSwap
from SwitchData.ECH.Lead_Calls lc with(nolock)
inner join UXID.EMP.Supervisor_Historical_Daily sh with(nolock)
	on sh.PEOPLESOFTID = lc.LeadPSID and lc.StdDate between sh.STARTDATE and case when sh.ENDDATE is null then dateadd(day,1,getutcdate()) else sh.ENDDATE end
where 
cast(CASE
    WHEN DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP)) < 29 THEN DATEADD(d,28-DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP)),dateadd(hour,-4,lc.LeadSEGSTOP))
    ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP))-28),dateadd(hour,-4,lc.LeadSEGSTOP)))
	END as date) = @fiscal
and lc.LeadPSID in (select d.CALLINGPSID from #reEsccallData_Detail d with(nolock) group by d.CALLINGPSID)
group by 
	sh.SUPPEOPLESOFTID,
	cast(CASE
    WHEN DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP)) < 29 THEN DATEADD(d,28-DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP)),dateadd(hour,-4,lc.LeadSEGSTOP))
    ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,dateadd(hour,-4,lc.LeadSEGSTOP))-28),dateadd(hour,-4,lc.LeadSEGSTOP)))
	END as date)


/* Return of Lead Call Counts */
;;with l_cte as (
select
	FiscalMth,
	CALLINGSUPPSID,
	count(distinct UCID) cCount
from #reEsccallData_Detail
where FiscalMth = @fiscal
group by 
	FiscalMth,
	CALLINGSUPPSID
)
select c.FiscalMth, c.CALLINGSUPPSID, 
cast(sum(c.cCount) as float) / cast(sum(lc.cCount) as float) reEscalationPct
from l_cte c
left join #leadSupCallsSwap lc with(nolock)
on c.CALLINGSUPPSID = lc.SUPPEOPLESOFTID and c.FiscalMth = lc.FiscalMth
where c.cCount <= lc.cCount and c.FiscalMth = @fiscal
group by c.FiscalMth, c.CALLINGSUPPSID




if object_id('tempdb..#leadSupCallsSwap') is not null begin drop table #leadSupCallsSwap end;
if object_id('tempdb..#leadCallsSwap') is not null begin drop table #leadCallsSwap end;
if object_id('tempdb..#tempWorkerA') is not null begin drop table #tempWorkerA end;
if object_id('tempdb..#reescc_skills') is not null begin drop table #reescc_skills end;
if object_id('tempdb..#reEsccallData_Detail') is not null begin drop table #reEsccallData_Detail end;
if object_id('tempdb..#Caller_callData_Detail') is not null begin drop table #Caller_callData_Detail end;