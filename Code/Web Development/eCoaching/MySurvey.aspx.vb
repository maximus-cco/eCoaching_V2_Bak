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
        For i As Integer = 1 To survey.Questions.Count
            ' labels
            Dim questionLabel As Label = QuestionsPanel.FindControl("Question" & i & "Label")
            Dim questionTextBoxLabel As Label = QuestionsPanel.FindControl("Question" & i & "TextBoxLabel")
            Dim question As Question = handler.GetQuestion(survey, i)
            questionLabel.Text = i & ". " & question.QuestionLabel
            questionTextBoxLabel.Text = question.TextBoxLabel

            ' radiobuttons
            Dim radioButtonList As RadioButtonList = QuestionsPanel.FindControl("Question" & i & "RadioButtonList")
            radioButtonList.DataSource = question.SingleChoices
            radioButtonList.DataTextField = "Text"
            radioButtonList.DataValueField = "Value"
            radioButtonList.DataBind()
            radioButtonList.SelectedIndex = 0
        Next

        If (handler.ShowHotTopic(survey)) Then
            HotTopicPanel.Visible = True
        End If

        CommentTextBoxLabel.Text = (survey.Questions.Count + 1) & ". " & CommentTextBoxLabel.Text

        ViewState(ViewStateSurvey) = survey
    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        If Page.IsValid Then

            Threading.Thread.Sleep(10000)

            survey = ViewState(ViewStateSurvey)
            ' Gets answers entered on the page
            For i As Integer = 1 To survey.Questions.Count
                Dim question As Question = handler.GetQuestion(survey, i)
                Dim tempSingleChoiceQ As RadioButtonList = QuestionsPanel.FindControl("Question" & i & "RadioButtonList")
                Dim tempMultiLineQ As TextBox = QuestionsPanel.FindControl("Question" & i & "TextBox")

                question.Answer = New Answer()
                question.Answer.QuestionID = question.ID
                question.Answer.SingleChoice = tempSingleChoiceQ.SelectedValue

                ' Truncate to max length (4000)
                question.Answer.MultiLineText = StringUtils.Truncate(Server.HtmlEncode(tempMultiLineQ.Text), CommentMaxLength)
            Next
            ' Truncate to max length (4000)
            survey.Comment = StringUtils.Truncate(Server.HtmlEncode(CommentTextBox.Text), CommentMaxLength)

            ' Save to database
            'handler.SaveSurvey(survey)
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

    Private Sub DisplayAccessDeniedMessage()
        QuestionsPanel.Controls.Clear()
        AccessDeniedMsgLabel.Text = Resources.LocalizedText.MySurvey_AccessDeniedMsg
    End Sub
End Class