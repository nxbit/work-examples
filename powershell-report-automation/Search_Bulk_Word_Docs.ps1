param(
    # Setting Parameters Accepting the BI Sub and FileName#
    [string] $source = '{{{{{{{{{{SOURCE PATH}}}}}}}}}}',
    [string] $searchString = '.FIRSTNAME' , 
    [string] $output =  'FileList.txt'

)


cls
Write-Output "Building list of docs in $source"
#Populating Files with Files that have .docx extension using extension check
$files = Get-ChildItem -Recurse -Path $source | Where-Object {$_.Extension -eq '.docx'}

#filenames will be used to concat the filename together
$fileNames  =''

#creating the Word object
$word = New-Object -ComObject Word.Application

Write-Output "Starting File Checks"
$files | ForEach-Object -Begin {
    # In the Begin block, use Clear-Host to clear the screen.
    Clear-Host
    # Set the $i counter variable to zero.
    $i = 0
} -Process {
	
    # Increment the $i counter variable which is used to create the progress bar.
    $i = $i+1
	cls
    # Use Write-Progress to output a progress bar.
    # The Activity and Status parameters create the first and second lines of the progress bar heading, respectively.
    Write-Progress -Activity "List Progress..." -Status "Progress:" -PercentComplete (($i/$files.count)*100)
<#  
    May need to Copy Local for inital check as PD's can be opened by other user during check
#>
        #creating the Word object
        #$word = New-Object -ComObject Word.Application
		#Open the Doc
        Write-Output "Checking File "$_.FullName
        #Opening as read only to avoid stepping on someones toes
		$doc = $word.Documents.Open($_.FullName,$false,$true)
        #Grab Content
        Write-Output "Reading Content..."
        $content = $doc.content
        #check for Text
        #$check = $content.Text -like '*EHH*'
        Write-Output "Searching Content..."
        $check = $content.Find.Execute($searchString)



        #kill content and doc and Word
        $content = $null
        $word.Application.ActiveDocument.Close()
        $doc = $null



    if ($check)
    {
        Write-Output "Found in file "$_.FullName
		#When a new file is found line break and add to the end of the current list#
		$fileNames = $fileNames + $_.FullName
		#Add new line after adding the file name#
		$fileNames += $("" | Out-String)
    }
	
	
} -End {
	cls
	Write-Output "Writing File to "$source\$output

	#since in the Loop we are including linebreaks and not creating a proper "CSV" we can use Out-File
	#$files | Export-Csv -Path $source\FileList.csv

	$fileNames | Out-File -FilePath $source\$output

}
$word.Quit()
$word = $null
$files = $null
$docs = $null
cls
Write-Output "File List Generated: "$source\$output