Imports System
Imports System.Configuration
Imports System.Web.UI.WebControls
Imports AjaxControlToolkit


Public Class view3
    Inherits BasePage

    Dim domain As String
    Dim strLevel As Label
    Dim TodaysDate = DateTime.Today.ToShortDateString()
    Dim filter1 As DropDownList
    ' Dim arcAccess = "harvan;brunB1;mcgey9;lapkca;jackky;turnna;grifpa;catopa;clutpe;mitcre;paqusa;stonsa;garns1;boulsh;jacqst;mcphvi;klicwa;findan;timmap;lemuce;stewci;ryanel;hatcki;rodrl1;morglo;thommi;esqumo;howare;dupesu;horrta;waleti;medlwa;mccoal;jakuas;slavda;orties;rodrgr;acosir;sumnlo;woodma;pezzni;amayro;medrru;pachsa;doolst;martt2;jonetr;Baezad;Gonzar;velado;castd1;barnge;pittgl;rosije;marmli;hernlu;favelu;castm4;bolina;demesa;delgba;navave;garcvi;nevavi"
    '(InStr(1, LCase(historyAccess), lan, 1) = 0)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' authentication is done in BasePage OnInit
            ' if it makes it here, it means authentication is successful
            InitializePageDisplay()
        End If
    End Sub

    Private Sub InitializePageDisplay()
        ' sp_check_AgentRole (GridView5)
        SqlDataSource14.SelectParameters("nvcLanID").DefaultValue = lan
        SqlDataSource14.SelectParameters("nvcRole").DefaultValue = "ARC"
        GridView5.DataBind()

        ' Title
        Label6a.Text = GetJobCode(Session("userInfo"))
        Select Case True 'Label6a.Text
            Case (InStr(1, Label6a.Text, "WACS0", 1) > 0)
                If (Label241.Text > 0) Then
                    Panel2.Visible = True
                    Label26.Text = "Welcome to the My Submitted Dashboard"
                    SqlDataSource1.SelectParameters("strUserin").DefaultValue = lan
                Else
                    Response.Redirect("error2.aspx")
                End If
            Case (InStr(1, Label6a.Text, "40", 1) > 0), (InStr(1, Label6a.Text, "WTTR12", 1) > 0), (InStr(1, Label6a.Text, "WTTI", 1) > 0) '"WACS40", "WMPR40", "WPPT40", "WSQA40", "WTTR40"
                Label26.Text = "Welcome to the My Submitted Dashboard"
                Panel1.Visible = True
                SqlDataSource7.SelectParameters("strUserin").DefaultValue = lan
                SqlDataSource10.SelectParameters("strCSRSUPin").DefaultValue = lan
                SqlDataSource11.SelectParameters("strCSRSUPin").DefaultValue = lan
                SqlDataSource12.SelectParameters("strCSRSUPin").DefaultValue = lan
            Case (InStr(1, Label6a.Text, "50", 1) > 0), (InStr(1, Label6a.Text, "60", 1) > 0), (InStr(1, Label6a.Text, "70", 1) > 0), (InStr(1, Label6a.Text, "WISO", 1) > 0), (InStr(1, Label6a.Text, "WSTE", 1) > 0), (InStr(1, Label6a.Text, "WPPM", 1) > 0), (InStr(1, Label6a.Text, "WPSM", 1) > 0), (InStr(1, Label6a.Text, "WEEX", 1) > 0), (InStr(1, Label6a.Text, "WISY", 1) > 0), (InStr(1, Label6a.Text, "WPWL51", 1) > 0) '"WACS50", "WACS60", "WBCO50", "WSQA50", "WTTR50", "WPOP50", "WPOP60", "WPPM50", "WPPM60", "WPPM70", "WPPT50", "WPPT60", "WISO11", "WISO13", "WISO14", "WSTE13", "WSTE14"
                Panel3.Visible = True
                Label26.Text = "Welcome to the My Submitted Dashboard"
                SqlDataSource17.SelectParameters("strUserin").DefaultValue = lan
                SqlDataSource18.SelectParameters("strCSRMGRin").DefaultValue = lan
                SqlDataSource19.SelectParameters("strCSRMGRin").DefaultValue = lan
                SqlDataSource22.SelectParameters("strCSRMGRin").DefaultValue = lan
            Case Else
                Panel4.Visible = True
                Label9.Visible = True
                Label26.Text = "Welcome to the My Submitted Dashboard"
                SqlDataSource2.SelectParameters("strUserin").DefaultValue = lan
                SqlDataSource6.SelectParameters("strUserin").DefaultValue = lan
                SqlDataSource3.SelectParameters("strCSRMGRin").DefaultValue = lan
                SqlDataSource4.SelectParameters("strCSRMGRin").DefaultValue = lan
                SqlDataSource5.SelectParameters("strCSRMGRin").DefaultValue = lan
                SqlDataSource8.SelectParameters("strCSRMGRin").DefaultValue = lan
                SqlDataSource9.SelectParameters("strCSRMGRin").DefaultValue = lan
                SqlDataSource13.SelectParameters("strCSRMGRin").DefaultValue = lan
        End Select
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



    Protected Sub GridView1_Bound(ByVal sender As Object, ByVal e As EventArgs) Handles GridView1.DataBound
  
    End Sub


    'Protected Sub GridView10_Bound(ByVal sender As Object, ByVal e As EventArgs) Handles GridView10.DataBound

    'End Sub



    Protected Sub OnRowDataBound1(ByVal sender As Object, ByVal e As GridViewRowEventArgs) Handles GridView1.RowDataBound


        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim id As Label = e.Row.FindControl("Label1")

            Dim mainReason As DataList = e.Row.FindControl("Dlist1")
            Dim subReason As DataList = e.Row.FindControl("Dlist2")
            Dim Value As DataList = e.Row.FindControl("Dlist3")

            'MsgBox(id.Text)
            If (Len(id.Text) > 0) Then

                SqlDataSource23.SelectParameters("strFormIDin").DefaultValue = id.Text

                mainReason.DataSource = SqlDataSource23
                mainReason.DataBind()

                subReason.DataSource = SqlDataSource23
                subReason.DataBind()

                Value.DataSource = SqlDataSource23
                Value.DataBind()
            End If



        End If

    End Sub


    Protected Sub OnRowDataBound2(ByVal sender As Object, ByVal e As GridViewRowEventArgs) Handles GridView2.RowDataBound


        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim id As Label = e.Row.FindControl("Label1")

            Dim mainReason As DataList = e.Row.FindControl("Dlist1")
            Dim subReason As DataList = e.Row.FindControl("Dlist2")
            Dim Value As DataList = e.Row.FindControl("Dlist3")

            'MsgBox(id.Text)
            If (Len(id.Text) > 0) Then

                SqlDataSource24.SelectParameters("strFormIDin").DefaultValue = id.Text

                mainReason.DataSource = SqlDataSource24
                mainReason.DataBind()

                subReason.DataSource = SqlDataSource24
                subReason.DataBind()

                Value.DataSource = SqlDataSource24
                Value.DataBind()
            End If



        End If

    End Sub

    Protected Sub OnRowDataBound3(ByVal sender As Object, ByVal e As GridViewRowEventArgs) Handles GridView3.RowDataBound


        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim id As Label = e.Row.FindControl("Label1")

            Dim mainReason As DataList = e.Row.FindControl("Dlist1")
            Dim subReason As DataList = e.Row.FindControl("Dlist2")
            Dim Value As DataList = e.Row.FindControl("Dlist3")

            'MsgBox(id.Text)
            If (Len(id.Text) > 0) Then

                SqlDataSource26.SelectParameters("strFormIDin").DefaultValue = id.Text

                mainReason.DataSource = SqlDataSource26
                mainReason.DataBind()

                subReason.DataSource = SqlDataSource26
                subReason.DataBind()

                Value.DataSource = SqlDataSource26
                Value.DataBind()
            End If



        End If

    End Sub

    Protected Sub OnRowDataBound4(ByVal sender As Object, ByVal e As GridViewRowEventArgs) Handles GridView4.RowDataBound


        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim id As Label = e.Row.FindControl("Label1")

            Dim mainReason As DataList = e.Row.FindControl("Dlist1")
            Dim subReason As DataList = e.Row.FindControl("Dlist2")
            Dim Value As DataList = e.Row.FindControl("Dlist3")

            'MsgBox(id.Text)
            If (Len(id.Text) > 0) Then

                SqlDataSource27.SelectParameters("strFormIDin").DefaultValue = id.Text

                mainReason.DataSource = SqlDataSource27
                mainReason.DataBind()

                subReason.DataSource = SqlDataSource27
                subReason.DataBind()

                Value.DataSource = SqlDataSource27
                Value.DataBind()
            End If



        End If

    End Sub


    Protected Sub OnRowDataBound10(ByVal sender As Object, ByVal e As GridViewRowEventArgs) Handles GridView10.RowDataBound


        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim id As Label = e.Row.FindControl("Label1")
 
            Dim mainReason As DataList = e.Row.FindControl("Dlist1")
            Dim subReason As DataList = e.Row.FindControl("Dlist2")
            Dim Value As DataList = e.Row.FindControl("Dlist3")

            'MsgBox(id.Text)
            If (Len(id.Text) > 0) Then

                SqlDataSource21.SelectParameters("strFormIDin").DefaultValue = id.Text

                mainReason.DataSource = SqlDataSource21
                mainReason.DataBind()

                subReason.DataSource = SqlDataSource21
                subReason.DataBind()

                Value.DataSource = SqlDataSource21
                Value.DataBind()
            End If



            ' For Each item As Object In mainReason.Items

            ' Dim reas As Label = mainReason.Items.Item(0).FindControl("Label6")
            'MsgBox(reas.Text)
            ' reasSpot.Text = reas.Text
            'Next

        End If

    End Sub


    Protected Sub GridView3_Bound(ByVal sender As Object, ByVal e As EventArgs) Handles GridView3.DataBound

    End Sub




    Protected Sub GridView4_Bound(ByVal sender As Object, ByVal e As EventArgs) Handles GridView4.DataBound

    End Sub

    Protected Sub ARC_Selected(ByVal sender As Object, ByVal e As SqlDataSourceStatusEventArgs) Handles SqlDataSource14.Selected
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
        'EC.sp_SelectFrom_Coaching_Log_MySubmitted_Dashboard 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource2_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource2.Selecting
        'EC.sp_SelectFrom_Coaching_Log_MyPenSubmitted_DashboardStaff 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource3_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource3.Selecting
        'EC.sp_SelectFrom_Coaching_LogStaffDistinctPendingSUPSubmitted 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource4_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource4.Selecting
        'EC.sp_SelectFrom_Coaching_LogStaffDistinctPendingMGRSubmitted 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource5_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource5.Selecting
        'EC.sp_SelectFrom_Coaching_LogStaffDistinctPendingCSRSubmitted 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource6_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource6.Selecting
        'EC.sp_SelectFrom_Coaching_Log_MyCompSubmitted_DashboardStaff 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource7_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource7.Selecting
        'EC.sp_SelectFrom_Coaching_Log_MySubmitted_DashboardSUP 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource8_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource8.Selecting
        'EC.sp_SelectFrom_Coaching_LogStaffDistinctCompletedSUPSubmitted 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource9_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource9.Selecting
        'EC.sp_SelectFrom_Coaching_LogStaffDistinctCompletedMGRSubmitted 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource10_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource10.Selecting
        'EC.sp_SelectFrom_Coaching_LogSupDistinctCSR 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource11_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource11.Selecting
        'EC.sp_SelectFrom_Coaching_LogSupDistinctMGR 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource12_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource12.Selecting
        'EC.sp_SelectFrom_Coaching_LogSupDistinctSUP 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource13_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource13.Selecting
        'EC.sp_SelectFrom_Coaching_LogStaffDistinctCompletedCSRSubmitted 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource14_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource14.Selecting
        'EC.sp_Check_AgentRole 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource16_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource16.Selecting
        'EC.sp_Select_Statuses_For_Dashboard 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource17_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource17.Selecting
        'EC.sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource18_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource18.Selecting
        'EC.sp_SelectFrom_Coaching_LogMgrDistinctCSRSubmitted 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource19_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource19.Selecting
        'EC.sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource20_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource20.Selecting
        'EC.sp_Select_Statuses_For_Dashboard 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource21_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource21.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource22_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource22.Selecting
        'EC.sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource23_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource23.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource24_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource24.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource26_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource26.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource27_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource27.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub





End Class