using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.DirectoryServices;
using System.Text.RegularExpressions;
using System.Data.SqlClient;
using System.Data;

//using System.Windows.Forms;

namespace eCLUsers
{
    public partial class _Default : System.Web.UI.Page
    {
        //string lan = HttpContext.Current.User.Identity.Name.Replace("VNGT\\", "").ToLower();
        string lan;
        List<string> validUsers = new List<string>();
        string returnMsg = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            lan = HttpContext.Current.User.Identity.Name.ToLower();
            lan = lan.Replace("ad\\", "").ToLower();
            lan = lan.Replace("vngt\\", "").ToLower();
            
            SqlDataSource2.SelectParameters["nvcLANID"].DefaultValue = lan;
            SqlDataSource2.DataBind();
            Label ulevel = (Label)GridView2.Rows[0].FindControl("Level");

            Label6.Text = ulevel.Text;

            Boolean bValidUser = false;
            //System.Windows.Forms.MessageBox.Show(Label6.Text);

            if (Label6.Text == "Y")
            {
                    bValidUser = true;
                    LanIDLenghtError.Visible = false;
                    //      SqlDataSource1.DeleteParameters["nvcLanID"].DefaultValue = lan;
                                   //     SqlDataSource1.SelectParameters["dtmDate"].DefaultValue = "2012/09/20"; // DateTime.Now.ToString();
                
            }
            
            if (!bValidUser)
            {
                //redirect user if they are not authorized
                Response.Redirect("UnAuthorizedUser11.aspx");
            }

            //AccessOption.SelectedIndex = accessIndex;
        }

        protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
        {
          //processing for assigning insert parameters prior to submission
            
            //System.Windows.Forms.MessageBox.Show(NewUserLanId.Text.Length.ToString());

            if ((NewUserLanId.Text.Length > 5) & (NewUserLanId.Text.Length < 21))

            {
                if (!Regex.IsMatch(NewUserLanId.Text, "^[0-9a-zA-Z-.']{6,20}$"))
                {
                    LanIDLenghtError.Text = "* Invalid LAN ID characters are present.";
                    LanIDLenghtError.Visible = true;
                }
                else
                {
                    SqlDataSource1.InsertParameters["nvcACTION"].DefaultValue = "ADD";
                    SqlDataSource1.InsertParameters["nvcLANID"].DefaultValue = lan;
                    SqlDataSource1.InsertParameters["nvcRole"].DefaultValue = AccessOption.SelectedValue;
                    SqlDataSource1.InsertParameters["nvcUserLANID"].DefaultValue = NewUserLanId.Text.ToLower();
                    
                    SqlDataSource1.InsertParameters["nvcErrorMsgForEndUser"].DefaultValue = null;
                    SqlDataSource1.Insert();

                    //System.Windows.Forms.MessageBox.Show((string)SqlDataSource1.InsertParameters["nvcErrorMsgForEndUser"].DefaultValue);
                   
                       if (returnMsg.Length == 0)
                    {
                    LanIDLenghtError.Visible = false;
                    }
                    else
                    {
                          LanIDLenghtError.Text = returnMsg;
                    LanIDLenghtError.Visible = true;
                    }
                    //Removed the response redirect to keep the dropdown selection.
                    //Response.Redirect("Default.aspx")
                    NewUserLanId.Text = "";
                }
            }
            else
            {
                LanIDLenghtError.Visible = true;
                if (NewUserLanId.Text.Length > 0)
                {
                    LanIDLenghtError.Text = "* LAN ID must be at least 6 characters.";
                }
                else
                {
                    LanIDLenghtError.Text = "* No LAN ID was entered.";
                }
            }


        }


        protected void GridviewApp_Selecting(object sender, GridViewSelectEventArgs e)
        {
            // processing for assigning update parameters prior to submission

            
          //  SqlDataSource2.SelectParameters["nvcLANID"].DefaultValue = lan;
           // SqlDataSource2.DataBind();

           
        }

        protected void GridviewView_Updating(object sender, GridViewUpdateEventArgs e)
        {
            // processing for assigning update parameters prior to submission
   
      //string rid = GridView1.DataKeys[e.RowIndex].Value.ToString() ;
      TextBox ulan = (TextBox) GridView1.Rows[e.RowIndex].FindControl("UserLAN"); //get the entered LANID for update
      Label rowID = (Label)GridView1.Rows[e.RowIndex].FindControl("RowLabel1"); //get the row ID for the record being updated
      DropDownList role = (DropDownList)GridView1.Rows[e.RowIndex].FindControl("RoleDropdown"); //get the row ID for the record being updated
      
            string eulan = ulan.Text;
            string erowID = rowID.Text;
            string erole = role.SelectedValue;

            SqlDataSource1.UpdateParameters["nvcRowID"].DefaultValue = erowID;
            SqlDataSource1.UpdateParameters["nvcLANID"].DefaultValue = lan;
            SqlDataSource1.UpdateParameters["nvcRole"].DefaultValue = erole;
          SqlDataSource1.UpdateParameters["nvcUserLANID"].DefaultValue = eulan.ToLower();

        }


        protected void GridviewView_Deleting(object sender, GridViewDeleteEventArgs e)
        {

            //processing for assigning delete parameters prior to submission
            
            //  foreach (Parameter aParameter in SqlDataSource1.DeleteParameters)
           // {
            //    Response.Write(aParameter.Name + "<BR>");
            //}

            Label ulan = (Label)GridView1.Rows[e.RowIndex].FindControl("UserLAN");
            string eulan = ulan.Text;
         
            SqlDataSource1.DeleteParameters["nvcACTION"].DefaultValue = "REMOVE";
            SqlDataSource1.DeleteParameters["nvcLANID"].DefaultValue = lan;
            SqlDataSource1.DeleteParameters["nvcRole"].DefaultValue = AccessOption.SelectedValue;
            SqlDataSource1.DeleteParameters["nvcUserLANID"].DefaultValue = eulan;
            SqlDataSource1.Delete();   
        }



        public string setImage(string user, string uname)
        {  
          //  if (user == "cougbr")
           //     return "~/Images/1348199466_metacontact_unknown.png";

            //return "~/Images/1348199437_user_2.png";

            if (user == lan)

                return "~/Images/1348199381_user_3.png"; 
            else if (uname == "Unknown")

                return "~/Images/1348199466_metacontact_unknown.png";
            else

                return "~/Images/1348199437_user_2.png";
        }


        protected void errorFound_OnInserted(object sender, SqlDataSourceStatusEventArgs e) 

        {
            returnMsg = e.Command.Parameters["@nvcErrorMsgForEndUser"].Value.ToString();
             // System.Windows.Forms.MessageBox.Show(returnMsg);
        }
       
    }
}