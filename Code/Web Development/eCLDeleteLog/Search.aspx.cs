using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace eCLDeleteLog
{
    public partial class Search : System.Web.UI.Page
    {
        private string connectionString = WebConfigurationManager.ConnectionStrings["CoachingConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        /// <summary>
        /// Call stored procedure sp_SelectReviewFrom_Coaching_Log_For_Delete to populate SearchResultGridView
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void SearchButton_Click(object sender, EventArgs e)
        {
            HideMessage();

            Page.Validate();
            if (Page.IsValid)
            {
                LoadSearchResultGridView(FormNameTextBox.Text.Trim());
                SearchResultGridView.Visible = true;
            }
            else
            {
                SearchResultGridView.Visible = false;
            }
        }

        /// <summary>
        /// Load data to SearchResultGridView
        /// </summary>
        /// <param name="formName"></param>
        private void LoadSearchResultGridView(string formName)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand("EC.sp_SelectReviewFrom_Coaching_Log_For_Delete", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@strFormIDin", formName));

                connection.Open();     
                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    SearchResultGridView.DataSource = dataReader;
                    SearchResultGridView.DataBind();
                }
            }
        }

        /// <summary>
        /// Handle "View Detail" and "Delete"
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void SearchResultGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName.Equals("viewDetail"))
            {
                ViewDetail(rowIndex);
            }
            else if (e.CommandName.Equals("deleteLog"))
            {
                HandleDelete(rowIndex);
            }
        }

        /// <summary>
        /// Delete the selected coaching/warning log
        /// </summary>
        /// <param name="rowIndex"></param>
        private void HandleDelete(int rowIndex)
        {
            var logIDHidden = (HiddenField)SearchResultGridView.Rows[rowIndex].FindControl("LogIDHidden");
            var sourceIDHidden = (HiddenField)SearchResultGridView.Rows[rowIndex].FindControl("SourceIDHidden");
            int logID = int.Parse(logIDHidden.Value);
            int sourceID = int.Parse(sourceIDHidden.Value);

            bool result = Delete(logID, sourceID);
            var logFormNameHidden = (HiddenField)SearchResultGridView.Rows[rowIndex].FindControl("FormNameHidden");
            string logFormName = logFormNameHidden.Value.Trim();

            DisplayDeleteResultMessage(result, logFormName);
            LoadSearchResultGridView(FormNameTextBox.Text.Trim());
        }

        /// <summary>
        /// Return approriate page name based on sourceID (warning or others)
        /// </summary>
        /// <param name="sourceID"></param>
        /// <returns></returns>
        private string GetViewPageNameBySourceID(int sourceID)
        {
            return IsWarning(sourceID) ? "ViewWarning.aspx" : "View.aspx";
        }

        private bool IsWarning(int sourceID)
        {
            return (sourceID == 120 || sourceID == 220);
        }

        /// <summary>
        /// Display coaching/warning log details in bootstrap modal dialog
        /// </summary>
        /// <param name="rowIndex"></param>
        private void ViewDetail(int rowIndex)
        {
            var coachingFormNameHidden = (HiddenField)SearchResultGridView.Rows[rowIndex].FindControl("FormNameHidden");
            var coachingSourceIDHidden = (HiddenField)SearchResultGridView.Rows[rowIndex].FindControl("SourceIDHidden");

            Session["formName"] = coachingFormNameHidden.Value;
            Session["sourceID"] = coachingSourceIDHidden.Value;
            ViewNameHidden.Value = GetViewPageNameBySourceID(int.Parse(coachingSourceIDHidden.Value));
            ScriptManager.RegisterStartupScript(this, this.GetType(), "DetailModalScript", "displayDetailModal();", true);
        }

        /// <summary>
        /// Delete the specified coaching/warning log
        /// </summary>
        /// <param name="rowIndex"></param>
        /// <returns>
        /// <c>true</c> if 
        /// </returns>
        private bool Delete(int logID, int sourceID)
        {
            bool success = false;
            SqlConnection connection = null;
            SqlTransaction transaction = null;
            try
            {
                connection = new SqlConnection(connectionString);
                connection.Open();
                transaction = connection.BeginTransaction();

                // Delete from coaching_log_reason/warning_log_reason table
                SqlCommand deleteLogReasonCommand = new SqlCommand(GetDeleteLogReasonSql(logID, sourceID), connection, transaction);
                deleteLogReasonCommand.Parameters.Add("@ID", SqlDbType.Int);
                deleteLogReasonCommand.Parameters["@ID"].Value = logID;
                deleteLogReasonCommand.ExecuteNonQuery();

                // Delete from coaching_log/warning_log table
                SqlCommand deleteLogCommand = new SqlCommand(GetDeleteLogSql(sourceID), connection, transaction);
                deleteLogCommand.Parameters.Add("@ID", SqlDbType.Int);
                deleteLogCommand.Parameters["@ID"].Value = logID;
                deleteLogCommand.ExecuteNonQuery();

                transaction.Commit();
                success = true;
            }
            catch (Exception ex)
            {
                transaction.Rollback();
                ExceptionMessage.Text = ex.Message;
            }
            finally
            {
                if (connection != null)
                {
                    connection.Close();
                }
            }

            return success;
        }

        /// <summary>
        /// Get the sql statement for deleting from table coaching_log_reason or warning_log_reason based on sourceID
        /// </summary>
        /// <param name="coachingID"></param>
        /// <returns></returns>
        private string GetDeleteLogReasonSql(int logID, int sourceID)
        {
            if (IsWarning(sourceID))
            {
                return "DELETE FROM [EC].[Warning_Log_Reason] WHERE [WarningID] = @ID";
            }

            return "DELETE FROM [EC].[Coaching_Log_Reason] WHERE [CoachingID] = @ID";
        }

        /// <summary>
        /// Get the sql statement for deleting from table coaching_log or warning_log based on sourceID
        /// </summary>
        /// <param name="coachingID"></param>
        /// <returns></returns>
        private string GetDeleteLogSql(int sourceID)
        {
            if (IsWarning(sourceID))
            {
                return "DELETE FROM [EC].[Warning_Log] WHERE [WarningID] = @ID";
            }

            return "DELETE FROM [EC].[Coaching_Log] WHERE [CoachingID] = @ID";
        }

        /// <summary>
        /// Display delete success/fail message on the page
        /// </summary>
        /// <param name="result"></param>
        /// <param name="formName"></param>
        private void DisplayDeleteResultMessage(bool result, string formName)
        {
            if (result)
            {
                SuccessMessage.Text = "Log [" + formName + "] has been successfully deleted.";
                SuccessMessage.Visible = true;
                ErrorMessage.Visible = false;
            }
            else
            {
                ErrorMessage.Text = "Failed to delete log [" + formName + "].";
                ErrorMessage.Visible = true;
                SuccessMessage.Visible = false;
            }
        }

        /// <summary>
        /// Hide delete success/fail message on the page
        /// </summary>
        private void HideMessage()
        {
            SuccessMessage.Visible = false;
            ErrorMessage.Visible = false;
        }
    }
}