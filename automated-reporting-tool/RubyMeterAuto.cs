using System;
using System.Windows.Forms;
using Excel = Microsoft.Office.Interop.Excel;

namespace RubyMeterAuto
{
    public static class RubyAuto
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        public static void RunAuto(string folderpath1)
        {
            string folderpath = "";
            if (folderpath1 == "")
            {
                FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog();
                if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
                {
                    folderpath = folderBrowserDialog.SelectedPath.ToString();
                }
            }
            else { folderpath = folderpath1; }

            // Open File with Header
            Excel.Application xlApp;
            xlApp = new Excel.Application();
            Excel.Workbook xlWorkbook;
            Excel.Worksheet xlWorksheet;
            xlWorkbook = xlApp.Workbooks.Open(folderpath + "/Ruby Meter.xlsx", 0, false, 5, "", "", true, Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
            xlApp.Visible = true;
            xlApp.DisplayAlerts = false;
            xlWorksheet = xlWorkbook.Sheets[1];
            xlWorksheet.Activate();

            Excel.Range supColumn = xlWorksheet.Range[xlWorksheet.Cells[1, 2], xlWorksheet.Cells[1, 2]];
            supColumn.ColumnWidth = 28.29;

            xlWorksheet.Shapes.Item(1).IncrementLeft(-143);
            xlWorksheet.Shapes.Item(1).IncrementTop(-5);

            Excel.Range delColumn = xlWorksheet.Range[xlWorksheet.Cells[1, 3], xlWorksheet.Cells[1, 3]];
            delColumn.EntireColumn.Delete();
            delColumn = xlWorksheet.Range[xlWorksheet.Cells[1, 3], xlWorksheet.Cells[1, 3]];
            delColumn.EntireColumn.Delete();

            Excel.Range mergeRange = xlWorksheet.Range[xlWorksheet.Cells[3, 4], xlWorksheet.Cells[3, 5]];
            mergeRange.UnMerge();

            xlWorksheet.Cells[3, 4].Copy();
            Excel.Range pasteRange = xlWorksheet.Cells[3, 3];
            pasteRange.PasteSpecial();
            xlWorksheet.Cells[1, 4].EntireColumn.Delete();
            pasteRange = xlWorksheet.Cells[3, 3];
            pasteRange.ColumnWidth = 28;

            delColumn = xlWorksheet.Cells[1, 5];
            delColumn.EntireColumn.Delete();

            mergeRange = xlWorksheet.Range[xlWorksheet.Cells[3, 3], xlWorksheet.Cells[3, 4]];
            mergeRange.Merge();

            int numberOfQualifed = xlWorksheet.Cells[Type.Missing, 5].EntireColumn.Find("Yes", System.Reflection.Missing.Value, System.Reflection.Missing.Value, System.Reflection.Missing.Value, Excel.XlSearchOrder.xlByRows, Excel.XlSearchDirection.xlPrevious, false, System.Reflection.Missing.Value, System.Reflection.Missing.Value).Row - 7;
            xlWorksheet.Cells[3, 5].Value = numberOfQualifed.ToString() + " Qualified";

            xlWorksheet.Cells[3, 5].Font.Bold();

            xlWorksheet.Range[xlWorksheet.Cells[7, 2], xlWorksheet.Cells[7, 10]].AutoFilter();

            xlWorkbook.SaveCopyAs(Environment.GetFolderPath(Environment.SpecialFolder.Desktop) + "/Ruby Meter - .xlsx");

            xlWorkbook.Close();
            xlApp.Quit();

            MessageBox.Show("File Created: " + Environment.GetFolderPath(Environment.SpecialFolder.Desktop) + "/Ruby Meter - .xlsx");
        }
    }
}