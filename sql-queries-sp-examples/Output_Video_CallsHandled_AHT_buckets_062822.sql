if object_id('tempdb..#reescc_skills') is not null begin drop table #reescc_skills end;
if object_id('tempdb..#reEsccallData_Detail') is not null begin drop table #reEsccallData_Detail end;
if object_id('tempdb..#Caller_callData_Detail') is not null begin drop table #Caller_callData_Detail end;
if object_id('tempdb..#tempWorkerA') is not null begin drop table #tempWorkerA end;
if object_id('tempdb..#leadCallsSwap') is not null begin drop table #leadCallsSwap end;

declare @eDate datetime; 
declare @sDate datetime; 
;

/* Sets  the End Date to the last Minute of the fiscal ex: 06/28/2022 11:59pm */
SET @eDate = '01/28/2022';
;
set @eDate = Dateadd(day,1,@eDate);
set @eDate = DateAdd(second,-1,@eDate);
/* Sets the Start Date two Months back from the start of the fiscal  at Midnight */
SET @sDate = cast(dateadd(day,1,dateadd(month,-2,@eDate)) as date);


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
	,rdm.FCSTGRP
into #reescc_skills
from [DimensionalMapping].[DIM].[RDM_Call_Skill_Split] rdm with(nolock)
where 
	rdm.SWITCHNM in ('cmscsgcdp01','cmswestnce01')
	and rdm.CUSTTYPE = 'Residential'
	 and [LOB_TYPE] = 'Video'
GROUP BY
	rdm.[SWITCHNM]
	,rdm.DISPLAYNM
	,rdm.[ACD]
	,rdm.[START_DATE]
	,rdm.[END_DATE]
	,rdm.[QUEUEID]
	,rdm.[SECONDARYSWITCHNM]
	,rdm.FCSTGRP



/* Swap of Call Data with Placeholders */
select 
	r.DISPLAYNM, 
	r.FCSTGRP,
	cd.ANSLOGIN,
	cd.CALLING_PTY,
	cd.ACD,
	cd.UCID,
	cast(' ' as varchar(124)) [AHT Bucket],
	(case when TALKTIME is null then 0 else TALKTIME end + 
	case when ANSHOLDTIME is null then 0 else ANSHOLDTIME end + 
	case when ACWTIME is null then 0 else ACWTIME end) AHT,
	r.FCSTGRP [Grouping],
	cd.TALKTIME,
	cd.ANSHOLDTIME,
	cd.ACWTIME,
	cd.RINGTIME,
	cd.QUEUETIME,
	cd.DISPTIME,
	cd.TRANSFERRED,
	cd.DISPSPLIT QUEUEID,
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
	dateadd(hour,-5,cd.SEGSTOP_UTC) between @sDate and @eDate
	/* Only Calls Handled */
	and cd.ANSLOGIN is not null
	

update d
set d.[AHT Bucket] = case
		when d.AHT <= 60 then '0000 - 0060'
		when d.AHT <= 120 then '0061 - 0120'
		when d.AHT <= 180 then '0121 - 0180'
		when d.AHT <= 300 then '0181 - 0300'
		when d.AHT <= 600 then '0301 - 0600'
		when d.AHT <= 900 then '0601 - 0900'
		when d.AHT <= 1200 then '0901 - 1200'
		when d.AHT <= 1500 then '1201 - 1500'
		when d.AHT > 1500 then '1500 >'
		else ''
	end
from #reEsccallData_Detail d with(nolock)
;
;
/* Grab Rolled Up Values by Skill Name */
select
	d.[FiscalMth]
	,d.[Grouping]
	,d.[AHT Bucket]
	,count(distinct d.UCID) callsOfferd	
from #reEsccallData_Detail d with(nolock)
group by d.FiscalMth, d.[Grouping], d.[AHT Bucket]



if object_id('tempdb..#leadCallsSwap') is not null begin drop table #leadCallsSwap end;
if object_id('tempdb..#tempWorkerA') is not null begin drop table #tempWorkerA end;
if object_id('tempdb..#reescc_skills') is not null begin drop table #reescc_skills end;
if object_id('tempdb..#reEsccallData_Detail') is not null begin drop table #reEsccallData_Detail end;
if object_id('tempdb..#Caller_callData_Detail') is not null begin drop table #Caller_callData_Detail end;