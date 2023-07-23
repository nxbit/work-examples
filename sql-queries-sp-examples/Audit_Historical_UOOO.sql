set nocount on;
;
/* ======== Using BI Daily CS Shrinkage against Enterprise Historical Daily Indexed Flattened to avoid row dups ======== */
if object_id('tempdb..#emp_roster') is not null
begin drop table #emp_roster end;
select 
	hdi.PEOPLESOFTID
	,hdi.STARTDATE
into #emp_roster
from UXID.EMP.Enterprise_Historical_Daily_Indexed hdi with(nolock)
where hdi.DEPARTMENT like '%Resi%Vid%Rep%'
and hdi.STARTDATE  between '3/29/2023' and '06/28/2023'
and hdi.TITLE not in ('Lead Video Repair')
group by
	hdi.PEOPLESOFTID
	,hdi.STARTDATE
;
select 
	(sum(case when s.ShrinkType = 'Scheduled Hours' then s.ShrinkSeconds else 0.00 end) / 3600.00) sched_seconds
	,(sum(case when s.ShrinkType = 'Out of Center - Unplanned' then s.ShrinkSeconds else 0.00 end) / 3600.00) uooo_seconds
	,sum(case when s.ShrinkType = 'Out of Center - Unplanned' then s.ShrinkSeconds else 0.00 end)/
	sum(case when s.ShrinkType = 'Scheduled Hours' then s.ShrinkSeconds else 0.00 end) uooopct
from Aspect.[WFM].[BI_Daily_CS_Shrinkage] s with(nolock)
inner join #emp_roster hdi with(nolock)
	on s.EmpID = hdi.PEOPLESOFTID and s.StdDate = hdi.STARTDATE
where 
s.StdDate between '3/29/2023' and '06/28/2023' 
and s.ShrinkType in ('Scheduled Hours', 'Out of Center - Unplanned');
;
if object_id('tempdb..#emp_roster') is not null
begin drop table #emp_roster end;

/* ======== Using BI Daily CS Shrinkage against Enterprise Historical Daily Indexed staright join too ======== */
;
select 
	(sum(case when s.ShrinkType = 'Scheduled Hours' then s.ShrinkSeconds else 0.00 end) / 3600.00) sched_seconds
	,(sum(case when s.ShrinkType = 'Out of Center - Unplanned' then s.ShrinkSeconds else 0.00 end) / 3600.00) uooo_seconds
	,sum(case when s.ShrinkType = 'Out of Center - Unplanned' then s.ShrinkSeconds else 0.00 end)/
	sum(case when s.ShrinkType = 'Scheduled Hours' then s.ShrinkSeconds else 0.00 end) uooopct
from Aspect.[WFM].[BI_Daily_CS_Shrinkage] s with(nolock)
inner join UXID.EMP.Enterprise_Historical_Daily_Indexed hdi with(nolock)
	on s.EmpID = hdi.PEOPLESOFTID and s.StdDate = hdi.STARTDATE and hdi.DLY_AGT_IDX = 1
where 
s.StdDate between '3/29/2023' and '06/28/2023' 
and s.ShrinkType in ('Scheduled Hours', 'Out of Center - Unplanned')
and hdi.DEPARTMENT like '%Resi%Vid%Rep%'
and hdi.TITLE not in ('Lead Video Repair')
;
/* =============== Using BI Daily CS Shrinkage against Enterprise Roster As Is ==================== */
select 
	(sum(case when s.ShrinkType = 'Scheduled Hours' then s.ShrinkSeconds else 0.00 end) / 3600.00) sched_seconds
	,(sum(case when s.ShrinkType = 'Out of Center - Unplanned' then s.ShrinkSeconds else 0.00 end) / 3600.00) uooo_seconds
	,sum(case when s.ShrinkType = 'Out of Center - Unplanned' then s.ShrinkSeconds else 0.00 end)/
	sum(case when s.ShrinkType = 'Scheduled Hours' then s.ShrinkSeconds else 0.00 end) uooopct
from Aspect.[WFM].[BI_Daily_CS_Shrinkage] s with(nolock)
inner join UXID.EMP.Enterprise_Roster hdi with(nolock)
	on s.EmpID = hdi.PEOPLESOFTID
where 
s.StdDate between '3/29/2023' and '06/28/2023' 
and hdi.DEPARTMENT like '%Resi%Vid%Rep%'
and s.ShrinkType in ('Scheduled Hours', 'Out of Center - Unplanned')
and hdi.TITLE not in ('Lead Video Repair');