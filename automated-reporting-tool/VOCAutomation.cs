using System;
using System.Windows.Forms;
using Excel = Microsoft.Office.Interop.Excel;

namespace VOCAutomation
{
    static class VOCAuto
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        public static void FullVOCAuto(string dlPath, string rPath)
        {
            string xlFileVOCPath = "";
            if (dlPath != "") { xlFileVOCPath = dlPath + "\\VOC Agent Details.xlsx"; }
            else { OpenFileDialog openFileDialog = new OpenFileDialog();
                if (openFileDialog.ShowDialog() == DialogResult.OK) {
                    xlFileVOCPath = openFileDialog.FileName;
                }
                openFileDialog.Dispose();
            }

            Excel.Application xlApp = new Excel.Application
            {
                Visible = true,
                DisplayAlerts = false,
            };
            Excel.Workbook xlVocWrkBook = xlApp.Workbooks.Open(xlFileVOCPath);
            Excel.Worksheet xlVocWrkSheet = xlVocWrkBook.Sheets[1];

            _ = xlVocWrkSheet.get_Range("G1", Type.Missing).EntireColumn.Delete(Type.Missing);

            int VocWrkSheetLastRowUsed = xlVocWrkSheet.Cells.Find(
                "*",
                Type.Missing,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                Type.Missing,
                Type.Missing).Row;



            string xlVocTemp = "";
            if (rPath != "")
            {
                xlVocTemp = rPath + "\\VOCTemp.xlsx";
            }
            else
            {
                FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog();
                if(folderBrowserDialog.ShowDialog() == DialogResult.OK)
                {
                    xlVocTemp = folderBrowserDialog.SelectedPath + "\\VOCTemp.xlsx";
                }
            }

            Excel.Workbook xlVocTempWrkBook = xlApp.Workbooks.Open(xlVocTemp);
            Excel.Worksheet xlVocTempWrkSheet = xlVocTempWrkBook.Sheets[1];

            int VocTempWrkSheetLastRowUsed = xlVocTempWrkSheet.Cells.Find(
                "*",
                Type.Missing,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                Type.Missing,
                Type.Missing).Row;

            Excel.Range DelRange = xlVocTempWrkSheet.Range[xlVocTempWrkSheet.Cells[3, 1], xlVocTempWrkSheet.Cells[VocTempWrkSheetLastRowUsed, 12]];
            DelRange.Delete(Type.Missing);

            Excel.Range CopyRange = xlVocWrkSheet.Range[xlVocWrkSheet.Cells[2, 1], xlVocWrkSheet.Cells[VocWrkSheetLastRowUsed, 12]];
            CopyRange.Copy();

            Excel.Range PasteCell = xlVocTempWrkSheet.Cells[3, 1];
            PasteCell.PasteSpecial(Excel.XlPasteType.xlPasteAll, Excel.XlPasteSpecialOperation.xlPasteSpecialOperationNone, false, false);

            xlVocWrkBook.Close();

            xlVocTempWrkSheet.Cells[1, 1].Value = "VOC Details - Updated " + DateTime.Now.ToString("MM/d");



            int TodaysDate = DateTime.Now.Day;
            int TodaysMonth = DateTime.Now.Month;
            int TodaysYear = DateTime.Now.Year;
            //int CurrentFiscalMonth = 0;


            string date = DateTime.Parse(xlVocTempWrkSheet.Cells[3, 4].Value.ToString()).ToString();
            string FiscalDate = "";
            if (DateTime.Today >= DateTime.Parse(date))
            {
                if (TodaysMonth == 12)
                    TodaysMonth = 0;
                FiscalDate = (TodaysMonth + 1).ToString() + "/29/" + (TodaysYear + 1).ToString();

            }
            else
            {
                FiscalDate = (TodaysMonth).ToString() + "/29/" + (TodaysYear).ToString();
            }

            xlVocTempWrkSheet.Name = "VOC Details - " + DateTime.Parse(FiscalDate).ToString("MMM") + " " + DateTime.Parse(FiscalDate).ToString("yy");


            string SavePath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop).ToString() + "\\VOC Details - " + DateTime.Parse(FiscalDate).ToString("MMM") + " " + DateTime.Parse(FiscalDate).ToString("yy") + ".xlsx";
            xlVocTempWrkBook.SaveAs(SavePath);
            xlVocTempWrkBook.Close();

            xlApp.Quit();

            MessageBox.Show("File Created: " + SavePath);












            //Application.EnableVisualStyles();
            //Application.SetCompatibleTextRenderingDefault(false);
            //Application.Run(new Form1());
        }
    }
}
