Imports System
Imports System.Configuration
Imports System.Web.UI.WebControls
Imports AjaxControlToolkit
Imports System.Data.SqlClient

Public Class view4
    Inherits System.Web.UI.Page
    Dim lan As String = LCase(User.Identity.Name) 'boulsh
    Dim domain As String
    Dim TodaysDate As String = DateTime.Today.ToShortDateString()
    Dim backDate As String = DateAdd("D", -548, TodaysDate).ToShortDateString()

    Dim counter As Integer



    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        Select Case True


            Case (InStr(1, lan, "vngt\", 1) > 0)
                lan = (Replace(lan, "vngt\", ""))
                domain = "LDAP://dc=vangent,dc=local"
            Case (InStr(1, lan, "ad\", 1) > 0)
                lan = (Replace(lan, "ad\", ""))
                domain = "LDAP://dc=ad,dc=local"

            Case Else

                Response.Redirect("error.aspx")

        End Select






        SqlDataSource2.SelectParameters("strUserin").DefaultValue = lan

        SqlDataSource2.DataBind()
        GridView3.DataBind()

      

        Dim subString As String


        Try

            subString = (CType(GridView3.Rows(0).FindControl("Job"), Label).Text)
        Catch ex As Exception
            subString = ""

            Response.Redirect("error.aspx")
        End Try



        If (Len(subString) > 0) Then

            Dim subArray As Array

            subArray = Split(subString, "$", -1, 1)

            Label6a.Text = subArray(0) 'title
        Else

            Label6a.Text = "Error"
            Response.Redirect("error.aspx")

        End If




        SqlDataSource5.SelectParameters("strUserin").DefaultValue = lan
        SqlDataSource5.DataBind()

        Select Case True 'Label6a.Text


            Case (InStr(1, Label6a.Text, "40", 1) > 0), (InStr(1, Label6a.Text, "50", 1) > 0), (InStr(1, Label6a.Text, "60", 1) > 0), (InStr(1, Label6a.Text, "70", 1) > 0), (InStr(1, Label6a.Text, "WISO", 1) > 0), (InStr(1, Label6a.Text, "WSTE", 1) > 0), (InStr(1, Label6a.Text, "WSQE", 1) > 0), (InStr(1, Label6a.Text, "WACQ", 1) > 0), (InStr(1, Label6a.Text, "WPPM", 1) > 0), (InStr(1, Label6a.Text, "WPSM", 1) > 0), (InStr(1, Label6a.Text, "WEEX", 1) > 0), (InStr(1, Label6a.Text, "WISY", 1) > 0), (InStr(1, Label6a.Text, "WPWL51", 1) > 0), (InStr(1, Label6a.Text, "WHER", 1) > 0), (InStr(1, Label6a.Text, "WHHR", 1) > 0)
                '"WACS40", "WMPR40", "WPPT40", "WSQA40", "WTTR40", "WTTR50", "WPSM11", "WPSM12", "WPSM13", "WPSM14", "WPSM15", "WACS50", "WACS60", "WFFA60", "WPOP50", "WPOP60", "WPPM50", "WPPM60", "WPPT50", "WPPT60", "WSQA50", "WSQA70", "WPPM70", "WPPM80", "WEEX90", "WEEX91", "WISO11", "WISO13", "WISO14", "WSTE13", "WSTE14", "WSQE14", "WSQE15", "WBCO50", "WEEX"

                '' If (Panel3.Visible = False) Then

                '    GridView7.Visible = False
                ''Panel3.Visible = True
                ''Else
                '   GridView7.Visible = True

                ''End If


                ''Panel3.Visible = True

                Label26.Text = "Welcome to the Historical Reporting Dashboard"

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

                SqlDataSource8.SelectParameters("strjobcode").DefaultValue = Label6a.Text
             
              
            Case Else
                Response.Redirect("error.aspx")
        End Select

        ' If (ddSite.SelectedValue = "%") Then

        'ddCSR.DataSourceID = "SqlDataSource6"
        'Else
        'ddCSR.DataSourceID = "SqlDataSource15"


        'End If


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


    'Protected Function oLink(ByVal destination As String, ByVal indicator As String) As String
    Protected Function oLink(ByVal indicator As String) As String

        If (indicator = "Warning") Then

            Return ("review3.aspx?id={0}")
        Else
            Return ("review2.aspx?id={0}")

        End If


    End Function

  


    Protected Sub GridView7_Bound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView7.RowDataBound

        If e.Row.RowType = DataControlRowType.Footer Then
            counter = GetTotalRows(SqlDataSource8)
            DirectCast(e.Row.FindControl("lblTotal"), Label).Text = String.Format("{0} records", counter.ToString)
        End If


        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim id As Label = e.Row.FindControl("Label1")

            Dim mainReason As DataList = e.Row.FindControl("Dlist1")
            Dim subReason As DataList = e.Row.FindControl("Dlist2")
            Dim Value As DataList = e.Row.FindControl("Dlist3")

            'MsgBox(id.Text)
            If (Len(id.Text) > 0) Then

                SqlDataSource10.SelectParameters("strFormIDin").DefaultValue = id.Text

                mainReason.DataSource = SqlDataSource10
                mainReason.DataBind()

                subReason.DataSource = SqlDataSource10
                subReason.DataBind()

                Value.DataSource = SqlDataSource10
                Value.DataBind()
            End If



        End If



    End Sub



    Protected Function GetTotalRows(ByVal datasource) As Int32
        Dim dv As DataView = CType(datasource.Select(DataSourceSelectArguments.Empty), DataView)
        Return dv.Count
    End Function

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button1.Click

        If (Date1.Text = "") Then
            Date1.Text = backDate '"01/01/2011"


        End If

        If (Date2.Text = "") Then


            Date2.Text = TodaysDate


        End If
        GridView7.Visible = True
        GridView7.DataBind()

    End Sub


    Protected Sub ddSite1_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddSite.SelectedIndexChanged

        If ddSite.SelectedValue = "%" Then

            ddCSR.DataSourceID = "SqlDataSource6"
            ddSUP.DataSourceID = "SqlDataSource7"
            ddMGR.DataSourceID = "SqlDataSource9"
        Else
            ddCSR.DataSourceID = "SqlDataSource15"
            ddSUP.DataSourceID = "SqlDataSource12"
            ddMGR.DataSourceID = "SqlDataSource3"
        End If


        'ddCSR5.Items.Clear()
        'ddCSR5.Items.Add(New ListItem("All CSRs", "%"))

        'ddSup.Items.Clear()
        'ddSup.Items.Add(New ListItem("All Supervisors", "%"))


        'ddMgr.Items.Clear()
        'ddMgr.Items.Add(New ListItem("All Managers", "%"))

    End Sub



    Protected Sub SqlDataSource1_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource1.Selecting
        'EC.sp_Select_Statuses_For_Dashboard

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource2_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource2.Selecting
        'EC.sp_Whoami

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource3_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource3.Selecting
        'EC.sp_SelectFrom_Coaching_LogDistinctMGRCompleted 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource4_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource4.Selecting
        'EC.sp_Select_Sites_For_Dashboard

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource5_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource5.Selecting
        'EC.sp_Select_Sources_For_Dashboard

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource6_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource6.Selecting
        'EC.sp_SelectFrom_Coaching_LogDistinctCSRCompleted2 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource7_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource7.Selecting
        'EC.sp_SelectFrom_Coaching_LogDistinctSUPCompleted2

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource8_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource8.Selecting
        'EC.sp_SelectFrom_Coaching_Log_HistoricalSUP

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource9_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource9.Selecting
        'EC.sp_SelectFrom_Coaching_LogDistinctMGRCompleted2 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource10_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource10.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource12_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource12.Selecting
        'EC.sp_SelectFrom_Coaching_LogDistinctSUPCompleted 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource13_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource13.Selecting
        'EC.sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource15_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource15.Selecting
        'EC.sp_SelectFrom_Coaching_LogDistinctCSRCompleted

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub












End Class
