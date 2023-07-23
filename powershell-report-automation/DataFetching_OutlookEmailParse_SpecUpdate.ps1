clear

Write-Host "____   ____.__    .___          __________                    .__        " -BackgroundColor Black -ForegroundColor Green
Write-Host "\   \ /   /|__| __| _/____  ____\______   \ ____ ___________  |__|______ " -BackgroundColor Black -ForegroundColor Green
Write-Host " \   Y   / |  |/ __ |/ __ \/  _ \|       _// __ \\____ \__  \ |  \_  __ \" -BackgroundColor Black -ForegroundColor Green
Write-Host "  \     /  |  / /_/ \  ___(  <_> )    |   \  ___/|  |_> > __ \|  ||  | \/" -BackgroundColor Black -ForegroundColor Green
Write-Host "   \___/   |__\____ |\___  >____/|____|_  /\___  >   __(____  /__||__|   " -BackgroundColor Black -ForegroundColor Green
Write-Host "                   \/    \/             \/     \/|__|       \/           " -BackgroundColor Black -ForegroundColor Green
Write-Host "      Outlook Email Data Miner - Update Spectrum emails                  " -BackgroundColor DarkBlue -ForegroundColor White
Write-Host "     Tool will loop though folders in email and one Subfolder deep       " -BackgroundColor DarkBlue -ForegroundColor Yellow
Write-Host "          When a Update Sepectrum email is found, it's contents are      " -BackgroundColor DarkBlue -ForegroundColor Yellow
Write-Host "          copied to a new page in MS Word. Every email body will be on a " -BackgroundColor DarkBlue -ForegroundColor Yellow
Write-Host "          new page. Only Red and Yellow Status emails are imaged         " -BackgroundColor DarkBlue -ForegroundColor Yellow
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
#    starting with "Update Spectrum" and has Video somehwere in the Subject. 
###=============================== Outlook Interop ===============================###


function cleanInput([string]$in){
    #=============================================================================#
    #     Function Used to Clean Input Values bfore its placed into its final tbl
    #=============================================================================#
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
#            Building Up Array's of Update Spectrum Email's Subject and Body Contents
#============================================================================================#

Add-Type -assembly "Microsoft.Office.Interop.Outlook"
$o = New-Object -comobject Outlook.Application
$ns = $o.GetNameSpace("MAPI")


#== Setting Folder and Grabbing Folder Array ==#
$i = $ns.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)

#$usrEmail = Read-Host -Prompt "Enter your EmailAddress"
$searcher = [adsisearcher]"(samaccountname=$env:USERNAME)"
$usrEmail = $searcher.FindOne().Properties.mail

#Array Will Store Found Comm ID Subjects
$SubArr = [System.Collections.ArrayList]@();
$DTArr = [System.Collections.ArrayList]@();
$BdyArr = [System.Collections.ArrayList]@();


#Iterate over Each Folder in the NameSpace#
# 080522 - Will now look though Archive Folders ie any folder in the MAPI NameSpace  #
foreach($i in $ns.Folders)
{
    $f = $i.Folders();

##==== Iterating over each Root Folder ====##
foreach($fldr in $f){


$fn = $fldr.Name

updateScreen("Building Array of Update Spectrum emails:")

if(($fn -ne 'Calendar') -and ($fn -ne 'Contacts')){
 
        
        
        #=== Loop Through Each Item in Root Folders ===#
        $itemCount = 1
        $allItemCount = $fldr.Items.Count
        foreach($item in $fldr.Items){
            #== Look at Emails with Comm ID only ==#
            updateScreen(" ")
            updateScreen("Looking through Folder: $fn ($itemCount/$allItemCount)")
            if($item.Subject -like '*Update*Spectrum*Video*')
            {
                #Adding the Subject to the Subject Array
               $null = $SubArr.Add($item.Subject)
                #Adding the Body to the Body Array
                $null = $BdyArr.Add($item.HTMLBody)
                $null = $DTArr.Add($item.ReceivedTime)
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
                    if($item.Subject -like '*Update*Spectrum*Video*')
                    {
                        $tName = $sub.Name
						updateScreen(" ")
                        updateScreen("Looking through Folder: $tName  ($itemCount/$allItemCount)")
                        #Adding the Subject to the Subject Array
                      $null = $SubArr.Add($item.Subject)
                        #Adding the Body to the Body Array
                      $null = $BdyArr.Add($item.HTMLBody)
                      $null = $DTArr.Add($item.ReceivedTime)
                   
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


#================================================
#     Creating Word App
#================================================
$wrd = New-Object -ComObject 'Word.Application'
$wrd.Visible = $true

$doc = $wrd.Documents.Add()
$sel = $wrd.Selection

$doc.Styles["Normal"].ParagraphFormat.SpaceAfter = 0
$doc.Styles["Normal"].ParagraphFormat.SpaceBefore = 0
$margin = 36 # 1.26 cm
$doc.PageSetup.LeftMargin = $margin
$doc.PageSetup.RightMargin = $margin
$doc.PageSetup.TopMargin = $margin
$doc.PageSetup.BottomMargin = $margin


$parseTxt = ""

if(Test-Path -Path "C:\Users\$env:UserName\Downloads\UpdateSpectrumEmails\"){
      $null =  Remove-Item "C:\Users\$env:UserName\Downloads\UpdateSpectrumEmails" -Recurse
    }

$null = New-Item -Path "C:\Users\$env:UserName\Downloads\UpdateSpectrumEmails\" -ItemType "directory"
    #================================================================
    #                   Looping over Each Body
    #================================================================

    $bdyCount = 0;
    foreach($bdy in $BdyArr){

        

        #Grabbing the Body Contents to an HTMLFile object
        $htmlBody = New-Object -ComObject "HTMLFile";
        $htmlBody.IHtmlDocument2_write($BdyArr[$bdyCount].ToString());

        #Writing Body to html File
        $fileName = "C:\Users\$env:UserName\Downloads\UpdateSpectrumEmails\" + $bdyCount + ".html"
        Out-File -InputObject $bdy -FilePath $fileName

        #Adding Data to New Page if Email was Yellow or Red Status
        if(($SubArr[$bdyCount] -like '*Yellow*') -or ($SubArr[$bdyCount] -like '*Red*')){
            $dttm = $DTArr[$bdyCount]
            $sel.TypeText("Email Recived: $dttm")
            $sel.TypeParagraph()
            $subject = $SubArr[$bdyCount]
            $sel.TypeText("Email Subject: $subject")
            $sel.TypeParagraph()
            $sel.InsertFile($fileName)
            $sel.InsertNewPage()
        }
        $parseTxt = $null
        $bdyCount += 1;
    
    };

if(Test-Path -Path "C:\Users\$env:UserName\Downloads\UpdateSpectrumEmails\"){
   $null = Remove-Item "C:\Users\$env:UserName\Downloads\UpdateSpectrumEmails" -Recurse
}

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
$wrd = $null
$doc = $null
$sel = $null


pause