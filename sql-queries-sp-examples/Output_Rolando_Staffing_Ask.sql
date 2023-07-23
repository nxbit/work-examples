set nocount on;
; 
/*================================================================================================*/
/*			Pulling Offical Schedules from Aspect along with Next Bid Results					  */
/*================================================================================================*/
;
declare @tDay as date = cast(dateadd(hour,-5,getutcdate()) as date);
;
if object_id('tempdb..#vid_scheds') is not null
begin drop table #vid_scheds end;
;
if object_id('tempdb..#summ_site') is not null
begin drop table #summ_site end;
;
declare @wpType as varchar(3) = 'OUT';
;
select *
into #vid_scheds
from openquery(TRAFFIC_REPORTING_WFM,N'
SELECT 
	trl.SEQ_NUM [SQ ID] 
	,LTRIM(RTRIM(e.ID)) PSID 
	,trl.LABEL_1 [Start/Stop] 
	,trl.LABEL_2 [Days Worked] 
	,sst.SET_NAME [SET_NAME_Org]
	,sg.CODE 
	,ROW_NUMBER() OVER(PARTITION BY e.ID ORDER BY case 
		when sst.SET_NAME LIKE ''2023_OFFICIAL'' then 2 
		when sst.SET_NAME LIKE ''NEW_HIRE_PRODUCTION'' then 1
		else 999 
		end) sOrd
FROM EWFM.dbo.SCH_SET sst with(nolock) 
INNER JOIN EWFM.dbo.STF_GRP sg with(nolock) on sst.STF_GRP_SK=sg.STF_GRP_SK 
INNER JOIN EWFM.dbo.TRL_SCH trl with(nolock) on sst.SCH_SET_SK=trl.SCH_SET_SK 
INNER JOIN EWFM.dbo.EMP e with(nolock) on e.EMP_SK=trl.EMP_SK 
WHERE 
	case 
		when Len(trl.LABEL_1) > 11 then 0
		when sst.SET_NAME LIKE ''2023_OFFICIAL'' then 1 
		when sst.SET_NAME LIKE ''NEW_HIRE_PRODUCTION'' then 1
		else 0 
	end = 1 
 AND
 CASE 
	WHEN sg.CODE LIKE ''Z%'' THEN 0 
	WHEN sg.CODE LIKE ''%VID%'' THEN 1 
	WHEN sg.CODE LIKE ''%CSI%'' THEN 1 
 ELSE 0 
 END = 1 
; 
');
;
/* Expanding Schedules Pull into a base */
if object_id('tempdb..#summ_details') is not null 
begin drop table #summ_details end;
;
/* Converting the Vid Shifts into a Cross Table with Days Worked as Flags.  */
select
	s.PSID id
	,cast(null as numeric(15,1)) Phase_Group_SK
	,cast(format(@tDay,'MM/dd/yyyy') + ' ' + left(s.[Start/Stop],5) as datetime) [start]
	,cast(format(@tDay,'MM/dd/yyyy') + ' ' + right(s.[Start/Stop],5) as datetime) [stop]
	,patindex('%S%',s.[Days Worked]) [Sun]
	,patindex('%M%',s.[Days Worked]) [Mon]
	,patindex('%T%',s.[Days Worked]) [Tue]
	,patindex('%W%',s.[Days Worked]) [Wed]
	,patindex('%R%',s.[Days Worked]) [Tur]
	,patindex('%F%',s.[Days Worked]) [Fri]
	,patindex('%Y%',s.[Days Worked]) [Sat]
	,s.[Days Worked]
	,s.[SET_NAME_Org]
	,ma.MGMTAREANAME [CODE]
	,cast(null as bigint) Work_Place_SK
	,cast(null as int) seq_id
into #summ_details
from #vid_scheds s with(nolock)
inner join UXID.EMP.Workers w with(nolock)
	on s.PSID = w.NETIQWORKERID
inner join UXID.REF.Management_Areas ma with(nolock)
	on w.MANAGEMENTAREAID = ma.MANAGEMENTAREAID
where s.sOrd = 1 and ma.MGMTAREANAME in 
('CC-El Paso Call Center' , 'CC-Gran Vista Call Center');

/* Check for cases where stop is < start */
/* this is because the same date was applied to both  */
/* the start and stop above */
update s 
set 
	s.stop = case when s.start > s.stop then dateadd(day,1,s.stop) else s.stop end
	,s.Sun = case when s.Sun <> 0 then 1 else 0 end 
	,s.Mon = case when s.Mon <> 0 then 1 else 0 end
	,s.Tue = case when s.Tue <> 0 then 1 else 0 end
	,s.Wed = case when s.Wed <> 0 then 1 else 0 end
	,s.Tur = case when s.Tur <> 0 then 1 else 0 end
	,s.Fri = case when s.Fri <> 0 then 1 else 0 end
	,s.Sat = case when s.Sat <> 0 then 1 else 0 end
from #summ_details s with(nolock)
;
/* Updateing Workplace Infomartion  */
update d
set 
	d.Work_Place_SK = wp.Work_Place_SK
from #summ_details d with(nolocK)
inner join DimensionalMapping.DIM.Agent a with(nolock)
	on cast(d.id as int) = cast(left(replace(a.EmployeeID,' ', ''),7) as int)
inner join DimensionalMapping.DIM.Historical_Agent_Work_Place wp with(nolock)
	on a.EMP_SK = wp.EMP_SK and (wp.EndDate is null or wp.EndDate > @tDay)
where isnumeric(left(replace(a.EmployeeID,' ', ''),7)) = 1


/* Updateing PhaseGroup Infomartion  */
update d
set 
	d.Phase_Group_SK = pg.Phase_Group_SK
from #summ_details d with(nolocK)
inner join DimensionalMapping.DIM.Agent a with(nolock)
	on cast(d.id as int) = cast(left(replace(a.EmployeeID,' ', ''),7) as int)
inner join DimensionalMapping.DIM.Historical_Agent_Phase_Group pg with(nolock)
	on a.EMP_SK = pg.EMP_SK and (pg.EndDate is null or pg.EndDate > @tDay)
where isnumeric(left(replace(a.EmployeeID,' ', ''),7)) = 1

/*	Building up the Cross Tab Table */

/* Build Base table of Intervals from the dataset */
declare @30minInvervals as table (s datetime, e datetime, seq_id int);
declare @sdttm as datetime, @edttm as datetime;
;
/* Setting Start Stop Pararms from Sched Data */
select 
	@sdttm = min(b.start)
	,@edttm = max(b.stop)
from #summ_details b with(nolock)
/*==================================================================================*/
/*			Expanded out the Intervals by 8 hours on each side.						*/
/*==================================================================================*/
/* There are (48) 30 min intervals in one day */
/* Building out a set of thoes Intervals in one day */
declare @i as int = 0 - (16), @maxi as int = 48 + (16);
while @i <= @maxi begin
	insert into @30minInvervals(s,e,seq_id)
	select
		dateadd(MI,(30 * (@i - 1)),@sdttm),
		dateadd(second,-1,dateadd(MI,30,dateadd(MI,(30 * (@i - 1)),@sdttm))),
		@i
	set @i = @i + 1;
end;

/* Creating a Base Summary Table By Site and By Interval to Update values on */
/* Building out by Site List */
declare @bySite as table (t nvarchar(50), g nvarchar(50));
insert into @bySite(t, g)
select b.CODE, b.Phase_Group_SK
from #summ_details b with(nolock)
group by b.CODE, b.Phase_Group_SK
;
/* Updating 30 Min Interval SeqID's on the Details Table */
update s
set 
	s.seq_id = i.seq_id
from #summ_details s with(nolock)
inner join @30minInvervals i on s.start between i.s and i.e
;
/* Create a Swap of Workplace Locations */
declare @workPlace as table (id numeric(15,1), val varchar(30));
insert into @workPlace(id, val)
select
	Work_Place_SK
	,case when p.WorkPlace like '%WAH%' then 'OUT' when p.WorkPlace like '%WIC%' then 'IN' else null end
from DimensionalMapping.DIM.Work_Place p with(nolock)
where 
	case 
		when p.WorkPlace like '%WAH%' then 1 
		when p.WorkPlace like '%WIC%' then 1 
		else null 
	end = 1;
;
insert into @workPlace(id, val)
select
	Work_Place_SK
	,'ALL'
from DimensionalMapping.DIM.Work_Place p with(nolock)
where 
	case 
		when p.WorkPlace like '%WAH%' then 1 
		when p.WorkPlace like '%WIC%' then 1 
		else null 
	end = 1
;

/* Creating a Base table to have By Group, By Interval to pulling Summarized data from the details. */
select 
	i.s, i.e, s.t, s.g, i.seq_id
into #summ_site
from @30minInvervals i, @bySite s
order by s.t, i.seq_id asc;
;
/* adding the context columns */
alter table #summ_site
add c_sun int, c_mon int, c_tue int, c_wed int, c_thr int, c_fri int, c_sat int
;
;;with eCounts as (
	select 
		d.CODE
		,i.seq_id
		,sum(case when d.Sun = 1 then 1 else 0 end) sunCount
		,sum(case when d.Mon = 1 then 1 else 0 end) monCount
		,sum(case when d.Tue = 1 then 1 else 0 end) tueCount
		,sum(case when d.Wed = 1 then 1 else 0 end) wedCount
		,sum(case when d.Tur = 1 then 1 else 0 end) thuCount
		,sum(case when d.Fri = 1 then 1 else 0 end) friCount
		,sum(case when d.Sat = 1 then 1 else 0 end) satCount
		,d.Phase_Group_SK
	from #summ_details d with(nolock)
	inner join @30minInvervals i 
		on case
			/* Then Arrival is Between Interval */
			when d.start between i.s and i.e then 1
			/* When Exit is Between Interval */
			when d.start < i.s and d.stop between i.s and i.e then 0
			/* When Shift is Over the Inteval */
			when d.start <= i.s and d.stop > i.e then 1
			else 0
		end = 1
	inner join @workPlace wp on d.Work_Place_SK = wp.id and wp.val = @wpType
	group by
		d.CODE
		,i.seq_id
		,d.Phase_Group_SK
),overNightCounts as (
	/* Caculating Thoes working Overnight onto Next Day */
	select
		d.CODE
		,dateadd(day,-1,i.s) s
		,dateadd(day,-1,i.e) e
		,sum(case when d.Sat = 1 then 1 else 0 end) sunNightCount
		,sum(case when d.Sun = 1 then 1 else 0 end) monNightCount
		,sum(case when d.Mon = 1 then 1 else 0 end) tueNightCount
		,sum(case when d.Tue = 1 then 1 else 0 end) wedNightCount
		,sum(case when d.Wed = 1 then 1 else 0 end) thuNightCount
		,sum(case when d.Tur = 1 then 1 else 0 end) friNightCount
		,sum(case when d.Fri = 1 then 1 else 0 end) satNightCount
		,d.Phase_Group_SK
	from #summ_details d with(nolock)
	inner join @30minInvervals i 
		on case
			/* Then Arrival is Between Interval */
			when dateadd(day,-1,d.start) between dateadd(day,-1,i.s) and dateadd(day,-1,i.e) then 1
			/* When Exit is Between Interval */
			when dateadd(day,-1,d.start) < dateadd(day,-1,i.s) and dateadd(day,-1,d.stop) between dateadd(day,-1,i.s) and dateadd(day,-1,i.e) then 0
			/* When Shift is Over the Inteval */
			when dateadd(day,-1,d.start) <= dateadd(day,-1,i.s) and dateadd(day,-1,d.stop) > dateadd(day,-1,i.e) then 1
			else 0
		end = 1
	inner join @workPlace wp on d.Work_Place_SK = wp.id and wp.val = @wpType
	where cast(dateadd(day,-1,d.start) as date) < cast(dateadd(day,-1,d.stop) as date)
	group by
		d.CODE
		,i.s
		,i.e
		,d.Phase_Group_SK
)
update a
set 
	a.c_sun = case when s.sunCount is null then 0 else s.sunCount end + case when c.sunNightCount is null then 0 else c.sunNightCount end,
	a.c_mon = case when s.monCount is null then 0 else s.monCount end + case when c.monNightCount is null then 0 else c.monNightCount end,
	a.c_tue = case when s.tueCount is null then 0 else s.tueCount end + case when c.tueNightCount is null then 0 else c.tueNightCount end,
	a.c_wed = case when s.wedCount is null then 0 else s.wedCount end + case when c.wedNightCount is null then 0 else c.wedNightCount end,
	a.c_thr = case when s.thuCount is null then 0 else s.thuCount end + case when c.thuNightCount is null then 0 else c.thuNightCount end,
	a.c_fri = case when s.friCount is null then 0 else s.friCount end + case when c.friNightCount is null then 0 else c.friNightCount end,
	a.c_sat = case when s.satCount is null then 0 else s.satCount end + case when c.satNightCount is null then 0 else c.satNightCount end
from #summ_site a with(nolock)
inner join eCounts s 
	on a.t = s.CODE and a.seq_id = s.seq_id and a.g = s.Phase_Group_SK
left join overNightCounts c 
	on a.t = c.CODE and a.s = c.s and a.e = c.e and a.g = c.Phase_Group_SK
;
if object_id('tempdb..#time_boundary') is not null
begin drop table #time_boundary end;
/* Pulling Data only Between Hours of 6am and 6pm for Sites that are 24 hrs. */
;;with siteRCounts as (
select
	t
	,count(*) rCount
	,format(cast(min(s.s) as date),'MM/dd/yyyy') + ' 06:00 AM' sDate
	,format(cast(max(s.s) as date),'MM/dd/yyyy') + ' 06:00 AM' eDate
from #summ_site s with(nolock)
where s.c_sun is not null
group by
	t)
select 
	t.t
	,r.sDate
	,r.eDate
into #time_boundary
from #summ_site t with(nolock)
inner join siteRCounts r
	on t.t = r.t and r.rCount > 48
group by
	t.t
	,r.sDate
	,r.eDate
/* Using Typical Time Frame for any Sites not 24 hrs */
insert into #time_boundary (t, sDate, eDate)
select
	s.t
	,min(s.s) sTime
	,max(s.s) eTime
from #summ_site s with(nolock)
where s.t not in (select t from #time_boundary with(nolock))
group by
	s.t
;
/* Updating Intervals to Start at 1 */
declare @seqOffset as table (t nvarchar(50), o int);
insert into @seqOffset(t, o)
select
	s.t
	/* To get the min sequence down to one
		setting the offset to min sequence
		minus self						 */
	,min(s.seq_id) - 1 start_seq_id
from #summ_site s
inner join DimensionalMapping.DIM.Phase_Group pg with(nolock)
	on s.g = pg.Phase_Group_SK
and pg.Phase_Group not in ('NO_PHASE')
where s.c_sun is not null
group by
	s.t
;

/* Total Payroll FTE is to include just agents thus Excluding No_Phase */
select 
	s.s
	,s.e
	,s.t
	,'Total Payroll FTE'
	,s.seq_id - seqoff.o [seq_id]
	,sum(s.c_sun) c_sun
	,sum(s.c_mon) c_mon
	,sum(s.c_tue) c_tue
	,sum(s.c_wed) c_wed
	,sum(s.c_thr) c_thr
	,sum(s.c_fri) c_fri
	,sum(s.c_sat) c_sat
	,case when @wpType = 'ALL' then 'Total Payroll FTE' when @wpType = 'IN' then 'In - Total Payroll FTE' when @wpType = 'OUT' then 'Out - Total Payroll FTE' else null end
from #summ_site s
inner join DimensionalMapping.DIM.Phase_Group pg with(nolock)
	on s.g = pg.Phase_Group_SK
and pg.Phase_Group not in ('NO_PHASE')
inner join @seqOffset seqoff on s.t = seqoff.t
where s.c_sun is not null
group by
	s.s
	,s.e
	,s.t
	,s.seq_id
	,seqoff.o

union all


/* Total Production made up of Thoes within Bridge and Prodcution PhaseGroups */
select 
	s.s
	,s.e
	,s.t
	,'Total Production FTE'
	,s.seq_id - seqoff.o [seq_id]
	,sum(s.c_sun) c_sun
	,sum(s.c_mon) c_mon
	,sum(s.c_tue) c_tue
	,sum(s.c_wed) c_wed
	,sum(s.c_thr) c_thr
	,sum(s.c_fri) c_fri
	,sum(s.c_sat) c_sat
	,case when @wpType = 'ALL' then 'Total Production FTE' when @wpType = 'IN' then 'In - Total Production FTE' when @wpType = 'OUT' then 'Out - Total Production FTE' else null end
from #summ_site s
inner join DimensionalMapping.DIM.Phase_Group pg with(nolock)
	on s.g = pg.Phase_Group_SK
and pg.Phase_Group in ('BRIDGE', 'PRODUCTION')
inner join @seqOffset seqoff on s.t = seqoff.t
where s.c_sun is not null
group by
	s.s
	,s.e
	,s.t
	,s.seq_id
	,seqoff.o
order by 4 asc, 3 asc, 5 asc 


if object_id('tempdb..#summ_site') is not null
begin drop table #summ_site end;

if object_id('tempdb..#summ_details') is not null 
begin drop table #summ_details end;

if object_id('tempdb..#vid_scheds') is not null
begin drop table #vid_scheds end;