/*VM0PWOWMMSDVS1*/
SET NOCOUNT ON;
/*	!!!		!!!			!!!			!!!			!!!			!!!			!!!
		Lead Queue Shrinkage Creating Temp Table to Load Totals
		Subqueset Inserts are the rolled up Totals that will be 
		consumed by the LeadQueue Tableau Update

	!!!		!!!			!!!			!!!			!!!			!!!			!!! */
if object_id('tempdb..#dispTbl') is not null begin drop table #dispTbl end;
if object_id('tempdb..#s_mapping') is not null begin drop table #s_mapping end;
create table #dispTbl (
	[Day] date,
	[VTO] float,
	[In Center] float,
	[Out of Center] float,
	[Scheduled Hours] float,
	[Day of Week] nvarchar(30),
	[Day of Week Assist] int
);
declare @DayRange date = DATEADD(d,-100,dateadd(hour,-5,getutcdate()));
declare @15Day date = dateadd(day,-15,dateadd(hour,-5,getutcdate()));
declare @14Week date = dateadd(week,-14,dateadd(hour,-5,getutcdate()));
declare @14Month date = DATEADD(month,-14,dateadd(hour,-5,getutcdate()));
/*
		Stacking [Shrinkage_Summary_by_Day_90] Data into Display Table
*/
Select
	sm.[LOBDesc]
	,sm.[Category]
	,sm.[InOut]
into #s_mapping
from Aspect.WFM.[Shrinkage_Summary_by_Day_90] sm with(nolock)
where sm.[LOBDesc] IN ('Video Lead','Spanish Video Lead')
AND sm.[Category] NOT IN('Company Holiday','Convergence Training') 
AND ((sm.[InOut] in ('In Center', 'Out of Center')) OR (sm.[Category] in ('VTO') AND sm.[Inout] IN ('Out of Center')))
group by 
	sm.[LOBDesc]
	,sm.[Category]
	,sm.[InOut]
;
if object_id('tempdb..#daily_90Day_Summ') is not null begin drop table #daily_90Day_Summ end;
SELECT 
	CAST(s.[date] as date) [Stddate]
	,case when s.[Category] = 'VTO' then 'VTO'  else s.[InOut] end  [InOut] 
	,SUM([ActualHours]) As [Hours] 
	,sum(s.[ScheduledHours])/count(DISTINCT(s.[Category])) As [Scheduled Hours]
INTO #daily_90Day_Summ
FROM [Aspect].[WFM].[Shrinkage_Summary_by_Day_90] s with(nolock)
inner join #s_mapping m with(nolock) on s.LOBdesc = m.LOBdesc and s.Category = m.Category and s.InOut = m.InOut
WHERE CAST([date] as date) > @DayRange
Group by CAST([date] as date)
,case when s.[Category] = 'VTO' then 'VTO' else s.[InOut] end
;
/* Creating Day Inputs */
insert into #dispTbl([Day], [VTO], [In Center], [Out of Center], [Scheduled Hours], [Day of Week], [Day of Week Assist])
select 
s.Stddate
,sum(case when InOut = 'VTO' then [Hours] else 0 end) [VTO]
,sum(case when InOut = 'In Center' then [Hours] else 0 end) [In Center]
,sum(case when InOut = 'Out of Center' then [Hours] else 0 end) [Out of Center]
,sum(s.[Scheduled Hours]) [Scheduled Hours]
,'Day' [Day of Week]
,2 [Day of Week Assist]
from #daily_90Day_Summ s with(nolock)
where s.StdDate > @15Day
group by s.Stddate;
;
/* Creating Day of Week Inputs */
insert into #dispTbl([Day], [VTO], [In Center], [Out of Center], [Scheduled Hours], [Day of Week], [Day of Week Assist])
select
	s.Stddate
	,sum(case when InOut = 'VTO' then [Hours] else 0 end) [VTO]
	,sum(case when InOut = 'In Center' then [Hours] else 0 end) [In Center]
	,sum(case when InOut = 'Out of Center' then [Hours] else 0 end) [Out of Center]
	,sum([Scheduled Hours]) [Scheduled Hours]
	,format(s.Stddate,'dddd') [Day of Week]
	,1 [Day of Week Assist]
from #daily_90Day_Summ s with(nolock)
group by s.Stddate
;
insert into #dispTbl([Day], [VTO], [In Center], [Out of Center], [Scheduled Hours], [Day of Week], [Day of Week Assist])
select 
	s.WeekEnding
	,sum(case when s.Category = 'VTO' then s.ActualHours else 0 end) [VTO]
	,sum(case when s.InOut = 'In Center' then s.ActualHours else 0 end) [In Center]
	,sum(case when s.InOut = 'Out of Center' then s.ActualHours else 0 end) [Out of Center]
	,cast(sum(s.[ScheduledHours]) as float)/
	nullif(cast(count(distinct s.[Category]) as float),0) as [Scheduled Hours]
	,'Week Ending Saturday' [Day of Week]
	,3 [Day of Week Assist]
from [Aspect].[WFM].[Shrinkage_Summary_by_Week] s with(nolock)
inner join #s_mapping m with(nolock) on s.LOBdesc = m.LOBdesc and s.Category = m.Category and s.InOut = m.InOut
where [WeekEnding] > @14Week	 
group by s.WeekEnding
;
insert into #dispTbl([Day], [VTO], [In Center], [Out of Center], [Scheduled Hours], [Day of Week], [Day of Week Assist])
SELECT 
	CAST(s.[FiscalMonth] as date) [FiscalMonth]
	,sum(case when s.Category = 'VTO' then s.ActualHours else 0 end) [VTO]
	,sum(case when s.InOut = 'In Center' then s.ActualHours else 0 end) [In Center]
	,sum(case when s.InOut = 'Out of Center' then s.ActualHours else 0 end) [Out of Center]
	,sum(s.[ScheduledHours])/count(DISTINCT(s.[Category])) As [Scheduled Hours]
	,'Fiscal Month' [Day of Week]
	,4 [Day of Week Assist]
FROM [Aspect].[WFM].[Shrinkage_Summary_by_Month] s with(nolock)
inner join #s_mapping m with(nolock)
	on s.LOBdesc = m.LOBdesc and s.Category = m.Category and s.InOut = m.InOut
WHERE CAST([FiscalMonth] as date) >  @14Month
Group by 
	CAST([FiscalMonth] as date) 
;
select 
	* 
from #dispTbl t with(nolock)
order by 
	t.[Day of Week Assist] ASC,
	t.[Day] ASC;
;
/*	!!!		!!!			!!!			!!!			!!!			!!!			!!!
								Clean Up
	!!!		!!!			!!!			!!!			!!!			!!!			!!!*/
if object_id('tempdb..#dispTbl') is not null begin drop table #dispTbl end;
if object_id('tempdb..#daily_90Day_Summ') is not null begin drop table #daily_90Day_Summ end;