param(
    # Setting Parameters Accepting the BI Sub and FileName#
    [string] $BISub = "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=E8D74189C54A0A95368708BCA0252894&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1",
    [string] $FileName = 'SELF-INSTALL' , 
    [string] $DetailsFileName = 'SELF-INSTALL_REPAIR',
    [string] $saveFolderPath =  'C:\Users\'+[Environment]::UserName+'\Downloads\'

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



#Manually Kicking off Garbage Collection before Script#
[system.gc]::Collect()


<# 
        SelPath - Stores the Location to Selenium on the Users Local PC
        dlFolder - Stores the Location the Downloaded Files are Expected to appear
        currentTime - Stores the time this script starts, and is used to time block check
            for any downloaded files
#>
$SelPath = 'C:\Users\'+[Environment]::UserName+'\Documents\Selenium\'
# If the SaveFolder Path does not exist, create it #
if(-not (Test-Path -Path $saveFolderPath)){
    New-Item -ItemType "directory" -Path  $saveFolderPath
}
$dlFolder = 'C:\Users\'+[Environment]::UserName+'\Downloads\'
$currentTime = Get-Date;


<# Adding the Selenium Working Directory Path to PS Shell Path #>
if(($env:Path -split ";") -notcontains $SelPath) {
    $env:Path += ";$SelPath"
}

Write-Host 'Loading Selenium Drivers' -ForegroundColor Yellow
# Load the Selenium Chrome WebDriver #
Add-Type -Path "$($SelPath)\WebDriver.dll"
$chromeOpts = New-Object OpenQA.Selenium.Chrome.ChromeOptions

$ChromeService = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService()
$ChromeService.EnableVerboseLogging = $false
$ChromeService.SuppressInitialDiagnosticInformation = $true




<# Creating Chrome Options and Initilizing the Chrome Object with Options #>
$chromeOpts.AddUserProfilePreference("download.default_directory",$saveFolderPath)
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



<# ====================================================================
    1) Navigate to BI Sub Link 
   ====================================================================#>
cls
Write-Host "Running BI Script to Produce File: "$FileName -ForegroundColor Green

Write-Host "Navigating the Chrome Window to the BI Sub" -ForegroundColor Yellow
$chrome.Navigate().GoToUrl($BISub)

#the Navigate will wait until onload has completed. for times when this DOESNT happen the below Wait will cover that time span.
Write-Host "Pausing to ensure page loads."
Start-Sleep -Seconds 5


<# ====================================================================
        1a) Waiting for the Export Button to appear which will tell us roughly when the Report is available to download
 ======================================================================#>

Write-Host "Waiting for BI Subscription to Load on the Report Home Tab" -BackgroundColor Red
do{
Start-Sleep -Seconds 1
$emptyGrid = $chrome.FindElementsByClassName('empty-view-grid').Count
}
while(($chrome.FindElementsById('tbExport').Count -eq 0))

if($emptyGrid -ige 1){ 
Write-Output "Clean Up"
$SelPath = $null
$BISub = $null
$chrome.Quit()
$chrome.Dispose()
exit 0 }



<# ====================================================================
    2) Click the Export
=======================================================================#>
Write-Output "Clicking the Export Button"
$chrome.ExecuteScript("document.getElementById('tbExport').click();")




<# ====================================================================
    3) Swtich to the Export Window to the Export Window 
=======================================================================#>
Write-Output "Switching to Export Window"
$null = $chrome.SwitchTo().Window($chrome.WindowHandles[1])


<# ====================================================================
        3a) Waiting until the Export as Plain Text Button Appears 
=======================================================================#>
Write-Output "Waiting for Export as Plain Text Button"
do{
Start-Sleep -Seconds 1
}while($chrome.FindElementsByid('exportFormatGrids_excelPlaintextIServer').Count -eq 0)

<# ====================================================================
        3b) Uncheck all Options 
=======================================================================#>
Write-Output "Unchecking All Options"
$chrome.ExecuteScript("var checkboxes = new Array(); 
  checkboxes = document.getElementsByTagName('input');
 
  for (var i=0; i<checkboxes.length; i++)  {
    if (checkboxes[i].type == 'checkbox')   {
      checkboxes[i].checked = false;
    }
  }")

<#==================================================================== 
        3c) Click the Plain Text Button 
=======================================================================#>
Write-Output "Checking Excel as Plain Text"
$chrome.FindElementByid('exportFormatGrids_excelPlaintextIServer').click()




<# ====================================================================
        3ca) Wait for the Export Button to appear 
=======================================================================#>
Write-Output "Waiting for the Export Button to Appear"
do{
Start-Sleep -Seconds 1
}while($chrome.FindElementsByid('3131').Count -eq 0)

<# ====================================================================
    4) Click the Export Button to generate the file 
=======================================================================#>
Write-Output "Clicking Export Button "
$chrome.FindElementById('3131').click()


<# ====================================================================
        4a) Wait for File to Export 
=======================================================================#>
Write-Output "Waiting for File to Appear"
$DldFile = Get-ChildItem $saveFolderPath -Recurse | Where-Object {$_.Mode -notmatch "d"} | Where-Object {$_.LastWriteTime -gt $currentTime} | Where-Object {$_.Extension -eq ".xlsx"}
do{
Start-Sleep -Seconds 3
$DldFile = Get-ChildItem $saveFolderPath -Recurse | Where-Object {$_.Mode -notmatch "d"} | Where-Object {$_.LastWriteTime -gt $currentTime} | Where-Object {$_.Extension -eq ".xlsx"}
Write-Output "Waiting for export to complete" #$chrome.FindElementById('done_eb_ExportStyle').GetAttribute('visibility')#
}while($DldFile.Length -eq 0)


<# ====================================================================
    5) Rename the Downloaded File 
=======================================================================#>
Write-Output "Renaming the downloaded File"
Rename-Item -Path $DldFile.FullName -NewName "$FileName.xlsx"


<# ====================================================================
    6) Close the Export Window and Pull the Call Details 
=======================================================================#>
$chrome.close();


<# ====================================================================
    7) Swtich Back to the BI Pull Tab
=======================================================================#>
Write-Output "Switching Back to BI Report"
$null = $chrome.SwitchTo().Window($chrome.WindowHandles[1])

<#====================================================================
    8) Click the Call Details Button
=======================================================================#>
Write-Output "Clicking for Details"
$chrome.ExecuteScript("document.querySelector('[o=""0""]').firstElementChild.click()")

<# ====================================================================
    9) Switch to the Call Details Window
=======================================================================#>
Write-Output "Swtiching to Call Details Window"
$null = $chrome.SwitchTo().Window($chrome.WindowHandles[1])

<# ====================================================================
        9a) Waiting for the Export Button to appear which will tell us roughly when the Report is available to download
 ======================================================================#>
 Write-Output "Waiting for Call Details to Load"
do{
Start-Sleep -Seconds 1
}while(($chrome.FindElementsById('tbExport').Count -eq 0))

<#=====================================================================
        Adding a Pause to allow for second tab to open
=======================================================================#>

Write-Output "Waiting a Few before Clicking Export"
Start-Sleep -Seconds 5


<# ====================================================================
    10) Click the Export
=======================================================================#>
Write-Output "Clicking the Export Button"
$chrome.ExecuteScript("document.getElementById('tbExport').click();")


<# ====================================================================
    11) Swtich to the Export Window to the Export Window 
=======================================================================#>



Write-Output "Waiting for Call Details Export Tab to Open"
do{
Start-Sleep -Seconds 1
}while(($chrome.WindowHandles.Count -le 2))




Write-Output "Switching to the Call Details Export Window"
$null = $chrome.SwitchTo().Window($chrome.WindowHandles[2])


<# ====================================================================
        11a) Waiting until the Export as Plain Text Button Appears 
=======================================================================#>
Write-Output "Waiting for Excel As Plain Text button to Appear"
do{
Start-Sleep -Seconds 1
}while($chrome.FindElementsByid('exportFormatGrids_excelPlaintextIServer').Count -eq 0)

<# ====================================================================
        11b) Uncheck all Options 
=======================================================================#>
Write-Output "Un Checking all Options"
$chrome.ExecuteScript("var checkboxes = new Array(); 
  checkboxes = document.getElementsByTagName('input');
 
  for (var i=0; i<checkboxes.length; i++)  {
    if (checkboxes[i].type == 'checkbox')   {
      checkboxes[i].checked = false;
    }
  }")

<#==================================================================== 
        11c) Click the Plain Text Button 
=======================================================================#>
Write-Output "Selecting Excel with Plain Text"
$chrome.FindElementByid('exportFormatGrids_excelPlaintextIServer').click()




<# ====================================================================
        11ca) Wait for the Export Button to appear 
=======================================================================#>
Write-Output "Waiting for the Export Button to Appear"
do{
Start-Sleep -Seconds 1
}while($chrome.FindElementsByid('3131').Count -eq 0)
#Restting the Time For the next Import this prevents overwriting the last downloaded file#
$currentTime = Get-Date;
<# ====================================================================
    12) Click the Export Button to generate the file 
=======================================================================#>
Write-Output "Clicking the Export Button"
$chrome.FindElementById('3131').click()


<# ====================================================================
        12a) Wait for File to Export 
=======================================================================#>
Write-Output "Waiting for the Call Details file to Appear"
$DldFile = Get-ChildItem $saveFolderPath -Recurse | Where-Object {$_.Mode -notmatch "d"} | Where-Object {$_.LastWriteTime -gt $currentTime} | Where-Object {$_.Extension -eq ".xlsx"}
do{
Start-Sleep -Seconds 3
$DldFile = Get-ChildItem $saveFolderPath -Recurse | Where-Object {$_.Mode -notmatch "d"} | Where-Object {$_.LastWriteTime -gt $currentTime} | Where-Object {$_.Extension -eq ".xlsx"}
Write-Output "Waiting for export to complete" #$chrome.FindElementById('done_eb_ExportStyle').GetAttribute('visibility')#
}while($DldFile.Length -eq 0)



<# ====================================================================
    13) Rename the Downloaded File 
=======================================================================#>
Write-Output "Rename the Call Details File"
Rename-Item -Path $DldFile.FullName -NewName $DetailsFileName".xlsx"


<# ====================================================================
    14) Close the Export Window and Pull the Call Details 
=======================================================================#>
$chrome.close();





Write-Output "Clean Up"
$SelPath = $null
$BISub = $null
$chrome.Quit()
$chrome.Dispose()
