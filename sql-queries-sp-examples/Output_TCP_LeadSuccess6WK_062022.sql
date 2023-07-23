SET NOCOUNT ON;
;
  IF OBJECT_ID('tempdb..#leadSkills') IS NOT NULL BEGIN DROP TABLE #leadSkills END;  
  ;
  IF OBJECT_ID('tempdb..#lastLeadPerUCID') IS NOT NULL BEGIN DROP TABLE #lastLeadPerUCID END;  
  IF OBJECT_ID('tempdb..#joinedData') IS NOT NULL BEGIN DROP TABLE #joinedData END;  
  IF OBJECT_ID('tempdb..#LeadTotals') IS NOT NULL BEGIN DROP TABLE #LeadTotals END;  
  IF OBJECT_ID('tempdb..#AgentCallGrouped') IS NOT NULL BEGIN DROP TABLE #AgentCallGrouped END; 
  IF OBJECT_ID('tempdb..#leadCallsHandled') IS NOT NULL BEGIN DROP TABLE #leadCallsHandled END;
  ;
  IF OBJECT_ID('tempdb..#leadPSIDs') IS NOT NULL BEGIN DROP TABLE #leadPSIDs END;
  ;
  /*
  062022:	Modeled from Monthly version to 6 weeks;
  060822:	Converted to the inverse for the success rate model;
  */
  ;    
  declare @eDate datetime; 
  declare @sDate datetime; 
  ;
  /*Builds into a rolling 6 weeks...*/
  SET @eDate = DATEADD(dw,7-DATEPART(dw,DATEADD(hh,-5, GETUTCDATE())),DATEADD(hh,-5, GETUTCDATE()));
  /*...Shifted to end of most recent week*/
  SET @eDate = DATEADD(wk,-1,@eDate);
;
  SET @sDate = DATEADD(wk,-6,DATEADD(d,1,@eDate));
  ;
  SET @eDate = DATEADD(s,-1,DATEADD(d,1,@eDate));
  ;
  ;;    
	/*060822:	Coverted to skill filtering from roster since Leads not consistently built in history*/
	SELECT s.CMSSERVER
		,s.ACD
		,s.DISPSPLIT
	INTO #leadSkills
	FROM SwitchData.ECH.Lead_Calls_Summary s with(nolock)
	WHERE s.SEGSTOP_Date between @sDate and @eDate
		AND s.CUSTTYPE NOT IN ('SMB')
		AND s.FCSTGRP LIKE 'Escalation%Video%'
	GROUP BY s.CMSSERVER
		,s.ACD
		,s.DISPSPLIT
	;
	;
	/* Grabbing Swap of Agent Calls with Lead Call Data,    
	Apply Row number partitioned by Agent Call, ordered by Lead Start Times */  
	select    
		c.AgentUCID AgUCID   
		,CAST(DATEADD(dw,7-DATEPART(dw,DATEADD(hh,-5, c.AgentRealStartTime)),DATEADD(hh,-5, c.AgentRealStartTime)) as date) WESat
		,c.AgentRealStartTime AgSegStart   
		,c.AgentRealEndTime AgSegEnd   
		,c.LeadPSID   
		,Row_Number() over (partition by c.AgentUCID order by c.LeadSEGSTART ASC) leadCallOrder  
	into #AgentCallGrouped  
	from SwitchData.ECH.Lead_Calls c with(nolocK)  
	/*060822:	Coverted to skill filtering from roster since Leads not consistently built in history*/
	INNER JOIN #leadSkills s with(nolock) on c.LeadCMSSERVER=s.CMSSERVER
		AND c.LeadACD=s.ACD 
		AND c.LeadDISPSPLIT=s.DISPSPLIT  
	where c.AgentRealStartTime between @sDate and @eDate 
		and c.AgentUCID != 0 
	;
	/* Grabbing Swap of Last Lead Order of each UCID    
	These Calls need to be filtered out of the SUM   
	as they were the last lead and should not have    
	a repeat count on that call*/  	
	SELECT   
		acc.AgUCID agentCallUCID  
		,max(acc.leadCallOrder) lastLeadInt  
	INTO #lastLeadPerUCID  
	FROM #AgentCallGrouped acc with(nolock)  
	GROUP BY acc.AgUCID        
	;
	/* Creating Temp Swap of LeadPSID's and a repeatFlag  */  
	SELECT   
		acg.LeadPSID  
		,acg.WESat
		,SUM(case when acg.leadCallOrder != ISNULL(ll.lastLeadInt,-1) then 1 else 0 end) repeatFlag  
		
	INTO #joinedData  
	FROM #AgentCallGrouped acg with(nolock) 
	LEFT JOIN #lastLeadPerUCID ll with(nolock)  
		on acg.AgUCID = ll.agentCallUCID 
	GROUP BY acg.LeadPSID  
		,acg.WESat
	;
	;;
	SELECT   
		ldsCall.LeadPSID  
		,CAST(DATEADD(dw,7-DATEPART(dw,DATEADD(hh,-5, ldsCall.LeadRealStartTime)),DATEADD(hh,-5, ldsCall.LeadRealStartTime)) as date) WESat
		,count(distinct ldsCall.LeadUCID) ldCalls  
	INTO #leadCallsHandled  
	FROM SwitchData.ECH.Lead_Calls ldsCall with(nolock)  
	/*060822:	Coverted to skill filtering from roster since Leads not consistently built in history*/
	INNER JOIN #leadSkills s with(nolock) on ldsCall.LeadCMSSERVER=s.CMSSERVER
		AND ldsCall.LeadACD=s.ACD 
		AND ldsCall.LeadDISPSPLIT=s.DISPSPLIT 
	where ldsCall.LeadRealStartTime between @sDate and @eDate  
	GROUP BY ldsCall.LeadPSID 
		,CAST(DATEADD(dw,7-DATEPART(dw,DATEADD(hh,-5, ldsCall.LeadRealStartTime)),DATEADD(hh,-5, ldsCall.LeadRealStartTime)) as date)  
	;
	;
	SELECT   
		jd.LeadPSID id  
		,jd.WESat 
		/*060822: Per Brandon make the inverse for the new roll out;*/
		,1-(cast(sum(jd.repeatFlag) as float)/nullif(cast(ch.ldCalls as float),0)) LeadSuccessRate  
	FROM #joinedData jd with(nolock)  
	LEFT JOIN #leadCallsHandled ch with(nolock)   
		on jd.LeadPSID = ch.LeadPSID  and jd.WESat=ch.WESat
	WHERE jd.LeadPSID IS NOT NULL  
		and jd.WESat between @sDate and @eDate
	GROUP BY jd.LeadPSID
		,jd.WESat 
		, ch.ldCalls      
	ORDER BY 2,1
	;
	IF OBJECT_ID('tempdb..#leadCallsHandled') IS NOT NULL BEGIN DROP TABLE #leadCallsHandled END;  
	IF OBJECT_ID('tempdb..#lastLeadPerUCID') IS NOT NULL BEGIN DROP TABLE #lastLeadPerUCID END;  
	IF OBJECT_ID('tempdb..#joinedData') IS NOT NULL BEGIN DROP TABLE #joinedData END;   
	IF OBJECT_ID('tempdb..#AgentCallGrouped') IS NOT NULL BEGIN DROP TABLE #AgentCallGrouped END;
	;
	IF OBJECT_ID('tempdb..#leadPSIDs') IS NOT NULL BEGIN DROP TABLE #leadPSIDs END;