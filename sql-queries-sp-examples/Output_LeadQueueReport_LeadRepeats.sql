SET NOCOUNT ON;
IF OBJECT_ID('tempdb..#lastLeadPerUCID') IS NOT NULL BEGIN DROP TABLE #lastLeadPerUCID END;
IF OBJECT_ID('tempdb..#joinedData') IS NOT NULL BEGIN DROP TABLE #joinedData END;
IF OBJECT_ID('tempdb..#LeadTotals') IS NOT NULL BEGIN DROP TABLE #LeadTotals END;
IF OBJECT_ID('tempdb..#AgentCallGrouped') IS NOT NULL BEGIN DROP TABLE #AgentCallGrouped END;
IF OBJECT_ID('tempdb..#leadCallsHandled') IS NOT NULL BEGIN DROP TABLE #leadCallsHandled END;
IF OBJECT_ID('tempdb..#weSatData') IS NOT NULL BEGIN DROP TABLE #weSatData END;
IF OBJECT_ID('tempdb..#ldsRepeatData') IS NOT NULL BEGIN DROP TABLE #ldsRepeatData END;
IF OBJECT_ID('tempdb..#StackedData') IS NOT NULL BEGIN DROP TABLE #StackedData END;
;
;
/* eDate will be Last Saturday From Todays Date  */
/* sDate will be the Start of the 4 Weeks Period From the eDate */
with params as (
	SELECT
	/*cast(DateAdd(week,-1,DATEADD(dd, 7-(DATEPART(dw, GetDate())), GetDate())) as date) as eDate
	,cast(DateAdd(day,-300,DateAdd(week,-1,DATEADD(dd, 7-(DATEPART(dw, GetDate())), GetDate()))) as date) as sDate*/
	getdate()-1 as eDate
	,cast(DateAdd(day,-30,DateAdd(week,-1,DATEADD(dd, 7-(DATEPART(dw, GetDate())), GetDate()))) as date) as sDate
)

/*Params Check
select eDate, sDate from params;
return*/

/* Grabbing a Swap of Grouped Agent and Lead Calls as a Base */
/* Looking for Calls to Lead Line that Occured Between the SegStart of the Agent Call
	and the Calculated End of the Agent Call */
SELECT 
	ag.UCID AgUCID
	,Cast(pw.NETIQWORKERID as decimal(10,0)) [WORKERID]
	,DATEADD(s,ag.DISPTIME,ag.SEGSTART) AgSegStart
	,DATEADD(s,ag.DISPTIME + ag.TALKTIME + ag.ANSHOLDTIME + ag.ACWTIME,ag.SEGSTART) AgSegEnd
    ,case 
        when ag.AgXfrEnd is NULL THEN NULL
        WHEN ag.AgXfrEnd < ldsCall.LdXfrEnd THEN 1
        ELSE 0
    END PossibleXfr    
    ,ldsCall.ANSLOGIN
	,pw.FIRSTNAME+' '+pw.LASTNAME leadName
	,w.CODE WAH
	,ma.MGMTAREANAME [site]
	,ldsCall.SEGSTART
	,ldsCall.ANSLOGIN ldsID
	,ldsCall.UCID ldsUCID
	,ldsCall.LEADBILLER Biller
	,DateDiff(second,ldsCall.SEGSTART_UTC,ldsCall.LDXFREND) ldsDuration
	/* Grabbing Order Leads were contected for each UCID */
	,Row_Number() over (partition by ag.UCID order by ldsCall.SEGSTART_UTC ASC) leadCallOrder
INTO #AgentCallGrouped
FROM MiningSwap.dbo.LeadQueue_ECH_ldsCall ldsCall with(nolock)
INNER JOIN params p on ldsCall.SEGSTART between p.sDate and p.eDate
LEFT OUTER JOIN MiningSwap.dbo.LeadQueue_ECH_agsCall ag with(nolock) on ldsCall.CALLING_PTY=ag.ANSLOGIN 
    /*Where the lead call starts before the agent call ends, but after the agent call starts (meaning after the call is answered); */
    and ag.AgJoinStart <= ldsCall.SEGSTART_UTC 
    /*Need to avoid using the segment end since that time will carry across transfers;*/
    and ag.AgJoinEnd >= ldsCall.SEGSTART_UTC
LEFT OUTER JOIN MiningSwap.dbo.PROD_WORKER_ACCOUNTS wa with(nolock)
	on wa.ACCOUNTIDVALUE = ldsCall.ANSLOGIN
	and ldsCall.SEGSTART BETWEEN wa.STARTDATE and ISNULL(wa.ENDDATE,getDate()+1)
LEFT OUTER JOIN MiningSwap.dbo.PROD_WORKERS pw with(nolock)
	on wa.WORKERID = pw.WORKERID
LEFT OUTER JOIN MiningSwap.dbo.PROD_MANAGEMENT_AREAS ma with(nolock)
	on pw.MANAGEMENTAREAID = ma.MANAGEMENTAREAID
LEFT OUTER JOIN MiningSwap.dbo.VID_EMP e with(nolock)
	on pw.NETIQWORKERID = e.ID
LEFT OUTER JOIN MiningSwap.dbo.VID_WAH w with(nolock)
	on e.EMP_SK = w.EMP_SK and DateDiff(d,'18991230',DateAdd(d,-1,getDate())) between w.START_NOM_DATE and case when w.STOP_NOM_DATE is null then DateAdd(d,1,getDate()) else w.STOP_NOM_DATE end
WHERE ag.UCID IS NOT NULL
	--AND ma.MGMTAREANAME IN ('CC-Appleton Call Center', 'CC-Cheektowaga Call Center','CC-Don Haskins  Call Center','CC-El Paso Call Center','CC-Flushing Call Center','CC-McAllen Call Center','CC-RochesterMN Bandell CC','CC-San Antonio Tech Com CC','CC-Worcester Call Center')




/* Grabbing Swap of Last Lead Order of each UCID */
SELECT 
acc.AgUCID agentCallUCID
,max(acc.leadCallOrder) lastLeadInt
INTO #lastLeadPerUCID
FROM #AgentCallGrouped acc with(nolock)
GROUP BY acc.AgUCID



/* Creating Table with Repeat Flags. Flags are identified when the lead Call order doesn't match
the max Lead Interaction count for that Call. Example if an agent called the lead line twice, 2 will 
be in the lastLeadInt column, for the first interaction LeadCallORder #1 will not match to that of the leadLastInt
therefor identifing a repeat on the same call */
SELECT 
acg.*, ll.lastLeadInt
,case when acg.leadCallOrder != ll.lastLeadInt then 1 else 0 end repeatFlag
INTO #joinedData
FROM #AgentCallGrouped acg
LEFT JOIN #lastLeadPerUCID ll with(nolock)
on acg.AgUCID = ll.agentCallUCID



/*joined Data check
select * from #joinedData;
return;*/

/* Grabbing Lead repleat Count Across A */
SELECT 
jd.ANSLOGIN leadLoginID
,sum(jd.repeatFlag) repeatCount
INTO #LeadTotals
FROM #joinedData jd with(nolock)
WHERE jd.ANSLOGIN IS NOT NULL
GROUP BY jd.ANSLOGIN


SELECT 
convert(date,jd.SEGSTART) [Day]
--,DATEADD(DAY, 7 - DATEPART(WEEKDAY, jd.SEGSTART), CAST(jd.SEGSTART AS DATE)) weSat
--,SUM(jd.repeatFlag) repeatFlag
,cast(round(cast(count(distinct case when jd.repeatFlag = 1 then jd.ldsUCID else null end) as float)*100,2) as float) RepeatNum
,cast(round(nullif(cast(count(distinct jd.ldsUCID) as float),0)*100,2) as float) RepeatDenom
,'Day' [Day of Week]
, '2' [Day of Week Assist]
FROM #joinedData jd with(nolock)
WHERE convert(date,jd.SEGSTART) > DATEADD(d,-15,getdate())
Group by CAST(jd.SEGSTART AS DATE) --convert(date,jd.SEGSTART),DATEADD(DAY, 7 - DATEPART(WEEKDAY, jd.SEGSTART), 


UNION ALL

SELECT 
convert(date,jd.SEGSTART) [Day]
--,DATEADD(DAY, 7 - DATEPART(WEEKDAY, jd.SEGSTART), CAST(jd.SEGSTART AS DATE)) weSat
,cast(round(cast(count(distinct case when jd.repeatFlag = 1 then jd.ldsUCID else null end) as float)*100,2) as float) RepeatNum
,cast(round(nullif(cast(count(distinct jd.ldsUCID) as float),0)*100,2) as float) RepeatDenom
,FORMAT(convert(date,jd.SEGSTART),'dddd') [Day of Week]
, '1' [Day of Week Assist]
FROM #joinedData jd with(nolock)
WHERE convert(date,jd.SEGSTART) > DATEADD(d,-130,getdate())
Group by CAST(jd.SEGSTART AS DATE) 



UNION ALL

SELECT 
--convert(date,jd.SEGSTART) [Day]
DATEADD(DAY, 7 - DATEPART(WEEKDAY, jd.SEGSTART), CAST(jd.SEGSTART AS DATE)) [Day]
,cast(round(cast(count(distinct case when jd.repeatFlag = 1 then jd.ldsUCID else null end) as float)*100,2) as float) RepeatNum
,cast(round(nullif(cast(count(distinct jd.ldsUCID) as float),0)*100,2) as float) RepeatDenom
,'Week Ending Saturday' [Day of Week]
, '3' [Day of Week Assist]
FROM #joinedData jd with(nolock)
WHERE DATEADD(DAY, 7 - DATEPART(WEEKDAY, jd.SEGSTART), CAST(jd.SEGSTART AS DATE)) > DATEADD(d,-200,getdate())
Group by DATEADD(DAY, 7 - DATEPART(WEEKDAY, jd.SEGSTART), CAST(jd.SEGSTART AS DATE))


UNION ALL

SELECT 
DateFromParts(YEAR(CASE 
                 WHEN DATEPART(dd,jd.SEGSTART) < 29 THEN DATEADD(d,28-DATEPART(dd,jd.SEGSTART),jd.SEGSTART) 
                 ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,jd.SEGSTART)-28),jd.SEGSTART)) 
             END),Month(CASE 
                 WHEN DATEPART(dd,jd.SEGSTART) < 29 THEN DATEADD(d,28-DATEPART(dd,jd.SEGSTART),jd.SEGSTART) 
                 ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,jd.SEGSTART)-28),jd.SEGSTART)) 
             END),1) [Day] 
,cast(round(cast(count(distinct case when jd.repeatFlag = 1 then jd.ldsUCID else null end) as float)*100,2) as float) RepeatNum
,cast(round(nullif(cast(count(distinct jd.ldsUCID) as float),0)*100,2) as float) RepeatDenom
			 ,'Fiscal Month' [Day of Week]
			 , '4' [Day of Week Assist]
FROM #joinedData jd with(nolock)
WHERE DateFromParts(YEAR(CASE 
                 WHEN DATEPART(dd,jd.SEGSTART) < 29 THEN DATEADD(d,28-DATEPART(dd,jd.SEGSTART),jd.SEGSTART) 
                 ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,jd.SEGSTART)-28),jd.SEGSTART)) 
             END),Month(CASE 
                 WHEN DATEPART(dd,jd.SEGSTART) < 29 THEN DATEADD(d,28-DATEPART(dd,jd.SEGSTART),jd.SEGSTART) 
                 ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,jd.SEGSTART)-28),jd.SEGSTART)) 
             END),1)  > DATEADD(d,-350,getdate())
Group by DateFromParts(YEAR(CASE 
                 WHEN DATEPART(dd,jd.SEGSTART) < 29 THEN DATEADD(d,28-DATEPART(dd,jd.SEGSTART),jd.SEGSTART) 
                 ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,jd.SEGSTART)-28),jd.SEGSTART)) 
             END),Month(CASE 
                 WHEN DATEPART(dd,jd.SEGSTART) < 29 THEN DATEADD(d,28-DATEPART(dd,jd.SEGSTART),jd.SEGSTART) 
                 ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,jd.SEGSTART)-28),jd.SEGSTART)) 
             END),1) 
ORDER BY [Day of Week Assist],[Day of Week],[day]


			 
