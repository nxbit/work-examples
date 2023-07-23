using System;
using System.Windows.Forms;
using Excel = Microsoft.Office.Interop.Excel;

namespace IRISAutomation
{
    public static class IRISAuto
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
            xlWorkbook = xlApp.Workbooks.Open(folderpath + "/Agent Daily IRIS Usage.xlsx", 0, false, 5, "", "", true, Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
            xlApp.Visible = true;
            xlApp.DisplayAlerts = false;
            xlWorksheet = xlWorkbook.Sheets[1];
            xlWorksheet.Activate();

            //Copy Header Row
            xlWorksheet.get_Range("A1", "J6").CopyPicture(Excel.XlPictureAppearance.xlScreen, Excel.XlCopyPictureFormat.xlBitmap);

            Excel.Workbook xlWorkbook1;
            Excel.Worksheet xlWorksheet2;
            xlWorkbook1 = xlApp.Workbooks.Open(folderpath + "/Agent Daily IRIS Usage wo Header.xlsx", 0, false, 5, "", "", true, Microsoft.Office.Interop.Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
            xlWorksheet2 = xlWorkbook1.Sheets[1];
            xlWorksheet2.Activate();

            xlWorksheet2.Range[xlWorksheet2.Cells[1, 1], xlWorksheet2.Cells[1, 1]].RowHeight = 96;
            xlWorksheet2.get_Range("A1", "A1").Select();
            xlWorksheet2.Paste();
            xlWorksheet2.Name = "Agent IRIS - ";

            xlWorkbook.Close(false);

            // Open File with Header
            Excel.Workbook xlWorkbook3;
            Excel.Worksheet xlWorksheet3;
            xlWorkbook3 = xlApp.Workbooks.Open(folderpath + "/Supervisor Daily IRIS Usage.xlsx", 0, false, 5, "", "", true, Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
            xlWorksheet3 = xlWorkbook3.Sheets[1];
            xlWorksheet3.Activate();

            //Copy Header Row
            xlWorksheet3.get_Range("A1", "I3").CopyPicture(Excel.XlPictureAppearance.xlScreen, Excel.XlCopyPictureFormat.xlBitmap);

            xlWorkbook3.Close(false);

            // Open File with Header
            Excel.Workbook xlWorkbook4;
            Excel.Worksheet xlWorksheet4;
            xlWorkbook4 = xlApp.Workbooks.Open(folderpath + "/Supervisor Daily IRIS Usage wo Headers.xlsx", 0, false, 5, "", "", true, Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
            xlWorksheet4 = xlWorkbook4.Sheets[1];
            xlWorksheet4.Activate();

            xlWorksheet4.Range[xlWorksheet4.Cells[1, 1], xlWorksheet4.Cells[1, 1]].RowHeight = 88.5;
            xlWorksheet4.get_Range("A1", "A1").Select();
            xlWorksheet4.Paste();
            xlWorksheet4.Name = "Supervisor IRIS - ";

            xlWorkbook1.Sheets.Move(Type.Missing, xlWorksheet4);

            string savePath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
            xlWorkbook4.SaveCopyAs(savePath + "/IRIS Usage by Team_Daily - .xlsx");
            xlWorkbook4.Close(false);
            xlApp.Quit();

            MessageBox.Show("File Saved: " + savePath + "/IRIS Usage by Team_Daily - .xlsx");
        }
    }
}