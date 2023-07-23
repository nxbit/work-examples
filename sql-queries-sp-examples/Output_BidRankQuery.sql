if OBJECT_ID('tempdb..#VID_BidRank_6m') is not null begin drop table #VID_BidRank_6m end;
if OBJECT_ID('tempdb..#VID_BidRank_Base') is not null begin drop table #VID_BidRank_Base end;
if OBJECT_ID('tempdb..#VID_BidRank_6m_base') is not null begin drop table #VID_BidRank_6m_base end;
if OBJECT_ID('tempdb..#VID_BidRank_Base_Fiscals') is not null begin drop table #VID_BidRank_Base_Fiscals end;
if OBJECT_ID('tempdb..#VID_BidRank_6m_fiscals') is not null begin drop table #VID_BidRank_6m_fiscals end;
if object_ID('tempdb..#BidBase') is not null begin drop table #BidBase end;

/*
	012622 - Query has been moved over to CTXCCOINT02 as VM0D does not have an updated UXID Table

*/
/*  Set 1 for Agent, 2 for Sup, and 4 for Lead */
declare @posLevel as int = 2;
/* Set to the Max Completed Fiscal that Should be considered */
declare @fiscalMth as date = '05/28/2023';
/* Bid Date needs to be set to the day the bid opens */
declare @bidDate as date = '07/11/2023';

declare @fiscalStart as date = dateadd(day,1,dateadd(month,-1,@fiscalMth));

declare @scLookBackInterval as int = -11;

/*
- Doc has been updated for all levels
The purpose of this document is to ensure consistency in standards and application of our Shift Bids across all Customer Service groups while also providing direction to the Reporting teams and sites on the criteria and process for Shift Bids at the Agent, Lead and Supervisor levels.
*/
declare @scLookBackCount as int = 3;


/*==============================================================================================*/
--
--		Agent Scorecards are sourced from Scorecard Oultier Report (CorPortal Pulls)
--		Sup Scorecard are sourced from VR Ranking Tool
--		Lead Scorecards are sourced from VR Ranking Tool
--	The below query can be ran against CTXCCOINT02 to gather the Ranking data in a format that 
--	can be imported into VM0DWOWMMSD0001
/* Start of CTXCCOINT02 Query

			select 
			r.id psid
			,dateadd(d,1,dateadd(month,-1,datefromparts(left(r.fiscalMth,4),right(r.fiscalMth,2),28))) startDate
			,datefromparts(left(r.fiscalMth,4),right(r.fiscalMth,2),28) endDate
			,case when r.posLevel = 2 then 'SUPERVISOR' when r.posLevel = 4 then 'LEAD' else null end peerGroup
			,r.fiscalPctRank
			from MiningSwap.dbo.R_Ranking r with(nolock)
			/* pulling Sups and Leads */
			where r.posLevel in (2, 4) and fiscalPctRank is not null


End of CTXCCOINT02 Query*/
--
/*==============================================================================================*/

/* This Section is to Stop the User from Running the Bid Ranks without enought data. */
declare @yDate as date = dateadd(day,-1,dateadd(hour,-5,getutcdate()));
/* Caculating the 12 month period we would expect to have completed performance data */ 
declare @cFiscal as date = 
	CASE
		WHEN DATEPART(dd,@yDate) < 29 THEN DATEADD(d,28-DATEPART(dd,@yDate),@yDate)
		ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,@yDate)-28),@yDate))
	END;
declare @eFiscal as date; 
set @eFiscal = dateadd(month,
	case
		when datediff(day,dateadd(day,1,dateadd(month,-1,@cFiscal)),@yDate) < 14 then -2
		else -1
	end, @cFiscal);
declare @sFiscal as date = dateadd(month,-11,@eFiscal);

/* Checking if we have the expected 12 month Period in the DataTables */
declare @fmonthCount as int;
;;with FiscalCounts as (
select
	/* Legacy CorPortal provided Rankings, the End Dates may not have always aligned to that of the fiscal. 
	using cacl to shift everything to fiscal Month end date */
	CASE
		WHEN DATEPART(dd,ss.endDate) < 29 THEN DATEADD(d,28-DATEPART(dd,ss.endDate),ss.endDate)
		ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,ss.endDate)-28),ss.endDate))
	END [fiscalMth]
from MiningSwap.dbo.BID_Scorecard_Swap ss with(nolock)
where ss.endDate between @sFiscal and @eFiscal
group by
	CASE
		WHEN DATEPART(dd,ss.endDate) < 29 THEN DATEADD(d,28-DATEPART(dd,ss.endDate),ss.endDate)
		ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,ss.endDate)-28),ss.endDate))
	END
)
select
	@fmonthCount = count(distinct fiscalMth)
from FiscalCounts


if @fmonthCount = 12 
begin

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
			,avg(performanceValue) StackedRankPercentile
		from MiningSwap.dbo.BID_Scorecard_Swap with(nolock)
		where performanceValue is not null
		and 
			case when @posLevel = 1 then 
				case when peerGroup not in ('SUPERVISOR','LEAD') then 1 else 0 end
				when @posLevel = 2 then 
				case when peerGroup in ('SUPERVISOR') then 1 else 0 end
				when @posLevel = 4 then 
				case when peerGroup in ('LEAD') then 1 else 0 end
				else 0
			end = 1
		and peerGroup not like '%NH%'
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
			,avg(fc.StackedRankPercentile) StackedRankPercentile
			,row_number() over (partition by fc.psid order by fc.fiscalMth Desc) rn
		from withFiscalCol fc with(nolock)
	
		group by fc.psid
			,fc.fiscalMth
		)

	/*==============================================================================================*/
	/* #VID_BidRank_6m is serving as a Base table in which we now can Pivot the last 6m Scorecards
		This will allow to pviot out the last 6m regardless if they were consecutive or not	with in the
		last 12 months. (Last 3 Scorecards with in the 12 Month Window) */
	/*==============================================================================================*/
	select 
		g.psid
		,g.rn
		,g.fiscalMth
		,g.StackedRankPercentile
	into #VID_BidRank_6m_base
	from groupedSCs g with(nolock)
	where g.rn <= @scLookBackCount



	select
	b.psid
	,b.rn
	,b.StackedRankPercentile
	into #VID_BidRank_6m
	from #VID_BidRank_6m_base b


	select
	b.psid
	,b.rn
	,cast(b.fiscalMth as int) fiscalMth
	into #VID_BidRank_6m_fiscals
	from #VID_BidRank_6m_base b




	/* Main Pivot for Percentile */
	select 
	pt.psid
	,
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
	case when pt.[12] is null then 0 else 1 end  scCount
	,
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
		select * from #VID_BidRank_6m with(nolock)
		)t 
	pivot(
		avg(StackedRankPercentile)
		for [rn]
		in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	) pt 





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
		select * from #VID_BidRank_6m_fiscals with(nolock)
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
	 ,CASE WHEN c.[Effective Date] > dateadd(month,-6,'06/08/2023') THEN 1 ELSE 0 END [BidRankRelated]
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
	--INNER JOIN vidSites vs on w.MANAGEMENTAREAID=vs.MANAGEMENTAREAID
	/*==============================================================================================*/
	/*
		Only excluding Document Warnings as per 2/1/22 Bid Ranking Criteria
		o	Corrective actions for Written Warnings and above or PIP for any reason delivered in the last 6 months will disqualify the employee from shift bid eligibility.
	*/
	/*==============================================================================================*/

	where c.[Discp Step Descr] != 'Documented Warning' 
	/* 012722 - As Per Brandon Documented Warning/PIP will disqualify
	and c.[Discp Step Descr] != 'Documented Warning/PIP'
	*/
	)



	--TODO: Add Winner of Previous Bid Logic
	/*==============================================================================================*/
	/* Sched Change Grabs Swap/CTE of the Last Schedule Change, [rn] will row number over the 
		effective dates returning a 1 for the latest schedule change, [diffMon] will return the 
		number of months between the last run */
	/*==============================================================================================*/
	, schedChange as (

	select 
	s.PSID
	,s.[effectiveDate]
	,row_number() over (partition by s.PSID order by s.[effectiveDate] desc) rn
	,dateDiff(month,s.[effectiveDate],@bidDate) diffMon
	from MiningSwap.dbo.BID_Awarded_Schedules s with(nolock)
	/*==============================================================================================*/
	/*
		o	Ranking file provided should include the # of months since last Shift Bid schedule change. (even if less than 6 months)
	*/
	/*==============================================================================================*/
	where Rescinded_Offer = 0
	-- Rescinded Offers will be handled in Seprate CTE   TODO: Noteate Row Number after CTE Is added

	), rescindedOffers as (

	select 
	s.PSID
	,s.[effectiveDate]
	,row_number() over (partition by s.PSID order by s.[effectiveDate] desc) rn
	,dateDiff(month,s.[effectiveDate],@bidDate) diffMon
	from MiningSwap.dbo.BID_Awarded_Schedules s with(nolock)
	/*==============================================================================================*/
	/*
		o	Ranking file provided should include the # of months since last Shift Bid schedule change. (even if less than 6 months)
	*/
	/*==============================================================================================*/
	where Rescinded_Offer = 1
	)
	select 
	ma.MGMTAREANAME [Site]
	,cast('' as varchar) DeptName
	,jc.TITLE [Employee Title]
	,w.FIRSTNAME+' '+w.LASTNAME [Employee Name]
	,b.psid PEOPLESOFTID
	,b.scCount [Scorecard Count]
	,ro.diffMon
	,ro.rn
	,datediff(day,w.SERVICEDATE,@bidDate) dayTenure

	,case 
		when 
		
			/* Has 6 Months of Scorecards */
			b.scCount = 3 and

			/* Does not have a Issued CA in last 6m */
				case 
					when DateDiff(month,c.[Effective Date],@bidDate) > 6 then 1
					when c.[Effective Date] is null then 1
					else 0
				end = 1 and

			/* No Shift Change in the Last 6m */
			/* No Rescinded Offer in the last Month */
				case
					when sc.diffMon <= 6 then 1
					when ro.diffMon = 1 and ro.rn = 1  then 1
				
					else 0
				end = 0



			then 1




		else 0
	end [Qual]

	,c.[Discp Step Descr] [CA Step Description]
	,c.[Effective Date] [CA Effective Date]

	,c.[Purge Date] [CA Purge Date]
	,format(sc.[effectiveDate],'MM/dd/yy') [Last Schedule Change]
	,dateDiff(month,sc.[effectiveDate],@bidDate) [Months since Last Schedule Change]
	,case when ro.rn is not null then 'Recinded Last Offer' else null end [Rescinded Offer Flag]
	,round(b.scSum/nullif(b.scCount,0),4) [CP Scorecard Avg]
	,b.[1] [Month 1]
	,b.[2] [Month 2]
	,b.[3] [Month 3]
	/*
	,b.[4] [Month 4]
	,b.[5] [Month 5]
	,b.[6] [Month 6]
	*/
	/*
		012422 - If Fiscal Month Range is Expaned, Columns can be uncommeted below. 

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
	left join schedChange sc on sc.rn = 1 and sc.PSID = b.psid
	left join #VID_BidRank_Base_Fiscals bf on b.psid = bf.psid
	left join MiningSwap.dbo.PROD_WORKERS w with(nolock) on b.psid = w.NETIQWORKERID
	left join MiningSwap.dbo.PROD_MANAGEMENT_AREAS ma with(nolock) on w.MANAGEMENTAREAID = ma.MANAGEMENTAREAID
	left join MiningSwap.dbo.PROD_JOB_CODES jc with(nolock) on w.JOBCODEID = jc.JOBCODEID
	left join MiningSwap.dbo.PROD_JOB_ROLES jr with(nolock) on w.JOBROLEID = jr.JOBROLEID
	/* As per Brandon do not include sups that are on the sup exclusion list */
	left join MiningSwap.dbo.RANKING_Sup_Exclusions se with(nolock) on b.psid = se.PSID
	/* As per Brandon secondardy list needed for exclusions form  just the BID */
	left join MiningSwap.dbo.BID_Exclusions be with(nolock) on b.psid = be.PSID
	left join rescindedOffers ro with(nolock) on b.psid = ro.PSID
	where 
	case when @posLevel = 1 then
	case when jr.JOBROLE = 'Frontline' then 1 else 0 end
	when @posLevel = 2 then 
	case when jr.JOBROLE = 'Supervisor' then 1 else 0 end
	when @posLevel = 4 then 
	case when jr.JOBROLE = 'Lead' then 1 else 0 end
	else 0 
	end = 1
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

/*======================================================================================================================
			BRIDGE SECTION
			ADDING BRIDGE QUAL DURING THIS STEP AS THEY WILL NOT HAVE ANY ACUTAL SCORECARDS ONLY PERFORMANCE VALUES.
======================================================================================================================*/
/**/


declare @bridgeBase as table ([cpavg] float, [Site] varchar(50), Qual int, pid int, deptname varchar(50))
--insert into @bridgeBase
--values(1,'CC-Appleton Call Center-Bridge',1,6257080,'Resi Vid Rep')
--,(1,'CC-Appleton Call Center-Bridge',1,6257310,'Resi Vid Rep')
--,(1,'CC-Appleton Call Center-Bridge',1,6257574,'Resi Vid Rep')
--,(1,'CC-Appleton Call Center-Bridge',1,6258130,'Resi Vid Rep')
--,(0.966734,'CC-El Paso Call Center-Bridge',1,6253940,'Resi Vid Rep')
--,(1,'CC-El Paso Call Center-Bridge',1,6254201,'Resi Vid Rep')
--,(0.966667,'CC-El Paso Call Center-Bridge',1,6254676,'Resi Vid Rep')
--,(0.966667,'CC-El Paso Call Center-Bridge',1,6254748,'Resi Vid Rep')
--,(0.967742,'CC-El Paso Call Center-Bridge',1,6255049,'Resi Vid Rep')
--,(0.952361,'CC-El Paso Call Center-Bridge',1,6255190,'Resi Vid Rep')
--,(0.967742,'CC-El Paso Call Center-Bridge',1,6255402,'Resi Vid Rep')
--,(0.967742,'CC-El Paso Call Center-Bridge',1,6255576,'Resi Vid Rep')
--,(0.966667,'CC-El Paso Call Center-Bridge',1,6255761,'Resi Vid Rep')
--,(0.951613,'CC-El Paso Call Center-Bridge',1,6255762,'Resi Vid Rep')
--,(0.983535,'CC-El Paso Call Center-Bridge',1,6256217,'Resi Vid Rep')
--,(1,'CC-El Paso Call Center-Bridge',1,6256375,'Resi Vid Rep')
--,(1,'CC-El Paso Call Center-Bridge',1,6256392,'Resi Vid Rep')
--,(0.989133,'CC-El Paso Call Center-Bridge',1,6256592,'Resi Vid Rep')
--,(0.954545,'CC-Flushing Call Center-Bridge',1,6252267,'Resi Vid Rep')
--,(0.977273,'CC-Flushing Call Center-Bridge',1,6252601,'Resi Vid Rep')
--,(0.954674,'CC-Flushing Call Center-Bridge',1,6253543,'Resi Vid Rep')
--,(0.954545,'CC-Flushing Call Center-Bridge',1,6254771,'Resi Vid Rep')
--,(0.968161,'CC-RochesterMN Bandell CC-Bridge',1,6253669,'Resi Vid Rep')
--,(0.995879,'CC-RochesterMN Bandell CC-Bridge',1,6254937,'Resi Vid Rep')
--,(0.978261,'CC-RochesterMN Bandell CC-Bridge',1,6255843,'Resi Vid Rep')
--,(0.977778,'CC-RochesterMN Bandell CC-Bridge',1,6152404,'Resi Vid Rep')
--,(1,'CC-Gran Vista Call Center-Bridge',1,6252570,'Resi Vid Rep')
--,(0.977273,'CC-Gran Vista Call Center-Bridge',1,6253614,'Resi Vid Rep')
--,(0.957812,'CC-Gran Vista Call Center-Bridge',1,6254197,'Resi Vid Rep')
--,(0.977273,'CC-Gran Vista Call Center-Bridge',1,6254285,'Resi Vid Rep')
--,(0.995549,'CC-Gran Vista Call Center-Bridge',1,6254286,'Resi Vid Rep')
--,(0.977273,'CC-Gran Vista Call Center-Bridge',1,6254397,'Resi Vid Rep')
--,(0.954545,'CC-Gran Vista Call Center-Bridge',1,6255609,'Resi Vid Rep')


delete from #BidBase where PEOPLESOFTID in (select b.pid from @bridgeBase b);

insert into #BidBase([CP Scorecard Avg], Site, Qual, PEOPLESOFTID, DeptName)
select
	[cpavg], [Site], [Qual], [pid], [deptname]
from @bridgeBase




update a
set 
	a.[Employee Title] = jc.TITLE
	,a.[Employee Name] = w.FIRSTNAME + ' ' + w.LASTNAME
from #BidBase a with(nolock)
inner join MiningSwap.dbo.PROD_WORKERS w with(nolock)
	on a.PEOPLESOFTID = w.NETIQWORKERID
inner join MiningSwap.dbo.PROD_JOB_CODES jc with(nolock)
	on w.JOBCODEID = jc.JOBCODEID
where a.[Employee Title] is null;
;

	select 
	[Site],
	[Employee Title],
	[Employee Name],
	[PEOPLESOFTID],
	row_number() over(
	/* Bridge should be Sorted at the bottom of each Site Rank */
		partition by 
			replace([Site],'-Bridge',''),
			Qual,
			case when [Employee Title] like '%Disability%' then 1 else 0 end
		/* First Order by is when Bridge or not to sperate the groups, then by Cp Scorecard Avg (Attendance for Bridge Agents) */
		order by case when patindex('%-Bridge', [Site]) > 0 then 99999 else 1 end asc, [Cp Scorecard Avg] DESC, 
		/* Added secondary Sort to break Ties in Cp Scorecard Avg */
		[dayTenure] DESC
		) BidRank,
	[Scorecard Count],
	[Qual],
	/* 022322 - Removed the CA type */
	case when [CA Step Description] is null then null else 'CA' end [CA Step Description],
	[CA Effective Date],
	[CA Purge Date],
	[Last Schedule Change],
	[Months since Last Schedule Change],
	[Rescinded Offer Flag],
	[CP Scorecard Avg],
	[Month 1],
	[Month 2],
	[Month 3],
	/*[Month 4],
	[Month 5],
	[Month 6],*/
	[Fiscals Used]
	from #BidBase
	where DeptName like 'Resi%Vid%Rep%'
	order by [Qual] desc


end
else
begin
	Select
		'Go back to Data Integrity Checks.';

end;



if object_ID('tempdb..#BidBase') is not null begin drop table #BidBase end;
if OBJECT_ID('tempdb..#VID_BidRank_Base_Fiscals') is not null begin drop table #VID_BidRank_Base_Fiscals end;
if OBJECT_ID('tempdb..#VID_BidRank_6m_fiscals') is not null begin drop table #VID_BidRank_6m_fiscals end;
if OBJECT_ID('tempdb..#VID_BidRank_6m_base') is not null begin drop table #VID_BidRank_6m_base end;
if OBJECT_ID('tempdb..#VID_BidRank_6m') is not null begin drop table #VID_BidRank_6m end;
if OBJECT_ID('tempdb..#VID_BidRank_Base') is not null begin drop table #VID_BidRank_Base end;