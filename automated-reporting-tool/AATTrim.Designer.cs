namespace WorkAutomation
{
    partial class AATTrim
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
            this.AATTrimDateSelection = new System.Windows.Forms.MonthCalendar();
            this.AATTrimButton = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // AATTrimDateSelection
            // 
            this.AATTrimDateSelection.Location = new System.Drawing.Point(2, 31);
            this.AATTrimDateSelection.MaxSelectionCount = 31;
            this.AATTrimDateSelection.Name = "AATTrimDateSelection";
            this.AATTrimDateSelection.TabIndex = 0;
            this.AATTrimDateSelection.DateChanged += new System.Windows.Forms.DateRangeEventHandler(this.AATTrimDateSelection_DateChanged);
            // 
            // AATTrimButton
            // 
            this.AATTrimButton.Location = new System.Drawing.Point(68, 240);
            this.AATTrimButton.Name = "AATTrimButton";
            this.AATTrimButton.Size = new System.Drawing.Size(75, 23);
            this.AATTrimButton.TabIndex = 1;
            this.AATTrimButton.Text = "Trim AAT";
            this.AATTrimButton.UseVisualStyleBackColor = true;
            this.AATTrimButton.Click += new System.EventHandler(this.AATTrimButton_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(52, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(121, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "Select Trim Date Range";
            // 
            // AATTrim
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(228, 275);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.AATTrimButton);
            this.Controls.Add(this.AATTrimDateSelection);
            this.Name = "AATTrim";
            this.Text = "AATTrim";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.MonthCalendar AATTrimDateSelection;
        private System.Windows.Forms.Button AATTrimButton;
        private System.Windows.Forms.Label label1;
    }
}