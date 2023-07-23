<#==================================================================
                     RANKING DATA PULLS
                     
            Script needs to run in Powershell ISE x86

            Why: Uses Microsoft.ACE.OLEDB.12.0 which is
            only avialable in x86 (unless you have a 64
            bit ACE driver. Just adjust the Provider line below    

==================================================================#>

function runQuery {

    Param(
        [Parameter(Mandatory=$true)][string]$query
    )
    Process{
        $sqlConn = New-Object System.Data.SqlClient.SqlConnection


        #SQL Connection String
        $connSring += 'server=VM0DWOWMMSD0001.CORP.CHARTERCOM.COM;'
        $connSring += 'database=GVPOperations;Network=DBMSSOCN;'
        $connSring += 'integrated security=SSPI;';
        $connSring += ' persist security info=false;'
        $connSring += 'Trusted_Connection=True;'
        $connSring += 'Timeout=600;';
        $sqlConn.ConnectionString = $connSring

        Write-Output "Building Connection"
        $sqlCmd = New-Object System.Data.SqlClient.SqlCommand
        $sqlCmd.Connection = $sqlConn
        $sqlCmd.CommandTimeout = 600
        $sqlCmd.CommandText = $query

        try{
            Write-Output "Connecting to SQL Server"
            $sqlConn.Open()
            Write-Output "Execute Query"
            try{
                $sqlCmd.ExecuteNonQuery()
                }catch{
                    Write-Output "Execute Query Failed"
                    Write-Output $_
                }
            $sqlConn.Close()
            Write-Output "Clean Up"
            $sqlCmd.Dispose()
            $sqlConn.Dispose()
            $sqlCmd.Dispose()

        }catch{

            $sqlCmd.Dispose()
            $sqlConn.Dispose()

        }

    }

}

Function pause ($message)
{
    # If in IE use WinForms
    if ($psISE)
    {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show("$message")
    }
    else
    {
        Write-Host "$message" -ForegroundColor Yellow
        $x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}



function Upload-xlData {
    param(
        [string]$fileName,
        [string]$filePath,
        [string]$tblName,
        [string]$sheetName
    )


    #Excel Data Connection String
    $excelConnection += "Provider=Microsoft.ACE.OLEDB.12.0;"
    $excelConnection += "Data Source=$filePath$fileName.xlsx;"
    $excelConnection += 'Extended Properties="Excel 12.0 Xml;'
    $excelConnection += "HDR=YES;"
    $excelConnection += 'IMEX=1;"'
    
    
    #SQL Connection String
    $connSring += 'server=VM0DWOWMMSD0001.CORP.CHARTERCOM.COM;'
    $connSring += 'database=GVPOperations;Network=DBMSSOCN;'
    $connSring += 'integrated security=SSPI;';
    $connSring += ' persist security info=false;'
    $connSring += 'Trusted_Connection=True;'
    $connSring += 'Timeout=600;';

    
    #excelConnection no longer needed after connection is created#
    #$excelConnection = $null

    Write-Output "Connecting to Excel File"
    try{
            #Creating Connection to Excel Data#
            $conn = New-Object System.Data.OleDb.OleDbConnection($excelConnection)
            $conn.Open()
    
            #Building the query to pull data from passed sheetname#
            $cmd = $conn.CreateCommand()
            $cmd.CommandText = 'select * from ['+$sheetName+'$]'
    
            #Read Data into Reader Object#
            Write-Output "Reading Data From File"
            $rdr = $cmd.ExecuteReader()
    
            try{
                #Create a Bulk Copy Object and load the Reader Results#
                Write-Output "Bulk Loading to "$tblName
                $sqlbc = New-Object System.Data.SqlClient.SqlBulkCopy($connSring, [System.Data.SqlClient.SqlBulkCopyOptions]::TableLock)
                #connSring is no longer needed after connection is made#
                #$connSring = $null
                #Setting Destination Settings#
                $sqlbc.DestinationTableName = $tblName
                $sqlbc.BulkCopyTimeout = 600
                #Writing To Server#
                $sqlbc.WriteToServer($rdr)
                Write-Output "Wrapping Up"
                $rdr.Close()
                $conn.Close()
    
                #CleanUP#
                $conn.Dispose()
                $cmd.Dispose()
                $rdr.Dispose()
                $sqlbc.Dispose()
            }catch{
                Write-Output "Connection to SQL Server Failed"
                Write-Output $_
            }
        }catch{
            Write-Output "Connection to Excel File Failed"
            Write-Output $_
        }

}


cls

$SelPath = 'C:\Users\'+$env:UserName+'\Documents\Selenium\'

$CpPath = '\\STXFILE01.corp.twcable.com\RTXCareReporting\Team Member Folders\Kevin\Selenium\'


if(Test-Path -Path $SelPath){
    #Test if each file needs to be loaded; WebDriver#
    #if(!(Test-Path $SelPath'BIDownloader.ps1' -PathType Leaf)){
        Copy-Item -Path $CpPath'BIDownloader.ps1' -Destination $SelPath'BIDownloader.ps1'
    #}
}else{
    # If Folder dosent Exist Create it and Then Copy in the required files #
    New-Item $SelPath -ItemType directory
    Copy-Item -Path $CpPath'BIDownloader.ps1' -Destination $SelPath'BIDownloader.ps1'
}


<#=====================================================================

        
            DOWNLOADING AND STAGING DOWNLOADED FILES


=======================================================================#>
cd $SelPath


<# 
R_Data 45-Days https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=1BAE826AAF4329F832791286D18134C5&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1
R_Data Fiscal Mth https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=ED4223150540DC9DC74BE39BF360C7BC&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1
R_Data 40-Days https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=35C6D7341A47D178D5CC738351FF7D89&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1
101321 - Updating BI Sub Pulls to a Rolling 40 Day pull
#>
cls
.\BIDownloader.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=35C6D7341A47D178D5CC738351FF7D89&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "R_Data" -saveFolderPath "C:\Users\$env:UserName\Downloads\"
Upload-xlData -fileName "R_Data" -filePath "C:\Users\$env:UserName\Downloads\" -tblName "VID.R_Data" -sheetName "Labor Insights" 

<#
R_IQDenom_tmp 45-Days https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=DBC2556611EB90AFBB6C0080EF0540E2&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1
R_IQDenom_tmp Fiscal Mth https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=3D0313F88A4C7C976C7C70B0E902B618&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1
R_IQDenom_tmp 40-Days https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=CE5A5F6DF248DD67246BC9A4E5064F3E&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1
101321 - Updating BI Sub Pulls too a Rolling 40 Day pull
#>
cls
.\BIDownloader.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=CE5A5F6DF248DD67246BC9A4E5064F3E&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "R_IQDenom_tmp" -saveFolderPath "C:\Users\$env:UserName\Downloads\"
Upload-xlData -fileName "R_IQDenom_tmp" -filePath "C:\Users\$env:UserName\Downloads\" -tblName "VID.R_IQDenom_tmp" -sheetName "Call Insights"

<#
R_IQNum_tmp 45-Day https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=3928FAB011EB90B1BB6C0080EF1560E2&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1
R_IQNum_tmp Fiscal Mth https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=857519D7254A6152E8A07F943753E2B1&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1
R_IQNum_tmp 40-Day https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=9434374B9E46DABAAE834C9AB1C39FAD&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1
101321 - Updating BI Sub Pulls too a Rolling 40 Day pull
#>
cls
.\BIDownloader.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=9434374B9E46DABAAE834C9AB1C39FAD&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "R_IQNum_tmp" -saveFolderPath "C:\Users\$env:UserName\Downloads\"
Upload-xlData -fileName "R_IQNum_tmp" -filePath "C:\Users\$env:UserName\Downloads\" -tblName "VID.R_IQNum_tmp" -sheetName "Call Insights"


 
 pause("Press Enter, and continue From the ProcessDocument");
 


 <# SMO not yet avail. Maybe on New Box? Leaving Commeted Out for now.
 
 [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null

 $srv = New-Object Microsoft.SqlServer.SMO.Server('CTXCCOINT02')
 $job = $srv.jobserver.jobs['$R_Ranking']

 if($job)
 {
    $job.Start()
 }else{}
  
$srv = $null
$job = $null

#>


$SelPath = $null
$CpPath = $null

