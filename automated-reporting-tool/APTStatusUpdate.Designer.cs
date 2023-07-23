namespace WorkAutomation
{
    partial class APTUpdateStatus
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
            APTStatusUpdate = new System.Windows.Forms.Label();
            this.button1 = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // APTStatusUpdate
            // 
            APTStatusUpdate.AutoSize = true;
            APTStatusUpdate.Font = new System.Drawing.Font("Segoe UI", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            APTStatusUpdate.Location = new System.Drawing.Point(12, 47);
            APTStatusUpdate.Name = "APTStatusUpdate";
            APTStatusUpdate.Size = new System.Drawing.Size(12, 17);
            APTStatusUpdate.TabIndex = 0;
            APTStatusUpdate.Text = " ";
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(297, 12);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 1;
            this.button1.Text = "Select APT";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.Button1_Click);
            // 
            // APTUpdateStatus
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(384, 80);
            this.Controls.Add(this.button1);
            this.Controls.Add(APTStatusUpdate);
            this.Name = "APTUpdateStatus";
            this.Text = "APT File Update";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        public static System.Windows.Forms.Label APTStatusUpdate;
        private System.Windows.Forms.Button button1;
    }
}