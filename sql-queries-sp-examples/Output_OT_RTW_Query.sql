
declare @sNomDate int = DateDiff(day,'18991230','12/29/2021')
declare @eNomDate int = DateDiff(day,'18991230','01/28/2022')


if OBJECT_ID('tempdb..#otTempBase') is not null begin drop table #otTempBase end;


;with 
/* Grabbing just Vid Department IDs */
vidDept as (select DEPARTMENTID 
from MiningSwap.dbo.PROD_DEPARTMENTS d with(nolock) 
where d.[NAME] like 'Resi%Vid%Rep%' 
group by DEPARTMENTID),

/* Grabbing just Frontline Role IDs */
vidFrontLine as (select JOBROLEID
from MiningSwap.dbo.PROD_JOB_ROLES r with(nolock)
where r.JOBROLE = 'Frontline'
group by r.JOBROLEID),

/* Grabbing Roster of Emp's with Current MAs */
vidEmpswithMA as (
select 
m.MGMTAREANAME
,w.NETIQWORKERID
from MiningSwap.dbo.PROD_WORKERS w with(nolock)
inner join vidDept d on w.DEPARTMENTID = d.DEPARTMENTID
inner join vidFrontLine v on w.JOBROLEID = v.JOBROLEID
left join MiningSwap.dbo.PROD_MANAGEMENT_AREAS m with(nolock) on w.MANAGEMENTAREAID = m.MANAGEMENTAREAID
where
/* Where Emp's are Active or Termed in the Last Year */ 
	case 
		when w.TERMINATEDDATE is null then 1
		when DateDiff(day,w.TERMINATEDDATE,dateadd(hour,-5,getutcdate())) <= 365 then 1
		else 0
	end = 1
	/* Only Internal Employees */
	and w.WORKERTYPE = 'E'
group by m.MGMTAREANAME, w.NETIQWORKERID)

select
s.EMP_SK
,ma.MGMTAREANAME
,s.NOM_DATE
,s.START_MOMENT
,s.STOP_MOMENT
/* Calc the WEThurs as Nominal Date */
,
/**DateDiff(day,'18991230',
	DATEADD(DAY, 5 - DATEPART(WEEKDAY, DATEADD(day, s.NOM_DATE, '18991230')), 
	CAST(DATEADD(day, s.NOM_DATE, '18991230') AS DATE))) WEThursNom */
/* Flipping to Fiscal Month Model */

CASE
    WHEN DATEPART(dd,DATEADD(day, s.NOM_DATE, '18991230')) < 29 THEN DATEADD(d,28-DATEPART(dd,DATEADD(day, s.NOM_DATE, '18991230')),DATEADD(day, s.NOM_DATE, '18991230'))
    ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,DATEADD(day, s.NOM_DATE, '18991230'))-28),DATEADD(day, s.NOM_DATE, '18991230')))
END FiscalMth	

,sg.CODE shiftCode
,(cast(s.DUR as float)/60.0) DurHrs
/* Subtract the Lunch Durations */
-- case when l.DurHr is null then 0 else l.DurHr end DurHrs
,cast(0.0 as float) lunchDur

into #otTempBase
from MiningSwap.dbo.VID_Shifts s with(nolock)
inner join MiningSwap.dbo.VID_EMP e with(nolock) on s.EMP_SK = e.EMP_SK
inner join vidEmpswithMA ma with(nolock) on e.ID = ma.NETIQWORKERID

inner join MiningSwap.dbo.VID_SEG_CODE sg with(nolock) on s.SEG_CODE_SK = sg.SEG_CODE_SK
where sg.CODE in ('OVERTIME','SHIFT') and s.NOM_DATE between @sNomDate and @eNomDate





/* Updating Lunch Durations preformating in CTE was causing query to run 7+ min  */
update #otTempBase
SET lunchDur = cast(lun.DurHr as float)
from (
SELECT 
	[EMP_SK]
	,l.START_MOMENT
	,l.STOP_MOMENT
	,sum([DUR])/60.0 DurHr
FROM [MiningSwap].[dbo].[VID_Lunches] l
where l.NOM_DATE between @sNomDate and @eNomDate
group by 
[EMP_SK]
,l.START_MOMENT
,l.STOP_MOMENT) lun
where #otTempBase.EMP_SK = lun.EMP_SK and lun.START_MOMENT between #otTempBase.START_MOMENT and #otTempBase.STOP_MOMENT







select 
*
from (
select 
e.ID
,(Year(ot.FiscalMth)*100)+Month(ot.FiscalMth) fiscalMth
,ot.shiftCode
,sum(ot.DurHrs) - sum(case when ot.lunchDur is null then 0 else ot.lunchDur end) DurHrs
from #otTempBase ot with(nolock)
left join MiningSwap.dbo.VID_EMP e with(nolock) on ot.EMP_SK = e.EMP_SK
left join MiningSwap.dbo.PROD_WORKERS w with(nolock) on e.ID = w.NETIQWORKERID
group by 
e.ID
,ot.FiscalMth
,ot.shiftCode
)t 
PIVOT
(
sum(DurHrs)
FOR shiftCode
IN ([OVERTIME],[SHIFT])
) pt










if OBJECT_ID('tempdb..#otTempBase') is not null begin drop table #otTempBase end;