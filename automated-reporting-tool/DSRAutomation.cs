using System;
using System.IO;
using System.Windows.Forms;
using Excel = Microsoft.Office.Interop.Excel;

namespace DSRAutomation
{
    public static class Automation
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        public static void RunDSR(string folderPath1)
        {
            // Fiscal Month String used in naming of Excel Tabs
            string fiscalMonth = null;
            if (DateTime.Now.Day >= 29)
                fiscalMonth = DateTime.Now.AddMonths(
                    
                    
                    
                    
                    
                    
                    1).ToString("MMM");
            else
                fiscalMonth = DateTime.Now.ToString("MMM");


            string folderPath = null;
            if (folderPath1 == "")
            {
                FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog();
                if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
                {
                    folderPath = folderBrowserDialog.SelectedPath;
                }
            }
            else
            {
                folderPath = folderPath1;
            }
            // Checks if needed files exist in selected directory
            if (File.Exists(folderPath + "/Agent DSR.xlsx") && File.Exists(folderPath + "/Agent DSR woHeaders.xlsx") && File.Exists(folderPath + "/Supervisor DSR.xlsx") &&
                File.Exists(folderPath + "/Supervisor DSR woHeaders.xlsx") && File.Exists(folderPath + "/Manager DSR.xlsx") && File.Exists(folderPath + "/Manager DSR woHeaders.xlsx"))
            {
                // Open the Worksheet
                Excel.Application xlApp;
                xlApp = new Excel.Application();
                Excel.Workbook agentWbookWOHeaders;
                Excel.Worksheet agentWsheetWOHeaders;
                agentWbookWOHeaders = xlApp.Workbooks.Open(folderPath + "/Agent DSR.xlsx", 0, false, 5, "DgZf9x?$", "", true, Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
                xlApp.Visible = true;
                xlApp.DisplayAlerts = false;
                agentWsheetWOHeaders = agentWbookWOHeaders.Sheets[1];
                agentWsheetWOHeaders.Activate();

                // Copy the Header Row
                agentWsheetWOHeaders.get_Range("Q2", "U3").Cells.Font.Size = 9;
                agentWsheetWOHeaders.get_Range("I5", "O9").Cells.Font.Size = 9;
                agentWsheetWOHeaders.get_Range("A6").EntireRow.RowHeight = 57;
                agentWsheetWOHeaders.get_Range("B2", "AQ7").CopyPicture(Excel.XlPictureAppearance.xlScreen, Excel.XlCopyPictureFormat.xlBitmap);

                // Open the Main Worksheet
                Excel.Workbook agentWbookHeaders;
                Excel.Worksheet agentWsheetHeaders;
                agentWbookHeaders = xlApp.Workbooks.Open(folderPath + "/Agent DSR woHeaders.xlsx", 0, false, 5, "DgZf9x?$", "", true, Microsoft.Office.Interop.Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
                //xlApp.Visible = true;
                agentWsheetHeaders = agentWbookHeaders.Sheets[1];
                agentWsheetHeaders.Activate();

                // Paste the copied Header
                agentWsheetHeaders.get_Range("A1", "A1").EntireRow.RowHeight = 162;
                agentWsheetHeaders.get_Range("A1", "A1").Select();
                agentWsheetHeaders.Paste();
                agentWsheetHeaders.Range[agentWsheetHeaders.Cells[3, 1], agentWsheetHeaders.Cells[agentWsheetHeaders.Rows.Count, 33]].AutoFilter();
                Excel.Range agentRange = agentWsheetHeaders.Range[agentWsheetHeaders.Cells[4, 1], agentWsheetHeaders.Cells[agentWsheetHeaders.Rows.Count, 33]];
                agentRange.Sort(agentWsheetHeaders.Range[agentWsheetHeaders.Cells[4, 13], agentWsheetHeaders.Cells[agentWsheetHeaders.Rows.Count, 13]], Excel.XlSortOrder.xlAscending);

                agentWsheetHeaders.Name = "Agent DSR - " + fiscalMonth;

                agentWbookWOHeaders.Close(false);

                // Open the Worksheet
                // xlApp = new Excel.Application();
                Excel.Workbook supervisorWbookWOHeaders;
                Excel.Worksheet supervisorWsheetWOHeaders;
                supervisorWbookWOHeaders = xlApp.Workbooks.Open(folderPath + "/Supervisor DSR.xlsx", 0, false, 5, "DgZf9x?$", "", true, Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
                // xlApp.Visible = true;
                supervisorWsheetWOHeaders = supervisorWbookWOHeaders.Sheets[1];
                supervisorWsheetWOHeaders.Activate();

                // Copy the Header Row
                supervisorWsheetWOHeaders.get_Range("S1", "AC2").Cells.Font.Size = 8;
                supervisorWsheetWOHeaders.get_Range("A1", "BD10").CopyPicture(Excel.XlPictureAppearance.xlScreen, Excel.XlCopyPictureFormat.xlBitmap);

                // Open the Main Worksheet
                Excel.Workbook supervisorWBookHeaders;
                Excel.Worksheet supervisorWsheetHeaders;
                supervisorWBookHeaders = xlApp.Workbooks.Open(folderPath + "/Supervisor DSR woHeaders.xlsx", 0, false, 5, "DgZf9x?$", "", true, Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
                // xlApp.Visible = true;
                supervisorWsheetHeaders = supervisorWBookHeaders.Sheets[1];
                supervisorWsheetHeaders.Activate();

                supervisorWsheetHeaders.Range[supervisorWsheetHeaders.Cells[3, 1], supervisorWsheetHeaders.Cells[supervisorWsheetHeaders.Rows.Count, 56]].AutoFilter();
                Excel.Range supRange = supervisorWsheetHeaders.Range[supervisorWsheetHeaders.Cells[4, 5], supervisorWsheetHeaders.Cells[supervisorWsheetHeaders.Rows.Count, 5]];
                supRange.Sort(supervisorWsheetHeaders.Range[supervisorWsheetHeaders.Cells[4, 5], supervisorWsheetHeaders.Cells[supervisorWsheetHeaders.Rows.Count, 5]], Excel.XlSortOrder.xlAscending);

                Excel.Range lastrow = supervisorWsheetHeaders.Cells.SpecialCells(Excel.XlCellType.xlCellTypeLastCell, Type.Missing);
                int lastRowUsed = lastrow.Row;

                for (int row = 4, rank = 1; row <= lastRowUsed; row++, rank++)
                {
                    supervisorWsheetHeaders.Cells[row, 5] = rank;
                }

                // Paste the copied Header
                supervisorWsheetHeaders.get_Range("A1", "A1").EntireRow.RowHeight = 180;
                supervisorWsheetHeaders.get_Range("A1", "A1").Select();
                supervisorWsheetHeaders.Name = "Supervisor DSR - " + fiscalMonth;
                supervisorWsheetHeaders.Paste();

                supervisorWbookWOHeaders.Close(false);

                // Open the Worksheet
                //  xlApp = new Excel.Application();
                Excel.Workbook managerWbookWOHeaders;
                Excel.Worksheet managerWsheetWOHeaders;
                managerWbookWOHeaders = xlApp.Workbooks.Open(folderPath + "/Manager DSR.xlsx", 0, false, 5, "DgZf9x?$", "", true, Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
                //  xlApp.Visible = true;
                managerWsheetWOHeaders = managerWbookWOHeaders.Sheets[1];
                managerWsheetWOHeaders.Activate();

                // Copy the Header Row
                managerWsheetWOHeaders.get_Range("V1", "AF2").Cells.Font.Size = 8;
                managerWsheetWOHeaders.get_Range("A1", "BC10").CopyPicture(Excel.XlPictureAppearance.xlScreen, Excel.XlCopyPictureFormat.xlBitmap);

                // Open the Main Worksheet
                Excel.Workbook managerWbookHeaders;
                Excel.Worksheet managerWsheetHeaders;
                managerWbookHeaders = xlApp.Workbooks.Open(folderPath + "/Manager DSR woHeaders.xlsx", 0, false, 5, "DgZf9x?$", "", true, Microsoft.Office.Interop.Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
                //  xlApp.Visible = true;
                managerWsheetHeaders = managerWbookHeaders.Sheets[1];
                managerWsheetHeaders.Activate();

                // Paste the copied Header
                managerWsheetHeaders.get_Range("A1", "A1").EntireRow.RowHeight = 180;
                managerWsheetHeaders.get_Range("A1", "A1").Select();
                managerWsheetHeaders.Paste();
                managerWsheetHeaders.Name = "Manager DSR - " + fiscalMonth;
                managerWsheetHeaders.Range[managerWsheetHeaders.Cells[2, 1], managerWsheetHeaders.Cells[managerWsheetHeaders.Rows.Count, 56]].AutoFilter();
                Excel.Range range = managerWsheetHeaders.Range[managerWsheetHeaders.Cells[3, 1], managerWsheetHeaders.Cells[managerWsheetHeaders.Rows.Count, 56]];
                //managerWsheetHeaders.Range[managerWsheetHeaders.Cells[2, 1], managerWsheetHeaders.Cells[managerWsheetHeaders.Rows.Count, 56]].AutoFileter.Sort.
                range.Sort(managerWsheetHeaders.Range[managerWsheetHeaders.Cells[3, 5], managerWsheetHeaders.Cells[managerWsheetHeaders.Rows.Count, 5]], Excel.XlSortOrder.xlAscending);

                lastrow = managerWsheetHeaders.Cells.SpecialCells(Excel.XlCellType.xlCellTypeLastCell, Type.Missing);
                lastRowUsed = lastrow.Row;
                for (int row = 3, rank = 1; row < lastRowUsed; row++, rank++)
                {
                    managerWsheetHeaders.Cells[row, 5] = rank;
                }

                managerWbookWOHeaders.Close(false);

                supervisorWBookHeaders.Sheets.Move(Type.Missing, agentWsheetHeaders);
                managerWbookHeaders.Sheets.Move(Type.Missing, agentWsheetHeaders);
                agentWsheetHeaders.Move(Before: agentWbookHeaders.Sheets[1]);
                supervisorWsheetHeaders = agentWbookHeaders.Sheets[3];
                supervisorWsheetHeaders.Move(Before: agentWbookHeaders.Sheets[2]);
                agentWsheetHeaders.Select();

                agentWsheetHeaders = agentWbookHeaders.Sheets[1];

                agentWsheetHeaders.Cells[2, 13].Value = "Ruby Meter";
                Excel.Range hyperlink = agentWsheetHeaders.Range[agentWsheetHeaders.Cells[2, 13], agentWsheetHeaders.Cells[2, 13]];
                hyperlink.Hyperlinks.Add(hyperlink, @"https://sharepoint.charter.com/ops/El_Paso_CSI/Shared%20Documents/Ruby%20Meter%20-%20Nov%2019.xlsx",Type.Missing,Type.Missing, "Ruby Meter");



                agentWbookHeaders.SaveAs(Environment.GetFolderPath(Environment.SpecialFolder.Desktop).ToString() + "/Daily Local Stack Rank - " + fiscalMonth + ".xlsx");

                agentWbookHeaders.Close();
                xlApp.Quit();
                MessageBox.Show("File Created - " + Environment.GetFolderPath(Environment.SpecialFolder.Desktop).ToString() + "/Daily Local Stack Rank - " + fiscalMonth + ".xlsx");
            }
            else { MessageBox.Show("Missing Files"); }
        }
    }
}