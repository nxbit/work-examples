using System;
using Excel = Microsoft.Office.Interop.Excel;
using System.Data.SqlClient;
using System.Data;
using System.Windows.Forms;
using WorkAutomation;

namespace aptfullauto
{
    public class APTUpdate
    {
        public string sqlServerAddress = null;
        public string sqlUserName = null;
        public string sqlPassword = null;
        public string sqlDatabase = null;
       



        public void RunAuto(string filepath)
        {
            string SqlConnectionString = "Data Source=" + sqlServerAddress + ",1806" +
                ";Initial Catalog=" + sqlDatabase +
                ";User ID=" + sqlUserName +
                ";Password=" + sqlPassword + ";";
            string FiscalMonthDate = null;
            DateTime yesterday = DateTime.Now.AddDays(-1);
            if (DateTime.Now.AddDays(-1).Day <= 28) { FiscalMonthDate = yesterday.Month - 1 + "/29/" + yesterday.ToString("yyyy"); } else { FiscalMonthDate = yesterday.Month + "/29/" + yesterday.ToString("yyyy"); }


            APTUpdateStatus.APTStatusUpdate.Text = "Running APT Automation";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            // This section updates the Roster Table of the Report Functions Tab
            Excel.Application xlApp;
            xlApp = new Excel.Application();
            Excel.Workbook xlWorkbook;
            Excel.Worksheet xlWorksheet;
            string aptFilePath = null;
            DataTable dataTable = new DataTable();
            xlApp.Visible = true;


            if (filepath == "")
            {
                // Open file Dialog to get location of APT File
                OpenFileDialog openFileDialog = new OpenFileDialog();
                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    aptFilePath = openFileDialog.FileName.ToString();
                }
            }
            else { aptFilePath = filepath + "/2018 and 2019 - Attendance Pattern Tool.xlsm"; }

            APTUpdateStatus.APTStatusUpdate.Text = "Opening APT File";
            APTUpdateStatus.APTStatusUpdate.Refresh();


            //Open APT File and set Caculation to Manual
            xlWorkbook = xlApp.Workbooks.Open(aptFilePath, 0, false, 5, "DgZf9x?$", "", true, Microsoft.Office.Interop.Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);
            xlApp.Calculation = Excel.XlCalculation.xlCalculationManual;


            //Unhide Needed Tabs
            APTUpdateStatus.APTStatusUpdate.Text = "Displaying Hidden Tabs";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            xlWorksheet = xlWorkbook.Sheets["eWFM"];
            xlWorksheet.Visible = Excel.XlSheetVisibility.xlSheetVisible;
            xlWorksheet = xlWorkbook.Sheets["CA Data"];
            xlWorksheet.Visible = Excel.XlSheetVisibility.xlSheetVisible;
            xlWorksheet = xlWorkbook.Sheets["Coaching Doc Data"];
            xlWorksheet.Visible = Excel.XlSheetVisibility.xlSheetVisible;
            xlWorksheet = xlWorkbook.Sheets["Report Functions"];
            xlWorksheet.Visible = Excel.XlSheetVisibility.xlSheetVisible;

            // Select the Report Function Tab
            xlWorksheet = xlWorkbook.Sheets["Report Functions"];
            xlWorksheet.Activate();

            int _lastRowUsed = xlWorksheet.Cells[6, 2].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            //Clearing Formulas on Table
            APTUpdateStatus.APTStatusUpdate.Text = "Clearing Formulas on Superstates Tab";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            Excel.Range deleteRange = xlWorksheet.Range[xlWorksheet.Cells[6, 2], xlWorksheet.Cells[_lastRowUsed, 13]];
            deleteRange.Delete();
            xlWorksheet.Range[xlWorksheet.Cells[((_lastRowUsed - 5) + 2), 24], xlWorksheet.Cells[(((_lastRowUsed - 5)) * 2) + 2, 25]].Delete();

            // Pulling SQL Data
            string connString = SqlConnectionString.ToString();
            string query = @"SELECT Roster.WorkerID AS 'EEID',
        concat(Roster.[First Name], ' ', Roster.[Last Name]) AS 'Employee Name',
		Roster.[Job Title],
		Roster.[Service Date],
		Roster.[Current Position Date],
		Roster.[Entity Account],
		concat(SupervisorRoster.[First Name], ' ', SupervisorRoster.[Last Name]) AS 'Supervisor',
		concat(ManagerRoster.[First Name], ' ', ManagerRoster.[Last Name]) AS 'Manager'
FROM CurrentRoster AS Roster
INNER JOIN SupervisorRoster ON Roster.[Supervisor PID] = SupervisorRoster.[Entity Account]
INNER JOIN ManagerRoster ON SupervisorRoster.[Supervisor PID] = ManagerRoster.[Entity Account]
WHERE(Roster.[Agent Role] = 'Frontline' OR Roster.[Agent Role] = 'Lead') AND(Roster.[Status] = 'Active' OR Roster.[Status] = 'Leave of Absence')";
            APTUpdateStatus.APTStatusUpdate.Text = "Pulling Roster Data from SQL Server";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            SqlConnection conn = new SqlConnection(connString);
            SqlCommand cmd = new SqlCommand(query, conn);
            conn.Open();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dataTable);
            conn.Close();
            da.Dispose();


            // Filling Roster with SQL Data
            for (int rowNumber = 0; rowNumber < dataTable.Rows.Count; rowNumber++)
            {
                for (int colNumber = 0; colNumber < dataTable.Columns.Count; colNumber++)
                {
                    APTUpdateStatus.APTStatusUpdate.Text = "Filling Roster Data " + rowNumber.ToString() + " of " + dataTable.Rows.Count.ToString();
                    APTUpdateStatus.APTStatusUpdate.Refresh();
                    xlWorksheet.Cells[rowNumber + 6, colNumber + 2] = dataTable.Rows[rowNumber][colNumber].ToString();
                }
            }

            //Wrapping up
            APTUpdateStatus.APTStatusUpdate.Text = "Caculating Roster Table Formulas";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            xlWorksheet.Calculate();
            xlWorkbook.RefreshAll();
            APTUpdateStatus.APTStatusUpdate.Text = "Roster Table Update Complete";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            xlWorksheet.Cells[1, 4] = DateTime.Now.ToString();



            // This section updates the Superstates Table



            DataTable dataTable1 = new DataTable();
            xlApp.Calculation = Excel.XlCalculation.xlCalculationManual;
            APTUpdateStatus.APTStatusUpdate.Text = "Opening eWFM Tab";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            xlWorksheet = xlWorkbook.Sheets["eWFM"];
            xlWorksheet.Activate();

            //Grabs lastRow Used of First Table
            _lastRowUsed = xlWorksheet.Cells[6, 2].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            APTUpdateStatus.APTStatusUpdate.Text = "Sorting Superstates Data Table";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            //Sorts the data range in table 1 from least to greatest
            Excel.Range dataRange = xlWorksheet.Range[xlWorksheet.Cells[6, 2], xlWorksheet.Cells[_lastRowUsed, 18]];
            dataRange.Sort(
                dataRange.Columns[10, Type.Missing],
                Excel.XlSortOrder.xlAscending, Type.Missing,
                Type.Missing, Excel.XlSortOrder.xlAscending,
                Type.Missing, Excel.XlSortOrder.xlAscending,
                Excel.XlYesNoGuess.xlGuess, Type.Missing,
                Type.Missing, Excel.XlSortOrientation.xlSortColumns,
                Excel.XlSortMethod.xlPinYin, Excel.XlSortDataOption.xlSortNormal,
                Excel.XlSortDataOption.xlSortNormal, Excel.XlSortDataOption.xlSortNormal);
            //Find Date Range to Clear Yesterday
            DateTime value2 = Convert.ToDateTime(DateTime.Now.AddDays(-366).ToString("MM/dd/yyyy") + " 12:00:00 AM");
            int _yDateRange = 0;
            try
            {
                _yDateRange = xlWorksheet.Cells[6, 11].EntireColumn.Find(value2,
               System.Reflection.Missing.Value,
               Excel.XlFindLookIn.xlValues,
               Excel.XlLookAt.xlWhole,
               Excel.XlSearchOrder.xlByRows,
               Excel.XlSearchDirection.xlPrevious,
               false,
               System.Reflection.Missing.Value,
               System.Reflection.Missing.Value).Row;
                APTUpdateStatus.APTStatusUpdate.Text = "Deleting Greater Than 1 Year Data";
                APTUpdateStatus.APTStatusUpdate.Refresh();
                //Delete Old Date Range
                Excel.Range superStatesDelete = xlWorksheet.Range[xlWorksheet.Cells[6, 2], xlWorksheet.Cells[_yDateRange, 18]];
                superStatesDelete.Delete();
            }
            catch { _yDateRange = 0; }




            //Recaculate the LastRow Used in worksheet
            _lastRowUsed = xlWorksheet.Cells[6, 2].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            //string data for fiscal Month Caculation
            int day = (int)System.DateTime.Now.Day;
            int fmonth = (int)System.DateTime.Now.Month;
            int fyear = (int)System.DateTime.Now.Year;
            if (day <= 29) { fmonth = System.DateTime.Now.Month - 1; } else { fmonth = System.DateTime.Now.Month; }
            DateTime cFiscal = Convert.ToDateTime(fmonth.ToString() + "/29/" + fyear + "");
            DateTime currentFiscal = Convert.ToDateTime(fmonth.ToString() + "/29/" + fyear + " 12:00:00 AM");

            int _cFDateRange = xlWorksheet.Cells[6, 11].EntireColumn.Find(currentFiscal,
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlNext,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            APTUpdateStatus.APTStatusUpdate.Text = "Deleting Date Range to Refresh";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            // Delete the range
            xlWorksheet.Range[xlWorksheet.Cells[_cFDateRange, 2], xlWorksheet.Cells[_lastRowUsed, 18]].Delete();

            //Recaculate the LastRow Used in worksheet
            _lastRowUsed = xlWorksheet.Cells[6, 2].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            APTUpdateStatus.APTStatusUpdate.Text = "Deleting Formula Ranges";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            //Delete teh existing formula fields
            xlWorksheet.Range[xlWorksheet.Cells[6, 2], xlWorksheet.Cells[_lastRowUsed, 9]].Clear();
            xlWorksheet.Range[xlWorksheet.Cells[6, 14], xlWorksheet.Cells[_lastRowUsed, 18]].Clear();

            //Recaculate the LastRow Used in worksheet
            _lastRowUsed = xlWorksheet.Cells[6, 10].EntireColumn.Find("*",
               System.Reflection.Missing.Value,
               Excel.XlFindLookIn.xlValues,
               Excel.XlLookAt.xlWhole,
               Excel.XlSearchOrder.xlByRows,
               Excel.XlSearchDirection.xlPrevious,
               false,
               System.Reflection.Missing.Value,
               System.Reflection.Missing.Value).Row;

            // Sql Connection String
            connString = SqlConnectionString.ToString();

            query = @"DECLARE @StartDate date
DECLARE @EndDate date
SET @StartDate = '" + FiscalMonthDate.ToString() + "' " + @"SET @EndDate = '" + yesterday.ToString("MM/dd/yyyy") + @"'


SELECT AvayaSuperstates.[EMP_ID],
		convert(varchar, AvayaSuperstates.[NOM_DATE], 101) AS 'NOM_DATE',
		AvayaSuperstates.[CODE],
		AvayaSuperstates.MI
FROM AvayaSuperstates
WHERE AvayaSuperstates.[NOM_DATE] >= @StartDate AND AvayaSuperstates.[NOM_DATE] <= @EndDate AND
	AvayaSuperstates.[NOM_DATE] != '08/03/2019' AND AvayaSuperstates.[NOM_DATE] != '08/04/2019' AND
	AvayaSuperstates.[NOM_DATE] != '08/05/2019' AND AvayaSuperstates.[NOM_DATE] != '08/06/2019' AND
	AvayaSuperstates.[NOM_DATE] != '08/07/2019' AND (
[AvayaSuperstates].[CODE] = 'STF-ABSTPERSONAL' OR 
									[AvayaSuperstates].[CODE] = 'STF-ABSTSICK' OR
									[AvayaSuperstates].[CODE] = 'STF-ABSTUNP' OR
									[AvayaSuperstates].[CODE] = 'STF-ABSTVACA' OR
									[AvayaSuperstates].[CODE] = 'STF-CA-KIN_CARE_SICK' OR 
									[AvayaSuperstates].[CODE] = 'STF-CA-PDL_SICK' OR
									[AvayaSuperstates].[CODE] = 'STF-MGMT OVR PERSONAL' OR
									[AvayaSuperstates].[CODE] = 'STF-MGM-OVR SICK' OR
									[AvayaSuperstates].[CODE] = 'STF-MGMT-OVR UNPPAID' OR
									[AvayaSuperstates].[CODE] = 'STF-MGMT-OVR VACA' OR
									[AvayaSuperstates].[CODE] = 'STF-NCNS PERSONAL' OR
									[AvayaSuperstates].[CODE] = 'STF-NCNS SICK' OR
									[AvayaSuperstates].[CODE] = 'STF-NCNS UNP' OR
									[AvayaSuperstates].[CODE] = 'STF-NCNS VACA' OR
									[AvayaSuperstates].[CODE] = 'STF-LATE/EARLY PERSONAL' OR
									[AvayaSuperstates].[CODE] = 'STF-PARTIAL PERSONAL' OR
									[AvayaSuperstates].[CODE] = 'STF-LC-SICK' OR
									[AvayaSuperstates].[CODE] = 'STF-LATE/EARLY SICK' OR
									[AvayaSuperstates].[CODE] = 'STF-PARTIAL SICK' OR
									[AvayaSuperstates].[CODE] = 'STF-LC-ABSENT UNP' OR
									[AvayaSuperstates].[CODE] = 'STF-LATE/EARLY UNP' OR
									[AvayaSuperstates].[CODE] = 'STF-PARTIAL UNP' OR
									[AvayaSuperstates].[CODE] = 'STF-LC-VACA' OR
									[AvayaSuperstates].[CODE] = 'STF-LATE/EARLY VACA' OR
									[AvayaSuperstates].[CODE] = 'STF-PARTIAL VACA') AND 
									AvayaSuperstates.[NOM_DATE] != '8/3/2019' AND
									AvayaSuperstates.[NOM_DATE] != '8/4/2019' AND
									AvayaSuperstates.[NOM_DATE] != '8/5/2019' AND
									AvayaSuperstates.[NOM_DATE] != '8/6/2019' AND
									AvayaSuperstates.[NOM_DATE] != '8/7/2019'";
            APTUpdateStatus.APTStatusUpdate.Text = "Pulling Superstates Data from SQL Server";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            // Initilize and Open SQL Connection
            conn = new SqlConnection(connString);
            cmd = new SqlCommand(query, conn);
            conn.Open();

            da = new SqlDataAdapter(cmd);

            // Fill dataTable with Query Results
            da.Fill(dataTable1);
            conn.Close();
            da.Dispose();

            for (int rowNumber = 0; rowNumber < dataTable1.Rows.Count; rowNumber++)
            {
                for (int colNumber = 0; colNumber < dataTable1.Columns.Count; colNumber++)
                {
                    APTUpdateStatus.APTStatusUpdate.Text = "Filling Superstate Data " + rowNumber.ToString() + " of " + dataTable1.Rows.Count.ToString();
                    APTUpdateStatus.APTStatusUpdate.Refresh();
                    xlWorksheet.Cells[rowNumber + _lastRowUsed, colNumber + 10] = dataTable1.Rows[rowNumber][colNumber].ToString();
                }
            }

            APTUpdateStatus.APTStatusUpdate.Text = "Filling Formula Ranges";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            //Fill Formulas Columns
            Excel.Range SuperstateFormulas2 = xlWorksheet.Range[xlWorksheet.Cells[4, 14], xlWorksheet.Cells[4, 18]];
            Excel.Range SuperstateFormulas2PasteRange = xlWorksheet.Range[xlWorksheet.Cells[6, 14], xlWorksheet.Cells[6, 18]];
            SuperstateFormulas2.Copy();
            SuperstateFormulas2PasteRange.PasteSpecial(Excel.XlPasteType.xlPasteFormulasAndNumberFormats);
            Excel.Range SuperstateFormulas1 = xlWorksheet.Range[xlWorksheet.Cells[4, 2], xlWorksheet.Cells[4, 9]];
            Excel.Range SuperstateFormulas1PasteRange = xlWorksheet.Range[xlWorksheet.Cells[6, 2], xlWorksheet.Cells[6, 9]];
            SuperstateFormulas1.Copy();
            SuperstateFormulas1PasteRange.PasteSpecial(Excel.XlPasteType.xlPasteFormulas);

            APTUpdateStatus.APTStatusUpdate.Text = "Sorting Superstates Table";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            // Sort Columns
            xlWorkbook.Worksheets["eWFM"].ListObjects["Segments"].Sort.SortFields.Clear();
            xlWorkbook.Worksheets["eWFM"].ListObjects["Segments"].Sort.SortFields.Add(xlWorkbook.Worksheets["eWFM"].Range("Segments[Emp ID]"),
                Excel.XlSortOn.xlSortOnValues,
                Excel.XlSortOrder.xlAscending,
                Excel.XlSortDataOption.xlSortNormal);

            xlWorkbook.Worksheets["eWFM"].ListObjects["Segments"].Sort.SortFields.Add(
            xlWorkbook.Worksheets["eWFM"].Range["Segments[Date]"],
            Excel.XlSortOn.xlSortOnValues,
            Excel.XlSortOrder.xlDescending,
            Excel.XlSortDataOption.xlSortNormal);

            xlWorkbook.Worksheets["eWFM"].ListObjects["Segments"].Sort.SortFields.Add(xlWorkbook.Worksheets["eWFM"].Range("Segments[CODE]"),
                Excel.XlSortOn.xlSortOnValues,
                Excel.XlSortOrder.xlAscending,
                "NCNS,ABSNT,PARTIAL,TARDY,OTHER,MGMT,APPVD TO",
                Excel.XlSortDataOption.xlSortNormal);

            xlWorkbook.Worksheets["eWFM"].ListObjects["Segments"].Sort.Apply();

            //Recaculate the LastRow Used in worksheet
            _lastRowUsed = xlWorksheet.Cells[6, 2].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;
            APTUpdateStatus.APTStatusUpdate.Text = "Copying and Pasting Values";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            dataRange = xlWorksheet.Range[xlWorksheet.Cells[6, 2], xlWorksheet.Cells[_lastRowUsed, 18]];
            dataRange.Copy();
            dataRange.PasteSpecial(Excel.XlPasteType.xlPasteValues);

            xlApp.Calculation = Excel.XlCalculation.xlCalculationAutomatic;
            xlWorkbook.RefreshAll();
            APTUpdateStatus.APTStatusUpdate.Text = "Updating Superstates Table Complete";
            APTUpdateStatus.APTStatusUpdate.Refresh();

            // Section updates the Shifts Table of the eWFM Tab

            DataTable dataTable2 = new DataTable();
            xlApp.Calculation = Excel.XlCalculation.xlCalculationManual;

            //Grabs eWFM sheet
            xlWorksheet = xlWorkbook.Sheets["eWFM"];
            xlWorksheet.Activate();

            //Grabs lastRow Used of First Table
            _lastRowUsed = xlWorksheet.Cells[6, 20].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;
            APTUpdateStatus.APTStatusUpdate.Text = "Sorting the Shifts Table";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            //Sorts the data range in table 1 from least to greatest
            dataRange = xlWorksheet.Range[xlWorksheet.Cells[6, 20], xlWorksheet.Cells[_lastRowUsed, 29]];
            dataRange.Sort(dataRange.Columns[7, Type.Missing], Excel.XlSortOrder.xlAscending, Type.Missing, Type.Missing, Excel.XlSortOrder.xlAscending,
             Type.Missing, Excel.XlSortOrder.xlAscending, Excel.XlYesNoGuess.xlGuess, Type.Missing, Type.Missing,
           Excel.XlSortOrientation.xlSortColumns, Excel.XlSortMethod.xlPinYin, Excel.XlSortDataOption.xlSortNormal,
           Excel.XlSortDataOption.xlSortNormal,
           Excel.XlSortDataOption.xlSortNormal);

            value2 = Convert.ToDateTime(DateTime.Now.AddDays(-366).ToString("MM/dd/yyyy") + " 12:00:00 AM");
            try
            {
                _yDateRange = xlWorksheet.Cells[6, 26].EntireColumn.Find(value2,
                    System.Reflection.Missing.Value,
                    Excel.XlFindLookIn.xlValues,
                    Excel.XlLookAt.xlWhole,
                    Excel.XlSearchOrder.xlByRows,
                    Excel.XlSearchDirection.xlPrevious,
                    false,
                    System.Reflection.Missing.Value,
                    System.Reflection.Missing.Value).Row;

                APTUpdateStatus.APTStatusUpdate.Text = "Trimming shift Table to 1 Year";
                APTUpdateStatus.APTStatusUpdate.Refresh();
                //Delete Old Date Range
                Excel.Range superStatesDelete = xlWorksheet.Range[xlWorksheet.Cells[6, 20], xlWorksheet.Cells[_yDateRange, 29]];
                superStatesDelete.Delete();
            }
            catch { _yDateRange = 0; }

            //Recaculate the LastRow Used in worksheet
            _lastRowUsed = xlWorksheet.Cells[6, 20].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            //string data for fiscal Month Caculation
            day = (int)System.DateTime.Now.Day;
            fmonth = (int)System.DateTime.Now.Month;
            fyear = (int)System.DateTime.Now.Year;
            if (day <= 29) { fmonth = System.DateTime.Now.Month - 1; } else { fmonth = System.DateTime.Now.Month; }

            currentFiscal = Convert.ToDateTime(fmonth.ToString() + "/29/" + fyear + " 12:00:00 AM");

            _cFDateRange = xlWorksheet.Cells[6, 26].EntireColumn.Find(currentFiscal,
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlNext,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            APTUpdateStatus.APTStatusUpdate.Text = "Deleting Fiscal Month Data";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            // Delete the range
            xlWorksheet.Range[xlWorksheet.Cells[_cFDateRange, 20], xlWorksheet.Cells[_lastRowUsed, 29]].Delete();

            //Recaculate the LastRow Used in worksheet
            _lastRowUsed = xlWorksheet.Cells[6, 20].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            APTUpdateStatus.APTStatusUpdate.Text = "Clearing Formula Ranges";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            xlWorksheet.Range[xlWorksheet.Cells[6, 20], xlWorksheet.Cells[_lastRowUsed, 23]].Clear();
            xlWorksheet.Range[xlWorksheet.Cells[6, 28], xlWorksheet.Cells[_lastRowUsed, 29]].Clear();

            _lastRowUsed = xlWorksheet.Cells[6, 24].EntireColumn.Find("*",
               System.Reflection.Missing.Value,
               Excel.XlFindLookIn.xlValues,
               Excel.XlLookAt.xlWhole,
               Excel.XlSearchOrder.xlByRows,
               Excel.XlSearchDirection.xlPrevious,
               false,
               System.Reflection.Missing.Value,
               System.Reflection.Missing.Value).Row;

            // Sql Connection String
            connString = SqlConnectionString.ToString();

            query = @"DECLARE @StartDate date
DECLARE @EndDate date
SET @StartDate = '" + FiscalMonthDate.ToString() + @"'
SET @EndDate = '" + yesterday.ToString("MM/dd/yyyy") + @"'


SELECT AvayaSuperstates.[EMP_ID],
		AvayaSuperstates.[CODE],
		convert(varchar, AvayaSuperstates.[NOM_DATE], 101) AS 'NOM_DATE',
		AvayaSuperstates.MI
FROM AvayaSuperstates
WHERE AvayaSuperstates.[NOM_DATE] >= @StartDate AND AvayaSuperstates.[NOM_DATE] <= @EndDate AND (
[AvayaSuperstates].[CODE] = 'SCHD-GROSS')";

            APTUpdateStatus.APTStatusUpdate.Text = "Pulling Shift Data from SQL Server";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            // Initilize and Open SQL Connection
            conn = new SqlConnection(connString);
            cmd = new SqlCommand(query, conn);
            conn.Open();

            da = new SqlDataAdapter(cmd);

            // Fill dataTable with Query Results
            da.Fill(dataTable2);
            conn.Close();
            da.Dispose();

            for (int rowNumber = 0; rowNumber < dataTable2.Rows.Count; rowNumber++)
            {
                for (int colNumber = 0; colNumber < dataTable2.Columns.Count; colNumber++)
                {
                    APTUpdateStatus.APTStatusUpdate.Text = "Filling Shift Data " + rowNumber.ToString() + " of " + dataTable2.Rows.Count.ToString();
                    APTUpdateStatus.APTStatusUpdate.Refresh();
                    xlWorksheet.Cells[rowNumber + _lastRowUsed, colNumber + 24] = dataTable2.Rows[rowNumber][colNumber].ToString();
                }
            }

            APTUpdateStatus.APTStatusUpdate.Text = "Filling Formula Range";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            //Fill Formulas
            SuperstateFormulas2 = xlWorksheet.Range[xlWorksheet.Cells[4, 28], xlWorksheet.Cells[4, 29]];
            SuperstateFormulas2PasteRange = xlWorksheet.Range[xlWorksheet.Cells[6, 28], xlWorksheet.Cells[6, 29]];
            SuperstateFormulas2.Copy();
            SuperstateFormulas2PasteRange.PasteSpecial(Excel.XlPasteType.xlPasteFormulasAndNumberFormats);
            SuperstateFormulas1 = xlWorksheet.Range[xlWorksheet.Cells[4, 20], xlWorksheet.Cells[4, 23]];
            SuperstateFormulas1PasteRange = xlWorksheet.Range[xlWorksheet.Cells[6, 20], xlWorksheet.Cells[6, 23]];
            SuperstateFormulas1.Copy();
            SuperstateFormulas1PasteRange.PasteSpecial(Excel.XlPasteType.xlPasteFormulas);

            APTUpdateStatus.APTStatusUpdate.Text = "Sorting the Shifts Table";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            // Sort Columns
            xlWorkbook.Worksheets["eWFM"].ListObjects["Shifts"].Sort.SortFields.Clear();
            xlWorkbook.Worksheets["eWFM"].ListObjects["Shifts"].Sort.SortFields.Add(xlWorkbook.Worksheets["eWFM"].Range("Shifts[Emp ID]"),
                Excel.XlSortOn.xlSortOnValues,
                Excel.XlSortOrder.xlAscending,
                Excel.XlSortDataOption.xlSortNormal);

            xlWorkbook.Worksheets["eWFM"].ListObjects["Shifts"].Sort.SortFields.Add(
            xlWorkbook.Worksheets["eWFM"].Range["Shifts[Date]"],
            Excel.XlSortOn.xlSortOnValues,
            Excel.XlSortOrder.xlDescending,
            Excel.XlSortDataOption.xlSortNormal);

            xlWorkbook.Worksheets["eWFM"].ListObjects["Shifts"].Sort.Apply();

            //Recaculate the LastRow Used in worksheet
            _lastRowUsed = xlWorksheet.Cells[6, 20].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            APTUpdateStatus.APTStatusUpdate.Text = "Pasting Values";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            dataRange = xlWorksheet.Range[xlWorksheet.Cells[6, 20], xlWorksheet.Cells[_lastRowUsed, 29]];
            dataRange.Copy();
            dataRange.PasteSpecial(Excel.XlPasteType.xlPasteValues);

            xlApp.Calculation = Excel.XlCalculation.xlCalculationAutomatic;
            xlWorkbook.RefreshAll();

            APTUpdateStatus.APTStatusUpdate.Text = "Shifts Table Update Complete";
            APTUpdateStatus.APTStatusUpdate.Refresh();

            // Section uploads Segments Table of eWFM Tab

            DataTable dataTable3 = new DataTable();
            xlApp.Calculation = Excel.XlCalculation.xlCalculationManual;

            //Grabs eWFM sheet
            xlWorksheet = xlWorkbook.Sheets["eWFM"];
            xlWorksheet.Activate();

            //Grabs lastRow Used of First Table
            _lastRowUsed = xlWorksheet.Cells[6, 37].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            APTUpdateStatus.APTStatusUpdate.Text = "Sorting the Segments Table";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            //Sorts the data range in table 1 from least to greatest
            dataRange = xlWorksheet.Range[xlWorksheet.Cells[6, 37], xlWorksheet.Cells[_lastRowUsed, 42]];
            dataRange.Sort(
                dataRange.Columns[3, Type.Missing],
                Excel.XlSortOrder.xlAscending, Type.Missing,
                Type.Missing, Excel.XlSortOrder.xlAscending,
                Type.Missing, Excel.XlSortOrder.xlAscending,
                Excel.XlYesNoGuess.xlGuess, Type.Missing,
                Type.Missing, Excel.XlSortOrientation.xlSortColumns,
                Excel.XlSortMethod.xlPinYin, Excel.XlSortDataOption.xlSortNormal,
                Excel.XlSortDataOption.xlSortNormal, Excel.XlSortDataOption.xlSortNormal);

            //Find Date Range to Clear Yesterday
            value2 = Convert.ToDateTime(DateTime.Now.AddDays(-366).ToString("MM/dd/yyyy") + " 12:00:00 AM");
            try
            {
                _yDateRange = xlWorksheet.Cells[6, 39].EntireColumn.Find(value2,
                    System.Reflection.Missing.Value,
                    Excel.XlFindLookIn.xlValues,
                    Excel.XlLookAt.xlWhole,
                    Excel.XlSearchOrder.xlByRows,
                    Excel.XlSearchDirection.xlPrevious,
                    false,
                    System.Reflection.Missing.Value,
                    System.Reflection.Missing.Value).Row;
            }
            catch { _yDateRange = 0; }

            if (_yDateRange != 0)
            {
                APTUpdateStatus.APTStatusUpdate.Text = "Trimming Segments Table to 1 Year";
                APTUpdateStatus.APTStatusUpdate.Refresh();
                //Delete Old Date Range
                Excel.Range superStatesDelete = xlWorksheet.Range[xlWorksheet.Cells[6, 37], xlWorksheet.Cells[_yDateRange, 42]];
                superStatesDelete.Delete();
            }

            //Recaculate the LastRow Used in worksheet
            _lastRowUsed = xlWorksheet.Cells[6, 37].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            //string data for fiscal Month Caculation
            day = (int)System.DateTime.Now.Day;
            fmonth = (int)System.DateTime.Now.Month;
            fyear = (int)System.DateTime.Now.Year;
            if (day <= 29) { fmonth = System.DateTime.Now.Month - 1; } else { fmonth = System.DateTime.Now.Month; }
            currentFiscal = Convert.ToDateTime(fmonth.ToString() + "/29/" + fyear + " 12:00:00 AM");
            _cFDateRange = xlWorksheet.Cells[6, 39].EntireColumn.Find(currentFiscal,
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlNext,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            APTUpdateStatus.APTStatusUpdate.Text = "Deleting Fiscal Month Date Range";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            // Delete the range
            xlWorksheet.Range[xlWorksheet.Cells[_cFDateRange, 37], xlWorksheet.Cells[_lastRowUsed, 42]].Delete();

            //Recaculate the LastRow Used in worksheet
            _lastRowUsed = xlWorksheet.Cells[6, 37].EntireColumn.Find("*",
               System.Reflection.Missing.Value,
               Excel.XlFindLookIn.xlValues,
               Excel.XlLookAt.xlWhole,
               Excel.XlSearchOrder.xlByRows,
               Excel.XlSearchDirection.xlPrevious,
               false,
               System.Reflection.Missing.Value,
               System.Reflection.Missing.Value).Row;

            // Sql Connection String
            connString = SqlConnectionString.ToString();

            query = @"SELECT [AvayaSegments].[EMP_ID],
		[AvayaSegments].[EMP_SHORT_NAME],
		[AvayaSegments].[NOM_DATE],
		[AvayaSegments].[DURATION],
		[AvayaSegments].[SEG_CODE],
		[AvayaSegments].[MEMO]
		FROM [AvayaSegments]
WHERE [AvayaSegments].[NOM_DATE] >= '" + FiscalMonthDate.ToString() + @"' and [AvayaSegments].[NOM_DATE] != '08/03/2019'
and [AvayaSegments].[NOM_DATE] != '08/04/2019'
and [AvayaSegments].[NOM_DATE] != '08/05/2019'
and [AvayaSegments].[NOM_DATE] != '08/06/2019'
and [AvayaSegments].[NOM_DATE] != '08/07/2019' and
 ([AvayaSegments].[SEG_CODE] = 'ABSENT_PERSONAL' OR
[AvayaSegments].[SEG_CODE] = 'ABSENT_SICK' OR
[AvayaSegments].[SEG_CODE] = 'ABSENT_UNP' OR
[AvayaSegments].[SEG_CODE] = 'ABSENT_VACA' OR
[AvayaSegments].[SEG_CODE] = 'ADA-PN_UNP' OR
[AvayaSegments].[SEG_CODE] = 'ADHERENCE_EXCLUSION' OR
[AvayaSegments].[SEG_CODE] = 'BEREAVEMENT' OR
[AvayaSegments].[SEG_CODE] = 'BEREAVEMENT-PN_UNP' OR
[AvayaSegments].[SEG_CODE] = 'FMLA-PN_UNP' OR
[AvayaSegments].[SEG_CODE] = 'JURY_DUTY' OR
[AvayaSegments].[SEG_CODE] = 'LATE/EARLY_PERSONAL' OR
[AvayaSegments].[SEG_CODE] = 'LATE/EARLY_SICK' OR
[AvayaSegments].[SEG_CODE] = 'LATE/EARLY_UNP' OR
[AvayaSegments].[SEG_CODE] = 'LATE/EARLY_VACA' OR
[AvayaSegments].[SEG_CODE] = 'LOA-MILT-PN_UNP' OR
[AvayaSegments].[SEG_CODE] = 'LOA-PN_UNP' OR
[AvayaSegments].[SEG_CODE] = 'MGMT-OVR_PERSONAL' OR
[AvayaSegments].[SEG_CODE] = 'MGMT-OVR_VACA' OR
[AvayaSegments].[SEG_CODE] = 'NCNS_SICK' OR
[AvayaSegments].[SEG_CODE] = 'NCNS_UNP' OR
[AvayaSegments].[SEG_CODE] = 'NCNS_VACA' OR
[AvayaSegments].[SEG_CODE] = 'PARTIAL_PERSONAL' OR
[AvayaSegments].[SEG_CODE] = 'PARTIAL_SICK' OR
[AvayaSegments].[SEG_CODE] = 'PARTIAL_UNP' OR
[AvayaSegments].[SEG_CODE] = 'PARTIAL_VACA' OR
[AvayaSegments].[SEG_CODE] = 'PERSONAL' OR
[AvayaSegments].[SEG_CODE] = 'SICK' OR
[AvayaSegments].[SEG_CODE] = 'VACA' OR
[AvayaSegments].[SEG_CODE] = 'VTO_PERSONAL' OR
[AvayaSegments].[SEG_CODE] = 'VTO_UNP' OR
[AvayaSegments].[SEG_CODE] = 'VTO_VACA' OR
[AvayaSegments].[SEG_CODE] = 'ABSENT_PERSONAL' OR
[AvayaSegments].[SEG_CODE] = 'ABSENT_SICK' OR
[AvayaSegments].[SEG_CODE] = 'ABSENT_UNP' OR
[AvayaSegments].[SEG_CODE] = 'ABSENT_VACA' OR
[AvayaSegments].[SEG_CODE] = 'ADA_UNP' OR
[AvayaSegments].[SEG_CODE] = 'ADA-PN_UNP' OR
[AvayaSegments].[SEG_CODE] = 'BEREAVEMENT' OR
[AvayaSegments].[SEG_CODE] = 'BEREAVEMENT-PN_UNP' OR
[AvayaSegments].[SEG_CODE] = 'FMLA-PN_UNP' OR
[AvayaSegments].[SEG_CODE] = 'HOLIDAY NON WORKED' OR
[AvayaSegments].[SEG_CODE] = 'HOLIDAY WORKED' OR
[AvayaSegments].[SEG_CODE] = 'JURY_DUTY' OR
[AvayaSegments].[SEG_CODE] = 'LATE/EARLY_PERSONAL' OR
[AvayaSegments].[SEG_CODE] = 'LATE/EARLY_SICK' OR
[AvayaSegments].[SEG_CODE] = 'LATE/EARLY_UNP' OR
[AvayaSegments].[SEG_CODE] = 'LATE/EARLY_VACA' OR
[AvayaSegments].[SEG_CODE] = 'LOA-MILT_UNP' OR
[AvayaSegments].[SEG_CODE] = 'LOA-MILT-PN_UNP' OR
[AvayaSegments].[SEG_CODE] = 'LOA-PN_UNP' OR
[AvayaSegments].[SEG_CODE] = 'MGMT-OVR_PERSONAL' OR
[AvayaSegments].[SEG_CODE] = 'MGMT-OVR_SICK' OR
[AvayaSegments].[SEG_CODE] = 'MGMT-OVR_VACA' OR
[AvayaSegments].[SEG_CODE] = 'NCNS_PERSONAL' OR
[AvayaSegments].[SEG_CODE] = 'NCNS_SICK' OR
[AvayaSegments].[SEG_CODE] = 'NCNS_UNP' OR
[AvayaSegments].[SEG_CODE] = 'NCNS_VACA' OR
[AvayaSegments].[SEG_CODE] = 'PARTIAL_PERSONAL' OR
[AvayaSegments].[SEG_CODE] = 'PARTIAL_SICK' OR
[AvayaSegments].[SEG_CODE] = 'PARTIAL_UNP' OR
[AvayaSegments].[SEG_CODE] = 'PARTIAL_VACA' OR
[AvayaSegments].[SEG_CODE] = 'PERSONAL' OR
[AvayaSegments].[SEG_CODE] = 'SICK' OR
[AvayaSegments].[SEG_CODE] = 'SUSPENSION_PD' OR
[AvayaSegments].[SEG_CODE] = 'VACA' OR
[AvayaSegments].[SEG_CODE] = 'VTO_PERSONAL' OR
[AvayaSegments].[SEG_CODE] = 'VTO_UNP' OR
[AvayaSegments].[SEG_CODE] = 'VTO_VACA'
)
";
            APTUpdateStatus.APTStatusUpdate.Text = "Pulling Segments Data from SQL Server";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            // Initilize and Open SQL Connection
            conn = new SqlConnection(connString);
            cmd = new SqlCommand(query, conn);
            conn.Open();

            da = new SqlDataAdapter(cmd);

            // Fill dataTable with Query Results
            da.Fill(dataTable3);
            conn.Close();
            da.Dispose();

            for (int rowNumber = 0; rowNumber < dataTable3.Rows.Count; rowNumber++)
            {
                for (int colNumber = 0; colNumber < dataTable3.Columns.Count; colNumber++)
                {
                    APTUpdateStatus.APTStatusUpdate.Text = "Filling Segments Data " + rowNumber.ToString() + " of " + dataTable3.Rows.Count.ToString();
                    APTUpdateStatus.APTStatusUpdate.Refresh();
                    xlWorksheet.Cells[rowNumber + _lastRowUsed, colNumber + 37] = dataTable3.Rows[rowNumber][colNumber].ToString();
                }
            }

            APTUpdateStatus.APTStatusUpdate.Text = "Sorting the Segments Table";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            // Sort Columns
            xlWorkbook.Worksheets["eWFM"].ListObjects["Segment_Memo"].Sort.SortFields.Clear();
            xlWorkbook.Worksheets["eWFM"].ListObjects["Segment_Memo"].Sort.SortFields.Add(xlWorkbook.Worksheets["eWFM"].Range("Segment_Memo[EE ID]"),
                Excel.XlSortOn.xlSortOnValues,
                Excel.XlSortOrder.xlDescending,
                Excel.XlSortDataOption.xlSortNormal);

            xlWorkbook.Worksheets["eWFM"].ListObjects["Segment_Memo"].Sort.SortFields.Add(
            xlWorkbook.Worksheets["eWFM"].Range["Segment_Memo[Date]"],
            Excel.XlSortOn.xlSortOnValues,
            Excel.XlSortOrder.xlDescending,
            Excel.XlSortDataOption.xlSortNormal);

            xlWorkbook.Worksheets["eWFM"].ListObjects["Segment_Memo"].Sort.Apply();

            //Recaculate the LastRow Used in worksheet
            _lastRowUsed = xlWorksheet.Cells[6, 37].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            APTUpdateStatus.APTStatusUpdate.Text = "Pasting Values of Segments Table";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            dataRange = xlWorksheet.Range[xlWorksheet.Cells[6, 37], xlWorksheet.Cells[_lastRowUsed, 42]];
            dataRange.Copy();
            dataRange.PasteSpecial(Excel.XlPasteType.xlPasteValues);

            xlApp.Calculation = Excel.XlCalculation.xlCalculationAutomatic;
            xlWorkbook.RefreshAll();

            APTUpdateStatus.APTStatusUpdate.Text = "Updating CorPortal Coaching Table";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            // This Section updates the CorPortal Coaching tables

            DataTable dataTable6 = new DataTable();
            xlApp.Calculation = Excel.XlCalculation.xlCalculationManual;

            xlApp.Calculation = Excel.XlCalculation.xlCalculationManual;

            xlWorksheet = xlWorkbook.Sheets["Coaching Doc Data"];
            xlWorksheet.Activate();

            //Grabs lastRow Used of First Table
            _lastRowUsed = xlWorksheet.Cells[4, 4].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;


            APTUpdateStatus.APTStatusUpdate.Text = "Sorting CorPortal Coaching Data";
            APTUpdateStatus.APTStatusUpdate.Refresh();

            dataRange = xlWorksheet.Range[xlWorksheet.Cells[4, 2], xlWorksheet.Cells[_lastRowUsed, 14]];
            dataRange.Sort(
                dataRange.Columns[4, Type.Missing],
                Excel.XlSortOrder.xlAscending, Type.Missing,
                Type.Missing, Excel.XlSortOrder.xlAscending,
                Type.Missing, Excel.XlSortOrder.xlAscending,
                Excel.XlYesNoGuess.xlGuess, Type.Missing,
                Type.Missing, Excel.XlSortOrientation.xlSortColumns,
                Excel.XlSortMethod.xlPinYin, Excel.XlSortDataOption.xlSortNormal,
                Excel.XlSortDataOption.xlSortNormal, Excel.XlSortDataOption.xlSortNormal);

            //Find Date Range to Clear Yesterday
            value2 = Convert.ToDateTime(DateTime.Now.AddDays(-366).ToString("MM/dd/yyyy") + " 12:00:00 AM");
            _yDateRange = 0;
            try
            {
                _yDateRange = xlWorkbook.Worksheets["Coaching Doc Data"].ListObjects["Coaching"].Range["Coaching[Date]"].Find(value2,
  System.Reflection.Missing.Value,
  Excel.XlFindLookIn.xlValues,
  Excel.XlLookAt.xlWhole,
  Excel.XlSearchOrder.xlByRows,
  Excel.XlSearchDirection.xlPrevious,
  false,
  System.Reflection.Missing.Value,
  System.Reflection.Missing.Value).Row;
            }
            catch { _yDateRange = 0; }

            if (_yDateRange != 0)
            {
                APTUpdateStatus.APTStatusUpdate.Text = "Trimming Data to 1 year";
                APTUpdateStatus.APTStatusUpdate.Refresh();
                Excel.Range superStatesDelete = xlWorksheet.Range[xlWorksheet.Cells[4, 2], xlWorksheet.Cells[_yDateRange, 14]];
                superStatesDelete.Delete();
            }
            //Recaculate the LastRow Used in worksheet
            _lastRowUsed = xlWorksheet.Cells[4, 4].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            //string data for fiscal Month Caculation
            day = (int)System.DateTime.Now.Day;
            fmonth = (int)System.DateTime.Now.Month;
            fyear = (int)System.DateTime.Now.Year;
            if (day <= 29) { fmonth = System.DateTime.Now.Month - 1; } else { fmonth = System.DateTime.Now.Month; }
            currentFiscal = Convert.ToDateTime(fmonth.ToString() + "/29/" + fyear + " 12:00:00 AM");

            _cFDateRange = 0;
            try
            {
                _cFDateRange = xlWorksheet.Cells[4, 5].EntireColumn.Find(currentFiscal,
                    System.Reflection.Missing.Value,
                    Excel.XlFindLookIn.xlValues,
                    Excel.XlLookAt.xlWhole,
                    Excel.XlSearchOrder.xlByRows,
                    Excel.XlSearchDirection.xlNext,
                    false,
                    System.Reflection.Missing.Value,
                    System.Reflection.Missing.Value).Row;
                APTUpdateStatus.APTStatusUpdate.Text = "Deleting Current Fiscal Data";
                APTUpdateStatus.APTStatusUpdate.Refresh();
                xlWorksheet.Range[xlWorksheet.Cells[_cFDateRange, 2], xlWorksheet.Cells[_lastRowUsed, 14]].Delete();
            }
            catch { _cFDateRange = 0; }

            //Recaculate the LastRow Used in worksheet
            _lastRowUsed = xlWorksheet.Cells[4, 4].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            APTUpdateStatus.APTStatusUpdate.Text = "Clearing Formula data";
            APTUpdateStatus.APTStatusUpdate.Refresh();

            xlWorksheet.Range[xlWorksheet.Cells[4, 2], xlWorksheet.Cells[_lastRowUsed, 3]].Clear();
            xlWorksheet.Range[xlWorksheet.Cells[4, 11], xlWorksheet.Cells[_lastRowUsed, 14]].Clear();

            //Recaculate the LastRow Used in worksheet
            _lastRowUsed = xlWorksheet.Cells[4, 4].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            // Sql Connection String
            connString = SqlConnectionString.ToString();

            query = @"SELECT 'ATTN COACH' AS 'Calendar Code',
		CorPortalCoaching.[Coaching Date],
		CorPortalCoaching.[Employee Name],
		CorPortalCoaching.[Coaching Type],
		CorPortalCoaching.[Coaching Specific],
		CorPortalCoaching.[Enter Date],
		CorPortalCoaching.[Employee NT Logon]

FROM CorPortalCoaching
WHERE [Enter Date] >= '" + FiscalMonthDate.ToString() + @"' AND [CorPortalCoaching].[Coaching Type]='Attendance'";

            APTUpdateStatus.APTStatusUpdate.Text = "Pulling SQL Coaching Data";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            conn = new SqlConnection(connString);
            cmd = new SqlCommand(query, conn);
            conn.Open();

            da = new SqlDataAdapter(cmd);

            // Fill dataTable with Query Results
            da.Fill(dataTable6);
            conn.Close();
            da.Dispose();

            for (int rowNumber = 0; rowNumber < dataTable6.Rows.Count; rowNumber++)
            {
                for (int colNumber = 0; colNumber < dataTable6.Columns.Count; colNumber++)
                {
                    APTUpdateStatus.APTStatusUpdate.Text = "Filling Coaching Data " + rowNumber.ToString() + " of " + dataTable6.Rows.Count.ToString();
                    APTUpdateStatus.APTStatusUpdate.Refresh();

                    xlWorksheet.Cells[rowNumber + _lastRowUsed, colNumber + 4] = dataTable6.Rows[rowNumber][colNumber].ToString();
                }
            }

            APTUpdateStatus.APTStatusUpdate.Text = "Pasting Formulas";
            APTUpdateStatus.APTStatusUpdate.Refresh();

            SuperstateFormulas2 = xlWorksheet.Range[xlWorksheet.Cells[2, 2], xlWorksheet.Cells[2, 3]];
            SuperstateFormulas2PasteRange = xlWorksheet.Range[xlWorksheet.Cells[4, 2], xlWorksheet.Cells[4, 3]];
            SuperstateFormulas2.Copy();
            SuperstateFormulas2PasteRange.PasteSpecial(Excel.XlPasteType.xlPasteFormulasAndNumberFormats);
            SuperstateFormulas1 = xlWorksheet.Range[xlWorksheet.Cells[2, 11], xlWorksheet.Cells[2, 14]];
            SuperstateFormulas1PasteRange = xlWorksheet.Range[xlWorksheet.Cells[4, 11], xlWorksheet.Cells[4, 14]];
            SuperstateFormulas1.Copy();
            SuperstateFormulas1PasteRange.PasteSpecial(Excel.XlPasteType.xlPasteFormulas);

            APTUpdateStatus.APTStatusUpdate.Text = "Sorrting CorPortal Coaching Data";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            xlWorkbook.Worksheets["Coaching Doc Data"].ListObjects["Coaching"].Sort.SortFields.Clear();
            xlWorkbook.Worksheets["Coaching Doc Data"].ListObjects["Coaching"].Sort.SortFields.Add(xlWorkbook.Worksheets["Coaching Doc Data"].Range("Coaching[EE ID]"),
                Excel.XlSortOn.xlSortOnValues,
                Excel.XlSortOrder.xlAscending,
                Excel.XlSortDataOption.xlSortNormal);

            xlWorkbook.Worksheets["Coaching Doc Data"].ListObjects["Coaching"].Sort.SortFields.Add(
            xlWorkbook.Worksheets["Coaching Doc Data"].Range["Coaching[Date]"],
            Excel.XlSortOn.xlSortOnValues,
            Excel.XlSortOrder.xlDescending,
            Excel.XlSortDataOption.xlSortNormal);


            xlWorkbook.Worksheets["Coaching Doc Data"].ListObjects["Coaching"].Sort.Apply();

            //Recaculate the LastRow Used in worksheet
            _lastRowUsed = xlWorksheet.Cells[4, 4].EntireColumn.Find("*",
                System.Reflection.Missing.Value,
                Excel.XlFindLookIn.xlValues,
                Excel.XlLookAt.xlWhole,
                Excel.XlSearchOrder.xlByRows,
                Excel.XlSearchDirection.xlPrevious,
                false,
                System.Reflection.Missing.Value,
                System.Reflection.Missing.Value).Row;

            APTUpdateStatus.APTStatusUpdate.Text = "Pasting Values";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            dataRange = xlWorksheet.Range[xlWorksheet.Cells[4, 2], xlWorksheet.Cells[_lastRowUsed, 14]];
            dataRange.Copy();
            dataRange.PasteSpecial(Excel.XlPasteType.xlPasteValues);

            xlApp.Calculation = Excel.XlCalculation.xlCalculationAutomatic;
            xlWorkbook.RefreshAll();

            //Unhide Needed Tabs
            APTUpdateStatus.APTStatusUpdate.Text = "Hiding Hidden Tabs";
            APTUpdateStatus.APTStatusUpdate.Refresh();
            xlWorksheet = xlWorkbook.Sheets["eWFM"];
            xlWorksheet.Visible = Excel.XlSheetVisibility.xlSheetVeryHidden;
            xlWorksheet = xlWorkbook.Sheets["CA Data"];
            xlWorksheet.Visible = Excel.XlSheetVisibility.xlSheetVeryHidden;
            xlWorksheet = xlWorkbook.Sheets["Coaching Doc Data"];
            xlWorksheet.Visible = Excel.XlSheetVisibility.xlSheetVeryHidden;
            xlWorksheet = xlWorkbook.Sheets["Report Functions"];
            xlWorksheet.Visible = Excel.XlSheetVisibility.xlSheetVeryHidden;



            APTUpdateStatus.APTStatusUpdate.Text = "APT Update Complete";
            APTUpdateStatus.APTStatusUpdate.Refresh();

            xlWorkbook.Close(true);
            xlApp.Quit();



        }
    }
}
