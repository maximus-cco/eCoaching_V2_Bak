Public Class MySurvey
	Inherits BasePage

	Const CommentMaxLength = 4000
    Const ViewStateSurvey = "Survey"

    Private handler As New MySurveyHandler()

    Private survey As Survey

    Sub Page_Error(sender As Object, e As EventArgs)
        Dim ex As Exception = Server.GetLastError().GetBaseException()
        Session("LastError") = ex.Message
        Server.ClearError()
        Response.Redirect("MySurveyError.aspx")
    End Sub

    Protected Sub Page_Init(sender As Object, e As System.EventArgs) Handles Me.Init
        If (Session("Submitted") IsNot Nothing AndAlso Session("Submitted") = "Success") Then
            DisplaySuccessMsg()
        End If
    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        ' First time page load
        If (Not Page.IsPostBack AndAlso Session("Submitted") Is Nothing) Then

            Dim surveyID As Integer = Request.QueryString("id")
			Dim survey As Survey = handler.GetSurvey(surveyID)

			Session("LogName") = survey.LogName

			If Not handler.IsAccessAllowed(DirectCast(Session("eclUser"), User).EmployeeID, survey) Then
				DisplayAccessDeniedMessage()
			Else
				If handler.IsSurveyCompleted(survey) Then
					DisplayCompletedMsg()
				ElseIf handler.IsSurveyInactive(survey) Then
					DisplayInactiveMsg()
				Else
					Session("AccessAllowed") = True
					BindSurveyQuestions(survey)
				End If
			End If
		End If
    End Sub

    Private Sub BindSurveyQuestions(survey As Survey)
        MySurveyLogLinkButton.Text = survey.LogName

		' Currently, the same number of questions on the page are added at design time, these questions all have the following controls:
		' Label for the RadioButtonList
		' RadioButtonList
		' Label for the TextBox
		' TextBox.

		' Populate questions' label on the page with the values stored in database
		' Bind radio button list to the values stored in database
		Dim count = 0
		For Each q As Question In survey.Questions
			' labels
			count = count + 1
			Dim questionLabel As Label = QuestionsPanel.FindControl("Question" & q.ID & "Label")
			Dim questionTextBoxLabel As Label = QuestionsPanel.FindControl("Question" & q.ID & "TextBoxLabel")
			Dim question As Question = handler.GetQuestion(survey, q.ID)
			questionLabel.Text = count & ". " & question.QuestionLabel
			If (questionTextBoxLabel IsNot Nothing) Then
				questionTextBoxLabel.Text = question.TextBoxLabel
			End If

			' radiobuttons
			Dim radioButtonList As RadioButtonList = QuestionsPanel.FindControl("Question" & q.ID & "RadioButtonList")
			radioButtonList.DataSource = question.SingleChoices
			radioButtonList.DataTextField = "Text"
			radioButtonList.DataValueField = "Value"
			radioButtonList.DataBind()
		Next

		' Either hot topic or pilot site question (#6)
		If (survey.HasHotTopic) Then
			HotTopicPanel.Visible = True
			PilotSitePanel.Visible = False
		ElseIf (survey.HasPilot) Then
			PilotSitePanel.Visible = True
			HotTopicPanel.Visible = False
		End If

		' Additional comment textbox
		CommentTextBoxLabel.Text = (count + 1) & ". " & CommentTextBoxLabel.Text

		ViewState(ViewStateSurvey) = survey
    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        If Page.IsValid Then
			Threading.Thread.Sleep(1000)

			survey = ViewState(ViewStateSurvey)
			' Gets answers entered on the page
			For Each question As Question In survey.Questions
				Dim tempSingleChoiceQ As RadioButtonList = QuestionsPanel.FindControl("Question" & question.ID & "RadioButtonList")
				Dim tempMultiLineQ As TextBox = QuestionsPanel.FindControl("Question" & question.ID & "TextBox")

				question.Answer = New Answer()
				question.Answer.QuestionID = question.ID
				question.Answer.SingleChoice = tempSingleChoiceQ.SelectedValue

				If (tempMultiLineQ IsNot Nothing) Then
					' Truncate to max length (4000)
					question.Answer.MultiLineText = StringUtils.Truncate(Server.HtmlEncode(tempMultiLineQ.Text), CommentMaxLength)
				End If
			Next

			' Truncate to max length (4000)
			survey.Comment = StringUtils.Truncate(Server.HtmlEncode(CommentTextBox.Text), CommentMaxLength)

            ' Save to database
            handler.SaveSurvey(survey)
            ' Display success msg 
            Session("Submitted") = "Success"
            DisplaySuccessMsg()
        End If
    End Sub

    Private Sub DisplaySuccessMsg()
        QuestionsPanel.Controls.Clear()
        SuccessMsgLabel.Text = Resources.LocalizedText.MySurvey_SaveSuccessMsg
    End Sub

    Private Sub DisplayCompletedMsg()
        QuestionsPanel.Controls.Clear()
        SuccessMsgLabel.Text = Resources.LocalizedText.MySurvey_AlreadyCompletedMsg
    End Sub

    Private Sub DisplayInactiveMsg()
        QuestionsPanel.Controls.Clear()
        SuccessMsgLabel.Text = Resources.LocalizedText.MySurvey_ExpiredMsg
    End Sub

    Private Sub DisplayAccessDeniedMessage()
        QuestionsPanel.Controls.Clear()
        AccessDeniedMsgLabel.Text = Resources.LocalizedText.MySurvey_AccessDeniedMsg
    End Sub
End Class