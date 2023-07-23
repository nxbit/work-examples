clear

Write-Host "____   ____.__    .___          __________                    .__        " -BackgroundColor Black -ForegroundColor Green
Write-Host "\   \ /   /|__| __| _/____  ____\______   \ ____ ___________  |__|______ " -BackgroundColor Black -ForegroundColor Green
Write-Host " \   Y   / |  |/ __ |/ __ \/  _ \|       _// __ \\____ \__  \ |  \_  __ \" -BackgroundColor Black -ForegroundColor Green
Write-Host "  \     /  |  / /_/ \  ___(  <_> )    |   \  ___/|  |_> > __ \|  ||  | \/" -BackgroundColor Black -ForegroundColor Green
Write-Host "   \___/   |__\____ |\___  >____/|____|_  /\___  >   __(____  /__||__|   " -BackgroundColor Black -ForegroundColor Green
Write-Host "                   \/    \/             \/     \/|__|       \/           " -BackgroundColor Black -ForegroundColor Green
Write-Host "      Outlook Email Data Miner - Comm ID Emails                          " -BackgroundColor DarkBlue -ForegroundColor White
Write-Host "     Tool will loop though folders in email and one Subfolder deep       " -BackgroundColor DarkBlue -ForegroundColor Yellow
Write-Host "          When a Comms email is found, it is added to a List. Once all   " -BackgroundColor DarkBlue -ForegroundColor Yellow
Write-Host "          the emails are gathered. The List is then parsed for HIGH,     " -BackgroundColor DarkBlue -ForegroundColor Yellow
Write-Host "          URGENT or ENTERPRISE level emails. A copy of the found Email's " -BackgroundColor DarkBlue -ForegroundColor Yellow
Write-Host "          Body is saved to a folder called CommEmails on the desktop.    " -BackgroundColor DarkBlue -ForegroundColor Yellow
Write-Host "          A CSV is produced on the desktop called emailParse.csv         " -BackgroundColor DarkBlue -ForegroundColor Yellow
Write-Host " "
$op = $host.UI.RawUI.CursorPosition


function updateScreen([string]$updateMsg){


$host.UI.RawUI.CursorPosition = $op
Write-Host "`r$updateMsg                                                                        "

#Write-Host "`r`b      Status:     $updateMsg                          " -NoNewline

}





##
#=============================== Outlook Email Parse =============================###
#          This email Prase is looking for any Emails where the Subject is 
#    starting with "Comm ID". The email is then quiereid 
#
#
###=============================== Outlook Interop ===============================###
#Add-Type -assembly "Microsoft.Office.Interop.Outlook"
#[Reflection.Assembly]::LoadWithPartialName("Microsoft.Office.Interop.Outlook") | Out-Null

$ob = $null;
$ob = New-Object -ComObject Outlook.Application
$ns = $null;
$ns = $ob.GetNameSpace("MAPI")


function cleanInput([string]$in){

    $clean = " ";

    $clean = $in.Replace(",","")
    $clean = $clean.Replace("  "," ")
    $clean = $clean.Replace("`t","")
    $clean = $clean.Replace("`n","")
    $clean = $clean.Replace("`r","")
    $clean = $clean.Replace(" ;",";")
    $clean = $clean.Replace("; ",";")
    $clean = $clean.Replace([Environment]::NewLine,"")
    

    return $clean

    

}
#============================================================================================#
#            Building Up Array's of Comm Email's Subject and Body Contents
#============================================================================================#


#== Setting Folder and Grabbing Folder Array ==#
$i = $ns.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)

#$usrEmail = Read-Host -Prompt "Enter your EmailAddress"
$searcher = [adsisearcher]"(samaccountname=$env:USERNAME)"
$usrEmail = $searcher.FindOne().Properties.mail


#TODO: Pull AD and grab Current Users Email#
#$f = $ns.Folders.Item($usrEmail).Folders();#


#Array Will Store Found Comm ID Subjects
$SubArr = [System.Collections.ArrayList]@();
$BdyArr = [System.Collections.ArrayList]@();


#Iterate over Each Folder in the NameSpace#
# 080522 - Will now look though Archive Folders ie any folder in the MAPI NameSpace  #
foreach($i in $ns.Folders)
{
    $f = $i.Folders();


##==== Iterating over each Root Folder ====##
foreach($fldr in $f){


$fn = $fldr.Name

updateScreen("Building Array of Comm ID emails:")

if(($fn -ne 'Calendar') -and ($fn -ne 'Contacts')){
 
        
        
        #=== Loop Through Each Item in Root Folders ===#
        $itemCount = 1
        $allItemCount = $fldr.Items.Count
        foreach($item in $fldr.Items){
            #== Look at Emails with Comm ID only ==#
            updateScreen(" ")
            updateScreen("Looking through Folder: $fn ($itemCount/$allItemCount)")
            if($item.Subject -like 'Comm ID*')
            {
                #Adding the Subject to the Subject Array
               $null = $SubArr.Add($item.Subject)
                #Adding the Body to the Body Array
                $null = $BdyArr.Add($item.HTMLBody)

           
            }
            $itemCount++
        }

        #== If the Root Folder has SubFolders ==#
        if($fldr.Folders.Count -gt 0){
            foreach($sub in $fldr.Folders){
                $allItemCount = $sub.Items.Count
                $itemCount = 1            
                #=== Loop Through Each Item in Sub Folders ===#
                foreach($item in $sub.Items){
                    #== Look at Emails with Comm ID only ==#        
                    if($item.Subject -like 'Comm ID*')
                    {
                        $tName = $sub.Name
						updateScreen(" ")
                        updateScreen("Looking through Folder: $tName  ($itemCount/$allItemCount)")
                        #Adding the Subject to the Subject Array
                      $null = $SubArr.Add($item.Subject)
                        #Adding the Body to the Body Array
                      $null = $BdyArr.Add($item.HTMLBody)
                   
                    }
                    $itemCount++
                }
                
            }

        }
    }

}

}
#============================================================================================#
#                       Looping Over Array of Comm Emails
#============================================================================================#


#grabbing a Count of expected Comm ID emails
$dataCount = $SubArr.Count

#Creating a DataTable of 5 Columns to Store the Subject Parsing
$subjectData = New-Object system.Data.DataTable 'SubjectData'
$col = New-Object System.Data.DataColumn 'ComID',([string]); $subjectData.Columns.add($col)
$col = New-Object System.Data.DataColumn 'aComID',([string]); $subjectData.Columns.add($col)
$col = New-Object System.Data.DataColumn 'aComIteration',([string]); $subjectData.Columns.add($col)
$col = New-Object System.Data.DataColumn 'LOB',([string]); $subjectData.Columns.add($col)
$col = New-Object System.Data.DataColumn 'PriDesc',([string]); $subjectData.Columns.add($col)
$col = New-Object System.Data.DataColumn 'SecDesc',([string]); $subjectData.Columns.add($col)
$col = New-Object System.Data.DataColumn 'Location',([string]); $subjectData.Columns.add($col)
$col = New-Object System.Data.DataColumn 'FinalUpdateDTTM',([string]); $subjectData.Columns.add($col)
$col = New-Object System.Data.DataColumn 'FinalUpdateDesc',([string]); $subjectData.Columns.add($col)
$col = New-Object System.Data.DataColumn 'InitialDescription',([string]); $subjectData.Columns.add($col)
$col = New-Object System.Data.DataColumn 'EventResolved',([string]); $subjectData.Columns.add($col)
$col = New-Object System.Data.DataColumn 'EventStartTime',([string]); $subjectData.Columns.add($col)








#Iterate over both Arrays
for($i = 0; $i -lt $dataCount; $i++){
#============================================================================================================================#
#                          Splitting out the Subject of the Comm Email into Seperate Elements    
#  Expected Subject Example:
#  Comm ID 132134-1 (Update): MEDIUM - Platform Outage | Spectrum TV App | Single Channel | Central Region | Waite Park, MN 
#
#  Index:
#     0 - Comm ID and Severity
#     1 - Impacting LOB
#     2 - Primary Description
#     3 - Secondary Description (Sometimes Not in Array)
#     (Last Item) - Impacted Location
#   Comms where Impacting LOB is RSSX will only have 3 Items CommID and Severity, Impacting LOB (RSSX), and Location
#
#============================================================================================================================#
    $headerItems = $SubArr[$i].ToString().Split("|")
    $headerItemCount = $headerItems.Count
    
    $SavPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
    $SavPath = "$SavPath\CommEmails"
     if(Test-Path($SavPath)){}
     else{
       $null = New-Item -ItemType Directory -Path $SavPath
     }

    #Creating a New Row
    $r = $subjectData.NewRow()
    for($a = 0; $a -lt $headerItemCount; $a++){
        $type = $headerItems[$a].ToString()
        
            #to Handle RSSX Comms, 
            if($headerItemCount -eq 3){
                #Insert into the Coorspoding DT Columns
                if($a -eq 0){ $r.ComID = cleanInput($headerItems[$a].ToString())
                
                    $cID = $headerItems[$a].ToString()
                    $cID = $cID.Replace("Comm ID ",$null)
                    $cID = $cID.Substring(0,$cID.IndexOf("(")-1)
                    $it = $cID.Split("-")
                    $r.aComID = cleanInput($it[0])
                    $r.aComIteration = cleanInput($it[1])
                  }
                if($a -eq 1){ $r.LOB = cleanInput($headerItems[$a].ToString()) }
                if($a -eq 2){ $r.Location = cleanInput($headerItems[$a].ToString()) }

            }
            #to Handle Comms with no Secondary Desc
            if($headerItemCount -eq 4){
                if($a -eq 0){ $r.ComID = cleanInput($headerItems[$a].ToString())
                
                    $cID = $headerItems[$a].ToString()
                    $cID = $cID.Replace("Comm ID ",$null)
                    $cID = $cID.Substring(0,$cID.IndexOf("(")-1)
                    $it = $cID.Split("-")
                    $r.aComID = cleanInput($it[0])
                    $r.aComIteration = cleanInput($it[1])
                 }
                if($a -eq 1){ $r.LOB = cleanInput($headerItems[$a].ToString()) }
                if($a -eq 2){ $r.PriDesc = cleanInput($headerItems[$a].ToString()) }
                if($a -eq 3){ $r.Location = cleanInput($headerItems[$a].ToString()) }

            }
            #to handle Comms with a Secondary Desc
            if($headerItemCount -eq 5){
                if($a -eq 0){ $r.ComID = cleanInput($headerItems[$a].ToString())
                
                    $cID = $headerItems[$a].ToString()
                    $cID = $cID.Replace("Comm ID ",$null)
                    $cID = $cID.Substring(0,$cID.IndexOf("(")-1)
                    $it = $cID.Split("-")
                    $r.aComID = cleanInput($it[0])
                    $r.aComIteration = cleanInput($it[1])
                }
                if($a -eq 1){ $r.LOB = cleanInput($headerItems[$a].ToString()) }
                if($a -eq 2){ $r.PriDesc = cleanInput($headerItems[$a].ToString()) }
                if($a -eq 3){ $r.SecDesc = cleanInput($headerItems[$a].ToString()) }
                if($a -eq 4){ $r.Location = cleanInput($headerItems[$a].ToString()) }

            }
            #to handle Comms When a Region is Passed
            if($headerItemCount -eq 6){
                if($a -eq 0){ $r.ComID = cleanInput($headerItems[$a].ToString())
                
                    $cID = $headerItems[$a].ToString()
                    $cID = $cID.Replace("Comm ID ",$null)
                    $cID = $cID.Substring(0,$cID.IndexOf("(")-1)
                    $it = $cID.Split("-")
                    $r.aComID = cleanInput($it[0])
                    $r.aComIteration = cleanInput($it[1])
                }
                if($a -eq 1){ $r.LOB = cleanInput($headerItems[$a].ToString()) }
                if($a -eq 2){ $r.PriDesc = cleanInput($headerItems[$a].ToString()) }
                if($a -eq 3){ $r.SecDesc = cleanInput($headerItems[$a].ToString()) }
                if($a -eq 5){ $r.Location = cleanInput($headerItems[$a].ToString()) }

            }
        
    }



    #Grabbing the Body Contents to an HTMLFile object
    $htmlBody = New-Object -ComObject "HTMLFile"
    $htmlBody.IHtmlDocument2_write($BdyArr[$i].ToString())

    #Grabbing the TableRows out of the HTML Object
    $tblRows = $htmlBody.getElementsByTagName('tr')
    


    for($e = 0; $e -lt $tblRows.length; $e++){

        #Grabbing Row Elements
        $tr = $tblRows.item($e)
        $tdCount = $tr.children.length
        $trChildren = $tr.children


        #Data Scraping Starts on the 5th Row of the Table#
        if($e -ige 4){
        
            #Looking for Final and Latest Update Data
            if(($tdCount -eq 1) -and ($e -eq 4)){
                
              #if Found, Update the Final DTTM Field of the Row
              $r.FinalUpdateDTTM = cleanInput($trChildren.item(0).innerText)

              #Grab the Description Element
              $tr = $tblRows.item($e+1)
              $tdCount = $tr.children.length
              $trChildren = $tr.children

              #Update the Description Field of the Row
              $r.FinalUpdateDesc = cleanInput($trChildren.item(0).innerText)
                

            }

            #Looking for Initial Description Data
            if(($tdCount -eq 2) -and ($e -eq 4)){

              #Grab the Description Element
              $tr = $tblRows.item($e+1)
              $tdCount = $tr.children.length
              $trChildren = $tr.children


              #Update the Initial Description Field of the Row
              $txt = cleanInput($trChildren.item(1).innerText)
              Write-Output $txt.Length
              $r.InitialDescription = $txt
            

            }

            #Grabbing Row Elements
            $tr = $tblRows.item($e)
            $tdCount = $tr.children.length
            $trChildren = $tr.children

            for($c = 0; $c -lt $trChildren.length; $c++){
                $innerT = $trChildren[$c]
                $txt = $innerT.innerText
                
                if($txt -like '*Event Resolved*')
                {
                    $innerT = $trChildren[$c+1]
                    $txt = $innerT.innerText

                    $r.EventResolved = cleanInput($txt)

                }

            }

            #Grabbing Row Elements
            $tr = $tblRows.item($e)
            $tdCount = $tr.children.length
            $trChildren = $tr.children

            for($c = 0; $c -lt $trChildren.length; $c++){
                $innerT = $trChildren[$c]
                $txt = $innerT.innerText
                
                if($txt -like '*Start*Time*')
                {
                    $innerT = $trChildren[$c+1]
                    $txt = $innerT.innerText

                    $r.EventStartTime = cleanInput($txt)

                }

            }





        }

    }

    
   
    if(($r.ComID -like '*HIGH*') -or ($r.ComID -like '*URGENT*') -or ($r.ComID -like '*EXECUTIVE*')  ){
        $p = "$SavPath\Comm_ID_"
        $p = $p + $r.aComID
        $p = $p + "_Email.html"
        if(Test-Path($p)){Remove-Item $p}
        Out-File -FilePath $p -InputObject $BdyArr[$i].ToString()
    }

    #Adding Row to SubjectData
    $subjectData.Rows.Add($r)
    $r = $null




    
    #== Innerloop Var Cleanup ==#
    $headerItemCount = $null
    $headerItems = $null

}
updateScreen(" ")
updateScreen($subjectData.Rows.Count.toString()+" Total Comm Emails Parsed ")

$dsk = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
#$subjectData | export-csv -Path "$dsk\emailParse.csv" -NoTypeInformation -Delimiter ","


if(Test-Path -Path $dsk\emailParse.csv){ Remove-Item $dsk\emailParse.csv; };

$subjectData | Where-Object { (($_.ComID -like '*HIGH*') -or ($_.ComID -like '*URGENT*') -or($_.ComID -like '*EXECUTIVE*')) } | export-csv -Path "$dsk\emailParse.csv" -NoTypeInformation -Delimiter ","



updateScreen(" ")
updateScreen(" Done. File was saved to: $dsk\emailParse.csv  ")



#== Overall Clean Up ==#
# Outside Block Scope #
$o = $null
$ns = $null
$i = $null
$f = $null
$SubArr = $null
$BdyArr = $null
$fn = $null
$JoinedArr = $null
$subjectData = $null
$col = $null
$usrEmail = $null


pause