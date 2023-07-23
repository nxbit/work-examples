param(
    # Setting Parameters #
    [string]$montSel = '2021-DEC',
    [string]$rptType = 'Rep'

)

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
<# 050622 - New Chrome Driver Sync Start Area  #>

<# 	NOTE. the final call in this area is to ./GrabChromeDriver.ps1. This file will 
be assumed local to that of the script. If the script is being copied local and then ran, 
you much ensure GrabChromeDriver is also in the same directory. 
 #>

#======================================================================================#
#                       START OF LOADING CHROMEDRIVERS                                 #
#======================================================================================#
cls


#setting ChromePath to Typical Default
$chromePath = "C:\Program Files*\Google\Chrome\Application\chrome.exe";

#setting local Selenium Path
$lSelenium = 'C:\Users\'+$env:UserName+'\Documents\Selenium';
$rChromeDriver = "\\STXFILE01.corp.twcable.com\RTXCareReporting\Report Main\Selenium\Driver";


#Sync-ChromeDriver will Check local Version of Chrome
#and synch that version of chromeDriver to the users Local Selenium Folder

function Sync-ChromeDriver {

    #if ChromePath is Valid, the version variable is set,
    #if ChromePath is Invalid then version variable is set to null
    if(Test-Path $chromePath){
        $ver = [System.Diagnostics.FileVersionInfo]::GetVersionInfo((Resolve-Path $chromePath).ProviderPath).FileVersion;    
        $ver = $ver.Substring(0,3);

    }else{
    
        $ver = $null;
    }
    if(Test-Path $rChromeDriver"\$ver\chromedriver.exe")
    {
       Write-Host -ForegroundColor Black -BackgroundColor White ("Chrome Driver Exists."); 
       Copy-Item -Path $rChromeDriver"\$ver\chromedriver.exe" -Destination $lSelenium"\chromedriver.exe"
    }else{
        Write-Host -ForegroundColor Black -BackgroundColor White ("Syncing $ver ChromeDriver."); 
		
		#Sync the latest logic for grab chrome driver
		Copy-Item -Path "\\stxfile01.corp.twcable.com\rtxcarereporting\Team Member Folders\Kevin\Selenium\GrabChromeDriver.ps1" -Destination "./GrabChromeDriver.ps1"
		#Now execute that newest logic to grab the new driver
        ./GrabChromeDriver.ps1 -neededMajorVer $ver
		
        Copy-Item -Path $rChromeDriver"\$ver\chromedriver.exe" -Destination $lSelenium"\chromedriver.exe"
    }

}



Sync-ChromeDriver
Write-Output "Driver synced"


<# 050622 - New Chrome Driver Sync End Area  #>


#======================================================================================#
#                       END OF LOADING CHROMEDRIVERS                                   #
#======================================================================================#


#=============================================================================#
#                       CORPORTAL PAGE ELEMENT PATHS                          #
#=============================================================================#


$cDate = Get-Date
#Offset to yesterday since data is not expected 'today'#
$cDate = $cDate.AddDays(-1)
#=============================================================================#
#                Modeling Grabbing Fiscal after Sql Case statement            #
#=============================================================================#

#CASE
#     WHEN DATEPART(dd,r.STARTDATE) < 29 THEN DATEADD(d,28-DATEPART(dd,r.STARTDATE),r.STARTDATE)
#     ELSE DATEADD(m,1,DATEADD(d,-1*(DATEPART(dd,r.STARTDATE)-28),r.STARTDATE))
#END
Write-Output $montSel

# Adding Default to Current Fiscal Month #
if($cDate.Day -lt 29){
    $cDate = $cDate.AddDays(28-$cDate.Day)
}else{
    $cDate = $cDate.AddDays(-1*($cDate.Day-28)).AddMonths(1)
}

if($montSel -eq 'NONE'){$montSel = $cDate.toString("yyyy-MMM").toUpper()}

#Ensure the value fed to CP is pmatching format#
$montSel = $montSel.toUpper()

Write-Output $montSel


$CpPath = '\\STXFILE01.corp.twcable.com\RTXCareReporting\Team Member Folders\Kevin\Selenium\'
$SelPath = 'C:\Users\'+$env:UserName+'\Documents\Selenium\'
$CorPortal = "https://corportal.corp.chartercom.com/main/reports/default.aspx?reports=135"
$dlFolder = 'C:\Users\'+$env:UserName+'\Downloads\'
#031022:	Added dedicated subfolder for the PGP effort#
$pgpFolder = 'C:\Users\'+$env:UserName+'\Downloads\CP_Local\'
# Fiscal Dates Object #
$fiscalDatesObj = 'ctl00_ContentPlaceHolder1_pnlReportForm_ctl05_cmbDates_I'
# Report View Object #
$reportViewObj = 'ctl00_ContentPlaceHolder1_pnlReportForm_ctl05_rblReportView_I'
# Report Type Object #
$reportTypeObj = 'ctl00_ContentPlaceHolder1_pnlReportForm_ctl05_rblReportType_I'
# Center Type Object #
$centerTypeObj = 'ctl00_ContentPlaceHolder1_pnlReportForm_ctl05_cklCenterList_I'
# Group Type Object #
$groupTypeObj = 'ctl00_ContentPlaceHolder1_pnlReportForm_ctl05_cklGroupList_I'

# Group List Class#
$groupList = 'dxeListBoxItemRow_Office2010Silver'

$loadingModalID = 'ctl00_ContentPlaceHolder1_pnlReportForm_ctl05_updateProgress'

$processStart = Get-Date

#Write-Output $montSel
#Write-Output $rptType

#=============================================================================#
#                       SELENIUM INITILIZATION AND CONFIG                     #
#=============================================================================#

# Unable to Run Add-Type over a network Path #
# Copying Selenium to Local Documents Folder #

if(Test-Path -Path $SelPath){
    #Test if each file needs to be loaded; WebDriver#
    if(!(Test-Path $SelPath'WebDriver.dll' -PathType Leaf)){
        Copy-Item -Path $CpPath'WebDriver.dll' -Destination $SelPath'WebDriver.dll'
    }
    #Test if each file needs to be loaded; ChromeDriver#
    if(!(Test-Path $SelPath'chromedriver.exe' -PathType Leaf)){
        Copy-Item -Path $CpPath'chromedriver.exe' -Destination $SelPath'chromedriver.exe'
    }
}else{
    # If Folder dosent Exist Create it and Then Copy in the required files #
    New-Item $SelPath -ItemType directory
    Copy-Item -Path $CpPath'WebDriver.dll' -Destination $SelPath'WebDriver.dll'
    Copy-Item -Path $CpPath'chromedriver.exe' -Destination $SelPath'chromedriver.exe'
}


# Adding the Selenium Working Directory Path to PS Shell Path #
if(($env:Path -split ";") -notcontains $SelPath) {
    $env:Path += ";$SelPath"
}

# Load the WebDriver #
Add-Type -Path "$($SelPath)WebDriver.dll"

#Creating the Default Service for which Selenium will Run
$ChromeService = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService()
#Supression Logging for the Service
$ChromeService.EnableVerboseLogging = $false
$ChromeService.SuppressInitialDiagnosticInformation = $true


#Creating Chrome Options and supressing Logging
$chromeOpts = New-Object OpenQA.Selenium.Chrome.ChromeOptions
$chromeOpts.AddArgument("--log-level=3")
$chromeOpts.AddArgument("--disable-gpu")
$chromeOpts.AddArgument("--disable-crash-reporter")
$chromeOpts.AddArgument("--disable-extensions")
$chromeOpts.AddArgument("--disable-in-process-stack-traces")
$chromeOpts.AddArgument("--disable-logging")
$chromeOpts.AddArgument("--disable-dev-shm-usage")
$chromeOpts.AddArgument("--log-level=3")
$chromeOpts.AddArgument("--output=/dev/null")
$chrome = New-Object OpenQA.Selenium.Chrome.ChromeDriver($ChromeService, $chromeOpts)

$ChromeService = $null
$chromeOpts = $null
$SelPath = $null



#=============================================================================#
#                       SELENIUM CHROME NAV AND OPTIONS                       #
#=============================================================================#

#Clear the PS screen before starting the processing #
cls
Write-Output "Opening CorPortal..."

# Navigate to CorPortal #
$chrome.Navigate().GoToUrl($CorPortal)



Write-Output "Confirming cards generated for $montSel ..."
#=============================================================================#
#                       CORPORTAL SCORECARD SUMMARY SELECTIONS                #
#=============================================================================#
# Set Fiscal Month #
Do{
    # Waiting until while the next list populates #
    Start-Sleep -Seconds 1
}
While($chrome.FindElementById($loadingModalID).GetAttribute("aria-hidden") -eq "false") 


#Since the selections on CorPortal trigger loading clickable tables, the value needs to be selected directly and then trigger the page recognizing the 'selection'#
#Another option would be triggering the table, scrolling to the correct row item, then clicking, but is much more work#
$chrome.ExecuteScript("document.getElementById('" + $fiscalDatesObj + "').value = '$montSel';")
$chrome.ExecuteScript("document.getElementById('" + $fiscalDatesObj + "').onchange();")



cls
Write-Output "Confirming cards generated for $montSel ..."
#=============================================================================#
# Set Report View Type #
Do{
    # Waiting until while the next list populates #
    Start-Sleep -Seconds 1
}
While($chrome.FindElementById($loadingModalID).GetAttribute("aria-hidden") -eq "false") 


$chrome.ExecuteScript("document.getElementById('" + $reportViewObj + "').value = 'Scorecard Summary';")
$chrome.FindElementById($reportViewObj).SendKeys([OpenQA.Selenium.Keys]::Tab)


cls
Write-Output "Confirming cards generated for $montSel ..."
#=============================================================================#
# Set Report Type and Tab of to Trigger OnChange Event#
Do{
    # Waiting until while the next list populates #
    Start-Sleep -Seconds 1
}
While($chrome.FindElementById($loadingModalID).GetAttribute("aria-hidden") -eq "false") 

$chrome.ExecuteScript("document.getElementById('" + $reportTypeObj + "').value = '$rptType';")
$chrome.FindElementById($reportTypeObj).SendKeys([OpenQA.Selenium.Keys]::Tab)


cls
Write-Output "Confirming cards generated for $montSel ..."
#=============================================================================#
# Set Center and Tab of to Trigger OnChange Event#
Do{
    # Waiting until while the next list populates #
    Start-Sleep -Seconds 1
}
While($chrome.FindElementById($loadingModalID).GetAttribute("aria-hidden") -eq "false") 

$chrome.ExecuteScript("document.getElementById('" + $centerTypeObj + "').value = 'ALL';")
$chrome.FindElementById($centerTypeObj).SendKeys([OpenQA.Selenium.Keys]::Tab)


cls
Write-Output "Confirming cards generated for $montSel ..."
#=============================================================================#
# Need to Find All td elements that contain the partial ID # 
# This will Grab a list of Groups #
Do{
    # Waiting until while the next list populates #
    Start-Sleep -Seconds 1
}
While($chrome.FindElementById($loadingModalID).GetAttribute("aria-hidden") -eq "false") 

#$groups = $chrome.FindElements([OpenQA.Selenium.By]::Id(("td[id*='ctl00_ContentPlaceHolder1_pnlReportForm_ctl05_cklGroupList_DDD'] > a")))
$groups = $chrome.FindElementsByClassName($groupList)
$specVidList = New-Object Collections.Generic.List[string]


cls
Write-Output "Confirming cards generated for $montSel ..."
#=============================================================================#
#                       CORPORTAL SCORECARD GROUPS LOOP; Non New Hire         #
#=============================================================================#
# Populate List of SPEC VID Groups #
ForEach($ele in $groups)
{
    $eleOuterText = $ele.GetAttribute('outerHTML')  
    if(($ele.GetAttribute('innerText') -like "*VID*") -and ($ele.GetAttribute('innerText') -like "*NH*"))
    {
		$specVidList.Add($ele.GetAttribute('innerText'))
    }
}

#Using the generated listing, check one at a time to see if cards generated#
For($i=0;$i -lt $specVidList.Count; $i++){

    $g = $specVidList[$i].Trim()
	
	cls
	Write-Output "Checking $montSel for $g ..."

    # Set the Group Type #
    $chrome.ExecuteScript("document.getElementById('ctl00_ContentPlaceHolder1_pnlReportForm_ctl05_cklGroupList_I').value = '$g';")
    
    # Send Keys was interating with page's AutoComplete #
    $chrome.FindElementById($groupTypeObj).SendKeys([OpenQA.Selenium.Keys]::Tab)
    
    Do{
        # Waiting until while the next list populates #
        Start-Sleep -Seconds 1
    }
    While($chrome.FindElementById($loadingModalID).GetAttribute("aria-hidden") -eq "false") 

    # Get Scorecard Data #
    $chrome.FindElementById('ctl00_ContentPlaceHolder1_pnlReportForm_ctl05_btnGetScorecards').Click()
    
    
    Do{
        # Waiting until while the next list populates #
        Start-Sleep -Seconds 1
    }
    While($chrome.FindElementById($loadingModalID).GetAttribute("aria-hidden") -eq "false") 


    # If this Ele doesn't po #
    # Checking for No Data Row #
    if($chrome.FindElementsById('ctl00_ContentPlaceHolder1_pnlReportForm_ctl05_pnlScoreCardDrillDown_tbTeamPeerGroup_gvScoreCardDrilldown_DXEmptyRow').Count -eq 0)
    {
       
		Write-Output "Exporting $montSel for $g ..."
        $chrome.ExecuteScript("document.getElementById('ctl00_ContentPlaceHolder1_pnlReportForm_ctl05_pnlScoreCardDrillDown_HTC_mnuScorecardSearch_DXI1i0_Img').click();")
        #Short extra pause to allow the browser to catch up#
        Start-Sleep -Seconds 1
        
    }
}

#=============================================================================#
#                            SELENIUM CLEAN UP                                #
#=============================================================================#
$processEnd = Get-Date
$chrome.Close()
$chrome.Quit()
$CorPortal = $null
$fiscalDatesObj = $null
$reportViewObj = $null
$reportTypeObj = $null
$centerTypeObj = $null
$groupTypeObj = $null
$loadingModalID = $null
$chrome.Dispose()

#=============================================================================#
#                      TRIM FIRST ROW OFF SC SUMMARY FILES                    #
#=============================================================================#
cls
Write-Output "Cleaning $montSel downloads between:"
Write-Output $processStart
Write-Output $processEnd

<# Using Excel.Appliction Object, Initilizing Objects and Path's used #>
$ExcelObject=New-Object -ComObject excel.application
$ExcelObject.visible=$false
<# Grabing Files with ScoreCard Summary created between the job process times #>
$ExcelFiles = Get-ChildItem $dlFolder -Filter *Scorecard*Summary*.xlsx | Where-Object {($_.CreationTime -ge $processStart) -and ($_.CreationTime -le $processEnd) }

#031022: Updated for the PGP Analysis to a dedicated subfolder#
$movPath = $pgpFolder+'processed'


if(!(Test-Path -Path $movPath))
#if(-not (Test-Path -Path $movPath))#
{
    New-Item $movPath -ItemType directory 
}

<# Open Each ExcelFile in the Folder and Copy its Data to the Combined Workbook #>
foreach($ExcelFile in $ExcelFiles){
        $Everyexcel=$ExcelObject.Workbooks.Open($ExcelFile.FullName)
        $Everyexcel.sheets.Item(1).Cells.Item(1,1).EntireRow.Delete()
        $Everyexcel.Save()
        $Everyexcel.Close()
        
       # Move-Item -Path $ExcelFile.FullName -Destination $movPath -Force


}

$ExcelObject.Quit() 
$ExcelFiles = $null
$ExcelObject = $null
$movPath = $null

Write-Output "Finished $montSel"







