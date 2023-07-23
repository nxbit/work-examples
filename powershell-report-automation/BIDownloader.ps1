param(
    # Setting Parameters Accepting the BI Sub and FileName#
    [string] $BISub = "",
    [string] $FileName = '' , 
    [string] $saveFolderPath =  'C:\Users\'+[Environment]::UserName+'\Downloads\'

)
#if the passed save dir doesnt exist create it
if(-not (Test-Path -Path $saveFolderPath)){
    New-Item -ItemType "directory" -Path  $saveFolderPath
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


# Selenium Path and Download Folder Path
# Creating Time Stamp for Download file time Blocking
$SelPath = 'C:\Users\'+[Environment]::UserName+'\Documents\Selenium\'
$currentTime = Get-Date;

# If the SaveFolder Path does not exist, create it #
if(-not (Test-Path -Path $saveFolderPath)){
    New-Item -ItemType "directory" -Path  $saveFolderPath
}

# Adding the Selenium Working Directory Path to PS Shell Path #
if(($env:Path -split ";") -notcontains $SelPath) {
    $env:Path += ";$SelPath"
}

Write-Host 'Loading Selenium Drivers' -ForegroundColor Yellow
# Load the WebDriver #
Add-Type -Path "$($SelPath)\WebDriver.dll"


#Creating the Default Service for which Selenium will Run
$ChromeService = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService()
#Supression Logging for the Service
$ChromeService.EnableVerboseLogging = $false
$ChromeService.SuppressInitialDiagnosticInformation = $true


#Creating Chrome Options and supressing Logging
$chromeOpts = New-Object OpenQA.Selenium.Chrome.ChromeOptions
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

$ChromeService = $null
$chromeOpts = $null
$SelPath = $null


# Navigate to BI Sub Link #
cls
Write-Host "Running BI Script to Produce File: "$FileName -ForegroundColor Green

Write-Host "Navigating the Chrome Window to the BI Sub" -ForegroundColor Yellow
$chrome.Navigate().GoToUrl($BISub)



# Waiting Till Export Button appears #
Write-Host "Waiting for BI Subscription to Load on the Report Home Tab" -BackgroundColor Red
do{
Start-Sleep -Seconds 1
$loopInt = $loopInt + 1;
$emptyGrid = $chrome.FindElementsByClassName('empty-view-grid').Count
}while(($chrome.FindElementsById('tbExport').Count -eq 0))

# Adding Clause if grid returned empty to exit the Script #
if($emptyGrid -ige 1){ 
Write-Host "Clean Up"
$SelPath = $null
$BISub = $null
$chrome.Quit()
$chrome.Dispose()
exit 0 }


Write-Host "Clicking the export Button"
# Click the Export Button by Fireing the OnClick Event #
$chrome.ExecuteScript("document.getElementById('tbExport').click();")


Write-Host "Switiching to Export Window"
# Swtich to the Export Window to the Export Window #
$null = $chrome.SwitchTo().Window($chrome.WindowHandles[1])


# Wait until the Export as Plain Text Button Appears #
Write-Host "Waiting for the Export as Plain Text Button"
do{
Start-Sleep -Seconds 1
}while($chrome.FindElementsByid('exportFormatGrids_excelPlaintextIServer').Count -eq 0)


# Uncheck all Options #
Write-Host "Un Checking All Options"
$chrome.ExecuteScript("var checkboxes = new Array(); 
  checkboxes = document.getElementsByTagName('input');
 
  for (var i=0; i<checkboxes.length; i++)  {
    if (checkboxes[i].type == 'checkbox')   {
      checkboxes[i].checked = false;
    }
  }")



Write-Host "Select Export as Plain Text"
# Click the Plain Text Button #
$chrome.FindElementByid('exportFormatGrids_excelPlaintextIServer').click()


# Wait for the Export Button to appear #
Write-Host "Waiting for Export Button"
do{
Start-Sleep -Seconds 1
}while($chrome.FindElementsByid('3131').Count -eq 0)


Write-Host "Clicked Export Button"
# Click the Export Button to generate the file #
$chrome.FindElementById('3131').click()


# Wait for File to Export #
$DldFile = Get-ChildItem $saveFolderPath -Recurse | Where-Object {$_.Mode -notmatch "d"} | Where-Object {$_.LastWriteTime -gt $currentTime} | Where-Object {$_.Extension -eq ".xlsx"}

Write-Host "Waiting for export to complete" #$chrome.FindElementById('done_eb_ExportStyle').GetAttribute('visibility')#
do{
Start-Sleep -Seconds 3
$DldFile = Get-ChildItem $saveFolderPath -Recurse | Where-Object {$_.Mode -notmatch "d"} | Where-Object {$_.LastWriteTime -gt $currentTime} | Where-Object {$_.Extension -eq ".xlsx"}
}while($DldFile.Length -eq 0)




$dlFile = Get-ChildItem $saveFolderPath -filter *.xlsx | sort LastWriteTime | select -Last 1

Rename-Item -Path $dlFile.FullName -NewName "$FileName.xlsx"

$chromeOpts = $null
$currentTime = $null
$FileName = $null
$saveFolderPath = $null
$dlFile = $null
$DldFile = $null
$SelPath = $null
$BISub = $null
$chrome.Quit()
$chrome.Dispose()
