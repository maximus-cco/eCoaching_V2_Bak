using System;

namespace eCLDeleteLog
{
    public partial class Error : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Exception error = Session["LastError"] as Exception;
            if (error != null)
            {
                error = error.GetBaseException();

                ExceptionMessage.Text = "@@" + error.Message + "##########" +"!!";

                if (error.InnerException != null)
                {
                    ExceptionMessage.Text = "AAAAAAA";
                }

                StackTrace.Text = error.StackTrace;
                Session["LastError"] = null;
            }
        }
    }
}