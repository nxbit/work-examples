declare @eDate as date = dateadd(day,-1,dateadd(hour,-5,getutcdate()));
declare @sDate as date = dateadd(day, -6,@eDate);

/* Grabbing a Swap of Video Frontline Rep's PSIDs */
declare @empIDs as table (id nvarchar(15));
insert into @empIDs (id)
select
	NETIQWORKERID
from UXID.EMP.Workers w with(nolock)
inner join UXID.REF.Job_Roles r with(nolock)
	on w.JOBROLEID = r.JOBROLEID
inner join UXID.REF.Departments d with(nolock)
	on w.DEPARTMENTID = d.DEPARTMENTID
where 
	r.JOBROLE = 'Frontline' 
	and d.NAME like 'Resi%Vid%Rep%' 
	and w.TERMINATEDDATE is null
group by
	NETIQWORKERID;
;
if object_id('tempdb..#sevenDaySumm') is not null
begin drop table #sevenDaySumm end;
;
;with sevenDayAuxData as (
select 
	s.EmpID
	,s.StdDate
	,sum(case when s.ShrinkCode like '%07%' then s.ShrinkSeconds else 0.0 end) [AUX Time 07]
	,sum(case when s.ShrinkCode like '%08%' then s.ShrinkSeconds else 0.0 end) [AUX Time 08]
	,sum(case when s.ShrinkCode like '%09%' then s.ShrinkSeconds else 0.0 end) [AUX Time 09]
	,sum(case when s.ShrinkCode like '%13%' then s.ShrinkSeconds else 0.0 end) [AUX Time 13]
from Aspect.WFM.BI_Daily_CS_Shrinkage s with(nolock)
inner join @empIDs i on s.EmpID = i.id
where 
	s.StdDate between @sDate and @eDate
	and case
		when s.ShrinkCode like '%07%' then 1
		when s.ShrinkCode like '%08%' then 1
		when s.ShrinkCode like '%09%' then 1
		when s.ShrinkCode like '%13%' then 1
		else 0
		end = 1
group by
	s.EmpID
	,s.StdDate
)
select 
	a.EmpID [Agent - HR Number]
	,cast(null as nvarchar(50)) [Agent - Full Name]
	,cast(null as nvarchar(50)) [Agent - Supervisor]
	,cast(null as nvarchar(50)) [Agent - Manager]
	,cast(null as nvarchar(50)) [Agent - Call Center Name]
	,a.StdDate [Date]
	,cast(a.[AUX Time 07] as int) [AUX Time 07]
	,cast(a.[AUX Time 08] as int) [AUX Time 08]
	,cast(a.[AUX Time 09] as int) [AUX Time 09]
	,cast(a.[AUX Time 13] as int) [AUX Time 13]
	,case when a.[AUX Time 07] > 300 then 1 else 0 end [AUX7Filter]
	,case when a.[AUX Time 08] > 600 then 1 else 0 end [AUX8Filter]
	,case when a.[AUX Time 09] > 480 then 1 else 0 end [AUX9Filter]
	,case when a.[AUX Time 13] > 1200 then 1 else 0 end [AUX13Filter]
into #sevenDaySumm
from sevenDayAuxData a 
where 
	case
		when a.[AUX Time 07] > 300 then 1
		when a.[AUX Time 08] > 600 then 1
		when a.[AUX Time 09] > 480 then 1
		when a.[AUX Time 13] > 1200 then 1
		else 0
	end = 1;
update a
set 
	a.[Agent - Full Name] = case when w.PREFFNAME is not null then w.PREFFNAME else w.FIRSTNAME end + ' ' + w.LASTNAME
	,a.[Agent - Supervisor] = case when sw.PREFFNAME is not null then sw.PREFFNAME else sw.FIRSTNAME end + ' ' + sw.LASTNAME
	,a.[Agent - Manager] = case when mw.PREFFNAME is not null then mw.PREFFNAME else mw.FIRSTNAME end + ' ' + mw.LASTNAME
	,a.[Agent - Call Center Name] = ma.MGMTAREANAME
from #sevenDaySumm a with(nolock)
inner join UXID.EMP.Workers w with(nolock)
	on a.[Agent - HR Number] = w.NETIQWORKERID
inner join UXID.EMP.Workers sw with(nolock)
	on w.SUPERVISORID = sw.WORKERID
inner join UXID.EMP.Workers mw with(nolock)
	on sw.SUPERVISORID = mw.WORKERID
inner join UXID.REF.Management_Areas ma with(nolock)
	on w.MANAGEMENTAREAID = ma.MANAGEMENTAREAID;
;
/*
select 
	* 
from #sevenDaySumm s with(nolock);
*/

;
if object_id('tempdb..#pivotSumm') is not null 
begin drop table #pivotSumm end;
;
select 
	cast('AUX 7 (Outbound) Outlier' as nvarchar(50)) [Value]
	,s.[Agent - Call Center Name]
	,s.[Date]
	,sum(s.AUX7Filter) oCount
into #pivotSumm
from #sevenDaySumm s with(nolock)
group by
	s.[Agent - Call Center Name]
	,s.[Date];
;

insert into #pivotSumm
select 
	'AUX 8 (Login) Outlier' [Value]
	,s.[Agent - Call Center Name]
	,s.[Date]
	,sum(s.AUX8Filter) oCount
from #sevenDaySumm s with(nolock)
group by
	s.[Agent - Call Center Name]
	,s.[Date]

insert into #pivotSumm
select 
	'AUX 9 (Personal) Outlier' [Value]
	,s.[Agent - Call Center Name]
	,s.[Date]
	,sum(s.AUX9Filter) oCount
from #sevenDaySumm s with(nolock)
group by
	s.[Agent - Call Center Name]
	,s.[Date]

insert into #pivotSumm
select 
	'AUX 10 (Emergency/Tech Issue) Outlier' [Value]
	,s.[Agent - Call Center Name]
	,s.[Date]
	,sum(s.AUX13Filter) oCount
from #sevenDaySumm s with(nolock)
group by
	s.[Agent - Call Center Name]
	,s.[Date]
;
declare @7DayCols as nvarchar(120) = '';
select @7DayCols += ', ' + quotename(b.[Date])
from (select 
	cast(format(s.[Date],'MM/dd/yyyy') as nvarchar(10)) [Date]
from #pivotSumm s with(nolock)
group by
	s.[Date]
) as b;

set @7DayCols = right(@7DayCols,len(@7DayCols)-1);

declare @summPivotQuery as nvarchar(max);
set @summPivotQuery = '

select *
from (
select 
	s.Value
	,s.[Agent - Call Center Name]
	,format(s.[Date],''MM/dd/yyyy'') [Date]
	,s.oCount
from #pivotSumm s with(nolock)
) t
PIVOT
(
	sum(oCount)
	for [Date]
	in('+@7DayCols+')
) pt
order by 1, 2 asc
';
exec(@summPivotQuery);



if object_id('tempdb..#sevenDaySumm') is not null
begin drop table #sevenDaySumm end;