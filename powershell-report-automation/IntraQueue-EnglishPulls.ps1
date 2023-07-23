<#==================================================================

    IntraQueue English
        - Contains different pulls than the Spanish version
==================================================================#>



cls
$SelPath = 'C:\Users\'+$env:UserName+'\Documents\Selenium\'

$SavPath = 'C:\Users\'+$env:UserName+'\Downloads\IntraQueue_en\Data\'




#$lockedFile='C:\Users\'+$env:UserName+'\Documents\Selenium\chromedriver.exe'


<# 022122 - Security Policy does not allow for killing of tasks anymore.  #>
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





cls
#"DENOMINATOR" 
.\BIDownloader.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=943DCE74424ACBB00F293EA5CC8A07A8&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "DENOMINATOR" -saveFolderPath $SavPath

cls
#"NUMERATOR" 
.\BIDownloader.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=5355A5DC3F44D2CC750F07AE3B4C013E&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "NUMERATOR" -saveFolderPath $SavPath

cls
#"SELF-INSTALL"
.\BIDownloaderDetails.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=0DA33198274C1406C1A6D983C8127285&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "SELF-INSTALL" -DetailsFileName "SELF-INSTALL_REPAIR"  -saveFolderPath $SavPath

cls
#"SIT"
.\BIDownloaderDetails.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=5BDA63BAC44C4FBDD707D181D673C732&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "SIT" -DetailsFileName "SIT_REPAIR"  -saveFolderPath $SavPath

cls
#"ICOMS-ICOMS"
.\BIDownloaderDetails.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=77692D3A434776CAE94A9EA8F7364E8F&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "ICOMS-ICOMS" -DetailsFileName "ICOMS-ICOMS_REPAIR"  -saveFolderPath $SavPath

cls
#"ICOMS-CSG"
.\BIDownloaderDetails.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=85A66101EE446681832F78B9F7BE27AB&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "ICOMS-CSG" -DetailsFileName "ICOMS-CSG_REPAIR"  -saveFolderPath $SavPath

cls
#"CSG-CSG"
.\BIDownloaderDetails.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=A1209037A942D838F23F7A87971A6005&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "CSG-CSG" -DetailsFileName "CSG-CSG_REPAIR"  -saveFolderPath $SavPath

cls
#"CSG-ICOMS"
.\BIDownloaderDetails.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=918490428E4DF88768D5B280B97FA211&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "CSG-ICOMS" -DetailsFileName "CSG-ICOMS_REPAIR"  -saveFolderPath $SavPath

cls
#"REMAINDER"
.\BIDownloaderDetails.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=F16F2359F7419D1A909619BE49C7A600&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "REMAINDER" -DetailsFileName "REMAINDER_REPAIR"  -saveFolderPath $SavPath

cls
#"SUP-DENOMINATOR" 
.\BIDownloader.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=E34CA9F7B7432D00075395BF269E791F&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "SUP-DENOMINATOR" -saveFolderPath $SavPath

cls
#"SUP-NUMERATOR" 
.\BIDownloader.ps1 -BISub "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=FE3E3E7E534C50510531478503FBDED2&reportViewMode=1&Server=NCEPNBISMSA0002&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" -FileName "SUP-NUMERATOR" -saveFolderPath $SavPath




$SelPath = $null
$CpPath = $null

