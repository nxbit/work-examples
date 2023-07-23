DECLARE @StartDate datetime;
DECLARE @EndDate datetime;
SET @StartDate = '12/29/2021';
SET @EndDate = '01/28/2022';



/*  Building Exclusions Table with Same Submitter, Same Date, Same Account greater than 4 Times*/
with ticketSumm as (SELECT 
[Submitted By],
[DateSubmitted],
[Account Number],
COUNT(DISTINCT [Ticket Number]) [perAcountCount]
FROM MiningSwap.dbo.[TempMonthlyETDSwap] e with(nolock)
WHERE e.[Submitted On] BETWEEN @StartDate AND @EndDate
GROUP BY [Submitted By], [DateSubmitted], [Account Number])

SELECT [Submitted By], [DateSubmitted], [Account Number]
INTO #tempExlusions
FROM ticketSumm t 
WHERE t.perAcountCount >= 3
ORDER BY t.perAcountCount DESC


/* Pulling Total Accounts */
;; with regionAccounts as (SELECT 
      [MA_Region] [Region],
	  COUNT(DISTINCT t.[Account Number]) [# Accounts],
	  COUNT(DISTINCT t.[Ticket Number]) [# Tickets]
  FROM [MiningSwap].[dbo].[TempMonthlyETDSwap] t
WHERE CASE 
	WHEN [MA_Region] IS NOT NULL THEN 1 
	WHEN [MA_Region] = 'Unknown' THEN 0 
	ELSE 0 END = 1 AND [Submitted On] BETWEEN @StartDate AND @EndDate  AND
	/* Remove Tickets from the 4+ Exclusion Table Above */
	NOT EXISTS (SELECT 1 FROM #tempExlusions e where e.[Account Number] = t.[Account Number] AND e.[Submitted By] = t.[Submitted By] AND e.DateSubmitted = t.DateSubmitted)
  GROUP BY [MA_Region])

  /* Flatten Counts by Reagion for Total Display */
	SELECT 
	SUM([# Accounts]) [# Accounts],
	SUM([# Tickets]) [# Tickets]
	FROM regionAccounts
	WHERE [Region] != 'Unknown'



;; with regionAccounts as (SELECT 
      [MA_Region] [Region],
	  COUNT(DISTINCT [Account Number]) [# Accounts]
  FROM [MiningSwap].[dbo].[TempMonthlyETDSwap]
WHERE CASE 
	WHEN [MA_Region] IS NOT NULL THEN 1 
	WHEN [MA_Region] = 'Unknown' THEN 0 
	ELSE 0 END = 1 AND [Submitted On] BETWEEN @StartDate AND @EndDate 
  GROUP BY [MA_Region])

  /* Select for Display */
	SELECT 
	[Region], [# Accounts]
	FROM regionAccounts
	WHERE [Region] != 'Unknown'
	ORDER BY [Region] ASC

;;
/* Flattening the Ticket Data by Account Number and Ticket Number
	This gives me a table to run clean counts against           */
with ticketlist as (SELECT
[Account Number],
[Ticket Number]
FROM MiningSwap.dbo.[TempMonthlyETDSwap] t with(nolock)
WHERE CASE 
	WHEN t.[MA_Region] IS NOT NULL THEN 1 
	WHEN t.[MA_Region] = 'Unknown' THEN 0 
	ELSE 0 END = 1 AND t.[Submitted On] BETWEEN @StartDate AND @EndDate
GROUP BY [Account Number],
[Ticket Number]),
/* Grabbing Ticket Counts Per Account Number */
ticketCount as (
SELECT
[Account Number],
COUNT(DISTINCT [Ticket Number]) [Tickets]
FROM ticketlist
GROUP BY [Account Number]),
/* Creating a Cross Tab of TicketCount Per account and the Ticket List */
crossTab as (
SELECT 
ticketlist.[Account Number]
,ticketlist.[Ticket Number]
,ticketCount.Tickets
FROM ticketlist 
LEFT JOIN ticketCount on ticketlist.[Account Number] = ticketCount.[Account Number])

/* CrossTabing Ticket Count with Distinct Count of Account Numbers, and Ticket Numbers */
SELECT
Tickets,
COUNT(DISTINCT [Account Number]) [# Accounts],
COUNT(DISTINCT [Ticket Number]) [# Tickets]
FROM crossTab
GROUP BY Tickets
;;
/* Grab a List of Reasons with Ticket Total Counts with an Extra Column for Totals */
SELECT TOP 10 * FROM
(
SELECT
[MD-GB Reason],
'Totals' [Total],
COUNT(DISTINCT [Ticket Number]) Tickets
FROM MiningSwap.dbo.[TempMonthlyETDSwap] t
WHERE CASE 
	WHEN t.[MA_Region] IS NOT NULL THEN 1 
	WHEN t.[MA_Region] = 'Unknown' THEN 0 
	ELSE 0 END = 1 AND t.[Submitted On] BETWEEN @StartDate AND @EndDate
GROUP BY [MD-GB Reason], [MA_Region]) t
/* Pivot out the Sum if all Tickets in the Totals Column per Reason */
PIVOT(
SUM([Tickets]) FOR [Total]
IN ([Totals])) pt
ORDER BY [Totals] DESC


/* Grabbing Ticket Counts by Region */
SELECT
[MA_Region],
COUNT(DISTINCT [Ticket Number]) Tickets
FROM MiningSwap.dbo.[TempMonthlyETDSwap] t
WHERE CASE 
	WHEN t.[MA_Region] IS NOT NULL THEN 1 
	WHEN t.[MA_Region] = 'Unknown' THEN 0 
	ELSE 0 END = 1 AND t.[Submitted On] BETWEEN @StartDate AND @EndDate
GROUP BY [MA_Region]




/* Pulling Top Submitted Tickets */

;;with peraccount as (SELECT
[Account Number],
COUNT(distinct [Ticket Number]) [CountofTickets]
FROM MiningSwap.dbo.[TempMonthlyETDSwap] t with(nolock)
WHERE t.DateSubmitted BETWEEN @StartDate and @EndDate
GROUP BY [Account Number])
,filteredTopAccts as (
SELECT top 15
[Account Number]
,[CountofTickets]
from peraccount p with(nolock)
ORDER BY p.CountofTickets DESC)
SELECT 
[Ticket Number],
t.[Account Number],
[Submitted On],
[AcctType_L-Org],
[Business_Location],
[MD-GB Reason],
cast([DateSubmitted] as date) [DateSubmitted],
[MA_Region],
[Submitted By],
[TITLE],
[City],
[State],
[Status],
[MA],
[SLA Met],
[Bucket],
[Date Bucket],
[7DayCount],
[5DayCount],
[3DayCount],
[1DayCount],
[Biller],
[TicketType],
[Biller],
[TicketType],
Row_Number() over(partition by t.[Account Number], [Ticket Number] order by [Submitted On] DESC) rn
FROM MiningSwap.dbo.[TempMonthlyETDSwap] t with(nolock)
INNER JOIN filteredTopAccts ta with(nolock) on t.[Account Number] = ta.[Account Number]
WHERE t.[DateSubmitted] BETWEEN @StartDate AND @EndDate AND
	/* Remove Tickets from the 4+ Exclusion Table Above */
NOT EXISTS (SELECT 1 FROM #tempExlusions e where e.[Account Number] = t.[Account Number] AND e.[Submitted By] = t.[Submitted By] AND e.DateSubmitted = t.DateSubmitted)


DROP TABLE #tempExlusions