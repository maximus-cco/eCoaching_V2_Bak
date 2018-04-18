using log4net;
using System;
using System.IO;

namespace eCoachingLog.Utilities
{
    public class FileUtil
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

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