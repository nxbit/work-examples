Sub main()

'tmp value will store the SiteName per row value
'sitesarr will store the Aggraged Array of sites
Dim tmp As String
Dim sitesarr() As String
Dim Cell As Range
Dim sites As Range
Set sites = ActiveSheet.Range("B1:B1048576")
'   012721: Updated to use the dates and data from the file as the check for the fiscal.
Dim fileDate As String
'   Read date from A2
fileDate = ActiveSheet.Cells(2, 1).Value


'MsgBox (fileDate)


'populate arr with list of Sites
sites.Select

For Each Cell In Selection
    Cell = Replace(Cell, ",", "")
Next Cell

If Not Selection Is Nothing Then
   For Each Cell In Selection
      If (Cell <> "") And (InStr(tmp, Cell) = 0) Then
      
        tmp = tmp & Cell & "|"
      End If
   Next Cell
End If

If Len(tmp) > 0 Then tmp = Left(tmp, Len(tmp) - 1)

sitesarr = Split(tmp, "|")

Dim now As Date
now = Date
Dim fDate As Date
fDate = now
'   012721: If the Date from A2 is a valid date use that value as fDate instead
If IsDate(fileDate) Then
    fDate = fileDate
End If

'MsgBox (fDate)



If Day(fDate) > 28 Then
fDate = DateAdd("m", 1, fDate)
fDate = DateSerial(Year(fDate), Month(fDate), 28)
Else
fDate = DateSerial(Year(fDate), Month(fDate), 28)
End If
Dim count As Integer

'MsgBox (fDate)

For count = 1 To ((UBound(sitesarr) - LBound(sitesarr) + 1) - 1)
'Apply Site and Fontline Filter
Worksheets(1).Range("A1").AutoFilter Field:=2, Criteria1:=sitesarr(count)
Worksheets(1).Range("A1").AutoFilter Field:=3, Criteria1:="Frontline"
'Copy Range Data
Range("A2").Select
    Range(Selection, Selection.End(xlDown)).Select
    Range(Selection, Selection.End(xlToRight)).Select
    Selection.Copy
    
'Open Site Temp Workbook
'--------------------------------------------;
' Old; Relied on files for each site matching the data export from BI;
'------;
'Workbooks.Open Filename:="\\server.domain.com\RTXCareReporting\Report Main\Aux Daily\temp\" & sitesarr(count) & ".xlsx"
'Workbooks(sitesarr(count) & ".xlsx").Worksheets("AUX Data").Select
'Workbooks(sitesarr(count) & ".xlsx").Worksheets("AUX Data").Range("Table1[Date]").Select
'    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
'        :=False, Transpose:=False
'Workbooks(sitesarr(count) & ".xlsx").RefreshAll
'Workbooks(sitesarr(count) & ".xlsx").Worksheets("AUX Data").Visible = False
'Windows(sitesarr(count) & ".xlsx").Activate
'Sheets("AUX Report").Select
'    Range("A1").Select
'Workbooks(sitesarr(count) & ".xlsx").SaveAs Filename:="\\server.domain.com\RTXCareReporting\Report Main\Aux Daily\AUX Daily - " & Format(fDate, "mmm") & " " & Format(fDate, "yy") & " - " & sitesarr(count) & ".xlsx"

'------;
'093021:    Updated to allow easier template maintenance;
' New;  Converted to a single base template to allow entirely data driven file generation;
'------;
Workbooks.Open Filename:="\\server.domain.com\RTXCareReporting\Report Main\Aux Daily\temp\BaseTemplate.xlsx"
Workbooks("BaseTemplate.xlsx").Worksheets("AUX Data").Select
Workbooks("BaseTemplate.xlsx").Worksheets("AUX Data").Range("Table1[Date]").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
Workbooks("BaseTemplate.xlsx").RefreshAll
Workbooks("BaseTemplate.xlsx").Worksheets("AUX Data").Visible = False
Windows("BaseTemplate.xlsx").Activate
Sheets("Summary").Select
    Range("A1").Select
Workbooks("BaseTemplate.xlsx").SaveAs Filename:="\\server.domain.com\RTXCareReporting\Report Main\Aux Daily\AUX Daily - " & Format(fDate, "mmm") & " " & Format(fDate, "yy") & " - " & sitesarr(count) & ".xlsx"


'--------------------------------------------;


Workbooks("AUX Daily - " & Format(fDate, "mmm") & " " & Format(fDate, "yy") & " - " & sitesarr(count) & ".xlsx").Close SaveChanges:=True

Next count


    'Set the Filters for Leads
    Worksheets(1).Range("A1").AutoFilter Field:=3, Criteria1:="Lead"
    Worksheets(1).Range("A1").AutoFilter Field:=2
    
    'Copy Range Data
    Range("A2").Select
    Range(Selection, Selection.End(xlDown)).Select
    Range(Selection, Selection.End(xlToRight)).Select
    Selection.Copy


    'Open Lead Workbook
    Workbooks.Open Filename:="\\server.domain.com\RTXCareReporting\Report Main\Aux Daily\temp\LeadAllSites.xlsx"
    Workbooks("LeadAllSites.xlsx").Worksheets("AUX Data").Select
    Workbooks("LeadAllSites.xlsx").Worksheets("AUX Data").Range("Table1[Date]").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Workbooks("LeadAllSites.xlsx").RefreshAll
    Workbooks("LeadAllSites.xlsx").Worksheets("AUX Data").Visible = False
    Workbooks("LeadAllSites.xlsx").Activate
    Sheets("Site Comparison").Select
    Range("A1").Select

    Workbooks("LeadAllSites.xlsx").SaveAs Filename:="\\server.domain.com\RTXCareReporting\Report Main\Aux Daily\AUX Daily - " & Format(fDate, "mmm") & " " & Format(fDate, "yy") & " - LeadAllSites.xlsx"
    Workbooks("AUX Daily - " & Format(fDate, "mmm") & " " & Format(fDate, "yy") & " - LeadAllSites.xlsx").Close SaveChanges:=True


    MsgBox ("Completed. Follow Step 9 of Process Doc")

End Sub




