SET NOCOUNT ON;
;
DECLARE @sDate date;
DECLARE @eDate date;
;
SET @sDate='6/29/2020';
SET @eDate='10/15/2020';
;
SELECT r.STARTDATE
	,DATEDIFF(d,'12/30/1899',r.STARTDATE)NOM_DATE
    ,PEOPLESOFTID
    ,PID
    ,SUPPEOPLESOFTID
    ,SUPERVISOR_PID
    ,MGRPEOPLESOFTID
    ,MANAGER_PID
	,ll.[Site]
	,ISNULL(w.CODE,'In Center') WorkPlace
	,e.EMP_SK
INTO #ELP_roster
FROM MiningSwap.dbo.RANKING_HIST_ROSTER r with(nolock)
INNER JOIN MiningSwap.dbo.VID_EMP e with(nolock) on r.PEOPLESOFTID=e.ID
INNER JOIN MiningSwap.DIM.Historical_Agent_Location l with(nolock) on e.EMP_SK=l.EMP_SK
	and r.STARTDATE between l.startdate and l.enddate
INNER JOIN MiningSwap.DIM.Locations ll with(nolock) on l.location_sk=ll.location_sk
LEFT OUTER JOIN MiningSwap.dbo.VID_WAH w with(nolock) on w.EMP_SK=e.EMP_SK
	and DATEDIFF(d,'12/30/1899',r.STARTDATE) between w.START_NOM_DATE and w.STOP_NOM_DATE
WHERE r.STARTDATE between @sDate and @eDate
	and ll.Location='TX_EL_PASO_AIRPRT'
;
SELECT r.STARTDATE
FROM #ELP_roster r with(nolock)
GROUP BY r.STARTDATE
ORDER BY 1
;
SELECT CASE
        WHEN DATEPART(dd,r.STARTDATE) < 29 THEN DATEADD(d,28-DATEPART(dd,r.STARTDATE),r.STARTDATE)
        ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,r.STARTDATE)-28),r.STARTDATE))
    END Fiscal
	,r.SUPERVISOR_PID,r.SUPPEOPLESOFTID
	/*Overall*/
	,SUM(case when m.InOut='Scheduled Hours' THEN s.MI ELSE 0 END)Schedule
	,SUM(case when m.Bucket='Unplanned OOO' THEN s.MI ELSE 0 END)UnPlanned
	,SUM(case when m.Bucket='Covid OOO' THEN s.MI ELSE 0 END)Covid
	/*In Center*/
	,SUM(case when r.WorkPlace='In Center' AND m.InOut='Scheduled Hours' THEN s.MI ELSE 0 END)Schedule_INC
	,SUM(case when r.WorkPlace='In Center' AND m.Bucket='Unplanned OOO' THEN s.MI ELSE 0 END)UnPlanned_INC
	,SUM(case when r.WorkPlace='In Center' AND m.Bucket='Covid OOO' THEN s.MI ELSE 0 END)Covid_INC
	/*Remote*/
	,SUM(case when r.WorkPlace='Remote' AND m.InOut='Scheduled Hours' THEN s.MI ELSE 0 END)Schedule_REM
	,SUM(case when r.WorkPlace='Remote' AND m.Bucket='Unplanned OOO' THEN s.MI ELSE 0 END)UnPlanned_REM
	,SUM(case when r.WorkPlace='Remote' AND m.Bucket='Covid OOO' THEN s.MI ELSE 0 END)Covid_REM
INTO #ELP_Sup
FROM MiningSwap.dbo.VID_OOCSuperState s with(nolock)
INNER JOIN MiningSwap.dbo.VID_OOCSuperStateMap m with(nolock) on s.SPRSTATE_SK=m.SPRSTATE_SK
INNER JOIN #ELP_roster r with(nolock) on s.EMP_SK=r.EMP_SK and s.NomDate=r.NOM_DATE
GROUP BY CASE
        WHEN DATEPART(dd,r.STARTDATE) < 29 THEN DATEADD(d,28-DATEPART(dd,r.STARTDATE),r.STARTDATE)
        ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,r.STARTDATE)-28),r.STARTDATE))
    END 
	,r.SUPERVISOR_PID,r.SUPPEOPLESOFTID
;
;
SELECT w.FIRSTNAME+' '+w.LASTNAME Supervisor
	,s.*
FROM #ELP_Sup s with(nolock)
LEFT OUTER JOIN MiningSwap.dbo.PROD_WORKERS w with(nolock) on s.SUPERVISOR_PID=w.ENTITYACCOUNT
ORDER BY 1,2
;
DROP TABLE #ELP_roster;
DROP TABLE #ELP_Sup;