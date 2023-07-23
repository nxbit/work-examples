using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using aptfullauto;

namespace WorkAutomation
{
    public partial class APTUpdateStatus : Form
    {
        public APTUpdateStatus()
        {
            InitializeComponent();
        }

        private void SelectAPT_Click(object sender, EventArgs e)
        {
            APTUpdate APTUpdate = new APTUpdate();
            APTUpdate.RunAuto();
        }
    }
}
