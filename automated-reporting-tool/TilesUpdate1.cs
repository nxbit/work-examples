using System.IO;
using System.Text.RegularExpressions;

namespace WorkAutomation
{
    internal class TilesUpdate

    {
        public string FilePath { get; set; }

        public static void ReplaceInFile(
                      string filePath, string searchText, string replaceText)
        {
            var content = string.Empty;
            using (StreamReader reader = new StreamReader(filePath))
            {
                content = reader.ReadToEnd();
                reader.Close();
            }

            content = Regex.Replace(content, searchText, replaceText);

            using (StreamWriter writer = new StreamWriter(filePath))
            {
                writer.Write(content);
                writer.Close();
            }
        }
    }
}