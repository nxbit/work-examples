SET NOCOUNT ON;                        
 ;                       
 IF OBJECT_ID('tempdb..#me_EmpTARPID') IS NOT NULL BEGIN DROP table #me_EmpTARPID END;                       
 IF OBJECT_ID('tempdb..#me_drTARPID') IS NOT NULL BEGIN DROP table #me_drTARPID END;                       
 IF OBJECT_ID('tempdb..#me_AuditsTARPID') IS NOT NULL BEGIN DROP table #me_AuditsTARPID END;                       
 IF OBJECT_ID('tempdb..#CorPortal_Supervisor_RankTemp') IS NOT NULl BEGIN DROP TABLE #CorPortal_Supervisor_RankTemp END;         
 IF OBJECT_ID('tempdb..#CorPortal_Agent_RankTemp') IS NOT NULL BEGIN DROP TABLE #CorPortal_Agent_RankTemp END;         
 ;                       
 ;                       
 /*121620: Aligned data type and size to UXID tables*/                      
 DECLARE @Sam varchar(64);                          
 SET @Sam = '<#SELECTEDUSER#>';             
 DECLARE @cSam varchar(64);            
 SET @cSam = '<#CURRENTUSER#>';      
 DECLARE @selSAM numeric;  
 SET @selSAM = (  
 SELECT   
 max(pw.NETIQWORKERID)  
 FROM Database.schema.PROD_WORKERS pw with(nolock)  
 WHERE   
 Case when cast(pw.NETIQWORKERID as nvarchar)= @Sam then 1   
 when cast(pw.SAMACCOUNTNAME as nvarchar) = @Sam then 1   
 when cast(pw.ENTITYACCOUNT as nvarchar) = @Sam then 1 else 0 end = 1);         
 DECLARE @lFiscal as float;  
 SET @lFiscal = (  
 SELECT   
 cast(STR(CAST(LEFT(max([Fiscal Mth]),4) as int) - 1) + RIGHT(max([Fiscal Mth]),2) as float)  
 FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 )      
           
 DECLARE @JobCode numeric(10,0);              
 SET @JobCode = (SELECT JOBCODEID FROM Database.schema.PROD_WORKERS pw with(nolock) WHERE pw.SAMACCOUNTNAME = @cSam);              
 DECLARE @Title nvarchar(15);             
 DECLARE @selTitle nvarchar(15);             
 SET @Title = (SELECT TITLE FROM Database.schema.PROD_WORKERS pw with(nolock) LEFT JOIN Database.schema.PROD_JOB_CODES jc with(nolock) on pw.JOBCODEID = jc.JOBCODEID WHERe pw.SAMACCOUNTNAME = @cSam);             
 SET @selTitle = (SELECT TITLE FROM Database.schema.PROD_WORKERS pw with(nolock) LEFT JOIN Database.schema.PROD_JOB_CODES jc with(nolock) on pw.JOBCODEID = jc.JOBCODEID WHERe case when pw.SAMACCOUNTNAME = @Sam then 1 when pw.ENTITYACCOUNT = @Sam then 1 else 0 end = 1);             
 DECLARE @PosLevel int;             
 DECLARE @selPosLevel int;             
 SET @PosLevel = CASE WHEN @Title LIKE 'GVP%' THEN 5 WHEN @Title LIKE 'Dir%' THEN 4 WHEN @Title LIKE 'Mgr%' THEN 3 WHEN @Title LIKE 'Sup%' THEN 2 ELSE 1 END;             
 SET @selPosLevel = CASE WHEN @selTitle LIKE 'GVP%' THEN 5 WHEN @selTitle LIKE 'Dir%' THEN 4 WHEN @selTitle LIKE 'Mgr%' THEN 3 WHEN @selTitle LIKE 'Sup%' THEN 2 ELSE 1 END;             
           
 ;                       
 DECLARE @Today datetime;                        
 /*121620: Updated from datetime to match data type of Aspect tables*/                      
 DECLARE @yNomDate numeric(15,1);                        
 DECLARE @YearAgo datetime;                         
 DECLARE @tNomDate numeric(15,1);                           
 DECLARE @sevenNomDate as numeric(15,1);                        
 DECLARE @CurrentFiscal as date;                          
 DECLARE @LastFiscal date;                          
 DECLARE @StartofYear date;                         
 DECLARE @FiscalStart date;                         
 DECLARE @FiscalStartCorp date;                         
 ;                       
 SET @Today = DATEADD(d,-1,DATEADD(hh,-5,GETUTCDATE()));                        
 SET @yNomDate = DATEDIFF(d,'12/30/1899',DateAdd(d,-1,@Today));                        
 SET @YearAgo = DateAdd(YEAR, -1, @Today);                         
 SET @tNomDate = DATEDIFF(d,'12/30/1899',@Today);                         
 SET @sevenNomDate = @yNomDate - 7;                       
 SET @CurrentFiscal = CASE                        
 WHEN DATEPART(dd, @Today) < 29 THEN DATEADD(d,28 - DATEPART(dd, @Today),@Today)                   
 ELSE DATEADD(m,1,DATEADD(d, -1 * (DATEPART(dd, @Today) - 28), @Today))                  
 END;                    
 SET @LastFiscal = DATEADD(m, -1, @CurrentFiscal);                         
 SET @StartofYear = DateFromParts(Year(@Today), 1, 1);                         
 SET @FiscalStart = CASE                         
 WHEN DATEPART(dd, @StartofYear) < 29 THEN DATEADD(d,28 - DATEPART(dd, @StartofYear),@StartofYear)                         
 ELSE DATEADD(m,1,DATEADD(d, -1 * (DATEPART(dd, @StartofYear) - 28), @StartofYear))                         
 END;                         
 SET @FiscalStartCorp = DATEFROMPARTS(year(@FiscalStart), month(@FiscalStart), 1);                         
 ;                       
 ;                       
 /**********************************************************************************************/       
 /*RETURN INDEX 0    */       
 /* Return List of Everyone Below the Current User's Position Level in Video Repair            */       
 /* This list drives the search box feature                                                    */                       
 /*121620: Since Dept check returns a small list, great option as filter criteria, moved to CTE*/       
 /**********************************************************************************************/                      
 WITH vid as (                       
 /*Return just the ID to keep footprint lower*/                      
 SELECT d.DEPARTMENTID                      
 FROM Database.schema.PROD_DEPARTMENTS d with(nolock)                      
 WHERE CASE                      
 WHEN d.[NAME] = 'Resi Video Repair Call Ctrs' THEN 1                      
 WHEN d.[NAME] = 'Resi Video Repair CC' THEN 1                      
 ELSE 0                      
 END = 1                       
 )                       
 SELECT                         
 case when pw.PREFFNAME is null then pw.FIRSTNAME else pw.PREFFNAME end + ' ' + pw.LASTNAME + '(' + pw.ENTITYACCOUNT+' - ' + cast(pw.NETIQWORKERID as nvarchar) +')' EMPName                        
 FROM Database.schema.PROD_WORKERS pw with(nolock)                         
 /*121620: Changed from LEFT to INNER given filter criteria made this implicit*/                       
 INNER JOIN Database.schema.PROD_JOB_CODES jc on pw.JOBCODEID = jc.JOBCODEID                         
 INNER JOIN vid dep on pw.DEPARTMENTID = dep.DEPARTMENTID                 
 LEFT JOIN Database.schema.PROD_WORKERS sw with(nolock) on pw.SUPERVISORID = sw.WORKERID                       
 WHERE pw.WORKERTYPE = 'E'                        
 AND pw.DEPARTMENTID IN (SELECT d.DEPARTMENTID FROM vid d)                       
 AND  CASE                        
 /* Only Return Rep, Sup, and Mgr Titles */       
 WHEN jc.TITLE LIKE 'Rep%' THEN 1                     
 WHEN jc.TITLE LIKE 'Lead%' THEN 1                     
 WHEN jc.TITLE LIKE 'Sup%' THEN 1                     
 WHEN jc.TITLE LIKE 'Mgr%' THEN 1        
 WHEN jc.TITLE LIKE 'Dir%' THEN 1                      
 ELSE 0                      
 END = 1                       
 AND CASE                        
 WHEN pw.TERMINATEDDATE IS NULL THEN 1                                  
 ELSE 0                      
 END = 1        
   
 AND pw.JOBCODEID != @JobCode AND CASE                        
 WHEN jc.TITLE LIKE 'Rep%' THEN 1                     
 WHEN jc.TITLE LIKE 'Lead%' THEN 1                     
 WHEN jc.TITLE LIKE 'Sup%' THEN 2                     
 WHEN jc.TITLE LIKE 'Mgr%' THEN 3             
 WHEN jc.TITLE LIKE 'Dir%' THEN 4             
 WHEN jc.TITLE LIKE 'GVP%' THEN 5                      
 /* 012021 - Updated to include      */   
 ELSE 0 END <= @PosLevel        
 GROUP BY case when pw.PREFFNAME is null then pw.FIRSTNAME else pw.PREFFNAME end, pw.LASTNAME, pw.ENTITYACCOUNT, pw.NETIQWORKERID, pw.SAMACCOUNTNAME                         
 ;                       
 ;                       
 /**********************************************************************************************/       
 /* Gather Employee Information. This will be used to populate                                 */       
 /* data in the Profile Information Window                                                     */                      
 /**********************************************************************************************/                       
 SELECT                         
case when mw.PREFFNAME is null then mw.FIRSTNAME else mw.PREFFNAME end + ' ' + mw.LASTNAME + ' - ' + Left(mjc.[TITLE],3) [Hierarchy Lv2],                         
case when sw.PREFFNAME is null then sw.FIRSTNAME else sw.PREFFNAME end + ' ' + sw.LASTNAME + ' - ' + Left(sjc.[TITLE],3) [Hierarchy Lv1],                         
 case when pw.PREFFNAME is null then pw.FIRSTNAME else pw.PREFFNAME end + ' ' + pw.LASTNAME [Employee]                         
 /*121620: Adding fields required for use later, data typed versions also*/                     
 ,pw.NETIQWORKERID                      
 ,CAST(pw.NETIQWORKERID as nvarchar(10)) HRNum                      
 ,pw.SAMACCOUNTNAME                     
 ,pw.ENTITYACCOUNT                      
 ,pw.SUPERVISORID                      
 ,pw.HIREDATE       
 ,pw.SERVICEDATE                
 ,pw.JOBCODEID                      
 ,pw.LOCATIONID                      
 ,sw.NETIQWORKERID SUPNETIQWORKERID                      
 ,CAST(sw.NETIQWORKERID as nvarchar(10)) SUPHrNum                      
 ,pw.WORKERID                      
 ,round(cast(DATEDIFF(d,pw.SERVICEDATE,@Today) as float)/365.0 , 1) [Tenure(yrs)]                         
 /*Placeholders fields to ensure a flat table later*/                      
 ,CAST(NULL as nvarchar(30)) WAH                      
 ,CAST(NULL as nvarchar(30)) Peer                      
 ,CAST(NULL as numeric(15,1)) EMP_SK                      
 INTO #me_EmpTARPID                       
 FROM Database.schema.PROD_WORKERS pw with(nolock)                         
 LEFT OUTER JOIN Database.schema.PROD_WORKERS sw with(nolock) on pw.SUPERVISORID = sw.WORKERID                         
 LEFT OUTER JOIN Database.schema.PROD_WORKERS mw with(nolock) on sw.SUPERVISORID = mw.WORKERID      
 LEFT OUTER JOIN Database.schema.PROD_JOB_CODES sjc with(nolock) on sw.JOBCODEID = sjc.JOBCODEID     
 LEFT OUTER JOIN Database.schema.PROD_JOB_CODES mjc with(nolock) on mw.JOBCODEID = mjc.JOBCODEID                       
 /*121620: Value fed could be a PID or a SAMAccount, ENTITYACCOUNT checked first since page used PID*/                        
 WHERE pw.ENTITYACCOUNT = @Sam                        
 ;                         
 /*121620: Value fed could be a PID or a SAMAccount, addresses scenario where the default pageUser is fed*/                        
 INSERT INTO #me_EmpTARPID                       
 SELECT                         
 case when mw.PREFFNAME is null then mw.FIRSTNAME else mw.PREFFNAME end + ' ' + mw.LASTNAME[Hierarchy Lv2],                         
 case when sw.PREFFNAME is null then sw.FIRSTNAME else sw.PREFFNAME end + ' ' + sw.LASTNAME[Hierarchy Lv1],                         
 case when pw.PREFFNAME is null then pw.FIRSTNAME else pw.PREFFNAME end + ' ' + pw.LASTNAME[Employee]                         
 /*121620: Adding fields required for use later, data typed versions also*/                     
 ,pw.NETIQWORKERID                      
 ,CAST(pw.NETIQWORKERID as nvarchar(10)) HRNum                      
 ,pw.SAMACCOUNTNAME                      
 ,pw.ENTITYACCOUNT                      
 ,pw.SUPERVISORID                      
 ,pw.HIREDATE       
 ,pw.SERVICEDATE                      
 ,pw.JOBCODEID                      
 ,pw.LOCATIONID                      
 ,sw.NETIQWORKERID SUPNETIQWORKERID                      
 ,CAST(sw.NETIQWORKERID as nvarchar(10)) SUPHrNum                      
 ,pw.WORKERID                      
 ,round(cast(DATEDIFF(d,pw.SERVICEDATE,@Today) as float)/365.0 , 1) [Tenure(yrs)]                      
 /*Placeholders fields to ensure a flat table later*/                      
 ,CAST(NULL as nvarchar(30)) WAH                      
 ,CAST(NULL as nvarchar(30)) Peer                      
 ,CAST(NULL as numeric(15,1)) EMP_SK                      
 FROM Database.schema.PROD_WORKERS pw with(nolock)                         
 LEFT OUTER JOIN Database.schema.PROD_WORKERS sw with(nolock) on pw.SUPERVISORID = sw.WORKERID                         
 LEFT OUTER JOIN Database.schema.PROD_WORKERS mw with(nolock) on sw.SUPERVISORID = mw.WORKERID                        
 /*121620: Value fed should be a PID or a SAMAccount, addresses scenario where the default pageUser is fed*/                        
 WHERE (SELECT COUNT(*) FROM #me_EmpTARPID c with(nolock)) = 0                       
 AND pw.SAMACCOUNTNAME = @Sam                       
 ;                         
 /*Apply the EMP_SK if found*/                       
 UPDATE e                       
 SET e.EMP_SK=v.EMP_SK                       
 FROM #me_EmpTARPID e,                       
 Database.schema.VID_EMP v                       
 WHERE v.ID=e.HRNum                       
 ;                       
 ;                       
 /*Apply just the most recent WAH value*/                       
 UPDATE e                       
 SET e.WAH=wah.CODE                       
 FROM #me_EmpTARPID e,                       
 (                       
 SELECT e.HRNum ID                      
 ,w.CODE                     
 ,ROW_NUMBER() OVER (PARTITION BY w.EMP_SK ORDER BY w.STOP_NOM_DATE DESC) rn                     
 FROM #me_EmpTARPID e with(nolock)                      
 INNER JOIN Database.schema.VID_WAH w with(nolock) on e.EMP_SK=w.EMP_SK                      
 WHERE w.START_NOM_DATE <= @tNomDate                      
 AND w.STOP_NOM_DATE >= @sevenNomDate                     
 ) wah                       
 WHERE wah.rn=1 AND e.HRNum=wah.ID                       
 ;                       
 /*Apply just the most recent Peer value*/                       
 UPDATE e                       
 SET e.Peer=peer.CODE                       
 FROM #me_EmpTARPID e,                       
 (                       
 SELECT e.HRNum ID                      
 ,p.CODE                     
 ,ROW_NUMBER() OVER (PARTITION BY p.EMP_SK ORDER BY p.STOP_NOM_DATE DESC) rn                     
 FROM #me_EmpTARPID e with(nolock)                       
 INNER JOIN Database.schema.VID_Peer p with(nolock) on e.EMP_SK=p.EMP_SK                      
 WHERE p.START_NOM_DATE <= @tNomDate                      
 AND p.STOP_NOM_DATE >= @sevenNomDate                     
 ) peer                       
 WHERE peer.rn=1 AND e.HRNum=peer.ID                       
 ;                       
 ;                       
 /**********************************************************************************************/       
 /*RETURN INDEX 1    */       
 /*             Selecting Employee Hirearchy Information and their Name                        */       
 /**********************************************************************************************/                      
 SELECT e.[Hierarchy Lv2] [Lv2]                       
 ,e.[Hierarchy Lv1] [Lv1]                      
 ,e.Employee                      
 FROM #me_EmpTARPID e with(nolock)               
 ;                       
 ;                       
 /**********************************************************************************************/       
 /*RETURN INDEX 2    */       
 /*             Selecting Employee Information For the Profile Information Window              */       
 /**********************************************************************************************/                      
 ;;        
      
        
        
        
        
                          
                        
 with cas as (                         
 SELECT                          
 ca.PSID,                        
 ca.[Discp Step Descr],                        
 ca.[Displinary Action/Reason],                        
 ca.[Effective Date],                        
 ca.[Purge Date],                        
 ROW_NUMBER() OVER (PARTITION BY ca.PSID ORDER BY ca.[Effective Date] DESC) rn                        
 FROM Database.schema.RANKING_CAR_TEMP ca with(nolock)                          
 /*121620: Updated from LEFT to INNER since criteria may the check implicit*/                      
 INNER JOIN #me_EmpTARPID pw with(nolock) on ca.PSID = pw.NETIQWORKERID                          
 /* 012122: Only Returning CA's for thoes marked as Frontline */ 
 INNER JOIN Database.schema.PROD_WORKERS p with(nolock) on ca.PSID = p.NETIQWORKERID 
 INNER JOIN Database.schema.PROD_JOB_ROLES r with(nolock) on p.JOBROLEID = r.JOBROLEID 
 where r.JOBROLE = 'Frontline' 
 )                                    
 SELECT                          
 pl.STATE+' '+pl.CITY [Site],                       
 jc.TITLE [Title],                         
 pw.[Tenure(yrs)],                      
 convert(nvarchar,pw.SERVICEDATE,101) [ServiceDate],                         
 /*121620: Updated to use values sourced in original temp table*/                      
 case when pw.Peer LIKE '%ICM%' THEN 'ICOMS' when pw.Peer LIKE '%CSG%' THEN 'CSG' else '' end Biller,                       
 pw.ENTITYACCOUNT [PID],                         
 pw.NETIQWORKERID [PSID],                         
 /*121620: Updated to use values sourced in original temp table*/                      
 pw.WAH [Work Location],                         
 case when jc.TITLE LIKE 'Sup%' THEN ss2.Days else schd.[Days Worked] end [DaysWorked],                         
 case when jc.TITLE LIKE 'Sup%' THEN ss2.HrsDisplay else schd.[Start/Stop] end [Official Shift],                         
 ss.Days [Sup Schedule],                          
 ss.HrsDisplay [Sup Usual Shift],                         
 case when cas.[Discp Step Descr] is null AND @selPosLevel = 1 then 'None' when @selPosLevel = 2 then '    ' else cas.[Discp Step Descr] end [CA Level],                         
 cas.[Displinary Action/Reason] [CA Category],                         
 convert(nvarchar,cas.[Effective Date],101)+' - '+convert(nvarchar,cas.[Purge Date],101) [CA Effective Period],     
 case when cas.[Purge Date] < DateAdd(d,-1,DATEADD(hh,-5,GETUTCDATE())) then 0 when cas.[Purge Date] IS NULL then 0 else 1 end [CA Active]    
 INTO #empDataWide                         
 FROM #me_EmpTARPID pw with(nolock)                          
 /*121620: References to VID tables replaced by staging roster data earlier in the flow*/                       
 LEFT OUTER JOIN Database.schema.PROD_JOB_CODES jc with(nolock) on pw.JOBCODEID = jc.JOBCODEID                          
 LEFT OUTER JOIN Database.schema.PROD_LOCATIONS pl with(nolock) on pw.LOCATIONID = pl.LOCATIONID                         
 LEFT OUTER JOIN Database.schema.PROD_SCHED schd with(nolock) on pw.NETIQWORKERID = schd.PSID                         
 LEFT OUTER JOIN cas with(nolock) on pw.NETIQWORKERID = cas.PSID AND cas.rn = 1                         
 /*121620: Updated to use values from original employee temp since already pulled once*/                       
 LEFT OUTER JOIN Database.schema.PROD_SUPERVISOR_SHIFTS ss with(nolock) on pw.SUPHrNum = ss.PSID             
 LEFT OUTER JOIN Database.schema.PROD_SUPERVISOR_SHIFTS ss2 with(nolock) on pw.NETIQWORKERID = ss2.PSID    
              
      
      
      
 CREATE TABLE #empData (    
 Col1 varchar(50) NULL,    
 Col2 varchar(50) NULL,    
 Col3 varchar(50) NULL    
 );;    
        
 INSERT INTO #empData(Col1, Col2, Col3)    
 SELECT 'Site' Col1, [Site], 0 Col3    
 FROM #empDataWide    
      
 INSERT INTO #empData(Col1, Col2, Col3)    
 SELECT 'Title' Col1, [Title], 0 Col3    
 FROM #empDataWide    
        
 INSERT INTO #empData(Col1, Col2, Col3)    
 SELECT 'Tenure(yrs)' Col1, [Tenure(yrs)], 0 Col3    
 FROM #empDataWide    
        
 INSERT INTO #empData(Col1, Col2, Col3)    
 SELECT 'ServiceDate' Col1, [ServiceDate], 0 Col3    
 FROM #empDataWide                  
        
 INSERT INTO #empData(Col1, Col2, Col3)    
 SELECT 'Biller' Col1, [Biller], 0 Col3    
 FROM #empDataWide       
        
 INSERT INTO #empData(Col1, Col2, Col3)    
 SELECT 'PID' Col1, [PID], 0 Col3    
 FROM #empDataWide                             
        
 INSERT INTO #empData(Col1, Col2, Col3)    
 SELECT 'PSID' Col1, [PSID], 0 Col3    
 FROM #empDataWide    
      
 INSERT INTO #empData(Col1, Col2, Col3)    
 SELECT 'Work Location' Col1, [Work Location], 0 Col3    
 FROM #empDataWide    
      
 INSERT INTO #empData(Col1, Col2, Col3)    
 SELECT 'DaysWorked' Col1, [DaysWorked], 0 Col3    
 FROM #empDataWide    
      
 INSERT INTO #empData(Col1, Col2, Col3)    
 SELECT 'Offical Shift' Col1, [Official Shift], 0 Col3    
 FROM #empDataWide    
      
 INSERT INTO #empData(Col1, Col2, Col3)    
 SELECT 'Sup Schedule' Col1, isNull([Sup Schedule],''), 0 Col3    
 FROM #empDataWide    
      
 INSERT INTO #empData(Col1, Col2, Col3)    
 SELECT 'Sup Usual Schedule' Col1, isNull([Sup Usual Shift],''), 0 Col3    
 FROM #empDataWide    
      
 INSERT INTO #empData(Col1, Col2, Col3)    
 SELECT 'CA Level' Col1, [CA Level], [CA Active] Col3    
 FROM #empDataWide    
      
 INSERT INTO #empData(Col1, Col2, Col3)    
 SELECT 'CA Category' Col1, [CA Category], [CA Active] Col3    
 FROM #empDataWide    
      
 INSERT INTO #empData(Col1, Col2, Col3)    
 SELECT 'CA Effective Period' Col1, [CA Effective Period], [CA Active] Col3    
 FROM #empDataWide    
      
 SELECT *    
 FROM #empData    
 ;                        
 ;                       
 ;                       
 ;                       
 ;                       
 /**********************************************************************************************/       
 /*             Gather Selected Users's Team List and Information                              */       
 /**********************************************************************************************/                        
 ;                       
 ;                       
 /*121620: Load temp of DR staff to filter results later*/                      
 WITH vid as (                       
 /*Return just the ID to keep footprint lower*/                      
 SELECT d.DEPARTMENTID                      
 FROM Database.schema.PROD_DEPARTMENTS d with(nolock)                      
 WHERE CASE                      
 WHEN d.[NAME] = 'Resi Video Repair Call Ctrs' THEN 1                      
 WHEN d.[NAME] = 'Resi Video Repair CC' THEN 1                      
 ELSE 0                      
 END = 1                       
 )              
 SELECT                         
 UPPER(LEFT(case when pw.PREFFNAME is null then pw.FIRSTNAME else pw.PREFFNAME end, 1)) + LOWER(SUBSTRING(case when pw.PREFFNAME is null then pw.FIRSTNAME else pw.PREFFNAME end, 2, LEN(case when pw.PREFFNAME is null then pw.FIRSTNAME else pw.PREFFNAME end))) + ' ' + UPPER(LEFT(pw.LASTNAME, 1)) + LOWER(SUBSTRING(pw.LASTNAME, 2, LEN(pw.LASTNAME)))[Agent Name],                         
 pw.ENTITYACCOUNT[PID]                         
 ,pw.HIREDATE          
 ,pw.SERVICEDATE                   
 ,pw.NETIQWORKERID                      
 ,CAST(pw.NETIQWORKERID as nvarchar(10)) HRNum                      
 ,CAST(NULL as numeric(15,1))EMP_SK                      
 ,pw.SAMACCOUNTNAME                  
 INTO #me_drTARPID                       
 FROM Database.schema.PROD_WORKERS pw with(nolock)              
 INNER JOIN Database.schema.PROD_DEPARTMENTS d with(nolock) on pw.DEPARTMENTID = d.DEPARTMENTID              
 INNER JOIN Database.schema.PROD_JOB_CODES jc with(nolock) on pw.JOBCODEID = jc.JOBCODEID                         
 /*121620: Converted from LEFT to INNER since filter critera was implicit*/                       
 INNER JOIN #me_EmpTARPID sw with(nolock) on pw.SUPERVISORID = sw.WORKERID                         
 WHERE pw.WORKERTYPE = 'E'                        
 AND pw.DEPARTMENTID IN (SELECT d.DEPARTMENTID FROM vid d)                       
 AND  CASE                        
 WHEN jc.TITLE LIKE 'Rep%' THEN 1                     
 WHEN jc.TITLE LIKE 'Lead%' THEN 1                     
 WHEN jc.TITLE LIKE 'Sup%' THEN 1                     
 WHEN jc.TITLE LIKE 'Mgr%' THEN 1                      
 ELSE 0                      
 END = 1                       
 AND CASE                        
 WHEN pw.TERMINATEDDATE IS NULL THEN 1                                  
 ELSE 0                      
 END = 1                     
 ;                       
 /**********************************************************************************************/       
 /*RETURN INDEX 3    */       
 /*             Display the Selected Users's Team List                                         */       
 /**********************************************************************************************/                      
 SELECT        
 UPPER(LEFT(case when pw.PREFFNAME is null then pw.FIRSTNAME else pw.PREFFNAME end, 1)) + LOWER(SUBSTRING(case when pw.PREFFNAME is null then pw.FIRSTNAME else pw.PREFFNAME end, 2, LEN(case when pw.PREFFNAME is null then pw.FIRSTNAME else pw.PREFFNAME end))) + ' ' + UPPER(LEFT(pw.LASTNAME, 1)) + LOWER(SUBSTRING(pw.LASTNAME, 2, LEN(pw.LASTNAME)))[Agent Name],                      
 pw.ENTITYACCOUNT[PID]        
 FROM Database.schema.PROD_WORKERS pw with(nolock)        
 /*121620: Converted from LEFT to INNER since filter critera was implicit*/        
 INNER JOIN Database.schema.PROD_WORKERS sw with(nolock) on pw.SUPERVISORID = sw.WORKERID        
 WHERE pw.TERMINATEDDATE IS NULL AND pw.SERVICEDATE < DATEADD(hh,-5,GETUTCDATE()) AND sw.SAMACCOUNTNAME = @Sam                          
 ;        
           
           
           
 /*121620: Apply the EMP_SK if it exists, avoid extra joins later*/                      
 UPDATE d                       
 SET d.EMP_SK=e.EMP_SK                       
 FROM #me_drTARPID d,                       
 Database.schema.VID_EMP e                       
 WHERE d.HRNum=e.ID                       
 ;                        
 ;        
 /**********************************************************************************************/       
 /*RETURN INDEX 4    */       
 /*             Select Team Infomration and Selected Metrics                                   */       
 /**********************************************************************************************/                                           
 SELECT                         
 pw.[Agent Name],                        
 pw.SAMACCOUNTNAME [NT Logon] ,                 
 /*pr.SiteRank [Site Rank],                       */ 
 dt.[Start/Stop] [Start Stop],                        
 dt.[Days Worked] [Days Worked]                        
 /*121620: Metric block with fewer windowed queries, pivot metrics already manually managed for this view*/                     
 ,MAX(CASE WHEN mm.MetricDisplayName = 'TRP' THEN round(pd.MetricValue*100,1) ELSE NULL END)TRP                      
 ,MAX(CASE WHEN mm.MetricDisplayName = 'AHT' THEN pd.MetricValue ELSE NULL END)AHT                      
 ,MAX(CASE WHEN mm.MetricDisplayName = 'VOC' THEN round(pd.MetricValue*100,1) ELSE NULL END)VOC                      
 ,MAX(CASE WHEN mm.MetricDisplayName = 'FCR' THEN round(pd.MetricValue*100,1) ELSE NULL END)FCR                      
 ,MAX(CASE WHEN mm.MetricDisplayName = 'Compliance' THEN round(pd.MetricValue*100,1) ELSE NULL END)Compliance                      
 ,MAX(CASE WHEN mm.MetricDisplayName = 'Unplanned Time' THEN round(pd.MetricValue*100,1) ELSE NULL END)[Unplanned Time]                      
 ,MAX(CASE WHEN mm.MetricDisplayName = 'Transfer Rate' THEN round(pd.MetricValue*100,1) ELSE NULL END)[Transfer Rate]                      
 /*121620: Converted to use DR temp table to reduce overhead and joins*/                       
 FROM #me_drTARPID pw with(nolock)                       
 /*121620: Converted from LEFT to INNER since filter criteria was implicit*/                       
 INNER JOIN Database.schema.RANKING_Prod_Data pd with(nolocK) on pw.HRNum = pd.PSID AND pd.RankTypeID = 0                 
 INNER JOIN Database.schema.RANKING_Prod_MetricMap mm with(nolock) on pd.MetricID = mm.MetricID                         
 LEFT OUTER JOIN Database.schema.RANKING_Prod_Ranks pr with(nolock) on pd.PSID = pr.PSID AND pd.[Fiscal Mth] = pr.[Fiscal Mth]  AND pr.RankTypeID = 0                       
 LEFT OUTER JOIN Database.schema.PROD_SCHED dt with(nolock) on pw.HRNum = dt.PSID                              
 WHERE pd.[Fiscal Mth] = @CurrentFiscal                        
 GROUP BY pw.[Agent Name]                       
 ,pw.SAMACCOUNTNAME                  
 ,pr.SiteRank                      
 ,dt.[Start/Stop]                     
 ,dt.[Days Worked]                   
 ;                        
 ;                       
 ;                       
 /**********************************************************************************************/       
 /*RETURN INDEX 5    */       
 /*             Current and Previous Month Selected Metrics                                    */       
 /**********************************************************************************************/                      
 ;;                        
 with pvi as (                         
 SELECT *                       
 FROM (                        
 SELECT                       
 CASE WHEN pd.[Fiscal Mth] = @LastFiscal THEN 1 WHEN pd.[Fiscal Mth] = @CurrentFiscal THEN 2 ELSE NULL END[index],                      
 mm.MetricDisplayName,                      
 case                     
 when mm.MetricDisplayName LIKE 'Compl%' OR        
 mm.MetricDisplayName = 'FCR' OR        
 mm.MetricDisplayName LIKE 'InCenter%' OR                     
 mm.MetricDisplayName LIKE 'Produ%' OR        
 mm.MetricDisplayName LIKE 'Tracker Usage' OR                      
 mm.MetricDisplayName LIKE 'Trans%' OR        
 mm.MetricDisplayName = 'TRP' OR        
 mm.MetricDisplayName LIKE 'Unplann%' OR                      
 mm.MetricDisplayName = 'VOC' THEN round(pd.MetricValue*100,1)        
           
 when mm.MetricDisplayName LIKE 'Credit%' OR        
 mm.MetricDisplayName = 'Audits Per HC' THEN round(pd.MetricValue,1)        
           
 when mm.MetricDisplayName LIKE 'IntraQ%' THEN  round(pd.MetricValue*100,2)        
 else pd.MetricValue        
 end MetricValue         
 , mm.MetricRankOrder                
 FROM Database.schema.RANKING_Prod_Data pd with(nolock)                       
 INNER JOIN Database.schema.RANKING_Prod_MetricMap mm with(nolock) on pd.MetricID = mm.MetricID                       
 /*121620: Converted LEFT to INNER since filter criteria was implicit, updated to use temp*/                    
 INNER JOIN #me_EmpTARPID pw with(nolock) on pd.PSID = pw.HRNum                       
 WHERE pd.[Fiscal Mth] >= @LastFiscal AND mm.MetricDisplayName NOT LIKE '%wo NH'  AND pd.RankTypeID =  0                   
 ) t                        
 PIVOT                        
 (                        
 SUM([MetricValue]) FOR [index]                        
 IN([1], [2]) ) pt                      
 )                         
 SELECT                         
 MetricDisplayName,    
 [1], [2]                      
 , case when MetricDisplayName LIKE 'IntraQ%' THEN round([2]-[1],2) ELSE round([2]-[1],1) END                
 [Change]   
 , case when MetricRankOrder = 1 AND (case when MetricDisplayName LIKE 'IntraQ%' THEN round([2]-[1],2) ELSE round([2]-[1],1) END) < 0 THEN 0    
 when MetricRankOrder = 2 AND (case when MetricDisplayName LIKE 'IntraQ%' THEN round([2]-[1],2) ELSE round([2]-[1],1) END) > 0 THEN 0 ELSE 1 END   
 [Formatting]                         
 FROM pvi                         
 ;                       
 ;                       
                          
 /**********************************************************************************************/       
 /*             Staging Two Tables one for Supervisor Ranks, other for Agent                   */       
 /**********************************************************************************************/             
 SELECT           
 [Hr Num],           
 CASE           
 WHEN DATEPART(dd,[Peer Group End Date]) < 29 THEN DATEADD(d,28-DATEPART(dd,[Peer Group End Date]),[Peer Group End Date])           
 ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,[Peer Group End Date])-28),[Peer Group End Date]           
 ))           
 END [Fiscal Mth],            
 [Overall Stacked Rank Percentile],           
 row_number() over(partition by [Hr Num], CASE           
 WHEN DATEPART(dd,[Peer Group End Date]) < 29 THEN DATEADD(d,28-DATEPART(dd,[Peer Group End Date]),[Peer Group End Date])           
 ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,[Peer Group End Date])-28),[Peer Group End Date]           
 ))           
 END order by [Peer Group Total Days] DESC) rn           
 INTO #CorPortal_Agent_RankTemp         
 FROM Database.schema.CORPORTAL_AGENT_SC ac with(nolock)         
           
 SELECT           
 [Hr Num],           
 CASE           
 WHEN DATEPART(dd,[Peer Group End Date]) < 29 THEN DATEADD(d,28-DATEPART(dd,[Peer Group End Date]),[Peer Group End Date])           
 ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,[Peer Group End Date])-28),[Peer Group End Date]           
 ))           
 END [Fiscal Mth],            
 [Overall Stacked Rank Percentile],           
 row_number() over(partition by [Hr Num], CASE           
 WHEN DATEPART(dd,[Peer Group End Date]) < 29 THEN DATEADD(d,28-DATEPART(dd,[Peer Group End Date]),[Peer Group End Date])           
 ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,[Peer Group End Date])-28),[Peer Group End Date]           
 ))           
 END order by [Peer Group Total Days] DESC) rn           
 INTO #CorPortal_Supervisor_RankTemp         
 FROM Database.schema.CORPORTAL_SUPERVISOR_SC ac with(nolock)         
           
           
 /**********************************************************************************************/       
 /*RETURN INDEX 6    */       
 /*             If Selected Position is a Agent, Return Agent CorPortal Rank                   */       
 /**********************************************************************************************/    
 DECLARE @maxFiscal  smalldatetime;   
 SET     @maxFiscal = (SELECT max([Fiscal Mth]) FROM #CorPortal_Agent_RankTemp)   
 DECLARE @12mAgo smalldatetime;   
 SET @12mAgo = DateAdd(m,-12,@maxFiscal);   
    
 IF @selPosLevel = 1 BEGIN                 
 SELECT                          
 format([Fiscal Mth], 'MM/yy') [CorPortal Ranking],                         
 cast(cast([Overall Stacked Rank Percentile] as float) as float) [Rank]                       
 FROM #CorPortal_Agent_RankTemp with(nolock)                        
 /*121620: Since variable could be PID or SAM, use a value from temp as criteria, aligned where similar data type*/                       
 INNER JOIN #me_EmpTARPID e with(nolock) on e.HRNum=#CorPortal_Agent_RankTemp.[Hr Num] WHERE  #CorPortal_Agent_RankTemp.rn = 1    
 AND #CorPortal_Agent_RankTemp.[Fiscal Mth] > @12mAgo        
 ORDER BY [Fiscal Mth] DESC         
 END ELSE         
 /**********************************************************************************************/       
 /*RETURN INDEX 6    */       
 /*             If Selected Position is not and Agent, Return Supervisor CorPortal Rank        */       
 /**********************************************************************************************/         
 BEGIN         
 SELECT                          
 format([Fiscal Mth], 'MM/yy') [CorPortal Ranking],                         
 cast(cast([Overall Stacked Rank Percentile] as float) as float) [Rank]                       
 FROM #CorPortal_Supervisor_RankTemp with(nolock)                        
 /*121620: Since variable could be PID or SAM, use a value from temp as criteria, aligned where similar data type*/                       
 INNER JOIN #me_EmpTARPID e with(nolock) on e.HRNum=#CorPortal_Supervisor_RankTemp.[Hr Num] WHERE  #CorPortal_Supervisor_RankTemp.rn = 1      
 AND #CorPortal_Supervisor_RankTemp.[Fiscal Mth] > @12mAgo            
 ORDER BY [Fiscal Mth] DESC         
 END         
 ;                                                  
 /**********************************************************************************************/       
 /*RETURN INDEX 7    */       
 /*                                   Build Team Moves Table,                                  */       
 /**********************************************************************************************/                         
 ;                       
 ;                       
 SELECT                         
 case when sw.PREFFNAME is null then sw.FIRSTNAME else sw.PREFFNAME end + ' ' + sw.LASTNAME [Supervisor],                        
 convert(nvarchar, shd.STARTDATE, 101) + ' - ' +case when shd.ENDDATE IS NULL then ' Current ' ELSE convert(nvarchar, DateAdd(d,-1,shd.ENDDATE),101) END [Started On - Ended On]                        
 FROM Database.schema.PROD_Supervisor_Historical_Daily shd with(nolock)                         
 /*121620: Converted LEFT to INNER since filter criteria was implicit, updated to use temp*/                      
 INNER JOIN #me_EmpTARPID pw with(nolock) on shd.PEOPLESOFTID = pw.NETIQWORKERID                         
 LEFT OUTER JOIN Database.schema.PROD_WORKERS sw with(nolock) on shd.SUPPEOPLESOFTID = sw.NETIQWORKERID                         
 ORDER BY shd.STARTDATE DESC                         
 ;                       
 ;                       
 ;                       
 /**********************************************************************************************/       
 /*RETURN INDEX 8    */       
 /*               Grab Agent Interactions on BQOA and CorPortal Team Moves Table               */       
 /**********************************************************************************************/                       
 SELECT                         
 CAST('BQOA' as varchar(25)) [System],                        
 EvalID [ID],                         
 convert(nvarchar, ad.Publisheddatetime, 101) [Interaction Date],                        
 [Behavior Coached] [Primary Reason],                        
 Answer [Secondary Reason],                        
 convert(nvarchar, ad.[Acknowledged date], 101) [Acknowledged Date]                       
 ,1 audType                       
 ,ROW_NUMBER() OVER(ORDER BY ad.Publisheddatetime DESC)audOrd                      
 INTO #me_AuditsTARPID                         
 FROM Database.schema.OUTLIER_AUDIT_DETAILS ad with(nolock)                         
 /*121620: Converted LEFT to INNER since filter criteria was implicit, updated to use temp*/                      
 INNER JOIN #me_EmpTARPID e with(nolock) on e.ENTITYACCOUNT=ad.pid                       
 ;                       
 ;                       
 INSERT INTO #me_AuditsTARPID                       
 SELECT                         
 'CorPortal' [System],                        
 [Entry #] [ID],                        
 convert(nvarchar,cd.[Interaction Date],101) [Interaction Date],                        
 [Primary Reason] [Primary Reason],                        
 LEFT(cd.[Coaching Notes], 25) [Secondary Reason],                        
 case when cd.[Employee Signed] != 0 THEN convert(nvarchar, cd.[Employee Signed On],101) else null end [Acknowledged Date]                        
 ,0 audType                      
 ,ROW_NUMBER() OVER(ORDER BY cd.[Interaction Date] DESC)audOrd                      
 FROM Database.schema.OUTLIER_COACHING_DETAILS cd with(nolock)                         
 /*121620: Converted LEFT to INNER since filter criteria was implicit, updated to use temp*/                      
 INNER JOIN #me_EmpTARPID pw on cd.[Employee NTLogon] = pw.SAMACCOUNTNAME                         
 ;                       
 ;                        
 SELECT [System], [ID], [Interaction Date], [Primary Reason], [Secondary Reason], [Acknowledged Date]                        
 FROM #me_AuditsTARPID a with(nolock)                       
 WHERE a.audOrd <= 10                       
 ORDER BY a.[Interaction Date] DESC       
 ;                       
 ;                       
 ;          
 /**********************************************************************************************/       
 /*RETURN INDEX 9    */       
 /*                                   Grab Leadership Notes                                    */       
 /**********************************************************************************************/                     
 SELECT                        
 ld.agentNotes,                       
 ld.leaderNotes                       
 FROM Database.schema.meCard_LEADERSHIP_DATA ld with(nolock)                        
 INNER JOIN #me_EmpTARPID e with(nolock) on ld.psid=@Sam                    
 ;;         
 /**********************************************************************************************/       
 /*RETURN INDEX 10    */       
 /*                        Grab List of All Employees for Admin                                */       
 /**********************************************************************************************/              
 WITH vid as (                       
 /*Return just the ID to keep footprint lower*/                      
 SELECT d.DEPARTMENTID                      
 FROM Database.schema.PROD_DEPARTMENTS d with(nolock)                      
 WHERE CASE                      
 WHEN d.[NAME] = 'Resi Video Repair Call Ctrs' THEN 1                      
 WHEN d.[NAME] = 'Resi Video Repair CC' THEN 1                      
 ELSE 0                      
 END = 1                       
 )                       
 SELECT                         
 case when pw.PREFFNAME is null then pw.FIRSTNAME else pw.PREFFNAME end + ' ' + pw.LASTNAME + '(' + pw.ENTITYACCOUNT + ' - ' + cast(pw.NETIQWORKERID as nvarchar) + ')' EMPName                        
 FROM Database.schema.PROD_WORKERS pw with(nolock)                         
 /*121620: Changed from LEFT to INNER given filter criteria made this implicit*/                       
 INNER JOIN Database.schema.PROD_JOB_CODES jc on pw.JOBCODEID = jc.JOBCODEID                         
 INNER JOIN vid dep on pw.DEPARTMENTID = dep.DEPARTMENTID                 
 LEFT JOIN Database.schema.PROD_WORKERS sw with(nolock) on pw.SUPERVISORID = sw.WORKERID                       
 WHERE pw.WORKERTYPE = 'E'                        
 AND pw.DEPARTMENTID IN (SELECT d.DEPARTMENTID FROM vid d)                       
 AND  CASE                        
 WHEN jc.TITLE LIKE 'Rep%' THEN 1                     
 WHEN jc.TITLE LIKE 'Lead%' THEN 1                     
 WHEN jc.TITLE LIKE 'Sup%' THEN 1                     
 WHEN jc.TITLE LIKE 'Mgr%' THEN 1                      
 ELSE 0                      
 END = 1                       
 AND CASE                        
 WHEN pw.TERMINATEDDATE IS NULL THEN 1                      
 /*WHEN pw.TERMINATEDDATE >= @YearAgo THEN 1*/                      
 ELSE 0                      
 END = 1                 
 GROUP BY case when pw.PREFFNAME is null then pw.FIRSTNAME else pw.PREFFNAME end, pw.LASTNAME, pw.ENTITYACCOUNT, pw.NETIQWORKERID, pw.SAMACCOUNTNAME                   
 ;       
 ;       
 /**********************************************************************************************/       
 /*RETURN INDEX 11    */       
 /*                        Grab APD Link of Selected User                                       */       
 /**********************************************************************************************/         
 SELECT       
 pl.STATE+' '+pl.CITY [StateCity],       
 adp.Link       
 FROM Database.schema.PROD_WORKERS pw with(nolock)       
 INNER JOIN Database.schema.PROD_LOCATIONS pl with(nolock) on pw.LOCATIONID = pl.LOCATIONID       
 LEFT JOIN Database.schema.meCard_SITE_APD_LINKS adp with(nolock) on pl.STATE+' '+pl.CITY = adp.stateCity       
 WHERE pw.SAMACCOUNTNAME = @Sam OR pw.ENTITYACCOUNT = @Sam       
      
      
 BEGIN     
 IF @selPosLevel = 1    
 SELECT    
 cast([Status_TS] as date) [UpdatedOn]    
 FROM Database.schema.JOB_StatusTracking jt with(nolock)    
 WHERE jt.JobToken = 'CorPortal.Agent'    
 ELSE    
 SELECT    
 cast([Status_TS] as date) [UpdatedOn]    
 FROM Database.schema.JOB_StatusTracking jt with(nolock)    
 WHERE jt.JobToken = 'CorPortal.Supervisor'    
 END  
   
 /* AHT Chart Data for Mgr, Sup and Agent is default case */ 
 IF @selPosLevel != 2 AND @selPosLevel != 3 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth],  
 case when sum(da.ahtDenom) = 0 then null when sum(da.ahtDenom) is NULL then NULL else  
 round(sum(da.ahtNom)/sum(da.ahtDenom),0) end[AHT]  
 FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 WHERE da.agentPSID = @selSAM AND da.[Fiscal Mth] >= @lFiscal  
 GROUP BY[Fiscal Mth]  
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
 IF @selPosLevel = 2 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth],  
 case when sum(da.ahtDenom) = 0 then null when sum(da.ahtDenom) is NULL then NULL else  
 round(sum(da.ahtNom)/sum(da.ahtDenom),0) end[AHT]  
 FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 WHERE da.supPSID = @selSAM AND da.[Fiscal Mth] >= @lFiscal  
 GROUP BY[Fiscal Mth], supPSID 
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
 IF @selPosLevel = 3 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth],  
 case when sum(da.ahtDenom) = 0 then null when sum(da.ahtDenom) is NULL then NULL else  
 round(sum(da.ahtNom)/sum(da.ahtDenom),0) end[AHT]  
 FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 WHERE da.mgrPSID = @selSAM AND da.[Fiscal Mth] >= @lFiscal  
 GROUP BY[Fiscal Mth], mgrPSID 
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
 /* COMP Chart Data for Mgr, Sup, and Agent is default case */ 
 IF @selPosLevel != 2 AND @selPosLevel != 3 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth],  
 case when sum(da.adhDenom) = 0 then null when sum(da.adhDenom) is NULL then NULL else  
 round(sum(da.adhNom)/sum(da.adhDenom) *100,2) end[Compliance]  
  FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 WHERE da.agentPSID = @selSAM AND da.[Fiscal Mth] >= @lFiscal  
 GROUP BY[Fiscal Mth]  
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
 IF @selPosLevel = 2 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth],  
 case when sum(da.adhDenom) = 0 then null when sum(da.adhDenom) is NULL then NULL else  
 round(sum(da.adhNom)/sum(da.adhDenom) *100,2) end[Compliance]  
  FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 WHERE da.supPSID = @selSAM AND da.[Fiscal Mth] >= @lFiscal  
 GROUP BY[Fiscal Mth], supPSID  
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
 IF @selPosLevel = 3 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth],  
 case when sum(da.adhDenom) = 0 then null when sum(da.adhDenom) is NULL then NULL else  
 round(sum(da.adhNom)/sum(da.adhDenom) *100,2) end[Compliance]  
  FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 WHERE da.mgrPSID = @selSAM AND da.[Fiscal Mth] >= @lFiscal  
 GROUP BY[Fiscal Mth], mgrPSID  
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
           
 /* FCR Chart Data for Mgr, Sup, and Agent is default case */                          
 IF @selPosLevel != 2 AND @selPosLevel !=3 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth],  
 case when sum(da.fcrDenom) = 0 then null when sum(da.fcrDenom) is NULL then NULL else  
 round(sum(da.fcrNom)/sum(da.fcrDenom) *100,2) end [FCR]  
  FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 WHERE da.agentPSID = @selSAM AND da.[Fiscal Mth] >= @lFiscal  
 GROUP BY[Fiscal Mth]  
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
 IF @selPosLevel = 2 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth],  
 case when sum(da.fcrDenom) = 0 then null when sum(da.fcrDenom) is NULL then NULL else  
 round(sum(da.fcrNom)/sum(da.fcrDenom) *100,2) end [FCR]  
  FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 WHERE da.supPSID = @selSAM AND da.[Fiscal Mth] >= @lFiscal  
 GROUP BY[Fiscal Mth], supPSID  
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
 IF @selPosLevel = 3 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth],  
 case when sum(da.fcrDenom) = 0 then null when sum(da.fcrDenom) is NULL then NULL else  
 round(sum(da.fcrNom)/sum(da.fcrDenom) *100,2) end [FCR]  
  FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 WHERE da.mgrPSID = @selSAM AND da.[Fiscal Mth] >= @lFiscal  
 GROUP BY[Fiscal Mth], mgrPSID  
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
  
  
 /* VOC Chart Data for Mgr, Sup, and Agent is default case */ 
 IF @selPosLevel != 2 AND @selPosLevel != 3 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth],  
 case when sum(da.vocDenom) = 0 then null when sum(da.vocDenom) is NULL then NULL else  
 round(sum(da.vocNom)/sum(da.vocDenom) *100,2) end [VOC]  
  FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 WHERE da.agentPSID = @selSAM AND da.[Fiscal Mth] >= @lFiscal  
 GROUP BY[Fiscal Mth]  
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
 IF @selPosLevel = 2 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth],  
 case when sum(da.vocDenom) = 0 then null when sum(da.vocDenom) is NULL then NULL else  
 round(sum(da.vocNom)/sum(da.vocDenom) *100,2) end [VOC]  
  FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 WHERE da.supPSID = @selSAM AND da.[Fiscal Mth] >= @lFiscal  
 GROUP BY[Fiscal Mth], supPSID  
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
 IF @selPosLevel = 3 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth],  
 case when sum(da.vocDenom) = 0 then null when sum(da.vocDenom) is NULL then NULL else  
 round(sum(da.vocNom)/sum(da.vocDenom) *100,2) end [VOC]  
  FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 WHERE da.mgrPSID = @selSAM AND da.[Fiscal Mth] >= @lFiscal  
 GROUP BY[Fiscal Mth], mgrPSID  
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
  
  
 /* Transfer Chart Data for Mgr. Sup and Agent is default case */ 
 IF @selPosLevel != 2 AND @selPosLevel != 3 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth],  
 case when sum(da.ahtDenom) = 0 then null when sum(da.ahtDenom) is NULL then NULL else  
 round(sum(da.TransNom)/sum(da.ahtDenom) *100,2) end [Transfer]  
  FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 WHERE da.agentPSID = @selSAM AND da.[Fiscal Mth] >= @lFiscal  
 GROUP BY[Fiscal Mth]  
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
 IF @selPosLevel = 2 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth],  
 case when sum(da.ahtDenom) = 0 then null when sum(da.ahtDenom) is NULL then NULL else  
 round(sum(da.TransNom)/sum(da.ahtDenom) *100,2) end [Transfer]  
  FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 WHERE da.supPSID = @selSAM AND da.[Fiscal Mth] >= @lFiscal  
 GROUP BY [Fiscal Mth], supPSID 
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
 IF @selPosLevel = 3 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth],  
 case when sum(da.ahtDenom) = 0 then null when sum(da.ahtDenom) is NULL then NULL else  
 round(sum(da.TransNom)/sum(da.ahtDenom) *100,2) end [Transfer]  
  FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 WHERE da.mgrPSID = @selSAM AND da.[Fiscal Mth] >= @lFiscal  
 GROUP BY [Fiscal Mth], mgrPSID 
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
  
  
  
  
 /* Unplanned OOO Chart Data for Mgr, Sup, and Agent is default case */ 
 IF @selPosLevel = 3 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth]  
 ,round(sum(case when [Category] = 'Unplanned OOO' THEN [Hours] ELSE 0 END)/sum(case when [Category] = 'Scheduled' THEN [Hours] ELSE NULL END)*100,2) [Unplanned]  
 FROM Database.schema.RANKING_OOO_DATAMGR od with(nolock)  
 WHERE od.EmpID = @selSAM AND od.[Fiscal Mth] >= @lFiscal  
 GROUP BY [Fiscal Mth]  
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
 IF @selPosLevel = 2 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth]  
 ,round(sum(case when [Category] = 'Unplanned OOO' THEN [Hours] ELSE 0 END)/sum(case when [Category] = 'Scheduled' THEN [Hours] ELSE NULL END)*100,2) [Unplanned]  
 FROM Database.schema.RANKING_OOO_DATASUP od with(nolock)  
 WHERE od.EmpID = @selSAM AND od.[Fiscal Mth] >= @lFiscal  
 GROUP BY [Fiscal Mth]  
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
 IF @selPosLevel != 2 AND @selPosLevel != 3 BEGIN 
 SELECT  
 RIGHT([Fiscal Mth],2)+'/' + RIGHT(LEFT([Fiscal Mth], 4),2) [Fiscal Mth]  
 ,round(sum(case when [Category] = 'Unplanned OOO' THEN [Hours] ELSE 0 END)/sum(case when [Category] = 'Scheduled' THEN [Hours] ELSE NULL END)*100,2) [Unplanned]  
 FROM Database.schema.RANKING_OOO_DATA od with(nolock)  
 WHERE od.EmpID = @selSAM AND od.[Fiscal Mth] >= @lFiscal  
 GROUP BY [Fiscal Mth]  
 ORDER BY DateFromParts(cast(LEFT([Fiscal Mth],4) as int),cast(RIGHT([Fiscal Mth],2) as int),1) DESC  
 END; 
  
  
  
  
 SELECT  
 cast([Status_TS] as date) [RankingUpdate]  
     FROM Database.schema.JOB_StatusTracking jt with(nolock)  
 WHERE jt.JobToken = 'Ranking.Updating'  
  
  
 ;; with fcrdates as (SELECT  
   [Date],  
   sum([fcrDenom])[Denom]  
 FROM Database.schema.RANKING_DATA_ALL da with(nolock)  
 GROUP BY da.[Date])  
 SELECT  
 max([Date]) [fcrUpdatedThrough]  
     FROM fcrDates  
 WHERE[Denom] != 0  
  
 IF OBJECT_ID('tempdb..#me_EmpTARPID') IS NOT NULL BEGIN DROP table #me_EmpTARPID END;                       
 IF OBJECT_ID('tempdb..#me_drTARPID') IS NOT NULL BEGIN DROP table #me_drTARPID END;                       
 IF OBJECT_ID('tempdb..#me_AuditsTARPID') IS NOT NULL BEGIN DROP table #me_AuditsTARPID END;                       
 IF OBJECT_ID('tempdb..#CorPortal_Supervisor_RankTemp') IS NOT NULl BEGIN DROP TABLE #CorPortal_Supervisor_RankTemp END;         
 IF OBJECT_ID('tempdb..#CorPortal_Agent_RankTemp') IS NOT NULL BEGIN DROP TABLE #CorPortal_Agent_RankTemp END;         
 IF OBJECT_ID('tempdb..#empData') IS NOT NULL BEGIN DROP TABLE #empData END;    
 IF OBJECT_ID('tempdb..#empDataWide') IS NOT NULL BEGIN DROP TABLE #empDataWide END;   
IF OBJECT_ID('tempdb..#Temp_cUserTeamList') IS NOT NULL BEGIN DROP table #Temp_cUserTeamList END;  




SELECT 
LEFT(jc.[TITLE],3) [TITLE] 
FROM Database.schema.PROD_WORKERS pw with(nolock)  
INNER JOIN Database.schema.PROD_JOB_CODES jc with(nolock) on pw.JOBCODEID = jc.JOBCODEID 
WHERE pw.SAMACCOUNTNAME = '<#CURRENTUSER#>'


SELECT 
LEFT(jc.[TITLE], 3)[TITLE] 
FROM Database.schema.PROD_WORKERS pw with(nolock) 
INNER JOIN Database.schema.PROD_JOB_CODES jc with(nolock) on pw.JOBCODEID = jc.JOBCODEID 
WHERE case when pw.SAMACCOUNTNAME = '<#SELECTEDUSER#>' THEN 1 WHEN pw.ENTITYACCOUNT = '<#SELECTEDUSER#>' THEN 1 ELSE 0 END = 1 


SELECT 
case when max([EMAIL]) is null then 'noemail@email.com' else max([EMAIL]) end [cUserEmail] 
   FROM Database.schema.PROD_WORKERS pw with(nolock) 
WHERE pw.ENTITYACCOUNT = '<#CURRENTUSER#>' OR pw.SAMACCOUNTNAME = '<#CURRENTUSER#>' 



DECLARE @SamAcct nvarchar(30); 
SET @SamAcct = '<#CURRENTUSER#>'; 
SELECT 
case when pw.PREFFNAME is null then pw.FIRSTNAME else pw.PREFFNAME end+' '+pw.LASTNAME [Agent Name], 
pw.ENTITYACCOUNT [PID] 
INTO #Temp_cUserTeamList 
FROM Database.schema.PROD_WORKERS pw with(nolock) 
LEFT JOIN Database.schema.PROD_WORKERS sw with(nolock) on pw.SUPERVISORID = sw.WORKERID 
WHERE sw.SAMACCOUNTNAME = @SamAcct AND  
	CASE WHEN pw.TERMINATEDDATE IS NULL AND pw.HIREDATE < DATEADD(hh,-5,GETUTCDATE()) THEN 1 
		ELSE 0 END 
		= 1 
DECLARE @tl int; 
SET @tl = (SELECT COUNT(DISTINCT [PID]) FROM #Temp_cUserTeamList); 
DECLARE @cUserSC nvarchar(30); 
SET @cUserSC = (SELECT pl.STATE+' '+pl.CITY FROM Database.schema.PROD_WORKERS pw with(nolock) LEFT JOIN Database.schema.PROD_LOCATIONS pl with(nolock) on pw.LOCATIONID = pl.LOCATIONID where pw.SAMACCOUNTNAME = '<#CURRENTUSER#>'); 
IF @tl = 0 BEGIN 
SELECT 
case when pw.PREFFNAME is null then pw.FIRSTNAME else pw.PREFFNAME end+' '+pw.LASTNAME [Agent Name], 
pw.[ENTITYACCOUNT] [PID] 
FROM Database.schema.PROD_WORKERS pw with(nolock) 
LEFT JOIN Database.schema.PROD_LOCATIONS pl with(nolock) on pw.LOCATIONID = pl.LOCATIONID 
LEFT JOIN Database.schema.PROD_JOB_CODES jc with(nolock) on pw.JOBCODEID = jc.JOBCODEID 
LEFT JOIN Database.schema.PROD_DEPARTMENTS pd with(nolock) on pw.DEPARTMENTID = pd.DEPARTMENTID 
WHERE pl.STATE+' '+pl.CITY = @cUserSC AND jc.TITLE LIKE 'Mgr%' AND  
 CASE       
  WHEN pd.[NAME] = 'Resi Video Repair Call Ctrs' THEN 1       
  WHEN pd.[NAME] = 'Resi Video Repair CC' THEN 1       
  ELSE 0       
 END = 1  
END; 
IF @tl != 0 BEGIN 
SELECT 
pw.[Agent Name], 
pw.[PID] 
FROM #Temp_cUserTeamList pw with(nolock) 
END; 
IF OBJECT_ID('tempdb..#Temp_cUserTeamList') IS NOT NULL BEGIN DROP table #Temp_cUserTeamList END; 