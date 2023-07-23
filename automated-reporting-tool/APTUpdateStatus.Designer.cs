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
            this.SelectAPT = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // APTStatusUpdate
            // 
            APTStatusUpdate.AutoSize = true;
            APTStatusUpdate.Location = new System.Drawing.Point(36, 57);
            APTStatusUpdate.Name = "APTStatusUpdate";
            APTStatusUpdate.Size = new System.Drawing.Size(10, 13);
            APTStatusUpdate.TabIndex = 0;
            APTStatusUpdate.Text = " ";
            // 
            // SelectAPT
            // 
            this.SelectAPT.Location = new System.Drawing.Point(288, 12);
            this.SelectAPT.Name = "SelectAPT";
            this.SelectAPT.Size = new System.Drawing.Size(75, 23);
            this.SelectAPT.TabIndex = 1;
            this.SelectAPT.Text = "Select APT";
            this.SelectAPT.UseVisualStyleBackColor = true;
            this.SelectAPT.Click += new System.EventHandler(this.SelectAPT_Click);
            // 
            // APTUpdateStatus
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(375, 127);
            this.Controls.Add(this.SelectAPT);
            this.Controls.Add(APTStatusUpdate);
            this.Name = "APTUpdateStatus";
            this.Text = "APTUpdateStatus";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button SelectAPT;
        public static System.Windows.Forms.Label APTStatusUpdate;
    }
}