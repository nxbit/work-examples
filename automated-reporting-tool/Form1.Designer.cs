using Microsoft.VisualBasic;
using System.Threading;
namespace WorkAutomation
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.sqlPasswordBox = new System.Windows.Forms.TextBox();
            this.sqlServerAddressBox = new System.Windows.Forms.TextBox();
            this.sqlDatabaseBox = new System.Windows.Forms.TextBox();
            this.sqlTestConn = new System.Windows.Forms.Button();
            this.SqlServerAddressLabel = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.xlFilePathBox = new System.Windows.Forms.TextBox();
            this.xlDateColBox = new System.Windows.Forms.TextBox();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.selectFileButton = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.sqlUsernameBox = new System.Windows.Forms.TextBox();
            this.uploadFileButton = new System.Windows.Forms.Button();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.fileToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.rosterDownloadToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.corPortalCoachingsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.exitToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.aboutToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.aboutToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.automationToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.setDefaultFoldersToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.aUXReportToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.dSRReportToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.iRISReportToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.rubyMeterReportToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.transferLocReportToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.vOCReportToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.eTDReportToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.aPTReportToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.alignmentToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.weekendAutomationToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.allToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.selectedToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.aATMgmtToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.exportReportDataToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.trimAATSPListToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.sqlTableNameBox = new System.Windows.Forms.TextBox();
            this.sqlTableNameLabel = new System.Windows.Forms.Label();
            this.selectFolderButton = new System.Windows.Forms.Button();
            this.AATData = new System.Windows.Forms.CheckBox();
            this.AgentSchedules = new System.Windows.Forms.CheckBox();
            this.AUXBIData = new System.Windows.Forms.CheckBox();
            this.AvayaSegments = new System.Windows.Forms.CheckBox();
            this.AvayaSuperstates = new System.Windows.Forms.CheckBox();
            this.BIMetricData = new System.Windows.Forms.CheckBox();
            this.BQOEData = new System.Windows.Forms.CheckBox();
            this.CorPortalCoaching = new System.Windows.Forms.CheckBox();
            this.CurrentRoster = new System.Windows.Forms.CheckBox();
            this.EHH = new System.Windows.Forms.CheckBox();
            this.HistoricalRoster = new System.Windows.Forms.CheckBox();
            this.ManagerRoster = new System.Windows.Forms.CheckBox();
            this.Roster = new System.Windows.Forms.CheckBox();
            this.SuperstateMapping = new System.Windows.Forms.CheckBox();
            this.SupervisorRoster = new System.Windows.Forms.CheckBox();
            this.TransferLocations = new System.Windows.Forms.CheckBox();
            this.folderPath = new System.Windows.Forms.TextBox();
            this.uploadMulti = new System.Windows.Forms.Button();
            this.folderBrowserDialog1 = new System.Windows.Forms.FolderBrowserDialog();
            this.uploadControls = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.uploadControlsProgressBar = new System.Windows.Forms.ProgressBar();
            this.UploadControlsInfo = new System.Windows.Forms.Label();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.pictureBox2 = new System.Windows.Forms.PictureBox();
            this.pictureBox3 = new System.Windows.Forms.PictureBox();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.serverStatusProgressBar = new System.Windows.Forms.ProgressBar();
            this.label6 = new System.Windows.Forms.Label();
            this.checkDatesButton = new System.Windows.Forms.Button();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.sqlTable = new System.Windows.Forms.Label();
            this.TransferLocationsUpdate = new System.Windows.Forms.Label();
            this.LastUpdated = new System.Windows.Forms.Label();
            this.SupervisorRosterUpdate = new System.Windows.Forms.Label();
            this.updatedThrough = new System.Windows.Forms.Label();
            this.SuperstateMappingUpdate = new System.Windows.Forms.Label();
            this.AATDataUpdate = new System.Windows.Forms.Label();
            this.RosterUpdate = new System.Windows.Forms.Label();
            this.AgentSchedulesUpdate = new System.Windows.Forms.Label();
            this.ManagerRosterUpdate = new System.Windows.Forms.Label();
            this.AUXBIDataUpdate = new System.Windows.Forms.Label();
            this.AvayaSegmentsUpdate = new System.Windows.Forms.Label();
            this.AvayaSuperstatesUpdate = new System.Windows.Forms.Label();
            this.CurrentRosterUpdate = new System.Windows.Forms.Label();
            this.BIMetricDataUpdate = new System.Windows.Forms.Label();
            this.CorPortalCoachingUpdate = new System.Windows.Forms.Label();
            this.BQOEDataUpdate = new System.Windows.Forms.Label();
            this.EHHUpdate = new System.Windows.Forms.Label();
            this.AATUpdateTDate = new System.Windows.Forms.Label();
            this.AUXBIDataUpdateTDate = new System.Windows.Forms.Label();
            this.AvayaSegmentsUpdatedTDate = new System.Windows.Forms.Label();
            this.AvayaSuperstatesUpdatedTDate = new System.Windows.Forms.Label();
            this.BIMetricDataUpdatedTDate = new System.Windows.Forms.Label();
            this.BQOEDataUpdatedTDate = new System.Windows.Forms.Label();
            this.CorPortalCoachingUpdatedTDate = new System.Windows.Forms.Label();
            this.CurrentRosterUpdatedTDate = new System.Windows.Forms.Label();
            this.EHHUpdatedTDate = new System.Windows.Forms.Label();
            this.ManagerRosterUpdatedTDate = new System.Windows.Forms.Label();
            this.RosterUpdatedTDate = new System.Windows.Forms.Label();
            this.SuperstateMappingUpdatedTDate = new System.Windows.Forms.Label();
            this.SupervisorRosterUpdatedTDate = new System.Windows.Forms.Label();
            this.TransferLocationsUpdatedTDate = new System.Windows.Forms.Label();
            this.AgentSchedulesUpdateTDate = new System.Windows.Forms.Label();
            this.AATDataUDate = new System.Windows.Forms.Label();
            this.AUXBIDataUDate = new System.Windows.Forms.Label();
            this.AvayaSegmentsUDate = new System.Windows.Forms.Label();
            this.AvayaSuperstatesUDate = new System.Windows.Forms.Label();
            this.BIMetricDataUDate = new System.Windows.Forms.Label();
            this.BQOEDataUDate = new System.Windows.Forms.Label();
            this.CorPortalCoachingUDate = new System.Windows.Forms.Label();
            this.EHHUDate = new System.Windows.Forms.Label();
            this.TransferLocationsUDate = new System.Windows.Forms.Label();
            this.tabPage3 = new System.Windows.Forms.TabPage();
            this.label7 = new System.Windows.Forms.Label();
            this.button1 = new System.Windows.Forms.Button();
            this.TransferLocationsLink = new System.Windows.Forms.LinkLabel();
            this.SupervisorDSRwoHeaders = new System.Windows.Forms.LinkLabel();
            this.SupervisorDSR = new System.Windows.Forms.LinkLabel();
            this.SupervisorDailyIRISwoHeaders = new System.Windows.Forms.LinkLabel();
            this.SupervisorDailyIris = new System.Windows.Forms.LinkLabel();
            this.Shrinkage = new System.Windows.Forms.LinkLabel();
            this.RubyMeter = new System.Windows.Forms.LinkLabel();
            this.ManagerDSRwoHeaders = new System.Windows.Forms.LinkLabel();
            this.ManagerDSR = new System.Windows.Forms.LinkLabel();
            this.LeadDSR = new System.Windows.Forms.LinkLabel();
            this.EHHLinkLabel = new System.Windows.Forms.LinkLabel();
            this.AUXSupervisors = new System.Windows.Forms.LinkLabel();
            this.AgentDSRwoHeaders = new System.Windows.Forms.LinkLabel();
            this.AgentDSR = new System.Windows.Forms.LinkLabel();
            this.AgentDailyIriswoHeaders = new System.Windows.Forms.LinkLabel();
            this.AgentDailyIrisUsage = new System.Windows.Forms.LinkLabel();
            this.SSRSServerBox = new System.Windows.Forms.TextBox();
            this.SSRSServerLabel = new System.Windows.Forms.Label();
            this.pictureBox4 = new System.Windows.Forms.PictureBox();
            this.tabPage4 = new System.Windows.Forms.TabPage();
            this.selectJSButton = new System.Windows.Forms.Button();
            this.selectHTMLButton = new System.Windows.Forms.Button();
            this.label21 = new System.Windows.Forms.Label();
            this.panel17 = new System.Windows.Forms.Panel();
            this.woReportDateBox = new System.Windows.Forms.DateTimePicker();
            this.WOReportLabel = new System.Windows.Forms.Label();
            this.woReportLinkBox = new System.Windows.Forms.TextBox();
            this.woReportCheckBox = new System.Windows.Forms.CheckBox();
            this.panel16 = new System.Windows.Forms.Panel();
            this.vocReportUDateBox = new System.Windows.Forms.DateTimePicker();
            this.vocReportLabel = new System.Windows.Forms.Label();
            this.vocReportLinkBox = new System.Windows.Forms.TextBox();
            this.vocReportCheckBox = new System.Windows.Forms.CheckBox();
            this.panel15 = new System.Windows.Forms.Panel();
            this.corportalUDateBox = new System.Windows.Forms.DateTimePicker();
            this.CorPortalCoachingReportLabel = new System.Windows.Forms.Label();
            this.CorPortalCoachingReportLinkBox = new System.Windows.Forms.TextBox();
            this.CorPortalCoachingReportCheckBox = new System.Windows.Forms.CheckBox();
            this.panel14 = new System.Windows.Forms.Panel();
            this.LDSRUDateBox = new System.Windows.Forms.DateTimePicker();
            this.LeadStackReportLabel = new System.Windows.Forms.Label();
            this.LeadStackReportLinkBox = new System.Windows.Forms.TextBox();
            this.LeadStackReportCheckBox = new System.Windows.Forms.CheckBox();
            this.panel13 = new System.Windows.Forms.Panel();
            this.aptUDateBox = new System.Windows.Forms.DateTimePicker();
            this.APTReportLabel = new System.Windows.Forms.Label();
            this.APTReportLinkBox = new System.Windows.Forms.TextBox();
            this.APTReportCheckBox = new System.Windows.Forms.CheckBox();
            this.panel12 = new System.Windows.Forms.Panel();
            this.momReportUDateBox = new System.Windows.Forms.DateTimePicker();
            this.MOMReportLabel = new System.Windows.Forms.Label();
            this.MOMReportLinkBox = new System.Windows.Forms.TextBox();
            this.MOMReportCheckBox = new System.Windows.Forms.CheckBox();
            this.panel11 = new System.Windows.Forms.Panel();
            this.IRISUDateBox = new System.Windows.Forms.DateTimePicker();
            this.IRISReportLabel = new System.Windows.Forms.Label();
            this.IRISReportLinkBox = new System.Windows.Forms.TextBox();
            this.IRISReportCheckBox = new System.Windows.Forms.CheckBox();
            this.panel10 = new System.Windows.Forms.Panel();
            this.alignmentReportUDateBox = new System.Windows.Forms.DateTimePicker();
            this.AlignmentReportLabel = new System.Windows.Forms.Label();
            this.AlignmentReportLinkBox = new System.Windows.Forms.TextBox();
            this.AlignmentReportCheckBox = new System.Windows.Forms.CheckBox();
            this.panel9 = new System.Windows.Forms.Panel();
            this.transferReportUDateBox = new System.Windows.Forms.DateTimePicker();
            this.transferReportLabel = new System.Windows.Forms.Label();
            this.transferReportLinkBox = new System.Windows.Forms.TextBox();
            this.transferReportCheckBox = new System.Windows.Forms.CheckBox();
            this.panel8 = new System.Windows.Forms.Panel();
            this.emeraldUDateBox = new System.Windows.Forms.DateTimePicker();
            this.EmeraldReportLabel = new System.Windows.Forms.Label();
            this.EmeraldReportLinkBox = new System.Windows.Forms.TextBox();
            this.EmeraldReportCheckBox = new System.Windows.Forms.CheckBox();
            this.panel7 = new System.Windows.Forms.Panel();
            this.rubyReportUDateBox = new System.Windows.Forms.DateTimePicker();
            this.rubyReportLabel = new System.Windows.Forms.Label();
            this.rubyReportLinkBox = new System.Windows.Forms.TextBox();
            this.rubyReportCheckBox = new System.Windows.Forms.CheckBox();
            this.panel6 = new System.Windows.Forms.Panel();
            this.sapphireUDateBox = new System.Windows.Forms.DateTimePicker();
            this.SapphireReportLabel = new System.Windows.Forms.Label();
            this.SapphireReportLinkBox = new System.Windows.Forms.TextBox();
            this.SapphireReportCheckBox = new System.Windows.Forms.CheckBox();
            this.panel5 = new System.Windows.Forms.Panel();
            this.etdReportUDateBox = new System.Windows.Forms.DateTimePicker();
            this.ETDReportLabel = new System.Windows.Forms.Label();
            this.ETDReportLinkBox = new System.Windows.Forms.TextBox();
            this.ETDReportCheckBox = new System.Windows.Forms.CheckBox();
            this.panel4 = new System.Windows.Forms.Panel();
            this.shrinkageReportUDateBox = new System.Windows.Forms.DateTimePicker();
            this.ShrinkageReportLabel = new System.Windows.Forms.Label();
            this.shrinkageReportLinkBox = new System.Windows.Forms.TextBox();
            this.shrinkageReportCheckBox = new System.Windows.Forms.CheckBox();
            this.panel3 = new System.Windows.Forms.Panel();
            this.dsrReportUDateBox = new System.Windows.Forms.DateTimePicker();
            this.DSRReportLabel = new System.Windows.Forms.Label();
            this.DSRReportLinkBox = new System.Windows.Forms.TextBox();
            this.DSRReportCheckBox = new System.Windows.Forms.CheckBox();
            this.panel2 = new System.Windows.Forms.Panel();
            this.eehReportUDateBox = new System.Windows.Forms.DateTimePicker();
            this.EHHReportLabel = new System.Windows.Forms.Label();
            this.ehhReportLinkBox = new System.Windows.Forms.TextBox();
            this.ehhReportCheckBox = new System.Windows.Forms.CheckBox();
            this.auxReportLinkBox = new System.Windows.Forms.TextBox();
            this.auxReportCheckbox = new System.Windows.Forms.CheckBox();
            this.auxReportLabel = new System.Windows.Forms.Label();
            this.panel1 = new System.Windows.Forms.Panel();
            this.auxReportUDateBox = new System.Windows.Forms.DateTimePicker();
            this.backgroundWorker1 = new System.ComponentModel.BackgroundWorker();
            this.openFileDialog2 = new System.Windows.Forms.OpenFileDialog();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage5 = new System.Windows.Forms.TabPage();
            this.webBrowser1 = new System.Windows.Forms.WebBrowser();
            this.tabPage6 = new System.Windows.Forms.TabPage();
            this.webBrowser2 = new System.Windows.Forms.WebBrowser();
            this.tabPage7 = new System.Windows.Forms.TabPage();
            this.webBrowser3 = new System.Windows.Forms.WebBrowser();
            this.tabPage8 = new System.Windows.Forms.TabPage();
            this.webBrowser4 = new System.Windows.Forms.WebBrowser();
            this.workOrderDetailsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.menuStrip1.SuspendLayout();
            this.uploadControls.SuspendLayout();
            this.tabPage1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox3)).BeginInit();
            this.tabPage2.SuspendLayout();
            this.tableLayoutPanel1.SuspendLayout();
            this.tabPage3.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox4)).BeginInit();
            this.tabPage4.SuspendLayout();
            this.panel17.SuspendLayout();
            this.panel16.SuspendLayout();
            this.panel15.SuspendLayout();
            this.panel14.SuspendLayout();
            this.panel13.SuspendLayout();
            this.panel12.SuspendLayout();
            this.panel11.SuspendLayout();
            this.panel10.SuspendLayout();
            this.panel9.SuspendLayout();
            this.panel8.SuspendLayout();
            this.panel7.SuspendLayout();
            this.panel6.SuspendLayout();
            this.panel5.SuspendLayout();
            this.panel4.SuspendLayout();
            this.panel3.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panel1.SuspendLayout();
            this.tabControl1.SuspendLayout();
            this.tabPage5.SuspendLayout();
            this.tabPage6.SuspendLayout();
            this.tabPage7.SuspendLayout();
            this.tabPage8.SuspendLayout();
            this.SuspendLayout();
            // 
            // sqlPasswordBox
            // 
            this.sqlPasswordBox.Location = new System.Drawing.Point(90, 225);
            this.sqlPasswordBox.Name = "sqlPasswordBox";
            this.sqlPasswordBox.PasswordChar = '*';
            this.sqlPasswordBox.Size = new System.Drawing.Size(100, 20);
            this.sqlPasswordBox.TabIndex = 2;
            // 
            // sqlServerAddressBox
            // 
            this.sqlServerAddressBox.Location = new System.Drawing.Point(90, 173);
            this.sqlServerAddressBox.Name = "sqlServerAddressBox";
            this.sqlServerAddressBox.Size = new System.Drawing.Size(100, 20);
            this.sqlServerAddressBox.TabIndex = 0;
            // 
            // sqlDatabaseBox
            // 
            this.sqlDatabaseBox.Location = new System.Drawing.Point(90, 251);
            this.sqlDatabaseBox.Name = "sqlDatabaseBox";
            this.sqlDatabaseBox.Size = new System.Drawing.Size(100, 20);
            this.sqlDatabaseBox.TabIndex = 3;
            // 
            // sqlTestConn
            // 
            this.sqlTestConn.Location = new System.Drawing.Point(99, 277);
            this.sqlTestConn.Name = "sqlTestConn";
            this.sqlTestConn.Size = new System.Drawing.Size(75, 23);
            this.sqlTestConn.TabIndex = 4;
            this.sqlTestConn.Text = "SQL Test";
            this.sqlTestConn.UseVisualStyleBackColor = true;
            this.sqlTestConn.Click += new System.EventHandler(this.SqlTestConn_Click);
            // 
            // SqlServerAddressLabel
            // 
            this.SqlServerAddressLabel.AutoSize = true;
            this.SqlServerAddressLabel.Location = new System.Drawing.Point(5, 176);
            this.SqlServerAddressLabel.Name = "SqlServerAddressLabel";
            this.SqlServerAddressLabel.Size = new System.Drawing.Size(79, 13);
            this.SqlServerAddressLabel.TabIndex = 5;
            this.SqlServerAddressLabel.Text = "Server Address";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(24, 202);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(60, 13);
            this.label1.TabIndex = 6;
            this.label1.Text = "User Name";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(31, 228);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(53, 13);
            this.label2.TabIndex = 7;
            this.label2.Text = "Password";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(31, 254);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(53, 13);
            this.label3.TabIndex = 8;
            this.label3.Text = "Database";
            // 
            // xlFilePathBox
            // 
            this.xlFilePathBox.Location = new System.Drawing.Point(276, 173);
            this.xlFilePathBox.Name = "xlFilePathBox";
            this.xlFilePathBox.ReadOnly = true;
            this.xlFilePathBox.Size = new System.Drawing.Size(100, 20);
            this.xlFilePathBox.TabIndex = 9;
            // 
            // xlDateColBox
            // 
            this.xlDateColBox.Location = new System.Drawing.Point(276, 199);
            this.xlDateColBox.Name = "xlDateColBox";
            this.xlDateColBox.Size = new System.Drawing.Size(100, 20);
            this.xlDateColBox.TabIndex = 10;
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.DefaultExt = "xlsx";
            this.openFileDialog1.FileName = "openFileDialog1";
            this.openFileDialog1.InitialDirectory = "C:\\";
            this.openFileDialog1.Title = "Select Excel File";
            // 
            // selectFileButton
            // 
            this.selectFileButton.Location = new System.Drawing.Point(287, 251);
            this.selectFileButton.Name = "selectFileButton";
            this.selectFileButton.Size = new System.Drawing.Size(75, 23);
            this.selectFileButton.TabIndex = 11;
            this.selectFileButton.Text = "Select File";
            this.selectFileButton.UseVisualStyleBackColor = true;
            this.selectFileButton.Click += new System.EventHandler(this.Button1_Click);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(216, 176);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(54, 13);
            this.label4.TabIndex = 12;
            this.label4.Text = "File Name";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(202, 202);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(68, 13);
            this.label5.TabIndex = 13;
            this.label5.Text = "Date Column";
            // 
            // sqlUsernameBox
            // 
            this.sqlUsernameBox.Location = new System.Drawing.Point(90, 199);
            this.sqlUsernameBox.Name = "sqlUsernameBox";
            this.sqlUsernameBox.Size = new System.Drawing.Size(100, 20);
            this.sqlUsernameBox.TabIndex = 1;
            // 
            // uploadFileButton
            // 
            this.uploadFileButton.Location = new System.Drawing.Point(287, 280);
            this.uploadFileButton.Name = "uploadFileButton";
            this.uploadFileButton.Size = new System.Drawing.Size(75, 23);
            this.uploadFileButton.TabIndex = 16;
            this.uploadFileButton.Text = "Upload File";
            this.uploadFileButton.UseVisualStyleBackColor = true;
            this.uploadFileButton.Click += new System.EventHandler(this.UploadFileButton_Click);
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.fileToolStripMenuItem,
            this.aboutToolStripMenuItem,
            this.automationToolStripMenuItem,
            this.weekendAutomationToolStripMenuItem,
            this.aATMgmtToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(1117, 24);
            this.menuStrip1.TabIndex = 17;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // fileToolStripMenuItem
            // 
            this.fileToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.rosterDownloadToolStripMenuItem,
            this.corPortalCoachingsToolStripMenuItem,
            this.exitToolStripMenuItem});
            this.fileToolStripMenuItem.Name = "fileToolStripMenuItem";
            this.fileToolStripMenuItem.Size = new System.Drawing.Size(37, 20);
            this.fileToolStripMenuItem.Text = "File";
            // 
            // rosterDownloadToolStripMenuItem
            // 
            this.rosterDownloadToolStripMenuItem.Name = "rosterDownloadToolStripMenuItem";
            this.rosterDownloadToolStripMenuItem.Size = new System.Drawing.Size(183, 22);
            this.rosterDownloadToolStripMenuItem.Text = "Roster Download";
            this.rosterDownloadToolStripMenuItem.Click += new System.EventHandler(this.RosterDownloadToolStripMenuItem_Click);
            // 
            // corPortalCoachingsToolStripMenuItem
            // 
            this.corPortalCoachingsToolStripMenuItem.Name = "corPortalCoachingsToolStripMenuItem";
            this.corPortalCoachingsToolStripMenuItem.Size = new System.Drawing.Size(183, 22);
            this.corPortalCoachingsToolStripMenuItem.Text = "CorPortal Coachings";
            this.corPortalCoachingsToolStripMenuItem.Click += new System.EventHandler(this.CorPortalCoachingsToolStripMenuItem_Click);
            // 
            // exitToolStripMenuItem
            // 
            this.exitToolStripMenuItem.Name = "exitToolStripMenuItem";
            this.exitToolStripMenuItem.Size = new System.Drawing.Size(183, 22);
            this.exitToolStripMenuItem.Text = "Exit";
            this.exitToolStripMenuItem.Click += new System.EventHandler(this.ExitToolStripMenuItem_Click);
            // 
            // aboutToolStripMenuItem
            // 
            this.aboutToolStripMenuItem.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.aboutToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.aboutToolStripMenuItem1});
            this.aboutToolStripMenuItem.Name = "aboutToolStripMenuItem";
            this.aboutToolStripMenuItem.Size = new System.Drawing.Size(52, 20);
            this.aboutToolStripMenuItem.Text = "About";
            // 
            // aboutToolStripMenuItem1
            // 
            this.aboutToolStripMenuItem1.Name = "aboutToolStripMenuItem1";
            this.aboutToolStripMenuItem1.Size = new System.Drawing.Size(107, 22);
            this.aboutToolStripMenuItem1.Text = "About";
            this.aboutToolStripMenuItem1.Click += new System.EventHandler(this.AboutToolStripMenuItem1_Click);
            // 
            // automationToolStripMenuItem
            // 
            this.automationToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.setDefaultFoldersToolStripMenuItem,
            this.aUXReportToolStripMenuItem,
            this.dSRReportToolStripMenuItem,
            this.iRISReportToolStripMenuItem,
            this.rubyMeterReportToolStripMenuItem,
            this.transferLocReportToolStripMenuItem,
            this.vOCReportToolStripMenuItem,
            this.eTDReportToolStripMenuItem,
            this.aPTReportToolStripMenuItem,
            this.alignmentToolStripMenuItem,
            this.workOrderDetailsToolStripMenuItem});
            this.automationToolStripMenuItem.Name = "automationToolStripMenuItem";
            this.automationToolStripMenuItem.Size = new System.Drawing.Size(83, 20);
            this.automationToolStripMenuItem.Text = "Automation";
            // 
            // setDefaultFoldersToolStripMenuItem
            // 
            this.setDefaultFoldersToolStripMenuItem.Name = "setDefaultFoldersToolStripMenuItem";
            this.setDefaultFoldersToolStripMenuItem.Size = new System.Drawing.Size(180, 22);
            this.setDefaultFoldersToolStripMenuItem.Text = "Set Default Folders";
            this.setDefaultFoldersToolStripMenuItem.Click += new System.EventHandler(this.SetDefaultFoldersToolStripMenuItem_Click);
            // 
            // aUXReportToolStripMenuItem
            // 
            this.aUXReportToolStripMenuItem.Name = "aUXReportToolStripMenuItem";
            this.aUXReportToolStripMenuItem.Size = new System.Drawing.Size(180, 22);
            this.aUXReportToolStripMenuItem.Text = "AUX Report";
            this.aUXReportToolStripMenuItem.Click += new System.EventHandler(this.AUXReportToolStripMenuItem_Click);
            // 
            // dSRReportToolStripMenuItem
            // 
            this.dSRReportToolStripMenuItem.Name = "dSRReportToolStripMenuItem";
            this.dSRReportToolStripMenuItem.Size = new System.Drawing.Size(180, 22);
            this.dSRReportToolStripMenuItem.Text = "DSR Report";
            this.dSRReportToolStripMenuItem.Click += new System.EventHandler(this.DSRReportToolStripMenuItem_Click);
            // 
            // iRISReportToolStripMenuItem
            // 
            this.iRISReportToolStripMenuItem.Name = "iRISReportToolStripMenuItem";
            this.iRISReportToolStripMenuItem.Size = new System.Drawing.Size(180, 22);
            this.iRISReportToolStripMenuItem.Text = "IRIS Report";
            this.iRISReportToolStripMenuItem.Click += new System.EventHandler(this.IRISReportToolStripMenuItem_Click);
            // 
            // rubyMeterReportToolStripMenuItem
            // 
            this.rubyMeterReportToolStripMenuItem.Name = "rubyMeterReportToolStripMenuItem";
            this.rubyMeterReportToolStripMenuItem.Size = new System.Drawing.Size(180, 22);
            this.rubyMeterReportToolStripMenuItem.Text = "RubyMeter Report";
            this.rubyMeterReportToolStripMenuItem.Click += new System.EventHandler(this.RubyMeterReportToolStripMenuItem_Click);
            // 
            // transferLocReportToolStripMenuItem
            // 
            this.transferLocReportToolStripMenuItem.Name = "transferLocReportToolStripMenuItem";
            this.transferLocReportToolStripMenuItem.Size = new System.Drawing.Size(180, 22);
            this.transferLocReportToolStripMenuItem.Text = "Transfer Loc Report";
            this.transferLocReportToolStripMenuItem.Click += new System.EventHandler(this.TransferLocReportToolStripMenuItem_Click);
            // 
            // vOCReportToolStripMenuItem
            // 
            this.vOCReportToolStripMenuItem.Name = "vOCReportToolStripMenuItem";
            this.vOCReportToolStripMenuItem.Size = new System.Drawing.Size(180, 22);
            this.vOCReportToolStripMenuItem.Text = "VOC Report";
            this.vOCReportToolStripMenuItem.Click += new System.EventHandler(this.vOCReportToolStripMenuItem_Click);
            // 
            // eTDReportToolStripMenuItem
            // 
            this.eTDReportToolStripMenuItem.Name = "eTDReportToolStripMenuItem";
            this.eTDReportToolStripMenuItem.Size = new System.Drawing.Size(180, 22);
            this.eTDReportToolStripMenuItem.Text = "ETD Report";
            this.eTDReportToolStripMenuItem.Click += new System.EventHandler(this.eTDReportToolStripMenuItem_Click);
            // 
            // aPTReportToolStripMenuItem
            // 
            this.aPTReportToolStripMenuItem.Name = "aPTReportToolStripMenuItem";
            this.aPTReportToolStripMenuItem.Size = new System.Drawing.Size(180, 22);
            this.aPTReportToolStripMenuItem.Text = "APT Report";
            this.aPTReportToolStripMenuItem.Click += new System.EventHandler(this.APTReportToolStripMenuItem_Click);
            // 
            // alignmentToolStripMenuItem
            // 
            this.alignmentToolStripMenuItem.Name = "alignmentToolStripMenuItem";
            this.alignmentToolStripMenuItem.Size = new System.Drawing.Size(180, 22);
            this.alignmentToolStripMenuItem.Text = "Alignment";
            this.alignmentToolStripMenuItem.Click += new System.EventHandler(this.AlignmentToolStripMenuItem_Click);
            // 
            // weekendAutomationToolStripMenuItem
            // 
            this.weekendAutomationToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.allToolStripMenuItem,
            this.selectedToolStripMenuItem});
            this.weekendAutomationToolStripMenuItem.Enabled = false;
            this.weekendAutomationToolStripMenuItem.Name = "weekendAutomationToolStripMenuItem";
            this.weekendAutomationToolStripMenuItem.Size = new System.Drawing.Size(135, 20);
            this.weekendAutomationToolStripMenuItem.Text = "Weekend Automation";
            // 
            // allToolStripMenuItem
            // 
            this.allToolStripMenuItem.Enabled = false;
            this.allToolStripMenuItem.Name = "allToolStripMenuItem";
            this.allToolStripMenuItem.Size = new System.Drawing.Size(118, 22);
            this.allToolStripMenuItem.Text = "All";
            // 
            // selectedToolStripMenuItem
            // 
            this.selectedToolStripMenuItem.Enabled = false;
            this.selectedToolStripMenuItem.Name = "selectedToolStripMenuItem";
            this.selectedToolStripMenuItem.Size = new System.Drawing.Size(118, 22);
            this.selectedToolStripMenuItem.Text = "Selected";
            this.selectedToolStripMenuItem.Click += new System.EventHandler(this.SelectedToolStripMenuItem_Click);
            // 
            // aATMgmtToolStripMenuItem
            // 
            this.aATMgmtToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.exportReportDataToolStripMenuItem,
            this.trimAATSPListToolStripMenuItem});
            this.aATMgmtToolStripMenuItem.Name = "aATMgmtToolStripMenuItem";
            this.aATMgmtToolStripMenuItem.Size = new System.Drawing.Size(77, 20);
            this.aATMgmtToolStripMenuItem.Text = "AAT Mgmt";
            // 
            // exportReportDataToolStripMenuItem
            // 
            this.exportReportDataToolStripMenuItem.Name = "exportReportDataToolStripMenuItem";
            this.exportReportDataToolStripMenuItem.Size = new System.Drawing.Size(172, 22);
            this.exportReportDataToolStripMenuItem.Text = "Export Report Data";
            this.exportReportDataToolStripMenuItem.Click += new System.EventHandler(this.ExportReportDataToolStripMenuItem_Click);
            // 
            // trimAATSPListToolStripMenuItem
            // 
            this.trimAATSPListToolStripMenuItem.Name = "trimAATSPListToolStripMenuItem";
            this.trimAATSPListToolStripMenuItem.Size = new System.Drawing.Size(172, 22);
            this.trimAATSPListToolStripMenuItem.Text = "Trim AAT SP List";
            this.trimAATSPListToolStripMenuItem.Click += new System.EventHandler(this.TrimAATSPListToolStripMenuItem_Click);
            // 
            // sqlTableNameBox
            // 
            this.sqlTableNameBox.Location = new System.Drawing.Point(276, 225);
            this.sqlTableNameBox.Name = "sqlTableNameBox";
            this.sqlTableNameBox.Size = new System.Drawing.Size(100, 20);
            this.sqlTableNameBox.TabIndex = 18;
            // 
            // sqlTableNameLabel
            // 
            this.sqlTableNameLabel.AutoSize = true;
            this.sqlTableNameLabel.Location = new System.Drawing.Point(208, 228);
            this.sqlTableNameLabel.Name = "sqlTableNameLabel";
            this.sqlTableNameLabel.Size = new System.Drawing.Size(62, 13);
            this.sqlTableNameLabel.TabIndex = 19;
            this.sqlTableNameLabel.Text = "TableName";
            // 
            // selectFolderButton
            // 
            this.selectFolderButton.Location = new System.Drawing.Point(25, 529);
            this.selectFolderButton.Name = "selectFolderButton";
            this.selectFolderButton.Size = new System.Drawing.Size(102, 23);
            this.selectFolderButton.TabIndex = 37;
            this.selectFolderButton.Text = "Select Folder";
            this.selectFolderButton.UseVisualStyleBackColor = true;
            this.selectFolderButton.Click += new System.EventHandler(this.SelectFolderButton_Click);
            // 
            // AATData
            // 
            this.AATData.AutoSize = true;
            this.AATData.Location = new System.Drawing.Point(25, 414);
            this.AATData.Name = "AATData";
            this.AATData.Size = new System.Drawing.Size(70, 17);
            this.AATData.TabIndex = 38;
            this.AATData.Text = "AATData";
            this.AATData.UseVisualStyleBackColor = true;
            // 
            // AgentSchedules
            // 
            this.AgentSchedules.AutoSize = true;
            this.AgentSchedules.Location = new System.Drawing.Point(25, 437);
            this.AgentSchedules.Name = "AgentSchedules";
            this.AgentSchedules.Size = new System.Drawing.Size(104, 17);
            this.AgentSchedules.TabIndex = 39;
            this.AgentSchedules.Text = "AgentSchedules";
            this.AgentSchedules.UseVisualStyleBackColor = true;
            // 
            // AUXBIData
            // 
            this.AUXBIData.AutoSize = true;
            this.AUXBIData.Location = new System.Drawing.Point(25, 460);
            this.AUXBIData.Name = "AUXBIData";
            this.AUXBIData.Size = new System.Drawing.Size(81, 17);
            this.AUXBIData.TabIndex = 40;
            this.AUXBIData.Text = "AUXBIData";
            this.AUXBIData.UseVisualStyleBackColor = true;
            // 
            // AvayaSegments
            // 
            this.AvayaSegments.AutoSize = true;
            this.AvayaSegments.Location = new System.Drawing.Point(25, 483);
            this.AvayaSegments.Name = "AvayaSegments";
            this.AvayaSegments.Size = new System.Drawing.Size(103, 17);
            this.AvayaSegments.TabIndex = 41;
            this.AvayaSegments.Text = "AvayaSegments";
            this.AvayaSegments.UseVisualStyleBackColor = true;
            // 
            // AvayaSuperstates
            // 
            this.AvayaSuperstates.AutoSize = true;
            this.AvayaSuperstates.Location = new System.Drawing.Point(25, 506);
            this.AvayaSuperstates.Name = "AvayaSuperstates";
            this.AvayaSuperstates.Size = new System.Drawing.Size(112, 17);
            this.AvayaSuperstates.TabIndex = 42;
            this.AvayaSuperstates.Text = "AvayaSuperstates";
            this.AvayaSuperstates.UseVisualStyleBackColor = true;
            // 
            // BIMetricData
            // 
            this.BIMetricData.AutoSize = true;
            this.BIMetricData.Location = new System.Drawing.Point(154, 414);
            this.BIMetricData.Name = "BIMetricData";
            this.BIMetricData.Size = new System.Drawing.Size(88, 17);
            this.BIMetricData.TabIndex = 43;
            this.BIMetricData.Text = "BIMetricData";
            this.BIMetricData.UseVisualStyleBackColor = true;
            // 
            // BQOEData
            // 
            this.BQOEData.AutoSize = true;
            this.BQOEData.Location = new System.Drawing.Point(154, 437);
            this.BQOEData.Name = "BQOEData";
            this.BQOEData.Size = new System.Drawing.Size(79, 17);
            this.BQOEData.TabIndex = 44;
            this.BQOEData.Text = "BQOEData";
            this.BQOEData.UseVisualStyleBackColor = true;
            // 
            // CorPortalCoaching
            // 
            this.CorPortalCoaching.AutoSize = true;
            this.CorPortalCoaching.Location = new System.Drawing.Point(154, 460);
            this.CorPortalCoaching.Name = "CorPortalCoaching";
            this.CorPortalCoaching.Size = new System.Drawing.Size(114, 17);
            this.CorPortalCoaching.TabIndex = 45;
            this.CorPortalCoaching.Text = "CorPortalCoaching";
            this.CorPortalCoaching.UseVisualStyleBackColor = true;
            // 
            // CurrentRoster
            // 
            this.CurrentRoster.AutoSize = true;
            this.CurrentRoster.Location = new System.Drawing.Point(154, 483);
            this.CurrentRoster.Name = "CurrentRoster";
            this.CurrentRoster.Size = new System.Drawing.Size(91, 17);
            this.CurrentRoster.TabIndex = 46;
            this.CurrentRoster.Text = "CurrentRoster";
            this.CurrentRoster.UseVisualStyleBackColor = true;
            // 
            // EHH
            // 
            this.EHH.AutoSize = true;
            this.EHH.Location = new System.Drawing.Point(154, 506);
            this.EHH.Name = "EHH";
            this.EHH.Size = new System.Drawing.Size(49, 17);
            this.EHH.TabIndex = 47;
            this.EHH.Text = "EHH";
            this.EHH.UseVisualStyleBackColor = true;
            // 
            // HistoricalRoster
            // 
            this.HistoricalRoster.AutoSize = true;
            this.HistoricalRoster.Location = new System.Drawing.Point(287, 414);
            this.HistoricalRoster.Name = "HistoricalRoster";
            this.HistoricalRoster.Size = new System.Drawing.Size(100, 17);
            this.HistoricalRoster.TabIndex = 48;
            this.HistoricalRoster.Text = "HistoricalRoster";
            this.HistoricalRoster.UseVisualStyleBackColor = true;
            // 
            // ManagerRoster
            // 
            this.ManagerRoster.AutoSize = true;
            this.ManagerRoster.Location = new System.Drawing.Point(287, 437);
            this.ManagerRoster.Name = "ManagerRoster";
            this.ManagerRoster.Size = new System.Drawing.Size(99, 17);
            this.ManagerRoster.TabIndex = 49;
            this.ManagerRoster.Text = "ManagerRoster";
            this.ManagerRoster.UseVisualStyleBackColor = true;
            // 
            // Roster
            // 
            this.Roster.AutoSize = true;
            this.Roster.Location = new System.Drawing.Point(287, 460);
            this.Roster.Name = "Roster";
            this.Roster.Size = new System.Drawing.Size(57, 17);
            this.Roster.TabIndex = 50;
            this.Roster.Text = "Roster";
            this.Roster.UseVisualStyleBackColor = true;
            // 
            // SuperstateMapping
            // 
            this.SuperstateMapping.AutoSize = true;
            this.SuperstateMapping.Location = new System.Drawing.Point(287, 483);
            this.SuperstateMapping.Name = "SuperstateMapping";
            this.SuperstateMapping.Size = new System.Drawing.Size(118, 17);
            this.SuperstateMapping.TabIndex = 51;
            this.SuperstateMapping.Text = "SuperstateMapping";
            this.SuperstateMapping.UseVisualStyleBackColor = true;
            // 
            // SupervisorRoster
            // 
            this.SupervisorRoster.AutoSize = true;
            this.SupervisorRoster.Location = new System.Drawing.Point(287, 506);
            this.SupervisorRoster.Name = "SupervisorRoster";
            this.SupervisorRoster.Size = new System.Drawing.Size(107, 17);
            this.SupervisorRoster.TabIndex = 52;
            this.SupervisorRoster.Text = "SupervisorRoster";
            this.SupervisorRoster.UseVisualStyleBackColor = true;
            // 
            // TransferLocations
            // 
            this.TransferLocations.AutoSize = true;
            this.TransferLocations.Location = new System.Drawing.Point(287, 529);
            this.TransferLocations.Name = "TransferLocations";
            this.TransferLocations.Size = new System.Drawing.Size(111, 17);
            this.TransferLocations.TabIndex = 53;
            this.TransferLocations.Text = "TransferLocations";
            this.TransferLocations.UseVisualStyleBackColor = true;
            // 
            // folderPath
            // 
            this.folderPath.Location = new System.Drawing.Point(133, 529);
            this.folderPath.Name = "folderPath";
            this.folderPath.ReadOnly = true;
            this.folderPath.Size = new System.Drawing.Size(138, 20);
            this.folderPath.TabIndex = 54;
            // 
            // uploadMulti
            // 
            this.uploadMulti.Location = new System.Drawing.Point(25, 558);
            this.uploadMulti.Name = "uploadMulti";
            this.uploadMulti.Size = new System.Drawing.Size(103, 23);
            this.uploadMulti.TabIndex = 55;
            this.uploadMulti.Text = "Upload Selected";
            this.uploadMulti.UseVisualStyleBackColor = true;
            this.uploadMulti.Click += new System.EventHandler(this.Button1_Click_1);
            // 
            // uploadControls
            // 
            this.uploadControls.Controls.Add(this.tabPage1);
            this.uploadControls.Controls.Add(this.tabPage2);
            this.uploadControls.Controls.Add(this.tabPage3);
            this.uploadControls.Controls.Add(this.tabPage4);
            this.uploadControls.Location = new System.Drawing.Point(12, 27);
            this.uploadControls.Name = "uploadControls";
            this.uploadControls.SelectedIndex = 0;
            this.uploadControls.Size = new System.Drawing.Size(418, 633);
            this.uploadControls.TabIndex = 56;
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.uploadControlsProgressBar);
            this.tabPage1.Controls.Add(this.UploadControlsInfo);
            this.tabPage1.Controls.Add(this.pictureBox1);
            this.tabPage1.Controls.Add(this.uploadMulti);
            this.tabPage1.Controls.Add(this.sqlUsernameBox);
            this.tabPage1.Controls.Add(this.folderPath);
            this.tabPage1.Controls.Add(this.sqlPasswordBox);
            this.tabPage1.Controls.Add(this.TransferLocations);
            this.tabPage1.Controls.Add(this.sqlServerAddressBox);
            this.tabPage1.Controls.Add(this.SupervisorRoster);
            this.tabPage1.Controls.Add(this.sqlDatabaseBox);
            this.tabPage1.Controls.Add(this.SuperstateMapping);
            this.tabPage1.Controls.Add(this.sqlTestConn);
            this.tabPage1.Controls.Add(this.Roster);
            this.tabPage1.Controls.Add(this.SqlServerAddressLabel);
            this.tabPage1.Controls.Add(this.ManagerRoster);
            this.tabPage1.Controls.Add(this.label1);
            this.tabPage1.Controls.Add(this.HistoricalRoster);
            this.tabPage1.Controls.Add(this.label2);
            this.tabPage1.Controls.Add(this.EHH);
            this.tabPage1.Controls.Add(this.label3);
            this.tabPage1.Controls.Add(this.CurrentRoster);
            this.tabPage1.Controls.Add(this.label5);
            this.tabPage1.Controls.Add(this.CorPortalCoaching);
            this.tabPage1.Controls.Add(this.pictureBox2);
            this.tabPage1.Controls.Add(this.BQOEData);
            this.tabPage1.Controls.Add(this.xlFilePathBox);
            this.tabPage1.Controls.Add(this.BIMetricData);
            this.tabPage1.Controls.Add(this.xlDateColBox);
            this.tabPage1.Controls.Add(this.AvayaSuperstates);
            this.tabPage1.Controls.Add(this.selectFileButton);
            this.tabPage1.Controls.Add(this.AvayaSegments);
            this.tabPage1.Controls.Add(this.label4);
            this.tabPage1.Controls.Add(this.AUXBIData);
            this.tabPage1.Controls.Add(this.uploadFileButton);
            this.tabPage1.Controls.Add(this.AgentSchedules);
            this.tabPage1.Controls.Add(this.sqlTableNameBox);
            this.tabPage1.Controls.Add(this.AATData);
            this.tabPage1.Controls.Add(this.sqlTableNameLabel);
            this.tabPage1.Controls.Add(this.selectFolderButton);
            this.tabPage1.Controls.Add(this.pictureBox3);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(410, 607);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "Upload Controls";
            this.tabPage1.UseVisualStyleBackColor = true;
            // 
            // uploadControlsProgressBar
            // 
            this.uploadControlsProgressBar.Location = new System.Drawing.Point(9, 587);
            this.uploadControlsProgressBar.Name = "uploadControlsProgressBar";
            this.uploadControlsProgressBar.Size = new System.Drawing.Size(395, 14);
            this.uploadControlsProgressBar.TabIndex = 57;
            this.uploadControlsProgressBar.Visible = false;
            // 
            // UploadControlsInfo
            // 
            this.UploadControlsInfo.AutoSize = true;
            this.UploadControlsInfo.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.UploadControlsInfo.Location = new System.Drawing.Point(6, 10);
            this.UploadControlsInfo.Name = "UploadControlsInfo";
            this.UploadControlsInfo.Size = new System.Drawing.Size(407, 75);
            this.UploadControlsInfo.TabIndex = 56;
            this.UploadControlsInfo.Text = resources.GetString("UploadControlsInfo.Text");
            // 
            // pictureBox1
            // 
            this.pictureBox1.Image = global::WorkAutomation.Properties.Resources.sql_icon1;
            this.pictureBox1.Location = new System.Drawing.Point(99, 88);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(87, 79);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pictureBox1.TabIndex = 14;
            this.pictureBox1.TabStop = false;
            // 
            // pictureBox2
            // 
            this.pictureBox2.Image = global::WorkAutomation.Properties.Resources.excel_icon;
            this.pictureBox2.Location = new System.Drawing.Point(287, 88);
            this.pictureBox2.Name = "pictureBox2";
            this.pictureBox2.Size = new System.Drawing.Size(87, 79);
            this.pictureBox2.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pictureBox2.TabIndex = 15;
            this.pictureBox2.TabStop = false;
            // 
            // pictureBox3
            // 
            this.pictureBox3.Image = global::WorkAutomation.Properties.Resources.upload_database;
            this.pictureBox3.InitialImage = global::WorkAutomation.Properties.Resources.upload_database;
            this.pictureBox3.Location = new System.Drawing.Point(154, 320);
            this.pictureBox3.Name = "pictureBox3";
            this.pictureBox3.Size = new System.Drawing.Size(87, 79);
            this.pictureBox3.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pictureBox3.TabIndex = 20;
            this.pictureBox3.TabStop = false;
            // 
            // tabPage2
            // 
            this.tabPage2.Controls.Add(this.serverStatusProgressBar);
            this.tabPage2.Controls.Add(this.label6);
            this.tabPage2.Controls.Add(this.checkDatesButton);
            this.tabPage2.Controls.Add(this.tableLayoutPanel1);
            this.tabPage2.Location = new System.Drawing.Point(4, 22);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(410, 607);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "Server Status";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // serverStatusProgressBar
            // 
            this.serverStatusProgressBar.Location = new System.Drawing.Point(94, 17);
            this.serverStatusProgressBar.Name = "serverStatusProgressBar";
            this.serverStatusProgressBar.Size = new System.Drawing.Size(288, 23);
            this.serverStatusProgressBar.TabIndex = 22;
            this.serverStatusProgressBar.Visible = false;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label6.Location = new System.Drawing.Point(10, 53);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(372, 105);
            this.label6.TabIndex = 21;
            this.label6.Text = resources.GetString("label6.Text");
            // 
            // checkDatesButton
            // 
            this.checkDatesButton.Location = new System.Drawing.Point(12, 17);
            this.checkDatesButton.Name = "checkDatesButton";
            this.checkDatesButton.Size = new System.Drawing.Size(75, 23);
            this.checkDatesButton.TabIndex = 20;
            this.checkDatesButton.Text = "Check";
            this.checkDatesButton.UseVisualStyleBackColor = true;
            this.checkDatesButton.Click += new System.EventHandler(this.CheckDatesButton_Click);
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.CellBorderStyle = System.Windows.Forms.TableLayoutPanelCellBorderStyle.InsetDouble;
            this.tableLayoutPanel1.ColumnCount = 3;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 110F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 150F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 255F));
            this.tableLayoutPanel1.Controls.Add(this.sqlTable, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.TransferLocationsUpdate, 0, 16);
            this.tableLayoutPanel1.Controls.Add(this.LastUpdated, 2, 0);
            this.tableLayoutPanel1.Controls.Add(this.SupervisorRosterUpdate, 0, 15);
            this.tableLayoutPanel1.Controls.Add(this.updatedThrough, 1, 0);
            this.tableLayoutPanel1.Controls.Add(this.SuperstateMappingUpdate, 0, 14);
            this.tableLayoutPanel1.Controls.Add(this.AATDataUpdate, 0, 1);
            this.tableLayoutPanel1.Controls.Add(this.RosterUpdate, 0, 13);
            this.tableLayoutPanel1.Controls.Add(this.AgentSchedulesUpdate, 0, 2);
            this.tableLayoutPanel1.Controls.Add(this.ManagerRosterUpdate, 0, 12);
            this.tableLayoutPanel1.Controls.Add(this.AUXBIDataUpdate, 0, 3);
            this.tableLayoutPanel1.Controls.Add(this.AvayaSegmentsUpdate, 0, 4);
            this.tableLayoutPanel1.Controls.Add(this.AvayaSuperstatesUpdate, 0, 5);
            this.tableLayoutPanel1.Controls.Add(this.CurrentRosterUpdate, 0, 9);
            this.tableLayoutPanel1.Controls.Add(this.BIMetricDataUpdate, 0, 6);
            this.tableLayoutPanel1.Controls.Add(this.CorPortalCoachingUpdate, 0, 8);
            this.tableLayoutPanel1.Controls.Add(this.BQOEDataUpdate, 0, 7);
            this.tableLayoutPanel1.Controls.Add(this.EHHUpdate, 0, 10);
            this.tableLayoutPanel1.Controls.Add(this.AATUpdateTDate, 1, 1);
            this.tableLayoutPanel1.Controls.Add(this.AUXBIDataUpdateTDate, 1, 3);
            this.tableLayoutPanel1.Controls.Add(this.AvayaSegmentsUpdatedTDate, 1, 4);
            this.tableLayoutPanel1.Controls.Add(this.AvayaSuperstatesUpdatedTDate, 1, 5);
            this.tableLayoutPanel1.Controls.Add(this.BIMetricDataUpdatedTDate, 1, 6);
            this.tableLayoutPanel1.Controls.Add(this.BQOEDataUpdatedTDate, 1, 7);
            this.tableLayoutPanel1.Controls.Add(this.CorPortalCoachingUpdatedTDate, 1, 8);
            this.tableLayoutPanel1.Controls.Add(this.CurrentRosterUpdatedTDate, 1, 9);
            this.tableLayoutPanel1.Controls.Add(this.EHHUpdatedTDate, 1, 10);
            this.tableLayoutPanel1.Controls.Add(this.ManagerRosterUpdatedTDate, 1, 12);
            this.tableLayoutPanel1.Controls.Add(this.RosterUpdatedTDate, 1, 13);
            this.tableLayoutPanel1.Controls.Add(this.SuperstateMappingUpdatedTDate, 1, 14);
            this.tableLayoutPanel1.Controls.Add(this.SupervisorRosterUpdatedTDate, 1, 15);
            this.tableLayoutPanel1.Controls.Add(this.TransferLocationsUpdatedTDate, 1, 16);
            this.tableLayoutPanel1.Controls.Add(this.AgentSchedulesUpdateTDate, 1, 2);
            this.tableLayoutPanel1.Controls.Add(this.AATDataUDate, 2, 1);
            this.tableLayoutPanel1.Controls.Add(this.AUXBIDataUDate, 2, 3);
            this.tableLayoutPanel1.Controls.Add(this.AvayaSegmentsUDate, 2, 4);
            this.tableLayoutPanel1.Controls.Add(this.AvayaSuperstatesUDate, 2, 5);
            this.tableLayoutPanel1.Controls.Add(this.BIMetricDataUDate, 2, 6);
            this.tableLayoutPanel1.Controls.Add(this.BQOEDataUDate, 2, 7);
            this.tableLayoutPanel1.Controls.Add(this.CorPortalCoachingUDate, 2, 8);
            this.tableLayoutPanel1.Controls.Add(this.EHHUDate, 2, 10);
            this.tableLayoutPanel1.Controls.Add(this.TransferLocationsUDate, 2, 16);
            this.tableLayoutPanel1.Location = new System.Drawing.Point(4, 161);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 17;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 50F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(398, 428);
            this.tableLayoutPanel1.TabIndex = 19;
            // 
            // sqlTable
            // 
            this.sqlTable.AutoSize = true;
            this.sqlTable.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.sqlTable.Location = new System.Drawing.Point(6, 3);
            this.sqlTable.Name = "sqlTable";
            this.sqlTable.Size = new System.Drawing.Size(74, 15);
            this.sqlTable.TabIndex = 17;
            this.sqlTable.Text = "SQL Table";
            // 
            // TransferLocationsUpdate
            // 
            this.TransferLocationsUpdate.AutoSize = true;
            this.TransferLocationsUpdate.Location = new System.Drawing.Point(6, 401);
            this.TransferLocationsUpdate.Name = "TransferLocationsUpdate";
            this.TransferLocationsUpdate.Size = new System.Drawing.Size(92, 13);
            this.TransferLocationsUpdate.TabIndex = 16;
            this.TransferLocationsUpdate.Text = "TransferLocations";
            // 
            // LastUpdated
            // 
            this.LastUpdated.AutoSize = true;
            this.LastUpdated.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.LastUpdated.Location = new System.Drawing.Point(272, 3);
            this.LastUpdated.Name = "LastUpdated";
            this.LastUpdated.Size = new System.Drawing.Size(92, 15);
            this.LastUpdated.TabIndex = 18;
            this.LastUpdated.Text = "Last Updated";
            // 
            // SupervisorRosterUpdate
            // 
            this.SupervisorRosterUpdate.AutoSize = true;
            this.SupervisorRosterUpdate.Location = new System.Drawing.Point(6, 378);
            this.SupervisorRosterUpdate.Name = "SupervisorRosterUpdate";
            this.SupervisorRosterUpdate.Size = new System.Drawing.Size(88, 13);
            this.SupervisorRosterUpdate.TabIndex = 15;
            this.SupervisorRosterUpdate.Text = "SupervisorRoster";
            // 
            // updatedThrough
            // 
            this.updatedThrough.AutoSize = true;
            this.updatedThrough.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.updatedThrough.Location = new System.Drawing.Point(119, 3);
            this.updatedThrough.Name = "updatedThrough";
            this.updatedThrough.Size = new System.Drawing.Size(118, 15);
            this.updatedThrough.TabIndex = 0;
            this.updatedThrough.Text = "Updated Through";
            // 
            // SuperstateMappingUpdate
            // 
            this.SuperstateMappingUpdate.AutoSize = true;
            this.SuperstateMappingUpdate.Location = new System.Drawing.Point(6, 355);
            this.SuperstateMappingUpdate.Name = "SuperstateMappingUpdate";
            this.SuperstateMappingUpdate.Size = new System.Drawing.Size(99, 13);
            this.SuperstateMappingUpdate.TabIndex = 14;
            this.SuperstateMappingUpdate.Text = "SuperstateMapping";
            // 
            // AATDataUpdate
            // 
            this.AATDataUpdate.AutoSize = true;
            this.AATDataUpdate.Location = new System.Drawing.Point(6, 56);
            this.AATDataUpdate.Name = "AATDataUpdate";
            this.AATDataUpdate.Size = new System.Drawing.Size(51, 13);
            this.AATDataUpdate.TabIndex = 1;
            this.AATDataUpdate.Text = "AATData";
            // 
            // RosterUpdate
            // 
            this.RosterUpdate.AutoSize = true;
            this.RosterUpdate.Location = new System.Drawing.Point(6, 332);
            this.RosterUpdate.Name = "RosterUpdate";
            this.RosterUpdate.Size = new System.Drawing.Size(38, 13);
            this.RosterUpdate.TabIndex = 13;
            this.RosterUpdate.Text = "Roster";
            // 
            // AgentSchedulesUpdate
            // 
            this.AgentSchedulesUpdate.AutoSize = true;
            this.AgentSchedulesUpdate.Location = new System.Drawing.Point(6, 79);
            this.AgentSchedulesUpdate.Name = "AgentSchedulesUpdate";
            this.AgentSchedulesUpdate.Size = new System.Drawing.Size(85, 13);
            this.AgentSchedulesUpdate.TabIndex = 2;
            this.AgentSchedulesUpdate.Text = "AgentSchedules";
            // 
            // ManagerRosterUpdate
            // 
            this.ManagerRosterUpdate.AutoSize = true;
            this.ManagerRosterUpdate.Location = new System.Drawing.Point(6, 309);
            this.ManagerRosterUpdate.Name = "ManagerRosterUpdate";
            this.ManagerRosterUpdate.Size = new System.Drawing.Size(80, 13);
            this.ManagerRosterUpdate.TabIndex = 12;
            this.ManagerRosterUpdate.Text = "ManagerRoster";
            // 
            // AUXBIDataUpdate
            // 
            this.AUXBIDataUpdate.AutoSize = true;
            this.AUXBIDataUpdate.Location = new System.Drawing.Point(6, 102);
            this.AUXBIDataUpdate.Name = "AUXBIDataUpdate";
            this.AUXBIDataUpdate.Size = new System.Drawing.Size(62, 13);
            this.AUXBIDataUpdate.TabIndex = 3;
            this.AUXBIDataUpdate.Text = "AUXBIData";
            // 
            // AvayaSegmentsUpdate
            // 
            this.AvayaSegmentsUpdate.AutoSize = true;
            this.AvayaSegmentsUpdate.Location = new System.Drawing.Point(6, 125);
            this.AvayaSegmentsUpdate.Name = "AvayaSegmentsUpdate";
            this.AvayaSegmentsUpdate.Size = new System.Drawing.Size(84, 13);
            this.AvayaSegmentsUpdate.TabIndex = 4;
            this.AvayaSegmentsUpdate.Text = "AvayaSegments";
            // 
            // AvayaSuperstatesUpdate
            // 
            this.AvayaSuperstatesUpdate.AutoSize = true;
            this.AvayaSuperstatesUpdate.Location = new System.Drawing.Point(6, 148);
            this.AvayaSuperstatesUpdate.Name = "AvayaSuperstatesUpdate";
            this.AvayaSuperstatesUpdate.Size = new System.Drawing.Size(93, 13);
            this.AvayaSuperstatesUpdate.TabIndex = 5;
            this.AvayaSuperstatesUpdate.Text = "AvayaSuperstates";
            // 
            // CurrentRosterUpdate
            // 
            this.CurrentRosterUpdate.AutoSize = true;
            this.CurrentRosterUpdate.Location = new System.Drawing.Point(6, 240);
            this.CurrentRosterUpdate.Name = "CurrentRosterUpdate";
            this.CurrentRosterUpdate.Size = new System.Drawing.Size(72, 13);
            this.CurrentRosterUpdate.TabIndex = 9;
            this.CurrentRosterUpdate.Text = "CurrentRoster";
            // 
            // BIMetricDataUpdate
            // 
            this.BIMetricDataUpdate.AutoSize = true;
            this.BIMetricDataUpdate.Location = new System.Drawing.Point(6, 171);
            this.BIMetricDataUpdate.Name = "BIMetricDataUpdate";
            this.BIMetricDataUpdate.Size = new System.Drawing.Size(69, 13);
            this.BIMetricDataUpdate.TabIndex = 6;
            this.BIMetricDataUpdate.Text = "BIMetricData";
            // 
            // CorPortalCoachingUpdate
            // 
            this.CorPortalCoachingUpdate.AutoSize = true;
            this.CorPortalCoachingUpdate.Location = new System.Drawing.Point(6, 217);
            this.CorPortalCoachingUpdate.Name = "CorPortalCoachingUpdate";
            this.CorPortalCoachingUpdate.Size = new System.Drawing.Size(95, 13);
            this.CorPortalCoachingUpdate.TabIndex = 8;
            this.CorPortalCoachingUpdate.Text = "CorPortalCoaching";
            // 
            // BQOEDataUpdate
            // 
            this.BQOEDataUpdate.AutoSize = true;
            this.BQOEDataUpdate.Location = new System.Drawing.Point(6, 194);
            this.BQOEDataUpdate.Name = "BQOEDataUpdate";
            this.BQOEDataUpdate.Size = new System.Drawing.Size(60, 13);
            this.BQOEDataUpdate.TabIndex = 7;
            this.BQOEDataUpdate.Text = "BQOEData";
            // 
            // EHHUpdate
            // 
            this.EHHUpdate.AutoSize = true;
            this.EHHUpdate.Location = new System.Drawing.Point(6, 263);
            this.EHHUpdate.Name = "EHHUpdate";
            this.EHHUpdate.Size = new System.Drawing.Size(30, 13);
            this.EHHUpdate.TabIndex = 10;
            this.EHHUpdate.Text = "EHH";
            // 
            // AATUpdateTDate
            // 
            this.AATUpdateTDate.AutoSize = true;
            this.AATUpdateTDate.Location = new System.Drawing.Point(119, 56);
            this.AATUpdateTDate.Name = "AATUpdateTDate";
            this.AATUpdateTDate.Size = new System.Drawing.Size(0, 13);
            this.AATUpdateTDate.TabIndex = 19;
            // 
            // AUXBIDataUpdateTDate
            // 
            this.AUXBIDataUpdateTDate.AutoSize = true;
            this.AUXBIDataUpdateTDate.Location = new System.Drawing.Point(119, 102);
            this.AUXBIDataUpdateTDate.Name = "AUXBIDataUpdateTDate";
            this.AUXBIDataUpdateTDate.Size = new System.Drawing.Size(10, 13);
            this.AUXBIDataUpdateTDate.TabIndex = 20;
            this.AUXBIDataUpdateTDate.Text = " ";
            // 
            // AvayaSegmentsUpdatedTDate
            // 
            this.AvayaSegmentsUpdatedTDate.AutoSize = true;
            this.AvayaSegmentsUpdatedTDate.Location = new System.Drawing.Point(119, 125);
            this.AvayaSegmentsUpdatedTDate.Name = "AvayaSegmentsUpdatedTDate";
            this.AvayaSegmentsUpdatedTDate.Size = new System.Drawing.Size(10, 13);
            this.AvayaSegmentsUpdatedTDate.TabIndex = 21;
            this.AvayaSegmentsUpdatedTDate.Text = " ";
            // 
            // AvayaSuperstatesUpdatedTDate
            // 
            this.AvayaSuperstatesUpdatedTDate.AutoSize = true;
            this.AvayaSuperstatesUpdatedTDate.Location = new System.Drawing.Point(119, 148);
            this.AvayaSuperstatesUpdatedTDate.Name = "AvayaSuperstatesUpdatedTDate";
            this.AvayaSuperstatesUpdatedTDate.Size = new System.Drawing.Size(10, 13);
            this.AvayaSuperstatesUpdatedTDate.TabIndex = 22;
            this.AvayaSuperstatesUpdatedTDate.Text = " ";
            // 
            // BIMetricDataUpdatedTDate
            // 
            this.BIMetricDataUpdatedTDate.AutoSize = true;
            this.BIMetricDataUpdatedTDate.Location = new System.Drawing.Point(119, 171);
            this.BIMetricDataUpdatedTDate.Name = "BIMetricDataUpdatedTDate";
            this.BIMetricDataUpdatedTDate.Size = new System.Drawing.Size(10, 13);
            this.BIMetricDataUpdatedTDate.TabIndex = 23;
            this.BIMetricDataUpdatedTDate.Text = " ";
            // 
            // BQOEDataUpdatedTDate
            // 
            this.BQOEDataUpdatedTDate.AutoSize = true;
            this.BQOEDataUpdatedTDate.Location = new System.Drawing.Point(119, 194);
            this.BQOEDataUpdatedTDate.Name = "BQOEDataUpdatedTDate";
            this.BQOEDataUpdatedTDate.Size = new System.Drawing.Size(10, 13);
            this.BQOEDataUpdatedTDate.TabIndex = 24;
            this.BQOEDataUpdatedTDate.Text = " ";
            // 
            // CorPortalCoachingUpdatedTDate
            // 
            this.CorPortalCoachingUpdatedTDate.AutoSize = true;
            this.CorPortalCoachingUpdatedTDate.Location = new System.Drawing.Point(119, 217);
            this.CorPortalCoachingUpdatedTDate.Name = "CorPortalCoachingUpdatedTDate";
            this.CorPortalCoachingUpdatedTDate.Size = new System.Drawing.Size(10, 13);
            this.CorPortalCoachingUpdatedTDate.TabIndex = 25;
            this.CorPortalCoachingUpdatedTDate.Text = " ";
            // 
            // CurrentRosterUpdatedTDate
            // 
            this.CurrentRosterUpdatedTDate.AutoSize = true;
            this.CurrentRosterUpdatedTDate.Location = new System.Drawing.Point(119, 240);
            this.CurrentRosterUpdatedTDate.Name = "CurrentRosterUpdatedTDate";
            this.CurrentRosterUpdatedTDate.Size = new System.Drawing.Size(10, 13);
            this.CurrentRosterUpdatedTDate.TabIndex = 26;
            this.CurrentRosterUpdatedTDate.Text = " ";
            // 
            // EHHUpdatedTDate
            // 
            this.EHHUpdatedTDate.AutoSize = true;
            this.EHHUpdatedTDate.Location = new System.Drawing.Point(119, 263);
            this.EHHUpdatedTDate.Name = "EHHUpdatedTDate";
            this.EHHUpdatedTDate.Size = new System.Drawing.Size(10, 13);
            this.EHHUpdatedTDate.TabIndex = 27;
            this.EHHUpdatedTDate.Text = " ";
            // 
            // ManagerRosterUpdatedTDate
            // 
            this.ManagerRosterUpdatedTDate.AutoSize = true;
            this.ManagerRosterUpdatedTDate.Location = new System.Drawing.Point(119, 309);
            this.ManagerRosterUpdatedTDate.Name = "ManagerRosterUpdatedTDate";
            this.ManagerRosterUpdatedTDate.Size = new System.Drawing.Size(10, 13);
            this.ManagerRosterUpdatedTDate.TabIndex = 29;
            this.ManagerRosterUpdatedTDate.Text = " ";
            // 
            // RosterUpdatedTDate
            // 
            this.RosterUpdatedTDate.AutoSize = true;
            this.RosterUpdatedTDate.Location = new System.Drawing.Point(119, 332);
            this.RosterUpdatedTDate.Name = "RosterUpdatedTDate";
            this.RosterUpdatedTDate.Size = new System.Drawing.Size(10, 13);
            this.RosterUpdatedTDate.TabIndex = 30;
            this.RosterUpdatedTDate.Text = " ";
            // 
            // SuperstateMappingUpdatedTDate
            // 
            this.SuperstateMappingUpdatedTDate.AutoSize = true;
            this.SuperstateMappingUpdatedTDate.Location = new System.Drawing.Point(119, 355);
            this.SuperstateMappingUpdatedTDate.Name = "SuperstateMappingUpdatedTDate";
            this.SuperstateMappingUpdatedTDate.Size = new System.Drawing.Size(10, 13);
            this.SuperstateMappingUpdatedTDate.TabIndex = 31;
            this.SuperstateMappingUpdatedTDate.Text = " ";
            // 
            // SupervisorRosterUpdatedTDate
            // 
            this.SupervisorRosterUpdatedTDate.AutoSize = true;
            this.SupervisorRosterUpdatedTDate.Location = new System.Drawing.Point(119, 378);
            this.SupervisorRosterUpdatedTDate.Name = "SupervisorRosterUpdatedTDate";
            this.SupervisorRosterUpdatedTDate.Size = new System.Drawing.Size(10, 13);
            this.SupervisorRosterUpdatedTDate.TabIndex = 32;
            this.SupervisorRosterUpdatedTDate.Text = " ";
            // 
            // TransferLocationsUpdatedTDate
            // 
            this.TransferLocationsUpdatedTDate.AutoSize = true;
            this.TransferLocationsUpdatedTDate.Location = new System.Drawing.Point(119, 401);
            this.TransferLocationsUpdatedTDate.Name = "TransferLocationsUpdatedTDate";
            this.TransferLocationsUpdatedTDate.Size = new System.Drawing.Size(10, 13);
            this.TransferLocationsUpdatedTDate.TabIndex = 33;
            this.TransferLocationsUpdatedTDate.Text = " ";
            // 
            // AgentSchedulesUpdateTDate
            // 
            this.AgentSchedulesUpdateTDate.AutoSize = true;
            this.AgentSchedulesUpdateTDate.Location = new System.Drawing.Point(119, 79);
            this.AgentSchedulesUpdateTDate.Name = "AgentSchedulesUpdateTDate";
            this.AgentSchedulesUpdateTDate.Size = new System.Drawing.Size(13, 13);
            this.AgentSchedulesUpdateTDate.TabIndex = 34;
            this.AgentSchedulesUpdateTDate.Text = "  ";
            // 
            // AATDataUDate
            // 
            this.AATDataUDate.AutoSize = true;
            this.AATDataUDate.Location = new System.Drawing.Point(272, 56);
            this.AATDataUDate.Name = "AATDataUDate";
            this.AATDataUDate.Size = new System.Drawing.Size(13, 13);
            this.AATDataUDate.TabIndex = 35;
            this.AATDataUDate.Text = "  ";
            // 
            // AUXBIDataUDate
            // 
            this.AUXBIDataUDate.AutoSize = true;
            this.AUXBIDataUDate.Location = new System.Drawing.Point(272, 102);
            this.AUXBIDataUDate.Name = "AUXBIDataUDate";
            this.AUXBIDataUDate.Size = new System.Drawing.Size(13, 13);
            this.AUXBIDataUDate.TabIndex = 36;
            this.AUXBIDataUDate.Text = "  ";
            // 
            // AvayaSegmentsUDate
            // 
            this.AvayaSegmentsUDate.AutoSize = true;
            this.AvayaSegmentsUDate.Location = new System.Drawing.Point(272, 125);
            this.AvayaSegmentsUDate.Name = "AvayaSegmentsUDate";
            this.AvayaSegmentsUDate.Size = new System.Drawing.Size(13, 13);
            this.AvayaSegmentsUDate.TabIndex = 37;
            this.AvayaSegmentsUDate.Text = "  ";
            // 
            // AvayaSuperstatesUDate
            // 
            this.AvayaSuperstatesUDate.AutoSize = true;
            this.AvayaSuperstatesUDate.Location = new System.Drawing.Point(272, 148);
            this.AvayaSuperstatesUDate.Name = "AvayaSuperstatesUDate";
            this.AvayaSuperstatesUDate.Size = new System.Drawing.Size(13, 13);
            this.AvayaSuperstatesUDate.TabIndex = 38;
            this.AvayaSuperstatesUDate.Text = "  ";
            // 
            // BIMetricDataUDate
            // 
            this.BIMetricDataUDate.AutoSize = true;
            this.BIMetricDataUDate.Location = new System.Drawing.Point(272, 171);
            this.BIMetricDataUDate.Name = "BIMetricDataUDate";
            this.BIMetricDataUDate.Size = new System.Drawing.Size(13, 13);
            this.BIMetricDataUDate.TabIndex = 39;
            this.BIMetricDataUDate.Text = "  ";
            // 
            // BQOEDataUDate
            // 
            this.BQOEDataUDate.AutoSize = true;
            this.BQOEDataUDate.Location = new System.Drawing.Point(272, 194);
            this.BQOEDataUDate.Name = "BQOEDataUDate";
            this.BQOEDataUDate.Size = new System.Drawing.Size(13, 13);
            this.BQOEDataUDate.TabIndex = 40;
            this.BQOEDataUDate.Text = "  ";
            // 
            // CorPortalCoachingUDate
            // 
            this.CorPortalCoachingUDate.AutoSize = true;
            this.CorPortalCoachingUDate.Location = new System.Drawing.Point(272, 217);
            this.CorPortalCoachingUDate.Name = "CorPortalCoachingUDate";
            this.CorPortalCoachingUDate.Size = new System.Drawing.Size(13, 13);
            this.CorPortalCoachingUDate.TabIndex = 41;
            this.CorPortalCoachingUDate.Text = "  ";
            // 
            // EHHUDate
            // 
            this.EHHUDate.AutoSize = true;
            this.EHHUDate.Location = new System.Drawing.Point(272, 263);
            this.EHHUDate.Name = "EHHUDate";
            this.EHHUDate.Size = new System.Drawing.Size(13, 13);
            this.EHHUDate.TabIndex = 42;
            this.EHHUDate.Text = "  ";
            // 
            // TransferLocationsUDate
            // 
            this.TransferLocationsUDate.AutoSize = true;
            this.TransferLocationsUDate.Location = new System.Drawing.Point(272, 401);
            this.TransferLocationsUDate.Name = "TransferLocationsUDate";
            this.TransferLocationsUDate.Size = new System.Drawing.Size(13, 13);
            this.TransferLocationsUDate.TabIndex = 44;
            this.TransferLocationsUDate.Text = "  ";
            // 
            // tabPage3
            // 
            this.tabPage3.Controls.Add(this.label7);
            this.tabPage3.Controls.Add(this.button1);
            this.tabPage3.Controls.Add(this.TransferLocationsLink);
            this.tabPage3.Controls.Add(this.SupervisorDSRwoHeaders);
            this.tabPage3.Controls.Add(this.SupervisorDSR);
            this.tabPage3.Controls.Add(this.SupervisorDailyIRISwoHeaders);
            this.tabPage3.Controls.Add(this.SupervisorDailyIris);
            this.tabPage3.Controls.Add(this.Shrinkage);
            this.tabPage3.Controls.Add(this.RubyMeter);
            this.tabPage3.Controls.Add(this.ManagerDSRwoHeaders);
            this.tabPage3.Controls.Add(this.ManagerDSR);
            this.tabPage3.Controls.Add(this.LeadDSR);
            this.tabPage3.Controls.Add(this.EHHLinkLabel);
            this.tabPage3.Controls.Add(this.AUXSupervisors);
            this.tabPage3.Controls.Add(this.AgentDSRwoHeaders);
            this.tabPage3.Controls.Add(this.AgentDSR);
            this.tabPage3.Controls.Add(this.AgentDailyIriswoHeaders);
            this.tabPage3.Controls.Add(this.AgentDailyIrisUsage);
            this.tabPage3.Controls.Add(this.SSRSServerBox);
            this.tabPage3.Controls.Add(this.SSRSServerLabel);
            this.tabPage3.Controls.Add(this.pictureBox4);
            this.tabPage3.Location = new System.Drawing.Point(4, 22);
            this.tabPage3.Name = "tabPage3";
            this.tabPage3.Size = new System.Drawing.Size(410, 607);
            this.tabPage3.TabIndex = 2;
            this.tabPage3.Text = "SSRS Reports";
            this.tabPage3.UseVisualStyleBackColor = true;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.Location = new System.Drawing.Point(150, 29);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(236, 90);
            this.label7.TabIndex = 26;
            this.label7.Text = resources.GetString("label7.Text");
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(212, 138);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 25;
            this.button1.Text = "Navigate";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.Button1_Click_2);
            // 
            // TransferLocationsLink
            // 
            this.TransferLocationsLink.AutoSize = true;
            this.TransferLocationsLink.Location = new System.Drawing.Point(21, 533);
            this.TransferLocationsLink.Name = "TransferLocationsLink";
            this.TransferLocationsLink.Size = new System.Drawing.Size(95, 13);
            this.TransferLocationsLink.TabIndex = 23;
            this.TransferLocationsLink.TabStop = true;
            this.TransferLocationsLink.Text = "Transfer Locations";
            this.TransferLocationsLink.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.TransferLocationsLink_LinkClicked);
            // 
            // SupervisorDSRwoHeaders
            // 
            this.SupervisorDSRwoHeaders.AutoSize = true;
            this.SupervisorDSRwoHeaders.Location = new System.Drawing.Point(21, 510);
            this.SupervisorDSRwoHeaders.Name = "SupervisorDSRwoHeaders";
            this.SupervisorDSRwoHeaders.Size = new System.Drawing.Size(143, 13);
            this.SupervisorDSRwoHeaders.TabIndex = 22;
            this.SupervisorDSRwoHeaders.TabStop = true;
            this.SupervisorDSRwoHeaders.Text = "Supervisor DSR wo Headers";
            this.SupervisorDSRwoHeaders.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.SupervisorDSRwoHeaders_LinkClicked);
            // 
            // SupervisorDSR
            // 
            this.SupervisorDSR.AutoSize = true;
            this.SupervisorDSR.Location = new System.Drawing.Point(21, 487);
            this.SupervisorDSR.Name = "SupervisorDSR";
            this.SupervisorDSR.Size = new System.Drawing.Size(80, 13);
            this.SupervisorDSR.TabIndex = 21;
            this.SupervisorDSR.TabStop = true;
            this.SupervisorDSR.Text = "SupervisorDSR";
            this.SupervisorDSR.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.SupervisorDSR_LinkClicked);
            // 
            // SupervisorDailyIRISwoHeaders
            // 
            this.SupervisorDailyIRISwoHeaders.AutoSize = true;
            this.SupervisorDailyIRISwoHeaders.Location = new System.Drawing.Point(21, 464);
            this.SupervisorDailyIRISwoHeaders.Name = "SupervisorDailyIRISwoHeaders";
            this.SupervisorDailyIRISwoHeaders.Size = new System.Drawing.Size(167, 13);
            this.SupervisorDailyIRISwoHeaders.TabIndex = 20;
            this.SupervisorDailyIRISwoHeaders.TabStop = true;
            this.SupervisorDailyIRISwoHeaders.Text = "Supervisor Daily IRIS wo Headers";
            this.SupervisorDailyIRISwoHeaders.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.SupervisorDailyIRISwoHeaders_LinkClicked);
            // 
            // SupervisorDailyIris
            // 
            this.SupervisorDailyIris.AutoSize = true;
            this.SupervisorDailyIris.Location = new System.Drawing.Point(21, 441);
            this.SupervisorDailyIris.Name = "SupervisorDailyIris";
            this.SupervisorDailyIris.Size = new System.Drawing.Size(107, 13);
            this.SupervisorDailyIris.TabIndex = 19;
            this.SupervisorDailyIris.TabStop = true;
            this.SupervisorDailyIris.Text = "Supervisor Daily IRIS";
            this.SupervisorDailyIris.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.SupervisorDailyIris_LinkClicked);
            // 
            // Shrinkage
            // 
            this.Shrinkage.AutoSize = true;
            this.Shrinkage.Location = new System.Drawing.Point(21, 418);
            this.Shrinkage.Name = "Shrinkage";
            this.Shrinkage.Size = new System.Drawing.Size(55, 13);
            this.Shrinkage.TabIndex = 18;
            this.Shrinkage.TabStop = true;
            this.Shrinkage.Text = "Shrinkage";
            this.Shrinkage.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.Shrinkage_LinkClicked);
            // 
            // RubyMeter
            // 
            this.RubyMeter.AutoSize = true;
            this.RubyMeter.Location = new System.Drawing.Point(24, 391);
            this.RubyMeter.Name = "RubyMeter";
            this.RubyMeter.Size = new System.Drawing.Size(63, 17);
            this.RubyMeter.TabIndex = 17;
            this.RubyMeter.TabStop = true;
            this.RubyMeter.Text = "Ruby Meter";
            this.RubyMeter.UseCompatibleTextRendering = true;
            this.RubyMeter.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.RubyMeter_LinkClicked);
            // 
            // ManagerDSRwoHeaders
            // 
            this.ManagerDSRwoHeaders.AutoSize = true;
            this.ManagerDSRwoHeaders.Location = new System.Drawing.Point(21, 368);
            this.ManagerDSRwoHeaders.Name = "ManagerDSRwoHeaders";
            this.ManagerDSRwoHeaders.Size = new System.Drawing.Size(135, 13);
            this.ManagerDSRwoHeaders.TabIndex = 16;
            this.ManagerDSRwoHeaders.TabStop = true;
            this.ManagerDSRwoHeaders.Text = "Manager DSR wo Headers";
            this.ManagerDSRwoHeaders.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.ManagerDSRwoHeaders_LinkClicked);
            // 
            // ManagerDSR
            // 
            this.ManagerDSR.AutoSize = true;
            this.ManagerDSR.Location = new System.Drawing.Point(21, 345);
            this.ManagerDSR.Name = "ManagerDSR";
            this.ManagerDSR.Size = new System.Drawing.Size(75, 13);
            this.ManagerDSR.TabIndex = 15;
            this.ManagerDSR.TabStop = true;
            this.ManagerDSR.Text = "Manager DSR";
            this.ManagerDSR.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.ManagerDSR_LinkClicked);
            // 
            // LeadDSR
            // 
            this.LeadDSR.AutoSize = true;
            this.LeadDSR.Location = new System.Drawing.Point(21, 322);
            this.LeadDSR.Name = "LeadDSR";
            this.LeadDSR.Size = new System.Drawing.Size(57, 13);
            this.LeadDSR.TabIndex = 14;
            this.LeadDSR.TabStop = true;
            this.LeadDSR.Text = "Lead DSR";
            this.LeadDSR.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.LeadDSR_LinkClicked);
            // 
            // EHHLinkLabel
            // 
            this.EHHLinkLabel.AutoSize = true;
            this.EHHLinkLabel.Location = new System.Drawing.Point(21, 299);
            this.EHHLinkLabel.Name = "EHHLinkLabel";
            this.EHHLinkLabel.Size = new System.Drawing.Size(30, 13);
            this.EHHLinkLabel.TabIndex = 13;
            this.EHHLinkLabel.TabStop = true;
            this.EHHLinkLabel.Text = "EHH";
            this.EHHLinkLabel.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.EHHLinkLabel_LinkClicked);
            // 
            // AUXSupervisors
            // 
            this.AUXSupervisors.AutoSize = true;
            this.AUXSupervisors.Location = new System.Drawing.Point(21, 276);
            this.AUXSupervisors.Name = "AUXSupervisors";
            this.AUXSupervisors.Size = new System.Drawing.Size(87, 13);
            this.AUXSupervisors.TabIndex = 12;
            this.AUXSupervisors.TabStop = true;
            this.AUXSupervisors.Text = "AUX Supervisors";
            this.AUXSupervisors.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.AUXSupervisors_LinkClicked);
            // 
            // AgentDSRwoHeaders
            // 
            this.AgentDSRwoHeaders.AutoSize = true;
            this.AgentDSRwoHeaders.Location = new System.Drawing.Point(21, 253);
            this.AgentDSRwoHeaders.Name = "AgentDSRwoHeaders";
            this.AgentDSRwoHeaders.Size = new System.Drawing.Size(121, 13);
            this.AgentDSRwoHeaders.TabIndex = 11;
            this.AgentDSRwoHeaders.TabStop = true;
            this.AgentDSRwoHeaders.Text = "Agent DSR wo Headers";
            this.AgentDSRwoHeaders.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.AgentDSRwoHeaders_LinkClicked);
            // 
            // AgentDSR
            // 
            this.AgentDSR.AutoSize = true;
            this.AgentDSR.Location = new System.Drawing.Point(21, 230);
            this.AgentDSR.Name = "AgentDSR";
            this.AgentDSR.Size = new System.Drawing.Size(61, 13);
            this.AgentDSR.TabIndex = 10;
            this.AgentDSR.TabStop = true;
            this.AgentDSR.Text = "Agent DSR";
            this.AgentDSR.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.AgentDSR_LinkClicked);
            // 
            // AgentDailyIriswoHeaders
            // 
            this.AgentDailyIriswoHeaders.AutoSize = true;
            this.AgentDailyIriswoHeaders.Location = new System.Drawing.Point(21, 207);
            this.AgentDailyIriswoHeaders.Name = "AgentDailyIriswoHeaders";
            this.AgentDailyIriswoHeaders.Size = new System.Drawing.Size(179, 13);
            this.AgentDailyIriswoHeaders.TabIndex = 9;
            this.AgentDailyIriswoHeaders.TabStop = true;
            this.AgentDailyIriswoHeaders.Text = "Agent Daily IRIS Usage wo Headers";
            this.AgentDailyIriswoHeaders.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.AgentDailyIriswoHeaders_LinkClicked);
            // 
            // AgentDailyIrisUsage
            // 
            this.AgentDailyIrisUsage.AutoSize = true;
            this.AgentDailyIrisUsage.Location = new System.Drawing.Point(21, 184);
            this.AgentDailyIrisUsage.Name = "AgentDailyIrisUsage";
            this.AgentDailyIrisUsage.Size = new System.Drawing.Size(119, 13);
            this.AgentDailyIrisUsage.TabIndex = 8;
            this.AgentDailyIrisUsage.TabStop = true;
            this.AgentDailyIrisUsage.Text = "Agent Daily IRIS Usage";
            this.AgentDailyIrisUsage.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.AgentDailyIrisUsage_LinkClicked);
            // 
            // SSRSServerBox
            // 
            this.SSRSServerBox.Location = new System.Drawing.Point(106, 141);
            this.SSRSServerBox.Name = "SSRSServerBox";
            this.SSRSServerBox.Size = new System.Drawing.Size(100, 20);
            this.SSRSServerBox.TabIndex = 6;
            // 
            // SSRSServerLabel
            // 
            this.SSRSServerLabel.AutoSize = true;
            this.SSRSServerLabel.Location = new System.Drawing.Point(21, 144);
            this.SSRSServerLabel.Name = "SSRSServerLabel";
            this.SSRSServerLabel.Size = new System.Drawing.Size(79, 13);
            this.SSRSServerLabel.TabIndex = 7;
            this.SSRSServerLabel.Text = "Server Address";
            // 
            // pictureBox4
            // 
            this.pictureBox4.Image = global::WorkAutomation.Properties.Resources.SSRSlogo;
            this.pictureBox4.Location = new System.Drawing.Point(29, 29);
            this.pictureBox4.Name = "pictureBox4";
            this.pictureBox4.Size = new System.Drawing.Size(87, 79);
            this.pictureBox4.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pictureBox4.TabIndex = 24;
            this.pictureBox4.TabStop = false;
            // 
            // tabPage4
            // 
            this.tabPage4.Controls.Add(this.selectJSButton);
            this.tabPage4.Controls.Add(this.selectHTMLButton);
            this.tabPage4.Controls.Add(this.label21);
            this.tabPage4.Controls.Add(this.panel17);
            this.tabPage4.Controls.Add(this.panel16);
            this.tabPage4.Controls.Add(this.panel15);
            this.tabPage4.Controls.Add(this.panel14);
            this.tabPage4.Controls.Add(this.panel13);
            this.tabPage4.Controls.Add(this.panel12);
            this.tabPage4.Controls.Add(this.panel11);
            this.tabPage4.Controls.Add(this.panel10);
            this.tabPage4.Controls.Add(this.panel9);
            this.tabPage4.Controls.Add(this.panel8);
            this.tabPage4.Controls.Add(this.panel7);
            this.tabPage4.Controls.Add(this.panel6);
            this.tabPage4.Controls.Add(this.panel5);
            this.tabPage4.Controls.Add(this.panel4);
            this.tabPage4.Controls.Add(this.panel3);
            this.tabPage4.Controls.Add(this.panel2);
            this.tabPage4.Controls.Add(this.auxReportLinkBox);
            this.tabPage4.Controls.Add(this.auxReportCheckbox);
            this.tabPage4.Controls.Add(this.auxReportLabel);
            this.tabPage4.Controls.Add(this.panel1);
            this.tabPage4.Location = new System.Drawing.Point(4, 22);
            this.tabPage4.Name = "tabPage4";
            this.tabPage4.Size = new System.Drawing.Size(410, 607);
            this.tabPage4.TabIndex = 3;
            this.tabPage4.Text = "Tiles Update";
            this.tabPage4.UseVisualStyleBackColor = true;
            // 
            // selectJSButton
            // 
            this.selectJSButton.Location = new System.Drawing.Point(161, 99);
            this.selectJSButton.Name = "selectJSButton";
            this.selectJSButton.Size = new System.Drawing.Size(82, 23);
            this.selectJSButton.TabIndex = 17;
            this.selectJSButton.Text = "Select JS";
            this.selectJSButton.UseVisualStyleBackColor = true;
            this.selectJSButton.Click += new System.EventHandler(this.SelectJSButton_Click);
            // 
            // selectHTMLButton
            // 
            this.selectHTMLButton.Location = new System.Drawing.Point(161, 68);
            this.selectHTMLButton.Name = "selectHTMLButton";
            this.selectHTMLButton.Size = new System.Drawing.Size(82, 23);
            this.selectHTMLButton.TabIndex = 16;
            this.selectHTMLButton.Text = "Select HTML";
            this.selectHTMLButton.UseVisualStyleBackColor = true;
            this.selectHTMLButton.Click += new System.EventHandler(this.SelectHTMLButton_Click);
            // 
            // label21
            // 
            this.label21.AutoSize = true;
            this.label21.Font = new System.Drawing.Font("Segoe UI", 11.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label21.Location = new System.Drawing.Point(140, 12);
            this.label21.Name = "label21";
            this.label21.Size = new System.Drawing.Size(130, 20);
            this.label21.TabIndex = 15;
            this.label21.Text = "Tiles Update Tool";
            // 
            // panel17
            // 
            this.panel17.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(230)))), ((int)(((byte)(126)))), ((int)(((byte)(34)))));
            this.panel17.Controls.Add(this.woReportDateBox);
            this.panel17.Controls.Add(this.WOReportLabel);
            this.panel17.Controls.Add(this.woReportLinkBox);
            this.panel17.Controls.Add(this.woReportCheckBox);
            this.panel17.Location = new System.Drawing.Point(14, 45);
            this.panel17.Name = "panel17";
            this.panel17.Size = new System.Drawing.Size(124, 87);
            this.panel17.TabIndex = 13;
            // 
            // woReportDateBox
            // 
            this.woReportDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.woReportDateBox.Location = new System.Drawing.Point(14, 57);
            this.woReportDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.woReportDateBox.Name = "woReportDateBox";
            this.woReportDateBox.Size = new System.Drawing.Size(100, 20);
            this.woReportDateBox.TabIndex = 19;
            // 
            // WOReportLabel
            // 
            this.WOReportLabel.AutoSize = true;
            this.WOReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.WOReportLabel.Location = new System.Drawing.Point(14, 11);
            this.WOReportLabel.Name = "WOReportLabel";
            this.WOReportLabel.Size = new System.Drawing.Size(76, 13);
            this.WOReportLabel.TabIndex = 6;
            this.WOReportLabel.Text = "W/O Report";
            // 
            // woReportLinkBox
            // 
            this.woReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.woReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.woReportLinkBox.Location = new System.Drawing.Point(14, 28);
            this.woReportLinkBox.Name = "woReportLinkBox";
            this.woReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.woReportLinkBox.TabIndex = 8;
            this.woReportLinkBox.Text = "W/O Report Link";
            // 
            // woReportCheckBox
            // 
            this.woReportCheckBox.AutoSize = true;
            this.woReportCheckBox.Location = new System.Drawing.Point(99, 11);
            this.woReportCheckBox.Name = "woReportCheckBox";
            this.woReportCheckBox.Size = new System.Drawing.Size(15, 14);
            this.woReportCheckBox.TabIndex = 7;
            this.woReportCheckBox.UseVisualStyleBackColor = true;
            // 
            // panel16
            // 
            this.panel16.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(149)))), ((int)(((byte)(165)))), ((int)(((byte)(166)))));
            this.panel16.Controls.Add(this.vocReportUDateBox);
            this.panel16.Controls.Add(this.vocReportLabel);
            this.panel16.Controls.Add(this.vocReportLinkBox);
            this.panel16.Controls.Add(this.vocReportCheckBox);
            this.panel16.Location = new System.Drawing.Point(274, 45);
            this.panel16.Name = "panel16";
            this.panel16.Size = new System.Drawing.Size(124, 87);
            this.panel16.TabIndex = 12;
            // 
            // vocReportUDateBox
            // 
            this.vocReportUDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.vocReportUDateBox.Location = new System.Drawing.Point(14, 52);
            this.vocReportUDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.vocReportUDateBox.Name = "vocReportUDateBox";
            this.vocReportUDateBox.Size = new System.Drawing.Size(100, 20);
            this.vocReportUDateBox.TabIndex = 35;
            // 
            // vocReportLabel
            // 
            this.vocReportLabel.AutoSize = true;
            this.vocReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.vocReportLabel.Location = new System.Drawing.Point(14, 11);
            this.vocReportLabel.Name = "vocReportLabel";
            this.vocReportLabel.Size = new System.Drawing.Size(74, 13);
            this.vocReportLabel.TabIndex = 6;
            this.vocReportLabel.Text = "VOC Report";
            // 
            // vocReportLinkBox
            // 
            this.vocReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.vocReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.vocReportLinkBox.Location = new System.Drawing.Point(14, 28);
            this.vocReportLinkBox.Name = "vocReportLinkBox";
            this.vocReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.vocReportLinkBox.TabIndex = 8;
            this.vocReportLinkBox.Text = "VOC Report Link";
            // 
            // vocReportCheckBox
            // 
            this.vocReportCheckBox.AutoSize = true;
            this.vocReportCheckBox.Location = new System.Drawing.Point(99, 11);
            this.vocReportCheckBox.Name = "vocReportCheckBox";
            this.vocReportCheckBox.Size = new System.Drawing.Size(15, 14);
            this.vocReportCheckBox.TabIndex = 7;
            this.vocReportCheckBox.UseVisualStyleBackColor = true;
            // 
            // panel15
            // 
            this.panel15.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(142)))), ((int)(((byte)(68)))), ((int)(((byte)(173)))));
            this.panel15.Controls.Add(this.corportalUDateBox);
            this.panel15.Controls.Add(this.CorPortalCoachingReportLabel);
            this.panel15.Controls.Add(this.CorPortalCoachingReportLinkBox);
            this.panel15.Controls.Add(this.CorPortalCoachingReportCheckBox);
            this.panel15.Location = new System.Drawing.Point(274, 510);
            this.panel15.Name = "panel15";
            this.panel15.Size = new System.Drawing.Size(124, 87);
            this.panel15.TabIndex = 11;
            // 
            // corportalUDateBox
            // 
            this.corportalUDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.corportalUDateBox.Location = new System.Drawing.Point(13, 52);
            this.corportalUDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.corportalUDateBox.Name = "corportalUDateBox";
            this.corportalUDateBox.Size = new System.Drawing.Size(100, 20);
            this.corportalUDateBox.TabIndex = 30;
            // 
            // CorPortalCoachingReportLabel
            // 
            this.CorPortalCoachingReportLabel.AutoSize = true;
            this.CorPortalCoachingReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.CorPortalCoachingReportLabel.Location = new System.Drawing.Point(14, 11);
            this.CorPortalCoachingReportLabel.Name = "CorPortalCoachingReportLabel";
            this.CorPortalCoachingReportLabel.Size = new System.Drawing.Size(101, 13);
            this.CorPortalCoachingReportLabel.TabIndex = 6;
            this.CorPortalCoachingReportLabel.Text = "CorPortal Report";
            // 
            // CorPortalCoachingReportLinkBox
            // 
            this.CorPortalCoachingReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.CorPortalCoachingReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.CorPortalCoachingReportLinkBox.Location = new System.Drawing.Point(14, 28);
            this.CorPortalCoachingReportLinkBox.Name = "CorPortalCoachingReportLinkBox";
            this.CorPortalCoachingReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.CorPortalCoachingReportLinkBox.TabIndex = 8;
            this.CorPortalCoachingReportLinkBox.Text = "CorPortal Link";
            // 
            // CorPortalCoachingReportCheckBox
            // 
            this.CorPortalCoachingReportCheckBox.AutoSize = true;
            this.CorPortalCoachingReportCheckBox.Location = new System.Drawing.Point(99, 11);
            this.CorPortalCoachingReportCheckBox.Name = "CorPortalCoachingReportCheckBox";
            this.CorPortalCoachingReportCheckBox.Size = new System.Drawing.Size(15, 14);
            this.CorPortalCoachingReportCheckBox.TabIndex = 7;
            this.CorPortalCoachingReportCheckBox.UseVisualStyleBackColor = true;
            // 
            // panel14
            // 
            this.panel14.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(127)))), ((int)(((byte)(140)))), ((int)(((byte)(141)))));
            this.panel14.Controls.Add(this.LDSRUDateBox);
            this.panel14.Controls.Add(this.LeadStackReportLabel);
            this.panel14.Controls.Add(this.LeadStackReportLinkBox);
            this.panel14.Controls.Add(this.LeadStackReportCheckBox);
            this.panel14.Location = new System.Drawing.Point(144, 510);
            this.panel14.Name = "panel14";
            this.panel14.Size = new System.Drawing.Size(124, 87);
            this.panel14.TabIndex = 11;
            // 
            // LDSRUDateBox
            // 
            this.LDSRUDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.LDSRUDateBox.Location = new System.Drawing.Point(14, 52);
            this.LDSRUDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.LDSRUDateBox.Name = "LDSRUDateBox";
            this.LDSRUDateBox.Size = new System.Drawing.Size(100, 20);
            this.LDSRUDateBox.TabIndex = 29;
            // 
            // LeadStackReportLabel
            // 
            this.LeadStackReportLabel.AutoSize = true;
            this.LeadStackReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.LeadStackReportLabel.Location = new System.Drawing.Point(14, 11);
            this.LeadStackReportLabel.Name = "LeadStackReportLabel";
            this.LeadStackReportLabel.Size = new System.Drawing.Size(77, 13);
            this.LeadStackReportLabel.TabIndex = 6;
            this.LeadStackReportLabel.Text = "Lead Report";
            // 
            // LeadStackReportLinkBox
            // 
            this.LeadStackReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.LeadStackReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.LeadStackReportLinkBox.Location = new System.Drawing.Point(14, 28);
            this.LeadStackReportLinkBox.Name = "LeadStackReportLinkBox";
            this.LeadStackReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.LeadStackReportLinkBox.TabIndex = 8;
            this.LeadStackReportLinkBox.Text = "Lead Report Link";
            // 
            // LeadStackReportCheckBox
            // 
            this.LeadStackReportCheckBox.AutoSize = true;
            this.LeadStackReportCheckBox.Location = new System.Drawing.Point(99, 11);
            this.LeadStackReportCheckBox.Name = "LeadStackReportCheckBox";
            this.LeadStackReportCheckBox.Size = new System.Drawing.Size(15, 14);
            this.LeadStackReportCheckBox.TabIndex = 7;
            this.LeadStackReportCheckBox.UseVisualStyleBackColor = true;
            // 
            // panel13
            // 
            this.panel13.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(52)))), ((int)(((byte)(73)))), ((int)(((byte)(94)))));
            this.panel13.Controls.Add(this.aptUDateBox);
            this.panel13.Controls.Add(this.APTReportLabel);
            this.panel13.Controls.Add(this.APTReportLinkBox);
            this.panel13.Controls.Add(this.APTReportCheckBox);
            this.panel13.Location = new System.Drawing.Point(14, 510);
            this.panel13.Name = "panel13";
            this.panel13.Size = new System.Drawing.Size(124, 87);
            this.panel13.TabIndex = 11;
            // 
            // aptUDateBox
            // 
            this.aptUDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.aptUDateBox.Location = new System.Drawing.Point(14, 52);
            this.aptUDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.aptUDateBox.Name = "aptUDateBox";
            this.aptUDateBox.Size = new System.Drawing.Size(100, 20);
            this.aptUDateBox.TabIndex = 24;
            // 
            // APTReportLabel
            // 
            this.APTReportLabel.AutoSize = true;
            this.APTReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.APTReportLabel.Location = new System.Drawing.Point(14, 11);
            this.APTReportLabel.Name = "APTReportLabel";
            this.APTReportLabel.Size = new System.Drawing.Size(73, 13);
            this.APTReportLabel.TabIndex = 6;
            this.APTReportLabel.Text = "APT Report";
            // 
            // APTReportLinkBox
            // 
            this.APTReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.APTReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.APTReportLinkBox.Location = new System.Drawing.Point(14, 28);
            this.APTReportLinkBox.Name = "APTReportLinkBox";
            this.APTReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.APTReportLinkBox.TabIndex = 8;
            this.APTReportLinkBox.Text = "APT Report Link";
            // 
            // APTReportCheckBox
            // 
            this.APTReportCheckBox.AutoSize = true;
            this.APTReportCheckBox.Location = new System.Drawing.Point(99, 11);
            this.APTReportCheckBox.Name = "APTReportCheckBox";
            this.APTReportCheckBox.Size = new System.Drawing.Size(15, 14);
            this.APTReportCheckBox.TabIndex = 7;
            this.APTReportCheckBox.UseVisualStyleBackColor = true;
            // 
            // panel12
            // 
            this.panel12.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(41)))), ((int)(((byte)(128)))), ((int)(((byte)(185)))));
            this.panel12.Controls.Add(this.momReportUDateBox);
            this.panel12.Controls.Add(this.MOMReportLabel);
            this.panel12.Controls.Add(this.MOMReportLinkBox);
            this.panel12.Controls.Add(this.MOMReportCheckBox);
            this.panel12.Location = new System.Drawing.Point(274, 417);
            this.panel12.Name = "panel12";
            this.panel12.Size = new System.Drawing.Size(124, 87);
            this.panel12.TabIndex = 11;
            // 
            // momReportUDateBox
            // 
            this.momReportUDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.momReportUDateBox.Location = new System.Drawing.Point(13, 52);
            this.momReportUDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.momReportUDateBox.Name = "momReportUDateBox";
            this.momReportUDateBox.Size = new System.Drawing.Size(100, 20);
            this.momReportUDateBox.TabIndex = 31;
            // 
            // MOMReportLabel
            // 
            this.MOMReportLabel.AutoSize = true;
            this.MOMReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.MOMReportLabel.Location = new System.Drawing.Point(14, 11);
            this.MOMReportLabel.Name = "MOMReportLabel";
            this.MOMReportLabel.Size = new System.Drawing.Size(76, 13);
            this.MOMReportLabel.TabIndex = 6;
            this.MOMReportLabel.Text = "MoM Report";
            // 
            // MOMReportLinkBox
            // 
            this.MOMReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.MOMReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.MOMReportLinkBox.Location = new System.Drawing.Point(14, 28);
            this.MOMReportLinkBox.Name = "MOMReportLinkBox";
            this.MOMReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.MOMReportLinkBox.TabIndex = 8;
            this.MOMReportLinkBox.Text = "MoM Report Link";
            // 
            // MOMReportCheckBox
            // 
            this.MOMReportCheckBox.AutoSize = true;
            this.MOMReportCheckBox.Location = new System.Drawing.Point(99, 11);
            this.MOMReportCheckBox.Name = "MOMReportCheckBox";
            this.MOMReportCheckBox.Size = new System.Drawing.Size(15, 14);
            this.MOMReportCheckBox.TabIndex = 7;
            this.MOMReportCheckBox.UseVisualStyleBackColor = true;
            // 
            // panel11
            // 
            this.panel11.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(189)))), ((int)(((byte)(195)))), ((int)(((byte)(199)))));
            this.panel11.Controls.Add(this.IRISUDateBox);
            this.panel11.Controls.Add(this.IRISReportLabel);
            this.panel11.Controls.Add(this.IRISReportLinkBox);
            this.panel11.Controls.Add(this.IRISReportCheckBox);
            this.panel11.Location = new System.Drawing.Point(144, 417);
            this.panel11.Name = "panel11";
            this.panel11.Size = new System.Drawing.Size(124, 87);
            this.panel11.TabIndex = 11;
            // 
            // IRISUDateBox
            // 
            this.IRISUDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.IRISUDateBox.Location = new System.Drawing.Point(14, 55);
            this.IRISUDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.IRISUDateBox.Name = "IRISUDateBox";
            this.IRISUDateBox.Size = new System.Drawing.Size(100, 20);
            this.IRISUDateBox.TabIndex = 28;
            // 
            // IRISReportLabel
            // 
            this.IRISReportLabel.AutoSize = true;
            this.IRISReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.IRISReportLabel.Location = new System.Drawing.Point(14, 11);
            this.IRISReportLabel.Name = "IRISReportLabel";
            this.IRISReportLabel.Size = new System.Drawing.Size(74, 13);
            this.IRISReportLabel.TabIndex = 6;
            this.IRISReportLabel.Text = "IRIS Report";
            // 
            // IRISReportLinkBox
            // 
            this.IRISReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.IRISReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.IRISReportLinkBox.Location = new System.Drawing.Point(14, 31);
            this.IRISReportLinkBox.Name = "IRISReportLinkBox";
            this.IRISReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.IRISReportLinkBox.TabIndex = 8;
            this.IRISReportLinkBox.Text = "IRIS Report Link";
            // 
            // IRISReportCheckBox
            // 
            this.IRISReportCheckBox.AutoSize = true;
            this.IRISReportCheckBox.Location = new System.Drawing.Point(99, 11);
            this.IRISReportCheckBox.Name = "IRISReportCheckBox";
            this.IRISReportCheckBox.Size = new System.Drawing.Size(15, 14);
            this.IRISReportCheckBox.TabIndex = 7;
            this.IRISReportCheckBox.UseVisualStyleBackColor = true;
            // 
            // panel10
            // 
            this.panel10.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(39)))), ((int)(((byte)(174)))), ((int)(((byte)(96)))));
            this.panel10.Controls.Add(this.alignmentReportUDateBox);
            this.panel10.Controls.Add(this.AlignmentReportLabel);
            this.panel10.Controls.Add(this.AlignmentReportLinkBox);
            this.panel10.Controls.Add(this.AlignmentReportCheckBox);
            this.panel10.Location = new System.Drawing.Point(274, 324);
            this.panel10.Name = "panel10";
            this.panel10.Size = new System.Drawing.Size(124, 87);
            this.panel10.TabIndex = 11;
            // 
            // alignmentReportUDateBox
            // 
            this.alignmentReportUDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.alignmentReportUDateBox.Location = new System.Drawing.Point(13, 52);
            this.alignmentReportUDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.alignmentReportUDateBox.Name = "alignmentReportUDateBox";
            this.alignmentReportUDateBox.Size = new System.Drawing.Size(100, 20);
            this.alignmentReportUDateBox.TabIndex = 32;
            // 
            // AlignmentReportLabel
            // 
            this.AlignmentReportLabel.AutoSize = true;
            this.AlignmentReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.AlignmentReportLabel.Location = new System.Drawing.Point(14, 11);
            this.AlignmentReportLabel.Name = "AlignmentReportLabel";
            this.AlignmentReportLabel.Size = new System.Drawing.Size(62, 13);
            this.AlignmentReportLabel.TabIndex = 6;
            this.AlignmentReportLabel.Text = "Alignment";
            // 
            // AlignmentReportLinkBox
            // 
            this.AlignmentReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.AlignmentReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.AlignmentReportLinkBox.Location = new System.Drawing.Point(14, 28);
            this.AlignmentReportLinkBox.Name = "AlignmentReportLinkBox";
            this.AlignmentReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.AlignmentReportLinkBox.TabIndex = 8;
            this.AlignmentReportLinkBox.Text = "Alignment Link";
            // 
            // AlignmentReportCheckBox
            // 
            this.AlignmentReportCheckBox.AutoSize = true;
            this.AlignmentReportCheckBox.Location = new System.Drawing.Point(99, 11);
            this.AlignmentReportCheckBox.Name = "AlignmentReportCheckBox";
            this.AlignmentReportCheckBox.Size = new System.Drawing.Size(15, 14);
            this.AlignmentReportCheckBox.TabIndex = 7;
            this.AlignmentReportCheckBox.UseVisualStyleBackColor = true;
            // 
            // panel9
            // 
            this.panel9.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(211)))), ((int)(((byte)(84)))), ((int)(((byte)(0)))));
            this.panel9.Controls.Add(this.transferReportUDateBox);
            this.panel9.Controls.Add(this.transferReportLabel);
            this.panel9.Controls.Add(this.transferReportLinkBox);
            this.panel9.Controls.Add(this.transferReportCheckBox);
            this.panel9.Location = new System.Drawing.Point(144, 324);
            this.panel9.Name = "panel9";
            this.panel9.Size = new System.Drawing.Size(124, 87);
            this.panel9.TabIndex = 11;
            // 
            // transferReportUDateBox
            // 
            this.transferReportUDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.transferReportUDateBox.Location = new System.Drawing.Point(14, 52);
            this.transferReportUDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.transferReportUDateBox.Name = "transferReportUDateBox";
            this.transferReportUDateBox.Size = new System.Drawing.Size(100, 20);
            this.transferReportUDateBox.TabIndex = 27;
            // 
            // transferReportLabel
            // 
            this.transferReportLabel.AutoSize = true;
            this.transferReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.transferReportLabel.Location = new System.Drawing.Point(14, 11);
            this.transferReportLabel.Name = "transferReportLabel";
            this.transferReportLabel.Size = new System.Drawing.Size(96, 13);
            this.transferReportLabel.TabIndex = 6;
            this.transferReportLabel.Text = "Transfer Report";
            // 
            // transferReportLinkBox
            // 
            this.transferReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.transferReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.transferReportLinkBox.Location = new System.Drawing.Point(14, 28);
            this.transferReportLinkBox.Name = "transferReportLinkBox";
            this.transferReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.transferReportLinkBox.TabIndex = 8;
            this.transferReportLinkBox.Text = "Transfer Link";
            // 
            // transferReportCheckBox
            // 
            this.transferReportCheckBox.AutoSize = true;
            this.transferReportCheckBox.Location = new System.Drawing.Point(99, 11);
            this.transferReportCheckBox.Name = "transferReportCheckBox";
            this.transferReportCheckBox.Size = new System.Drawing.Size(15, 14);
            this.transferReportCheckBox.TabIndex = 7;
            this.transferReportCheckBox.UseVisualStyleBackColor = true;
            // 
            // panel8
            // 
            this.panel8.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(243)))), ((int)(((byte)(156)))), ((int)(((byte)(18)))));
            this.panel8.Controls.Add(this.emeraldUDateBox);
            this.panel8.Controls.Add(this.EmeraldReportLabel);
            this.panel8.Controls.Add(this.EmeraldReportLinkBox);
            this.panel8.Controls.Add(this.EmeraldReportCheckBox);
            this.panel8.Location = new System.Drawing.Point(274, 231);
            this.panel8.Name = "panel8";
            this.panel8.Size = new System.Drawing.Size(124, 87);
            this.panel8.TabIndex = 11;
            // 
            // emeraldUDateBox
            // 
            this.emeraldUDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.emeraldUDateBox.Location = new System.Drawing.Point(13, 52);
            this.emeraldUDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.emeraldUDateBox.Name = "emeraldUDateBox";
            this.emeraldUDateBox.Size = new System.Drawing.Size(100, 20);
            this.emeraldUDateBox.TabIndex = 33;
            // 
            // EmeraldReportLabel
            // 
            this.EmeraldReportLabel.AutoSize = true;
            this.EmeraldReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.EmeraldReportLabel.Location = new System.Drawing.Point(14, 11);
            this.EmeraldReportLabel.Name = "EmeraldReportLabel";
            this.EmeraldReportLabel.Size = new System.Drawing.Size(52, 13);
            this.EmeraldReportLabel.TabIndex = 6;
            this.EmeraldReportLabel.Text = "Emerald";
            // 
            // EmeraldReportLinkBox
            // 
            this.EmeraldReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.EmeraldReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.EmeraldReportLinkBox.Location = new System.Drawing.Point(14, 28);
            this.EmeraldReportLinkBox.Name = "EmeraldReportLinkBox";
            this.EmeraldReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.EmeraldReportLinkBox.TabIndex = 8;
            this.EmeraldReportLinkBox.Text = "Emerald Report Link";
            // 
            // EmeraldReportCheckBox
            // 
            this.EmeraldReportCheckBox.AutoSize = true;
            this.EmeraldReportCheckBox.Location = new System.Drawing.Point(99, 11);
            this.EmeraldReportCheckBox.Name = "EmeraldReportCheckBox";
            this.EmeraldReportCheckBox.Size = new System.Drawing.Size(15, 14);
            this.EmeraldReportCheckBox.TabIndex = 7;
            this.EmeraldReportCheckBox.UseVisualStyleBackColor = true;
            // 
            // panel7
            // 
            this.panel7.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(57)))), ((int)(((byte)(43)))));
            this.panel7.Controls.Add(this.rubyReportUDateBox);
            this.panel7.Controls.Add(this.rubyReportLabel);
            this.panel7.Controls.Add(this.rubyReportLinkBox);
            this.panel7.Controls.Add(this.rubyReportCheckBox);
            this.panel7.Location = new System.Drawing.Point(144, 231);
            this.panel7.Name = "panel7";
            this.panel7.Size = new System.Drawing.Size(124, 87);
            this.panel7.TabIndex = 11;
            // 
            // rubyReportUDateBox
            // 
            this.rubyReportUDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.rubyReportUDateBox.Location = new System.Drawing.Point(14, 52);
            this.rubyReportUDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.rubyReportUDateBox.Name = "rubyReportUDateBox";
            this.rubyReportUDateBox.Size = new System.Drawing.Size(100, 20);
            this.rubyReportUDateBox.TabIndex = 26;
            // 
            // rubyReportLabel
            // 
            this.rubyReportLabel.AutoSize = true;
            this.rubyReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rubyReportLabel.Location = new System.Drawing.Point(14, 11);
            this.rubyReportLabel.Name = "rubyReportLabel";
            this.rubyReportLabel.Size = new System.Drawing.Size(78, 13);
            this.rubyReportLabel.TabIndex = 6;
            this.rubyReportLabel.Text = "Ruby Report";
            // 
            // rubyReportLinkBox
            // 
            this.rubyReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rubyReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.rubyReportLinkBox.Location = new System.Drawing.Point(14, 28);
            this.rubyReportLinkBox.Name = "rubyReportLinkBox";
            this.rubyReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.rubyReportLinkBox.TabIndex = 8;
            this.rubyReportLinkBox.Text = "Ruby Report Link";
            // 
            // rubyReportCheckBox
            // 
            this.rubyReportCheckBox.AutoSize = true;
            this.rubyReportCheckBox.Location = new System.Drawing.Point(99, 11);
            this.rubyReportCheckBox.Name = "rubyReportCheckBox";
            this.rubyReportCheckBox.Size = new System.Drawing.Size(15, 14);
            this.rubyReportCheckBox.TabIndex = 7;
            this.rubyReportCheckBox.UseVisualStyleBackColor = true;
            // 
            // panel6
            // 
            this.panel6.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(22)))), ((int)(((byte)(160)))), ((int)(((byte)(133)))));
            this.panel6.Controls.Add(this.sapphireUDateBox);
            this.panel6.Controls.Add(this.SapphireReportLabel);
            this.panel6.Controls.Add(this.SapphireReportLinkBox);
            this.panel6.Controls.Add(this.SapphireReportCheckBox);
            this.panel6.Location = new System.Drawing.Point(274, 138);
            this.panel6.Name = "panel6";
            this.panel6.Size = new System.Drawing.Size(124, 87);
            this.panel6.TabIndex = 11;
            // 
            // sapphireUDateBox
            // 
            this.sapphireUDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.sapphireUDateBox.Location = new System.Drawing.Point(13, 52);
            this.sapphireUDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.sapphireUDateBox.Name = "sapphireUDateBox";
            this.sapphireUDateBox.Size = new System.Drawing.Size(100, 20);
            this.sapphireUDateBox.TabIndex = 34;
            // 
            // SapphireReportLabel
            // 
            this.SapphireReportLabel.AutoSize = true;
            this.SapphireReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.SapphireReportLabel.Location = new System.Drawing.Point(14, 11);
            this.SapphireReportLabel.Name = "SapphireReportLabel";
            this.SapphireReportLabel.Size = new System.Drawing.Size(99, 13);
            this.SapphireReportLabel.TabIndex = 6;
            this.SapphireReportLabel.Text = "Sapphire Report";
            // 
            // SapphireReportLinkBox
            // 
            this.SapphireReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.SapphireReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.SapphireReportLinkBox.Location = new System.Drawing.Point(14, 28);
            this.SapphireReportLinkBox.Name = "SapphireReportLinkBox";
            this.SapphireReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.SapphireReportLinkBox.TabIndex = 8;
            this.SapphireReportLinkBox.Text = "Sapphire Link";
            // 
            // SapphireReportCheckBox
            // 
            this.SapphireReportCheckBox.AutoSize = true;
            this.SapphireReportCheckBox.Location = new System.Drawing.Point(99, 11);
            this.SapphireReportCheckBox.Name = "SapphireReportCheckBox";
            this.SapphireReportCheckBox.Size = new System.Drawing.Size(15, 14);
            this.SapphireReportCheckBox.TabIndex = 7;
            this.SapphireReportCheckBox.UseVisualStyleBackColor = true;
            // 
            // panel5
            // 
            this.panel5.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(241)))), ((int)(((byte)(196)))), ((int)(((byte)(15)))));
            this.panel5.Controls.Add(this.etdReportUDateBox);
            this.panel5.Controls.Add(this.ETDReportLabel);
            this.panel5.Controls.Add(this.ETDReportLinkBox);
            this.panel5.Controls.Add(this.ETDReportCheckBox);
            this.panel5.Location = new System.Drawing.Point(144, 138);
            this.panel5.Name = "panel5";
            this.panel5.Size = new System.Drawing.Size(124, 87);
            this.panel5.TabIndex = 11;
            // 
            // etdReportUDateBox
            // 
            this.etdReportUDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.etdReportUDateBox.Location = new System.Drawing.Point(14, 52);
            this.etdReportUDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.etdReportUDateBox.Name = "etdReportUDateBox";
            this.etdReportUDateBox.Size = new System.Drawing.Size(100, 20);
            this.etdReportUDateBox.TabIndex = 25;
            // 
            // ETDReportLabel
            // 
            this.ETDReportLabel.AutoSize = true;
            this.ETDReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ETDReportLabel.Location = new System.Drawing.Point(14, 11);
            this.ETDReportLabel.Name = "ETDReportLabel";
            this.ETDReportLabel.Size = new System.Drawing.Size(74, 13);
            this.ETDReportLabel.TabIndex = 6;
            this.ETDReportLabel.Text = "ETD Report";
            // 
            // ETDReportLinkBox
            // 
            this.ETDReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ETDReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.ETDReportLinkBox.Location = new System.Drawing.Point(14, 28);
            this.ETDReportLinkBox.Name = "ETDReportLinkBox";
            this.ETDReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.ETDReportLinkBox.TabIndex = 8;
            this.ETDReportLinkBox.Text = "ETD Report Link";
            // 
            // ETDReportCheckBox
            // 
            this.ETDReportCheckBox.AutoSize = true;
            this.ETDReportCheckBox.Location = new System.Drawing.Point(99, 11);
            this.ETDReportCheckBox.Name = "ETDReportCheckBox";
            this.ETDReportCheckBox.Size = new System.Drawing.Size(15, 14);
            this.ETDReportCheckBox.TabIndex = 7;
            this.ETDReportCheckBox.UseVisualStyleBackColor = true;
            // 
            // panel4
            // 
            this.panel4.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(89)))), ((int)(((byte)(182)))));
            this.panel4.Controls.Add(this.shrinkageReportUDateBox);
            this.panel4.Controls.Add(this.ShrinkageReportLabel);
            this.panel4.Controls.Add(this.shrinkageReportLinkBox);
            this.panel4.Controls.Add(this.shrinkageReportCheckBox);
            this.panel4.Location = new System.Drawing.Point(14, 417);
            this.panel4.Name = "panel4";
            this.panel4.Size = new System.Drawing.Size(124, 87);
            this.panel4.TabIndex = 11;
            // 
            // shrinkageReportUDateBox
            // 
            this.shrinkageReportUDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.shrinkageReportUDateBox.Location = new System.Drawing.Point(14, 52);
            this.shrinkageReportUDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.shrinkageReportUDateBox.Name = "shrinkageReportUDateBox";
            this.shrinkageReportUDateBox.Size = new System.Drawing.Size(100, 20);
            this.shrinkageReportUDateBox.TabIndex = 23;
            // 
            // ShrinkageReportLabel
            // 
            this.ShrinkageReportLabel.AutoSize = true;
            this.ShrinkageReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ShrinkageReportLabel.Location = new System.Drawing.Point(14, 11);
            this.ShrinkageReportLabel.Name = "ShrinkageReportLabel";
            this.ShrinkageReportLabel.Size = new System.Drawing.Size(64, 13);
            this.ShrinkageReportLabel.TabIndex = 6;
            this.ShrinkageReportLabel.Text = "Shrinkage";
            // 
            // shrinkageReportLinkBox
            // 
            this.shrinkageReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.shrinkageReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.shrinkageReportLinkBox.Location = new System.Drawing.Point(14, 28);
            this.shrinkageReportLinkBox.Name = "shrinkageReportLinkBox";
            this.shrinkageReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.shrinkageReportLinkBox.TabIndex = 8;
            this.shrinkageReportLinkBox.Text = "Shrinkage Link";
            // 
            // shrinkageReportCheckBox
            // 
            this.shrinkageReportCheckBox.AutoSize = true;
            this.shrinkageReportCheckBox.Location = new System.Drawing.Point(99, 11);
            this.shrinkageReportCheckBox.Name = "shrinkageReportCheckBox";
            this.shrinkageReportCheckBox.Size = new System.Drawing.Size(15, 14);
            this.shrinkageReportCheckBox.TabIndex = 7;
            this.shrinkageReportCheckBox.UseVisualStyleBackColor = true;
            // 
            // panel3
            // 
            this.panel3.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(52)))), ((int)(((byte)(152)))), ((int)(((byte)(219)))));
            this.panel3.Controls.Add(this.dsrReportUDateBox);
            this.panel3.Controls.Add(this.DSRReportLabel);
            this.panel3.Controls.Add(this.DSRReportLinkBox);
            this.panel3.Controls.Add(this.DSRReportCheckBox);
            this.panel3.Location = new System.Drawing.Point(14, 324);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(124, 87);
            this.panel3.TabIndex = 10;
            // 
            // dsrReportUDateBox
            // 
            this.dsrReportUDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.dsrReportUDateBox.Location = new System.Drawing.Point(14, 52);
            this.dsrReportUDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.dsrReportUDateBox.Name = "dsrReportUDateBox";
            this.dsrReportUDateBox.Size = new System.Drawing.Size(100, 20);
            this.dsrReportUDateBox.TabIndex = 22;
            // 
            // DSRReportLabel
            // 
            this.DSRReportLabel.AutoSize = true;
            this.DSRReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.DSRReportLabel.Location = new System.Drawing.Point(14, 11);
            this.DSRReportLabel.Name = "DSRReportLabel";
            this.DSRReportLabel.Size = new System.Drawing.Size(75, 13);
            this.DSRReportLabel.TabIndex = 6;
            this.DSRReportLabel.Text = "DSR Report";
            // 
            // DSRReportLinkBox
            // 
            this.DSRReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.DSRReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.DSRReportLinkBox.Location = new System.Drawing.Point(14, 28);
            this.DSRReportLinkBox.Name = "DSRReportLinkBox";
            this.DSRReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.DSRReportLinkBox.TabIndex = 8;
            this.DSRReportLinkBox.Text = "DSR Report Link";
            // 
            // DSRReportCheckBox
            // 
            this.DSRReportCheckBox.AutoSize = true;
            this.DSRReportCheckBox.Location = new System.Drawing.Point(99, 11);
            this.DSRReportCheckBox.Name = "DSRReportCheckBox";
            this.DSRReportCheckBox.Size = new System.Drawing.Size(15, 14);
            this.DSRReportCheckBox.TabIndex = 7;
            this.DSRReportCheckBox.UseVisualStyleBackColor = true;
            // 
            // panel2
            // 
            this.panel2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(46)))), ((int)(((byte)(204)))), ((int)(((byte)(113)))));
            this.panel2.Controls.Add(this.eehReportUDateBox);
            this.panel2.Controls.Add(this.EHHReportLabel);
            this.panel2.Controls.Add(this.ehhReportLinkBox);
            this.panel2.Controls.Add(this.ehhReportCheckBox);
            this.panel2.Location = new System.Drawing.Point(14, 231);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(124, 87);
            this.panel2.TabIndex = 5;
            // 
            // eehReportUDateBox
            // 
            this.eehReportUDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.eehReportUDateBox.Location = new System.Drawing.Point(14, 52);
            this.eehReportUDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.eehReportUDateBox.Name = "eehReportUDateBox";
            this.eehReportUDateBox.Size = new System.Drawing.Size(100, 20);
            this.eehReportUDateBox.TabIndex = 21;
            // 
            // EHHReportLabel
            // 
            this.EHHReportLabel.AutoSize = true;
            this.EHHReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.EHHReportLabel.Location = new System.Drawing.Point(14, 11);
            this.EHHReportLabel.Name = "EHHReportLabel";
            this.EHHReportLabel.Size = new System.Drawing.Size(75, 13);
            this.EHHReportLabel.TabIndex = 6;
            this.EHHReportLabel.Text = "EHH Report";
            // 
            // ehhReportLinkBox
            // 
            this.ehhReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ehhReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.ehhReportLinkBox.Location = new System.Drawing.Point(14, 28);
            this.ehhReportLinkBox.Name = "ehhReportLinkBox";
            this.ehhReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.ehhReportLinkBox.TabIndex = 8;
            this.ehhReportLinkBox.Text = "EHH Report Link";
            // 
            // ehhReportCheckBox
            // 
            this.ehhReportCheckBox.AutoSize = true;
            this.ehhReportCheckBox.Location = new System.Drawing.Point(99, 11);
            this.ehhReportCheckBox.Name = "ehhReportCheckBox";
            this.ehhReportCheckBox.Size = new System.Drawing.Size(15, 14);
            this.ehhReportCheckBox.TabIndex = 7;
            this.ehhReportCheckBox.UseVisualStyleBackColor = true;
            // 
            // auxReportLinkBox
            // 
            this.auxReportLinkBox.Font = new System.Drawing.Font("Segoe UI", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.auxReportLinkBox.ForeColor = System.Drawing.SystemColors.GrayText;
            this.auxReportLinkBox.Location = new System.Drawing.Point(28, 167);
            this.auxReportLinkBox.Name = "auxReportLinkBox";
            this.auxReportLinkBox.Size = new System.Drawing.Size(100, 18);
            this.auxReportLinkBox.TabIndex = 2;
            this.auxReportLinkBox.Text = "AUX Report Link";
            // 
            // auxReportCheckbox
            // 
            this.auxReportCheckbox.AutoSize = true;
            this.auxReportCheckbox.Location = new System.Drawing.Point(113, 150);
            this.auxReportCheckbox.Name = "auxReportCheckbox";
            this.auxReportCheckbox.Size = new System.Drawing.Size(15, 14);
            this.auxReportCheckbox.TabIndex = 1;
            this.auxReportCheckbox.UseVisualStyleBackColor = true;
            // 
            // auxReportLabel
            // 
            this.auxReportLabel.AutoSize = true;
            this.auxReportLabel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(26)))), ((int)(((byte)(188)))), ((int)(((byte)(156)))));
            this.auxReportLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.auxReportLabel.Location = new System.Drawing.Point(28, 150);
            this.auxReportLabel.Name = "auxReportLabel";
            this.auxReportLabel.Size = new System.Drawing.Size(70, 13);
            this.auxReportLabel.TabIndex = 0;
            this.auxReportLabel.Text = "AUXReport";
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(26)))), ((int)(((byte)(188)))), ((int)(((byte)(156)))));
            this.panel1.Controls.Add(this.auxReportUDateBox);
            this.panel1.Location = new System.Drawing.Point(14, 138);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(124, 87);
            this.panel1.TabIndex = 4;
            // 
            // auxReportUDateBox
            // 
            this.auxReportUDateBox.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.auxReportUDateBox.Location = new System.Drawing.Point(14, 59);
            this.auxReportUDateBox.MinDate = new System.DateTime(2018, 1, 1, 0, 0, 0, 0);
            this.auxReportUDateBox.Name = "auxReportUDateBox";
            this.auxReportUDateBox.Size = new System.Drawing.Size(100, 20);
            this.auxReportUDateBox.TabIndex = 20;
            // 
            // openFileDialog2
            // 
            this.openFileDialog2.DefaultExt = "xlsx";
            this.openFileDialog2.FileName = "openFileDialog1";
            this.openFileDialog2.InitialDirectory = "C:\\";
            this.openFileDialog2.Title = "Select Excel File";
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabPage5);
            this.tabControl1.Controls.Add(this.tabPage6);
            this.tabControl1.Controls.Add(this.tabPage7);
            this.tabControl1.Controls.Add(this.tabPage8);
            this.tabControl1.Location = new System.Drawing.Point(450, 27);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(655, 633);
            this.tabControl1.TabIndex = 59;
            // 
            // tabPage5
            // 
            this.tabPage5.Controls.Add(this.webBrowser1);
            this.tabPage5.Location = new System.Drawing.Point(4, 22);
            this.tabPage5.Name = "tabPage5";
            this.tabPage5.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage5.Size = new System.Drawing.Size(647, 607);
            this.tabPage5.TabIndex = 0;
            this.tabPage5.Text = "SP Documents";
            this.tabPage5.UseVisualStyleBackColor = true;
            // 
            // webBrowser1
            // 
            this.webBrowser1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.webBrowser1.Location = new System.Drawing.Point(3, 3);
            this.webBrowser1.MinimumSize = new System.Drawing.Size(20, 20);
            this.webBrowser1.Name = "webBrowser1";
            this.webBrowser1.Size = new System.Drawing.Size(641, 601);
            this.webBrowser1.TabIndex = 0;
            this.webBrowser1.Url = new System.Uri("https://sharepoint.charter.com/ops/El_Paso_CSI/Shared%20Documents/Forms/AllItems." +
        "aspx", System.UriKind.Absolute);
            // 
            // tabPage6
            // 
            this.tabPage6.Controls.Add(this.webBrowser2);
            this.tabPage6.Location = new System.Drawing.Point(4, 22);
            this.tabPage6.Name = "tabPage6";
            this.tabPage6.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage6.Size = new System.Drawing.Size(647, 607);
            this.tabPage6.TabIndex = 1;
            this.tabPage6.Text = "AAT View";
            this.tabPage6.UseVisualStyleBackColor = true;
            // 
            // webBrowser2
            // 
            this.webBrowser2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.webBrowser2.Location = new System.Drawing.Point(3, 3);
            this.webBrowser2.MinimumSize = new System.Drawing.Size(20, 20);
            this.webBrowser2.Name = "webBrowser2";
            this.webBrowser2.Size = new System.Drawing.Size(641, 601);
            this.webBrowser2.TabIndex = 0;
            this.webBrowser2.Url = new System.Uri("https://sharepoint.charter.com/ops/AAT/VIDTXElPaso/SiteAssets/HTML/AgentsStatus.h" +
        "tml", System.UriKind.Absolute);
            // 
            // tabPage7
            // 
            this.tabPage7.Controls.Add(this.webBrowser3);
            this.tabPage7.Location = new System.Drawing.Point(4, 22);
            this.tabPage7.Name = "tabPage7";
            this.tabPage7.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage7.Size = new System.Drawing.Size(647, 607);
            this.tabPage7.TabIndex = 2;
            this.tabPage7.Text = "CorPortal";
            this.tabPage7.UseVisualStyleBackColor = true;
            // 
            // webBrowser3
            // 
            this.webBrowser3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.webBrowser3.Location = new System.Drawing.Point(3, 3);
            this.webBrowser3.MinimumSize = new System.Drawing.Size(20, 20);
            this.webBrowser3.Name = "webBrowser3";
            this.webBrowser3.Size = new System.Drawing.Size(641, 601);
            this.webBrowser3.TabIndex = 0;
            this.webBrowser3.Url = new System.Uri("https://corportal.corp.chartercom.com/main/default.aspx", System.UriKind.Absolute);
            // 
            // tabPage8
            // 
            this.tabPage8.Controls.Add(this.webBrowser4);
            this.tabPage8.Location = new System.Drawing.Point(4, 22);
            this.tabPage8.Name = "tabPage8";
            this.tabPage8.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage8.Size = new System.Drawing.Size(647, 607);
            this.tabPage8.TabIndex = 3;
            this.tabPage8.Text = "MicroStrategy";
            this.tabPage8.UseVisualStyleBackColor = true;
            // 
            // webBrowser4
            // 
            this.webBrowser4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.webBrowser4.Location = new System.Drawing.Point(3, 3);
            this.webBrowser4.MinimumSize = new System.Drawing.Size(20, 20);
            this.webBrowser4.Name = "webBrowser4";
            this.webBrowser4.Size = new System.Drawing.Size(641, 601);
            this.webBrowser4.TabIndex = 0;
            this.webBrowser4.Url = new System.Uri("https://bi.corp.chartercom.com/MicroStrategy/", System.UriKind.Absolute);
            // 
            // workOrderDetailsToolStripMenuItem
            // 
            this.workOrderDetailsToolStripMenuItem.Name = "workOrderDetailsToolStripMenuItem";
            this.workOrderDetailsToolStripMenuItem.Size = new System.Drawing.Size(180, 22);
            this.workOrderDetailsToolStripMenuItem.Text = "WorkOrderDetails";
            this.workOrderDetailsToolStripMenuItem.Click += new System.EventHandler(this.WorkOrderDetailsToolStripMenuItem_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1117, 672);
            this.Controls.Add(this.tabControl1);
            this.Controls.Add(this.uploadControls);
            this.Controls.Add(this.menuStrip1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "Form1";
            this.Text = "SQL File Tool";
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.uploadControls.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox3)).EndInit();
            this.tabPage2.ResumeLayout(false);
            this.tabPage2.PerformLayout();
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.tabPage3.ResumeLayout(false);
            this.tabPage3.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox4)).EndInit();
            this.tabPage4.ResumeLayout(false);
            this.tabPage4.PerformLayout();
            this.panel17.ResumeLayout(false);
            this.panel17.PerformLayout();
            this.panel16.ResumeLayout(false);
            this.panel16.PerformLayout();
            this.panel15.ResumeLayout(false);
            this.panel15.PerformLayout();
            this.panel14.ResumeLayout(false);
            this.panel14.PerformLayout();
            this.panel13.ResumeLayout(false);
            this.panel13.PerformLayout();
            this.panel12.ResumeLayout(false);
            this.panel12.PerformLayout();
            this.panel11.ResumeLayout(false);
            this.panel11.PerformLayout();
            this.panel10.ResumeLayout(false);
            this.panel10.PerformLayout();
            this.panel9.ResumeLayout(false);
            this.panel9.PerformLayout();
            this.panel8.ResumeLayout(false);
            this.panel8.PerformLayout();
            this.panel7.ResumeLayout(false);
            this.panel7.PerformLayout();
            this.panel6.ResumeLayout(false);
            this.panel6.PerformLayout();
            this.panel5.ResumeLayout(false);
            this.panel5.PerformLayout();
            this.panel4.ResumeLayout(false);
            this.panel4.PerformLayout();
            this.panel3.ResumeLayout(false);
            this.panel3.PerformLayout();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.panel1.ResumeLayout(false);
            this.tabControl1.ResumeLayout(false);
            this.tabPage5.ResumeLayout(false);
            this.tabPage6.ResumeLayout(false);
            this.tabPage7.ResumeLayout(false);
            this.tabPage8.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.TextBox sqlPasswordBox;
        public string SqlPasswordBox { get { return sqlPasswordBox.Text.ToString(); } set { sqlPasswordBox.Text = value; } }
        private System.Windows.Forms.TextBox sqlServerAddressBox;
        public string SqlServerAddressBox { get { return sqlServerAddressBox.Text.ToString(); } set { sqlServerAddressBox.Text = value; } }
        private System.Windows.Forms.TextBox sqlDatabaseBox;
        public string SqlDatabaseBox { get { return sqlDatabaseBox.Text.ToString(); } set { sqlDatabaseBox.Text = value; } }
        private System.Windows.Forms.Button sqlTestConn;
        private System.Windows.Forms.Label SqlServerAddressLabel;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox xlFilePathBox;
        private System.Windows.Forms.TextBox xlDateColBox;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.Button selectFileButton;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.PictureBox pictureBox1;
        public System.Windows.Forms.TextBox sqlUsernameBox;
        public string SqlUsernameBox { get { return sqlUsernameBox.Text.ToString(); } set { sqlUsernameBox.Text = value; } }
        private System.Windows.Forms.PictureBox pictureBox2;
        private System.Windows.Forms.Button uploadFileButton;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem fileToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem exitToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem aboutToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem aboutToolStripMenuItem1;
        private System.Windows.Forms.TextBox sqlTableNameBox;
        private System.Windows.Forms.Label sqlTableNameLabel;
        private System.Windows.Forms.PictureBox pictureBox3;
        private System.Windows.Forms.Button selectFolderButton;
        private System.Windows.Forms.CheckBox AATData;
        private System.Windows.Forms.CheckBox AgentSchedules;
        private System.Windows.Forms.CheckBox AUXBIData;
        private System.Windows.Forms.CheckBox AvayaSegments;
        private System.Windows.Forms.CheckBox AvayaSuperstates;
        private System.Windows.Forms.CheckBox BIMetricData;
        private System.Windows.Forms.CheckBox BQOEData;
        private System.Windows.Forms.CheckBox CorPortalCoaching;
        private System.Windows.Forms.CheckBox CurrentRoster;
        private System.Windows.Forms.CheckBox EHH;
        private System.Windows.Forms.CheckBox HistoricalRoster;
        private System.Windows.Forms.CheckBox ManagerRoster;
        private System.Windows.Forms.CheckBox Roster;
        private System.Windows.Forms.CheckBox SuperstateMapping;
        private System.Windows.Forms.CheckBox SupervisorRoster;
        private System.Windows.Forms.CheckBox TransferLocations;
        private System.Windows.Forms.TextBox folderPath;
        private System.Windows.Forms.Button uploadMulti;
        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog1;
        private System.Windows.Forms.TabControl uploadControls;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.TabPage tabPage2;
        private System.Windows.Forms.Label LastUpdated;
        private System.Windows.Forms.Label sqlTable;
        private System.Windows.Forms.Label TransferLocationsUpdate;
        private System.Windows.Forms.Label SupervisorRosterUpdate;
        private System.Windows.Forms.Label SuperstateMappingUpdate;
        private System.Windows.Forms.Label RosterUpdate;
        private System.Windows.Forms.Label ManagerRosterUpdate;
        private System.Windows.Forms.Label EHHUpdate;
        private System.Windows.Forms.Label CurrentRosterUpdate;
        private System.Windows.Forms.Label CorPortalCoachingUpdate;
        private System.Windows.Forms.Label BQOEDataUpdate;
        private System.Windows.Forms.Label BIMetricDataUpdate;
        private System.Windows.Forms.Label AvayaSuperstatesUpdate;
        private System.Windows.Forms.Label AvayaSegmentsUpdate;
        private System.Windows.Forms.Label AUXBIDataUpdate;
        private System.Windows.Forms.Label AgentSchedulesUpdate;
        private System.Windows.Forms.Label AATDataUpdate;
        private System.Windows.Forms.Label updatedThrough;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.Button checkDatesButton;
        private System.Windows.Forms.Label AATUpdateTDate;
        private System.Windows.Forms.Label AUXBIDataUpdateTDate;
        private System.Windows.Forms.Label AvayaSegmentsUpdatedTDate;
        private System.Windows.Forms.Label AvayaSuperstatesUpdatedTDate;
        private System.Windows.Forms.Label BIMetricDataUpdatedTDate;
        private System.Windows.Forms.Label BQOEDataUpdatedTDate;
        private System.Windows.Forms.Label CorPortalCoachingUpdatedTDate;
        private System.Windows.Forms.Label CurrentRosterUpdatedTDate;
        private System.Windows.Forms.Label EHHUpdatedTDate;
        private System.Windows.Forms.Label ManagerRosterUpdatedTDate;
        private System.Windows.Forms.Label RosterUpdatedTDate;
        private System.Windows.Forms.Label SuperstateMappingUpdatedTDate;
        private System.Windows.Forms.Label SupervisorRosterUpdatedTDate;
        private System.Windows.Forms.Label TransferLocationsUpdatedTDate;
        private System.Windows.Forms.Label AgentSchedulesUpdateTDate;
        private System.Windows.Forms.TabPage tabPage3;
        private System.Windows.Forms.LinkLabel AgentDailyIrisUsage;
        private System.Windows.Forms.TextBox SSRSServerBox;
        private System.Windows.Forms.Label SSRSServerLabel;
        private System.Windows.Forms.LinkLabel AgentDailyIriswoHeaders;
        private System.Windows.Forms.LinkLabel AgentDSR;
        private System.Windows.Forms.LinkLabel AgentDSRwoHeaders;
        private System.Windows.Forms.LinkLabel AUXSupervisors;
        private System.Windows.Forms.LinkLabel SupervisorDSRwoHeaders;
        private System.Windows.Forms.LinkLabel SupervisorDSR;
        private System.Windows.Forms.LinkLabel SupervisorDailyIRISwoHeaders;
        private System.Windows.Forms.LinkLabel SupervisorDailyIris;
        private System.Windows.Forms.LinkLabel Shrinkage;
        private System.Windows.Forms.LinkLabel RubyMeter;
        private System.Windows.Forms.LinkLabel ManagerDSRwoHeaders;
        private System.Windows.Forms.LinkLabel ManagerDSR;
        private System.Windows.Forms.LinkLabel LeadDSR;
        private System.Windows.Forms.LinkLabel EHHLinkLabel;
        private System.Windows.Forms.LinkLabel TransferLocationsLink;
        private System.Windows.Forms.PictureBox pictureBox4;
        private System.Windows.Forms.TabPage tabPage4;
        private System.Windows.Forms.Label AATDataUDate;
        private System.Windows.Forms.Label AUXBIDataUDate;
        private System.Windows.Forms.Label AvayaSegmentsUDate;
        private System.Windows.Forms.Label AvayaSuperstatesUDate;
        private System.Windows.Forms.Label BIMetricDataUDate;
        private System.Windows.Forms.Label BQOEDataUDate;
        private System.Windows.Forms.Label CorPortalCoachingUDate;
        private System.Windows.Forms.Label EHHUDate;
        private System.Windows.Forms.Label TransferLocationsUDate;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Label EHHReportLabel;
        private System.Windows.Forms.TextBox ehhReportLinkBox;
        private System.Windows.Forms.CheckBox ehhReportCheckBox;
        private System.Windows.Forms.TextBox auxReportLinkBox;
        private System.Windows.Forms.CheckBox auxReportCheckbox;
        private System.Windows.Forms.Label auxReportLabel;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel panel17;
        private System.Windows.Forms.Label WOReportLabel;
        private System.Windows.Forms.TextBox woReportLinkBox;
        private System.Windows.Forms.CheckBox woReportCheckBox;
        private System.Windows.Forms.Panel panel16;
        private System.Windows.Forms.Label vocReportLabel;
        private System.Windows.Forms.TextBox vocReportLinkBox;
        private System.Windows.Forms.CheckBox vocReportCheckBox;
        private System.Windows.Forms.Panel panel15;
        private System.Windows.Forms.Label CorPortalCoachingReportLabel;
        private System.Windows.Forms.TextBox CorPortalCoachingReportLinkBox;
        private System.Windows.Forms.CheckBox CorPortalCoachingReportCheckBox;
        private System.Windows.Forms.Panel panel14;
        private System.Windows.Forms.Label LeadStackReportLabel;
        private System.Windows.Forms.TextBox LeadStackReportLinkBox;
        private System.Windows.Forms.CheckBox LeadStackReportCheckBox;
        private System.Windows.Forms.Panel panel13;
        private System.Windows.Forms.Label APTReportLabel;
        private System.Windows.Forms.TextBox APTReportLinkBox;
        private System.Windows.Forms.CheckBox APTReportCheckBox;
        private System.Windows.Forms.Panel panel12;
        private System.Windows.Forms.Label MOMReportLabel;
        private System.Windows.Forms.TextBox MOMReportLinkBox;
        private System.Windows.Forms.CheckBox MOMReportCheckBox;
        private System.Windows.Forms.Panel panel11;
        private System.Windows.Forms.Label IRISReportLabel;
        private System.Windows.Forms.TextBox IRISReportLinkBox;
        private System.Windows.Forms.CheckBox IRISReportCheckBox;
        private System.Windows.Forms.Panel panel10;
        private System.Windows.Forms.Label AlignmentReportLabel;
        private System.Windows.Forms.TextBox AlignmentReportLinkBox;
        private System.Windows.Forms.CheckBox AlignmentReportCheckBox;
        private System.Windows.Forms.Panel panel9;
        private System.Windows.Forms.Label transferReportLabel;
        private System.Windows.Forms.TextBox transferReportLinkBox;
        private System.Windows.Forms.CheckBox transferReportCheckBox;
        private System.Windows.Forms.Panel panel8;
        private System.Windows.Forms.Label EmeraldReportLabel;
        private System.Windows.Forms.TextBox EmeraldReportLinkBox;
        private System.Windows.Forms.CheckBox EmeraldReportCheckBox;
        private System.Windows.Forms.Panel panel7;
        private System.Windows.Forms.Label rubyReportLabel;
        private System.Windows.Forms.TextBox rubyReportLinkBox;
        private System.Windows.Forms.CheckBox rubyReportCheckBox;
        private System.Windows.Forms.Panel panel6;
        private System.Windows.Forms.Label SapphireReportLabel;
        private System.Windows.Forms.TextBox SapphireReportLinkBox;
        private System.Windows.Forms.CheckBox SapphireReportCheckBox;
        private System.Windows.Forms.Panel panel5;
        private System.Windows.Forms.Label ETDReportLabel;
        private System.Windows.Forms.TextBox ETDReportLinkBox;
        private System.Windows.Forms.CheckBox ETDReportCheckBox;
        private System.Windows.Forms.Panel panel4;
        private System.Windows.Forms.Label ShrinkageReportLabel;
        private System.Windows.Forms.TextBox shrinkageReportLinkBox;
        private System.Windows.Forms.CheckBox shrinkageReportCheckBox;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.Label DSRReportLabel;
        private System.Windows.Forms.TextBox DSRReportLinkBox;
        private System.Windows.Forms.CheckBox DSRReportCheckBox;
        private System.Windows.Forms.Label label21;
        private System.Windows.Forms.Button selectHTMLButton;
        private System.Windows.Forms.Button selectJSButton;
        private System.Windows.Forms.Label UploadControlsInfo;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label7;
        private System.ComponentModel.BackgroundWorker backgroundWorker1;
        private System.Windows.Forms.ProgressBar serverStatusProgressBar;
        private System.Windows.Forms.ProgressBar uploadControlsProgressBar;
        private System.Windows.Forms.OpenFileDialog openFileDialog2;
        private System.Windows.Forms.DateTimePicker woReportDateBox;
        private System.Windows.Forms.DateTimePicker eehReportUDateBox;
        private System.Windows.Forms.DateTimePicker auxReportUDateBox;
        private System.Windows.Forms.DateTimePicker aptUDateBox;
        private System.Windows.Forms.DateTimePicker LDSRUDateBox;
        private System.Windows.Forms.DateTimePicker IRISUDateBox;
        private System.Windows.Forms.DateTimePicker transferReportUDateBox;
        private System.Windows.Forms.DateTimePicker rubyReportUDateBox;
        private System.Windows.Forms.DateTimePicker etdReportUDateBox;
        private System.Windows.Forms.DateTimePicker shrinkageReportUDateBox;
        private System.Windows.Forms.DateTimePicker dsrReportUDateBox;
        private System.Windows.Forms.DateTimePicker vocReportUDateBox;
        private System.Windows.Forms.DateTimePicker corportalUDateBox;
        private System.Windows.Forms.DateTimePicker momReportUDateBox;
        private System.Windows.Forms.DateTimePicker alignmentReportUDateBox;
        private System.Windows.Forms.DateTimePicker emeraldUDateBox;
        private System.Windows.Forms.DateTimePicker sapphireUDateBox;
        private System.Windows.Forms.ToolStripMenuItem automationToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem aUXReportToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem aPTReportToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem dSRReportToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem weekendAutomationToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem allToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem selectedToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem alignmentToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem iRISReportToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem rubyMeterReportToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem aATMgmtToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem exportReportDataToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem trimAATSPListToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem transferLocReportToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem rosterDownloadToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem corPortalCoachingsToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem setDefaultFoldersToolStripMenuItem;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabPage5;
        private System.Windows.Forms.WebBrowser webBrowser1;
        private System.Windows.Forms.TabPage tabPage6;
        private System.Windows.Forms.WebBrowser webBrowser2;
        private System.Windows.Forms.TabPage tabPage7;
        private System.Windows.Forms.WebBrowser webBrowser3;
        private System.Windows.Forms.TabPage tabPage8;
        private System.Windows.Forms.WebBrowser webBrowser4;
        private System.Windows.Forms.ToolStripMenuItem vOCReportToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem eTDReportToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem workOrderDetailsToolStripMenuItem;
    }
}

