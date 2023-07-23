if OBJECT_ID('tempdb..#VID_BidRank_6m') is not null begin drop table #VID_BidRank_6m end;
if OBJECT_ID('tempdb..#VID_BidRank_Base') is not null begin drop table #VID_BidRank_Base end;
if OBJECT_ID('tempdb..#VID_BidRank_6m_base') is not null begin drop table #VID_BidRank_6m_base end;
if OBJECT_ID('tempdb..#VID_BidRank_Base_Fiscals') is not null begin drop table #VID_BidRank_Base_Fiscals end;
if OBJECT_ID('tempdb..#VID_BidRank_6m_fiscals') is not null begin drop table #VID_BidRank_6m_fiscals end;
if object_ID('tempdb..#BidBase') is not null begin drop table #BidBase end;
if OBJECT_ID('tempdb..#BidBaseOne') is not null begin drop table #BidBaseOne end;


/*
	012622 - Query has been moved over to CTXCCOINT02 as VM0D does not have an updated UXID Table

*/

declare @fiscalStart as date = '04/29/2023';
/* BidDate should be the date the Bid Opens */
declare @bidDate as date = '6/30/2023';
declare @scLookBackInterval as int = -4;
declare @scLookBackCount as int = 3;
declare @holDate date = '07/04/2023';
declare @posLevel as int = 4;





/*==============================================================================================*/
/* withFiscalCol is pulling the Scorecards from BID_Scorecard_Swap and creating a Fiscal Month
	column using the endDate from the data. This produces a table we now can group by the 
	FiscalMth column. Only Grabbing Cards within the last 12 Months	 */
/*==============================================================================================*/
;; with withFiscalCol as (
	select 
		psid psid
		/* Populating a Col with fiscalMth based on EndDate */
		,CASE
			WHEN DATEPART(dd,endDate) < 29 THEN DATEADD(d,28-DATEPART(dd,endDate),endDate)
			ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,endDate)-28),endDate))
		END fiscalMth
		,case when max(peerGroup) like '%NH' then 1 else 0 end NHFlag
		,avg(performanceValue) StackedRankPercentile
	from MiningSwap.dbo.BID_Scorecard_Swap with(nolock)
	where performanceValue is not null
	and case 
			when @posLevel = 4 then 
				case when peerGroup in ('LEAD') then 1 else 0 end
			when @posLevel = 2 then 
				case when peerGroup in ('SUPERVISOR') then 1 else 0 end
			when @posLevel = 1 then 
				case when peerGroup not in ('LEAD','SUPERVISOR') then 1 else 0 end
			else 0
		end = 1
	/*==============================================================================================*/
	/* Lookback is rolling 12 months. To prepare for changes this has been inserted as a var @scLookBackInterval.
	o	For Agents with a gap in scorecards, the most recent 6 qualifying scorecards within a rolling 12 month period will be used.
	 */
	 /*==============================================================================================*/
	and startDate > DateAdd(month,@scLookBackInterval,@fiscalStart)
	group by psid, 
		CASE
			WHEN DATEPART(dd,endDate) < 29 THEN DATEADD(d,28-DATEPART(dd,endDate),endDate)
			ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,endDate)-28),endDate))
		END
	)
/*==============================================================================================*/
/* groupedSCs will flatten the data on the fiscalMth Column generated from the above CTE and Average
	the StackedRankPercentile, this will ensure we recieve one value per fiscal. If a Peer Group
	change happend mid Month the two producing SC's will be averaged.	
	
	NOTE: 012022 - Checking with Brandon if SC's will be averaged. Need to revisit upon confirmation.
		-Its noted that a Change between Mid month should not happen. 
		Brandon: Do you have any examples of it? Gina's team should make the peer group changes at the fiscal
		-No Examples were found, able to proceed as normal
		-Leaving Avg Logic as pulls are sourced from Scorecard Outlier file, if a dup pasted row occurs, essentally the 
		avg betwen the two would return the same orignal value. 
	 */
/*==============================================================================================*/
,groupedSCs as (
	select 
		fc.psid
		,fc.fiscalMth
		,case when sum(fc.NHFlag) > 0 then 1 else 0 end NHFlag
		,avg(fc.StackedRankPercentile) StackedRankPercentile
		,row_number() over (partition by fc.psid order by fc.fiscalMth Desc) rn
	from withFiscalCol fc with(nolock)
	
	group by fc.psid
		,fc.fiscalMth
	)

/*==============================================================================================*/
/* #VID_BidRank_6m is serving as a Base table in which we now can Pivot the last 6m Scorecards
	This will allow to pviot out the last 6m regardless if they were consecutive or not	with in the
	last 12 months. (Last 6 Scorecards with in the 12 Month Window) */
/*==============================================================================================*/
select 
	g.psid
	,g.rn
	,g.fiscalMth
	,g.NHFlag
	,g.StackedRankPercentile
into #VID_BidRank_6m_base
from groupedSCs g with(nolock)
where g.rn <= @scLookBackCount





select
b.psid
,b.rn
,b.NHFlag
,b.StackedRankPercentile
into #VID_BidRank_6m
from #VID_BidRank_6m_base b


select
b.psid
,b.rn
,cast(b.fiscalMth as int) fiscalMth
,b.NHFlag
into #VID_BidRank_6m_fiscals
from #VID_BidRank_6m_base b




/* Main Pivot for Percentile */
select 
pt.psid,
0 NHFlag,
case when pt.[1] is null then 0 else 1 end +
case when pt.[2] is null then 0 else 1 end +
case when pt.[3] is null then 0 else 1 end +
case when pt.[4] is null then 0 else 1 end +
case when pt.[5] is null then 0 else 1 end +
case when pt.[6] is null then 0 else 1 end +
case when pt.[7] is null then 0 else 1 end +
case when pt.[8] is null then 0 else 1 end +
case when pt.[9] is null then 0 else 1 end +
case when pt.[10] is null then 0 else 1 end +
case when pt.[11] is null then 0 else 1 end +
case when pt.[12] is null then 0 else 1 end  scCount,





case when pt.[1] is null then 0 else pt.[1] end +
case when pt.[2] is null then 0 else pt.[2] end +
case when pt.[3] is null then 0 else pt.[3] end +
case when pt.[4] is null then 0 else pt.[4] end +
case when pt.[5] is null then 0 else pt.[5] end +
case when pt.[6] is null then 0 else pt.[6] end +
case when pt.[7] is null then 0 else pt.[7] end +
case when pt.[8] is null then 0 else pt.[8] end +
case when pt.[9] is null then 0 else pt.[9] end +
case when pt.[10] is null then 0 else pt.[10] end +
case when pt.[11] is null then 0 else pt.[11] end +
case when pt.[12] is null then 0 else pt.[12] end  scSum

,pt.[1]
,pt.[2]
,pt.[3]
,pt.[4]
,pt.[5]
,pt.[6]
,pt.[7]
,pt.[8]
,pt.[9]
,pt.[10]
,pt.[11]
,pt.[12]
into #VID_BidRank_Base
from (
	select * from #VID_BidRank_6m a with(nolock) where a.NHFlag = 0
	)t 
pivot(
	avg(StackedRankPercentile)
	for [rn]
	in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) pt 




insert into #VID_BidRank_Base
select 
pt.psid,
1 NHFlag,
case when pt.[1] is null then 0 else 1 end +
case when pt.[2] is null then 0 else 1 end +
case when pt.[3] is null then 0 else 1 end +
case when pt.[4] is null then 0 else 1 end +
case when pt.[5] is null then 0 else 1 end +
case when pt.[6] is null then 0 else 1 end +
case when pt.[7] is null then 0 else 1 end +
case when pt.[8] is null then 0 else 1 end +
case when pt.[9] is null then 0 else 1 end +
case when pt.[10] is null then 0 else 1 end +
case when pt.[11] is null then 0 else 1 end +
case when pt.[12] is null then 0 else 1 end  scCount,





case when pt.[1] is null then 0 else pt.[1] end +
case when pt.[2] is null then 0 else pt.[2] end +
case when pt.[3] is null then 0 else pt.[3] end +
case when pt.[4] is null then 0 else pt.[4] end +
case when pt.[5] is null then 0 else pt.[5] end +
case when pt.[6] is null then 0 else pt.[6] end +
case when pt.[7] is null then 0 else pt.[7] end +
case when pt.[8] is null then 0 else pt.[8] end +
case when pt.[9] is null then 0 else pt.[9] end +
case when pt.[10] is null then 0 else pt.[10] end +
case when pt.[11] is null then 0 else pt.[11] end +
case when pt.[12] is null then 0 else pt.[12] end  scSum

,pt.[1]
,pt.[2]
,pt.[3]
,pt.[4]
,pt.[5]
,pt.[6]
,pt.[7]
,pt.[8]
,pt.[9]
,pt.[10]
,pt.[11]
,pt.[12]

from (
	select * from #VID_BidRank_6m a with(nolock) where a.NHFlag = 1
	)t 
pivot(
	avg(StackedRankPercentile)
	for [rn]
	in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) pt 
where psid not in (select psid from #VID_BidRank_Base b where b.NHFlag = 0)





/* Main Pivot for Fiscal Months Used */
select 
pt.psid

,case when pt.[1] is null then '' else format(cast(pt.[1] as datetime),'MM/dd/yy') end+', '+
case when pt.[2] is null then '' else format(cast(pt.[2] as datetime),'MM/dd/yy') end+', '+
case when pt.[3] is null then '' else format(cast(pt.[3] as datetime),'MM/dd/yy') end+', '+
case when pt.[4] is null then '' else format(cast(pt.[4] as datetime),'MM/dd/yy') end+', '+
case when pt.[5] is null then '' else format(cast(pt.[5] as datetime),'MM/dd/yy') end+', '+
case when pt.[6] is null then '' else format(cast(pt.[6] as datetime),'MM/dd/yy') end+', '+
case when pt.[7] is null then '' else format(cast(pt.[7] as datetime),'MM/dd/yy') end+', '+
case when pt.[8] is null then '' else format(cast(pt.[8] as datetime),'MM/dd/yy') end+', '+
case when pt.[9] is null then '' else format(cast(pt.[9] as datetime),'MM/dd/yy') end+', '+
case when pt.[10] is null then '' else format(cast(pt.[10] as datetime),'MM/dd/yy') end+', '+
case when pt.[11] is null then '' else format(cast(pt.[11] as datetime),'MM/dd/yy') end+', '+
case when pt.[12] is null then '' else format(cast(pt.[12] as datetime),'MM/dd/yy') end [FiscalsUsed]

into #VID_BidRank_Base_Fiscals
from (
	select * from #VID_BidRank_6m_fiscals b with(nolock) where b.NHFlag = 0
	)t 
pivot(
	avg(fiscalMth)
	for [rn]
	in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) pt 

insert into #VID_BidRank_Base_Fiscals
select 
pt.psid

,case when pt.[1] is null then '' else format(cast(pt.[1] as datetime),'MM/dd/yy') end+', '+
case when pt.[2] is null then '' else format(cast(pt.[2] as datetime),'MM/dd/yy') end+', '+
case when pt.[3] is null then '' else format(cast(pt.[3] as datetime),'MM/dd/yy') end+', '+
case when pt.[4] is null then '' else format(cast(pt.[4] as datetime),'MM/dd/yy') end+', '+
case when pt.[5] is null then '' else format(cast(pt.[5] as datetime),'MM/dd/yy') end+', '+
case when pt.[6] is null then '' else format(cast(pt.[6] as datetime),'MM/dd/yy') end+', '+
case when pt.[7] is null then '' else format(cast(pt.[7] as datetime),'MM/dd/yy') end+', '+
case when pt.[8] is null then '' else format(cast(pt.[8] as datetime),'MM/dd/yy') end+', '+
case when pt.[9] is null then '' else format(cast(pt.[9] as datetime),'MM/dd/yy') end+', '+
case when pt.[10] is null then '' else format(cast(pt.[10] as datetime),'MM/dd/yy') end+', '+
case when pt.[11] is null then '' else format(cast(pt.[11] as datetime),'MM/dd/yy') end+', '+
case when pt.[12] is null then '' else format(cast(pt.[12] as datetime),'MM/dd/yy') end [FiscalsUsed]

from (
	select * from #VID_BidRank_6m_fiscals with(nolock) where NHFlag = 1
	and psid not in (select psid from #VID_BidRank_6m_fiscals b with(nolock) where b.NHFlag = 0)
	)t 
pivot(
	avg(fiscalMth)
	for [rn]
	in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) pt 






/*==============================================================================================*/
/* Utilizing the CA Summary Logic to Gather CA data combined with PIP updates
	the [BidRankRelated] Column has been adjusted to look 6m back to flag what has been issued in last 6
	a [CArn] has been added to determine what is the latest CA within the last 6m	 */
/*==============================================================================================*/


/*011922:	Added check to avoid reporting sites rolled to other LOBs*/
;;with vidSites as (
	SELECT vma.MANAGEMENTAREAID
		,vma.MGMTAREANAME
		,COUNT(*) Profiles
	FROM MiningSwap.dbo.PROD_WORKERS vw with(nolock)
	INNER JOIN MiningSwap.dbo.PROD_MANAGEMENT_AREAS vma with(nolock) on vw.MANAGEMENTAREAID=vma.MANAGEMENTAREAID
	INNER JOIN MiningSwap.dbo.PROD_DEPARTMENTS vd with(nolock) on vw.DEPARTMENTID=vd.DEPARTMENTID
	INNER JOIN MiningSwap.dbo.PROD_JOB_ROLES vjr with(nolock) on vw.JOBROLEID=vjr.JOBROLEID
	WHERE vd.NAME LIKE 'Resi%Vid%Rep%'
		and vw.TERMINATEDDATE is null
		and vjr.JOBROLE='Frontline'
		and vw.WORKERTYPE='E'
	GROUP BY vma.MANAGEMENTAREAID
		,vma.MGMTAREANAME
	HAVING COUNT(*) > 70
), CASummary as (

SELECT 1 HasData
 -- 012022 - Updateed getdate() to getUTCDate
 ,CASE WHEN c.[Effective Date] > dateadd(month,-6,@bidDate) THEN 1 ELSE 0 END [BidRankRelated]
 ,c.PSID
 ,c.[Displinary Action/Reason]
 ,FORMAT(c.[Effective Date],'MM/dd/yyyy')[Effective Date]
 ,FORMAT(c.[Purge Date],'MM/dd/yyyy')[Purge Date]
 ,row_number() over(partition by c.PSID order by c.[Effective Date] desc) CArn
 ,c.[Discp Step Descr]
 ,FORMAT(c.[Term Date],'MM/dd/yyyy') [Term Date]
 ,CASE WHEN c.[Term Date] is NULL THEN w.FIRSTNAME+' '+w.LASTNAME ELSE '' END [Agent Name]
 ,CASE WHEN c.[Term Date] is NULL THEN REPLACE(ma.MGMTAREANAME,'CC-','') ELSE '' END [Call Center Name]
FROM MiningSwap.dbo.RANKING_CAR_TEMP c with(nolock)
INNER JOIN MiningSwap.dbo.PROD_WORKERS w with(nolock) on c.PSID=w.NETIQWORKERID
INNER JOIN MiningSwap.dbo.PROD_MANAGEMENT_AREAS ma with(nolock) on w.MANAGEMENTAREAID=ma.MANAGEMENTAREAID
INNER JOIN vidSites vs on w.MANAGEMENTAREAID=vs.MANAGEMENTAREAID
/*==============================================================================================*/
/* Updated to Guidance provoded on 3/24
	Perf Data Range	Average of Prior 3 full months scorecard rating
		Group 1	No Corrective Action or a Verbal Warning Only within last 6-months
		Group 2	Written Warning within last 6 months
		Group 3	Final Warning within last 6 months
		Sorting Order 1	Highest to lowest by Corportal or VR&A(Leads) weighted ranking

*/
/*==============================================================================================*/
where c.[Discp Step Descr] not in ( 'Documented Warning' , 'Termination', 'Performance Improvement Plan', 'Documented Warning/PIP')
/* 012722 - As Per Brandon Documented Warning/PIP will disqualify
and c.[Discp Step Descr] != 'Documented Warning/PIP'
*/
)
select 
ma.MGMTAREANAME [Site]
,cast('' as varchar) DeptName
,jc.TITLE [Employee Title]
,w.FIRSTNAME+' '+w.LASTNAME [Employee Name]
,b.psid PEOPLESOFTID
,b.scCount [Scorecard Count]
,datediff(day,w.SERVICEDATE,@bidDate) dayTenure
,b.NHFlag
,
		/* Does not have a Issued CA in last 6m */
			case 
				when c.[Effective Date] is null then 1
				when c.[Discp Step Descr] like 'Final%' then 3
				else 2
			end [Group]

,c.[Discp Step Descr] [CA Step Description]
,c.[Effective Date] [CA Effective Date]

,c.[Purge Date] [CA Purge Date]
,round(b.scSum/nullif(b.scCount,0),4) [CP Scorecard Avg]
,b.[1] [Month 1]
,b.[2] [Month 2]
,b.[3] [Month 3]
/* 012422 - If Fiscal Month Range is Expaned, Columns can be uncommeted below. 
,b.[4] [Month 4]
,b.[5] [Month 5]
,b.[6] [Month 6]
,b.[7] [Month 7]
,b.[8] [Month 8]
,b.[9] [Month 9]
,b.[10] [Month 10]
,b.[11] [Month 11]
,b.[12] [Month 12]

*/

,replace(bf.FiscalsUsed,', ,','') [Fiscals Used]

into #BidBase
from #VID_BidRank_Base b with(nolock)
left join CASummary c on b.psid = c.PSID and c.BidRankRelated = 1 and c.CArn = 1

left join #VID_BidRank_Base_Fiscals bf on b.psid = bf.psid
left join MiningSwap.dbo.PROD_WORKERS w with(nolock) on b.psid = w.NETIQWORKERID
left join MiningSwap.dbo.PROD_MANAGEMENT_AREAS ma with(nolock) on w.MANAGEMENTAREAID = ma.MANAGEMENTAREAID
left join MiningSwap.dbo.PROD_JOB_CODES jc with(nolock) on w.JOBCODEID = jc.JOBCODEID
left join MiningSwap.dbo.PROD_JOB_ROLES jr with(nolock) on w.JOBROLEID = jr.JOBROLEID
/* As per Brandon do not include sups that are on the sup exclusion list */
left join MiningSwap.dbo.RANKING_Sup_Exclusions se with(nolock) on b.psid = se.PSID
/* As per Brandon secondardy list needed for exclusions form  just the BID */
left join MiningSwap.dbo.BID_Exclusions be with(nolock) on b.psid = be.PSID

where jr.JOBROLE = case when @posLevel = 1 then  'Frontline' when @posLevel = 2 then 'Supervisor' when @posLevel = 4 then 'Lead' else '' end
and w.TERMINATEDDATE is null
and se.PSID is null



















update #BidBase
set #BidBase.DeptName = dep.[NAME]
from (
select bb.PEOPLESOFTID, d.NAME
from #BidBase bb
left join MiningSwap.dbo.PROD_WORKERS w with(nolock) on bb.PEOPLESOFTID = w.NETIQWORKERID
left join MiningSwap.dbo.PROD_DEPARTMENTS d with(nolock) on w.DEPARTMENTID = d.DEPARTMENTID)
dep 
where #BidBase.PEOPLESOFTID = dep.PEOPLESOFTID



select 
[Site],
[Employee Title],
[Employee Name],
[PEOPLESOFTID],
row_number() over(

	partition by 
		
		[Site],
		
		case when [Employee Title] like '%Disability%' then 1 else 0 end
		
	/* Main order is by CP Scorecard Avg */
	
	order by [NHFlag] ASC, [Scorecard Count] DESC, [Group], [Cp Scorecard Avg] DESC,
	/* Added secondary Sort to break Ties in Cp Scorecard Avg */
	[dayTenure] DESC



	
	) BidRank,
[NHFlag],
[Scorecard Count],
[Group],
/* 022322 - Removed the CA type */
--case when [CA Step Description] is null then null else 'CA' end [CA Step Description],
[CA Step Description],
[CA Effective Date],
[CA Purge Date],
[CP Scorecard Avg],
[Month 1],
[Month 2],
[Month 3],
[Fiscals Used]

into #BidBaseOne
from #BidBase b

where DeptName like 'Resi%Vid%Rep%'




;;with baseRoster as (
select 
	ma.MGMTAREANAME [site]
	,w.FIRSTNAME+' '+w.LASTNAME empName
	,w.NETIQWORKERID
	,w.CURRENTPOSITIONSTARTDATE
	,w.HIREDATE
	,jc.TITLE
	,
	case when ma.MGMTAREANAME like '%RochesterMN%' then
		case when datediff(day,case	
			when jc.TITLE like 'Rep%1%' then 
				case when w.CURRENTPOSITIONSTARTDATE is null then w.HIREDATE else w.CURRENTPOSITIONSTARTDATE end
			else w.HIREDATE
		end,@holDate) > 49 then 1 else 0 end 
	else
		case when datediff(day,case	
			when jc.TITLE like 'Rep%1%' then 
				case when w.CURRENTPOSITIONSTARTDATE is null then w.HIREDATE else w.CURRENTPOSITIONSTARTDATE end
			else w.HIREDATE
		end,@holDate) > 84 then 1 else 0 end 
	end prodAgent
	
	,case	
		when jc.TITLE like 'Rep%1%' then 
			case when w.CURRENTPOSITIONSTARTDATE is null then w.HIREDATE else w.CURRENTPOSITIONSTARTDATE end
		else w.HIREDATE
	end vidDate
from MiningSwap.dbo.PROD_WORKERS w with(nolock)
inner join MiningSwap.dbo.PROD_JOB_CODES jc with(nolock)
	on w.JOBCODEID = jc.JOBCODEID
inner join MiningSwap.dbo.PROD_DEPARTMENTS d with(nolock)
	on w.DEPARTMENTID = d.DEPARTMENTID
inner join MiningSwap.dbo.PROD_JOB_ROLES jr with(nolock)
	on w.JOBROLEID = jr.JOBROLEID
inner join MiningSwap.dbo.PROD_MANAGEMENT_AREAS ma with(nolock)
	on w.MANAGEMENTAREAID = ma.MANAGEMENTAREAID
where 
	w.TERMINATEDDATE is null and
	d.NAME like '%Resi%Vid%Rep%' and
	jr.JOBROLE = case when @posLevel = 1 then  'Frontline' when @posLevel = 2 then 'Supervisor' when @posLevel = 4 then 'Lead' else '' end
), maxSiteBase as (
select 
	b.[Site]
	,max(b.BidRank) maxBid
from #BidBaseOne b
group by b.[Site]
)
insert into #BidBaseOne(Site, [Employee Title], [Employee Name], PEOPLESOFTID, BidRank, [Group], [NHFlag])
select 
r.[site]
,r.TITLE
,r.empName
,r.NETIQWORKERID
,row_number() 
	over (
	partition by r.[site]
	order by r.vidDate, r.NETIQWORKERID
	) + b.maxBid bidRank
,4 [Group]
,4 [NHFlag]
from baseRoster r
left join maxSiteBase b on r.[site] = b.[Site]
where r.NETIQWORKERID not in (select o.PEOPLESOFTID from #BidBaseOne o with(nolock)) and r.prodAgent = 1 and r.vidDate <= dateadd(hour,-5,getutcdate())








select *
from #BidBaseOne
where BidRank is not null
order by Site, NHFlag, [Scorecard Count] DESC, [Group] ASC, BidRank ASC






if OBJECT_ID('tempdb..#BidBaseOne') is not null begin drop table #BidBaseOne end;
if object_ID('tempdb..#BidBase') is not null begin drop table #BidBase end;
if OBJECT_ID('tempdb..#VID_BidRank_Base_Fiscals') is not null begin drop table #VID_BidRank_Base_Fiscals end;
if OBJECT_ID('tempdb..#VID_BidRank_6m_fiscals') is not null begin drop table #VID_BidRank_6m_fiscals end;
if OBJECT_ID('tempdb..#VID_BidRank_6m_base') is not null begin drop table #VID_BidRank_6m_base end;
if OBJECT_ID('tempdb..#VID_BidRank_6m') is not null begin drop table #VID_BidRank_6m end;
if OBJECT_ID('tempdb..#VID_BidRank_Base') is not null begin drop table #VID_BidRank_Base end;