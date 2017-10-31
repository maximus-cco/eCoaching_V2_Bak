using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace eCLDeleteLog
{
    public partial class Detail : System.Web.UI.Page
    {
        private string connectionString = WebConfigurationManager.ConnectionStrings["CoachingConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            string formName = (string)Session["formName"];
            if (formName != null)
            {
                PageValueLabel.Text = FetchLogStatus();
                this.BindPage(formName);
                this.BindCoachingReasonGridView(formName);
            }
        }

        /// <summary>
        /// Return the form status.
        /// </summary>
        /// <param name="formName"></param>
        /// <returns>formStatus</returns>
        private string FetchLogStatus()
        {
            string formStatus = null;
            string formName = Request.QueryString["formName"];

            if (formName == null)
            {
                return null;
            }

            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand("EC.sp_SelectRecordStatus", connection))
            {
                connection.Open();
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@strFormID", formName));
                using (SqlDataReader sqlDataReader = command.ExecuteReader())
                {
                    while (sqlDataReader.Read())
                    {
                        formStatus = sqlDataReader["strFormStatus"].ToString();
                    }
                }
            }

            return formStatus;
        }

        /// <summary>
        /// Call stored procedure sp_SelectReviewFrom_Coaching_Log_Reasons to populate CoachingReasonGridView
        /// </summary>
        /// <param name="formName"></param>
        private void BindCoachingReasonGridView(string formName)
        {
            if (formName != null)
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                using (SqlCommand command = new SqlCommand("EC.sp_SelectReviewFrom_Coaching_Log_Reasons", connection))
                {
                    connection.Open();
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(new SqlParameter("@strFormIDin", formName));
                    using (SqlDataReader sqlDataReader = command.ExecuteReader())
                    {
                        CoachingReasonGridView.DataSource = sqlDataReader;
                        CoachingReasonGridView.DataBind();
                    }
                }
            }
        }

        /// <summary>
        /// Call stored procedure sp_SelectReviewFrom_Coaching_Log to populate fields on the page
        /// </summary>
        /// <param name="formName"></param>
        private void BindPage(string formName)
        {
            if (formName != null)
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                using (SqlCommand command = new SqlCommand("EC.sp_SelectReviewFrom_Coaching_Log", connection))
                {
                    connection.Open();

                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(new SqlParameter("@strFormIDin", formName));
                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            FormIDValueLabel.Text = dataReader["strFormID"].ToString();
                            StatusValueLabel.Text = dataReader["strFormStatus"].ToString();
                            DataSubmittedValueLabel.Text = dataReader["SubmittedDate"].ToString();
                            TypeValueLabel.Text = dataReader["strFormType"].ToString();

                            CoachingDateValueLabel.Text = dataReader["CoachingDate"].ToString();
                            EventDateValueLabel.Text = dataReader["EventDate"].ToString();
                            this.ShowHideCoachingDateEventDatePanel();

                            SourceValueLabel.Text = dataReader["strSource"].ToString();
                            SiteValueLabel.Text = dataReader["strCSRSite"].ToString();

                            VerintIDValueLabel.Text = dataReader["strVerintID"].ToString();
                            ScoreCardNameValueLabel.Text = dataReader["VerintFormName"].ToString();
                            this.ShowHideVerintPanel(dataReader["isVerintMonitor"].ToString());

                            AvokeIDValueLabel.Text = dataReader["strBehaviorAnalyticsID"].ToString();
                            this.ShowHideAvokeIDPanel(dataReader["isBehaviorAnalyticsMonitor"].ToString());

                            NgdActivityIDValueLabel.Text = Server.HtmlDecode(dataReader["strNGDActivityID"].ToString());
                            this.ShowHideNgdActivityIDPanel(dataReader["isNGDActivityID"].ToString());

                            UniversalCallIDValueLabel.Text = dataReader["strUCID"].ToString();
                            this.ShowHideUniversalCallIDPanel(dataReader["isUCID"].ToString());

                            EmployeeValueLabel.Text = dataReader["strCSRName"].ToString();
                            SupervisorValueLabel.Text = dataReader["strCSRSupName"].ToString();
                            ManagerValueLabel.Text = dataReader["strCSRMgr"].ToString();
                            SubmitterValueLabel.Text = dataReader["strSubmitterName"].ToString();

                            BehaviorDetailsValueLabel.Text = Server.HtmlDecode(dataReader["txtDescription"].ToString());

                            ManagementNotesValueLabel.Text = dataReader["txtMgrNotes"].ToString();
                            this.ShowHideCustomerServiceEscalation(dataReader["Customer Service Escalation"].ToString(), dataReader["isCSE"].ToString());
                            this.ShowHideManagementNotesPanel(ManagementNotesValueLabel.Text);

                            CoachingNotesValueLabel.Text = dataReader["txtCoachingNotes"].ToString();

                            EmployeeNameValueLabel.Text = dataReader["strCSRName"].ToString();
                            EmployeeReviewedDateValueLabel.Text = string.IsNullOrWhiteSpace(dataReader["CSRReviewAutoDate"].ToString()) ? "" : dataReader["CSRReviewAutoDate"].ToString() + "&nbsp;PDT";

                            SupervisorNameValueLabel.Text = dataReader["strReviewer"].ToString();
                            SupervisorReviewedDateValueLabel.Text = string.IsNullOrWhiteSpace(dataReader["SupReviewedAutoDate"].ToString()) ? "" : dataReader["SupReviewedAutoDate"].ToString() + "&nbsp;PDT";
                            this.ShowHideSupervisorReviewInformationPanel(dataReader["isIQS"].ToString());

                            EmployeeCommentsFeedbackValueLabel.Text = dataReader["txtCSRComments"].ToString();
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Show/Hide Date of Coaching:
        /// Show/Hide Date of Event:
        /// </summary>
        private void ShowHideCoachingDateEventDatePanel()
        {
            // Coaching Date and Event Date display
            if (string.Equals(TypeValueLabel.Text, "Direct", StringComparison.OrdinalIgnoreCase))
            {
                CoachingDatePanel.Visible = true;
                EventDatePanel.Visible = false;
            }
            else // Indirect
            {
                EventDatePanel.Visible = true;
                CoachingDatePanel.Visible = false;
            }
        }

        /// <summary>
        /// Show/Hide Verint ID panel
        /// </summary>
        /// <param name="isVerintMonitor"></param>
        private void ShowHideVerintPanel(string isVerintMonitor)
        {
            if (isVerintMonitor == "True")
            {
                VerintPanel.Visible = true;
            }
            else
            {
                VerintPanel.Visible = false;
            }
        }

        /// <summary>
        /// Show/Hide Avoke ID panel
        /// </summary>
        /// <param name="isBehaviorAnalyticsMonitor"></param>
        private void ShowHideAvokeIDPanel(string isBehaviorAnalyticsMonitor)
        {
            if (isBehaviorAnalyticsMonitor == "True")
            {
                AvokeIDPanel.Visible = true;
            }
            else
            {
                AvokeIDPanel.Visible = false;
            }
        }

        /// <summary>
        /// Show/Hide NGD Activity ID panel
        /// </summary>
        /// <param name="isNGDActivityID"></param>
        private void ShowHideNgdActivityIDPanel(string isNGDActivityID)
        {
            if (isNGDActivityID == "True")
            {
                NgdActivityIDPanel.Visible = true;
            }
            else
            {
                NgdActivityIDPanel.Visible = false;
            }
        }

        /// <summary>
        /// Show/Hide Universal Call ID panel
        /// </summary>
        /// <param name="isUCID"></param>
        private void ShowHideUniversalCallIDPanel(string isUCID)
        {
            if (isUCID == "True")
            {
                UniversalCallIDPanel.Visible = true;
            }
            else
            {
                UniversalCallIDPanel.Visible = false;
            }
        }

        /// <summary>
        /// Show/Hide CustomerServiceEscalationLabel - "Coaching Opportunity was a confirmed Customer Service Escalation"
        /// Show/Hide NonCustomerServiceEscalationPanel - "Coaching Opportunity was not a confirmed Customer Service Escalation"
        /// </summary>
        /// <param name="customerServiceEscalation"></param>
        /// <param name="isCSE"></param>
        private void ShowHideCustomerServiceEscalation(string customerServiceEscalation, string isCSE)
        {
            if (customerServiceEscalation == "1")
            {
                if (isCSE == "True")
                {
                    CustomerServiceEscalationLabel.Visible = true;
                }
                else
                {
                    NonCustomerServiceEscalationPanel.Visible = true;
                }
            }
        }

        /// <summary>
        /// Show/Hide Management Notes panel
        /// </summary>
        /// <param name="managementNotes"></param>
        private void ShowHideManagementNotesPanel(string managementNotes)
        {
            if (!string.IsNullOrWhiteSpace(managementNotes))
            {
                ManagementNotesPanel.Visible = true;
            }
        }

        /// <summary>
        /// Show/Hide Supervisor Review Information panel
        /// Show/Hide Employee Comments/Feedback panel
        /// </summary>
        /// <param name="isIQS"></param>
        private void ShowHideSupervisorReviewInformationPanel(string isIQS)
        {
            if (isIQS == "1")
            {
                EmployeeReviewedDateLabel.Text = "Reviewed and acknowledged Quality Monitor on";
                SupervisorReviewInformationPanel.Visible = true;
            }
            else
            {
                EmployeeCommentsFeedbackPanel.Visible = true;
            }
        }

    }
}