using System;
using System.Windows.Forms;
using aptfullauto;

namespace WorkAutomation
{
    public partial class APTUpdateStatus : Form
    {
        public string sqlUserName = null;
        public string sqlPassword = null;
        public string sqlServer = null;
        public string filepath = null;
        public APTUpdateStatus()
        {
            InitializeComponent();
            

        }

        private void Button1_Click(object sender, EventArgs e)
        {
            APTUpdate APTUpdate = new APTUpdate();
            try { APTUpdate.sqlDatabase = "El_Paso_Video"; APTUpdate.sqlPassword = sqlPassword; APTUpdate.sqlServerAddress = sqlServer; APTUpdate.sqlUserName = sqlUserName; APTUpdate.RunAuto(filepath);} catch { MessageBox.Show("APT file update failed. Retry"); }

        }
    }
}
