SET NOCOUNT ON;
if object_id('tempdb..#vid_shink_Summary') is not null begin drop table #vid_shink_Summary end;
if OBJECT_ID('tempdb..#vid_shrinkData') is not null begin drop table #vid_shrinkData end;
if object_id('tempdb..#vid_staffgroups') is not null begin drop table #vid_staffgroups end;
if object_id('tempdb..#vid_emps') is not null begin drop table #vid_emps end;
if object_id('tempdb..#vid_his_location') is not null begin drop table #vid_his_location end;
/*	@yDate - Yesterdays Date
	@yFiscal - StartDate of the Yearly Fiscal based on @yDate's fiscal Year  */
declare @yeDate date = dateadd(day,-1,dateadd(hour,-5,getutcdate()));
declare @ysDate date = 
	CASE 
		WHEN DATEPART(dd,@yeDate) < 29 THEN DATEADD(d,28-DATEPART(dd,@yeDate),@yeDate)
        ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,@yeDate)-28),@yeDate))
    END;
set @ysDate = DATEFROMPARTS(year(@ysDate),1,day(@ysDate));
set @ysDate = dateadd(day,1,dateadd(month,-1,@ysDate));
;
DECLARE @eDate datetime = DateAdd(d,-1,DATEADD(hh,-5,GETUTCDATE()));
DECLARE @sDate datetime = DATEADD(d,-45,@eDate);
;
/* Grabbing Video Staff Groups SK's and the valid Date Ranges */
select
	l.STF_GRP_SK
	,l.StartDate
	,datediff(day,'12/30/1899',l.StartDate) sNom
	,l.EndDate
	,datediff(day,'12/30/1899',l.EndDate) eNom
into #vid_staffgroups
from DimensionalMapping.DIM.Staff_Group_to_LOB l with(nolock)
where 
	case 
		when l.StartDate between @ysDate and @yeDate then 1
		when l.EndDate between @ysDate and @yeDate then 1
		when l.StartDate <= @ysDate and l.EndDate >= @yeDate then 1
		else 0
	end = 1 and
	l.CBI_LOB = 'Video Lead'
group by 
	l.STF_GRP_SK
	,l.StartDate
	,l.EndDate;
;

/* Updafting the Date Ranges to be only within the period looking at 
update a
set 
	a.StartDate = case when a.StartDate < @ysDate then @ysDate else a.StartDate end 
	,a.sNom = case when a.StartDate < @ysDate then datediff(day,'12/30/1899',@ysDate) else a.sNom end 
	,a.EndDate = case when a.EndDate > @yeDate then @yeDate else a.EndDate end
	,a.eNom = case when a.EndDate > @yeDate then datediff(day,'12/30/1899',@yeDate) else a.eNom end 
from #vid_staffgroups a with(nolock)
;*/

select 
	da.EMP_SK
	,da.EmpID
	,dateadd(day,da.NomDate,'12/30/1899') StdDate
into #vid_emps
from Aspect.WFM.Daily_Agents da with(nolock)
inner join #vid_staffgroups sg with(nolock) 
	on da.STF_GRP_SK = sg.STF_GRP_SK 
		and da.NomDate between sg.sNom and sg.eNom
;
select
	hdi.PEOPLESOFTID
	,hdi.LOC
	,min(hdi.STARTDATE) sDate
	,max(hdi.STARTDATE) eDate
into #vid_his_location
from UXID.EMP.Enterprise_Historical_Daily_Indexed hdi with(nolock)
inner join #vid_emps v with(nolock)
	on hdi.PEOPLESOFTID = v.EmpID
	and hdi.STARTDATE = v.StdDate
	and hdi.DLY_AGT_IDX = 1
group by 
	hdi.PEOPLESOFTID
	,hdi.LOC
;
select 
	cast(null as nvarchar(120)) stateCity
	,cast(s.EmpID as int) PEOPLESOFTID
	,cast(s.StdDate as date) StdDate
	,sum(cast(case when s.ShrinkCategory = 'Scheduled' then s.ShrinkSeconds else 0 end as int)) [Scheduled]
	,sum(cast(case when s.ShrinkType = 'Out of Center - Unplanned' and s.ShrinkCategory not in ('FMLA/SMLA/LOA', 'COVID OOO') then s.ShrinkSeconds else 0 end as int)) [Unplanned OOO]
	,sum(cast(case when s.ShrinkType = 'Out of Center - Planned' then s.ShrinkSeconds else 0 end as int)) [Planned OOO]
	,sum(cast(case when s.ShrinkCategory = 'FMLA/SMLA/LOA' then s.ShrinkSeconds else 0 end as int)) [FMLA/SMLA/LOA]
	,sum(cast(case when s.ShrinkCategory = 'COVID OOO' then s.ShrinkSeconds else 0 end as int)) [COVID OOO]
	,null CompanyHoliday
	,sum(cast(case when s.ShrinkType = 'In Center' then s.ShrinkSeconds else 0 end as int)) [InCenter]
	,sum(cast(case when s.ShrinkCategory = 'Breaks' then s.ShrinkSeconds else 0 end as int)) [Breaks]
	,sum(cast(case when s.ShrinkCategory = 'Coaching' then s.ShrinkSeconds else 0 end as int)) [Coaching]
	,sum(cast(case when s.ShrinkCategory = 'Emergency' then s.ShrinkSeconds else 0 end as int)) [Emergency]
	,sum(cast(case when s.ShrinkCategory = 'Front Line Support' then s.ShrinkSeconds else 0 end as int)) [Front Line Support]
	,sum(cast(case when s.ShrinkCategory = 'Login' then s.ShrinkSeconds else 0 end as int)) [Login]
	,sum(cast(case when s.ShrinkCategory = 'Meeting' then s.ShrinkSeconds else 0 end as int)) [Meeting]
	,sum(cast(case when s.ShrinkCategory = 'New Hire Support' then s.ShrinkSeconds else 0 end as int)) [New Hire Support]
	,sum(cast(case when s.ShrinkCategory = 'Outbound' then s.ShrinkSeconds else 0 end as int)) [Outbound]
	,sum(cast(case when s.ShrinkCategory = 'Personal' then s.ShrinkSeconds else 0 end as int)) [Personal]
	,sum(cast(case when s.ShrinkCategory = 'Project' then s.ShrinkSeconds else 0 end as int)) [Project]
	,sum(cast(case when s.ShrinkCategory = 'Technical Issue' then s.ShrinkSeconds else 0 end as int)) [Technical Issue]
	,sum(cast(case when s.ShrinkCategory = 'Training' then s.ShrinkSeconds else 0 end as int)) [Training]
into #vid_shrinkData
from Aspect.WFM.BI_Daily_CS_Shrinkage s with(nolock)
inner join #vid_emps l with(nolock)
	on s.EmpID = l.EmpID and s.StdDate = l.StdDate
where 
	s.StdDate between @ysDate and @yeDate
group by 
	cast(s.EmpID as int)
	,cast(s.StdDate as date)

;
update a
set a.stateCity = l.LOC
from #vid_shrinkData a with(nolock)
left join #vid_his_location l with(nolock)
	on a.PEOPLESOFTID = l.PEOPLESOFTID 
		and a.StdDate between l.sDate and l.eDate
;
select 
	* 
into #vid_shink_Summary
from #vid_shrinkData sd with(nolock)
where sd.StdDate between @sDate and @eDate
	and sd.stateCity is not null 
	and sd.PEOPLESOFTID is not null
order by sd.stateCity, sd.PEOPLESOFTID, sd.StdDate desc
;
insert into #vid_shink_Summary([stateCity], [StdDate], [Scheduled], [Unplanned OOO], [Planned OOO], [FMLA/SMLA/LOA], [COVID OOO], 
[CompanyHoliday], [InCenter], [Breaks], [Coaching], [Emergency], [Front Line Support], [Login], [Meeting], [New Hire Support], 
[Outbound], [Personal], [Project], [Technical Issue], [Training])
select
	[stateCity]
	,datefromparts(year(@yeDate),1,1) [StdDate]
	,SUM([Scheduled]) [Scheduled]
	,SUM([Unplanned OOO]) [Unplanned OOO]
	,SUM([Planned OOO]) [Planned OOO]
	,SUM([FMLA/SMLA/LOA]) [FMLA/SMLA/LOA]
	,SUM([COVID OOO]) [COVID OOO]
	,SUM([CompanyHoliday]) [CompanyHoliday]
	,SUM([InCenter]) [InCenter]
	,SUM([Breaks]) [Breaks]
	,SUM([Coaching]) [Coaching]
	,SUM([Emergency]) [Emergency]
	,SUM([Front Line Support]) [Front Line Support]
	,SUM([Login]) [Login]
	,SUM([Meeting]) [Meeting]
	,SUM([New Hire Support]) [New Hire Support]
	,SUM([Outbound]) [Outbound]
	,SUM([Personal]) [Personal]
	,SUM([Project]) [Project]
	,SUM([Technical Issue]) [Technical Issue]
	,SUM([Training]) [Training]
from #vid_shink_Summary
where [stateCity] is not null
group by [stateCity];
;
select
	*
from #vid_shink_Summary s with(nolock)
where s.stateCity is not null
order by 
	case when s.PEOPLESOFTID is null then 'ENDOFYEAR' else s.stateCity end, 
	s.StdDate desc;
;
if object_id('tempdb..#vid_shink_Summary') is not null begin drop table #vid_shink_Summary end;
if OBJECT_ID('tempdb..#vid_shrinkData') is not null begin drop table #vid_shrinkData end;
if object_id('tempdb..#vid_staffgroups') is not null begin drop table #vid_staffgroups end;
if object_id('tempdb..#vid_emps') is not null begin drop table #vid_emps end;
if object_id('tempdb..#vid_his_location') is not null begin drop table #vid_his_location end;