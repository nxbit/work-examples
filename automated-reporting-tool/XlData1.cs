using System.Data;
using System.Data.OleDb;

namespace WorkAutomation
{
    /*
     *
     *  xlData class
     *  Containes all the nessary members and methods to prase Excel Documents
     *
     */

    internal class XlData
    {
        private string _xlHDR;
        private string _xlFilePath;
        public string SheetName { get; set; }
        public string XlConnectionString { get; set; }
        public string FolderPath { get; set; }
        public string XlDateColName { get; set; }

        public string XlHDR
        {
            get { return _xlHDR; }
            set
            {
                _xlHDR = value;
                SetxlConnectionString();
            }
        }

        public string XlFilePath
        {
            get { return _xlFilePath; }
            set
            {
                _xlFilePath = value;
                SetxlConnectionString();
            }
        }

        public void SetxlConnectionString()
        {
            XlConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + XlFilePath + "; Extended Properties = \"Excel 12.0 Xml;HDR=YES\";";
        }

        public bool TestxlConnection()
        {
            using (OleDbConnection conn = new OleDbConnection(XlConnectionString))
            {
                try { conn.Open(); return true; } catch { return false; }
            }
        }

        /*
         *  getxlData will pull the data from an excel file and load it into a datatable
         */

        public DataTable GetxlData()
        {
            //Initilize Objects
            OleDbConnection conn = new OleDbConnection(XlConnectionString);
            OleDbCommand oconn = new OleDbCommand("Select * from [" + SheetName + "$]", conn);
            using (OleDbDataAdapter adp = new OleDbDataAdapter(oconn))
            {
                DataTable dt = new DataTable();

                // Fill xlData into datatable and return it
                conn.Open();
                adp.Fill(dt);
                conn.Close();
                return dt;
            }
        }

        /*
         *  getMindDate method will return the minimum date from the datatable
         */

        public string GetMinDate(DataTable dt)
        {
            foreach (DataColumn y in dt.Columns)
            {
                int col = 0;
                if (y.ColumnName.ToString() == XlDateColName)
                {
                    DataRow[] dr = dt.Select("[" + XlDateColName + "] = MIN([" + XlDateColName + "])");
                    return dr[0][dt.Columns.IndexOf(XlDateColName)].ToString();
                };
                col += 1;
            }
            return "error";
        }

        /*
         *  getMaxDate will return the maximum date from the datatable
         */

        public string GetMaxDate(DataTable dt)
        {
            foreach (DataColumn y in dt.Columns)
            {
                int col = 0;
                if (y.ColumnName.ToString() == XlDateColName)
                {
                    DataRow[] dr = dt.Select("[" + XlDateColName + "] = MAX([" + XlDateColName + "])");
                    return dr[0][dt.Columns.IndexOf(XlDateColName)].ToString();
                };
                col += 1;
            }
            return "error";
        }
    }
}