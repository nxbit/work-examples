using System;
using System.IO;
using System.Windows.Forms;
using Excel = Microsoft.Office.Interop.Excel;

namespace ETDAutomation
{
    static class ETDAuto
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        public static void ETDFullAuto(string reporttemp, string datadownload)
        {
            string ReportTempPath = "";
            string ETDDataPath = "";

            if (reporttemp == "")
            {
                OpenFileDialog openFileDialog = new OpenFileDialog();
                if(openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    ReportTempPath = openFileDialog.FileName;
                }
                
                openFileDialog.Dispose();
            }
            else { ReportTempPath = reporttemp + "\\ETDReportTemp.xlsx"; }

            if (datadownload == "")
            {
                OpenFileDialog openFileDialog = new OpenFileDialog();
                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    ETDDataPath = openFileDialog.FileName;
                }
                
                openFileDialog.Dispose();
            }
            else { ETDDataPath = datadownload + "\\ETD.xlsx"; }


            Excel.Application xlApp;
            Excel.Workbook xlWorkBook;
            Excel.Worksheet xlWorksheet;

            xlApp = new Excel.Application();
            xlApp.Visible = true;
            xlApp.DisplayAlerts = false;

            xlWorkBook = xlApp.Workbooks.Open(ReportTempPath);
            xlWorksheet = xlWorkBook.Sheets[2];
            xlWorksheet.Activate();

            Excel.Range DelRange = xlWorksheet.Range[xlWorksheet.Cells[4, 1], xlWorksheet.Cells[xlWorksheet.UsedRange.Rows.Count, 10]];
            DelRange.Delete(Excel.XlDeleteShiftDirection.xlShiftUp);

            Excel.Workbook xlWorkbook2;
            Excel.Worksheet xlWorksheet2;

            xlWorkbook2 = xlApp.Workbooks.Open(ETDDataPath);
            xlWorksheet2 = xlWorkbook2.Sheets[1];
            xlWorksheet2.Activate();

            Excel.Range CopyRange = xlWorksheet2.Range[xlWorksheet2.Cells[2, 1], xlWorksheet2.Cells[xlWorksheet2.UsedRange.Rows.Count, 10]];
            CopyRange.Copy();

            Excel.Range PasteRange = xlWorksheet.Cells[4, 1];

            PasteRange.PasteSpecial();

            xlWorkbook2.Close(false);

            xlWorkBook.RefreshAll();

            xlWorksheet = xlWorkBook.Sheets[1];
            xlWorksheet.Activate();
            xlWorksheet.Cells[1, 6].Select();

            xlWorkBook.SaveAs(Environment.GetFolderPath(Environment.SpecialFolder.Desktop) + "\\ETD - Report - .xlsx");
            xlWorkBook.Close(true);
            xlApp.Quit();
            MessageBox.Show("File Created: " + Environment.GetFolderPath(Environment.SpecialFolder.Desktop) + "\\ETD - Report - .xlsx");














            //Application.EnableVisualStyles();
            //Application.SetCompatibleTextRenderingDefault(false);
            //Application.Run(new Form1());
        }
    }
}
