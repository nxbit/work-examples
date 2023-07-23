<#
    Selenium Maintance Script
#>
#Clearing Screen and Running Garbage Collection
cls
[system.gc]::Collect()

$localPath = 'C:\Users\'+$env:UserName+'\Documents\Selenium\'
$sourcePath = '\\STXFILE01.corp.twcable.com\RTXCareReporting\Team Member Folders\Kevin\Selenium\'

#Test if the User has a local Selenium Path
#if not, create it
if((Test-Path -Path $localPath) -ne $true){
New-Item $localPath -ItemType directory
}

#The Default action is to Grab the Copy from the Server and Copy it Local
#
#Grab the Lastest Copy of Selenium, and Chrome Driver
Write-Output 'Syncing Selenium and Chrome Driver'
Copy-Item -Path $sourcePath'chromedriver.exe' -Destination $localPath'chromedriver.exe' -Force
Copy-Item -Path $sourcePath'WebDriver.dll' -Destination $localPath'WebDriver.dll' -Force
Write-Output 'Sync Complete'



[system.gc]::Collect()
$localPath = $null
$sourcePath = $null