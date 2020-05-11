using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Security.AccessControl;
using System.Security.Principal;

namespace Monitoring_Tool.monitoring_pages
{
    public partial class omsi_client_status : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            //getlogdatetime("Desktop-gkoflpn");
            //getpostNjdbc_url("Desktop-gkoflpn");
            getpostNjdbc_url("totpsps01");
            getpostNjdbc_url("totpsappdev01"); 
            getpostNjdbc_url("totpsapptst01");


        }

        private void getpostNjdbc_url(string servername)
        {
            //calling method for 
            string cp_status_log = getlogdatetime(servername);
            string[] cp_status_array = cp_status_log.Split('_');
            var cp_status = cp_status_array[0];
            var cp_log_time = cp_status_array[1];

            var alertclass = "alert-success";
            if (cp_status == "Down")
            {
                //adding css class 
                alertclass = "alert-danger";
                cp_status = "<span class='badge badge-pill badge-danger'>Down</span>";
                cp_log_time = "Last modified date o log file : " + cp_log_time;
            }
            else
            {
                alertclass = "alert-success";
                cp_status = "<span class='badge badge-pill badge-success'>Running</span>";
            }

            //lblgetlogdate.Text = cp_status_log;
            string inputString;

            string[] paths = { @"\\", servername, "D$", "OMSI-Client85", "ini", "CPClientProperties.ini" };
            string path = Path.Combine(paths);
            FileInfo fi = new FileInfo(path);

            //html string 
            String htmlstring = "";
            htmlstring = "<div class='alert " + alertclass + "' role='alert'>";
            htmlstring += "<h3 class='alert-heading'>OMSI Client Parameters: <mark>\"" + servername + "\"</mark></h3>";
            htmlstring += "<div class='mt-4'>";


            using (StreamReader streamReader = fi.OpenText())
            {
                inputString = streamReader.ReadLine();

                if (inputString != null)
                {
                    string line, noOfLines;
                    int lineNumber = 0;
                    using (StreamReader streamReader1 = new StreamReader(path))
                    {
                        /*count for the number of lines*/
                        while ((line = streamReader1.ReadLine()) != null)
                            lineNumber++;

                        noOfLines = lineNumber.ToString();
                        //lbl_CPClientLine.Text = noOfLines;

                        /*loops according to the number of lines*/
                        //for (int count = 1; count <= lineNumber; count++)
                        //{

                        // Open the file to read from.

                        string[] readText = File.ReadAllLines(path);
                        foreach (string s in readText)
                        {

                            string sub1 = "POST_URL";
                            string sub2 = "JDBC_URL";
                            string comstring = "#";

                            if (!s.Contains(comstring) || !s.Contains(""))
                            {
                                if (s.Contains(sub1))

                                {
                                    htmlstring += "<p>" + s.ToString() + "</p>";
                                    //lbl_POST_URL.Text = s.ToString() + "zz";
                                    inputString = streamReader.ReadLine();
                                }
                                if (s.Contains(sub2))

                                {

                                    htmlstring += "<p>" + s.ToString() + "</p>";
                                    //lbl_JDBC_URL.Text = s.ToString() + "zz";
                                    inputString = streamReader.ReadLine();
                                }
                            }

                        }

                        //}
                    }

                }
            }
            htmlstring += "<hr>";
            htmlstring += "<p class='mb-0'>CP Client is " + cp_status +"  "+cp_log_time + "</p>";
            htmlstring += "</div>";
            htmlstring += "</div>";
            //Append the HTML string to Placeholder.
            PlaceHolder_htmlstring.Controls.Add(new Literal { Text = htmlstring });
        }


        private static string getlogdatetime(string servername)
        {
            var cp_status = "";
            string inputString;

            string[] paths = { @"\\", servername, "D$", "OMSI-Client85", "log", "omsi-client.log" };
            string path = Path.Combine(paths);

            if (File.Exists(path))
            {
                //this file exists
            }
            else
            {
                //this file dont exists
            }

            FileInfo fi = new FileInfo(path);
            using (StreamReader streamReader = fi.OpenText())
            {
                inputString = streamReader.ReadLine();
                if (inputString != null)
                {
                    string line, noOfLines;
                    int lineNumber = 0;
                    using (StreamReader streamReader1 = new StreamReader(path))
                    {
                        /*count for the number of lines*/
                        while ((line = streamReader1.ReadLine()) != null)
                            lineNumber++;

                        noOfLines = lineNumber.ToString();
                        //Number of line
                        //lblomsi_clinetlog.Text = noOfLines;


                        // Get the current date.
                        DateTime thisday = DateTime.Now;
                        //lblgetdate.Text = thisday.ToString();

                        //Get Last log datetime.
                        string[] readText = File.ReadAllLines(path);
                        DateTime last_log_datetime = DateTime.Parse(readText.LastOrDefault().Substring(0, 19));
                        //lblgetlogdate.Text = last_log_datetime.ToString();

                        //Get Difference of datetime
                        TimeSpan t = (thisday - last_log_datetime);
                        //lbl_cp_status.Text = t.Minutes.ToString();


                        if (t.Minutes > 5)
                        {

                            //lbl_cp_status.Text = "CP Client is Down. Last mondified date of log file: " + last_log_datetime;
                            cp_status = "Down_" + last_log_datetime;
                        }
                        else
                        {
                            //lbl_cp_status.Text = "CP Client is Running. Last mondified date of log file: " + last_log_datetime;
                            cp_status = "Running_" + last_log_datetime;
                        }
                    }
                }
            }

            return cp_status;
        }


        private void copyfiles()
        {
            string fileName = "file.txt";
            string sourcePath = @"D:\test\";
            //string targetPath = @"D:\test\SubDir";
            string targetPath = HttpContext.Current.Server.MapPath("~/Temp_SubDir");

            // Use Path class to manipulate file and directory paths.
            string sourceFile = System.IO.Path.Combine(sourcePath, fileName);
            string destFile = System.IO.Path.Combine(targetPath, fileName);

            // To copy a folder's contents to a new location:
            // Create a new target folder.
            // If the directory already exists, this method does not create a new directory.
            System.IO.Directory.CreateDirectory(targetPath);

            // To copy a file to another location and
            // overwrite the destination file if it already exists.
            //System.IO.File.Copy(sourceFile, destFile, true);

            // To copy all the files in one directory to another directory.
            // Get the files in the source folder. (To recursively iterate through
            // all subfolders under the current directory, see
            // "How to: Iterate Through a Directory Tree.")
            // Note: Check for target path was performed previously
            //       in this code example.
            if (System.IO.Directory.Exists(sourcePath))
            {
                string[] files = System.IO.Directory.GetFiles(sourcePath);

                // Copy the files and overwrite destination files if they already exist.
                foreach (string s in files)
                {
                    if (s.Contains(fileName))
                    {
                        // Use static Path methods to extract only the file name from the path.
                        fileName = System.IO.Path.GetFileName(s);
                        destFile = System.IO.Path.Combine(targetPath, "P" + fileName);
                        System.IO.File.Copy(s, destFile, true);
                    }
                }
            }
            else
            {
                //lbl_copystatus.Text = "Source path does not exist!";

            }

        }

        protected void btncopy_Click(object sender, EventArgs e)
        {
            copyfiles();
            getlogdatetime("Desktop-gkoflpn");
            getpostNjdbc_url("Desktop-gkoflpn");
        }
    }
}