SET NOCOUNT ON;
;
/*====================================================================================*/
/*	Setting a Period to include Current Fiscal Plus the Past Fiscal during every run  */
/*====================================================================================*/
declare @yDate as date = DateAdd(day,-1,DateAdd(hour,-5,getutcdate()));
declare @yDate_Fiscal as date = (CASE WHEN DATEPART(dd,@yDate) < 29 THEN 
					DATEADD(d,28-DATEPART(dd,@yDate),@yDate)
					ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,@yDate)-28),@yDate))END);
declare @yDate_sFiscal date = DateAdd(day,1,DateAdd(month,-2,@yDate_Fiscal));

/*====================================================================================*/
/*	Creating Swap of Video Staff Groups to Use as an Inner in Later Joins	          */
/*====================================================================================*/
if object_id('tempdb..#vid_sg_grp_sk') is not null begin drop table #vid_sg_grp_sk end;
select
	sg.STF_GRP_SK
	,sg.StartDate
	,sg.EndDate
into #vid_sg_grp_sk
from DimensionalMapping.DIM.Staff_Group_to_LOB sg with(nolock)
where 
	sg.LOBDesc in ('Video', 'Video Lead')
	and
		case
			-- When the SG Started During the Period
			when sg.StartDate >= @yDate_sFiscal and sg.StartDate <= @yDate_Fiscal then 1
			-- When the SG was already Existing During the Period
			when sg.EndDate >= @yDate_sFiscal then 1
			-- When the SG was active BEtween the Period
			when sg.StartDate >= @yDate_sFiscal and sg.EndDate <= @yDate_Fiscal then 1
			else 0
		end = 1
group by
	sg.STF_GRP_SK
	,sg.StartDate
	,sg.EndDate;
;;
/*====================================================================================*/
/*	Creating Swap of Video Employees with Period Dates, that align with the 
		Staff Group Period		
		Adding a Null Column PSID to be updated later on.							  */
/*====================================================================================*/
if object_id('tempdb..#vid_emp_sk') is not null begin drop table #vid_emp_sk end;
select
	h_sg.EMP_SK
	,cast(null as numeric(10,0)) psid
	,cast(null as varchar(8)) pid
	,h_sg.StartDate
	,h_sg.EndDate
into #vid_emp_sk
from DimensionalMapping.DIM.Historical_Agent_Staff_Group h_sg with(nolock)
inner join #vid_sg_grp_sk v_sg with(nolock)
	on h_sg.StartDate between v_sg.StartDate and v_sg.EndDate
	and h_sg.STF_GRP_SK = v_sg.STF_GRP_SK
where 
	case 
		-- When the SG Started During the Period
		when h_sg.StartDate >= @yDate_sFiscal and h_sg.StartDate <= @yDate_Fiscal then 1
		-- When the SG was already Existing During the Period
		when h_sg.EndDate >= @yDate_sFiscal then 1
		-- When the SG was active BEtween the Period
		when h_sg.StartDate >= @yDate_sFiscal and h_sg.EndDate <= @yDate_Fiscal then 1
		else 0
	end = 1
group by
	h_sg.EMP_SK
	,h_sg.StartDate
	,h_sg.EndDate
--Staff Group Swap No Longer Needed from This point
if object_id('tempdb..#vid_sg_grp_sk') is not null begin drop table #vid_sg_grp_sk end;
/*====================================================================================*/
/*	Updating the Dates in the vid_emp_sk Table to the Needed Period     	          */
/*====================================================================================*/
update a
set a.StartDate = 
	case
		--When the Start date of the Staff Group is before our Data Period,
		--Date is being brought up to the start of the Data Period
		when a.StartDate < @yDate_sFiscal then @yDate_sFiscal
		else a.StartDate
	end,
	a.EndDate = 
	case
		--When the End date of the Staff Group is After our Data Period, 
		--Date is being brought down to the end date of the Data Period
		when a.EndDate > @yDate_Fiscal then @yDate_Fiscal
		else a.EndDate
	end
from #vid_emp_sk a with(nolock)

/*====================================================================================*/
/*	Updating the PSIDs and PIDs on the vid_emp_sk Table						     	  */
/*====================================================================================*/
update a
set a.psid = ag.EmployeeID, a.pid = w.ENTITYACCOUNT
from #vid_emp_sk a with(nolock)
inner join DimensionalMapping.DIM.Agent ag with(nolock)
	on a.EMP_SK = ag.EMP_SK
left join UXID.EMP.Workers w with(nolock)
	on ag.EmployeeID = w.NETIQWORKERID;
;;
/*====================================================================================*/
/*	Creating CorPortal Coaching Swap Data							     	          */
/*====================================================================================*/
if object_id('tempdb..#vid_coachings') is not null begin drop table #vid_coachings end;
select
	cd.CoachingDate
	,cd.CoachingDetailID
	,cd.CoachedByHrNumber
	,cd.SelectionPrimaryDesc
	,cast(cd.Notes as varchar(50)) [Notes]
	,cd.RepHrNumber
	,cd.SupHrNumber
	,cd.MgrHrNumber
into #vid_coachings
from External_Interface.CORPR.Coaching_Details cd with(nolock)
inner join #vid_emp_sk sk with(nolock) 
	on cd.RepHrNumber = sk.psid 
	and cd.CoachingDate between sk.StartDate and sk.EndDate
where cd.IsRepViewable = 1


/*====================================================================================*/
/*	Creating OAI Coaching Swap Data							     	                  */
/*	Underlying Data uses PID, to merge both PID values will be gathered here		  */
/*	and will be used to gather PSID's that will be used for the end join    		  */
/*====================================================================================*/
if object_id('tempdb..#vid_audits') is not null begin drop table #vid_audits end;
;;with oai_dup_fix as (
	select
		ad.Publisheddatetime
		,ad.Template
		,ROW_NUMBER() OVER(PARTITION BY ad.Publisheddatetime ORDER BY COUNT(distinct ad.[EvalID]) DESC) rn
	from GVPOperations.VID.OAI_Audit_Details ad with(nolock)
	inner join #vid_emp_sk sk with(nolock)
		on ad.pid = sk.pid
		and ad.Publisheddatetime between sk.StartDate and sk.EndDate
	where 
		(ad.Question = 'Behavior Coached')
	group by ad.Publisheddatetime, ad.Template
)
select
	ad.Publisheddatetime [CoachingDate],
	ad.EvalID [CoachingDetailID],
	ad.[Evaluator ID],
	cast(null as numeric(10,0)) CoachedByHrNumber,
	case when f.[Template] IS NULL THEN 'Other' else ad.[Behavior Coached] end [SelectionPrimaryDesc],
	ad.pid,
	cast(null as numeric(10,0)) RepHrNumber,
	cast(null as numeric(10,0)) SupHrNumber,
	cast(null as numeric(10,0)) MgrHrNumber
into #vid_audits
from GVPOperations.VID.OAI_Audit_Details ad with(nolock)
inner join oai_dup_fix f 
	on 
		ad.Template = f.Template and 
		ad.Publisheddatetime = f.Publisheddatetime and 
		f.rn = 1
inner join #vid_emp_sk sk with(nolock)
		on 
			ad.pid = sk.pid
			and ad.Publisheddatetime between sk.StartDate and sk.EndDate
group by
	ad.Publisheddatetime
	,ad.EvalID
	,ad.[Evaluator ID]
	,f.Template
	,ad.[Behavior Coached]
	,ad.pid
--Vid Emp Staff Group Driven Roster no Longer Needed at this Point
if object_id('tempdb..#vid_emp_sk') is not null begin drop table #vid_emp_sk end;

/*====================================================================================*/
/*	Creating Current Roster Data Swap								     	          */
/*====================================================================================*/
if object_id('tempdb..#vid_emp_Data') is not null begin drop table #vid_emp_Data end;
select 
	w.NETIQWORKERID psid
	,w.ENTITYACCOUNT pid
	,w.FIRSTNAME+ ' '+w.LASTNAME empName
	,CASE
       WHEN DATEDIFF(m,w.SERVICEDATE,DATEADD(hh,-5,GETUTCDATE())) between 0 and 3 THEN '1 to 3 mos'
            WHEN DATEDIFF(m,w.SERVICEDATE,DATEADD(hh,-5,GETUTCDATE())) between 4 and 6 THEN '>3 to 6 mos'
            WHEN DATEDIFF(m,w.SERVICEDATE,DATEADD(hh,-5,GETUTCDATE())) between 7 and 9 THEN '>6 to 9 mos'
            WHEN DATEDIFF(m,w.SERVICEDATE,DATEADD(hh,-5,GETUTCDATE())) between 10 and 12 THEN '>9 to 12 mos'
            WHEN DATEDIFF(m,w.SERVICEDATE,DATEADD(hh,-5,GETUTCDATE())) between 13 and 24 THEN '>12 to 24 mos'
            WHEN DATEDIFF(m,w.SERVICEDATE,DATEADD(hh,-5,GETUTCDATE())) >= 25  THEN '>2yrs'
            ELSE ''
     END [Service Tenure]
	,ma.MGMTAREANAME
	,jc.TITLE empTitle
	,s.[DESCRIPTION] [Status]
	,h1.NETIQWORKERID suppsid
	,h2.NETIQWORKERID mgrpsid
into #vid_emp_Data
from UXID.EMP.Workers w with(nolock)
inner join UXID.REF.Management_Areas ma with(nolock)
	on w.MANAGEMENTAREAID = ma.MANAGEMENTAREAID
inner join UXID.REF.Job_Codes jc with(nolock)
	on w.JOBCODEID = jc.JOBCODEID
inner join UXID.REF.Worker_Status s with(nolock)
	on w.STATUSID = s.WORKERSTATUSID
inner join UXID.EMP.Workers h1 with(nolock)
	on w.SUPERVISORID = h1.WORKERID
inner join UXID.EMP.Workers h2 with(nolock)
	on h1.SUPERVISORID = h2.WORKERID
where 
	case 
		when w.NETIQWORKERID in ( select v.RepHrNumber from #vid_coachings v with(nolock)) then 1
		when w.ENTITYACCOUNT in ( select v.pid from #vid_audits v with(nolock) ) then 1
		when w.NETIQWORKERID in ( select v.CoachedByHrNumber from #vid_coachings v with(nolock)) then 1
		when w.NETIQWORKERID in ( select v.SupHrNumber from #vid_coachings v with(nolock) ) then 1
		when w.ENTITYACCOUNT in ( select v.[Evaluator ID] from #vid_audits v with(nolock) ) then 1
		when w.NETIQWORKERID in ( select v.MgrHrNumber from #vid_coachings v with(nolock) ) then 1
		else 0
	end = 1

/*====================================================================================*/
/*	Converting the OAI PID's into PSID's to use in the below flow.          		  */
/*====================================================================================*/
update a
set a.CoachedByHrNumber = e.psid
from #vid_audits a with(nolock)
inner join #vid_emp_Data e with(nolock)
	on a.[Evaluator ID] = e.pid

update a
set 
	a.RepHrNumber = e.psid
	,a.SupHrNumber = e.suppsid
	,a.MgrHrNumber = e.mgrpsid
from #vid_audits a with(nolock)
inner join #vid_emp_Data e with(nolock)
	on a.pid = e.pid


/*====================================================================================*/
/*	Creating Base Table Return										     	          */
/*====================================================================================*/
if object_id('tempdb..#vid_interactions') is not null begin drop table #vid_interactions end;
select 
	cast(null as varchar(50)) Status,
	cast(null as varchar(100)) Manager, 
	cast(null as varchar(100)) Supervisor,
	c.MgrHrNumber ManagerPSID,
	c.SupHrNumber SupervisorPSID,
	c.RepHrNumber AgentPSID,
	cast(null as varchar(100)) CoachedEmployee,
	format(DATEADD(dd, -(DATEPART(dw, c.CoachingDate)-7), c.CoachingDate),'d') WESat,
	cast(null as varchar(15)) ServiceTenure,
	'CorPortal' Source,
	c.CoachingDetailID [Entry#],
	cast(null as varchar(50)) cityState,
	c.CoachedByHrNumber CoachPSID,
	cast(null as varchar(100)) CoachedBy,
	c.CoachingDate [InteractionDate],
	c.SelectionPrimaryDesc [Primary Reason],
	cast(null as varchar(100)) EmpTitle
into #vid_interactions
from #vid_coachings c with(nolock)
if object_id('tempdb..#vid_coachings') is not null begin drop table #vid_coachings end;


/*====================================================================================*/
/*	Inserting OAI Data into Base Table								     	          */
/*====================================================================================*/
insert into #vid_interactions(ManagerPSID, SupervisorPSID, AgentPSID, WESat, Source, Entry#, CoachPSID, InteractionDate, [Primary Reason])
select
	a.MgrHrNumber
	,a.SupHrNumber
	,a.RepHrNumber
	,format(DATEADD(dd, -(DATEPART(dw, a.CoachingDate)-7), a.CoachingDate),'d') WESat
	,'OAI' Source
	,a.CoachingDetailID
	,a.CoachedByHrNumber
	,a.CoachingDate
	,a.SelectionPrimaryDesc
from #vid_audits a with(nolock)
if object_id('tempdb..#vid_audits') is not null begin drop table #vid_audits end;

/*====================================================================================*/
/*	Updating Employee Hirearchy Info								     	          */
/*====================================================================================*/
update a
set 
	a.Manager = m.empName,
	a.Supervisor = s.empName,
	a.CoachedEmployee = e.empName,
	a.ServiceTenure = e.[Service Tenure],
	a.cityState = e.MGMTAREANAME,
	a.CoachedBy = c.empName,
	a.EmpTitle = e.empTitle,
	a.[Status] = e.[Status]
from #vid_interactions a with(nolock)
left join #vid_emp_Data e with(nolock)
	on a.AgentPSID = e.psid
left join #vid_emp_Data s with(nolock)
	on a.SupervisorPSID = s.psid
left join #vid_emp_Data m with(nolock)
	on a.ManagerPSID = m.psid
left join #vid_emp_Data c with(nolock)
	on a.CoachPSID = c.psid


/* Main Return */
select * from #vid_interactions vi with(nolock)
if object_id('tempdb..#vid_interactions') is not null begin drop table #vid_interactions end;
if object_id('tempdb..#vid_emp_Data') is not null begin drop table #vid_emp_Data end;
