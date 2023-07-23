/*
	Step 2 Holiday Bid Ranking Instructions
	
	1.) Import Holiday Bid Rank Values to BID_Step2_Base Table
		a)PEOPLESOFTID to psid
		b)Month 1 to PrefMonth1
		c)Month 2 to PrefMonth2
		d)Month 3 to PrefMonth3
		e)CP Scorecard Avg to PrevAvg
		f)FiscalsUsed to PrefMonthUsed

	2.) Import and Append Holiday Bid Winners to BID_Holiday_Sched


	3.) Update the holBidWinner flag. 1 indicates was a winner of the Holiday Bid, 0 indicates was not a winner of Holiday Bid

	4.) Update the vidStartDate column. Date is based on Title, Current Position Start Date and Hire Date.

	5.) Update the Days Worked, StartTime, and endTime Columns

	6.) Update worksHoliday Flag agent will work holiday based on current Days Worked

	7.) Update workedHoliday, agent worked holiday based on shifts

	8.) Update Hierarchy info and StaffGroup Assignments

*/
declare @holidayDate as date = '7/04/2023';
/* Holiday Staffed Dates*/
declare @holiday1 date = '1/16/2023';
declare @holiday2 date = '1/1/2023';
declare @holiday3 date = '12/25/2022';
/*
Reset the Bid Assignments
	This will ensure the column that indicates which employee is assigned to the 
	available schedule will be null prior to running

update MiningSwap.dbo.BID_Avail_Holiday_Sched
set empRN = null
*/
/*
Remove Terms from Base Table
	This will remove any attrit from the time the Base data was created to
	Step 2 of the Holiday Bid Rank. Not many attrit,  but it does happen
*/
delete from MiningSwap.dbo.BID_Step2_Base
where psid in (select NETIQWORKERID 
from MiningSwap.dbo.PROD_WORKERS w with(nolock) 
inner join MiningSwap.dbo.PROD_WORKER_STATUS s with(nolock)
	on w.STATUSID = s.WORKERSTATUSID
where 
	case 
		when w.TERMINATEDDATE is not null then 1
		when s.REPORTINGNAME = 'Leave of Absence' then 1
		else 0
	end = 1)



/* Updating the holBidWinner flag 
		These steps will set the holdBidWinner flag to 1 or 0. This column
		indicates who was awarded a Holiday Schedule already from Step 1 of
		Holiday Bid Ranks. As these people are already working their chosen
		holiday schedule we do not include them in the Step 2 (Mandate) phase
*/
update MiningSwap.dbo.BID_Step2_Base
set holBidWinner = 1
where psid in (
select
	hs.PSID
from MiningSwap.dbo.BID_Holiday_Sched hs with(nolock)
where hs.holidayDate = @holidayDate)

update MiningSwap.dbo.BID_Step2_Base
set holBidWinner = 0 
where holBidWinner is null



/* Updating VidStartDate
		This date uses logic to determine what their Video Start Date is.
		This ensures we are capturing the correct Video Hire date. As employees
		Transfer into Video, the Hire Data does not change. To Counter this the 
		logic will check if the employee is a Rep 1, and if so, will utilize the
		Current Position Start Date rather than their Hire Date. These may be the 
		same if the employee was hired direct in as Video. 
*/
update MiningSwap.dbo.BID_Step2_Base
set vidStartDate = t.vidDate
from (
	select 
	w.NETIQWORKERID
	,case
			when jc.TITLE like 'Rep%1' then 
				case when w.CURRENTPOSITIONSTARTDATE is null then w.HIREDATE else w.CURRENTPOSITIONSTARTDATE end
			else w.HIREDATE
		end vidDate
	from  MiningSwap.dbo.PROD_WORKERS w with(nolock)
	inner join MiningSwap.dbo.PROD_JOB_CODES jc with(nolock)
		on w.JOBCODEID = jc.JOBCODEID
	where w.TERMINATEDDATE is null
) t
where t.NETIQWORKERID = psid



/* Updating the Works Holiday Flag
		An Aspect pull of the schedules set to work the holiday is uploaded to the BID_Holiday_A_Sched. 
		An employee's existance in this table indicates they are scheduled to work the holiday. This
		table is used to set the wrksHoliday flag to 1 if they work and 0 if they are off the holiday.
*/
update MiningSwap.dbo.BID_Step2_Base
set wrksHoliday = 1
from MiningSwap.dbo.BID_Holiday_A_Sched s with(nolock)
where MiningSwap.dbo.BID_Step2_Base.psid = s.PSID 
and s.WorksHoliday = 1
;
update MiningSwap.dbo.BID_Step2_Base
set wrksHoliday = 0
where MiningSwap.dbo.BID_Step2_Base.wrksHoliday is null
;
update MiningSwap.dbo.BID_Step2_Base
set startTime = s.[Start], endTime = s.[Stop], bridgeFlag = s.bridgeFlag
from MiningSwap.dbo.BID_Holiday_A_Sched s with(nolock)
where MiningSwap.dbo.BID_Step2_Base.psid = s.PSID

;
/* Updating Holiday Flags from the Holiday_Staffed Table
		Now that we have the who worked table staged from the query above
		We are updating the flags in the base table.
*/

update MiningSwap.dbo.BID_Step2_Base
set 
	holiday1Staffed = null
	,holiday2Staffed = null
	,holiday3Staffed = null


update MiningSwap.dbo.BID_Step2_Base
set holiday1Staffed = h.StaffedTime
from (
	select 
		hs.PSID
		,hs.StaffedTime
	from MiningSwap.dbo.BID_Holiday_Staffed hs with(nolock)
	where hs.Date = @holiday1
) h
where MiningSwap.dbo.BID_Step2_Base.psid = h.PSID

update MiningSwap.dbo.BID_Step2_Base
set holiday2Staffed = h.StaffedTime
from (
	select 
		hs.PSID
		,hs.StaffedTime
	from MiningSwap.dbo.BID_Holiday_Staffed hs with(nolock)
	where hs.Date = @holiday2
) h
where MiningSwap.dbo.BID_Step2_Base.psid = h.PSID

update MiningSwap.dbo.BID_Step2_Base
set holiday3Staffed = h.StaffedTime
from (
	select 
		hs.PSID
		,hs.StaffedTime
	from MiningSwap.dbo.BID_Holiday_Staffed hs with(nolock)
	where hs.Date = @holiday3
) h
where MiningSwap.dbo.BID_Step2_Base.psid = h.PSID

/* Update holidayStaffed Count
		Counting the number of holidays worked out of the last three
		This is used during the Ranking process as the logic will use
		who has been off the last thre holidays down to who has worked
		the last three holidays
*/
update MiningSwap.dbo.BID_Step2_Base
set holidayStaffedCount = 
	(case when holiday1Staffed is not null then 1 else 0 end+
	case when holiday2Staffed is not null then 1 else 0 end+
	case when holiday3Staffed is not null then 1 else 0 end)

/* Trim out any Non Qualifiers
		We not Trim out anyone that is not normally scheduled to work
		the holiday, or they were a previous Holiday Bid Winner (Volunteer)
*/
/*
delete from MiningSwap.dbo.BID_Step2_Base 
where wrksHoliday = 0 or holBidWinner = 1
*/


/* Next Series of queries update Profile Information such as Staff Group, Manager, Supervisor, and Employee Names */

/* Updating the Staff Group */
update MiningSwap.dbo.BID_Step2_Base
set staffGroup = a.CODE
from (
select
	s.CODE
	,r.ID
FROM MiningSwap.dbo.VID_Staff s with(nolock)
inner join (
select 
	e.EMP_SK
	,e.ID
from MiningSwap.dbo.VID_EMP e with(nolock)
group by 
	e.EMP_SK
	,e.ID) r on s.EMP_SK = r.EMP_SK
where datediff(day,'12/30/1899',dateadd(hour,-5,getutcdate())) between s.START_NOM_DATE and s.STOP_NOM_DATE
group by s.CODE
	,r.ID
)  a
where psid = a.ID


/* Updating the Names */
update MiningSwap.dbo.BID_Step2_Base
set empFName  = p.FIRSTNAME
,empLName = p.LASTNAME
,bossName = p.bossName
,bossbossName = p.bossbossName
from 
(
select 
case when pw.PREFFNAME is null then pw.FIRSTNAME else pw.PREFFNAME end [FIRSTNAME]
,pw.LASTNAME 
,pw.NETIQWORKERID
,sw.FIRSTNAME + ' ' + sw.LASTNAME bossName
,mw.FIRSTNAME + ' ' + mw.LASTNAME bossbossName

FROM MiningSwap.dbo.PROD_WORKERS pw with(nolock)
INNER JOIN MiningSwap.dbo.PROD_WORKERS sw with(nolock) 
	on pw.SUPERVISORID = sw.WORKERID
INNER JOIN MiningSwap.dbo.PROD_WORKERS mw with(nolock)
	on sw.SUPERVISORID = mw.WORKERID) p
where psid = p.NETIQWORKERID


/* Assigning Grouping IDs based on the logic below */
/*
Worked no holidays and normally work a Monday
Worked 1 holiday and normally works a Monday
Worked 2 holiday and normally works a Monday
Worked no holidays and normally doesn't work a Monday
Worked 1 holiday and normally doesn't work a Monday
Worked 2 holiday and normally doesn't work a Monday
Worked 3 holiday and normally works a Monday
Worked 3 holiday and normally doesn't work a Monday
*/
update a
	set a.groupingID = 
		case
			when a.holidayStaffedCount = 0 and a.wrksHoliday = 1 then (case when a.bridgeFlag = 1 then 10 else 1 end)
			when a.holidayStaffedCount = 1 and a.wrksHoliday = 1 then (case when a.bridgeFlag = 1 then 20 else 2 end)
			when a.holidayStaffedCount = 2 and a.wrksHoliday = 1 then (case when a.bridgeFlag = 1 then 30 else 3 end)
			when a.holidayStaffedCount = 0 and a.wrksHoliday = 0 then (case when a.bridgeFlag = 1 then 40 else 4 end)
			when a.holidayStaffedCount = 1 and a.wrksHoliday = 0 then (case when a.bridgeFlag = 1 then 50 else 5 end)
			when a.holidayStaffedCount = 2 and a.wrksHoliday = 0 then (case when a.bridgeFlag = 1 then 60 else 6 end)
			when a.holidayStaffedCount = 3 and a.wrksHoliday = 1 then (case when a.bridgeFlag = 1 then 70 else 7 end)
			when a.holidayStaffedCount = 3 and a.wrksHoliday = 0 then (case when a.bridgeFlag = 1 then 80 else 8 end)
			else null
		end
from MiningSwap.dbo.BID_Step2_Base a with(nolock)



/*
	Assigning RowNumbers() 
		This now Ranks the Base of Employees by StaffGroup, Count of Holidays Worked, and by Performance Average. 
		Here Count of Holidays is sorted by thoes who have not worked any past holidays, to thoes that have worked
		all last Holidays. The Performance Average is sorted by thoes who have had the worst performnace to the best.
*/
update MiningSwap.dbo.BID_Step2_Base
set empRN = r.empRN
from (
select psid,
ROW_NUMBER() over(order by staffGroup, groupingID asc, PrefAvg asc) empRN
from MiningSwap.dbo.BID_Step2_Base) r
where MiningSwap.dbo.BID_Step2_Base.psid = r.psid


/*
	Mandating Employees to Available Schedules
		We will now loop though the entire list of base employees and look for the 
		first available schedule that is within 4 hours of their normal start time
*/


/* Grabbing Start and Stop Inverval #'s
		This controls the range of employees we will loop though, and in this case
		it will loop though all. */
declare @empInterval int = 1;
declare @empMaxInterval int = (select count(*) from MiningSwap.dbo.BID_Step2_Base);

/* External Loop: Will Loop  per Employee */
While @empInterval <= @empMaxInterval
Begin

	if OBJECT_ID('tempdb..#tmpSchedContainer') is not null begin drop table #tmpSchedContainer end;
	
	/* we are Selecting the First Closest Available Time to orginal schedule */
	select top 1 * ,abs(datediff(minute,hs.Start,e.startTime)) timeDiff
	into #tmpSchedContainer
	from MiningSwap.dbo.BID_Avail_Holiday_Sched hs with(nolock)
	inner join (
	select b.staffGroup
	,b.startTime
	,b.empRN foundEmp
	from MiningSwap.dbo.BID_Step2_Base b with(nolock)
	where b.empRN = @empInterval and b.bridgeFlag = 0
	) e on hs.Site = e.staffGroup
	/* Here we filter down to schedules that are within Four (Updated from 2) Hours of the Original Schedued Time
		here we also ensure an empRN (Employee Row Number) hasn't already been assigned as well */
	where hs.empRN is null and abs(datediff(minute,hs.Start,e.startTime)) <= 240
	/* Found Employee Match must not already be assinged.  */
	--and e.foundEmp not in (select empRN from MiningSwap.dbo.BID_Avail_Holiday_Sched s with(nolock))
	/* Here we order by closest time difference and the scheduled ID Number */
	order by timeDiff asc

	/* Here we then update the Available Holiday Scheduled with the matched Employee from above
		if the above table returned now rows, a match will not occur and the employee would not 
		be manded
	 */
	update MiningSwap.dbo.BID_Avail_Holiday_Sched
	set empRN = foundEMP
	from #tmpSchedContainer
	where MiningSwap.dbo.BID_Avail_Holiday_Sched.[#] = #tmpSchedContainer.[#]
	and MiningSwap.dbo.BID_Avail_Holiday_Sched.[Site] = #tmpSchedContainer.[Site]

	/* We Clean up the Temp and then increment the Employee Interval */
	if OBJECT_ID('tempdb..#tmpSchedContainer') is not null begin drop table #tmpSchedContainer end;	
	set @empInterval = @empInterval + 1;
End;



/* Grabbing Start and Stop Inverval #'s
		This controls the range of employees we will loop though, and in this case
		it will loop though all. */
set @empInterval = 1;
set @empMaxInterval = (select count(*) from MiningSwap.dbo.BID_Step2_Base);

/* External Loop: Will Loop  per Employee */
While @empInterval <= @empMaxInterval
Begin

	if OBJECT_ID('tempdb..#tmpSchedContainer2') is not null begin drop table #tmpSchedContainer2 end;
	
	/* we are Selecting the First Closest Available Time to orginal schedule */
	select top 1 * ,abs(datediff(minute,hs.Start,e.startTime)) timeDiff
	into #tmpSchedContainer2
	from MiningSwap.dbo.BID_Avail_Holiday_Sched hs with(nolock)
	inner join (
	select b.staffGroup
	,b.startTime
	,b.empRN foundEmp
	from MiningSwap.dbo.BID_Step2_Base b with(nolock)
	where b.empRN = @empInterval and b.bridgeFlag = 1
	) e on hs.Site = e.staffGroup
	/* Here we filter down to schedules that are within Four (Updated from 2) Hours of the Original Schedued Time
		here we also ensure an empRN (Employee Row Number) hasn't already been assigned as well */
	where hs.empRN is null and abs(datediff(minute,hs.Start,e.startTime)) <= 240
	/* Found Employee Match must not already be assinged.  */
	--and e.foundEmp not in (select empRN from MiningSwap.dbo.BID_Avail_Holiday_Sched s with(nolock))
	/* Here we order by closest time difference and the scheduled ID Number */
	order by timeDiff asc

	/* Here we then update the Available Holiday Scheduled with the matched Employee from above
		if the above table returned now rows, a match will not occur and the employee would not 
		be manded
	 */
	update MiningSwap.dbo.BID_Avail_Holiday_Sched
	set empRN = foundEMP
	from #tmpSchedContainer2
	where MiningSwap.dbo.BID_Avail_Holiday_Sched.[#] = #tmpSchedContainer2.[#]
	and MiningSwap.dbo.BID_Avail_Holiday_Sched.[Site] = #tmpSchedContainer2.[Site]

	/* We Clean up the Temp and then increment the Employee Interval */
	if OBJECT_ID('tempdb..#tmpSchedContainer2') is not null begin drop table #tmpSchedContainer2 end;	
	set @empInterval = @empInterval + 1;
End;


/*
	Display Matched Results
		This now then Displays the Available Scheduled that are filled, and thoes that weren't
		in a format WF can digest. Thoes Schedules that could not be matched to anyone will have
		No Match in the First and Last Name Fields, and Employee ID.
*/
if OBJECT_ID('tempdb..#AvailableScheduleSummary') is not null begin drop table #AvailableScheduleSummary end;

select
	s.#
	,left(convert(varchar,s.Start,8),5)+'-'+left(convert(varchar,s.Stop,8),5) [Start/Stop]
	,case when b.empFName is null then 'No Match' else b.empFName end [First Name]
	,case when b.empLName is null then 'No Match' else b.empLName end [Last Name]
	,case when cast(b.psid as varchar) is null then 'No Match' else cast(b.psid as varchar) end [Employee ID]
	,s.Holiday
	,s.[Site]
	,b.holidayStaffedCount
into #AvailableScheduleSummary
from MiningSwap.dbo.BID_Avail_Holiday_Sched s with(nolock)
left join MiningSwap.dbo.BID_Step2_Base b with(nolock)
on s.empRN = b.empRN
where s.Site = 'SPEC_MLT_VID_SAT' and [#] in (341, 350);


/* Grabbing a Table View to be used in the Schedule File */
select *
from #AvailableScheduleSummary s with(nolock)


/* Grabbing a Summary to include in email */
select 
	s.Site
	,s.Holiday
	,sum(case when s.[First Name] = 'No Match' then 0 else 1 end) empMatchCount
	,count(*) avalSchedCount
	,sum(case when s.[First Name] = 'No Match' then 1 else 0 end) empNoMatchCount
	,cast(sum(case when s.[First Name] = 'No Match' then 0 else 1 end) as float)/
	nullif(cast(count(*) as float),0) PctFilled

from #AvailableScheduleSummary s with(nolock)
group by 
	s.Site
	,s.Holiday

if OBJECT_ID('tempdb..#AvailableScheduleSummary') is not null begin drop table #AvailableScheduleSummary end;



select * from MiningSwap.dbo.BID_Step2_Base