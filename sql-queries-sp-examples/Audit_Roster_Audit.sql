if object_id('tempdb..#vid_Roster_Audit') is not null begin drop table #vid_Roster_Audit end;
if object_id('tempdb..#vid_DeptIDs') is not null begin drop table #vid_DeptIDs end;
if object_id('tempdb..#vid_JobRoles') is not null begin drop table #vid_JobRoles end;
if object_id('tempdb..#vid_workers') is not null begin drop table #vid_workers end;
if object_id('tempdb..#vid_MAs') is not null begin drop table #vid_MAs end;
if object_id('tempdb..#vid_staffGroup') is not null begin drop table #vid_staffGroup end;
if object_id('tempdb..#vid_peerGroups') is not null begin drop table #vid_peerGroups end;
if object_id('tempdb..#vid_ActiveAvayaIDs') is not null begin drop table #vid_ActiveAvayaIDs end;
if object_id('tempdb..#vid_AvayaLastLogon') is not null begin drop table #vid_AvayaLastLogon end;
if OBJECT_ID('tempdb..#vid_lastCall_date') is not null begin drop table #vid_lastCall_date end;
/*
	Vid_Roster_Audit

	- Build out List of Frontline, Lead, Supervisor, and Manager into a Base Audit Table
	- Update Base Profile Info
*/
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
									Building Up UXID Information
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
select
	d.DEPARTMENTID
into #vid_DeptIDs
from UXID.REF.Departments d with(nolock)
where d.NAME like 'Resi%Vid%Rep%'

select
	jr.JOBROLEID
	,jr.JOBROLE
into #vid_JobRoles
from UXID.REF.Job_Roles jr with(nolock)
where jr.JOBROLE in ('Frontline','Supervisor','Manager','Support', 'Lead')

select
	m.MGMTAREANAME
	,m.MANAGEMENTAREAID
into #vid_MAs
from UXID.REF.Management_Areas m with(nolock)

select
	w.WORKERID
	,cast(null as bigint) EMP_SK
	,w.NETIQWORKERID
	,case when w.PREFFNAME is not null then w.PREFFNAME else w.FIRSTNAME end + ' ' + w.LASTNAME empName
	,w.SUPERVISORID
	,r.JOBROLE
	,datediff(month,w.HIREDATE,getutcdate()) TenureMths
	,m.MGMTAREANAME
	,cast(null as varchar(48)) StaffGroup
	,cast(null as nvarchar(30)) PeerGroup
	,cast(null as date) lastLogon
	,cast(null as date) lastCall
	,cast(null as int) activeAvaya
into #vid_workers
from UXID.EMP.Workers w with(nolock)
inner join #vid_DeptIDs d with(nolock)
	on w.DEPARTMENTID = d.DEPARTMENTID
inner join #vid_JobRoles r with(nolock)
	on w.JOBROLEID = r.JOBROLEID
inner join #vid_MAs m with(nolock)
	on w.MANAGEMENTAREAID = m.MANAGEMENTAREAID
where w.TERMINATEDDATE is null
and w.HIREDATE <= dateadd(day,-1,getutcdate())

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
									Building Up Avaya Information
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

/* Grabbing StaffGroups Active in the last 7 Days */
declare @sNomDate int = datediff(day,'12/30/1899',dateadd(day,-7,getutcdate()));
select
	da.EmpID
	,da.EMP_SK
	,da.StaffGroup
	,max(da.NomDate) sDate
	,row_number() over(partition by da.EmpID order by max(da.NomDate) desc) [Idex]
into #vid_staffGroup
from Aspect.WFM.Daily_Agents da with(nolock)
inner join #vid_workers w with(nolock)
	on da.EmpID = w.NETIQWORKERID
where da.NomDate >= @sNomDate
group by 
	da.EmpID
	,da.EMP_SK
	,da.StaffGroup

update a
	set a.EMP_SK = b.EMP_SK
from #vid_workers a with(nolock)
left join (
	select
		da.EmpID
		,da.EMP_SK
	from Aspect.WFM.Daily_Agents da with(nolock)
	inner join #vid_workers w with(nolocK)
		on da.EmpID = w.NETIQWORKERID
	group by 
		da.EmpID
		,da.EMP_SK
) b on a.NETIQWORKERID = b.EmpID


/* Updating Current StaffGroups to Workers Temp */
update a
set 
	a.StaffGroup = s.StaffGroup
from #vid_workers a with(nolock)
left join #vid_staffGroup s with(nolock)
	on a.EMP_SK = s.EMP_SK and s.Idex = 1


select 
	g.EMP_SK
	,g.StartDate
	,g.EndDate
	,pm.Peer_Group
	,g.Seq
	,row_number() over(partition by g.EMP_SK order by g.Seq desc) pgIndex
into #vid_peerGroups
from DimensionalMapping.DIM.Historical_Agent_Peer_Group g with(nolock)
inner join #vid_workers w with(nolock)
	on g.EMP_SK = w.EMP_SK
inner join DimensionalMapping.DIM.Peer_Group pm with(nolock)
	on pm.Peer_Group_SK = g.Peer_Group_SK
where g.StartDate < dateadd(day,-1,getutcdate())

update a
	set a.peerGroup = p.Peer_Group
from #vid_workers a with(nolock)
left join #vid_peerGroups p with(nolock)
	on a.EMP_SK = p.EMP_SK and p.pgIndex = 1

/* Updating Last Logon and Avaya data */
declare @ydate date = cast(dateadd(day,-90,getutcdate()) as date);
select 
	ha.EMP_SK
	,ha.Avaya
	,ha.ACD
	,ha.StartDate
	,ha.EndDate
into #vid_ActiveAvayaIDs
from DimensionalMapping.DIM.Historical_Avaya ha with(nolock)
inner join #vid_workers w with(nolock)
	on ha.EMP_SK = w.EMP_SK
where ha.EndDate >= @ydate


/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
									Building Up Call and Logon Information
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
declare @hlog_eDate date = cast(dateadd(day,-1,getutcdate()) as date);
declare @hlog_sDate date = dateadd(day,-90,@hlog_eDate);
/**/

select
a.EMP_SK
,max(hl.LOGIN_UTC) lastLogOnDate
into #vid_AvayaLastLogon
from SwitchData.CMS.HAGLOG hl with(nolock)
inner join #vid_ActiveAvayaIDs a with(nolock)
	on hl.ACD = a.ACD 
		and hl.LOGID = a.Avaya 
		and hl.ROW_DATE between a.StartDate and a.EndDate
where hl.ROW_DATE between @hlog_sDate and @hlog_eDate
group by a.EMP_SK


select
	a.EMP_SK
	,cast(max(cd.SEGSTOP_UTC) as date) lastCallDate
into #vid_lastCall_date
from SwitchData.ECH.Switch_Call_Data cd with(nolock)
inner join #vid_ActiveAvayaIDs a with(nolock)
	on cd.ACD = a.ACD
		and cd.ANSLOGIN = a.Avaya
		and cd.SEGSTART_UTC between a.StartDate and a.EndDate
where cd.SEGSTOP_UTC between @hlog_sDate and @hlog_eDate
group by a.EMP_SK

update a
	set 
		a.activeAvaya = case when active.EMP_SK is null then 0 else 1 end, 
		a.lastLogon = ll.lastLogOnDate
from #vid_workers a with(nolock)
left join (select aid.EMP_SK from #vid_ActiveAvayaIDs aid with(nolock) group by aid.EMP_SK) as active
	on a.EMP_SK = active.EMP_SK
left join #vid_AvayaLastLogon ll with(nolock)
	on a.EMP_SK = ll.EMP_SK


update a
	set 
		a.lastCall = cd.lastCallDate
from #vid_workers a with(nolock)
left join #vid_lastCall_date cd with(nolock)
	on a.EMP_SK = cd.EMP_SK


/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
									Building Base Roster Audit Table
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

create table #vid_Roster_Audit(
	/* Employee Info */
	MA varchar(50) null,
	BossBoss varchar(110) null,
	Boss varchar(110) null,
	Employee varchar(110) null,
	PSID numeric(10) not null primary key,
	JobRole varchar(120) null,
	TenureMts int null,
	StaffGroup varchar(48) null,
	PeerGroup nvarchar(30) null,
	/* Phone Info */
	ActiveAvaya int null,
	LastAvayaLogin date null,
	LastCallHandled date null,
	/* Team Info */
	EmployeeCount int null,
	NH_EmployeeCount int null,
	Lead_EmployeeCount int null

);

/* Insert Names & PSIDs of Active Frontline, Supervisor, and Manager */
insert into #vid_Roster_Audit(PSID, Employee)
select
	w.NETIQWORKERID
	,w.empName
from #vid_workers w with(nolock)

/* Updating Employee Roster and Label Info */
update a
	set 
		Boss = sw.empName
		,BossBoss = mw.empName
		,JobRole = w.JOBROLE
		,TenureMts = w.TenureMths
		,MA = w.MGMTAREANAME
		,StaffGroup = w.StaffGroup
		,PeerGroup = w.PeerGroup
		,ActiveAvaya = w.activeAvaya
		,LastAvayaLogin = w.lastLogon
		,LastCallHandled = w.lastCall
from #vid_Roster_Audit a with(nolock)
inner join #vid_workers w with(nolock) 
	on a.PSID = w.NETIQWORKERID
left join #vid_workers sw with(nolock)
	on w.SUPERVISORID = sw.WORKERID
left join #vid_workers mw with(nolock)
	on sw.SUPERVISORID = mw.WORKERID

/* Updating Employee Count */
;;with empCount as (
	select
		w.SUPERVISORID
		,count(distinct w.WORKERID) empCount
	from #vid_workers w with(nolock)
	where w.SUPERVISORID in 
	(
		select
			s.WORKERID
		from #vid_workers s with(nolock)
	)
	and w.JOBROLE in ('Frontline','Supervisor','Lead')
	group by 
		w.SUPERVISORID
)
update a
	set a.EmployeeCount = e.empCount
from #vid_Roster_Audit a with(nolock)
inner join #vid_workers w with(nolock)
	on a.PSID = w.NETIQWORKERID
inner join empCount e 
	on w.WORKERID = e.SUPERVISORID



/* Updating Lead Employee Count */
;;with empCount as (
	select
		w.SUPERVISORID
		,count(distinct w.WORKERID) empCount
	from #vid_workers w with(nolock)
	where w.SUPERVISORID in 
	(
		select
			s.WORKERID
		from #vid_workers s with(nolock)
	)
	and w.JOBROLE = 'Lead'
	group by 
		w.SUPERVISORID
)
update a
	set a.Lead_EmployeeCount = e.empCount
from #vid_Roster_Audit a with(nolock)
inner join #vid_workers w with(nolock)
	on a.PSID = w.NETIQWORKERID
inner join empCount e 
	on w.WORKERID = e.SUPERVISORID




/* Updating Lead Employee Count */
;;with empCount as (
	select
		w.SUPERVISORID
		,count(distinct w.WORKERID) empCount
	from #vid_workers w with(nolock)
	where w.SUPERVISORID in 
	(
		select
			s.WORKERID
		from #vid_workers s with(nolock)
	)
	and w.PeerGroup like '%NH%'
	group by 
		w.SUPERVISORID
)
update a
	set a.NH_EmployeeCount = e.empCount
from #vid_Roster_Audit a with(nolock)
inner join #vid_workers w with(nolock)
	on a.PSID = w.NETIQWORKERID
inner join empCount e 
	on w.WORKERID = e.SUPERVISORID


select * from #vid_Roster_Audit


if object_id('tempdb..#vid_Roster_Audit') is not null begin drop table #vid_Roster_Audit end;
if object_id('tempdb..#vid_DeptIDs') is not null begin drop table #vid_DeptIDs end;
if object_id('tempdb..#vid_JobRoles') is not null begin drop table #vid_JobRoles end;
if object_id('tempdb..#vid_workers') is not null begin drop table #vid_workers end;
if object_id('tempdb..#vid_MAs') is not null begin drop table #vid_MAs end;
if object_id('tempdb..#vid_staffGroup') is not null begin drop table #vid_staffGroup end;
if object_id('tempdb..#vid_peerGroups') is not null begin drop table #vid_peerGroups end;
if object_id('tempdb..#vid_ActiveAvayaIDs') is not null begin drop table #vid_ActiveAvayaIDs end;
if object_id('tempdb..#vid_AvayaLastLogon') is not null begin drop table #vid_AvayaLastLogon end;
if OBJECT_ID('tempdb..#vid_lastCall_date') is not null begin drop table #vid_lastCall_date end;