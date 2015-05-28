using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.DirectoryServices;

namespace CSRID2
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        //string lan = HttpContext.Current.User.Identity.Name.Replace("VNGT\\", "").ToLower();
                
        protected void Page_Load(object sender, EventArgs e)
        {
            string lan = HttpContext.Current.User.Identity.Name.ToLower();
            //string strDomain = "";

            if (lan.Contains("vngt"))
            {
             //strDomain = "LDAP://dc=vangent,dc=local";
                lan = lan.Replace("vngt\\", "").ToLower();

                try
                {
                    DirectoryEntry entry = new DirectoryEntry("LDAP://dc=vangent,dc=local");
                    DirectorySearcher dsSearch = new DirectorySearcher(entry);
                    dsSearch.Filter = "(&(objectCategory=User)(sAMAccountName=" + lan + ")(displayName=*))";

                    DirectoryEntry dResult = dsSearch.FindOne().GetDirectoryEntry();
                    Label2.Text = dResult.Properties["displayName"].Value.ToString();

                }
                catch (Exception ex)
                {
                    Response.Write("error with LDAP\n\n\n");
                    Response.Write(ex);
                    Response.Redirect("error2.aspx");
                }
            }
            else
            {
             //strDomain = "LDAP://dc=ad,dc=local";
                lan = lan.Replace("ad\\", "").ToLower();

                try
                {
                    DirectoryEntry entry = new DirectoryEntry("LDAP://dc=ad,dc=local");
                    DirectorySearcher dsSearch = new DirectorySearcher(entry);
                    dsSearch.Filter = "(&(objectCategory=User)(sAMAccountName=" + lan + ")(displayName=*))";

                    DirectoryEntry dResult = dsSearch.FindOne().GetDirectoryEntry();
                    Label2.Text = dResult.Properties["displayName"].Value.ToString();

                }
                catch (Exception ex)
                {
                    Response.Write("error with LDAP\n\n\n");
                    Response.Write(ex);
                    Response.Redirect("error2.aspx");
                }

            }

          
        }
    }
}