using System;
using System.Data;
using System.IO;
using System.Windows.Forms;
using System.Diagnostics;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Threading;
using DSRAutomation;
using IRISAutomation;
using RubyMeterAuto;
using AATAutomations;
using TransferLocations;
using Excel = Microsoft.Office.Interop.Excel;
using VOCAutomation;
using ETDAutomation;
using WorkOrderDetailsAuto;

namespace WorkAutomation
{
    public partial class Form1 : Form
    {
        public string reportTemplates { get; set; }
        public string dataPath { get; set; }
        public string msaccessPath { get; set; }



        public Form1()
        {
            InitializeComponent();
            reportTemplates = "";
            dataPath = "";
            msaccessPath = "";
        }
        /*
         * 
         *    SQL Test Connection button. 
         * 
         */
        private void SqlTestConn_Click(object sender, EventArgs e)
        {
            SqlData sqldata = new SqlData
            {
                SqlServerAddress = sqlServerAddressBox.Text.ToString(),
                SqlUserName = sqlUsernameBox.Text.ToString(),
                SqlPassword = sqlPasswordBox.Text.ToString(),
                SqlDatabase = sqlDatabaseBox.Text.ToString()
            };
            sqldata.SetSqlConnection();
            if (sqldata.TestsqlConnection()) { MessageBox.Show("Successfull"); } else { MessageBox.Show("Failed"); };
        }
        /*
         * 
         *  Select File Button
         * 
         */
        private void Button1_Click(object sender, EventArgs e)
        {
            XlData xlData = new XlData();
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {xlFilePathBox.Text = Path.GetFileName(openFileDialog1.FileName);
                xlData.XlFilePath = openFileDialog1.FileName;
                sqlTableNameBox.Text = Path.GetFileNameWithoutExtension(openFileDialog1.FileName).ToString();
            }
        }
        /*
         * 
         *  Upload File Button
         * 
         */
        private void UploadFileButton_Click(object sender, EventArgs e)
        {
            XlData xlData = new XlData
            {
                XlFilePath = openFileDialog1.FileName,
                XlDateColName = xlDateColBox.Text.ToString(),
                SheetName = Path.GetFileNameWithoutExtension(openFileDialog1.FileName).ToString()
             };
            SqlData sqldata = new SqlData
            {
                SqlServerAddress = sqlServerAddressBox.Text.ToString(),
                SqlUserName = sqlUsernameBox.Text.ToString(),
                SqlPassword = sqlPasswordBox.Text.ToString(),
                SqlDatabase = sqlDatabaseBox.Text.ToString(),
                sqlTableName = Path.GetFileNameWithoutExtension(openFileDialog1.FileName).ToString()
             };

            //Initilizes members of xlData and sqldata
            xlData.SetxlConnectionString();
            sqldata.SetSqlConnection();

            //Pull data from excel to datatable
            DataTable dt = xlData.GetxlData();

            //Clear date range from Sql Table
            if (sqldata.ClearDateRange(sqldata.sqlTableName, xlData.XlDateColName, xlData.GetMinDate(dt), xlData.GetMaxDate(dt)))
            { MessageBox.Show("Sucessfull"); }
            else { MessageBox.Show("Clear Data Failed"); };

            //Upload data to SQL Table
            try { sqldata.UploadData(sqldata.sqlTableName, dt); } catch { MessageBox.Show("Upload Failed"); }
        }
        /*
         * 
         *  File Menu - Exit button
         * 
         */
        private void ExitToolStripMenuItem_Click(object sender, EventArgs e)
        {if (System.Windows.Forms.Application.MessageLoop)
            {System.Windows.Forms.Application.Exit();}
            else {System.Environment.Exit(1);}}

        /*
         * 
         *   Select Folder Button
         * 
         */
        private void SelectFolderButton_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                folderPath.Text = folderBrowserDialog1.SelectedPath;
            }
        }
        /*
         * 
         * getDateColname
         * 
         */
        private string GetDateColname(string sheetName)
        {
            if (sheetName == "AATData") return "Request Created On";
            if (sheetName == "AUXBIData") return "Date";
            if (sheetName == "AvayaSegments") return "NOM_DATE";
            if (sheetName == "AvayaSuperstates") return "NOM_DATE";
            if (sheetName == "BIMetricData") return "Date";
            if (sheetName == "BQOEData") return "PublishDt";
            if (sheetName == "CorPortalCoaching") return "Coaching Date";
            if (sheetName == "EHH") return "Click Date";
            if (sheetName == "HistoricalRoster") return "Date";
            if (sheetName == "TransferLocations") return "Date";
            else return "";
        }

        /*
         * 
         *  Multi File Upload loop
         * 
         */
        public void SqlUploadLoop()
        {
            // Initiates the xlData and sqldata objects
            XlData xlData = new XlData();
            SqlData sqldata = new SqlData
            {

                //Initilizes members of xlData and sqldata
                SqlServerAddress = sqlServerAddressBox.Text.ToString(),
                SqlUserName = sqlUsernameBox.Text.ToString(),
                SqlPassword = sqlPasswordBox.Text.ToString(),
                SqlDatabase = sqlDatabaseBox.Text.ToString()
            };

            foreach (var tablename in updates)
            {


                xlData.XlDateColName = GetDateColname(tablename);
                xlData.XlFilePath = folderBrowserDialog1.SelectedPath.ToString() + "\\" + tablename + ".xlsx";
                sqldata.sqlTableName = tablename;
                xlData.SheetName = tablename;
                if (tablename == "CurrentRoster" || tablename == "Roster" || tablename == "SupervisorRoster" || tablename == "ManagerRoster")
                {
                    FileUploadStaticTable(tablename);

                }
                else
                {

                    //Initilize Connection Strings
                    xlData.SetxlConnectionString();
                    sqldata.SetSqlConnection();


                    //Pull data from excel to datatable
                    DataTable dt = xlData.GetxlData();
                    //Clear date range from Sql Table
                    if (sqldata.ClearDateRange(sqldata.sqlTableName, xlData.XlDateColName, xlData.GetMinDate(dt), xlData.GetMaxDate(dt)))
                    { }
                    else { MessageBox.Show("Clear Data Failed"); };


                    try { sqldata.UploadData(sqldata.sqlTableName, dt); } catch (Exception e) { MessageBox.Show("Upload Failed: " + e.ToString()); }
                }
                MessageBox.Show("Multi-Upload Complete");
            }
      

        }
        /*
         * 
         * fileUploadStaticTable
         * 
         */
         
        private void FileUploadStaticTable(string msheetName)
        {
            // Initiates the xlData and sqldata objects
            XlData xlData = new XlData();
            SqlData sqldata = new SqlData
            {
                SqlServerAddress = sqlServerAddressBox.Text.ToString(),
                SqlUserName = sqlUsernameBox.Text.ToString(),
                SqlPassword = sqlPasswordBox.Text.ToString(),
                SqlDatabase = sqlDatabaseBox.Text.ToString()
            };

            //Initilizes members of xlData and sqldata
            xlData.XlFilePath = folderBrowserDialog1.SelectedPath.ToString() +"\\"+ msheetName + ".xlsx";
           // xlData.SetxlConnectionString();
           // sqldata.SqlServerAddress = sqlServerAddressBox.Text.ToString();
           // sqldata.SqlUserName = sqlUsernameBox.Text.ToString();
           // sqldata.SqlPassword = sqlPasswordBox.Text.ToString();
           // sqldata.SqlDatabase = sqlDatabaseBox.Text.ToString();
            //xlData.xlDateColName = xlDateColBox.Text.ToString();
            sqldata.sqlTableName = msheetName;
            xlData.SheetName = msheetName;
            //sqldata.SetSqlConnection();

            //Pull data from excel to datatable
            DataTable dt = xlData.GetxlData();
            

            //Upload data to SQL Table
            try { DeleteTable(msheetName); sqldata.UploadData(msheetName, dt); } catch { MessageBox.Show("Upload Failed"); }
        }
       /*
        * 
        * 
        * deleteTable
        * 
        */
        public void DeleteTable(string TableName)
        {
            SqlData sqldata = new SqlData
            {
                SqlServerAddress = sqlServerAddressBox.Text.ToString(),
                SqlUserName = sqlUsernameBox.Text.ToString(),
                SqlPassword = sqlPasswordBox.Text.ToString(),
                SqlDatabase = sqlDatabaseBox.Text.ToString()
            };
            //sqldata.SetSqlConnection();
            string query = "DELETE FROM [" + TableName + "]";
            SqlConnection conn = new SqlConnection(sqldata.SqlConnectionString);
            conn.Open();
            using (SqlCommand comm = new SqlCommand(query, conn))
            {
                comm.ExecuteNonQuery();
            }
        }

        /*
         * 
         *  Multi File Upload Button
         * 
         */
        readonly List<string> updates = new List<string>();

        private void Button1_Click_1(object sender, EventArgs e)
        {
            uploadControlsProgressBar.Visible = true;
            uploadControlsProgressBar.Value = 0;
            uploadControlsProgressBar.Minimum = 0;
            uploadControlsProgressBar.Maximum = 160;

            updates.Clear();

            uploadControlsProgressBar.Value += 10;
            if (AATData.Checked) {
                updates.Add("AATData");
            }
            uploadControlsProgressBar.Value += 10;
            if (AUXBIData.Checked) {
                updates.Add("AUXBIData");
            }
            uploadControlsProgressBar.Value += 10;
            if (AvayaSegments.Checked) {
                updates.Add("AvayaSegments");
            }
            uploadControlsProgressBar.Value += 10;
            if (AvayaSuperstates.Checked)
            {
                updates.Add("AvayaSuperstates");
            }
            uploadControlsProgressBar.Value += 10;
            if (BIMetricData.Checked)
            {
                updates.Add("BIMetricData");
            }
            uploadControlsProgressBar.Value += 10;
            if (BQOEData.Checked)
            {
                updates.Add("BQOEData");
            }
            uploadControlsProgressBar.Value += 10;
            if (CorPortalCoaching.Checked)
            {
                updates.Add("CorPortalCoaching");
            }
            uploadControlsProgressBar.Value += 10;
            if (EHH.Checked)
            {
                updates.Add("EHH");
            }
            uploadControlsProgressBar.Value += 10;
            if (HistoricalRoster.Checked)
            {
                updates.Add("HistoricalRoster");
            }
            uploadControlsProgressBar.Value += 10;
            if (TransferLocations.Checked)
            {
                updates.Add("TransferLocations");
            }
            uploadControlsProgressBar.Value += 10;
            if (AgentSchedules.Checked)
            {
                updates.Add("AgentSchedules");
            }
            uploadControlsProgressBar.Value += 10;
            if (CurrentRoster.Checked)
            {
                updates.Add("CurrentRoster");
            }
            uploadControlsProgressBar.Value += 10;
            if (ManagerRoster.Checked)
            {
                updates.Add("ManagerRoster");
            }
            uploadControlsProgressBar.Value += 10;
            if (Roster.Checked)
            {
                updates.Add("Roster");
            }
            uploadControlsProgressBar.Value += 10;
            if (SuperstateMapping.Checked)
            {
                updates.Add("Shrinkage-SuperstateMappings");
            }
            uploadControlsProgressBar.Value += 10;
            if (SupervisorRoster.Checked)
            {
                updates.Add("SupervisorRoster");
            }
            
            uploadControlsProgressBar.Value = 160;
            uploadControlsProgressBar.Dispose();
            Thread SqlUploadThread = new Thread(new ThreadStart(SqlUploadLoop));
            SqlUploadThread.Start();

            //SqlUploadLoop();
            MessageBox.Show("Files will be uploaded. Please use Status Tab to verify.");   

        }
        /*
         * 
         *  Check Update Dates Button
         * 
         */
        private void CheckDatesButton_Click(object sender, EventArgs e)
        {
            serverStatusProgressBar.Visible = true;
            serverStatusProgressBar.Value = 0;
            serverStatusProgressBar.Minimum = 0;
            serverStatusProgressBar.Maximum = 100;

            if (sqlServerAddressBox.TextLength < 7 || sqlServerAddressBox.TextLength > 15)
            { MessageBox.Show("Check SQL Server address on Upload Controls tab."); }
            else
            {


                // Initilize sqlData object
                SqlData sqlData = new SqlData();
                if (sqlServerAddressBox.Text.ToString() == null) { MessageBox.Show("Enter SQL Server Address on Upload Controls tab."); }

                // Initilize sqlData members
                sqlData.SqlServerAddress = sqlServerAddressBox.Text.ToString();
                sqlData.SqlUserName = sqlUsernameBox.Text.ToString();
                sqlData.SqlPassword = sqlPasswordBox.Text.ToString();
                sqlData.SqlDatabase = sqlDatabaseBox.Text.ToString();
                sqlData.SetSqlConnection();

                serverStatusProgressBar.Value += 4;
                try { AATUpdateTDate.Text = sqlData.GetupdateDate("AATData", "Request Created On"); } catch(Exception ex) { MessageBox.Show("AATData Date query failed."+ ex.ToString()); }
                serverStatusProgressBar.Value += 4;
                try { AATDataUDate.Text = sqlData.GetLastUpdateDate("AATData"); } catch { MessageBox.Show("AAT Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { AgentSchedulesUpdateTDate.Text = sqlData.GetLastUpdateDate("AgentSchedules"); } catch { MessageBox.Show("AgentSchedules Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { AUXBIDataUpdateTDate.Text = sqlData.GetupdateDate("AUXBIData", "Date"); } catch { MessageBox.Show("AUXBIData Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { AUXBIDataUDate.Text = sqlData.GetLastUpdateDate("AUXBIData"); } catch { MessageBox.Show("AUXBIData Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { AvayaSegmentsUpdatedTDate.Text = sqlData.GetupdateDate("AvayaSegments", "NOM_DATE"); } catch { MessageBox.Show("AvayaSegments Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { AvayaSegmentsUDate.Text = sqlData.GetLastUpdateDate("AvayaSegments"); } catch { MessageBox.Show("AvayaSegments Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { AvayaSuperstatesUpdatedTDate.Text = sqlData.GetupdateDate("AvayaSuperstates", "NOM_DATE"); } catch { MessageBox.Show("AvayaSuperstates Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { AvayaSuperstatesUDate.Text = sqlData.GetLastUpdateDate("AvayaSuperstates"); } catch { MessageBox.Show("AvayaSuperstates Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { BIMetricDataUpdatedTDate.Text = sqlData.GetupdateDate("BIMetricData", "Date"); } catch { MessageBox.Show("BIMetricData Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { BIMetricDataUDate.Text = sqlData.GetLastUpdateDate("BIMetricData"); } catch { MessageBox.Show("BIMetricData Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { CorPortalCoachingUpdatedTDate.Text = sqlData.GetupdateDate("CorPortalCoaching", "Coaching Date"); } catch { MessageBox.Show("CorPortalCoaching Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { CorPortalCoachingUDate.Text = sqlData.GetLastUpdateDate("CorPortalCoaching"); } catch { MessageBox.Show("CorPortalCoaching Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { CurrentRosterUpdatedTDate.Text = sqlData.GetLastUpdateDate("CurrentRoster"); } catch { MessageBox.Show("CurrentRoster Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { BQOEDataUpdatedTDate.Text = sqlData.GetupdateDate("BQOEData", "PublishDt"); } catch { MessageBox.Show("BQOEData Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { BQOEDataUDate.Text = sqlData.GetLastUpdateDate("BQOEData"); } catch { MessageBox.Show("BQOEData Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { EHHUpdatedTDate.Text = sqlData.GetupdateDate("EHH", "Click Date"); } catch { MessageBox.Show("EHH Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { EHHUDate.Text = sqlData.GetLastUpdateDate("EHH"); } catch { MessageBox.Show("EHH Date query failed"); }
                serverStatusProgressBar.Value += 4;
                serverStatusProgressBar.Value += 4;
                serverStatusProgressBar.Value += 4;
                try { ManagerRosterUpdatedTDate.Text = sqlData.GetLastUpdateDate("ManagerRoster"); } catch { MessageBox.Show("ManagerRoster Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { RosterUpdatedTDate.Text = sqlData.GetLastUpdateDate("Roster"); } catch { MessageBox.Show("Roster Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { SuperstateMappingUpdatedTDate.Text = sqlData.GetLastUpdateDate("Superstate-ShrinkageMapping"); } catch { MessageBox.Show("ShrinkageMapping Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { SupervisorRosterUpdatedTDate.Text = sqlData.GetLastUpdateDate("SupervisorRoster"); } catch { MessageBox.Show("SupervisorRoster Date query failed"); }
                serverStatusProgressBar.Value += 4;
                try { TransferLocationsUpdatedTDate.Text = sqlData.GetupdateDate("TransferLocations", "Date"); } catch { MessageBox.Show("TransferLocations Date query failed"); }
                try { TransferLocationsUDate.Text = sqlData.GetLastUpdateDate("TransferLocations"); } catch { MessageBox.Show("TransferLocations Date query failed"); }
                serverStatusProgressBar.Value = 100;
                serverStatusProgressBar.Value = 0;
                serverStatusProgressBar.Dispose();
            }
        }
        /*
         * AgentDailyIrisUsage_LinkClicked
         */
        private void AgentDailyIrisUsage_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start(@"http://"+ SSRSServerBox .Text.ToString()+ "/ReportServer/Pages/ReportViewer.aspx?%2fAgent+Daily+IRIS+Usage&rs:Command=Render");
        }
        /*
        * AgentDailyIriswoHeaders_LinkClicked
        */
        private void AgentDailyIriswoHeaders_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start(@"http://" + SSRSServerBox.Text.ToString() + "/ReportServer/Pages/ReportViewer.aspx?%2fAgent+Daily+IRIS+Usage+wo+Header&rs:Format=EXCELOPENXML");
        }
        /*
        * AgentDSR_LinkClicked
        */
        private void AgentDSR_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start(@"http://"+SSRSServerBox.Text.ToString()+ "/ReportServer?%2fAgent+DSR&rs:Format=EXCELOPENXML");
        }
        /*
        * AgentDSRwoHeaders_LinkClicked
        */
        private void AgentDSRwoHeaders_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start(@"http://"+SSRSServerBox.Text.ToString()+"/ReportServer?%2fAgent+DSR+woHeaders&rs:Format=EXCELOPENXML");
        }
        /*
        * AUXSupervisors_LinkClicked
        */
        private void AUXSupervisors_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start(@"http://" + SSRSServerBox.Text.ToString() + "/ReportServer/Pages/ReportViewer.aspx?%2fAUX+Supervisors&rs:Command=Render");
        }
        /*
       * EHHLinkLabel_LinkClicked
       */
        private void EHHLinkLabel_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start(@"http://" + SSRSServerBox.Text.ToString() + "/ReportServer/Pages/ReportViewer.aspx?%2fEHH&rs:Format=EXCELOPENXML");
        }
     /*
      * LeadDSR_LinkClicked
      */
        private void LeadDSR_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start(@"http://" + SSRSServerBox.Text.ToString() + "/ReportServer/Pages/ReportViewer.aspx?%2fLead+DSR&rs:Format=EXCELOPENXML");
        }
     /*
     * ManagerDSR_LinkClicked
     */
        private void ManagerDSR_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start(@"http://"+SSRSServerBox.Text.ToString()+"/ReportServer?%2fManager+DSR&rs:Format=EXCELOPENXML");
        }
     /*
     * ManagerDSRwoHeaders_LinkClicked
     */
        private void ManagerDSRwoHeaders_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start(@"http://"+SSRSServerBox.Text.ToString()+"/ReportServer?%2fManager+DSR+woHeaders&rs:Format=EXCELOPENXML");
        }
    /*
     * RubyMeter_LinkClicked
     */
        private void RubyMeter_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start(@"http://" + SSRSServerBox.Text.ToString() + "/ReportServer/Pages/ReportViewer.aspx?%2fRuby+Meter&rs:Format=EXCELOPENXML");
        }
    /*
    * Shrinkage_LinkClicked
    */
        private void Shrinkage_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start(@"http://" + SSRSServerBox.Text.ToString() + "/ReportServer/Pages/ReportViewer.aspx?%2fShrinkage&rs:Format=EXCELOPENXML");
        }
   /*
    * SupervisorDailyIris_LinkClicked
    */
        private void SupervisorDailyIris_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start(@"http://" + SSRSServerBox.Text.ToString() + "/ReportServer/Pages/ReportViewer.aspx?%2fSupervisor+Daily+IRIS+Usage&rs:Command=Render");
        }
   /*
   * SupervisorDailyIRISwoHeaders_LinkClicked
   */
        private void SupervisorDailyIRISwoHeaders_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start(@"http://" + SSRSServerBox.Text.ToString() + "/ReportServer/Pages/ReportViewer.aspx?%2fSupervisor+Daily+IRIS+Usage+wo+Headers&rs:Format=EXCELOPENXML");
        }
  /*
  * SupervisorDSR_LinkClicked
  */
        private void SupervisorDSR_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start(@"http://"+SSRSServerBox.Text.ToString()+"/ReportServer?%2fSupervisor+DSR&rs:Format=EXCELOPENXML");
        }
        /*
  * SupervisorDSRwoHeaders_LinkClicked
  */
        private void SupervisorDSRwoHeaders_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start(@"http://"+SSRSServerBox.Text.ToString()+"/ReportServer?%2fSupervisor+DSR+woHeaders&rs:Format=EXCELOPENXML");
        }
        /*
  * TransferLocationsLink_LinkClicked
  */
        private void TransferLocationsLink_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start(@"http://" + SSRSServerBox.Text.ToString() + "/ReportServer/Pages/ReportViewer.aspx?%2fTransfer+Locations&rs:Format=EXCELOPENXML");
        }
        /*
         * Button1_Click_2
        */
        private void Button1_Click_2(object sender, EventArgs e)
        {
            Process.Start(@"http://" + SSRSServerBox.Text.ToString() + "/Reports/browse");
        }
        /*
         * selectJSButton_Click
         */
        public string tempfilepath;
        /*
         * selectJSButton_Click
         */
        private void SelectJSButton_Click(object sender, EventArgs e)
        {
            _ = new TilesUpdate();
            if (openFileDialog2.ShowDialog() == DialogResult.OK)
            {
                tempfilepath = openFileDialog2.FileName.ToString();
                TilesUpdate.ReplaceInFile(tempfilepath, "auxReportURLPlaceholder", auxReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "auxReportDatePlaceholder", auxReportUDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "shrinkageReportURLPlaceholder", shrinkageReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "shrinkageReportDatePlaceholder", shrinkageReportUDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "dailystackrankReportURLPlaceholder", DSRReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "dailystackrankReportDatePlaceholder", dsrReportUDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "corportalcoachingReportURLPlaceholder", CorPortalCoachingReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "corportalcoachingReportDatePlaceholder", corportalUDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "etdReportURLPlaceholder", ETDReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "etdReportDatePlaceholder", etdReportUDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "irisusageReportURLPlaceholder", IRISReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "irisusageDatePlaceholder", IRISUDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "leadstackrankReportURLPlaceholder", LeadStackReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "leadstackrankReportDatePlaceholder", LDSRUDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "attendanceReportURLPlaceholder", APTReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "attendanceReportDatePlaceholder", aptUDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "alignmentReportURLPlaceholder", AlignmentReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "alignmentReportDatePlaceholder", alignmentReportUDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "rubyReportURLPlaceholder", rubyReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "rubyReportDatePlaceholder", rubyReportUDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "transferlocationsReportURLPlaceholder", transferReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "transferlocationsReportDatePlaceholder", transferReportUDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "workorderdetailsReportURLPlaceholder", woReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "workorderdetailsReportDatePlaceholder", woReportDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "vocdetailsReportURLPlaceholder", vocReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "vocdetailsReportDatePlaceholder", vocReportUDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "monthovermonthURLPlaceholder", MOMReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "monthovermonthReportDatePlaceholder", momReportUDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "sapphireReportURLPlaceholder", SapphireReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "sapphireReportDatePlaceholder", sapphireUDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "emeraldReportURLPlaceholder", EmeraldReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "emeraldReportDatePlaceholder", emeraldUDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "ehhReportURLPlaceholder", EmeraldReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "emeraldReportDatePlaceholder", emeraldUDateBox.Text.ToString());

                TilesUpdate.ReplaceInFile(tempfilepath, "ehhReportURLPlaceholder", ehhReportLinkBox.Text.ToString());
                TilesUpdate.ReplaceInFile(tempfilepath, "ehhReportDatePlaceholder", eehReportUDateBox.Text.ToString());
            }

        }

        /*
         * selectHTMLBUtton_Click
         */
        private void SelectHTMLButton_Click(object sender, EventArgs e)
        {
            
            if (openFileDialog2.ShowDialog() == DialogResult.OK)
            {
                tempfilepath = openFileDialog2.FileName.ToString();
                if (auxReportCheckbox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "auxSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "auxSelectedHTMLBox", ""); }
                if (shrinkageReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "shrinkageSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "shrinkageSelectedHTMLBox", ""); }
                if (DSRReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "dsrSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "dsrSelectedHTMLBox", ""); }
                if (CorPortalCoachingReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "corportalSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "corportalSelectedHTMLBox", ""); }
                if (ETDReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "etdSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "etdSelectedHTMLBox", ""); }
                if (IRISReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "irisSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "irisSelectedHTMLBox", ""); }
                if (LeadStackReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "ldsrSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "ldsrSelectedHTMLBox", ""); }
                if (APTReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "aptSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "aptSelectedHTMLBox", ""); }
                if (AlignmentReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "alignmentSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "alignmentSelectedHTMLBox", ""); }
                if (rubyReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "rubySelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "rubySelectedHTMLBox", ""); }
                if (transferReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "transferlocationsSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "transferlocationsSelectedHTMLBox", ""); }
                if (woReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "woSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "woSelectedHTMLBox", ""); }
                if (vocReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "vocSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "vocSelectedHTMLBox", ""); }
                if (MOMReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "momSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "momSelectedHTMLBox", ""); }
                if (SapphireReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "sapphireSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "sapphireSelectedHTMLBox", ""); }
                if (EmeraldReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "emeraldSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "emeraldSelectedHTMLBox", ""); }
                if (ehhReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "ehhSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "ehhSelectedHTMLBox", ""); }
                if (ehhReportCheckBox.Checked.ToString() == "True")
                { TilesUpdate.ReplaceInFile(tempfilepath, "ehhSelectedHTMLBox", "class=\"selected\""); }
                else { TilesUpdate.ReplaceInFile(tempfilepath, "ehhSelectedHTMLBox", ""); }
            }
        }

        private void AboutToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            using (AboutBox1 aboutBox1 = new AboutBox1())
            {
                aboutBox1.ShowDialog();
            }
        }

        private void AUXAutomationToolStripMenuItem_Click(object sender, EventArgs e)
        {
           

        }

        private void AUXReportToolStripMenuItem_Click(object sender, EventArgs e)
        {
            AuxAutomation auxAutomation = new AuxAutomation();
            auxAutomation.StartAuxAutomation(reportTemplates.ToString(), dataPath.ToString());
        }
       

        private void APTReportToolStripMenuItem_Click(object sender, EventArgs e)
        {
            APTUpdateStatus APTUpdateStatus = new APTUpdateStatus
            {
                sqlPassword = sqlPasswordBox.Text.ToString(),
                sqlUserName = sqlUsernameBox.Text.ToString(),
                sqlServer = sqlServerAddressBox.Text.ToString(),
                filepath = reportTemplates.ToString()
            };

            APTUpdateStatus.ShowDialog();
            

            
        }

        private void DSRReportToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Automation.RunDSR(dataPath.ToString());
        }

        private void SelectedToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SelectedAutomation selectedAutomation = new SelectedAutomation();
            selectedAutomation.ShowDialog();
        }

        private void AlignmentToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void IRISReportToolStripMenuItem_Click(object sender, EventArgs e)
        {
            IRISAuto.RunAuto(dataPath);
        }

        private void RubyMeterReportToolStripMenuItem_Click(object sender, EventArgs e)
        {
            RubyAuto.RunAuto(dataPath);
        }

        private void ExportReportDataToolStripMenuItem_Click(object sender, EventArgs e)
        {
            AATAutoFunctions.GetData(msaccessPath, dataPath);
        }



        private void TrimAATSPListToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (AATTrim AATTrim = new AATTrim())
            {
                AATTrim.filepath = msaccessPath;
                AATTrim.ShowDialog();
            }
        }

        private void TransferLocReportToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //TransferLocationsAuto TransferLocationsAuto = new TransferLocationsAuto();
            TransferLocationsAuto.TransferAuto(reportTemplates, dataPath);
        }

        private void RosterDownloadToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Process.Start("chrome.exe", "https://uxid-nce.corp.chartercom.com/generateReport/EnterpriseView?accountType=Worker%20Account&addAccount=N&addProfile=Y&locationMA=152");
            Thread.Sleep(15000);


            Excel.Application xlApp = new Excel.Application
            {
                Visible = false,
                DisplayAlerts = false
            };
                Excel.Workbook xlWorkbook = xlApp.Workbooks.Open(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments).ToString() + "/Daily_Data/EnterpriseReport.xls", 0, false, 5, "", "", true, Excel.XlPlatform.xlWindows, "\t", false, false, 0, true, 1, 0);

            Excel.Worksheet xlWorksheet = xlWorkbook.Sheets[1];
            xlWorksheet.Activate();

            xlWorksheet.Range[xlWorksheet.Cells[1, Type.Missing], xlWorksheet.Cells[1, Type.Missing]].EntireRow.Delete();
            xlWorksheet.Name = "Roster";
            xlWorkbook.SaveCopyAs(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments).ToString() + "/Daily_Data/Roster.xls");
            xlWorkbook.Close();
            xlApp.Quit();
            File.Delete(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments).ToString() + "/Daily_Data/EnterpriseReport.xls");
            MessageBox.Show("Roster Downloaded Sucessfully");
        }

        private void CorPortalCoachingsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Process.Start("chrome.exe", "https://corportal.corp.chartercom.com/main/forms/default.aspx?Forms=48");
        }

        private void SetDefaultFoldersToolStripMenuItem_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog folderBrowserDialog1 = new FolderBrowserDialog();
            folderBrowserDialog1.Description = "Select Report Templates Folder";
            if(folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                reportTemplates = folderBrowserDialog1.SelectedPath.ToString();
            }
            folderBrowserDialog1.Description = "Select Data Downloads Folder";
            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                dataPath = folderBrowserDialog1.SelectedPath.ToString();
                folderPath.Text = folderBrowserDialog1.SelectedPath.ToString();
            }
            folderBrowserDialog1.Description = "Select Data Connections Downloads Folder";
            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                msaccessPath = folderBrowserDialog1.SelectedPath.ToString();
            }
            folderBrowserDialog1.Dispose();

        }

        private void vOCReportToolStripMenuItem_Click(object sender, EventArgs e)
        {
            VOCAuto.FullVOCAuto(dataPath, reportTemplates);
        }

        private void eTDReportToolStripMenuItem_Click(object sender, EventArgs e)
        {
            ETDAuto.ETDFullAuto(reportTemplates, dataPath);
        }

        private void WorkOrderDetailsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            WorkOrderDetailsAuto.WorkOrderDetailsAuto.FullAuto(dataPath, reportTemplates);
        }
    }
    }
//}




