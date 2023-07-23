SET NOCOUNT ON; 

DECLARE @Sam nvarchar(30);   
SET @Sam = 'P2140237';  
DECLARE @Today datetime; 
SET @Today = getDate(); 
DECLARE @yNomDate datetime; 
SET @yNomDate = DATEDIFF(d,'12/30/1899',DateAdd(d,-1,@Today)); 
DECLARE @YearAgo datetime;  
SET @YearAgo = DateAdd(YEAR, -1, @Today);  
DECLARE @tNomDate numeric(15,1);   
SET @tNomDate = DATEDIFF(d,'12/30/1899',@Today);   
DECLARE @sevenNomDate as numeric(15,1);   
SET @sevenNomDate = DateDiff(d,'12/30/1899',DateAdd(d,-8,@Today));  
DECLARE @CurrentFiscal as date;  
SET @CurrentFiscal = CASE WHEN DATEPART(dd, @Today) < 29 THEN DATEADD(d,28 - DATEPART(dd, @Today),@Today)  
                  ELSE DATEADD(m,1,DATEADD(d, -1 * (DATEPART(dd, @Today) - 28), @Today)) END;  
DECLARE @LastFiscal date;  
SET @LastFiscal = DATEADD(m, -1, @CurrentFiscal);  
DECLARE @StartofYear date;  
SET @StartofYear = DateFromParts(Year(@Today), 1, 1);  
DECLARE @FiscalStart date;  
SET @FiscalStart = CASE  
                WHEN DATEPART(dd, @StartofYear) < 29 THEN DATEADD(d,28 - DATEPART(dd, @StartofYear),@StartofYear)  
                ELSE DATEADD(m,1,DATEADD(d, -1 * (DATEPART(dd, @StartofYear) - 28), @StartofYear))  
            END;  
DECLARE @FiscalStartCorp date;  
SET @FiscalStartCorp = DATEFROMPARTS(year(@FiscalStart), month(@FiscalStart), 1);  


/*     Query to Populate AutoFill Textbox */ 
/*     This replaces all getEmpAllList() refrences     */ 
SELECT  
pw.FIRSTNAME + ' ' + pw.LASTNAME + '(' + pw.ENTITYACCOUNT + ')' EMPName  
FROM MiningSwap.dbo.PROD_WORKERS pw with(nolock)  
LEFT JOIN MiningSwap.dbo.PROD_JOB_CODES jc with(nolock) on pw.JOBCODEID = jc.JOBCODEID  
LEFT JOIN MiningSwap.dbo.PROD_DEPARTMENTS dep with(nolock) on pw.DEPARTMENTID = dep.DEPARTMENTID  
WHERE pw.WORKERTYPE = 'E' AND  
CASE    WHEN dep.NAME = 'Resi Video Repair Call Ctrs' THEN 1  
        WHEN dep.NAME = 'Resi Video Repair CC' THEN 1 ELSE 0 END = 1 AND  
CASE WHEN jc.TITLE LIKE 'Rep%' THEN 1  
       WHEN jc.TITLE LIKE 'Sup%' THEN 1  
       WHEN jc.TITLE LIKE 'Mgr%' THEN 1 ELSE 0 END = 1 AND     
CASE WHEN pw.TERMINATEDDATE IS NULL THEN 1 
       WHEN pw.TERMINATEDDATE >= @YearAgo THEN 1 ELSE 0 END = 1   
GROUP BY pw.FIRSTNAME, pw.LASTNAME, pw.ENTITYACCOUNT, pw.SAMACCOUNTNAME  

/*     Gather Employee Hierarchy Info Used for Div with Image */ 
/*     This replaces empHierarchyInfo() refrences      */ 
SELECT  
       mw.FIRSTNAME + ' ' + mw.LASTNAME[Hierarchy Lv2],  
       sw.FIRSTNAME + ' ' + sw.LASTNAME[Hierarchy Lv1],  
       pw.FIRSTNAME + ' ' + pw.LASTNAME[Employee]  
FROM MiningSwap.dbo.PROD_WORKERS pw with(nolock)  
LEFT OUTER JOIN MiningSwap.dbo.PROD_WORKERS sw with(nolock) on pw.SUPERVISORID = sw.WORKERID  
LEFT OUTER JOIN MiningSwap.dbo.PROD_WORKERS mw with(nolock) on sw.SUPERVISORID = mw.WORKERID  
WHERE pw.SAMACCOUNTNAME = @Sam;  

/*     Gather Profile Info  */  
/*     This replaces empInfo() references */ 
/*This populates the Profile Info Data   */ 
;;   
with shift as ( 
    SELECT * FROM ( 
        SELECT     
            emp.ID,   
            case when DATENAME(w,NOM_DATE) = 'Saturday' THEN 2        
                WHEN DATENAME(w,NOM_DATE) = 'Sunday' THEN 3   
                WHEN DATENAME(w,NOM_DATE) = 'Monday' THEN 4   
                WHEN DATENAME(w,NOM_DATE) = 'Tuesday' THEN 5          
                WHEN DATENAME(w,NOM_DATE) = 'Wednesday' THEN 6        
                WHEN DATENAME(w,NOM_DATE) = 'Thursday' THEN 7         
                WHEN DATENAME(w,NOM_DATE) = 'Friday' THEN 1  
                ELSE NULL END DayIndex,   
            SUM(seg.DUR) shiftTime   
        FROM MiningSwap.dbo.VID_Shifts seg with(nolock)   
        INNER JOIN MiningSwap.dbo.VID_SEG_CODE sc with(nolock) on seg.SEG_CODE_SK = sc.SEG_CODE_SK   
        INNER JOIN MiningSwap.dbo.VID_EMP emp with(nolock) on seg.EMP_SK = emp.EMP_SK   
        INNER JOIN MiningSwap.dbo.PROD_WORKERS pw with(nolock) on emp.ID = pw.NETIQWORKERID 
        WHERE sc.DESCR = 'Shift' and NOM_DATE BETWEEN @sevenNomDate AND @yNomDate AND pw.SAMACCOUNTNAME = @Sam     
        GROUP BY emp.ID, NOM_DATE) t   
    PIVOT  (  
        SUM(shiftTime) FOR  [DayIndex] IN ([1], [2], [3], [4], [5], [6], [7])) pt),  
daysWorkedTable as(   
    SELECT     
        ID,   
        concat(case when [1] IS NULL THEN '=' ELSE 'F' END,   
            case when [2] IS NULL THEN '=' ELSE 'S' END,       
            case when [3] IS NULL THEN '=' ELSE 'Y' END,       
            case when [4] IS NULL THEN '=' ELSE 'M' END,       
            case when [5] IS NULL THEN '=' ELSE 'T' END,       
            case when [6] IS NULL THEN '=' ELSE 'W' END,       
            case when [7] IS NULL THEN '=' ELSE 'R' END) DaysWorked   
    FROM shift),  
startStopTimes as (   
    SELECT * FROM (   
    SELECT     
        emp.ID,       
        CONCAT(FORMAT(MAX(DATEADD(n,START_MOMENT,'12/30/1899')),'HH:mm'),' - ',FORMAT(MAX(DATEADD(n,STOP_MOMENT,'12/30/1899')),'HH:mm')) shiftTime   
    FROM MiningSwap.dbo.VID_Shifts seg with(nolock)   
    INNER JOIN MiningSwap.dbo.VID_SEG_CODE sc with(nolock) on seg.SEG_CODE_SK = sc.SEG_CODE_SK   
    INNER JOIN MiningSwap.dbo.VID_EMP emp with(nolock) on seg.EMP_SK = emp.EMP_SK   
    INNER JOIN MiningSwap.dbo.PROD_WORKERS pw with(nolock) on emp.ID = pw.NETIQWORKERID 
    WHERE sc.DESCR = 'Shift' and NOM_DATE BETWEEN @sevenNomDate AND @yNomDate AND pw.SAMACCOUNTNAME = @Sam     
    GROUP BY emp.ID) t  ),   
cas as (  SELECT    
    ca.PSID,   
    ca.[Discp Step Descr],   
    ca.[Displinary Action/Reason],   
    ca.[Effective Date],   
    ca.[Purge Date],   
    ROW_NUMBER() OVER (PARTITION BY ca.PSID ORDER BY ca.[Effective Date] DESC) rn   
    FROM MiningSwap.dbo.RANKING_CAR_TEMP ca with(nolock)   
    LEFT OUTER JOIN MiningSwap.dbo.PROD_WORKERS pw with(nolock) on ca.PSID = pw.NETIQWORKERID   
    WHERE pw.ENTITYACCOUNT = @Sam  )             
SELECT   
pl.STATE+' '+pl.CITY [Site], 
jc.TITLE [Title],   
round(cast(DATEDIFF(d,pw.HIREDATE,@Today) as float)/365.0 , 2) [Tenure(yrs)],   
convert(nvarchar,pw.HIREDATE,101) [HireDate],   
case when peer.CODE LIKE '%ICM%' THEN 'ICOMS' when peer.CODE LIKE '%CSG%' THEN 'CSG' else '' end Biller,   
pw.ENTITYACCOUNT [PID],   
pw.NETIQWORKERID [PSID],   
wah.CODE [Work Location],   
daywrk.daysworked [Days Worked],   
sst.shiftTime [Usual Shift],   
ss.Days [Sup Schedule],    
ss.HrsDisplay [Sup Usual Shift],   
cas.[Discp Step Descr] [CA Level],   
cas.[Displinary Action/Reason] [CA Category],   
convert(nvarchar,cas.[Effective Date],101)+' - '+convert(nvarchar,cas.[Purge Date],101) [CA Effective Period]   
FROM MiningSwap.dbo.PROD_WORKERS pw with(nolock)   
LEFT OUTER JOIN MiningSwap.dbo.VID_EMP emp with(nolock) on pw.NETIQWORKERID = emp.ID   
LEFT OUTER JOIN MiningSwap.dbo.VID_Peer peer with(nolock) on emp.EMP_SK = peer.EMP_SK AND peer.START_NOM_DATE <= @tNomDate AND peer.STOP_NOM_DATE >= @tNomDate   
LEFT OUTER JOIN MiningSwap.dbo.VID_WAH wah with(nolock) on emp.EMP_SK = wah.EMP_SK AND wah.START_NOM_DATE <= @tNomDate AND wah.STOP_NOM_DATE >= @tNomDate   
LEFT OUTER JOIN MiningSwap.dbo.PROD_JOB_CODES jc with(nolock) on pw.JOBCODEID = jc.JOBCODEID   
LEFT OUTER JOIN MiningSwap.dbo.PROD_LOCATIONS pl with(nolock) on pw.LOCATIONID = pl.LOCATIONID  
LEFT OUTER JOIN daysWorkedTable daywrk with(nolock) on pw.NETIQWORKERID = daywrk.ID   
LEFT OUTER JOIN startStopTimes sst with(nolock) on pw.NETIQWORKERID = sst.ID   
LEFT OUTER JOIN MiningSwap.dbo.PROD_WORKERS sw with(nolock) on pw.SUPERVISORID = sw.WORKERID   
LEFT OUTER JOIN MiningSwap.dbo.PROD_SUPERVISOR_SHIFTS ss with(nolock) on sw.NETIQWORKERID = ss.PSID   
LEFT OUTER JOIN cas with(nolock) on pw.NETIQWORKERID = cas.PSID AND cas.rn = 1  WHERE pw.SAMACCOUNTNAME = @Sam; 




/*     This replaces the getEmpList() references */ 
/*     This Table populates the Team List that appears 
       When a Sup and above Visits the Page     */ 


SELECT  
       UPPER(LEFT(pw.FIRSTNAME, 1)) + LOWER(SUBSTRING(pw.FIRSTNAME, 2, LEN(pw.FIRSTNAME))) + ' ' + UPPER(LEFT(pw.LASTNAME, 1)) + LOWER(SUBSTRING(pw.LASTNAME, 2, LEN(pw.LASTNAME)))[Agent Name],  
       pw.ENTITYACCOUNT[PID]  
FROM MiningSwap.dbo.PROD_WORKERS pw with(nolock)  
LEFT OUTER JOIN MiningSwap.dbo.PROD_WORKERS sw with(nolock) on pw.SUPERVISORID = sw.WORKERID  
WHERE sw.SAMACCOUNTNAME = @Sam AND pw.TERMINATEDDATE IS NULL  
ORDER BY pw.HIREDATE DESC  
;; 
with shift as (SELECT* FROM (  
SELECT  
    emp.ID,  
    case when DATENAME(w, NOM_DATE) = 'Saturday' THEN 2  
        WHEN DATENAME(w, NOM_DATE) = 'Sunday' THEN 3  
        WHEN DATENAME(w, NOM_DATE) = 'Monday' THEN 4  
        WHEN DATENAME(w, NOM_DATE) = 'Tuesday' THEN 5  
        WHEN DATENAME(w, NOM_DATE) = 'Wednesday' THEN 6  
        WHEN DATENAME(w, NOM_DATE) = 'Thursday' THEN 7  
        WHEN DATENAME(w, NOM_DATE) = 'Friday' THEN 1 ELSE NULL END DayIndex,  
        SUM(seg.DUR) shiftTime  
FROM MiningSwap.dbo.VID_Shifts seg with(nolock)  
INNER JOIN MiningSwap.dbo.VID_SEG_CODE sc with(nolock) on seg.SEG_CODE_SK = sc.SEG_CODE_SK  
INNER JOIN MiningSwap.dbo.VID_EMP emp with(nolock) on seg.EMP_SK = emp.EMP_SK  
WHERE sc.DESCR = 'Shift' and NOM_DATE BETWEEN @sevenNomDate AND @yNomDate  
GROUP BY emp.ID, NOM_DATE) t  
PIVOT  
(SUM(shiftTime) FOR  
[DayIndex] IN([1], [2], [3], [4], [5], [6], [7])) pt)  
, daysWorkedTable as (  
SELECT  
    ID,  
    concat(case when[1] IS NULL THEN '=' ELSE 'F' END,  
    case when[2] IS NULL THEN '=' ELSE 'S' END,  
case when[3] IS NULL THEN '=' ELSE 'Y' END,  
case when[4] IS NULL THEN '=' ELSE 'M' END,  
case when[5] IS NULL THEN '=' ELSE 'T' END,  
case when[6] IS NULL THEN '=' ELSE 'W' END,  
case when[7] IS NULL THEN '=' ELSE 'R' END) DaysWorked  
FROM shift), startStopTimes as (  
SELECT* FROM (  
SELECT  
emp.ID,  
    CONCAT(FORMAT(MAX(DATEADD(n, START_MOMENT, '12/30/1899')), 'HH:mm'), ' - ', FORMAT(MAX(DATEADD(n, STOP_MOMENT, '12/30/1899')), 'HH:mm')) shiftTime  
        FROM MiningSwap.dbo.VID_Shifts seg with(nolock)  
INNER JOIN MiningSwap.dbo.VID_SEG_CODE sc with(nolock) on seg.SEG_CODE_SK = sc.SEG_CODE_SK  
INNER JOIN MiningSwap.dbo.VID_EMP emp with(nolock) on seg.EMP_SK = emp.EMP_SK  
WHERE sc.DESCR = 'Shift' and NOM_DATE BETWEEN @sevenNomDate AND @yNomDate  
GROUP BY emp.ID) t  
)  
SELECT* FROM(  
SELECT  
UPPER(LEFT(pw.FIRSTNAME, 1)) + LOWER(SUBSTRING(pw.FIRSTNAME, 2, LEN(pw.FIRSTNAME))) + ' ' + UPPER(LEFT(pw.LASTNAME, 1)) + LOWER(SUBSTRING(pw.LASTNAME, 2, LEN(pw.LASTNAME))) [Agent Name],  
mm.MetricDisplayName,  
CASE WHEN mm.MetricDisplayName = 'TRP' OR 
mm.MetricDisplayName = 'VOC' OR  
mm.MetricDisplayName = 'FCR' OR 
mm.MetricDisplayName = 'Compliance' OR 
mm.MetricDisplayName = 'Unplanned Time' OR 
mm.MetricDisplayName = 'Transfer Rate' THEN  
round(pd.MetricValue*100,2) ELSE pd.MetricValue END MetricValue,  
pr.SiteRank[Site Rank],  
st.shiftTime[Start Stop],  
dt.DaysWorked[DaysWorked]  
FROM MiningSwap.dbo.PROD_WORKERS pw with(nolock)  
LEFT OUTER JOIN MiningSwap.dbo.PROD_WORKERS sw with(nolock) on pw.SUPERVISORID = sw.WORKERID  
LEFT OUTER JOIN MiningSwap.dbo.RANKING_Prod_Data pd with(nolocK) on cast(pw.NETIQWORKERID as nvarchar(10)) = cast(pd.PSID as nvarchar(10))  
INNER JOIN MiningSwap.dbo.RANKING_Prod_MetricMap mm with(nolock) on pd.MetricID = mm.MetricID  
LEFT OUTER JOIN MiningSwap.dbo.RANKING_Prod_Ranks pr with(nolock) on pd.PSID = pr.PSID AND pd.[Fiscal Mth] = pr.[Fiscal Mth]  
LEFT OUTER JOIN daysWorkedTable dt with(nolock) on pw.NETIQWORKERID = dt.ID  
LEFT OUTER JOIN startStopTimes st with(nolock) on pw.NETIQWORKERID = st.ID  
WHERE sw.SAMACCOUNTNAME = @Sam AND  
pw.TERMINATEDDATE IS NULL AND pd.[Fiscal Mth] = @CurrentFiscal) as t  
PIVOT(  
SUM([MetricValue]) FOR [MetricDisplayName] IN  
([TRP], [AHT], [VOC], [FCR], [Compliance], [Unplanned Time], [Transfer Rate])) pt; 




/*     This replaces all getTeamRank() refrences 
       This populates the Team Ranks when a Sup visists the page     */ 
;; 
with pvi as (  
SELECT* FROM (  
SELECT  
CASE WHEN pd.[Fiscal Mth] = @LastFiscal THEN 1 WHEN pd.[Fiscal Mth] = @CurrentFiscal THEN 2 ELSE NULL END[index],  
mm.MetricDisplayName,  
case when mm.MetricDisplayName LIKE 'Compl%' OR mm.MetricDisplayName = 'FCR' OR mm.MetricDisplayName LIKE 'InCenter%' OR  
mm.MetricDisplayName LIKE 'IntraQ' OR mm.MetricDisplayName LIKE 'Produ%' OR mm.MetricDisplayName LIKE 'Tracker Usage' OR  
mm.MetricDisplayName LIKE 'Trans%' OR mm.MetricDisplayName = 'TRP' OR mm.MetricDisplayName LIKE 'Unplann%' OR  
mm.MetricDisplayName = 'VOC' THEN round(pd.MetricValue*100,2) when mm.MetricDisplayName LIKE 'Credit%' OR mm.MetricDisplayName = 'Audits Per HC' THEN round(pd.MetricValue,2) else pd.MetricValue end MetricValue  
FROM MiningSwap.dbo.RANKING_Prod_Data pd with(nolock)  
INNER JOIN MiningSwap.dbo.RANKING_Prod_MetricMap mm with(nolock) on pd.MetricID = mm.MetricID  
LEFT OUTER JOIN MiningSwap.dbo.PROD_WORKERS pw with(nolock) on pd.PSID = pw.NETIQWORKERID  
WHERE pd.[Fiscal Mth] >= @LastFiscal AND pw.SAMACCOUNTNAME = @Sam AND mm.MetricDisplayName NOT LIKE '%wo NH') t  
PIVOT  
(  
SUM([MetricValue]) FOR [index]  
IN([1], [2]) ) pt)  

SELECT  
MetricDisplayName, [1], [2], round([2]-[1],2)  
    [Change]  
    FROM pvi  


SELECT   
format(DateFromParts(year([FiscalMonth]), Month([FiscalMonth]), 28), 'MM/dd') [CorPortal Ranking],   
cast(cast([Overall Stacked Rank Percentile] as float)/100.00 as float) [Rank] 
FROM MiningSwap.dbo.CORPORTAL_RankingExports  
WHERE[Domain Login] = @Sam 
ORDER BY [FiscalMonth] DESC 


SELECT  
cast(format([Fiscal Mth],'MM/yy') as nvarchar(5)) [VR Ranking],  
[SiteRank]  
FROM MiningSwap.dbo.RANKING_Prod_Ranks pr with(nolock)  
LEFT OUTER JOIN MiningSwap.dbo.PROD_WORKERS pw with(nolock) on pr.PSID = pw.NETIQWORKERID  
WHERE([SiteRank] IS NOT NULL) AND pw.SAMACCOUNTNAME = @Sam  
ORDER BY[Fiscal Mth] ASC  


SELECT  
       format(CASE WHEN DATEPART(dd, [Peer Group Start Date]) < 29 THEN DATEADD(d,28 - DATEPART(dd, [Peer Group Start Date]),[Peer Group Start Date])  
       ELSE DATEADD(m,1,DATEADD(d, -1 * (DATEPART(dd, [Peer Group Start Date]) - 28), [Peer Group Start Date])) END, 'MM/dd') [Fiscal Mth],  
cast(cast([Overall Stacked Rank Percentile] as float)/100.00 as float) [Rank]  
FROM MiningSwap.dbo.CORPORTAL_RankingExports corp with(nolock)   
LEFT JOIN MiningSwap.dbo.PROD_WORKERS pw with(nolock) on corp.[Hr Num] = pw.NETIQWORKERID  
WHERE [Peer Group Start Date] >= @YearAgo AND pw.SAMACCOUNTNAME = @Sam AND [Aspect Peer Group] NOT LIKE '%NH'  
ORDER BY [Peer Group Start Date] DESC  

; ; with fiscalMthsIndex as (  
    SELECT  
        pr.[Fiscal Mth]  
FROM MiningSwap.dbo.RANKING_Prod_Ranks pr with(nolock)  
        WHERE pr.[Fiscal Mth] >= @FiscalStart  
        GROUP BY pr.[Fiscal Mth]),  
VRRankings as(  
SELECT  
    pr.[Fiscal Mth],  
    pr.SiteRank  
FROM MiningSwap.dbo.RANKING_Prod_Ranks pr with(nolock)  
INNER JOIN MiningSwap.dbo.PROD_WORKERS pw with(nolock) on pr.PSID = pw.NETIQWORKERID  
WHERE pr.[Fiscal Mth] >= @FiscalStart AND pw.SAMACCOUNTNAME = @Sam),  
CorPortalRankings as(  
SELECT  
DateFromParts(Year([FiscalMonth]),Month([FiscalMonth]),28) [Fiscal Mth],  
cast([Overall Stacked Rank Percentile] as float) [Rank]  
    FROM MiningSwap.dbo.CORPORTAL_RankingExports corp with(nolock)  
WHERE [FiscalMonth] >= @FiscalStartCorp AND corp.[Domain Login] = @Sam)  
SELECT  
format(fiscalMthsIndex.[Fiscal Mth],'MM/yy') [CorPortal Ranking],  
VRRankings.SiteRank,  
CorPortalRankings.Rank  
FROM fiscalMthsIndex  
LEFT OUTER JOIN VRRankings on fiscalMthsIndex.[Fiscal Mth] = VRRankings.[Fiscal Mth]  
LEFT OUTER JOIN CorPortalRankings on fiscalMthsIndex.[Fiscal Mth] = CorPortalRankings.[Fiscal Mth]  
WHERE VRRankings.SiteRank IS NOT NULL OR CorPortalRankings.Rank IS NOT NULL  
ORDER BY fiscalMthsIndex.[Fiscal Mth] ASC 



SELECT  
sw.FIRSTNAME + ' ' + sw.LASTNAME [Supervisor],  
convert(nvarchar, shd.STARTDATE, 101) + ' - ' +case when shd.ENDDATE IS NULL then ' Current ' ELSE convert(nvarchar, shd.ENDDATE,101) END [Date Range]  
FROM MiningSwap.dbo.PROD_Supervisor_Historical_Daily shd with(nolock)  
LEFT OUTER JOIN MiningSwap.dbo.PROD_WORKERS pw with(nolock) on shd.PEOPLESOFTID = pw.NETIQWORKERID  
LEFT OUTER JOIN MiningSwap.dbo.PROD_WORKERS sw with(nolock) on shd.SUPPEOPLESOFTID = sw.NETIQWORKERID  
WHERE pw.SAMACCOUNTNAME = @Sam 
ORDER BY shd.STARTDATE DESC  






/* Audit and Coaching Data */ 
SELECT  
'BQOA' [System],  
EvalID [ID],   
convert(nvarchar, ad.Publisheddatetime, 101) [Interaction Date],  
[Behavior Coached] [Primary Reason],  
Answer [Secondary Reason],  
convert(nvarchar, ad.[Acknowledged date], 101) [Acknowledged Date]  
    INTO #Audits_UserPSID  
FROM MiningSwap.dbo.OUTLIER_AUDIT_DETAILS ad with(nolock)  
WHERE ad.pid = @Sam 
ORDER BY ad.Publisheddatetime DESC  

SELECT  
'CorPortal' [System],  
[Entry #] [ID],  
convert(nvarchar,cd.[Interaction Date],101) [Interaction Date],  
[Primary Reason] [Primary Reason],  
LEFT(cd.[Coaching Notes], 25) [Secondary Reason],  
case when cd.[Employee Signed] != 0 THEN convert(nvarchar, cd.[Employee Signed On],101) else null end [Acknowledged Date]  
INTO #CorPortal_UserPSID  
FROM MiningSwap.dbo.OUTLIER_COACHING_DETAILS cd with(nolock)  
LEFT OUTER JOIN MiningSwap.dbo.PROD_WORKERS pw on cd.[Employee NTLogon] = pw.SAMACCOUNTNAME  
WHERE pw.SAMACCOUNTNAME = @Sam 
ORDER BY cd.[Interaction Date] DESC  

SELECT TOP 10 [System], [ID], [Interaction Date], [Primary Reason], [Secondary Reason], [Acknowledged Date] FROM #CorPortal_UserPSID  
UNION  
SELECT TOP 10 [System], [ID], [Interaction Date], [Primary Reason], [Secondary Reason], [Acknowledged Date] FROM #Audits_UserPSID  

DROP TABLE #CorPortal_UserPSID 
DROP TABLE #Audits_UserPSID 


SELECT 
ld.agentNotes, 
ld.leaderNotes 
FROM MiningSwap.dbo.meCard_LEADERSHIP_DATA ld with(nolock) 
WHERE ld.psid = @Sam
