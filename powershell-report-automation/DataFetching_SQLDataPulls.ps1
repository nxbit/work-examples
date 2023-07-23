
#Var holding SQL Query and Db Info
$SQLServer = "VM0PWOWMMSD0001"
$SQLDBName = "master"
$delim = ","
$SQLQuery = "SET NOCOUNT ON;
;


DECLARE @StartDate datetime;
DECLARE @EndDate datetime;
SET @StartDate = DATEADD(D,-43,GetDate());
SET @EndDate = DATEADD(D,-1,GetDate());



With EMP1 as 
                (
                                Select 
                                                Cast(Dateadd(dd,A.NomDate,'1899-12-30') as Date) NomDate,
                                                A.EMP_SK,
                                                A.EmpID,
                                                B.[LegacyORG] [ORG],
                                                B.[LOBDesc] [LOB],
                                                B.Biller,
                                                B.StaffGroup as Staff_Group,
                                                B.Location,
                                                ROW_NUMBER() OVER(Partition by A.NomDate,A.EMP_SK,B.STAFFGROUP Order by A.NomDate) RN
                                From ASPECT.WFM.DAILY_AGENTS A with (nolock)
                                Inner Join DimensionalMapping.DIM.Staff_Group_to_LOB B with (nolock) ON
                                                A.STF_GRP_SK = B.STF_GRP_SK and Cast(Dateadd(dd,A.NomDate,'1899-12-30') as Date) between B.StartDate and B.EndDate 
                                Where A.NomDate between DATEDIFF(dd,'1899-12-30',@StartDate) and DATEDIFF(dd,'1899-12-30',@EndDate)
                                group by              
                                                A.NomDate,
                                                A.EMP_SK,
                                                A.EmpID,
                                                B.[LegacyORG] ,
                                                B.[LOBDesc] ,
                                                B.Biller,
                                                B.StaffGroup ,
                                                B.Location
                )

,EMP as 
                (
                                Select 
                                                NomDate,
                                                EMP_SK,
                                                EmpId,
                                                [ORG],
                                                [LOB],
                                                Biller,
                                                Staff_Group,
                                                Location
                                From EMP1
                                Where RN = 1
                )
, VID as
				(
					SELECT EMP_SK
						,CASE
							WHEN SUM(CASE 
									/*if Video or CSI count as a Video date;*/
									WHEN e.LOB LIKE '%VID%' THEN 1
									WHEN e.LOB LIKE '%CSI%' THEN 1
									ELSE 0
								END) > 0 THEN 1
							ELSE 0
						END VidAgent
					FROM EMP e
					GROUP BY EMP_SK

				)

,DT as 
                (
                                Select 
                                                [StdDate] as [Date],
                                                [FiscalMonth]
                                From DimensionalMapping.DIM.Date_Table with (nolock)
                                Where [StdDate] Between @StartDate and @EndDate
                )

Select 
                E.EmpID,
                E.LOB [LOB],
                convert(varchar,[StdDate],101) [StdDate],
                G.Bucket [Category],
                G.InOut [InOut],
                SUM(cast(A.[MI] as Decimal(16,8)) /60) [Hours]

From Aspect.wfm.Daily_Superstate_Hours A With(nolock)
Inner Join DT on
                A.StdDate = DT.Date
INNER join EMP E On
                A.EMP_SK = E.EMP_SK and 
                A.StdDate = E.NomDate
INNER JOIN VID v ON e.EMP_SK=v.EMP_SK
Inner join [DimensionalMapping].[DIM].[Enterprise_Shrinkage_Buckets] G With(nolock) ON
                A.SPRSTATE_SK = G.SPRSTATE_SK
Left outer join DimensionalMapping.[DIM].[Abs_Trending_Codes] F With(nolock) ON 
                G.CODE = F.[code]
/*072220:	Added check for staff that had any video dates during period;*/
Where v.VidAgent=1 AND

                A.StdDate           Between  @StartDate and @EndDate 
AND
(
                        G.[InOut] in ('Out of Center', 'Scheduled Hours')       
						--or buckets.[CODE] = 'STF-LOGIN GRACE PERIOD'  (Data moved from segment to Aux 8)
						/*021120:	Updated based on feedback from Traffic;*/
						or G.[CODE] like '%sign%out%'

)

Group by 
                E.EmpID,
                E.LOB,
                convert(varchar,[StdDate],101),
                G.Bucket,
                G.InOut"

$ConnStringBuilder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder
$ConnStringBuilder['Data Source']=$SQLServer
$ConnStringBuilder['Integrated Security']=$true
$ConnStringBuilder['Initial Catalog']=$SQLDBName




#Building Connection Object
$SQLConnection = New-Object System.Data.SqlClient.SqlConnection
#Setting SQL Connection String
$SQLConnection.ConnectionString = $ConnStringBuilder.ConnectionString
#Building SQLCommand Object
$SQLCommand = New-Object System.Data.SqlClient.SqlCommand
#Set the CommandText to the Query Object from Above
$SQLCommand.CommandText = $SQLQuery
#Set the Command Connection to the one from Above
$SQLCommand.Connection = $SQLConnection
#Build the SQLAdapter Object
$SQLAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
#Set the SQLAdapter's Command to the one created above
$SQLAdapter.SelectCommand = $SQLCommand
#Build the Dataset for the return
$SelectReturn = New-OBject System.Data.DataSet
#Fill the Return with the SQL Query Results
$SQLAdapter.Fill($SelectReturn)

#Pipe the return to export-csv
$SelectReturn.Tables[0] | export-csv -Delimiter $delim -Path "C:\Users\P2147086\Desktop\OutliersRpt\DataPulls\eWFM Data.csv" -NoTypeInformation
Copy-Item -Path "C:\Users\P2147086\Desktop\OutliersRpt\DataPulls\eWFM Data.csv" -Destination "\\STXFILE01\RTXCareReporting\Team Member Folders\Kevin\Template_Documents\OutliersRpt\DataPulls\eWFM Data.csv"
Remove-Variable SelectReturn



$SQLQuery = "USE [MiningSwap];

SELECT 
	jc.TITLE
	,[NETIQWORKERID]
	
FROM
	[MiningSwap].[dbo].[PROD_WORKERS] as pw with (nolock)
LEFT JOIN [MiningSwap].[dbo].[PROD_JOB_CODES] as jc with(nolock) on pw.JOBCODEID = jc.JOBCODEID
WHERE [TERMINATEDDATE] IS NULL AND 
	(jc.TITLE LIKE '%Rep%Video%' OR 
	 jc.TITLE = 'Outsourcer - Resi Video Repair Agent' OR 
	 jc.TITLE = 'Outsourcer_Repair Video') AND 
	 
	 NETIQWORKERID IS NOT NULL AND 

	 (jc.TITLE NOT LIKE '%Sup%' OR
	  jc.TITLE NOT LIKE '%Mgr%' OR
	  jc.TITLE NOT LIKE '%Lead%' OR
	  jc.TITLE NOT LIKE '%Dir%')"



#Set Connection now to CorPortal for Call Tracker Data
$SQLServer = "CTXCCOINT02"
#Set the Connection String Builder to new Server
$ConnStringBuilder['Data Source']=$SQLServer
#Setting SQL Connection String
$SQLConnection.ConnectionString = $ConnStringBuilder.ConnectionString
#Set the CommandText to the Query Object from Above
$SQLCommand.CommandText = $SQLQuery
#Set the Command Connection to the one from Above
$SQLCommand.Connection = $SQLConnection
#Set the SQLAdapter's Command to the one created above
$SQLAdapter.SelectCommand = $SQLCommand
#Build the Dataset for the return
$SelectReturn = New-OBject System.Data.DataSet
#Fill the Return with the SQL Query Results
$SQLAdapter.Fill($SelectReturn)
#Pipe the return to export-csv
$SelectReturn.Tables[0] | export-csv -Delimiter $delim -Path "C:\Users\P2147086\Desktop\OutliersRpt\DataPulls\ActiveRoster.csv" -NoTypeInformation

Copy-Item -Path "C:\Users\P2147086\Desktop\OutliersRpt\DataPulls\ActiveRoster.csv" -Destination "\\STXFILE01\RTXCareReporting\Team Member Folders\Kevin\Template_Documents\OutliersRpt\DataPulls\ActiveRoster.csv"

#TheCleanup
Remove-Variable SQLServer
Remove-Variable SQLDBName
Remove-Variable delim
Remove-Variable SQLQuery
Remove-Variable ConnStringBuilder
Remove-Variable SQLConnection
Remove-Variable SQLCommand
Remove-Variable SQLAdapter
Remove-Variable SelectReturn




