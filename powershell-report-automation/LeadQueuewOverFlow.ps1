
$BIPreProcessFolder = 'C:\Users\'+$env:UserName+'\Documents\Selenium\BIProcessed\Pre_Process'
$LeadQueueOverFlowFolder = '\\STXFILE01.corp.twcable.com\RTXCareReporting\Team Member Folders\Kevin\Template_Documents\LeadQueueWithOverflow'

# Check of LeadQueueData and LeadQueueOverflowData files exist #

$LQData = Get-ChildItem $BIPreProcessFolder -filter LeadQueueData.xlsx 
$LQOData = Get-ChildItem $BIPreProcessFolder -filter LeadQueueOverflowData.xlsx

if($LQData.Exists -and $LQOData.Exists)
{
Write-Output 'Both Files Exist. Proceeding'

$skillBillingVendorPath = $LeadQueueOverFlowFolder + "\Skill Billing Vendor.xlsx"
$skillBillingVendor = Get-ChildItem $skillBillingVendorPath

# Creating the Excel Application Object #
$xcl = New-Object -ComObject Excel.Application
$xcl.visible = $true
$xcl.DisplayAlerts = $false

# Open Skill Billing Vendor File and the Downloaded LeadQueue Data #
$xclBVWB = $xcl.workbooks.Open($skillBillingVendor.FullName)
$xclLQDataWB = $xcl.workbooks.Open($LQData.FullName)
$fiscalMthCol = $xclLQDataWB.Worksheets[1].Columns[4].EntireColumn
$DateCol = $xclLQDataWB.Worksheets[1].Columns[1].EntireColumn
$fiscalMthRnge = $xclLQDataWB.Worksheets[1].range('D1')

# Format the FiscalMnth Columns from JAN 2021 to M/D/YYYY #
$fiscalMthCol.texttocolumns(
    $fiscalMthRnge,
    [Microsoft.Office.Interop.Excel.XlTextParsingType]::xlDelimited,
    [Microsoft.Office.Interop.Excel.XlTextQualifier]::xlTextQualifierDoubleQuote,
    $false,
    $true,
    $false,
    $false,
    $false,
    (1,1),
    $true)
$fiscalMthCol.NumberFormat = 'm/d/yyy'


# Grab Date Range of Downloaded File #
Write-Output $xcl.WorksheetFunction.Max($DateCol)
Write-Output $xcl.WorksheetFunction.Min($DateCol)












$xcl.Quit()
}else{
Write-Output 'Please Restage LeadQueueData and LeadQueueOverflowData files'







}


$LQOData = $null
$LQData = $null
$BIPreProcessFolder = $null
$skillBillingVendor = $null
$skillBillingVendorPath = $null
$xcl = $null