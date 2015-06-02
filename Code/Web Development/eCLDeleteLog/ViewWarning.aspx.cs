using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace eCLDeleteLog
{
    public partial class ViewWarning : System.Web.UI.Page
    {
        private string connectionString = WebConfigurationManager.ConnectionStrings["CoachingConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            string formName = (string)Session["formName"];
            if (formName != null)
            {
                this.BindPage(formName);
                this.BindCoachingReasonGridView(formName);
                this.ShowAndHide(formName);
            }
        }

        /// <summary>
        /// Call stored procedure sp_SelectReviewFrom_Warning_Log to populate page fields
        /// </summary>
        /// <param name="formName"></param>
        private void BindPage(string formName)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand("EC.sp_SelectReviewFrom_Warning_Log", connection))
            {
                connection.Open();
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@strFormIDin", formName));
                using (SqlDataReader sqlDataReader = command.ExecuteReader())
                {
                    while (sqlDataReader.Read())
                    {
                        FormIDValueLabel.Text = sqlDataReader["strFormID"].ToString();
                        StatusValueLabel.Text = sqlDataReader["strFormStatus"].ToString();
                        DateSubmittedValueLabel.Text = string.IsNullOrWhiteSpace(sqlDataReader["SubmittedDate"].ToString()) ? "" : sqlDataReader["SubmittedDate"].ToString() + "&nbsp;PDT";
                        TypeValueLabel.Text = sqlDataReader["strFormType"].ToString();
                        WarningDateValueLabel.Text = sqlDataReader["EventDate"].ToString();
                        SourceValueLabel.Text = sqlDataReader["strSource"].ToString();
                        SiteValueLabel.Text = sqlDataReader["strCSRSite"].ToString();
                        EmployeeValueLabel.Text = sqlDataReader["strCSRName"].ToString();
                        SupervisorValueLabel.Text = sqlDataReader["strCSRSupName"].ToString();
                        ManagerValueLabel.Text = sqlDataReader["strCSRMgrName"].ToString();
                        SubmitterValueLabel.Text = sqlDataReader["strSubmitter"].ToString();
                    }
                }
            }
        }

        /// <summary>
        /// Call stored procedure sp_SelectReviewFrom_Warning_Log_Reasons to populate CoachingReasonGridView
        /// </summary>
        /// <param name="formName"></param>
        private void BindCoachingReasonGridView(string formName)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand("EC.sp_SelectReviewFrom_Warning_Log_Reasons", connection))
            {
                connection.Open();
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@strFormIDin", formName));
                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    CoachingReasonGridView.DataSource = dataReader;
                    CoachingReasonGridView.DataBind();
                }
            }
        }

        /// <summary>
        /// Show/Hide panels/fields on the page
        /// </summary>
        /// <param name="formName"></param>
        private void ShowAndHide(string formName)
        {
            if (formName.Length > 9 && formName.ToLower().Trim().StartsWith("ecl-"))
            {
                LeftContentPanel.Visible = true;
                PageValueLabel.Text = "Final";

                InvalidFormIDPanel.Visible = false;
            }
            else
            {
                InvalidFormIDPanel.Visible = true;

                LeftContentPanel.Visible = false;
                InstructionLabel.Visible = false;
                CoachingReasonLabel.Visible = false;
                CoachingReasonGridView.Visible = false;
            }
        }
    }
}