param(
    # Setting Parameters Accepting the BI Sub and FileName#
    [string] $BISub = "",
    [string] $FileName = '' , 
    [string] $saveFolderPath =  'C:\Users\'+[Environment]::UserName+'\Downloads\TCPFiles\'

)
Write-Output "<<<<<<<<<<<<<PROCESSING FILE: "$FileName


#Manually Kicking off Garbage Collection before Script#
[system.gc]::Collect()

# Selenium Path and Download Folder Path  #
$SelPath = 'C:\Users\'+[Environment]::UserName+'\Documents\Selenium\'
# Creating Time Stamp for Download file time Blocking
$currentTime = Get-Date;

# Adding the Selenium Working Directory Path to PS Shell Path #
if(($env:Path -split ";") -notcontains $SelPath) {
    $env:Path += ";$SelPath"
}
Write-Output 'Loading Selenium Drivers'
# Load the WebDriver #
Add-Type -Path "$($SelPath)\WebDriver.dll"

$chromeOpts = New-Object OpenQA.Selenium.Chrome.ChromeOptions


#if the passed save dir doesnt exist create it
if(-not (Test-Path -Path $saveFolderPath)){
    New-Item -ItemType "directory" -Path  $saveFolderPath
}


#Creating Chrome Options and createing Chrome Object with Options #
$chromeOpts.AddUserProfilePreference("download.default_directory",$saveFolderPath)
$chromeOpts.AddArgument("-log-level=3")


#$chrome = New-Object OpenQA.Selenium.Chrome.ChromeDriver($chromeOpts)
$chrome = New-Object OpenQA.Selenium.Chrome.ChromeDriver($chromeOpts)


# Navigate to BI Sub Link #
Write-Output "Navigating to BI for file" $FileName

$chrome.Navigate().GoToUrl($BISub)





# Waiting Till Export Button appears #
do{
Start-Sleep -Seconds 1
$emptyGrid = $chrome.FindElementsByClassName('empty-view-grid').Count
Write-Output "Waiting for BI Subscription to Load on the Report Home Tab"
}while(($chrome.FindElementsById('tbExport').Count -eq 0))
# Adding Clause if grid returned empty to exit the Script #
if($emptyGrid -ige 1){ 
Write-Output "Clean Up"
$SelPath = $null
$BISub = $null
$chrome.Quit()
$chrome.Dispose()
exit 0 }


Write-Output "Clicking the export Button"
# Click the Export Button by Fireing the OnClick Event #
$chrome.ExecuteScript("document.getElementById('tbExport').click();")


Write-Output "Switiching to Export Window"
# Swtich to the Export Window to the Export Window #
$null = $chrome.SwitchTo().Window($chrome.WindowHandles[1])


# Wait until the Export as Plain Text Button Appears #
do{
Start-Sleep -Seconds 1
Write-Output "Waiting for the Export as Plain Text Button"
}while($chrome.FindElementsByid('exportFormatGrids_excelPlaintextIServer').Count -eq 0)


# Uncheck all Options #
Write-Output "Un Checking All Options"
$chrome.ExecuteScript("var checkboxes = new Array(); 
  checkboxes = document.getElementsByTagName('input');
 
  for (var i=0; i<checkboxes.length; i++)  {
    if (checkboxes[i].type == 'checkbox')   {
      checkboxes[i].checked = false;
    }
  }")



Write-Output "Select Export as Plain Text"
# Click the Plain Text Button #
$chrome.FindElementByid('exportFormatGrids_excelPlaintextIServer').click()


# Wait for the Export Button to appear #
do{
Start-Sleep -Seconds 1
Write-Output "Waiting for Export Button"
}while($chrome.FindElementsByid('3131').Count -eq 0)


Write-Output "Clicked Export Button"
# Click the Export Button to generate the file #
$chrome.FindElementById('3131').click()


# Wait for File to Export #
$DldFile = Get-ChildItem $saveFolderPath -Recurse | Where-Object {$_.Mode -notmatch "d"} | Where-Object {$_.LastWriteTime -gt $currentTime} | Where-Object {$_.Extension -eq ".xlsx"}

do{
Start-Sleep -Seconds 3
$DldFile = Get-ChildItem $saveFolderPath -Recurse | Where-Object {$_.Mode -notmatch "d"} | Where-Object {$_.LastWriteTime -gt $currentTime} | Where-Object {$_.Extension -eq ".xlsx"}
Write-Output "Waiting for export to complete" #$chrome.FindElementById('done_eb_ExportStyle').GetAttribute('visibility')#
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
