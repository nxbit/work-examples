<#==================================================================

==================================================================#>



cls
$SelPath = 'C:\Users\'+$env:UserName+'\Documents\Selenium\'

$SavPath = 'C:\Users\'+$env:UserName+'\Downloads\IntraQueue_sp\Data\'


#Run Maintance Script and jump back into the local Selenium Path
#cd '\\STXFILE01.corp.twcable.com\RTXCareReporting\Team Member Folders\Kevin\Selenium\'
#.\SeleniumMaintanceScript.ps1
cd $SelPath


$lockedFile='C:\Users\'+$env:UserName+'\Documents\Selenium\chromedriver.exe'

<# 022122 - New Security Policy dosent allow for killing of tassks. #>
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
Copy-Item -Path '\\STXFILE01.corp.twcable.com\RTXCareReporting\Team Member Folders\Kevin\Selenium\BIDownloaderDetails.ps1' -Destination $SelPath'BIDownloaderDetails.ps1' -Force



<#=====================================================================

        
            DOWNLOADING AND STAGING DOWNLOADED FILES


=======================================================================#>
cd $SelPath




cls
#"CSG-CSG_REPAIR"
.\BIDownloaderDetails.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=F03AD32CD24CECEF9CA7E2A15825B2A0&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "CSG-CSG" -DetailsFileName "CSG-CSG_REPAIR"  -saveFolderPath $SavPath
#"CSG-ICOMS_REPAIR"
.\BIDownloaderDetails.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=7C528383AB4E9CB89B765D930764747B&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "CSG-ICOMS" -DetailsFileName "CSG-ICOMS_REPAIR" -saveFolderPath $SavPath
#"DENOMINATOR" 
.\BIDownloader.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=4D7AF44011EBAF4D94610080EFB58FE1&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "DENOMINATOR"  -saveFolderPath $SavPath
#"ICOMS-CSG_REPAIR" 
.\BIDownloaderDetails.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=468FD1D9D4430D56EE170A9DF1E4066E&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "ICOMS-CSG" -DetailsFileName "ICOMS-CSG_REPAIR"  -saveFolderPath $SavPath
#"ICOMS-ICOMS_REPAIR"
.\BIDownloaderDetails.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=8AC4BEAF8A483ACD003B238C38C7F2BE&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "ICOMS-ICOMS" -DetailsFileName "ICOMS-ICOMS_REPAIR" -saveFolderPath $SavPath
#"NUMERATOR"
.\BIDownloader.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=F81BAC5011EBAF4D94610080EF0530E1&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "NUMERATOR" -saveFolderPath $SavPath
#"REMAINDER_REPAIR"
.\BIDownloaderDetails.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=7413085111EBAF51AEA00080EF0572A2&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "REMAINDER" -DetailsFileName "REMAINDER_REPAIR" -saveFolderPath $SavPath
#"SELF-INSTALL_REPAIR"
.\BIDownloaderDetails.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=E8D74189C54A0A95368708BCA0252894&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "SELF-INSTALL" -DetailsFileName "SELF-INSTALL_REPAIR" -saveFolderPath $SavPath
#"SIT_REPAIR"
.\BIDownloaderDetails.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=E2D54108BD4ABDD8E3657CBFA84A76E6&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "SIT" -DetailsFileName "SIT_REPAIR" -saveFolderPath $SavPath








$SelPath = $null
$CpPath = $null

