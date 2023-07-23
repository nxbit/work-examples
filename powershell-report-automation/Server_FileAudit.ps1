#==================================;
#	Test version with the progress bars shown for each stage;
#
#==================================;
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
#Archive the web reports older than 6 months;
#Clean the team share using the IT File Retention guidance;
#Traffic published files are redundant and can be cleaned after 60 days;
$webLimit = (Get-Date).AddDays(-1*(365/2))
$shareLimit = (Get-Date).AddDays(-1*(365*2))
$trafficLimit = (Get-Date).AddDays(-1*(60))

#Default lookup paths for each type of cleanup
$webPath = "\\ausccoweb01\ChannelYou_Protected"
$sharePath = "\\stxfile01.corp.twcable.com\RTXCareReporting\AUSCCOWEB01 - Archived Reports"
$trafficPath = "\\corp.chartercom.com\Apps\CSRA\GVPOperations Published Files\Video"
#Each entry needs to end in a semicolon to identify the delimiter;
$extIgnore = "config;db;lnk;jpg;png;bmp;gif;tif;"


#===========================;
#Define a single cleanup token for holding the collection of objects
#===========================;
$cleanupObjects = $null


#Building the list takes a while
#========================================================================================;
# Stage 1:	Identify files older than the $webLimit; At design time this will be 6 months;
#========================================================================================;
$curStage = "Stage 1: Archive Web Server"
$itemChanges = 0
cls
Write-Output ("$curStage")
Write-Output "Reading files for archive..."


#Recursively find any files older than the threshold
$cleanupObjects = Get-ChildItem -Path $webPath -Recurse -Force | 
	Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $webLimit -and !($extIgnore.ToLower() -Match ($_.Extension.ToLower() + ";"))} 

#Start processing
$cleanupObjects | ForEach-Object -Begin {
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
		Write-Progress -Activity "Archive Web Server" -Status "Progress:" -PercentComplete (($i/$cleanupObjects.count)*100)


		#Define the destinations for the share using the same subfolders
		$dest 		= $sharePath + $_.FullName.Substring($webPath.Length) 	#For the full file and path
		$dPath		= $dest.Substring(0,$dest.Length - $_.Name.Length)		#For just the new path
		
		#Now confirm the full path is built on the share; Needs to exist before moving a distinct file
		if(!(test-path $dPath)){
			#Build the path if it is missing
			$null = New-Item -ItemType Directory -Force -Path $dPath 
		}
		#Now relocate the file to the share
		Move-Item -path $_.FullName -destination $dest 
		
		cls
		$itemChanges = $itemChanges + 1
		Write-Output ("$curStage")
		Write-Output ("File: $itemChanges")
} -End {
	cls
	Write-Output ("$curStage - Done!")
	$cleanupObjects = $null
	
}
#This completed statement, named for the same activity as the progress bar, should remove the bar after each stage#
Write-Progress -Activity "Archive Web Server" -Status "Ready" -Completed
	
#========================================================================================;
# Stage 2:	Identify web folders that are now empty and clean;
#========================================================================================;
$curStage = "Stage 2: Clean Empty Web Server folders"
$itemChanges = 0
cls
Write-Output ("$curStage")
Write-Output "Reading folders for cleanup..."


# Find a listing of any empty directories left behind after deleting the old report files.
#100422: Updated to also skip ignored files when determining an empty folder;
$cleanupObjects = Get-ChildItem -Path $webPath -Recurse -Force | 
	Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer -and !($extIgnore.ToLower() -Match ($_.Extension.ToLower() + ";"))}) -eq $null }
	
#Start processing
$cleanupObjects | ForEach-Object -Begin {
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
		Write-Progress -Activity "Clean Empty Web Server Folders" -Status "Progress:" -PercentComplete (($i/$cleanupObjects.count)*100)

		Remove-Item -Path $_.FullName -Force
		#Write-Output $_.FullName
		
		cls
		$itemChanges = $itemChanges + 1
		Write-Output ("$curStage")
		Write-Output ("Folders: $itemChanges")
} -End {
	cls
	Write-Output ("$curStage - Done!")
	$cleanupObjects = $null
}
#This completed statement, named for the same activity as the progress bar, should remove the bar after each stage#
Write-Progress -Activity "Clean Empty Web Server Folders" -Status "Ready" -Completed
	
#========================================================================================;
# Stage 3:	Identify share files older than the IT File Retention limits and clean;
#========================================================================================;
$curStage = "Stage 3: Clean share for IT File Retention"
$itemChanges = 0
cls
Write-Output ("$curStage")
Write-Output "Reading share files for cleanup..."


#Recursively find any files older than the threshold
$cleanupObjects = Get-ChildItem -Path $sharePath -Recurse -Force | 
	Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $shareLimit -and !($extIgnore -Match ($_.Extension + ";"))}
	
#Start processing
$cleanupObjects | ForEach-Object -Begin {
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
		Write-Progress -Activity "Clean share for IT File Retention" -Status "Progress:" -PercentComplete (($i/$cleanupObjects.count)*100)

		#Now remove items
		Remove-Item -Path $_.FullName -Force	
		#Write-Output $_.FullName
		
		cls
		$itemChanges = $itemChanges + 1
		Write-Output ("$curStage")
		Write-Output ("File: $itemChanges")
} -End {
	cls
	Write-Output ("$curStage - Done!")
	$cleanupObjects = $null
}
#This completed statement, named for the same activity as the progress bar, should remove the bar after each stage#
Write-Progress -Activity "Clean share for IT File Retention" -Status "Ready" -Completed
	
#========================================================================================;
# Stage 4:	Identify share folders that are now empty and clean;
#========================================================================================;
$curStage = "Stage 4: Clean empty share folders"
$itemChanges = 0
cls
Write-Output ("$curStage")
Write-Output "Determining share folders for cleanup, this might take a while..."


# Find a listing of any empty directories left behind after deleting the old report files.
#100422: Updated to also skip ignored files when determining an empty folder;
$cleanupObjects = Get-ChildItem -Path $sharePath -Recurse -Force | 
	Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer -and !($extIgnore.ToLower() -Match ($_.Extension.ToLower() + ";"))}) -eq $null }
	
#Start processing
$cleanupObjects | ForEach-Object -Begin {
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
		Write-Progress -Activity "Clean empty share folders" -Status "Progress:" -PercentComplete (($i/$cleanupObjects.count)*100)

		Remove-Item -Path $_.FullName -Force
		#Write-Output $_.FullName
		
		cls
		$itemChanges = $itemChanges + 1
		Write-Output ("$curStage")
		Write-Output ("Folders: $itemChanges")
} -End {
	cls
	Write-Output ("$curStage - Done!")
	$cleanupObjects = $null
}
#This completed statement, named for the same activity as the progress bar, should remove the bar after each stage#
Write-Progress -Activity "Clean empty share folders" -Status "Ready" -Completed
	
#========================================================================================;
# Stage 5:	Identify aging files in the Traffic Published folder and clean;
#========================================================================================;
$curStage = "Stage 5: Clean aging Published files on Traffic file share"
$itemChanges = 0
cls
Write-Output ("$curStage")
Write-Output "Determining aging files for cleanup, this might take a while..."


#Recursively find any files older than the threshold
$cleanupObjects = Get-ChildItem -Path $trafficPath -Recurse -Force | 
	Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $trafficLimit -and !($extIgnore -Match ($_.Extension + ";"))}
	
#Start processing
$cleanupObjects | ForEach-Object -Begin {
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
		Write-Progress -Activity "Clean Published files on Traffic share" -Status "Progress:" -PercentComplete (($i/$cleanupObjects.count)*100)

		#Now remove items
		Remove-Item -Path $_.FullName -Force	
		#Write-Output $_.FullName
		
		cls
		$itemChanges = $itemChanges + 1
		Write-Output ("$curStage")
		Write-Output ("File: $itemChanges")
} -End {
	cls
	Write-Output ("$curStage - Done!")
	$cleanupObjects = $null
}
#This completed statement, named for the same activity as the progress bar, should remove the bar after each stage#
Write-Progress -Activity "Clean Published files on Traffic share" -Status "Ready" -Completed

	
	
	
#Housekeep variable entries
$webLimit = $null
$shareLimit = $null
$trafficLimit = $null
$webPath = $null
$sharePath = $null
$trafficPath = $null	
$extIgnore = $null
#Tracking
$curStage = $null
$itemChanges = $null
$i = $null
$cleanupObjects = $null
	
	pause("Done.  Press Enter to close.");
	exit