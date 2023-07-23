SET NOCOUNT ON;
;
SELECT s.MA
	,s.[Customer - Account Number]
	,COUNT(DISTINCT c.[Segment Start Date and Time]) Calls
FROM MiningSwap.dbo.CSI_StreamingSales s with(nolock)
LEFT OUTER JOIN MiningSwap.dbo.CSI_VideoCalls c with(nolock) on s.MA=c.MA
	and s.[Customer - Account Number]=c.[Customer - Account Number]
--WHERE s.[No Box - Customer Owned Device Flag] = 'No'
GROUP BY s.MA
	,s.[Customer - Account Number]