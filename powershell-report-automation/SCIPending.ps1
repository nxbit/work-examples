
<# 050622 - New Chrome Driver Sync Start Area  #>

<# 	NOTE. the final call in this area is to ./GrabChromeDriver.ps1. This file will 
be assumed local to that of the script. If the script is being copied local and then ran, 
you much ensure GrabChromeDriver is also in the same directory.#>

#======================================================================================#
#                       START OF LOADING CHROMEDRIVERS                                 #
#======================================================================================#



#setting ChromePath to Typical Default
$chromePath = "C:\Program Files*\Google\Chrome\Application\chrome.exe";

#setting local Selenium Path
$lSelenium = 'C:\Users\'+$env:UserName+'\Documents\Selenium';
$rChromeDriver = "\\165.237.249.28\RTXCareReporting\Report Main\Selenium\Driver";


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

       Write-Output $rChromeDriver"\$ver\chromedriver.exe"
        Write-Output $lSelenium"\chromedriver.exe"

        Write-Output 'Test'
    }else{
        Write-Host -ForegroundColor Black -BackgroundColor White ("Syncing $ver ChromeDriver."); 
		
		#Sync the latest logic for grab chrome driver
		Copy-Item -Path "\\stxfile01.corp.twcable.com\RTXCareReporting\Report Main\Selenium\GrabChromeDriver.ps1" -Destination "./GrabChromeDriver.ps1"
		#Now execute that newest logic to grab the new driver
        ./GrabChromeDriver.ps1 -neededMajorVer $ver
		
        Write-Output $rChromeDriver"\$ver\chromedriver.exe"
        Write-Output $lSelenium"\chromedriver.exe"


        Copy-Item -Path $rChromeDriver"\$ver\chromedriver.exe" -Destination $lSelenium"\chromedriver.exe"
    }

}



Sync-ChromeDriver
Write-Output "Driver synced"


<# 050622 - New Chrome Driver Sync End Area  #>


#======================================================================================#
#                       END OF LOADING CHROMEDRIVERS                                   #
#======================================================================================#


$CpPath = '\\stxfile01.corp.twcable.com\RTXCareReporting\Report Main\Selenium\'
$SelPath = 'C:\Users\'+$env:UserName+'\Documents\Selenium\'
$GenURI = "https://nocportal-prd.corp.chartercom.com/incidentportal/sharedfilter/loadfilter/27714/"
$dlFolder = 'C:\Users\'+$env:UserName+'\Downloads\'
$SCIPendingFolder = "\\165.237.249.28\RTXCareReporting\Team Member Folders\Rolando\DB\NOCPortal\Prog\Data\"


$processStart = Get-Date


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

Write-Output $SelPath'WebDriver.dll'
Write-Output $CpPath'WebDriver.dll'
Write-Output $SelPath'chromedriver.exe'
Write-Output $CpPath'chromedriver.exe'




# Load the WebDriver #
Add-Type -Path "$($SelPath)WebDriver.dll"

#Creating the Default Service for which Selenium will Run
$ChromeService = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService()
#Supression Logging for the Service
$ChromeService.EnableVerboseLogging = $false
$ChromeService.SuppressInitialDiagnosticInformation = $true


#Creating Chrome Options and supressing Logging
$chromeOpts    = New-Object OpenQA.Selenium.Chrome.ChromeOptions
$chromeOpts.AddUserProfilePreference("download.default_directory",$SCIPendingFolder)
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




#=============================================================================#
#                       SELENIUM CHROME NAV AND OPTIONS                       #
#=============================================================================#

#Clear the PS screen before starting the processing #

Write-Output "Opening NOCPortal..."


Write-Output $GenURI


# Navigate to CorPortal #
$chrome.Navigate().GoToUrl($GenURI)


$chrome.Manage().Timeouts().PageLoad = (New-TimeSpan -Seconds 10)


Write-Host -BackgroundColor Yellow -ForegroundColor Black "Log Into NOC Portal"
$loginName = $chrome.FindElementByClassName('login_name').Text
<# Check if User has Logged In #>
do{

    Start-Sleep -Seconds 1
    $loginName = $chrome.FindElementByClassName('login_name').Text

}while($loginName.Contains('Not Logged In'))
$loginName = $null


Write-Host -BackgroundColor Black -ForegroundColor Yellow "Login Found"
    Start-Sleep 2



Write-Host "Clearing Filter Loaded Popup"
<# Clear the Filter Loaded PopUp #>
$rightArrowEles = $chrome.FindElementsByClassName('right_arrow')
$rightArrowEle = $null

foreach($ele in $rightArrowEles){
    if($ele.Text -eq 'OK'){$rightArrowEle = $ele}
}

$rightArrowEle.Click()
$rightArrowEles = $null
$rightArrowEle = $null


cls
Write-Host "Waiting for Report to Load"
<#Export Current View Only When Available#>
$exportButtonEles = $chrome.FindElementsByClassName('export_button')
$exportButtonEle = $null
do{
    Start-Sleep 1
    $exportButtonEles = $chrome.FindElementsByClassName('export_button')
    foreach($ele in $exportButtonEles)
    {
        if($ele.Text -eq 'Export Current View Only')
        {
            $exportButtonEle = $ele
        }
    }
    


}while($exportButtonEle -eq $null)
cls
Write-Host "Starting Download"
$exportButtonEle.Click()
$exportButtonEles = $null
$exportButtonEle = $null


$exportURLEles = 0

do{

    $exportURLEles = $chrome.FindElementsByClassName('export_download_link').Count

}while($exportURLEles -eq 0)


cls 
Write-Host "Downloading ..."
$chrome.FindElementByClassName('export_download_link').Click()
$tDay = Get-Date



<# Wait for Download to populate #>
$dlExists = $true
do{

    Get-ChildItem $SCIPendingFolder |
    ForEach-Object {
      
      if(($_.Name.Contains("sci_tickets")) -and ($_.Extension.Contains("csv")) -and (-not $_.FullName.Contains("crdownload"))){
        
        Start-Sleep -Seconds 5

        $newName = $_.FullName.Substring(0,$_.FullName.LastIndexOf('\'))
        $newName = $newName+"\SCI_"+$tDay.ToString('MMddyy')+".csv"
    
        cls
        Write-Output "File Processing"
        Copy-Item -Path $_.FullName -Destination $newname -Force
        Remove-Item -Path $_.FullName -Force

        $dlExists = $false
        
      }
       
    } 




}while($dlExists)



cls
Write-Output "Completed. Cleaning Up"

Start-Sleep -Seconds 5
$chrome.Quit()
$chrome.Dispose()






$GenURI = $null
$CpPath = $null
$chrome = $null
$SelPath = $null
$chromeOpts = $null
$ChromeService = $null
$processStart = $null
$loadingModalID = $null