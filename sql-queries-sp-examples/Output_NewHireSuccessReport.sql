declare @sdate as date = '09/01/2021';
;
if object_id('tempdb..#vid_nh_headcount') is not null begin drop table #vid_nh_headcount end;
;
/* Grabbing a List of Rep 1's When they Hit the Enterprise Headcount File */
/* Making Initial Pull Two Months back from Selected Month to ensure Bookends are Complete */
select 
	datefromparts(year(min(cast(hc.PayrollMonth as date))),month(min(cast(hc.PayrollMonth as date))),1) PayrollMonth
	,dateadd(day,-6,cast(hc.PayrollWeek as date)) PayrollWeek
	,row_number() over(partition by hc.EmpID order by cast(hc.PayrollWeek as date) asc) pWeek_seq
	,hc.EmpID
into #vid_nh_headcount
from Enterprise_Rpt.EPR.EHC_Employee_HC hc with(nolock)
where
	hc.DeptID = 640
	and hc.JobCodeDescrip like 'Rep%1%Vid%Rep%'
	and datefromparts(year(cast(hc.PayrollMonth as date)),month(cast(hc.PayrollMonth as date)),1) >= dateadd(month,-2,@sDate)
group by
	hc.EmpID
	,hc.PayrollWeek
;
/* Clearing off data outside of bookend range */
delete from #vid_nh_headcount where PayrollMonth < @sdate;
delete from #vid_nh_headcount where pWeek_seq > 1
;
/* Count of NH's each Fiscal Payroll Month */
select
	PayrollMonth
	,count(distinct EmpID) nh_Count
from #vid_nh_headcount
group by
	PayrollMonth
order by
	PayrollMonth asc;
;
/* Adding Context Columns */
alter table #vid_nh_headcount
add term_date date,
    hire_date date,
	no_show int,
	/* 0 - Transfer In, 1 - Transfer Out */
	trasnfer int,
	transfer_date date,
	hire_dur int;
;
/* Update Context Columns from UXID */
;;with emp_workers as (
	select
		NETIQWORKERID
		,TERMINATEDDATE
		,HIREDATE
		/* Found Case where Same PSID existed in Workers Table, so using most recent upddated row */
		,row_number() over(partition by NETIQWORKERID order by UPDATEDDATE desc) emp_seq
	from UXID.EMP.Workers w with(nolock)
)
update a 
set
	a.term_date = w.TERMINATEDDATE
	,a.hire_date = case when w.HIREDATE < cast(PayrollMonth as date) then cast(PayrollWeek as date) else cast(w.HIREDATE as date) end
	,a.hire_dur = datediff(day,case when w.HIREDATE < cast(PayrollMonth as date) then cast(PayrollWeek as date) else cast(w.HIREDATE as date) end,case when w.TERMINATEDDATE is null then getutcdate() else w.TERMINATEDDATE end)
from #vid_nh_headcount a with(nolock)
inner join emp_workers w with(nolock)
	on 
		a.EmpID = w.NETIQWORKERID
		and w.emp_seq = 1;
;;
;with vidJC as (
select
	jc.JOBCODEID
from UXID.REF.Job_Codes jc with(nolock)
where jc.TITLE like 'Rep%1%Vid%Rep%'
), vidNHDates as (
select
w.NETIQWORKERID
,w.CURRENTPOSITIONSTARTDATE
from UXID.EMP.Workers w with(nolock)
inner join vidJC j 
	on w.JOBCODEID = j.JOBCODEID
where
	w.CURRENTPOSITIONSTARTDATE is not null
)
update a
set
	a.hire_date = b.CURRENTPOSITIONSTARTDATE
from #vid_nh_headcount a with(nolock)
inner join vidNHDates b 
	on a.EmpID = b.NETIQWORKERID;
;
/* Cleaning up Last Items */
update a
set
	a.hire_date = case when	a.PayrollWeek < a.term_date then a.PayrollWeek else null end
	,a.hire_dur = datediff(day,case when	a.PayrollWeek < a.term_date then a.PayrollWeek else null end,a.term_date)
from #vid_nh_headcount a with(nolock)
where 
	a.hire_date is null 
	and a.term_date is not null;

/* Clearning Context where Possible Rehire ie, their Hire Date is before they showed on 640's Headcount 
update a
set 
	a.hire_date = null
	,a.hire_dur = null
from #vid_nh_headcount a with(nolock)
where a.hire_date < dateadd(day,-14,a.PayrollMonth);
*/
;
/* Updating Thoes that were No Shows */
;;with no_show_context as (
	select 
		min(datefromparts(year(cast(hc.PayrollMonth as date)),month(cast(hc.PayrollMonth as date)),1)) PayrollMonth
		,hc.EmpID
	from Enterprise_Rpt.EPR.EHC_Employee_TC hc with(nolock)
	where
		hc.DeptID = 640
		and hc.JobCodeDescrip like 'Rep%1%Vid%Rep%'
		and datefromparts(year(cast(hc.PayrollMonth as date)),month(cast(hc.PayrollMonth as date)),1) >= dateadd(month,-2,@sDate)
		and hc.TenureDetail = 'No Show'
	group by
		hc.EmpID
		,hc.TenureDetail
)
update a
set 
	a.no_show = 1
from #vid_nh_headcount a with(nolock)
inner join no_show_context c 
	on 
		a.EmpID = c.EmpID 
		and a.PayrollMonth = c.PayrollMonth;
;
/* Finding and Updating Transfer In/Out Context Info */
;;with trans_context_info as (
select
	hc.EmpID 
	,datefromparts(year(cast(hc.PayrollMonth as date)),month(cast(hc.PayrollMonth as date)),1) PayrollMonth
	,min(cast(hc.PayrollWeek as date)) min_pWeek
	/* 0 - Transfer In, 1 - Transfer Out */
	,case
		when hc.Previous_DeptID = 640 then 1
		when hc.Current_DeptID = 640 then 0
		else null
	end [trans_type]
from Enterprise_Rpt.EPR.EHC_Employee_TR hc with(nolock)
where
	case
		when hc.Previous_DeptID = 640 then 1
		when hc.Current_DeptID = 640 then 1
		/* Exclude when the Transfer is IntraDepartment */
		when hc.Current_DeptID = 640 and hc.Previous_DeptID = 640 then 0
		else 0
	end = 1
	and datefromparts(year(cast(hc.PayrollMonth as date)),month(cast(hc.PayrollMonth as date)),1) >= dateadd(month,-2,@sDate)
group by
	hc.EmpID
	,datefromparts(year(cast(hc.PayrollMonth as date)),month(cast(hc.PayrollMonth as date)),1)
	,hc.Previous_DeptID
	,hc.Current_DeptID
)
update a
set 
	a.trasnfer = ci.trans_type
	,a.transfer_date = ci.min_pWeek
	,a.hire_date = 
		case 
			when a.trasnfer = 0 then ci.min_pWeek
			else a.hire_date
		end
from #vid_nh_headcount a with(nolock)
inner join trans_context_info ci with(nolock)
	on a.EmpID = ci.EmpID and a.PayrollMonth = ci.PayrollMonth 
;
/* Update Transfer Context Info */
update a
set 
	a.term_date = a.transfer_date
	,a.hire_dur = datediff(day,a.hire_date,a.transfer_date)
from #vid_nh_headcount a
where a.trasnfer = 1
;
;
/* Attemping to find the Video Start Date for Employees that Transfered In from Other Depts */
/* Checking for when the Transfer In First Appres under a Video StaffGroup */
if object_id('tempdb..#vid_transin_Context') is not null begin drop table #vid_transin_Context end;
;
select
	/* Matching DataType in DimensionalMapping */
	cast(vh.EmpID as varchar(32)) EmpID
	,cast(null as bigint) EMP_SK
	,cast(null as date) vid_sg_firstDate
into #vid_transin_Context
from #vid_nh_headcount vh with(nolock)
where vh.[trasnfer] = 0;
/* Update EMP_SK Values */
update a
set 
	a.EMP_SK = ag.EMP_SK
from #vid_transin_Context a with(nolock)
inner join DimensionalMapping.DIM.Agent ag with(nolock)
	on a.EmpID = ag.EmployeeID
;
update a
set 
	a.EMP_SK = ha.EMP_SK
from #vid_transin_Context a with(nolock)
inner join DimensionalMapping.DIM.Historical_Avaya ha with(nolock)
	on a.EmpID = ha.EmployeeID
where a.EMP_SK is null
/* Grab a List of Video Staff Grups */
if object_id('tempdb..#vid_staffGroups') is not null begin drop table #vid_staffGroups end;
;
select
	l.STF_GRP_SK
	,l.StaffGroup
	,l.StartDate
	,l.EndDate
into #vid_staffGroups
from DimensionalMapping.DIM.Staff_Group_to_LOB l with(nolock)
where l.LOBDesc in ('Video', 'Video Lead');
;
;
;with firstDayVidSG as (
select 
	sg.EMP_SK
	,min(sg.StartDate) firstVidSGDate
from DimensionalMapping.DIM.Historical_Agent_Staff_Group sg with(nolock)
inner join #vid_staffGroups vsg with(nolock)
	on 
		sg.STF_GRP_SK = vsg.STF_GRP_SK 
		and sg.StartDate between vsg.StartDate and vsg.EndDate
inner join #vid_transin_Context tc with(nolock)
	on sg.EMP_SK = tc.EMP_SK
group by
	sg.EMP_SK
)
/* Updating HireDate to the first date found in a Video StaffGroup */
update a
set 
	a.vid_sg_firstDate = b.firstVidSGDate
from #vid_transin_Context a with(nolock)
inner join firstDayVidSG b 
	on a.EMP_SK = b.EMP_SK;
;
/* Update Main NH Headcount Table */
update a
set 
	a.hire_date = tc.vid_sg_firstDate
from #vid_nh_headcount a with(nolock)
inner join #vid_transin_Context tc with(nolock)
	on a.EmpID = tc.EmpID;
;
if object_id('tempdb..#vid_noContext') is not null begin drop table #vid_noContext end;
;
select 
	cast(hc.EmpID as varchar(32)) EmpID
	,cast(null as bigint) EMP_SK
	,cast(null as date) vid_sg_firstDate
into #vid_noContext
from #vid_nh_headcount hc with(nolock)
where hc.hire_date is null
and hc.no_show is null
and hc.trasnfer is null;
;
/* Update EMP_SK Values */
update a
set 
	a.EMP_SK = ag.EMP_SK
from #vid_noContext a with(nolock)
inner join DimensionalMapping.DIM.Agent ag with(nolock)
	on a.EmpID = ag.EmployeeID
;
update a
set 
	a.EMP_SK = ha.EMP_SK
from #vid_noContext a with(nolock)
inner join DimensionalMapping.DIM.Historical_Avaya ha with(nolock)
	on a.EmpID = ha.EmployeeID
where a.EMP_SK is null
;
if object_id('tempdb..#vid_nh_periods') is not null  begin drop table #vid_nh_periods end;
;
;;with vidPeerGroups as (
SELECT 
	[Peer_Group_SK]
    ,[Peer_Group]
FROM [DimensionalMapping].[DIM].[Peer_Group] pg with(nolock)
where pg.Peer_Group like '%VID%NH'
)
select
	hpg.EMP_SK
	,vc.EmpID
	,hpg.StartDate
	,hpg.EndDate
into #vid_nh_periods
from DimensionalMapping.DIM.Historical_Agent_Peer_Group hpg with(nolock)
inner join vidPeerGroups vpg with(nolock)
	on hpg.Peer_Group_SK = vpg.Peer_Group_SK
inner join #vid_noContext vc with(nolock)
	on hpg.EMP_SK = vc.EMP_SK;
;
if object_id('tempdb..#vid_nh_period_chk') is not null begin drop table #vid_nh_period_chk end;
;with emp_sk as (
	select 
		EMP_SK 
		,EmpID
	from #vid_nh_periods with(nolock) 
	group by 
		EMP_SK
		,EmpID
), params as (
	select 
		min(p.StartDate) sDate, 
		max(p.EndDate) eDate 
	from #vid_nh_periods p with(nolock)
)
select
	StdDate
	,EMP_SK
	,EmpID
	,0 vidCheck
into #vid_nh_period_chk
from DimensionalMapping.DIM.Date_Table, emp_sk
where
	StdDate between (select sDate from params) and (select eDate from params);
;
;
update a
set
	a.vidCheck = 1
from #vid_nh_period_chk a with(nolock)
inner join #vid_nh_periods p with(nolock)
	on a.EMP_SK = p.EMP_SK and a.StdDate between p.StartDate and p.EndDate;
;
;;with vidDates as (
select
	c.EMP_SK
	,c.EmpID
	,min(c.StdDate) sDate
from #vid_nh_period_chk c with(nolock)
where 
	c.vidCheck = 1
group by
	c.EMP_SK
	,c.EmpID
)
update a
set 
	a.hire_date = v.sDate
from #vid_nh_headcount a with(nolock)
inner join vidDates v 
	on a.EmpID = v.EmpID;
;
;
update a
set 
	a.hire_dur = datediff(day,hire_date,term_date)
from #vid_nh_headcount a with(nolock)
where 
	a.hire_dur is null
	and hire_date is not null
	and term_date is not null;
;
select 
	* 
from #vid_nh_headcount;
;
;
if object_id('tempdb..#vid_nh_headcount') is not null begin drop table #vid_nh_headcount end;
if object_id('tempdb..#vid_transin_Context') is not null begin drop table #vid_transin_Context end;
if object_id('tempdb..#vid_staffGroups') is not null begin drop table #vid_staffGroups end;
if object_id('tempdb..#vid_nh_periods') is not null  begin drop table #vid_nh_periods end;
if object_id('tempdb..#vid_nh_period_chk') is not null begin drop table #vid_nh_period_chk end;