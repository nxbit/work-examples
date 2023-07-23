using Microsoft.Office.Interop.Access;
using System;
using System.Data.OleDb;
using System.IO;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using Access = Microsoft.Office.Interop.Access;
using Excel = Microsoft.Office.Interop.Excel;
using System.Threading;

namespace AATAutomations
{
    /*
    *   AATAutomation contains all the nessary functions to automate the
    *   Tasks sorrounding the AAT tool.
    */

    public static class AATAutoFunctions
    {
        //
        //
        // ExportQuery - Runs Export based on Query Name
        //               and outputs the file to an Excel Document
        //
        private static void ExportQuery(string databaseLocation, string queryNameToExport, string locationToExportTo)
        {
            var application = new Access.Application();
            application.OpenCurrentDatabase(databaseLocation);
            application.DoCmd.TransferSpreadsheet(AcDataTransferType.acExport, AcSpreadSheetType.acSpreadsheetTypeExcel12Xml,
                                                  queryNameToExport, locationToExportTo, true);
            application.CloseCurrentDatabase();
            application.Quit();
            Marshal.ReleaseComObject(application);
        }

        //
        // TrimAAT - Trims the AAT Tool from a Specific Date and on
        //
        //
        public static void TrimAAT(string databaseLocation, string Date, string Date2)
        {
            /*
            Access.Application application = new Access.Application
            {
                Visible = true
            };
            
            
                application.OpenCurrentDatabase(databaseLocation);
                string sqlCommand = @"DELETE FROM History WHERE History.[Request Created On] >= '"+Date.ToString()+@"' AND History.[Request Created On] <= '"+Date2.ToString()+@"';";
                
                    application.DoCmd.RunSQL(sqlCommand.ToString(), Type.Missing);
                
                application.CloseCurrentDatabase();
                application.Quit();
                Marshal.ReleaseComObject(application);
                MessageBox.Show("AAT Trim Sucessfull.");
            */
            string sqlCommand = @"DELETE FROM History WHERE History.[Request Created On] >= '" + Date.ToString() + @"' AND History.[Request Created On] <= '" + Date2.ToString() + @"';";
            var AATAccessPath = databaseLocation;
            OleDbConnection AATConnection = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + AATAccessPath);
            AATConnection.Open();
            using (OleDbCommand command = new OleDbCommand(sqlCommand, AATConnection))
            {
                command.ExecuteNonQuery();
            }

            MessageBox.Show("AAT Trim Complete");



        }

        //
        // getData - Will aquire the AAT Access File location and save file location
        //          for the excel export getData will produce.
        //
        public static void GetData(string filepath1, string filepath2)
        {
            // Gather the file and save path and Call the ExportQuery function
            string filePath = "";
            string savePath = "";
            if (filepath1 == "")
            {
                OpenFileDialog openFileDialog = new OpenFileDialog();
                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    filePath = openFileDialog.FileName.ToString();
                }
                FolderBrowserDialog openFolderDialog = new FolderBrowserDialog();
                if (openFolderDialog.ShowDialog() == DialogResult.OK)
                {
                    savePath = openFolderDialog.SelectedPath.ToString();
                }
            }
            else
            {
                filePath = filepath1 + "\\AATAccess.mdb";
                savePath = filepath2;
            }
            ExportQuery(filePath, "History Query", savePath + "\\AATData.xlsx");

            //
            // Open Excel Document and Format
            //
            //
            Excel.Application xlApp = new Excel.Application();
            Excel.Workbook xlWorkbook = xlApp.Workbooks.Open(savePath + "\\AATData.xlsx", 0, false, 5, "", "", true, Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
            Excel.Worksheet xlWorksheet = xlWorkbook.Sheets[1];
            xlWorksheet.Activate();

            Excel.Range usedRange = xlWorksheet.UsedRange;
            usedRange.Replace("_", "", Excel.XlLookAt.xlPart, Excel.XlSearchOrder.xlByRows, false, false, false, false);

            Excel.Range ColRange = xlWorksheet.Cells[1, 21].EntireColumn;
            ColRange.TextToColumns(xlWorksheet.Cells[1, 21].EntireColumn, Excel.XlTextParsingType.xlDelimited,
                Excel.XlTextQualifier.xlTextQualifierDoubleQuote, false, false, false, false, false, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, true);

            ColRange = xlWorksheet.Cells[1, 23].EntireColumn;
            ColRange.TextToColumns(xlWorksheet.Cells[1, 23].EntireColumn, Excel.XlTextParsingType.xlDelimited,
                Excel.XlTextQualifier.xlTextQualifierDoubleQuote, false, false, false, false, false, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, true);

            ColRange = xlWorksheet.Cells[1, 10].EntireColumn;
            ColRange.TextToColumns(xlWorksheet.Cells[1, 10].EntireColumn, Excel.XlTextParsingType.xlDelimited,
                Excel.XlTextQualifier.xlTextQualifierDoubleQuote, false, false, false, false, false, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, true);

            ColRange = xlWorksheet.Cells[1, 11].EntireColumn;
            ColRange.TextToColumns(xlWorksheet.Cells[1, 11].EntireColumn, Excel.XlTextParsingType.xlDelimited,
                Excel.XlTextQualifier.xlTextQualifierDoubleQuote, false, false, false, false, false, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, true);

            xlWorksheet.Cells[1, 1].Select();
            xlWorksheet.Name = "AATData";
            xlWorkbook.Close(true);
            xlApp.Quit();
            Marshal.ReleaseComObject(xlApp);

            MessageBox.Show("AAT Data Export Complete");
        }

        //
        // trimData - Will trim data from the SP AAT site. The AAT Access file location
        //             will be gathered.
        //
        public static void TrimData(string filepath, string Date, string Date2)
        {
            string filePath = "";
            if (filepath == "\\AATAccess.mdb")
            {
                OpenFileDialog openFileDialog = new OpenFileDialog();
                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    filePath = openFileDialog.FileName.ToString();
                }
                openFileDialog.Dispose();
            }
            else { filePath = filepath.ToString(); }
            TrimAAT(filePath, Date, Date2);
        }
    }
}