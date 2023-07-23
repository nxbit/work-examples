using System;
using System.Runtime.InteropServices;
using Excel = Microsoft.Office.Interop.Excel;
using System.Windows.Forms;


namespace TransferLocations
{

    public class TransferLocationsAuto
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        public static void TransferAuto(string filePath1, string temp1Path1)
        {
            string filePath = "";
            string temp1Path = "";
            string temp2Path = "";
            if (filePath1 == "" && temp1Path1 == "")
            {
                OpenFileDialog openFileDialog = new OpenFileDialog
                {
                    Title = "Select Transfer Location Report Template"
                };
                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    filePath = openFileDialog.FileName.ToString();
                }
                openFileDialog.Title = "Select Transfer Locations Call Data";
                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    temp1Path = openFileDialog.FileName.ToString();
                }
                openFileDialog.Title = "Select SSRS Transfer Locations File";
                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    temp2Path = openFileDialog.FileName.ToString();
                }
            }
            else { filePath = filePath1 + "/TransferLocationsTemp.xlsx"; temp1Path = temp1Path1 + "/Call Insights-_Customer Details.xlsx"; temp2Path = temp1Path1 + "/Transfer Locations.xlsx"; }

            Excel.Application xlApp;
            xlApp = new Excel.Application
            {
                Visible = true,
                DisplayAlerts = false
            };
            Excel.Workbook xlWorkbook;
            Excel.Worksheet xlWorksheet;


            xlWorkbook = xlApp.Workbooks.Open(filePath, 0, false, 5, "", "", true, Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
            xlWorksheet = xlWorkbook.Sheets[1];
            xlWorksheet.Activate();


            // Delete the Existing Transfer Locations sheet
            xlWorksheet.Delete();
            xlWorksheet = xlWorkbook.Sheets[1];
            xlWorksheet.Activate();

            // Find LastRow of Transfered Calls Sheet
            int _lastRowUsed = xlWorksheet.Cells[Type.Missing, 1].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;


            //Delete Data from Transfer Calls Tab
            xlWorksheet.Range[xlWorksheet.Cells[3, 1], xlWorksheet.Cells[_lastRowUsed, 8]].Delete();

            Excel.Workbook xlWorkbookTemp;
            Excel.Worksheet xlWorksheettemp;


            xlWorkbookTemp = xlApp.Workbooks.Open(temp1Path, 0, false, 5, "", "", true, Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
            xlWorksheettemp = xlWorkbookTemp.Sheets[1];

            xlWorksheettemp.Range[xlWorksheettemp.Cells[Type.Missing, 28], xlWorksheettemp.Cells[Type.Missing, 28]].EntireColumn.Delete();
            _lastRowUsed = xlWorksheettemp.Cells[Type.Missing, 2].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            xlWorksheettemp.Range[xlWorksheettemp.Cells[2, 2], xlWorksheettemp.Cells[_lastRowUsed, 2]].Copy();
            xlWorksheet.Range[xlWorksheet.Cells[3, 1], xlWorksheet.Cells[3, 1]].PasteSpecial(Excel.XlPasteType.xlPasteAll, Excel.XlPasteSpecialOperation.xlPasteSpecialOperationNone, Type.Missing, Type.Missing);

            xlWorksheettemp.Range[xlWorksheettemp.Cells[2, 13], xlWorksheettemp.Cells[_lastRowUsed, 13]].Copy();
            xlWorksheet.Range[xlWorksheet.Cells[3, 2], xlWorksheet.Cells[3, 2]].PasteSpecial(Excel.XlPasteType.xlPasteAll, Excel.XlPasteSpecialOperation.xlPasteSpecialOperationNone, Type.Missing, Type.Missing);

            xlWorksheettemp.Range[xlWorksheettemp.Cells[2, 6], xlWorksheettemp.Cells[_lastRowUsed, 6]].Copy();
            xlWorksheet.Range[xlWorksheet.Cells[3, 3], xlWorksheet.Cells[3, 3]].PasteSpecial(Excel.XlPasteType.xlPasteAll, Excel.XlPasteSpecialOperation.xlPasteSpecialOperationNone, Type.Missing, Type.Missing);

            xlWorksheettemp.Range[xlWorksheettemp.Cells[2, 3], xlWorksheettemp.Cells[_lastRowUsed, 3]].Copy();
            xlWorksheet.Range[xlWorksheet.Cells[3, 4], xlWorksheet.Cells[3, 4]].PasteSpecial(Excel.XlPasteType.xlPasteAll, Excel.XlPasteSpecialOperation.xlPasteSpecialOperationNone, Type.Missing, Type.Missing);

            xlWorksheettemp.Range[xlWorksheettemp.Cells[2, 16], xlWorksheettemp.Cells[_lastRowUsed, 16]].Copy();
            xlWorksheet.Range[xlWorksheet.Cells[3, 5], xlWorksheet.Cells[3, 5]].PasteSpecial(Excel.XlPasteType.xlPasteAll, Excel.XlPasteSpecialOperation.xlPasteSpecialOperationNone, Type.Missing, Type.Missing);

            xlWorksheettemp.Range[xlWorksheettemp.Cells[2, 23], xlWorksheettemp.Cells[_lastRowUsed, 23]].Copy();
            xlWorksheet.Range[xlWorksheet.Cells[3, 6], xlWorksheet.Cells[3, 6]].PasteSpecial(Excel.XlPasteType.xlPasteAll, Excel.XlPasteSpecialOperation.xlPasteSpecialOperationNone, Type.Missing, Type.Missing);

            xlWorksheettemp.Range[xlWorksheettemp.Cells[2, 27], xlWorksheettemp.Cells[_lastRowUsed, 27]].Copy();
            xlWorksheet.Range[xlWorksheet.Cells[3, 7], xlWorksheet.Cells[3, 7]].PasteSpecial(Excel.XlPasteType.xlPasteAll, Excel.XlPasteSpecialOperation.xlPasteSpecialOperationNone, Type.Missing, Type.Missing);

            xlWorksheettemp.Range[xlWorksheettemp.Cells[2, 26], xlWorksheettemp.Cells[_lastRowUsed, 26]].Copy();
            xlWorksheet.Range[xlWorksheet.Cells[3, 8], xlWorksheet.Cells[3, 8]].PasteSpecial(Excel.XlPasteType.xlPasteAll, Excel.XlPasteSpecialOperation.xlPasteSpecialOperationNone, Type.Missing, Type.Missing);
            xlWorkbookTemp.Close(false);


            Excel.Range dataRange = xlWorksheet.Range[xlWorksheet.Cells[3, 1], xlWorksheet.Cells[_lastRowUsed, 8]];
            dataRange.Sort(
                dataRange.Columns[4, Type.Missing],
                Excel.XlSortOrder.xlDescending, Type.Missing,
                Type.Missing, Excel.XlSortOrder.xlDescending,
                Type.Missing, Excel.XlSortOrder.xlDescending,
                Excel.XlYesNoGuess.xlGuess, Type.Missing,
                Type.Missing, Excel.XlSortOrientation.xlSortColumns,
                Excel.XlSortMethod.xlPinYin, Excel.XlSortDataOption.xlSortNormal,
                Excel.XlSortDataOption.xlSortNormal, Excel.XlSortDataOption.xlSortNormal);

            Excel.Range selRange = xlWorksheet.Cells[1, 2];
            selRange.Select();

            xlWorkbookTemp = xlApp.Workbooks.Open(temp2Path, 0, false, 5, "", "", true, Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);

            xlWorkbookTemp.Sheets.Move(xlWorksheet, Type.Missing);

            xlWorksheet = xlWorkbook.Sheets[1];

            Excel.Range mergeSel = xlWorksheet.Range[xlWorksheet.Cells[8, 1], xlWorksheet.Cells[8, (int)xlWorksheet.UsedRange.Columns.Count]];
            mergeSel.UnMerge();

            xlWorkbook.SaveCopyAs(Environment.GetFolderPath(Environment.SpecialFolder.Desktop).ToString() + "/Transfer Locations - .xlsx");
            xlWorkbook.Close();
            xlApp.Quit();
            Marshal.ReleaseComObject(xlApp);
            MessageBox.Show("File Created: " + Environment.GetFolderPath(Environment.SpecialFolder.Desktop).ToString() + "/Transfer Locations - .xlsx");
        }
    }
}
