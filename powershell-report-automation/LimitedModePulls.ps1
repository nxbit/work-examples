cls
$SelPath = 'C:\Users\'+$env:UserName+'\Documents\Selenium\'

$SavPath = 'C:\Users\'+$env:UserName+'\Downloads\LimitedMode\Data\'


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
#020422 - For the LimitedMode report folder should exist before script launched
if(Test-Path $SavPath){
    Get-ChildItem $SavPath | Remove-Item
}else{
    New-Item -Path $SavPath -ItemType Directory
}


#Grab the latest Copy of BIDownloader and BIDownloaderDetails
Copy-Item -Path '\\STXFILE01.corp.twcable.com\RTXCareReporting\Team Member Folders\Kevin\Selenium\BIDownloader.ps1' -Destination $SelPath'BIDownloader.ps1' -Force
Copy-Item -Path '\\STXFILE01.corp.twcable.com\RTXCareReporting\Team Member Folders\Kevin\Selenium\BIDownloaderDetails.ps1' -Destination $SelPath'BIDownloaderDetails.ps1' -Force


cd $SelPath

Write-Output "CT Values"
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=DB565C111E4B33D74A1564A977FCE250&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "CTValues" -saveFolderPath $SavPath


#This task needs to be last since it requires header cleanups

$processStart = Get-Date
cls
Write-Output "FCR Values"
.\BIDownloader.ps1 "https://bi.corp.chartercom.com/MicroStrategy/servlet/mstrWeb?evt=4058&src=mstrWeb.4058&_subscriptionID=F37BB3CD764800C776258FABF47A230B&reportViewMode=1&Server=NCEPNBISMSA0001.CORP.CHARTERCOM.COM&Project=BI%20Reporting%20and%20Analytics&Port=34952&share=1" "FCRValues" -saveFolderPath $SavPath

#=====================================================================================================;
#020822 - The FCR file has two header rows, which need to be cleaned or merged;
$processEnd = Get-Date
cls
Write-Output "Cleaning FCR headers:"
Write-Output $processStart
Write-Output $processEnd

<# Using Excel.Appliction Object, Initilizing Objects and Path's used #>
$ExcelObject=New-Object -ComObject excel.application
$ExcelObject.visible=$false
<# Grabing Files with FCRValues created between the job process times #>
$ExcelFiles = Get-ChildItem $SavPath -Filter *FCRValues*.xlsx | Where-Object {($_.CreationTime -ge $processStart) -and ($_.CreationTime -le $processEnd) }


<# Open Each ExcelFile in the Folder and Copy its Data to the Combined Workbook #>
foreach($ExcelFile in $ExcelFiles){
        $Everyexcel=$ExcelObject.Workbooks.Open($ExcelFile.FullName)
		
		for(($c = 1); ($c -lt 11) ; $c++)
		{
			#Prep the value we plan to move into row2
			$row1 = $Everyexcel.sheets.Item(1).Cells.Item(1,$c).text
			if($Everyexcel.sheets.Item(1).Cells.Item(2,$c).text -eq "")
			{	
				#If the second row of the column is blank, move the value from the first row to the 2nd
				$Everyexcel.sheets.Item(1).Cells.Item(2,$c) = $row1
			}
			else 
			{
				#Otherwise add the first row as a prefix to the 2nd row
				$Everyexcel.sheets.Item(1).Cells.Item(2,$c) = $row1 + " " + $Everyexcel.sheets.Item(1).Cells.Item(2,$c).text
			}
		}
		#Now clear the 2nd header
        $Everyexcel.sheets.Item(1).Cells.Item(1,1).EntireRow.Delete()
        $Everyexcel.Save()
        $Everyexcel.Close()
        
}

$ExcelObject.Quit() 
$ExcelFiles = $null
$ExcelObject = $null

#=====================================================================================================;

#112421 Since the files are saved to a dedicated folder, added to avoid missing the manual step before the DB processing#
#120821 - Added Test Remote Location Path Step#
#010522 - Added additional links for the new SAM metric sourced from Call Insights#
#020422 - Borrowed from TCP logic for the LimitedMode reporting#
cls
$rl = '\\stxfile01.corp.twcable.com\RTXCareReporting\Report Main\Limited Mode\Data\';
Write-Output "Moving Files"
if(Test-Path $rl){
Move-Item -Path $SavPath'*.*' -Destination $rl -Force
}else{
Write-Host -ForegroundColor White -BackgroundColor Red "Unable to Move the Files. Please Copy Files to Share Manually"
}
$rl = $null;
Write-Output "Files Refreshed"