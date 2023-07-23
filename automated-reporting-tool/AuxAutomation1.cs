using System.Windows.Forms;
using Excel = Microsoft.Office.Interop.Excel;

namespace WorkAutomation
{
    internal class AuxAutomation
    {
        public void StartAuxAutomation(string auxTemplateFilePath1, string auxDataFilePath1)
        {
            // Initilize Excel Objects
            Excel.Application xlApp;
            Excel.Workbook xlWorkbook;
            Excel.Workbook xlDataFile;
            Excel.Workbook ssrsWorkbook;
            Excel.Worksheet xlWorksheet;
            Excel.Worksheet xlDataWorksheet;
            Excel.Worksheet ssrsWorksheet;
            xlApp = new Excel.Application
            {
                DisplayAlerts = false
            };

            string auxTemplateFilePath = null;
            string auxDataFilePath = null;
            string srssDataFilePath = null;
            string auxPostedFilePath = System.Environment.GetFolderPath(System.Environment.SpecialFolder.Desktop) + "\\AUX Report - .xlsx";
            if (auxTemplateFilePath1 == "" && auxDataFilePath1 == "")
            {
                // Open File Dialog to grab AUX Template File Path
                OpenFileDialog openFileDialog = new OpenFileDialog
                {
                    Title = "Select AUX Temp File"
                };
                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    auxTemplateFilePath = openFileDialog.FileName.ToString();
                }
                openFileDialog.Dispose();

                
                
                openFileDialog.Title = "Select AUX Data File";
                // Open File Dialog to grab AUX Data File Path
                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    auxDataFilePath = openFileDialog.FileName.ToString();
                }
                openFileDialog.Dispose();
                openFileDialog.Title = "Select AUX Supervisors Files";
                // Open File Dialog to grab AUX Data File Path
                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    srssDataFilePath = openFileDialog.FileName.ToString();
                }

                openFileDialog.Dispose();
            }
            else
            {
                auxTemplateFilePath = auxTemplateFilePath1.ToString() + "/AUXReportTemp.xlsx";
                auxDataFilePath = auxDataFilePath1.ToString() + "/AUXBIData.xlsx";
                srssDataFilePath = auxDataFilePath1.ToString() + "/AUX Supervisors.xlsx";

            }


            xlApp.Visible = true;

            // Open The Excel File
            xlWorkbook = xlApp.Workbooks.Open(auxTemplateFilePath, 0, false, 5, "", "", true, Microsoft.Office.Interop.Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);

            // Unhide Data Tab
            xlWorksheet = xlWorkbook.Worksheets["AUX Data"];
            xlWorksheet.Visible = Excel.XlSheetVisibility.xlSheetVisible;

            //Clear Data from range
            var range = (Excel.Range)xlWorksheet.Range[xlWorksheet.Cells[2, 1], xlWorksheet.Cells[xlWorksheet.UsedRange.Rows.Count, xlWorksheet.UsedRange.Columns.Count]];
            range.Delete(Excel.XlDeleteShiftDirection.xlShiftUp);

            // Open The Excel Data File
            xlDataFile = xlApp.Workbooks.Open(auxDataFilePath, 0, true, 5, "", "", true, Microsoft.Office.Interop.Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);

            // Remove unneeded columns from Data File (Cols F and G)
            xlDataWorksheet = xlDataFile.Worksheets[1];
            var delDataRange = (Excel.Range)xlDataWorksheet.Range["G:G"];
            delDataRange.Delete();
            delDataRange = (Excel.Range)xlDataWorksheet.Range["F:F"];
            delDataRange.Delete();

            // Copy AUX Data into Data Tab
            var dataRange = (Excel.Range)xlDataWorksheet.Range[xlDataWorksheet.Cells[2, 1], xlDataWorksheet.Cells[xlDataWorksheet.UsedRange.Rows.Count, xlDataWorksheet.UsedRange.Columns.Count]];
            dataRange.Copy();
            var PasteDataRange = (Excel.Range)xlWorksheet.Cells[2, 1];
            PasteDataRange.PasteSpecial();
            xlDataFile.Close();

            // Hide Data Tab
            xlWorksheet.Visible = Excel.XlSheetVisibility.xlSheetVeryHidden;

            // Refresh all Pivot Tables
            foreach (Excel.PivotCache pivotTables in xlWorkbook.PivotCaches())
                pivotTables.Refresh();

            // Open The Excel File
            ssrsWorkbook = xlApp.Workbooks.Open(srssDataFilePath, 0, true, 5, "", "", true, Microsoft.Office.Interop.Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
            ssrsWorksheet = ssrsWorkbook.Sheets[1];

            // Move AUX Supervisors Tab to AUX Template
            xlWorkbook.Activate();
            ssrsWorkbook.Sheets.Copy(xlWorksheet);

            // Move AUX Superviors Tab to Beginning of Workbook
            xlWorksheet = xlWorkbook.Sheets["AUX Supervisors"];
            xlWorksheet.Select();
            xlWorksheet.Move(Before: xlWorkbook.Sheets[1]);

            // Close Out Procedures
            xlWorkbook.SaveCopyAs(auxPostedFilePath);
            xlWorkbook.Close(false);
            ssrsWorkbook.Close(false);
            xlApp.Quit();
            MessageBox.Show("AUX File Created: " + auxPostedFilePath.ToString());
        }
    }
}