using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using log4net;
using log4net.Appender;

namespace SharePointToolBox
{
    public class Log4NetTraceListener : TraceListener, IDisposable
    {
        public ILog Logger { get; private set; }

        public Log4NetTraceListener()
        {
            Logger = LogManager.GetLogger(System.AppDomain.CurrentDomain.FriendlyName);
        }

        public override void Write(string message)
        {
            Logger.Debug(message);
        }

        public override void WriteLine(string message)
        {
            Logger.Debug(message);
        }
    }
}
