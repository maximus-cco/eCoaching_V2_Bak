﻿Public Class MySurveyHandler

    Const COMPLETED As String = "COMPLETED"
    Const INACTIVE As String = "INACTIVE"

    Private mySurveyDBAccess As MySurveyDBAccess

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub New()
        mySurveyDBAccess = New MySurveyDBAccess()
    End Sub

    Public Function IsAccessAllowed(userEmployeeID As String, survey As Survey) As Boolean
        Return UCase(StringUtils.GetSafeString(userEmployeeID)) = UCase(StringUtils.GetSafeString(survey.EmployeeID))
    End Function

    Public Function IsSurveyCompleted(survey As Survey) As Boolean
        Return UCase(StringUtils.GetSafeString(survey.Status)) = COMPLETED
    End Function

    Public Function IsSurveyInactive(survey As Survey) As Boolean
        Return UCase(StringUtils.GetSafeString(survey.Status)) = INACTIVE
    End Function

	''' <summary>
	''' 
	''' </summary>
	''' <returns></returns>
	''' <remarks></remarks>
	Public Function GetSurvey(surveyID As Integer) As Survey
        Return mySurveyDBAccess.GetSurvey(surveyID)
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns>true if success; false otherwise</returns>
    ''' <remarks></remarks>
    Public Function SaveSurvey(survey As Survey) As Boolean
        Return mySurveyDBAccess.SaveSurvey(survey)
    End Function

	Public Function GetQuestion(survey As Survey, questionId As Integer) As Question
		Dim questions As List(Of Question) = survey.Questions
		Dim query = From question In questions.AsEnumerable()
					Where question.ID = questionId
					Select question
		Return query(0)
	End Function
End Class

