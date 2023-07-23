SET NOCOUNT ON;
;
/*122721:	Cleanup for the R_Weights to remove the dupes;
;
An archive of the dupes for each entry were saved and counted 
as a dated swap table in MiningSwap, as needed for review;
;
*/
;
SELECT [locID]
      ,[fiscalMth]
      ,[metricID]
      ,[posLevel]
      ,[metricWeight]
      ,[groupID]
	  ,COUNT(*) dupeChk
INTO #r_wt_temp
FROM MiningSwap.dbo.R_Weights w with(nolock)
GROUP BY [locID]
      ,[fiscalMth]
      ,[metricID]
      ,[posLevel]
      ,[metricWeight]
      ,[groupID]
;
;
/*Clear the dupes...*/
TRUNCATE TABLE MiningSwap.dbo.R_Weights;
;
;
/*...Then reload the distinct values*/
INSERT INTO MiningSwap.dbo.R_Weights ([locID]
      ,[fiscalMth]
      ,[metricID]
      ,[posLevel]
      ,[metricWeight]
      ,[groupID])
select [locID]
      ,[fiscalMth]
      ,[metricID]
      ,[posLevel]
      ,[metricWeight]
      ,[groupID]
FROM #r_wt_temp t with(nolock)
;
return
;
/*Testing queries after the cleanup was run; 
;
Initial clean found dupes on 7604 entries of the table;
Zero dupes after the clean;
;
*/
;
SELECT COUNT(*) [Dupes Found]
FROM #r_wt_temp t with(nolock)
WHERE t.dupeChk > 1
;
SELECT [locID]
      ,[fiscalMth]
      ,[metricID]
      ,[posLevel]
      ,[metricWeight]
      ,[groupID]
	  ,COUNT(*) dupeChk
FROM MiningSwap.dbo.R_Weights w with(nolock)
GROUP BY [locID]
      ,[fiscalMth]
      ,[metricID]
      ,[posLevel]
      ,[metricWeight]
      ,[groupID]
HAVING COUNT(*) > 1
;
DROP TABLE #r_wt_temp;
;