using System;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;
using Excel = Microsoft.Office.Interop.Excel;
using System.Reflection;
using System.Linq;

namespace Alignment
{
   public static class Full
    {
        public static bool fullsearch;
        public static int mystart;
        public static int myend;

    }


    public class Rock1 : Form
    {



        public Rock1()
        {

            this.Size = new Size(400, 500);

            Icon = Icon.ExtractAssociatedIcon(System.Reflection.Assembly.GetExecutingAssembly().Location);

            // Create and configure the PictureBox

            PictureBox pb1 = new PictureBox
            {
                ImageLocation = ("res/myicon.png"),
                SizeMode = PictureBoxSizeMode.AutoSize,
                Location = new Point(100, 200)
            };
            // Add our new controls to the Form
            this.Controls.Add(pb1);

            //create labels
            Label mylab = new Label
            {
                Text = "Alignment Tool",
                Location = new Point(100, 1),
                AutoSize = true,
                Font = new Font("Calibri", 19),
                ForeColor = Color.Blue,
                Padding = new Padding(6)
            };
            // Adding this control to the form 
            this.Controls.Add(mylab);
            // Creating and setting the properties of Button
            Button Mybutton = new Button
            {
                Location = new Point(20, 100),
                Text = "Open  file",
                AutoSize = true,
                BackColor = Color.LightBlue,
                Padding = new Padding(6)
            };
            Mybutton.Click += new EventHandler(Button1_Click);
            // Adding this button to form


            this.Controls.Add(Mybutton);
            TextBox Mytextbox = new TextBox
            {
                Location = new Point(100, 150),
                BackColor = Color.LightGray,
                ForeColor = Color.DarkOliveGreen,
                AutoSize = true,
                Name = "text_box1"
            };
            TextBox Mytextbox1 = new TextBox
            {
                Location = new Point(240, 150),
                BackColor = Color.LightGray,
                ForeColor = Color.DarkOliveGreen,
                AutoSize = true,
                Name = "text_box2"
            };

            // Add this textbox to form 
            this.Controls.Add(Mytextbox);
            this.Controls.Add(Mytextbox1);
            // Creating radio button
            RadioButton radioButton1 = new RadioButton
            {
                // Set the AutoSize property 
                AutoSize = true,

                // Add text in RadioButton
                Text = "full check",

                // Set the location of the RadioButton
                Location = new Point(100, 100),

                // Set Font property 
                Font = new Font("Berlin Sans FB", 12)
            };
            // Add this radio button to the form
            this.Controls.Add(radioButton1);
            radioButton1.Click += new EventHandler(button_Click);

            RadioButton r2 = new RadioButton
            {
                // Set the AutoSize property 
                AutoSize = true,

                // Add text in RadioButton
                Text = "row scan",

                // Set the location of the RadioButton
                Location = new Point(200, 100),

                // Set Font property 
                Font = new Font("Berlin Sans FB", 12)
            };
            // Add this radio button to the form
            this.Controls.Add(r2);
            //  radio button clicked on
            r2.Click += new EventHandler(button3_Click);
            Mytextbox.Click += new EventHandler(button5_Click);
            Mytextbox1.Click += new EventHandler(button5_Click);
            // Creating and setting the properties of Button
            Button Mybutton1 = new Button
            {
                Location = new Point(20, 150),
                Text = "update",
                AutoSize = true,
                BackColor = Color.LightBlue,
                Padding = new Padding(6)
            };
            Mybutton1.Click += new EventHandler(button5_Click);
            // Adding this button to form
            this.Controls.Add(Mybutton1);
            void button5_Click(object sender, EventArgs e)
            {



                try
                {

                    Full.mystart = int.Parse(Mytextbox.Text);
                    Full.myend = int.Parse(Mytextbox1.Text);
                    Console.WriteLine(Full.mystart);
                    Console.WriteLine(Full.myend);

                }


                catch
                {

                }


            }
            void button_Click(object sender, EventArgs e)
            {
                if (radioButton1.Checked == true)
                {
                    Full.fullsearch = true;

                    return;
                }

            }
            void button3_Click(object sender, EventArgs e)
            {
                if (r2.Checked == true)
                {
                    Full.fullsearch = false;

                    return;
                }

            }

            if (r2.Checked is true)
            {
                Full.fullsearch = false;

            }

            return;
        }

        private void Button1_Click(object sender, EventArgs e)
        {
            //Grab FilePath of Alignment File
            string filepath = null;
            OpenFileDialog openFileDialog = new OpenFileDialog();
            if (openFileDialog.ShowDialog() == DialogResult.OK)
            {filepath = openFileDialog.FileName.ToString();}
            openFileDialog.Dispose();


            // Initilize Excel Objects
            Excel.Application xlApp;
            Excel.Workbook xlWorkbook;
            Excel._Worksheet xlSheet;
            Excel._Workbook oWB;
            Excel._Worksheet oSheet;
            xlApp = new Excel.Application
            {
                DisplayAlerts = false,
                Visible = true
            };
            xlWorkbook = xlApp.Workbooks.Open(filepath);
            xlSheet = xlWorkbook.Sheets[2];
            oWB = xlApp.Workbooks.Add(Missing.Value);
            oSheet = (Excel._Worksheet)oWB.ActiveSheet;
            xlSheet.Activate();

            // Gather Last Row Used in Sheet
            int lastUsedRow = xlSheet.UsedRange.Rows.Count;

            //Grab lenght of Superivsor Column
            Excel.Range supColRange = xlSheet.Range[xlSheet.Cells[1, 4], xlSheet.Cells[lastUsedRow, 4]].EntireColumn;
            

            // length of SupColumn sheet
            int lastUsedSupRow = xlSheet.UsedRange.Columns["D:D", Type.Missing].Rows.Count;
            int numberOfSups  = supColRange.Cells.Find("*", Missing.Value, Missing.Value, Missing.Value, Excel.XlSearchOrder.xlByRows, 
                Excel.XlSearchDirection.xlPrevious, false, Missing.Value, Missing.Value).Row;
            numberOfSups -= 4;


            MessageBox.Show(lastUsedRow.ToString() + " " + numberOfSups.ToString());


            //Arrays to Store Supervisor Names, and Matched Agent to Sup Names
            string[] SUPER = new string[numberOfSups];
            double[,] fred = new double[numberOfSups, lastUsedRow];
            

           
            int mycola = 3;
            int mycol = lastUsedRow;
            Excel.Range range = xlSheet.get_Range("D3", "D" + mycol);




            if (Full.fullsearch == true)
            {
                mycol = lastUsedRow;
            }
            if (Full.fullsearch == false)
            {
                mycola = Full.mystart;
                mycol = Full.myend;

            }
            // lope for superrvisers

            for (int x = 3; x <= 19; x++)
            {
                var cellValue = (string)(xlSheet.Cells[x, 4] as Excel.Range).Value;

                SUPER[x] = cellValue;
                oSheet.Cells[x, 2] = cellValue;
            }
            //lope for employes
            for (int x = mycola; x <= mycol; x++)
            {
                try
                {
                    string value = (xlSheet.Cells[x, 17] as Excel.Range).Value as string;
                    var cellValue = value;
                    oSheet.Cells[2, x] = cellValue;
                }
                catch
                {
                    //Console.WriteLine("Hello World");

                }

            }
            // lope for caculations
            int g, y;

            for (g = mycola; g <= mycol; g++)
            {

                for (y = 3; y <= 19; y++)
                {
                    try
                    {

                        xlSheet.Cells[g, 24] = SUPER[y];

                        var cellValue = (xlSheet.Cells[g, 23] as Excel.Range).Value;




                        oSheet.Cells[y, g] = cellValue;


                        fred[y, g] = (double)cellValue;
                    }
                    catch
                    {
                        //Console.WriteLine("Hello World");
                    }
                }
            }
            //end of lope   
            // loop ranking
            for (g = mycola; g <= mycol; g++)
            {
                double[] mysearch1 = new double[30];
                for (y = 3; y <= 19; y++)
                {
                    mysearch1[y] = fred[y, g];
                }
                double x = mysearch1.Max();
                Console.WriteLine(x);
                for (y = 3; y <= 19; y++)
                {
                    if (mysearch1[y] == x)
                    {
                        xlSheet.Cells[g, 24] = SUPER[y];


                    }
                }
            }

            System.Runtime.InteropServices.Marshal.ReleaseComObject(xlApp);
            System.Runtime.InteropServices.Marshal.ReleaseComObject(xlApp);
            MessageBox.Show("Complete");
        }
        [STAThread]
       public static void runAlignment()
        {

            Form myform = new Rock1();

            myform.ShowDialog();
        }
    }
}
