using System;
using System.IO;
using System.Windows.Forms;
using Excel = Microsoft.Office.Interop.Excel;

namespace WorkOrderDetailsAuto
{
    static class WorkOrderDetailsAuto
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        public static void FullAuto(string DataDownloadFolder, string ReportTempFolder)
        {
            string WorkOrderInsights = "";
            string WorkOrderTemp = "";
            string RosterLocation = "";


            if(DataDownloadFolder == "")
            {
                OpenFileDialog openFileDialog = new OpenFileDialog();
                if(openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    WorkOrderInsights = openFileDialog.FileName;
                }
            }
            else { WorkOrderInsights = DataDownloadFolder + "\\Work Order insights.xlsx"; }
            if (DataDownloadFolder == "")
            {
                OpenFileDialog openFileDialog = new OpenFileDialog();
                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    RosterLocation = openFileDialog.FileName;
                }
            }
            else { RosterLocation = DataDownloadFolder + "\\Roster.xls"; }
            if (ReportTempFolder == "")
            {
                OpenFileDialog openFileDialog = new OpenFileDialog();
                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    WorkOrderTemp = openFileDialog.FileName;
                }
            }
            else { WorkOrderTemp = ReportTempFolder + "\\WorkOrderTemp.xlsx"; }




            Excel.Application xlApp;
            Excel.Workbook xlWorkBook;
            Excel.Worksheet xlWorksheet;
            Excel.Workbook xlWOTempBook;
            Excel.Worksheet xlWOTempSheet;

            xlApp = new Excel.Application();
            xlApp.Visible = true;
            xlApp.DisplayAlerts = false;

            xlWorkBook = xlApp.Workbooks.Open(WorkOrderInsights);
            xlWorksheet = xlWorkBook.Sheets[1];
            xlWorksheet.Activate();

            xlWOTempBook = xlApp.Workbooks.Open(WorkOrderTemp);
            xlWOTempSheet = xlWOTempBook.Sheets[1];


            Excel.Range DelRange = xlWorksheet.Cells[1, 5].EntireColumn;
            DelRange.Delete(Excel.XlDeleteShiftDirection.xlShiftToLeft);

            Excel.Range CutRange = xlWorksheet.Cells[1, 7].EntireColumn;
            CutRange.Cut();
            Excel.Range PasteCutRange = xlWorksheet.Cells[1, 5].EntireColumn;
            PasteCutRange.Insert(Excel.XlInsertShiftDirection.xlShiftToRight);

            Excel.Range InsertRange = xlWorksheet.Cells[1, 3].EntireColumn;
            InsertRange.Insert(Excel.XlInsertShiftDirection.xlShiftToRight);

            Excel.Workbook xlRosterBook;
            Excel.Worksheet xlRosterSheet;

            xlRosterBook = xlApp.Workbooks.Open(RosterLocation);
            xlRosterSheet = xlRosterBook.Sheets[1];
            xlRosterSheet.Activate();

            Excel.Range RosterNameRange = xlRosterSheet.Cells[1, 4].EntireColumn;
            RosterNameRange.Insert(Excel.XlInsertShiftDirection.xlShiftToRight);

            xlRosterSheet.Cells[1, 4].Value = "Full Name";
            xlRosterSheet.Cells[2, 4].Value = "=C2&\", \"&B2";
            Excel.Range RosterCellRange = xlRosterSheet.Cells[2, 4];
            RosterCellRange.AutoFill(xlRosterSheet.Range[xlRosterSheet.Cells[2, 4], xlRosterSheet.Cells[xlRosterSheet.UsedRange.Rows.Count, 4]]);

            Excel.Range xlCellRange = xlWorksheet.Cells[2, 3];

            xlCellRange.Value = @"=INDEX(Roster.xls!$D:$D,MATCH(D2,Roster.xls!$P:$P,0),1)";
            xlCellRange.AutoFill(xlWorksheet.Range[xlWorksheet.Cells[2, 3], xlWorksheet.Cells[xlWorksheet.UsedRange.Rows.Count, 3]]);

            xlWorksheet.Range[xlWorksheet.Cells[1, 1], xlWorksheet.Cells[xlWorksheet.UsedRange.Rows.Count, xlWorksheet.UsedRange.Columns.Count]].Copy();
            Excel.Range pasteRange = xlWorksheet.Cells[1, 1];
            pasteRange.PasteSpecial(Excel.XlPasteType.xlPasteValuesAndNumberFormats);

            xlRosterBook.Close(false);

            Excel.Range CopyRange = xlWorksheet.Range[xlWorksheet.Cells[2, 1], xlWorksheet.Cells[xlWorksheet.UsedRange.Rows.Count, xlWorksheet.UsedRange.Columns.Count]];
            CopyRange.Copy();

            pasteRange = xlWOTempSheet.Cells[3, 1];

            pasteRange.PasteSpecial();

            xlWorkBook.Close(false);

            xlWOTempSheet.Cells[1, 1].Value = "Work Order Details - Updated on " + DateTime.Now.ToString("MM/dd");

            xlWOTempBook.SaveAs(Environment.GetFolderPath(Environment.SpecialFolder.Desktop) + "\\Work Order Details.xlsx");
            xlWOTempBook.Close(false);
            xlApp.Quit();
            MessageBox.Show(Environment.GetFolderPath(Environment.SpecialFolder.Desktop) + "\\Work Order Details.xlsx");







            //Application.EnableVisualStyles();
            //Application.SetCompatibleTextRenderingDefault(false);
            //Application.Run(new Form1());
        }
    }
}
