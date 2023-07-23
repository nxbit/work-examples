declare @eDate date = dateadd(day,-1,getdate());
declare @sDate date = dateadd(day,-7,@eDate);

declare @posLevel int = 2;
declare @asofDate date = '11/29/2021';
declare @fiscalYr int = 2021;

;;with updateSeq as (select 
h.posLevel
,h.fiscalMth
,h.ChangedOn
,count(distinct h.metricID) metricCount
,count(distinct h.id) empCount
,row_number() over(partition by h.posLevel, h.fiscalMth order by h.ChangedOn desc) rn
from MiningSwap.dbo.R_Metrics_Hist h with(nolock)
where h.posLevel = @posLevel
and h.ChangedOn <= @asofDate
group by h.posLevel, h.fiscalMth, h.ChangedOn)
, tokens as (select * from updateSeq where rn = 1)

select rmh.*, mm.metricDisplayName
from MiningSwap.dbo.R_Metrics_Hist rmh with(nolock)
inner join tokens t on rmh.ChangedOn = t.ChangedOn and 
		rmh.fiscalMth = t.fiscalMth and 
		rmh.posLevel = t.posLevel
inner join MiningSwap.dbo.R_Metric_Map mm with(nolock)
	on rmh.metricID = mm.id




