using log4net;
using System;
using System.IO;

namespace eCLAdmin.Utilities
{
    public class FileUtil
    {
        static readonly ILog logger = LogManager.GetLogger(typeof(FileUtil));

        public static string ReadFile(string fileFullPath)
        {
            StreamReader sr = null;
            string retValue = null;
            
            try
            {
                sr = new StreamReader(fileFullPath);
                retValue = sr.ReadToEnd();
            }
            catch (Exception ex)
            {
                logger.Debug("Exception when reading email template file [" + fileFullPath + "]: " + ex.Message);
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                    sr = null;
                }
            }

            return retValue;
        }
    }
}