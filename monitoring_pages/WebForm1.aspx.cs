using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection.Emit;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Runtime.InteropServices;

namespace Monitoring_Tool.monitoring_pages
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {



            byte[] output1 = Helper.ReadFileBytes(@"D:\OMSI-Client85\log\omsi-client.log");
            string output2 = Helper.ReadFileTextWithEncoding(@"D:\OMSI-Client85\log\omsi-client.log");
            string output3 = Helper.ReadFileTextNoEncoding(@"D:\OMSI-Client85\log\omsi-client.log");
            Label1.Text = output1.ToString();
            Label2.Text = output2.ToString();
            Label3.Text = output3.ToString();

        }
        internal static class Helper
        {
            const int ERROR_SHARING_VIOLATION = 32;
            const int ERROR_LOCK_VIOLATION = 33;

            private static bool IsFileLocked(Exception exception)
            {
                int errorCode = Marshal.GetHRForException(exception) & ((1 << 16) - 1);
                return errorCode == ERROR_SHARING_VIOLATION || errorCode == ERROR_LOCK_VIOLATION;
            }

            internal static bool CanReadFile(string filePath)
            {
                //Try-Catch so we dont crash the program and can check the exception
                try
                {
                    //The "using" is important because FileStream implements IDisposable and
                    //"using" will avoid a heap exhaustion situation when too many handles  
                    //are left undisposed.
                    using (FileStream fileStream = File.Open(filePath, FileMode.Open, FileAccess.ReadWrite, FileShare.None))
                    {
                        if (fileStream != null) fileStream.Close();  //This line is me being overly cautious, fileStream will never be null unless an exception occurs... and I know the "using" does it but its helpful to be explicit - especially when we encounter errors - at least for me anyway!
                    }
                }
                catch (IOException ex)
                {
                    //THE FUNKY MAGIC - TO SEE IF THIS FILE REALLY IS LOCKED!!!
                    if (IsFileLocked(ex))
                    {
                        // do something, eg File.Copy or present the user with a MsgBox - I do not recommend Killing the process that is locking the file
                        return false;
                    }
                }
                finally
                { }
                return true;
            }


            public static byte[] ReadFileBytes(string filePath)
            {
                byte[] buffer = null;
                try
                {
                    using (FileStream fileStream = File.Open(filePath, FileMode.Open, FileAccess.ReadWrite, FileShare.None))
                    {
                        int length = (int)fileStream.Length;  // get file length
                        buffer = new byte[length];            // create buffer
                        int count;                            // actual number of bytes read
                        int sum = 0;                          // total number of bytes read

                        // read until Read method returns 0 (end of the stream has been reached)
                        while ((count = fileStream.Read(buffer, sum, length - sum)) > 0)
                            sum += count;  // sum is a buffer offset for next reading

                        fileStream.Close(); //This is not needed, just me being paranoid and explicitly releasing resources ASAP
                    }
                }
                catch (IOException ex)
                {
                    //THE FUNKY MAGIC - TO SEE IF THIS FILE REALLY IS LOCKED!!!
                    if (IsFileLocked(ex))
                    {
                        // do something? 
                    }
                }
                catch (Exception ex)
                {
                }
                finally
                {
                }
                return buffer;
            }

            public static string ReadFileTextWithEncoding(string filePath)
            {
                string fileContents = string.Empty;
                byte[] buffer;
                try
                {
                    using (FileStream fileStream = File.Open(filePath, FileMode.Open, FileAccess.ReadWrite, FileShare.None))
                    {
                        int length = (int)fileStream.Length;  // get file length
                        buffer = new byte[length];            // create buffer
                        int count;                            // actual number of bytes read
                        int sum = 0;                          // total number of bytes read

                        // read until Read method returns 0 (end of the stream has been reached)
                        while ((count = fileStream.Read(buffer, sum, length - sum)) > 0)
                        {
                            sum += count;  // sum is a buffer offset for next reading
                        }

                        fileStream.Close(); //Again - this is not needed, just me being paranoid and explicitly releasing resources ASAP

                        //Depending on the encoding you wish to use - I'll leave that up to you
                        fileContents = System.Text.Encoding.Default.GetString(buffer);
                    }
                }
                catch (IOException ex)
                {
                    //THE FUNKY MAGIC - TO SEE IF THIS FILE REALLY IS LOCKED!!!
                    if (IsFileLocked(ex))
                    {
                        // do something? 
                    }
                }
                catch (Exception ex)
                {
                }
                finally
                { }
                return fileContents;
            }

            public static string ReadFileTextNoEncoding(string filePath)
            {
                string fileContents = string.Empty;
                byte[] buffer;
                try
                {
                    using (FileStream fileStream = File.Open(filePath, FileMode.Open, FileAccess.ReadWrite, FileShare.None))
                    {
                        int length = (int)fileStream.Length;  // get file length
                        buffer = new byte[length];            // create buffer
                        int count;                            // actual number of bytes read
                        int sum = 0;                          // total number of bytes read

                        // read until Read method returns 0 (end of the stream has been reached)
                        while ((count = fileStream.Read(buffer, sum, length - sum)) > 0)
                        {
                            sum += count;  // sum is a buffer offset for next reading
                        }

                        fileStream.Close(); //Again - this is not needed, just me being paranoid and explicitly releasing resources ASAP

                        char[] chars = new char[buffer.Length / sizeof(char) + 1];
                        System.Buffer.BlockCopy(buffer, 0, chars, 0, buffer.Length);
                        fileContents = new string(chars);
                    }
                }
                catch (IOException ex)
                {
                    //THE FUNKY MAGIC - TO SEE IF THIS FILE REALLY IS LOCKED!!!
                    if (IsFileLocked(ex))
                    {
                        // do something? 
                    }
                }
                catch (Exception ex)
                {
                }
                finally
                {
                }

                return fileContents;
            }
        }
    }
}