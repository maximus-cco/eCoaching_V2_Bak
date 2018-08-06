Public Class MySurveyLogDetailView
    Inherits System.Web.UI.Page

    Sub Page_Error(sender As Object, e As EventArgs)
        Dim ex As Exception = Server.GetLastError().GetBaseException()
        Session("LastError") = ex.Message
        Server.ClearError()
        Response.Redirect("MySurveyError.aspx")
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not Page.IsPostBack AndAlso Session("AccessAllowed") AndAlso Session("Submitted") Is Nothing) Then
            PopulatePage()
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub PopulatePage()
        Dim handler As MySurveyLogDetailViewHandler = New MySurveyLogDetailViewHandler()
        Dim logName As String = Session("LogName")
        Dim logDetail As MySurveyLogDetail = handler.GetLogDetail(logName)

        CoachingReasonGridView.DataSource = handler.GetLogReasons(logName)
        CoachingReasonGridView.DataBind()

        PageValueLabel.Text = logDetail.Status
        FormIDValueLabel.Text = logDetail.ID
        StatusValueLabel.Text = logDetail.Status
        TypeValueLabel.Text = logDetail.Type
        DataSubmittedValueLabel.Text = logDetail.SubmittedDate & " PDT"

        CoachingDateValueLabel.Text = If(String.IsNullOrWhiteSpace(logDetail.CoachingDate), String.Empty, CDate(logDetail.CoachingDate).ToShortDateString())
        EventDateValueLabel.Text = If(String.IsNullOrWhiteSpace(logDetail.EventDate), String.Empty, CDate(logDetail.EventDate).ToShortDateString())
        SourceValueLabel.Text = logDetail.Source
        SiteValueLabel.Text = logDetail.Site
        VerintIDValueLabel.Text = logDetail.VerintID
        ScoreCardNameValueLabel.Text = logDetail.VerintFormName
        AvokeIDValueLabel.Text = logDetail.BehaviorAnalyticsID
        NgdActivityIDValueLabel.Text = logDetail.NGDActivityID
        UniversalCallIDValueLabel.Text = logDetail.UCID
        EmployeeValueLabel.Text = logDetail.EmployeeName
        SupervisorValueLabel.Text = logDetail.SupervisorName
        ManagerValueLabel.Text = logDetail.ManagerName
        SubmitterValueLabel.Text = logDetail.SubmitterName
        BehaviorDetailsValueLabel.Text = logDetail.Description
        ManagementNotesValueLabel.Text = logDetail.ManagerNotes
        CoachingNotesValueLabel.Text = logDetail.CoachingNotes
        EmployeeNameValueLabel.Text = logDetail.EmployeeName
        SupervisorNameValueLabel.Text = logDetail.SupervisorName
        EmployeeCommentsFeedbackValueLabel.Text = logDetail.EmployeeComments

        If Not String.IsNullOrWhiteSpace(logDetail.EmployeeReviewedAutoDate) Then
            EmployeeReviewedDateValueLabel.Text = logDetail.EmployeeReviewedAutoDate & " PDT"
        End If

        If Not String.IsNullOrWhiteSpace(logDetail.ReviewerReviewedAutoDate) Then
            SupervisorReviewedDateValueLabel.Text = logDetail.ReviewerReviewedAutoDate & " PDT"
        End If

        ShowAndHide(logDetail)
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="logDetail"></param>
    ''' <remarks></remarks>
    Private Sub ShowAndHide(logDetail As MySurveyLogDetail)
        ShowHideCoachingDateEventDatePanel(logDetail.Type)
        ShowHideVerintPanel(logDetail.IsVerintMonitor)
        ShowHideAvokeIDPanel(logDetail.IsBehaviorAnalyticsMonitor)
        ShowHideNgdActivityIDPanel(logDetail.IsNGDActivityID)
        ShowHideUniversalCallIDPanel(logDetail.IsUCID)
        ShowHideCustomerServiceEscalation(logDetail.CSE, logDetail.IsCSE)
        ShowHideManagementNotesPanel(logDetail.ManagerNotes)
        ShowHideSupervisorReviewInformationPanel(logDetail.IsIQS)
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="type"></param>
    ''' <remarks></remarks>
    Private Sub ShowHideCoachingDateEventDatePanel(type As String)
        ' Coaching Date and Event Date display
        If (String.Equals(type, "Direct", StringComparison.OrdinalIgnoreCase)) Then
            CoachingDatePanel.Visible = True
            EventDatePanel.Visible = False
        Else
            CoachingDatePanel.Visible = False
            EventDatePanel.Visible = True
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="isVerintMonitor"></param>
    ''' <remarks></remarks>
    Private Sub ShowHideVerintPanel(isVerintMonitor As String)
        If StringUtils.IsTrue(isVerintMonitor) Then
            VerintPanel.Visible = True
        Else
            VerintPanel.Visible = False
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="isBehaviorAnalyticsMonitor"></param>
    ''' <remarks></remarks>
    Private Sub ShowHideAvokeIDPanel(isBehaviorAnalyticsMonitor As String)
        If StringUtils.IsTrue(isBehaviorAnalyticsMonitor) Then
            AvokeIDPanel.Visible = True
        Else
            AvokeIDPanel.Visible = False
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="isNGDActivityID"></param>
    ''' <remarks></remarks>
    Private Sub ShowHideNgdActivityIDPanel(isNGDActivityID As String)
        If StringUtils.IsTrue(isNGDActivityID) Then
            NgdActivityIDPanel.Visible = True
        Else
            NgdActivityIDPanel.Visible = False
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="isUCID"></param>
    ''' <remarks></remarks>
    Private Sub ShowHideUniversalCallIDPanel(isUCID As String)
        If StringUtils.IsTrue(isUCID) Then
            UniversalCallIDPanel.Visible = True
        Else
            UniversalCallIDPanel.Visible = False
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="customerServiceEscalation"></param>
    ''' <param name="isCSE"></param>
    ''' <remarks></remarks>
    Private Sub ShowHideCustomerServiceEscalation(customerServiceEscalation As String, isCSE As String)
        If customerServiceEscalation = "1" AndAlso StringUtils.IsTrue(isCSE) Then
            CustomerServiceEscalationLabel.Visible = True
        Else
            NonCustomerServiceEscalationPanel.Visible = True
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="managementNotes"></param>
    ''' <remarks></remarks>
    Private Sub ShowHideManagementNotesPanel(managementNotes As String)
        If (Not String.IsNullOrWhiteSpace(managementNotes)) Then
            ManagementNotesPanel.Visible = True
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="isIQS"></param>
    ''' <remarks></remarks>
    Private Sub ShowHideSupervisorReviewInformationPanel(isIQS As String)
        If isIQS = "1" Then
            EmployeeReviewedDateLabel.Text = "Reviewed and acknowledged Quality Monitor on"
            SupervisorReviewInformationPanel.Visible = True
        Else
            EmployeeCommentsFeedbackPanel.Visible = True
        End If
    End Sub

End Class