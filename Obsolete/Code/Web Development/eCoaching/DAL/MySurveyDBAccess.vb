Imports System.Data.SqlClient

Public Class MySurveyDBAccess

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetSurvey(surveyID As Integer) As Survey
        Dim survey As Survey = GetSurveyInfo(surveyID)
        Dim allSingleChoices As List(Of SingleChoice) = GetSingleChoices()

        survey.Questions = GetSurveyQuestions(surveyID)
        For Each question In survey.Questions
            question.SingleChoices = GetSingleChoices(question.ID, allSingleChoices)
        Next

        Return survey
    End Function

    Public Function GetSurveyInfo(surveyID As Integer) As Survey
        Dim survey As New Survey(surveyID)
		Dim parameters() As SqlParameter = New SqlParameter() _
		{
			New SqlParameter("@intSurveyID", surveyID)
		}
		Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_Select_SurveyDetails_By_SurveyID", CommandType.StoredProcedure, parameters)
			Dim row As DataRow = dataTable.Rows(0)
			survey.EmployeeID = row("EmpID")
			survey.LogName = row("FormName")
			survey.Status = row("Status")
			survey.HasHotTopic = row("hasHotTopic")
			survey.HasPilot = row("hasPilot")
		End Using

		Return survey
    End Function

    Public Function GetSurveyQuestions(surveyID As Integer) As ICollection(Of Question)
        Dim questions As ICollection(Of Question) = New List(Of Question)
        Dim parameters() As SqlParameter = New SqlParameter() _
        {
            New SqlParameter("@intSurveyID", surveyID)
        }
        Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_Select_Questions_For_Survey", CommandType.StoredProcedure, parameters)
            For Each row In dataTable.Rows
                Dim question = New Question()
                question.ID = row("QuestionID")
                question.DisplayOrder = row("DisplayOrder")

				Dim description As String = row("Description")
				' Element 0 is the question text; element 1 is the label text for this question's textbox
				Dim temp = (From q In description.Split("|") Select q).ToList()
				question.QuestionLabel = temp.ElementAt(0).Trim()
				question.TextBoxLabel = temp.ElementAt(1).Trim()

				question.SurveyID = surveyID

				questions.Add(question)
			Next
        End Using

        Return questions
    End Function

    Public Function GetSingleChoices() As ICollection(Of SingleChoice)
        Dim singleChoices As ICollection(Of SingleChoice) = New List(Of SingleChoice)

        Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_Select_Responses_By_Question", CommandType.StoredProcedure, Nothing)
            For Each row In dataTable.Rows
                Dim choice = New SingleChoice()
                choice.QuestionID = row("QuestionID")
                choice.Value = row("ResponseID")
                choice.Text = row("ResponseValue")

                singleChoices.Add(choice)
            Next
        End Using

        Return singleChoices
    End Function

    Public Function GetSingleChoices(questionID As Integer, allSingleChoices As List(Of SingleChoice)) As ICollection(Of SingleChoice)
        Return (From choice As SingleChoice In allSingleChoices
                Where choice.QuestionID = questionID
                Select choice).ToList
    End Function

    Public Function SaveSurvey(survey As Survey) As Boolean
        Dim retVal As Boolean = False
        Dim connection As SqlConnection = Nothing
        Dim command As SqlCommand = Nothing

        Try
            connection = New SqlConnection(DBUtility.connectionString)

            command = New SqlCommand("EC.sp_Update_Survey_Response", connection)
            command.CommandType = CommandType.StoredProcedure

            Dim tableSRParam As SqlParameter = command.Parameters.AddWithValue("@tableSR", GetSurveyResponseDataTable(survey))
            tableSRParam.SqlDbType = SqlDbType.Structured
            tableSRParam.TypeName = "EC.ResponsesTableType"

            command.Parameters.AddWithValue("@intSurveyID", survey.ID)
            command.Parameters.AddWithValue("@nvcUserComments", survey.Comment)

            ' Output parameters
            Dim retCodeParam As SqlParameter = command.Parameters.Add("@returnCode", SqlDbType.Int)
            retCodeParam.Direction = ParameterDirection.Output
            Dim retMsgParam As SqlParameter = command.Parameters.Add("@returnMessage", SqlDbType.VarChar, 100)
            retMsgParam.Direction = ParameterDirection.Output

            connection.Open()
            command.ExecuteNonQuery()

            retVal = If(command.Parameters("@returnCode").Value = 0, True, False)
            Dim retMsg As String = command.Parameters("@returnMessage").Value

            If Not retVal Then
                ' TODO: Log retMsg and retVal here
            End If
        Catch ex As Exception
            ' TODO: Log ex here
            Dim errorMsg = ex.Message
            Throw ex
        Finally
            If connection IsNot Nothing AndAlso connection.State = ConnectionState.Open Then
                connection.Close()
            End If
        End Try

        Return retVal
    End Function

    Private Function GetSurveyResponseDataTable(survey As Survey) As DataTable
        Dim dataTable As DataTable = New DataTable()
        dataTable.Columns.Add("QuestionID", GetType(System.Int32))
        dataTable.Columns.Add("ResponseID", GetType(System.Int32))
        dataTable.Columns.Add("Comments", GetType(System.String))

        Dim questions As IList(Of Question) = survey.Questions
        For Each question In questions
            Dim answer As Answer = question.Answer
            Dim singleChoiceSelected As String = answer.SingleChoice

            dataTable.Rows().Add(question.ID,
                          question.Answer.SingleChoice,
                          answer.MultiLineText)
        Next

        Return dataTable
    End Function

	''' <summary>
	''' 
	''' </summary>
	''' <returns></returns>
	''' <remarks></remarks>
	Private Function GetAsterisk()
        Dim asterisk = New Label()
        asterisk.Text = "*"

        Return asterisk
    End Function

    Private Function GetQuestionLabel(description As String)
        Return (From question In description.Split("|") Select question).ToList().ElementAt(0)
    End Function



    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="controlID"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function GetQuestionTextBoxLabel(controlID As String)
        Dim lbl = New Label()
        lbl.Text = "Question 1 Text Box"
        lbl.ID = controlID

        Return lbl
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="controlID"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function GetQuestionTextBox(controlID As String)
        Dim textBox = New TextBox()
        textBox.ID = controlID

        Return textBox
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="controlID"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function GetRadioButtonList(controlID As String)
        Dim rbl = New RadioButtonList()

        rbl.Items.AddRange(
            New ListItem() {
                New ListItem("A", 1),
                New ListItem("B", 2),
                New ListItem("C", 3)
            }
        )

        rbl.ID = controlID
        Return rbl
    End Function
End Class
