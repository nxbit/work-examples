using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using AATAutomations;

namespace WorkAutomation
{
    
    public partial class AATTrim : Form
    {
        public string selectedDate { get; set; }
        public string selectedDate2 { get; set; }
        public string filepath { get; set; }
        public AATTrim()
        {
            InitializeComponent();
        }

        private void AATTrimButton_Click(object sender, EventArgs e)
        {
            selectedDate = AATTrimDateSelection.SelectionRange.Start.ToString("MM/dd/yyyy");
            selectedDate2 = AATTrimDateSelection.SelectionRange.End.ToString("MM/dd/yyyy");
            try { AATAutoFunctions.TrimData(filepath+ "\\AATAccess.mdb", selectedDate, selectedDate2); }
            catch { MessageBox.Show("AAT Trim Failed. Try Again"); }
            
        }

        private void AATTrimDateSelection_DateChanged(object sender, DateRangeEventArgs e)
        {

            selectedDate = AATTrimDateSelection.SelectionRange.Start.ToString("MM/dd/yyyy");
            selectedDate2 = AATTrimDateSelection.SelectionRange.End.ToString("MM/dd/yyyy");
        }
    }
}
