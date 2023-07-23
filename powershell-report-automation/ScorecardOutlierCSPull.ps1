param(
    # Setting Parameters #
    [string]$montSel = '2021-AUG',
    [string]$rptType = 'Rep'

)

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
    $cDate = $cDate.AddMonths(1,$cDate.AddDays(-1*($cDate.Day-28)))
}

if($montSel -eq 'NONE'){$montSel = $cDate.toString("yyyy-MMM").toUpper()}

#Ensure the value fed to CP is pmatching format#
$montSel = $montSel.toUpper()

Write-Output $montSel


$CpPath = '\\STXFILE01.corp.twcable.com\RTXCareReporting\Team Member Folders\Kevin\Selenium\'
$SelPath = 'C:\Users\'+$env:UserName+'\Documents\Selenium\'
$CorPortal = "https://corportal.corp.chartercom.com/main/reports/default.aspx?reports=135"
$dlFolder = 'C:\Users\'+$env:UserName+'\Downloads\'
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
$chrome = New-Object OpenQA.Selenium.Chrome.ChromeDriver


#=============================================================================#
#                       SELENIUM CHROME NAV AND OPTIONS                       #
#=============================================================================#

#Clear the PS screen before starting the processing #
#cls#

# Navigate to CorPortal #
$chrome.Navigate().GoToUrl($CorPortal)



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



#=============================================================================#
# Set Report View Type #
Do{
    # Waiting until while the next list populates #
    Start-Sleep -Seconds 1
}
While($chrome.FindElementById($loadingModalID).GetAttribute("aria-hidden") -eq "false") 


$chrome.ExecuteScript("document.getElementById('" + $reportViewObj + "').value = 'Scorecard Summary';")
$chrome.FindElementById($reportViewObj).SendKeys([OpenQA.Selenium.Keys]::Tab)


#=============================================================================#
# Set Report Type and Tab of to Trigger OnChange Event#
Do{
    # Waiting until while the next list populates #
    Start-Sleep -Seconds 1
}
While($chrome.FindElementById($loadingModalID).GetAttribute("aria-hidden") -eq "false") 

$chrome.ExecuteScript("document.getElementById('" + $reportTypeObj + "').value = '$rptType';")
$chrome.FindElementById($reportTypeObj).SendKeys([OpenQA.Selenium.Keys]::Tab)


#=============================================================================#
# Set Center and Tab of to Trigger OnChange Event#
Do{
    # Waiting until while the next list populates #
    Start-Sleep -Seconds 1
}
While($chrome.FindElementById($loadingModalID).GetAttribute("aria-hidden") -eq "false") 

$chrome.ExecuteScript("document.getElementById('" + $centerTypeObj + "').value = 'ALL';")
$chrome.FindElementById($centerTypeObj).SendKeys([OpenQA.Selenium.Keys]::Tab)


#=============================================================================#
# Need to Find All td elements that contain the partial ID # 
# This will Grab a list of Groups #
Do{
    # Waiting until while the next list populates #
    Start-Sleep -Seconds 1
}
While($chrome.FindElementById($loadingModalID).GetAttribute("aria-hidden") -eq "false") 

#$groups = $chrome.FindElements([OpenQA.Selenium.By]::Id(("td[id*='ctl00_ContentPlaceHolder1_pnlReportForm_ctl05_cklGroupList_DDD'] > a")))
#$groups = $chrome.FindElementsByClassName($groupList)



$groups = @('SPEC CSG VID SIK MIX', 'SPEC CSG VID SIK MIX OVN', 'SPEC ICM VID SIK MIX', 'SPEC ICM VID SIK MIX OVN')
$specVidList = New-Object Collections.Generic.List[string]


#=============================================================================#
#                       CORPORTAL SCORECARD GROUPS LOOP                       #
#=============================================================================#
# Populate List of SPEC VID Groups #
ForEach($ele in $groups)
{
    
        $specVidList.Add($ele)
    
}

#Using the generated listing, check one at a time to see if cards generated#
For($i=0;$i -lt $specVidList.Count; $i++){

    $g = $specVidList[$i].Trim()

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

Write-Output $processStart
Write-Output $processEnd

<# Using Excel.Appliction Object, Initilizing Objects and Path's used #>
$ExcelObject=New-Object -ComObject excel.application
$ExcelObject.visible=$false
<# Grabing Files with ScoreCard Summary created between the job process times #>
$ExcelFiles = Get-ChildItem $dlFolder -Filter *Scorecard*Summary*.xlsx | Where-Object {($_.CreationTime -ge $processStart) -and ($_.CreationTime -le $processEnd) }


$movPath = $SelPath+'processed'


if(-not (Test-Path -Path $movPath))
{
    New-Item $movPath -ItemType directory 
}

<# Open Each ExcelFile in the Folder and Copy its Data to the Combined Workbook #>
foreach($ExcelFile in $ExcelFiles){
        $Everyexcel=$ExcelObject.Workbooks.Open($ExcelFile.FullName)
        $Everyexcel.sheets.Item(1).Cells.Item(1,1).EntireRow.Delete()
        $Everyexcel.Save()
        $Everyexcel.Close()
        
        Move-Item -Path $ExcelFile.FullName -Destination $movPath


}

$ExcelObject.Quit() 
$ExcelFiles = $null
$ExcelObject = $null
$movPath = $null








