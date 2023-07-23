cls
$SelPath = 'C:\Users\'+$env:UserName+'\Documents\Selenium\'

$SavPath = 'C:\Users\'+$env:UserName+'\Downloads\Tag Rep Performance\Data\'

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

#Run Maintance Script and jump back into the local Selenium Path
#cd '\\STXFILE01.corp.twcable.com\RTXCareReporting\Team Member Folders\Kevin\Selenium\'
#.\SeleniumMaintanceScript.ps1
cd $SelPath


$lockedFile='C:\Users\'+$env:UserName+'\Documents\Selenium\chromedriver.exe'

<# 022122 - New Security Policy doesn't allow for killing of tasks. #>
#Get-Process | foreach{$processVar = $_;$_.Modules | foreach{if($_.FileName -eq $lockedFile){
#Stop-Process -id $processVar.id -Force
#$processVar.Name + "Killing ChromeDriver.exe background tasks PID:" + $processVar.id
#}}}



#If the Save path already Exists, Clear it
#If the Save path dosent Exist, Create it
#030222 - For the Tag Rep Performance report folder should exist before script launched
if(Test-Path $SavPath){
    Get-ChildItem $SavPath | Remove-Item
}else{
    New-Item -Path $SavPath -ItemType Directory
}


#Grab the latest Copy of BIDownloader and BIDownloaderDetails
Copy-Item -Path '\\STXFILE01.corp.twcable.com\RTXCareReporting\Team Member Folders\Kevin\Selenium\BIDownloader.ps1' -Destination $SelPath'BIDownloader.ps1' -Force
Copy-Item -Path '\\STXFILE01.corp.twcable.com\RTXCareReporting\Team Member Folders\Kevin\Selenium\BIDownloaderDetails.ps1' -Destination $SelPath'BIDownloaderDetails.ps1' -Force


cd $SelPath

#030322:	Updated from 14 days to 21 since we are reloading 2 weeks during each run;#
Write-Output "StaffedTime"
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=F1422A60CB4295ABEEA0C189EB01F2BA&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "StaffedTime" -saveFolderPath $SavPath


#=====================================================================================================;

#112421 Since the files are saved to a dedicated folder, added to avoid missing the manual step before the DB processing#
#120821 - Added Test Remote Location Path Step#
#030222 - Borrowed from TCP logic for the Tag Rep Performance reporting#
cls
$rl = '\\stxfile01.corp.twcable.com\RTXCareReporting\Report Main\Tag Rep Performance\Data\';
Write-Output "Moving Files"
if(Test-Path $rl){
Move-Item -Path $SavPath'*.*' -Destination $rl -Force
}else{
Write-Host -ForegroundColor White -BackgroundColor Red "Unable to Move the Files. Please Copy Files to Share Manually"
}
$rl = $null;
Write-Output "Files Refreshed"