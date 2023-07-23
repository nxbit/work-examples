cls
$SelPath = 'C:\Users\'+$env:UserName+'\Documents\Selenium\'

$SavPath = 'C:\Users\'+$env:UserName+'\Downloads\InCenterNoPhone\'


#Run Maintance Script and jump back into the local Selenium Path
#cd '\\STXFILE01.corp.twcable.com\RTXCareReporting\Team Member Folders\Kevin\Selenium\'
#.\SeleniumMaintanceScript.ps1
cd $SelPath


$lockedFile='C:\Users\'+$env:UserName+'\Documents\Selenium\chromedriver.exe'

<# 022122 - New Securty Policy dosent allow for killing of tasks. #>
#Get-Process | foreach{$processVar = $_;$_.Modules | foreach{if($_.FileName -eq $lockedFile){
#Stop-Process -id $processVar.id -Force
#$processVar.Name + "Killing ChromeDriver.exe background tasks PID:" + $processVar.id
#}}}



#If the Save path already Exists, Clear it
#If the Save path dosent Exist, Create it
if(Test-Path $SavPath){
    Get-ChildItem $SavPath | Remove-Item
}else{
    New-Item -Path $SavPath -ItemType Directory
}




#Grab the latest Copy of BIDownloader and BIDownloaderDetails
Copy-Item -Path '\\STXFILE01.corp.twcable.com\RTXCareReporting\Team Member Folders\Kevin\Selenium\BIDownloader.ps1' -Destination $SelPath'BIDownloader.ps1' -Force


cd $SelPath

Write-Output "Staffed"
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=9D05C2E6D94D7ED455D93980C513437E&reportViewMode=1&Server=NCEPNBISMSA0001&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "Staffed" -saveFolderPath $SavPath

cls

Write-Output "Process Complete"
