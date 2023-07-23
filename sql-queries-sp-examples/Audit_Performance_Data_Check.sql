/* CTXCCOINT02 */
/*=================================================================================================*/
/*					FIRST CHECKING IF ALL PERFORMANCE MONTHS ARE POPULATED						   */
/*=================================================================================================*/
/*	
	This check's intent to to ensure we have data for the 
		correct peergroups in the performanceSwap table. We 
		are partically checking for the existance of performance
		data within the last 12 months. If any of the months
		do not return any performance values, that months data
		needs to be uploaded to the performanceSwap table. This
		will ensure Bid Ranks are ran against the lastest performance
		data.														  */
declare @yDate as date = dateadd(day,-1,dateadd(hour,-5,getutcdate()));
/* Caculating the 12 month period we would expect to have completed performance data */ 
declare @cFiscal as date = 
	CASE
		WHEN DATEPART(dd,@yDate) < 29 THEN DATEADD(d,28-DATEPART(dd,@yDate),@yDate)
		ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,@yDate)-28),@yDate))
	END;
declare @eFiscal as date; 
set @eFiscal = dateadd(month,
	case
		when datediff(day,dateadd(day,1,dateadd(month,-1,@cFiscal)),@yDate) < 14 then -2
		else -1
	end, @cFiscal);
declare @sFiscal as date = dateadd(month,-11,@eFiscal);

/* Checking if we have the expected 12 month Period in the DataTables */
declare @fmonthCount as int;
;;with FiscalCounts as (
select
	/* Legacy CorPortal provided Rankings, the End Dates may not have always aligned to that of the fiscal. 
	using cacl to shift everything to fiscal Month end date */
	CASE
		WHEN DATEPART(dd,ss.endDate) < 29 THEN DATEADD(d,28-DATEPART(dd,ss.endDate),ss.endDate)
		ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,ss.endDate)-28),ss.endDate))
	END [fiscalMth]
from MiningSwap.dbo.BID_Scorecard_Swap ss with(nolock)
where ss.endDate between @sFiscal and @eFiscal
group by
	CASE
		WHEN DATEPART(dd,ss.endDate) < 29 THEN DATEADD(d,28-DATEPART(dd,ss.endDate),ss.endDate)
		ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,ss.endDate)-28),ss.endDate))
	END
)
select
	@fmonthCount = count(distinct fiscalMth)
from FiscalCounts

if(@fmonthCount < 12) begin 
	declare @missingMonths as nvarchar(100) = '';
	declare @i int = 0;
	while @i < 12 begin 
		if(
		select top 1
		ss.endDate
		from MiningSwap.dbo.BID_Scorecard_Swap ss with(nolock)
		where ss.endDate = dateadd(month,@i* -1,@eFiscal)
		) is null 
		begin

			set @missingMonths += @missingMonths + format(@efiscal,'MM/dd/yy') + ', ' 

		end;
	set @i = @i + 1;
	end;
	/* Build Message to Let user know X months are needed data */
	declare @msgTable as table (msg nvarchar(255));
	insert into @msgTable(msg)
	select
		'There is missing Performance Data';
	insert into @msgTable(msg)
	select
		'Load Performance Data for the following Month(s):';

	insert into @msgTable(msg)
	select
		left(@missingMonths,len(@missingMonths) -1);

	select * from @msgTable
end;
else
begin
	/* Prepparing and Display Checks Passed Message  */
	declare @msgTable2 as table (msg nvarchar(255));
	insert into @msgTable2(msg)
	select
		'Performance Data is loaded for all Twelve Months';
	insert into @msgTable2(msg)
	select
		format(@sFiscal,'MM/dd/yy') + ' to '+ format(@eFiscal,'MM/dd/yy') + ' is all present';

	select * from @msgTable2

end;

/*=================================================================================================*/
/*					SECOND CHECKING FOR WHOM WE HAVE PERFORMANCE VALUES FOR						   */
/*=================================================================================================*/
select 
	'Check for mismatch PG Names' [Peer Groups]
	,12 [MonthCount]
	,2000 [EmpCount]
union all
select
	ss.peerGroup
	,count(distinct 
			CASE
				WHEN DATEPART(dd,ss.endDate) < 29 THEN DATEADD(d,28-DATEPART(dd,ss.endDate),ss.endDate)
				ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,ss.endDate)-28),ss.endDate))
			END) fMonthCount
	,count(distinct ss.psid) empCount
from MiningSwap.dbo.BID_Scorecard_Swap ss with(nolock)
where ss.endDate between @sFiscal and @eFiscal
group by
	ss.peerGroup


/*=================================================================================================*/
/*					THIRD CHECKING THE DATA IS ALL WITHIN EXPECTED RANGES						   */
/*=================================================================================================*/
declare @nullIDRecCount as int;
select 
	@nullIDRecCount = count(*)
from MiningSwap.dbo.BID_Scorecard_Swap ss with(nolock)
where ss.psid is null and ss.endDate between @sFiscal and @eFiscal

declare @nullPrefRecCount as int;
select 
	@nullPrefRecCount = count(*)
from MiningSwap.dbo.BID_Scorecard_Swap ss with(nolock)
where ss.performanceValue is null and ss.endDate between @sFiscal and @eFiscal

declare @oddPrefRecCount as int;
select 
	@oddPrefRecCount = count(*)
from MiningSwap.dbo.BID_Scorecard_Swap ss with(nolock)
where ss.performanceValue > 1 and ss.endDate between @sFiscal and @eFiscal

declare @nullPeerGroupRecCount as int;
select 
	@nullPeerGroupRecCount = count(*)
from MiningSwap.dbo.BID_Scorecard_Swap ss with(nolock)
where ss.peerGroup is null and ss.endDate between @sFiscal and @eFiscal

select
	cast(@nullIDRecCount as nvarchar(10)) + ' records with Null PSID values.' [Data Integerty Checks]
Union All
select
	cast(@nullPrefRecCount as nvarchar(10)) + ' records with Null Performance Values.' [Data Integerty Checks]
Union All
select
	cast(@oddPrefRecCount as nvarchar(10)) + ' records with nonPct Performance Values.' [Data Integerty Checks]
Union All
select 
	cast(@nullPeerGroupRecCount as nvarchar(10)) + ' records wtih Null PeerGroup Values.' [Data Integerty Checks]



select 
	*
from MiningSwap.dbo.BID_Scorecard_Swap ss with(nolock)
where 
	case
		when ss.psid is null then 1
		when ss.performanceValue is null then 1
		when ss.performanceValue > 1 then 1
		when ss.peerGroup is null then 1
		else 0
	end = 1
	 and ss.endDate between @sFiscal and @eFiscal
order by ss.peerGroup, ss.endDate desc