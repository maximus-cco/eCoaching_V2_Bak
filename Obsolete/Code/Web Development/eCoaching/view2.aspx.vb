﻿Imports System
Imports System.Configuration
Imports System.Web.UI.WebControls
Imports AjaxControlToolkit


Public Class view2
    Inherits BasePage

    Dim domain As String
    Dim strLevel As Label
    Dim TodaysDate As String = DateTime.Today.ToShortDateString()
    Dim backDate As String = DateAdd("D", -30, TodaysDate).ToShortDateString()

    Dim filter1 As DropDownList
    Dim counter As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        HandlePageRequest()
    End Sub

    Public Sub HandlePageRequest()
        Dim eclUser As User = Session("eclUser")

        '  sp_check_agentrole
        SqlDataSource41.SelectParameters("nvcLanID").DefaultValue = eclUser.LanID
        SqlDataSource41.SelectParameters("nvcRole").DefaultValue = "SRMGR"
        GridView12.DataBind()

        ' Title
        Label6a.Text = If(String.IsNullOrEmpty(eclUser.JobCode), String.Empty, eclUser.JobCode.Trim().ToUpper())
        Dim jobCode = Label6a.Text
        Select Case True ' jobCode
            ' WACS01, WACS02, WACS03
            Case (InStr(1, jobCode, "WACS0", 1) > 0)
                Panel2.Visible = True
                Label26.Text = "Welcome to the Employee Dashboard"
                SqlDataSource2.SelectParameters("strCSRin").DefaultValue = eclUser.LanID
                SqlDataSource1.SelectParameters("strCSRin").DefaultValue = eclUser.LanID

            ' WACS50, WACS60, WBCO50, WSQA50, WTTR50, WPOP50, WPOP60, 
            ' WPPM50, WPPM60, WPPM70, WPPT50, WPPT60, WISO11, WISO13, WISO14, WSTE13, WSTE14
            ' WISA50, WISA60, WISA70
            Case InStr(1, jobCode, "50", 1) > 0,
                 InStr(1, jobCode, "60", 1) > 0,
                 InStr(1, jobCode, "70", 1) > 0,
                 InStr(1, jobCode, "WISO", 1) > 0,
                 InStr(1, jobCode, "WSTE", 1) > 0,
                 InStr(1, jobCode, "WEEX", 1) > 0,
                 InStr(1, jobCode, "WISY", 1) > 0,
                 InStr(1, jobCode, "WPWL51", 1) > 0,
                 jobCode = "WPPM80" ' Is this true?

                Panel3.Visible = True
                Label26.Text = "Welcome to the Manager Dashboard"
                SqlDataSource25.SelectParameters("strUserin").DefaultValue = eclUser.LanID
                SqlDataSource26.SelectParameters("strUserin").DefaultValue = eclUser.LanID
                SqlDataSource4.SelectParameters("strCSRMGRin").DefaultValue = eclUser.LanID
                SqlDataSource5.SelectParameters("strCSRMGRin").DefaultValue = eclUser.LanID
                SqlDataSource8.SelectParameters("strCSRMGRin").DefaultValue = eclUser.LanID
                SqlDataSource13.SelectParameters("strCSRMGRin").DefaultValue = eclUser.LanID
                SqlDataSource14.SelectParameters("strCSRMGRin").DefaultValue = eclUser.LanID
                SqlDataSource15.SelectParameters("strCSRMGRin").DefaultValue = eclUser.LanID
                SqlDataSource16.SelectParameters("strCSRMGRin").DefaultValue = eclUser.LanID
                SqlDataSource20.SelectParameters("strCSRMGRin").DefaultValue = eclUser.LanID
                SqlDataSource21.SelectParameters("strCSRMGRin").DefaultValue = eclUser.LanID
                SqlDataSource18.SelectParameters("strCSRin").DefaultValue = eclUser.LanID
                If (jobCode = "WACS50" OrElse jobCode = "WACS60") Then
                    Panel5.Visible = True
                    SqlDataSource23.SelectParameters("strCSRMGRin").DefaultValue = eclUser.LanID
                    If (Date5.Text = "") Then
                        SqlDataSource23.SelectParameters("strSDatein").DefaultValue = backDate
                        Date5.Text = backDate
                    Else
                        SqlDataSource23.SelectParameters("strSDatein").DefaultValue = Date5.Text
                    End If
                    If (Date6.Text = "") Then
                        SqlDataSource23.SelectParameters("strEDatein").DefaultValue = TodaysDate
                        Date6.Text = TodaysDate
                    Else
                        SqlDataSource23.SelectParameters("strEDatein").DefaultValue = Date6.Text
                    End If
                End If

                CalendarExtender1.EndDate = TodaysDate
                CalendarExtender2.EndDate = TodaysDate
                If (Date1.Text = "") Then
                    SqlDataSource8.SelectParameters("strSDatein").DefaultValue = backDate '"01/01/2011" 'Date1.Text
                    Date1.Text = backDate
                Else
                    SqlDataSource8.SelectParameters("strSDatein").DefaultValue = Date1.Text
                End If

                If (Date2.Text = "") Then
                    SqlDataSource8.SelectParameters("strEDatein").DefaultValue = TodaysDate
                    Date2.Text = TodaysDate
                Else
                    SqlDataSource8.SelectParameters("strEDatein").DefaultValue = Date2.Text
                End If
                ' Case (InStr(1, Label6a.Text, "WSQE", 1) > 0), (InStr(1, Label6a.Text, "WACQ", 1) > 0) '"WTTR12", "WTTR40", "WTTR50", "WACQ12", "WACQ13", "WSQA40", "WSQA70", "WSQE14", "WSQE15"

            Case Else
                Label26.Text = "Welcome to the eCL Dashboard"

                If (InStr(1, jobCode, "40", 1) > 0 OrElse InStr(1, jobCode, "WTTI", 1) > 0) Then
                    Label26.Text = "Welcome to the Supervisor Dashboard"
                End If

                Panel1.Visible = True
                SqlDataSource28.SelectParameters("strUserin").DefaultValue = eclUser.LanID
                SqlDataSource27.SelectParameters("strUserin").DefaultValue = eclUser.LanID
                SqlDataSource3.SelectParameters("strCSRSUPin").DefaultValue = eclUser.LanID
                SqlDataSource6.SelectParameters("strCSRSUPin").DefaultValue = eclUser.LanID
                SqlDataSource7.SelectParameters("strCSRSUPin").DefaultValue = eclUser.LanID
                SqlDataSource10.SelectParameters("strCSRSUPin").DefaultValue = eclUser.LanID
                SqlDataSource11.SelectParameters("strCSRSUPin").DefaultValue = eclUser.LanID
                SqlDataSource17.SelectParameters("strCSRin").DefaultValue = eclUser.LanID
                SqlDataSource9.SelectParameters("strCSRSUPin").DefaultValue = eclUser.LanID

                CalendarExtender3.EndDate = TodaysDate
                CalendarExtender4.EndDate = TodaysDate
                If (Date3.Text = "") Then
                    SqlDataSource9.SelectParameters("strSDatein").DefaultValue = backDate '"01/01/2011" 'Date1.Text
                    Date3.Text = backDate
                Else
                    SqlDataSource9.SelectParameters("strSDatein").DefaultValue = Date3.Text
                End If

                If (Date4.Text = "") Then
                    SqlDataSource9.SelectParameters("strEDatein").DefaultValue = TodaysDate
                    Date4.Text = TodaysDate
                Else
                    SqlDataSource9.SelectParameters("strEDatein").DefaultValue = Date4.Text
                End If

                DisplayMyTeamWarnings(eclUser.LanID)
        End Select

        If (Label241.Text > 0) Then ' Senior Manager
            Panel6.Visible = True
            SqlDataSource44.SelectParameters("strUserin").DefaultValue = eclUser.LanID
            SqlDataSource43.SelectParameters("strCSRSrMGRin").DefaultValue = eclUser.LanID
            SqlDataSource47.SelectParameters("strCSRSrMGRin").DefaultValue = eclUser.LanID
            SqlDataSource48.SelectParameters("strCSRSrMGRin").DefaultValue = eclUser.LanID
            SqlDataSource45.SelectParameters("strEMPSRMGRin").DefaultValue = eclUser.LanID
            If (Date11.Text = "") Then
                SqlDataSource45.SelectParameters("strSDatein").DefaultValue = backDate '"01/01/2011" 'Date1.Text
                Date11.Text = backDate
            Else
                SqlDataSource45.SelectParameters("strSDatein").DefaultValue = Date11.Text
            End If
            If (Date12.Text = "") Then
                SqlDataSource45.SelectParameters("strEDatein").DefaultValue = TodaysDate
                Date12.Text = TodaysDate
            Else
                SqlDataSource45.SelectParameters("strEDatein").DefaultValue = Date12.Text
            End If

            SqlDataSource50.SelectParameters("strEMPSRMGRin").DefaultValue = eclUser.LanID
            If (Date9.Text = "") Then
                SqlDataSource50.SelectParameters("strSDatein").DefaultValue = backDate '"01/01/2011" 'Date1.Text
                Date9.Text = backDate
            Else
                SqlDataSource50.SelectParameters("strSDatein").DefaultValue = Date9.Text
            End If

            If (Date10.Text = "") Then
                SqlDataSource50.SelectParameters("strEDatein").DefaultValue = TodaysDate
                Date10.Text = TodaysDate
            Else
                SqlDataSource50.SelectParameters("strEDatein").DefaultValue = Date10.Text
            End If
        End If
    End Sub

    Private Sub DisplayMyTeamWarnings(userId As String)
        Panel4.Visible = True
        SqlDataSource22.SelectParameters("strCSRSUPin").DefaultValue = userId
        If (Date7.Text = "") Then
            SqlDataSource22.SelectParameters("strSDatein").DefaultValue = backDate '"01/01/2011" 'Date1.Text
            Date7.Text = backDate
        Else
            SqlDataSource22.SelectParameters("strSDatein").DefaultValue = Date7.Text
        End If

        If (Date8.Text = "") Then
            SqlDataSource22.SelectParameters("strEDatein").DefaultValue = TodaysDate
            Date8.Text = TodaysDate
        Else
            SqlDataSource22.SelectParameters("strEDatein").DefaultValue = Date8.Text
        End If
    End Sub

    Protected Sub Button3_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button3.Click


        'MsgBox("button pushed")
        If (Date7.Text = "") Then
            Date7.Text = backDate '"01/01/2011"

        End If

        If (Date8.Text = "") Then
            Date8.Text = TodaysDate

        End If

        GridView13.DataBind()
    End Sub


    Protected Sub Button4_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button4.Click


        'MsgBox("button pushed")
        If (Date5.Text = "") Then
            Date5.Text = backDate '"01/01/2011"

        End If

        If (Date6.Text = "") Then
            Date6.Text = TodaysDate

        End If

        GridView14.DataBind()
    End Sub

    Protected Sub Button5_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button5.Click
        'MsgBox("button pushed")
        If (Date9.Text = "") Then
            Date9.Text = backDate '"01/01/2011"
        End If

        If (Date10.Text = "") Then
            Date10.Text = TodaysDate
        End If

        GridView16.DataBind()
    End Sub

    Protected Sub Button6_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button6.Click
        'MsgBox("button pushed")
        If (Date11.Text = "") Then
            Date11.Text = backDate '"01/01/2011"
        End If

        If (Date12.Text = "") Then
            Date12.Text = TodaysDate

        End If

        GridView15.DataBind()
    End Sub


    Protected Function newDisplay(ByVal indicator As DateTime) As String
        If (DateDiff("D", indicator, TodaysDate) < 1) Then
            Return ("&nbsp;&nbsp;New!&nbsp;")
        Else
            Return ("")
        End If
    End Function

    Protected Function newDisplay2(ByVal indicator As DateTime) As String

        If (DateDiff("D", indicator, TodaysDate) < 1) Then

            Return ("True")
        Else
            Return ("False")

        End If


    End Function



    Protected Sub GridView3_Bound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView3.RowDataBound

        If e.Row.RowType = DataControlRowType.Footer Then
            counter = GetTotalRows(SqlDataSource3)
            DirectCast(e.Row.FindControl("lblTotal"), Label).Text = String.Format("{0} records", counter.ToString)
        End If
    End Sub

    Protected Sub GridView5_Bound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView5.RowDataBound

        If e.Row.RowType = DataControlRowType.Footer Then
            counter = GetTotalRows(SqlDataSource5)
            DirectCast(e.Row.FindControl("lblTotal"), Label).Text = String.Format("{0} records", counter.ToString)
        End If
    End Sub


    Protected Sub GridView7_Bound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView7.RowDataBound

        If e.Row.RowType = DataControlRowType.Footer Then
            counter = GetTotalRows(SqlDataSource8)
            DirectCast(e.Row.FindControl("lblTotal"), Label).Text = String.Format("{0} records", counter.ToString)
        End If
    End Sub

    Protected Sub GridView8_Bound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView8.RowDataBound

        If e.Row.RowType = DataControlRowType.Footer Then
            counter = GetTotalRows(SqlDataSource9)
            DirectCast(e.Row.FindControl("lblTotal"), Label).Text = String.Format("{0} records", counter.ToString)
        End If
    End Sub


    Protected Sub GridView9_Bound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView9.RowDataBound

        If e.Row.RowType = DataControlRowType.Footer Then
            counter = GetTotalRows(SqlDataSource4)
            DirectCast(e.Row.FindControl("lblTotal"), Label).Text = String.Format("{0} records", counter.ToString)
        End If
    End Sub

    Protected Sub GridView15_Bound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView15.RowDataBound

        If e.Row.RowType = DataControlRowType.Footer Then
            counter = GetTotalRows(SqlDataSource45)
            DirectCast(e.Row.FindControl("lblTotal"), Label).Text = String.Format("{0} records", counter.ToString)
        End If
    End Sub





    Protected Function GetTotalRows(ByVal datasource) As Int32
        Dim dv As DataView = CType(datasource.Select(DataSourceSelectArguments.Empty), DataView)
        Return dv.Count
    End Function

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button1.Click
        'MsgBox("button pushed")
        If (Date1.Text = "") Then
            'MsgBox("hello2")
            '            SqlDataSource8.SelectParameters("strSDatein").DefaultValue = "01/01/2011" 'Date1.Text
            Date1.Text = backDate '"01/01/2011"

            'Else
            '  MsgBox("hello2")
            '  MsgBox(Date1.Text)
            '   SqlDataSource8.SelectParameters("strSDatein").DefaultValue = Date1.Text


        End If

        If (Date2.Text = "") Then

            '            SqlDataSource8.SelectParameters("strEDatein").DefaultValue = TodaysDate
            Date2.Text = TodaysDate

            '       Else
            '          SqlDataSource8.SelectParameters("strEDatein").DefaultValue = Date2.Text

        End If

        GridView7.DataBind()

    End Sub


    Protected Sub Button2_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button2.Click


        'MsgBox("button pushed")
        If (Date3.Text = "") Then
            Date3.Text = backDate '"01/01/2011"

        End If

        If (Date4.Text = "") Then
            Date4.Text = TodaysDate

        End If

        GridView8.DataBind()
    End Sub


    Protected Sub SRMGR_Selected(ByVal sender As Object, ByVal e As SqlDataSourceStatusEventArgs) Handles SqlDataSource41.Selected
        'EC.sp_Check_AgentRole
        'MsgBox("param=" & e.Command.Parameters("nvcLanID").Value)
        Label241.Text = e.Command.Parameters("@Indirect@return_value").Value
        'Dim spot3
        'For Each param In e.Command.Parameters

        ' Extract the name and value of the parameter.
        'spot3 = param.ParameterName & " - " & param.Value.ToString()
        'MsgBox(spot3)
        'Next

        'MsgBox("1-" & Label241.Text)
    End Sub


    Protected Sub SqlDataSource1_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource1.Selecting
        'EC.sp_SelectFrom_Coaching_Log_CSRCompleted  

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource2_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource2.Selecting
        'EC.sp_SelectFrom_Coaching_Log_CSRPending  

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource3_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource3.Selecting
        'EC.sp_SelectFrom_Coaching_Log_SUPPending

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource4_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource4.Selecting
        'EC.sp_SelectFrom_Coaching_Log_MGRPending  

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource5_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource5.Selecting
        'EC.sp_SelectFrom_Coaching_Log_MGRCSRPending  

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource6_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource6.Selecting
        'EC.sp_SelectFrom_Coaching_Log_SUPCSRPending  

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub





    Protected Sub SqlDataSource7_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource7.Selecting
        'EC.sp_SelectFrom_Coaching_LogSupDistinctMGRTeamCompleted  

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource8_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource8.Selecting
        'EC.sp_SelectFrom_Coaching_Log_MGRCSRCompleted  

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource9_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource9.Selecting
        'EC.sp_SelectFrom_Coaching_Log_SUPCSRCompleted  

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource10_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource10.Selecting
        'EC.sp_SelectFrom_Coaching_LogSupDistinctCSRTeam 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource11_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource11.Selecting
        'EC.sp_SelectFrom_Coaching_LogSupDistinctCSRTeamCompleted  

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource13_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource13.Selecting

        'EC.sp_SelectFrom_Coaching_LogMgrDistinctCSR  

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout

    End Sub



    Protected Sub SqlDataSource14_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource14.Selecting
        'EC.sp_SelectFrom_Coaching_LogMGRDistinctSUP  

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource15_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource15.Selecting
        'EC.sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted   

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub




    Protected Sub SqlDataSource16_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource16.Selecting
        'EC.sp_SelectFrom_Coaching_LogMgrDistinctSUPTeamCompleted  

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub
    Protected Sub SqlDataSource17_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource17.Selecting
        'EC.sp_SelectFrom_Coaching_Log_CSRCompleted  

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub




    Protected Sub SqlDataSource18_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource18.Selecting
        'EC.sp_SelectFrom_Coaching_Log_CSRCompleted  

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource19_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource19.Selecting
        'EC.sp_SelectReviewFrom_Warning_Log_Reasons  

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource20_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource20.Selecting
        'EC.sp_SelectFrom_Coaching_LogMgrDistinctCSRTeam 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource21_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource21.Selecting
        'EC.sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam  

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource22_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource22.Selecting
        'EC.sp_SelectFrom_Warning_Log_SUPCSRCompleted 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource23_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource23.Selecting
        'EC.sp_SelectFrom_Warning_Log_MGRCSRCompleted 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource24_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource24.Selecting
        'EC.sp_SelectReviewFrom_Warning_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource25_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource25.Selecting
        'EC.sp_Select_Sources_For_Dashboard 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource26_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource26.Selecting
        'EC.sp_Select_Sources_For_Dashboard 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource27_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource27.Selecting
        'EC.sp_Select_Sources_For_Dashboard 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource28_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource28.Selecting
        'EC.sp_Select_Sources_For_Dashboard 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource29_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource29.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource30_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource30.Selecting
        'EC.sp_Select_States_For_Dashboard 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource31_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource31.Selecting
        'EC.sp_Select_States_For_Dashboard 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource32_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource32.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource33_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource33.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource34_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource34.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource35_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource35.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource36_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource36.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource37_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource37.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource38_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource38.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource39_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource39.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource40_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource40.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource41_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource41.Selecting
        'EC.sp_Check_AgentRole 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource42_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource42.Selecting
        'EC.sp_Select_Statuses_For_Dashboard 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource43_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource43.Selecting
        'EC.sp_SelectFrom_Coaching_LogSrMgrDistinctMGRTeam 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource44_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource44.Selecting
        'EC.sp_Select_Sources_For_Dashboard 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource45_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource45.Selecting
        'EC.sp_SelectFrom_Coaching_Log_SRMGREmployee 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource46_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource46.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource47_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource47.Selecting
        'EC.sp_SelectFrom_Coaching_LogSrMgrDistinctSUPTeam 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource48_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource48.Selecting
        'EC.sp_SelectFrom_Coaching_LogSrMgrDistinctCSRTeam 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource49_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource49.Selecting
        'EC.sp_Select_States_For_Dashboard 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub
    Protected Sub SqlDataSource50_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource50.Selecting
        'EC.sp_SelectFrom_Coaching_Log_SRMGREmployeeWarning 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource51_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource51.Selecting
        'EC.sp_SelectReviewFrom_Warning_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

End Class