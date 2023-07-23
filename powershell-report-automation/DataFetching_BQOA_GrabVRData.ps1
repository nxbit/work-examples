
#Path to BQData csv file
$desktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
$sourceCSV = $desktopPath+'\BQOAData.csv';
$exportCSV = $desktopPath+'\BQOA_VR_Export.csv';
$cols = ('Agent Id','Behavior','Caldt','Denominator Count','Numerator Count')

#Start of Import Process
Import-CSV $sourceCSV |
#Pulling only Video Repair
Where-Object {$_.Lob -eq 'Video Repair'} |
#Selecting only needed Columns set above
Select-Object $cols |
Export-Csv $exportCSV -NoClobber -NoTypeInformation