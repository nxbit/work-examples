#MK: Added the param at the top in case someone needs to call this directly to test a specific version#
param(
    [int]$neededMajorVer = 0
)
#Intent is for this to be triggered by a user attempting to do work#
#One pull and check for the latest release and then also the version needed by the user#


function Get-ChromeDriver {
<#
    Function Get-ChromeDriver
        When called Get-ChromeDriver will use the https://chromedriver.storage.googleapis.com API
        to gater the needed ChromeDriver version for either the Latest_Release or
        the identified neededMajorVer parameter

        Note: the neededMajorVer is an interger and only the Major version needed is expected 
        to be used. No SubVersion would be needed here as the chromedriverAPI will be used
        to determine what is the best chromedriver version for the Google Major Version needed.

        Example of usage: Get-ChromeDriver -neededMajorVer 100
#>

<#
    Variable Usage
    $driverPath - Base folder where chromeDrivers are stored and used by End Users
    $chromeDriverAPI - ChromeDrivers's API
    $downloadPath - Download Path
    $chromeDriverVersionUri - Uri used to grab the needed chromedriver version
    $chromeDriverDownloadUri - Uri used to download the chromedriver


#>

param(
    [int]$neededMajorVer = 0,
    [string]$downloadPath = "C:\Users\$env:UserName\Downloads\"
)

    [string]$driverPath = '\\165.237.249.28\RTXCareReporting\Report Main\Selenium\Driver\'
    [string]$chromeDriverAPI = 'https://chromedriver.storage.googleapis.com/'
    [string]$downloadPath = "C:\Users\$env:UserName\Downloads\"
    [string]$latestMajorVer = $null
    [string]$chromeDriverVersionUri = $null
    [string]$chromeDriverDownloadUri = $null


if($neededMajorVer -eq 0){
    <# Grab Latest Release #>
    $r = Invoke-WebRequest -Uri $chromeDriverAPI'LATEST_RELEASE'

    <# Grab the Latest Release Ver from the Return #>
    $latestMajorVer = $r.ToString().SubString(0,$r.ToString().IndexOf("."))
}
if($neededMajorVer -gt 0){
    <# If the user has requsted a specific Needed Major Verstion, then lastestMajorVer that will be looked for
    is that of what the user is requesting. #>
    $latestMajorVer = $neededMajorVer
}

    Write-Host -ForegroundColor White -BackgroundColor Red "Grabbing Chrome Driver for Google Version: $latestMajorVer"

<# Chrome Drivers API will provide the correct version of chromedriver for a certain google chrome version#>

 #build string to gather chromeDriver version
 $chromeDriverVersionUri = $chromeDriverAPI+'LATEST_RELEASE_'+$latestMajorVer   
 
 #grabWebRequest
 $r = $null
 $r = Invoke-WebRequest -Uri $chromeDriverVersionUri

 $updatedChromeDriverVersion = $r.ToString()

 #build string to download ChromeDriver version
 $chromeDriverDownloadUri = 'https://chromedriver.storage.googleapis.com/'+$updatedChromeDriverVersion+'/chromedriver_win32.zip'




#MK: Before download, need to test for an existing ZIP and EXE, otherwise the old zip will be unpacked, not the new#
#Also because windows likes to rename a file on download or unpack if there is an existing file in the folder#

<# KH: Testing 5/4/22 - adding is current server path ver needing to be updated or not check 
#>
if(Test-Path $downloadPath'chromedriver_win32.zip' -PathType Leaf){
	#Delete the old Zip#
	Remove-Item -Path $downloadPath'chromedriver_win32.zip' -Force	
}
if(Test-Path $downloadPath'chromedriver.exe' -PathType Leaf){
	#Delete the old Exe#
	Remove-Item -Path $downloadPath'chromedriver.exe' -Force	
}


#Testing if majorVersion is already updated on server or not




<# KH: Testing 5/4/22 - adding is current server path ver needing to be updated or not check #>

 #Grab the new file with a typical WebReques#
 $r = $null
 $r = Invoke-WebRequest -Uri $chromeDriverDownloadUri -OutFile $downloadPath'chromedriver_win32.zip'

 #Unip the file into the downloadPath#
 Expand-Archive -Path $downloadPath'chromedriver_win32.zip' -DestinationPath $downloadPath -Force
 
 #Delete the Zip#
 Remove-Item -Path $downloadPath'chromedriver_win32.zip' -Force

 if(Test-Path $driverPath$latestMajorVer){
    #Updating Item Property to the chromeVersionNeeded    
    #New-ItemProperty -Path $downloadPath'chromedriver.exe' -Name "chromeDriverVersion" -Value $updatedChromeDriverVersion
    Move-Item -Path $downloadPath'chromedriver.exe' -Destination $driverPath$latestMajorVer -Force
    
 }else{
    New-Item $driverPath$latestMajorVer -ItemType directory
    Move-Item -Path $downloadPath'chromedriver.exe' -Destination $driverPath$latestMajorVer -Force


 }

 


 #Clean-Up#
$r = $null
$driverPath = $null
$chromeDriverAPI = $null
$downloadPath = $null
$latestMajorVer = $null
$chromeDriverVersionUri = $null
$chromeDriverDownloadUri = $null

 }


 $chromeDriverPath = '\\165.237.249.28\RTXCareReporting\Report Main\Selenium\Driver\'
 
 #MK: Test if a specific version was passed to the script retain and pass the value, otherwise test the installed Chrome#
 if($neededMajorVer -eq 0){
	 $localChromeMajorVersion = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion
	 $localChromeMajorVersion = $localChromeMajorVersion.Substring(0,$localChromeMajorVersion.IndexOf("."))
}
else{
	$localChromeMajorVersion = $neededMajorVer
}
 
 Get-ChromeDriver -neededMajorVer $localChromeMajorVersion
 
 
#MK: Explicitly end when the work is done#
return
 
 