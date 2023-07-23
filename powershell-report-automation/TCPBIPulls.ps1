cls
$SelPath = 'C:\Users\'+$env:UserName+'\Documents\Selenium\'

$SavPath = 'C:\Users\'+$env:UserName+'\Downloads\TCPData\'


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
Copy-Item -Path '\\STXFILE01.corp.twcable.com\RTXCareReporting\Team Member Folders\Kevin\Selenium\BIDownloaderDetails.ps1' -Destination $SelPath'BIDownloaderDetails.ps1' -Force


cd $SelPath

# 113022 - Added Gran Vista, and updated Contracting Firm = Unknown  #
Write-Output "Roster"
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=E3562E63764F246B832CE6B31D4DAE26&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "Roster" -saveFolderPath $SavPath
#===============================================#
Write-Output "6WK Files"
#6WKBase#
# 113022 - Added Gran Vista#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=494EE023DA47CBCA89B4A7A90C773FB9&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "6WKBase" -saveFolderPath $SavPath
cls
#6WKEscal#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=694504FAC2478CB3F7CF378254E8BF2E&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "6WKEscal" -saveFolderPath $SavPath
cls
#6WKIQDen#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=42788821D6445BD4254CB6841398718B&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "6WKIQDen" -saveFolderPath $SavPath
cls
#6WKIQNum#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=8A63DAFCD442A027895624AE6B56CCB4&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "6WKIQNum" -saveFolderPath $SavPath
cls
#052522:	SAM added to LI and added to Base;  No need for dedicated SAM pull from CI;#
#.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=2C3920D30B45CFFDAF926E9C6D9256F3&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "6WKSAM" -saveFolderPath $SavPath
#===============================================#
Write-Output "Fiscal Files"
#FiscalBase#
# 113022 - Added Gran Vista#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=71C37FB2EB45B108A889149153C31266&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "FiscalBase" -saveFolderPath $SavPath
cls
#FiscalEscal#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=97448DBB414CFDA0894CEC906D543E04&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "FiscalEscal" -saveFolderPath $SavPath
cls
#FiscalIntraQDen#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=226F08B50E480CE10A65CFB88FD30B05&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "FiscalIntraQDen" -saveFolderPath $SavPath
cls
#FiscalIntraQNum#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=38702BEC474D7B7B0FD03BA4F93245B5&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "FiscalIntraQNum" -saveFolderPath $SavPath
cls
#052522:	SAM added to LI and added to Base;  No need for dedicated SAM pull from CI;#
#.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=3B44F9BE7442B63D1E87908580525424&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "FiscalSAM" -saveFolderPath $SavPath
#===============================================#
Write-Output "MTD Mgr"
#MTDMgr#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=5EC0414EA144DD6E6639DDA61487DF76&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "MTDMgr" -saveFolderPath $SavPath
cls
#MTDMgrEscalations#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=D8FF02BB2F41E34399B360BA0BB27A3F&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "MTDMgrEscalations" -saveFolderPath $SavPath
cls
#MTDMgrIntraQDen#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=17AC559EFC43AA9EBC1B39BCE7F478E5&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "MTDMgrIntraQDen" -saveFolderPath $SavPath
cls
#MTDMgrIntraQNum#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=CD59F5B364484028A78671B9605DFB0E&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "MTDMgrIntraQNum" -saveFolderPath $SavPath
cls
#052522:	SAM added to LI and added to Base;  No need for dedicated SAM pull from CI;#
#.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=FE48371E394DEF669C8E49A4C30AEE8C&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "MTDMgrSAM" -saveFolderPath $SavPath
#===============================================#
Write-Output "MTD Site"
#MTDSite#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=E156320B2344411DDDA805B5A518F327&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "MTDSite" -saveFolderPath $SavPath
cls
#MTDSiteEscalations#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=C26F1661024F87ABCAD767A69C37CD7A&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "MTDSiteEscalations" -saveFolderPath $SavPath
cls
#MTDSiteIQDen#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=CFF59AC9B142BD9A062CE28D6FA5485B&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "MTDSiteIQDen" -saveFolderPath $SavPath
cls
#MTDSiteIQNum#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=94273B309948671A887B4B860766EDAB&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "MTDSiteIQNum" -saveFolderPath $SavPath
cls
#052522:	SAM added to LI and added to Base;  No need for dedicated SAM pull from CI;#
#.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=0D77F696D74761CAA396F1B507E29D56&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "MTDSiteSAM" -saveFolderPath $SavPath
#===============================================#
Write-Output "MTD Sup"
#MTDSup#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=867A2B8C974CCCF9AF3D15A0900EA71C&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "MTDSup" -saveFolderPath $SavPath
cls
#MTDSupEscalations#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=C0284CA6C747CE9B0EE40EB194DAF78E&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "MTDSupEscalations" -saveFolderPath $SavPath
cls
#MTDSupIQDen#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=9A9E4FEDC54F336CC792B1A83BC21D87&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "MTDSupIQDen" -saveFolderPath $SavPath
cls
#MTDSupIQNum#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=0827B8A1ED4AEEF199E4ADAA53950B03&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "MTDSupIQNum" -saveFolderPath $SavPath
cls
#052522:	SAM added to LI and added to Base;  No need for dedicated SAM pull from CI;#
#.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=2A2356FDDC446FFD6F4527AEDDA7C780&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "MTDSupSAM" -saveFolderPath $SavPath
#===============================================#
Write-Output "YTD Agent"
#YTDAgent#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=5B59F606454FBA225C0C44B9F7165833&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "YTDAgent" -saveFolderPath $SavPath
cls
#YTDAgentEscal#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=71C3BB85BC42389EC735919B11F8E1FE&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "YTDAgentEscal" -saveFolderPath $SavPath
cls
#YTDAgentIQDen#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=65957ADDA74E67148C0007AA789A8651&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "YTDAgentIQDen" -saveFolderPath $SavPath
cls
#YTDAgentIQNum#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=40D78747B140E73D24433EBE40142049&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "YTDAgentIQNum" -saveFolderPath $SavPath
cls
#052522:	SAM added to LI and added to Base;  No need for dedicated SAM pull from CI;#
#.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=B83E29B54246290657CB52A700FBC997&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "YTDAgentSAM" -saveFolderPath $SavPath
#===============================================#
Write-Output "YTD Site"
#YTDSite#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=8245327B374D85EC4151BB91135AC80A&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "YTDSite" -saveFolderPath $SavPath
cls
#YTDSiteEscalations#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=09FEDAA62E41D93D27A3AD8AEF312740&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "YTDSiteEscalations" -saveFolderPath $SavPath
cls
#YTDSiteIQDen#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=34DFE8FCB74BAAEBE2DE978C7BBAE0DE&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "YTDSiteIQDen" -saveFolderPath $SavPath
cls
#YTDSiteIQNum#
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=83707862F24CDCE653695AA9465FF13F&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "YTDSiteIQNum" -saveFolderPath $SavPath
cls
#052522:	SAM added to LI and added to Base;  No need for dedicated SAM pull from CI;#
#.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=8EC160CCCB482F09D0A8C98A13DDEF0B&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "YTDSiteSAM" -saveFolderPath $SavPath

#112421 Since the files are saved to a dedicated folder, added to avoid missing the manual step before the DB processing#
#120821 - Added Test Remote Location Path Step#
#010522 - Added additional links for the new SAM metric sourced from Call Insights#
cls
$rl = '\\stxfile01.corp.twcable.com\RTXCareReporting\202X_TargetedCoachingProgram\Data\';
Write-Output "Moving Files"
if(Test-Path $rl){
Move-Item -Path $SavPath'*.*' -Destination $rl -Force
}else{
Write-Host -ForegroundColor White -BackgroundColor Red "Unable to Move the Files. Please Copy Files to Share Manually"
}
$rl = $null;