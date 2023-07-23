/*VM0PWOWMMSD0001*/
set nocount on;
declare @dayInterval as int = 90;
declare @cutOffDate as date = '06/30/2023';
declare @preGradGoal as float = 0.0;
declare @postGradGoal as float = 0.0;
;

/*========================================================================================================== 
	Creating Roster Table for newly Bridge Agents. Table will be staged with their PSID, Graduation Date
	sDate, eDate ranges for the UOOO Data and their emp_sk for mappping.								 
==========================================================================================================*/
declare @new_bridge as table(id numeric(15,0), gradDate date, sDate date, eDate date, emp_sk bigint, tAttend float, preGrad float, postGrad float, qualFlag int);			
insert @new_bridge(id, gradDate)			
/*========Paste Copy From SQL Template Tab Below this Line*/			

						
/*End Of SQL Template Area*/	
/* Updating Date Ranges on the new_bridge table */
update a
set
	a.sDate = dateadd(day,(@dayInterval+1)*-1,a.gradDate)
	,a.eDate = @cutOffDate 
from @new_bridge a 		
;
/* Updaing the EMP_SK column in the newBridge Table */
;; with empIDs as (
	select
		a.EMP_SK
		,cast(substring(a.EmployeeID,patindex('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',a.EmployeeID),patindex('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',a.EmployeeID)+7) as varchar(7)) psid
	from DimensionalMapping.DIM.Agent a with(nolock)
	where 
	patindex('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',a.EmployeeID) > 0 and
	substring(a.EmployeeID,patindex('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',a.EmployeeID),patindex('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',a.EmployeeID)+7) in (
	select cast(b.id as varchar(7)) from @new_bridge b 
	)
)
update a
set 
	a.emp_sk = b.EMP_SK
from @new_bridge a
inner join empIDs b on replace(a.id,' ','') = replace(b.psid,' ','');
;
/*========================================================================================================== 
								End of New_Bridge Roster Section							 
==========================================================================================================*/

/*========================================================================================================== 
						Building Swap of Superstate Codes that will be used to 
							Caculate the Unplanned Out of Office. Note that Manager
							Overrides are excluded.								 
==========================================================================================================*/
declare @shrinkBuckets as table(Bucket varchar(50), SPRSTATE_SK bigint);
insert into @shrinkBuckets(Bucket, SPRSTATE_SK)
SELECT 
    [Bucket]
    ,[SPRSTATE_SK]
FROM [DimensionalMapping].[DIM].[Enterprise_Shrinkage_Buckets] sb with(nolock)
where 
	sb.Bucket in ('Unplanned OOO','Scheduled')
	and (sb.Description not like 'MGM%Over%' or sb.Description not like 'MGR%Over%')
group by
	[Bucket]
    ,[SPRSTATE_SK]

/* Utilizing Aspects Daily Superstate Hours to Caculate the Total Unplanned Out of Office Time */
if object_id('tempdb..#byDatePull') is not null
begin drop table #byDatePull end;

select
	nb.id
	,ss.StdDate
	,case when ss.StdDate <= nb.gradDate then 'Pre-Graduation' else 'Post-Graduation' end [Period]
	,sb.Bucket
	,ss.MI
into #byDatePull
from Aspect.WFM.Daily_Superstate_Hours ss with(nolock)
inner join @shrinkBuckets sb on ss.SPRSTATE_SK = sb.SPRSTATE_SK
inner join @new_bridge nb on 
	ss.EMP_SK = nb.emp_sk 
	and ss.StdDate between nb.sDate and nb.eDate

;;with byPeriodData as (
	select
		[id] [PSID]
		,[Period]
		,round(1 - (cast(sum(case when [Bucket] = 'Unplanned OOO' then [MI] else 0 end) as float) / nullif(cast(sum(case when [Bucket] = 'Scheduled' then [MI] else 0 end) as float),0)),6) [AttendPct]
	from #byDatePull p
	group by 
		[id]
		,[Period]
)
/* Updating the Pre and Post Attendance Results on the New Bridge Roster Table */
update a
set
	a.postGrad = (select top 1 AttendPct from byPeriodData r with(nolock) where r.PSID = a.id and r.[Period] = 'Post-Graduation')
	,a.preGrad = (select top 1 AttendPct from byPeriodData r with(nolock) where r.PSID = a.id and r.[Period] = 'Pre-Graduation')
from @new_bridge a 

;;with byTotal as (
	select
		[id] [PSID]
		,round(1 - (cast(sum(case when [Bucket] = 'Unplanned OOO' then [MI] else 0 end) as float) / nullif(cast(sum(case when [Bucket] = 'Scheduled' then [MI] else 0 end) as float),0)),6) [AttendPct]
	from #byDatePull p
	group by 
		[id]
)
/* Updating the Total Attendance Results on the New Bridge Roster Table */
update a
set
	a.tAttend = (select top 1 AttendPct from byTotal r with(nolock) where r.PSID = a.id)
from @new_bridge a 
;
/* Setting the Qual Flag to 1 when the Pre and Post Grad Goals have been met */
update a
set
	a.qualFlag = case when a.preGrad >= @preGradGoal and a.postGrad >= @postGradGoal then 1 else 0 end
from @new_bridge a
;
if object_id('tempdb..#byDatePull') is not null
begin drop table #byDatePull end;

select 
	* 
from @new_bridge b;