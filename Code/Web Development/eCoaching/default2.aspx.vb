Imports System.Data.SqlClient
Imports System.Net.Mail
Imports System
Imports System.Configuration
Imports AjaxControlToolkit

'still left to be done, add domain as a behind the scenes property of the selected CSR and pass that so on check u can see who the supervisor is in the right domain

Public Class default2
    Inherits BasePage

    Private CoachingButtonList1 As RadioButtonList
    Private VerintButtonList1 As RadioButtonList
    Private BehaviorButtonList1 As RadioButtonList
    Private NGDAButtonList1 As RadioButtonList
    Private VerintButtonList2 As RadioButtonList
    Private BehaviorButtonList2 As RadioButtonList
    Private NGDAButtonList2 As RadioButtonList
    Private CSIButtonList2 As RadioButtonList
    Private CSEButtonList As RadioButtonList

    Dim numCount As Label
    Dim TodaysDate As String = DateTime.Today.ToShortDateString()
    Dim x As String
    Dim strEmail As String
    Dim strSubject As String
    Dim strPerson As String
    Dim strDate As String
    Dim strFormID As String
    Dim strCtrMessage As String
    Dim mngrName As String
    Dim suprName As String

    Dim mailSent As Boolean = False
    'code for formID random generator
    Dim chars As String = "0123456789"
    Dim digit
    Dim found
    Dim coachR(13, 3)

    Dim copy As Boolean = False
    Dim strCopy As String

    Dim supervisor As String
    Dim domain As String
    Dim FromURL As String
    Dim userTitle As String
    Dim moduleID As Integer
    Dim modtype As Array
    Dim grid As GridView

    Protected Sub DropDownList1_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        DropDownList1 = CType(sender, DropDownList)
        Dim lan As String = TryCast(Session("eclUser"), User).LanID
        Dim site = DropDownList1.SelectedItem.Text

        Label21.Visible = False
        Label23.Visible = False
        Label30.Visible = False
        Label32.Visible = False
        Label52.Visible = False
        Label53.Visible = False
        Label49.Text = site        'site
        SupervisorDropDownList.Text = ""
        MGRDropDownList.Text = ""

        ddCSR.Items.Clear()
        ddCSR.Items.Add(New ListItem("Select...", "Select..."))
        If (site <> "Select...") Then
            ' EC.sp_Select_Employees_By_Module
            SqlDataSource1.SelectParameters("strCSRSitein").DefaultValue = site
            SqlDataSource1.SelectParameters("strModulein").DefaultValue = "CSR"
            SqlDataSource1.SelectParameters("strUserLanin").DefaultValue = lan
        Else
            Panel0a.Visible = False
            Select Case True
                Case Panel1.Visible
                    Date1.Text = ""
                    TextBox5.Text = ""
                    callID2.Text = ""
                    calltype2.SelectedIndex = 0
                    cseradio2.SelectedIndex = 1
                    RadioButton4.Checked = True
                    RadioButton3.Checked = False
                    CheckBox1.Checked = False
                    GridView6.DataSourceID = ""
                    GridView6.DataBind()
                    GridView6.DataSourceID = "SqlDataSource21"  ' EC.sp_Select_CoachingReasons_By_Module
                    GridView6.DataBind()

                    GridView2.DataSourceID = ""
                    GridView2.DataBind()
                    GridView2.DataSourceID = "SqlDataSource10"  ' EC.sp_Select_CoachingReasons_By_Module
                    GridView2.DataBind()

                    Panel1.Visible = False
                Case Panel2.Visible
                    If (warnlist.SelectedIndex = 0) Then
                        warnlist.SelectedIndex = 1
                        warnlist2.SelectedIndex = 0
                        warnReasons.Items.Clear()
                        warnReasons.Items.Add(New ListItem("Select...", "Select..."))
                        warngroup1.Style("display") = "none" 'inline
                        warngroup1.Style("visibility") = "hidden" 'visible

                        Panel6.Style("display") = "inline"
                        Panel6.Style("visibility") = "visible"
                        Panel7.Style("display") = "inline"
                        Panel7.Style("visibility") = "visible"

                        CustomValidator2.Enabled = True

                        RequiredFieldValidator11.Enabled = False
                        CustomValidator3.Enabled = False

                        nowarn.Style("display") = "inline" 'inline
                        nowarn.Style("visibility") = "visible" 'visible
                        Labe27.Text = "Enter/Select the date of coaching:"
                    End If
                    Date2.Text = ""
                    TextBox11.Text = ""
                    TextBox12.Text = ""
                    callID.Text = ""
                    calltype.SelectedIndex = 0
                    cseradio.SelectedIndex = 1

                    RadioButton2.Checked = True
                    RadioButton1.Checked = False

                    CheckBox2.Checked = False
                    GridView5.DataSourceID = ""
                    GridView5.DataBind()
                    GridView5.DataSourceID = "SqlDataSource18"  ' EC.sp_Select_CoachingReasons_By_Module
                    GridView5.DataBind()

                    GridView4.DataSourceID = ""
                    GridView4.DataBind()
                    GridView4.DataSourceID = "SqlDataSource12"  ' EC.sp_Select_CoachingReasons_By_Module
                    GridView4.DataBind()

                    Panel2.Visible = False
            End Select
        End If
    End Sub

    Protected Sub warnlist2_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim site = warnlist2.SelectedItem.Text
        warnReasons.Items.Clear()
        warnReasons.Items.Add(New ListItem("Select...", "Select..."))
        Dim lan As String = TryCast(Session("eclUser"), User).LanID
        If (warnlist2.SelectedValue <> "Select...") Then
            ' EC.sp_Select_SubCoachingReasons_By_Reason
            SqlDataSource26.SelectParameters("strReasonin").DefaultValue = warnlist2.SelectedItem.Text
            SqlDataSource26.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource26.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource26.SelectParameters("nvcEmpLanIDin").DefaultValue = lan

            warnReasons.DataSource = SqlDataSource26
            warnReasons.DataBind()
            warnReasons.SelectedIndex = 0
        End If
    End Sub

    Protected Sub DropDownList3_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim lan As String = TryCast(Session("eclUser"), User).LanID
        Dim DropDownList3 = CType(sender, DropDownList)
        Dim recipient = DropDownList3.SelectedItem.Text

        Label21.Visible = False
        Label23.Visible = False
        Label48.Visible = False
        Label49.Visible = False
        Label30.Visible = False
        Label32.Visible = False
        Label52.Visible = False
        Label53.Visible = False

        SupervisorDropDownList.Text = ""
        MGRDropDownList.Text = ""

        ddCSR.Items.Clear() 'clear CSR List
        ddCSR.Items.Add(New ListItem("Select...", "Select..."))

        DropDownList1.Items.Clear() 'clear site list
        DropDownList1.Items.Add(New ListItem("Select...", "Select..."))

        programList.Items.Clear() 'clear program list
        programList.Items.Add(New ListItem("Select...", "Select..."))

        behaviorList.Items.Clear() 'clear behavior list
        behaviorList.Items.Add(New ListItem("Select...", "Select..."))

        RadioButtonList1.SelectedIndex = -1

        Panel0.Visible = False
        Panel2.Visible = False
        Panel1.Visible = False

        If (recipient = "Select...") Then
            Panel0.Visible = False
        Else
            Panel0.Visible = True
            ' EC.sp_Display_Sites_For_Module
            SqlDataSource3.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            ' EC.sp_Select_Programs
            SqlDataSource4.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            ' EC.sp_Select_Behaviors
            SqlDataSource28.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

            modtype = Split(DropDownList3.SelectedItem.Value, "-", -1, 1)
            moduleIDlbl.Text = modtype(2)
            If (modtype(0) = 1) Then
                Panel29.Visible = True ' 1. Select Employee Site:
                Label41.Text = "2. "
                Label42.Text = "3. "
                Label43.Text = "4. "
                Label61.Text = "5. "
                Label63.Text = "6. "
            Else
                Panel29.Visible = False
                Label41.Text = "1. "
                Label42.Text = "2. "
                Label43.Text = "3. "
                If (modtype(5) = 1) Then
                    Panel8.Visible = True
                    RequiredFieldValidator22.Enabled = True
                    Label61.Text = "4. "
                Else
                    Panel8.Visible = False
                    RequiredFieldValidator22.Enabled = False
                    Label61.Text = ""
                End If
                If (modtype(6) = 1) Then
                    Panel9.Visible = True
                    RequiredFieldValidator10.Enabled = True
                    If (Label61.Text = "4. ") Then
                        Label96.Text = "5. "
                        Label63.Text = "6. "
                    Else
                        Label96.Text = "4. "
                        Label63.Text = "5. "
                    End If
                Else
                    Label96.Text = ""
                    Panel9.Visible = False
                    RequiredFieldValidator10.Enabled = False
                    If (Label61.Text = "4. ") Then
                        Label63.Text = "5. "
                    Else
                        Label63.Text = "4. "
                    End If
                End If

                ' EC.sp_Select_Employees_By_Module
                SqlDataSource1.SelectParameters("strCSRSitein").DefaultValue = "Empty"
                SqlDataSource1.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
                SqlDataSource1.SelectParameters("strUserLanin").DefaultValue = lan
            End If
        End If
    End Sub

    Protected Sub CSRDropDownList_SelectedIndexChanged2(ByVal sender As Object, ByVal e As EventArgs)
        ddCSR = CType(sender, DropDownList)
        Dim arrCSR As Array
        If (ddCSR.SelectedValue = "Select...") Then
            SupervisorDropDownList.Text = ""
            MGRDropDownList.Text = ""
            Panel0a.Visible = False
            Select Case True
                Case Panel1.Visible
                    Date1.Text = ""
                    TextBox5.Text = ""
                    callID2.Text = ""
                    calltype2.SelectedIndex = 0
                    cseradio2.SelectedIndex = 1
                    RadioButton4.Checked = True
                    RadioButton3.Checked = False
                    CheckBox1.Checked = False
                    GridView6.DataSourceID = ""
                    GridView6.DataBind()
                    GridView6.DataSourceID = "SqlDataSource21"  ' EC.sp_Select_CoachingReasons_By_Module
                    GridView6.DataBind()
                    GridView2.DataSourceID = ""
                    GridView2.DataBind()
                    GridView2.DataSourceID = "SqlDataSource10"  ' EC.sp_Select_CoachingReasons_By_Module
                    GridView2.DataBind()
                    Panel1.Visible = False
                Case Panel2.Visible
                    If (warnlist.SelectedIndex = 0) Then
                        warnlist.SelectedIndex = 1
                        warnlist2.SelectedIndex = 0
                        warnReasons.Items.Clear()
                        warnReasons.Items.Add(New ListItem("Select...", "Select..."))
                        warngroup1.Style("display") = "none" 'inline
                        warngroup1.Style("visibility") = "hidden" 'visible
                        Panel6.Style("display") = "inline"
                        Panel6.Style("visibility") = "visible"
                        Panel7.Style("display") = "inline"
                        Panel7.Style("visibility") = "visible"
                        CustomValidator2.Enabled = True
                        RequiredFieldValidator11.Enabled = False
                        CustomValidator3.Enabled = False
                        nowarn.Style("display") = "inline" 'inline
                        nowarn.Style("visibility") = "visible" 'visible
                        Labe27.Text = "Enter/Select the date of coaching:"
                    End If
                    Date2.Text = ""
                    TextBox11.Text = ""
                    TextBox12.Text = ""
                    callID.Text = ""
                    calltype.SelectedIndex = 0
                    cseradio.SelectedIndex = 1
                    RadioButton2.Checked = True
                    RadioButton1.Checked = False
                    CheckBox2.Checked = False
                    GridView5.DataSourceID = ""
                    GridView5.DataBind()
                    GridView5.DataSourceID = "SqlDataSource18"  ' EC.sp_Select_CoachingReasons_By_Module
                    GridView5.DataBind()
                    GridView4.DataSourceID = ""
                    GridView4.DataBind()
                    GridView4.DataSourceID = "SqlDataSource12"  ' EC.sp_Select_CoachingReasons_By_Module 
                    GridView4.DataBind()
                    Panel2.Visible = False
            End Select
        Else
            Panel0a.Visible = False
            SupervisorDropDownList.Text = ""
            MGRDropDownList.Text = ""
            Dim y As String
            Dim z As String
            arrCSR = Split(ddCSR.SelectedValue, "$", -1, 1)
            y = arrCSR(3) & " (" & arrCSR(5) & ") - " & arrCSR(6)
            z = arrCSR(7) & " (" & arrCSR(9) & ") - " & arrCSR(10)
            SupervisorDropDownList.Text = y
            MGRDropDownList.Text = z
            Label23.Text = arrCSR(0)
            Label17.Text = arrCSR(2)
            Label19.Text = arrCSR(1)
            Label32.Text = arrCSR(3) '"Curtis, Jared A" '
            Label28.Text = arrCSR(5) '"curtja" 
            Label36.Text = arrCSR(4) '"jared.curtis@vangent.com" 
            Label53.Text = arrCSR(7) '"Cortez, Corey C"
            Label47.Text = arrCSR(9) '"cortco"
            Label55.Text = arrCSR(8) '"corey.cortez@vangent.com"
            Label49.Text = arrCSR(11) ' site
            Panel0a.Visible = False
            Select Case True
                Case Panel1.Visible
                    Date1.Text = ""
                    TextBox5.Text = ""
                    callID2.Text = ""
                    calltype2.SelectedIndex = 0
                    cseradio2.SelectedIndex = 1
                    RadioButton4.Checked = True
                    RadioButton3.Checked = False
                    CheckBox1.Checked = False
                    GridView6.DataSourceID = ""
                    GridView6.DataBind()
                    GridView6.DataSourceID = "SqlDataSource21"  ' EC.sp_Select_CoachingReasons_By_Module
                    GridView6.DataBind()
                    GridView2.DataSourceID = ""
                    GridView2.DataBind()
                    GridView2.DataSourceID = "SqlDataSource10"  ' EC.sp_Select_CoachingReasons_By_Module
                    GridView2.DataBind()
                    Panel1.Visible = False
                Case Panel2.Visible
                    If (warnlist.SelectedIndex = 0) Then
                        warnlist.SelectedIndex = 1
                        warnlist2.SelectedIndex = 0
                        warnReasons.Items.Clear()
                        warnReasons.Items.Add(New ListItem("Select...", "Select..."))
                        warngroup1.Style("display") = "none" 'inline
                        warngroup1.Style("visibility") = "hidden" 'visible

                        Panel6.Style("display") = "inline"
                        Panel6.Style("visibility") = "visible"
                        Panel7.Style("display") = "inline"
                        Panel7.Style("visibility") = "visible"

                        CustomValidator2.Enabled = True
                        RequiredFieldValidator11.Enabled = False
                        CustomValidator3.Enabled = False

                        nowarn.Style("display") = "inline" 'inline
                        nowarn.Style("visibility") = "visible" 'visible
                        Labe27.Text = "Enter/Select the date of coaching:"
                    End If
                    Date2.Text = ""
                    TextBox11.Text = ""
                    TextBox12.Text = ""
                    callID.Text = ""
                    calltype.SelectedIndex = 0
                    cseradio.SelectedIndex = 1

                    RadioButton2.Checked = True
                    RadioButton1.Checked = False

                    CheckBox2.Checked = False
                    GridView5.DataSourceID = ""
                    GridView5.DataBind()
                    GridView5.DataSourceID = "SqlDataSource18"  ' EC.sp_Select_CoachingReasons_By_Module
                    GridView5.DataBind()

                    GridView4.DataSourceID = ""
                    GridView4.DataBind()
                    GridView4.DataSourceID = "SqlDataSource12"  ' EC.sp_Select_CoachingReasons_By_Module
                    GridView4.DataBind()

                    Panel2.Visible = False
            End Select
            Label21.Visible = True
            Label23.Visible = True
            Label30.Visible = True
            Label32.Visible = True
            Label52.Visible = True
            Label53.Visible = True

            Button1_Click() ' Next1.Enabled = True
        End If
    End Sub

    Protected Sub ProgramList_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        programList = CType(sender, DropDownList)
        Button1_Click() '  Next1.Enabled = True
    End Sub

    Protected Sub BehaviorList_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        behaviorList = CType(sender, DropDownList)
        Button1_Click() '  Next1.Enabled = True
    End Sub

    Protected Sub RadioButtonList1_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Button1_Click() '  Next1.Enabled = True
    End Sub

    Protected Sub Button1_Click()
        Dim lan As String = TryCast(Session("eclUser"), User).LanID
        Dim checkProgram
        Dim checkBehavior

        modtype = Split(DropDownList3.SelectedItem.Value, "-", -1, 1)
        If (modtype(5) = 1) Then
            checkProgram = (programList.SelectedIndex <> 0)
        Else
            checkProgram = True
        End If

        If (modtype(6) = 1) Then
            checkBehavior = (behaviorList.SelectedIndex <> 0)
        Else
            checkBehavior = True
        End If

        If ((RadioButtonList1.SelectedIndex <> -1) And (checkProgram = True) And (checkBehavior = True) And (ddCSR.SelectedIndex <> 0)) Then
            Page.Validate()
            If ((Page.IsValid) Or (Panel1.Visible = True) Or (Panel2.Visible = True)) Then
                Dim cbl = RadioButtonList1.SelectedValue
                Dim site = DropDownList1.SelectedValue
                Dim menu '= CType(sender, DropDownList)

                Panel0a.Visible = True ' display side info
                Label8.Text = "Date Submitted"
                Label21.Visible = True
                Label23.Visible = True
                Label48.Visible = True
                Label49.Visible = True
                Label30.Visible = True
                Label32.Visible = True
                Label52.Visible = True
                Label53.Visible = True

                If (DropDownList1.SelectedIndex <> 0) Then
                    Label49.Text = DropDownList1.SelectedItem.Text        'site
                Else
                    Label49.Text = Label49.Text        'site
                End If

                Label51.Text = cbl
                Label57.Text = lan

                Dim numCur As Integer
                numCur = CInt(Replace(Label63.Text, ". ", ""))
                If (cbl = "Indirect") Then
                    warnlist.SelectedIndex = 1
                    Labe27.Text = "Enter/Select the date of coaching:"
                    warnReasons.Items.Clear()
                    warnReasons.Items.Add(New ListItem("Select...", "Select..."))

                    Button2.Visible = True
                    Panel2.Visible = False
                    Panel1.Visible = True
                    CalendarExtender1.EndDate = TodaysDate

                    ' EC.sp_Select_CoachingReasons_By_Module
                    SqlDataSource10.SelectParameters("strSourcein").DefaultValue = "Indirect"
                    SqlDataSource10.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
                    SqlDataSource10.SelectParameters("isSplReason").DefaultValue = False
                    SqlDataSource10.SelectParameters("splReasonPrty").DefaultValue = 2
                    SqlDataSource10.SelectParameters("strCSRin").DefaultValue = Label17.Text
                    SqlDataSource10.SelectParameters("strSubmitterin").DefaultValue = lan

                    ' EC.sp_Select_CoachingReasons_By_Module
                    SqlDataSource21.SelectParameters("strSourcein").DefaultValue = "Indirect"
                    SqlDataSource21.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
                    SqlDataSource21.SelectParameters("isSplReason").DefaultValue = True
                    SqlDataSource21.SelectParameters("splReasonPrty").DefaultValue = 2
                    SqlDataSource21.SelectParameters("strCSRin").DefaultValue = Label17.Text
                    SqlDataSource21.SelectParameters("strSubmitterin").DefaultValue = lan

                    Label188.Text = "Indirect Entry [2 of 2]"

                    RadioButton3.Attributes.Add("onclick", "javascript: toggleCallID1('1','" & panel2c2.ClientID & "','" & callID2.ClientID & "','" & calltype2.ClientID & "');")
                    RadioButton4.Attributes.Add("onclick", "javascript: toggleCallID1('0','" & panel2c2.ClientID & "','" & callID2.ClientID & "','" & calltype2.ClientID & "');")

                    CompareValidator1.ValueToCompare = TodaysDate

                    menu = howid2
                    menu.Items.Clear()
                    menu.Items.Add(New ListItem("Select...", "Select..."))

                    ' EC.sp_Select_Source_By_Module
                    SqlDataSource5.SelectParameters("strSourcein").DefaultValue = "Indirect"
                    SqlDataSource5.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

                    ' EC.sp_Select_CallID_By_Module
                    SqlDataSource8.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

                    numCur = numCur + 1
                    Label66.Text = (numCur) & ". "
                    numCur = numCur + 1

                    If (modtype(3) = 1) Then
                        Panel3.Visible = True
                        Label72.Text = (numCur) & ". "
                        numCur = numCur + 1
                    Else
                        Panel3.Visible = False
                    End If

                    Label73.Text = (numCur) & ". "
                    numCur = numCur + 1
                    Label74.Text = (numCur) & ". "
                    numCur = numCur + 1
                    Label75.Text = (numCur) & ". "
                    numCur = numCur + 1
                    Label76.Text = (numCur) & ". "

                    warngroup2.Visible = False

                    Panel6.Style("display") = "inline"
                    Panel6.Style("visibility") = "visible"
                    Panel7.Style("display") = "inline"
                    Panel7.Style("visibility") = "visible"

                    CustomValidator2.Enabled = True

                    RequiredFieldValidator11.Enabled = False
                    CustomValidator3.Enabled = False
                Else
                    Button5.Visible = True
                    Panel1.Visible = False
                    Panel2.Visible = True
                    CalendarExtender2.EndDate = TodaysDate

                    ' EC.sp_Select_CoachingReasons_By_Module
                    SqlDataSource12.SelectParameters("strSourcein").DefaultValue = "Direct"
                    SqlDataSource12.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
                    SqlDataSource12.SelectParameters("isSplReason").DefaultValue = False
                    SqlDataSource12.SelectParameters("splReasonPrty").DefaultValue = 2
                    SqlDataSource12.SelectParameters("strCSRin").DefaultValue = Label17.Text
                    SqlDataSource12.SelectParameters("strSubmitterin").DefaultValue = lan

                    ' EC.sp_Select_CoachingReasons_By_Module
                    SqlDataSource18.SelectParameters("strSourcein").DefaultValue = "Direct"
                    SqlDataSource18.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
                    SqlDataSource18.SelectParameters("isSplReason").DefaultValue = True
                    SqlDataSource18.SelectParameters("splReasonPrty").DefaultValue = 2
                    SqlDataSource18.SelectParameters("strCSRin").DefaultValue = Label17.Text
                    SqlDataSource18.SelectParameters("strSubmitterin").DefaultValue = lan

                    If (((lan = LCase(Label28.Text)) Or (lan = LCase(Label47.Text))) And (modtype(4) = 1)) Then
                        warngroup2.Visible = True
                        warnlist2.Items.Clear() 'clear site list
                        warnlist2.Items.Add(New ListItem("Select...", "Select..."))

                        'Warning setup
                        ' EC.sp_Select_CoachingReasons_By_Module
                        SqlDataSource24.SelectParameters("strSourcein").DefaultValue = "Direct"
                        SqlDataSource24.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
                        SqlDataSource24.SelectParameters("isSplReason").DefaultValue = True
                        SqlDataSource24.SelectParameters("splReasonPrty").DefaultValue = 1
                        SqlDataSource24.SelectParameters("strCSRin").DefaultValue = Label17.Text
                        SqlDataSource24.SelectParameters("strSubmitterin").DefaultValue = lan
                    Else
                        warngroup2.Visible = False
                    End If

                    Label188.Text = "Direct Entry [2 of 2]"
                    RadioButton1.Attributes.Add("onclick", "javascript: toggleCallID1('1','" & panel2c.ClientID & "','" & callID.ClientID & "','" & calltype.ClientID & "');")
                    RadioButton2.Attributes.Add("onclick", "javascript: toggleCallID1('0','" & panel2c.ClientID & "','" & callID.ClientID & "','" & calltype.ClientID & "');")
                    CompareValidator2.ValueToCompare = TodaysDate

                    menu = howid
                    menu.Items.Clear()
                    menu.Items.Add(New ListItem("Select...", "Select..."))

                    ' EC.sp_Select_Source_By_Module
                    SqlDataSource7.SelectParameters("strSourcein").DefaultValue = "Direct"
                    SqlDataSource7.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

                    ' EC.sp_Select_CallID_By_Module
                    SqlDataSource9.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

                    If (((lan = LCase(Label28.Text)) Or (lan = LCase(Label47.Text))) And (modtype(4) = 1)) Then
                        numCur = numCur + 1
                        Label64.Text = (numCur) & ". "
                    End If

                    numCur = numCur + 1
                    Label77.Text = (numCur) & ". "
                    numCur = numCur + 1
                    If (modtype(3) = 1) Then
                        Panel5.Visible = True
                        Label78.Text = (numCur) & ". "
                        numCur = numCur + 1
                    Else
                        Panel5.Visible = False
                    End If

                    Label79.Text = (numCur) & ". "
                    numCur = numCur + 1
                    Label80.Text = (numCur) & ". "
                    numCur = numCur + 1
                    Label83.Text = (numCur) & ". "
                    numCur = numCur + 1
                    Label84.Text = (numCur) & ". "
                    numCur = numCur + 1
                    Label85.Text = (numCur) & ". "
                End If
            End If
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            HandlePageNonPostBack()
        Else
            HandlePagePostBack()
        End If
    End Sub

    ' called on page non post back but after authentication is successful
    Public Sub HandlePageNonPostBack()
        Dim eclUser As User = Session("eclUser")
        Dim lan As String = eclUser.LanID

        userTitle = eclUser.JobCode
        Label180.Text = eclUser.Email
        Label178.Text = eclUser.Name
        Label157.Text = lan
        ' Display today date after "Date Started:"
        Label10.Text = DateTime.Today.ToShortDateString()

        ' sp_check_agentrole (GridView1)
        SqlDataSource14.SelectParameters("nvcLanID").DefaultValue = lan
        SqlDataSource14.SelectParameters("nvcRole").DefaultValue = "ARC"
        GridView1.DataBind()

        ' Populate "Select Coaching Module:" (DropDownList3)
        ' sp_select_modules_by_job_code
        SqlDataSource15.SelectParameters("nvcEmpLanIDin").DefaultValue = lan
        SqlDataSource15.DataBind()

        If ((InStr(1, userTitle, "WACS0", 1) > 0) And (Label241.Text = 0)) Then
            ' not authorized to submit an eCoaching Log
            Response.Redirect("error2.aspx")
        End If
    End Sub

    Public Sub HandlePagePostBack()
        Dim eclUser As User = Session("eclUser")
        Dim lan As String = eclUser.LanID

        grid = GridView4

        If (DropDownList3.SelectedIndex > 0) Then
            modtype = Split(DropDownList3.SelectedItem.Value, "-", -1, 1)
            If (modtype(5) = 1) Then
                Panel8.Visible = True
                RequiredFieldValidator22.Enabled = True
            Else
                Panel8.Visible = False
                RequiredFieldValidator22.Enabled = False
            End If

            If (modtype(6) = 1) Then
                Panel9.Visible = True
                RequiredFieldValidator10.Enabled = True
            Else
                Panel9.Visible = False
                RequiredFieldValidator10.Enabled = False
            End If
        End If

        If ((RadioButtonList1.SelectedValue = "Direct") And (DropDownList3.SelectedItem.Value <> "Select...")) Then
            grid = GridView4
            If ((modtype(3) = 1) And (warnlist.SelectedIndex <> 0)) Then
                Panel6.Style("display") = "inline"
                Panel6.Style("visibility") = "visible"
                Panel7.Style("display") = "inline"
                Panel7.Style("visibility") = "visible"
                Select Case cseradio.SelectedValue
                    Case "Yes"
                        grid = GridView5
                        csegroup.Style("display") = "inline"
                        csegroup.Style("visibility") = "visible"
                        nocsegroup.Style("display") = "none"
                        nocsegroup.Style("visibility") = "hidden"
                    Case "No"
                        grid = GridView4
                        nocsegroup.Style("display") = "inline"
                        nocsegroup.Style("visibility") = "visible"
                        csegroup.Style("display") = "none"
                        csegroup.Style("visibility") = "hidden"
                End Select
            End If

            If ((((lan = LCase(Label28.Text)) Or (lan = LCase(Label47.Text))) And (modtype(4) = 1)) And (ddCSR.SelectedIndex <> 0)) Then
                warngroup2.Visible = True
                If (warnlist.SelectedIndex = 0) Then
                    warngroup1.Style("display") = "inline" 'inline
                    warngroup1.Style("visibility") = "visible" 'visible

                    Labe27.Text = "Enter/Select the date the warning was issued:"

                    Panel6.Style("display") = "none"
                    Panel6.Style("visibility") = "hidden"
                    Panel7.Style("display") = "none"
                    Panel7.Style("visibility") = "hidden"

                    CustomValidator2.Enabled = False

                    nowarn.Style("display") = "none" 'inline
                    nowarn.Style("visibility") = "hidden" 'visible

                    RequiredFieldValidator49.Enabled = False
                    RequiredFieldValidator50.Enabled = False
                Else
                    warngroup1.Style("display") = "none" 'inline
                    warngroup1.Style("visibility") = "hidden" 'visible
                    Panel6.Style("display") = "inline"
                    Panel6.Style("visibility") = "visible"
                    Panel7.Style("display") = "inline"
                    Panel7.Style("visibility") = "visible"

                    RequiredFieldValidator11.Enabled = False
                    CustomValidator3.Enabled = False

                    nowarn.Style("display") = "inline" 'inline
                    nowarn.Style("visibility") = "visible" 'visible

                    Labe27.Text = "Enter/Select the date of coaching:"
                End If
            Else
                warngroup2.Visible = False

                Panel6.Style("display") = "inline"
                Panel6.Style("visibility") = "visible"
                Panel7.Style("display") = "inline"
                Panel7.Style("visibility") = "visible"

                RequiredFieldValidator11.Enabled = False
                CustomValidator3.Enabled = False
            End If

            If (RadioButton1.Checked) Then
                panel2c.Style("display") = "inline"
                panel2c.Style("visibility") = "visible"
            Else
                panel2c.Style("display") = "none"
                panel2c.Style("visibility") = "hidden"
            End If
        End If

        If ((RadioButtonList1.SelectedValue = "Indirect") And (DropDownList3.SelectedItem.Value <> "Select...")) Then
            grid = GridView2
            If (modtype(3) = 1) Then
                Select Case cseradio2.SelectedValue
                    Case "Yes"
                        grid = GridView6
                        csegroup2.Style("display") = "inline"
                        csegroup2.Style("visibility") = "visible"
                        nocsegroup2.Style("display") = "none"
                        nocsegroup2.Style("visibility") = "hidden"
                    Case "No"
                        grid = GridView2
                        nocsegroup2.Style("display") = "inline"
                        nocsegroup2.Style("visibility") = "visible"
                        csegroup2.Style("display") = "none"
                        csegroup2.Style("visibility") = "hidden"
                End Select
            End If

            If (RadioButton3.Checked) Then
                panel2c2.Style("display") = "inline"
                panel2c2.Style("visibility") = "visible"
            Else
                panel2c2.Style("display") = "none"
                panel2c2.Style("visibility") = "hidden"
            End If
        End If

        Dim d As CheckBox
        Dim f As RadioButtonList
        Dim g As ListBox
        Dim h As ListBox
        Dim j As RequiredFieldValidator
        Dim state As String

        state = "closed"
        If (warngroup2.Visible = False) Then ' check for regular coaching reasons - not warning
            RequiredFieldValidator11.Enabled = False
            CustomValidator3.Enabled = False
            For i As Integer = 0 To (grid.Rows.Count - 1)
                For k As Integer = 0 To (grid.Columns.Count - 1)
                    Dim childc As Control
                    For Each childc In grid.Rows(i).Cells(k).Controls
                        If (TypeOf childc Is RequiredFieldValidator) Then
                            j = CType(childc, RequiredFieldValidator)
                            If (state = "open") Then
                                j.Enabled = True
                            Else
                                j.Enabled = False
                            End If
                        End If

                        If ((k = 0) And ((InStr(1, childc.ClientID, "sub1", 1) > 0))) Then
                            Dim childgc As Control
                            For Each childgc In childc.Controls
                                If ((InStr(1, childgc.ClientID, "SubReasons", 1) > 0)) Then
                                    h = CType(childgc, ListBox)
                                    Dim b
                                    b = CType(h.Parent, Panel)
                                    If (state = "open") Then
                                        b.style("display") = "inline"
                                        b.style("visibility") = "visible"
                                    Else
                                        b.style("display") = "none"
                                        b.style("visibility") = "hidden"
                                    End If
                                End If
                                If (TypeOf childgc Is RequiredFieldValidator) Then
                                    ' MsgBox("1-a-state=" & state)
                                    'MsgBox("1-a-id=" & childgc.ClientID)
                                    j = CType(childgc, RequiredFieldValidator)
                                    If (state = "open") Then
                                        j.Enabled = True
                                    Else
                                        j.Enabled = False
                                    End If
                                End If
                            Next
                        End If

                        If (TypeOf childc Is CheckBox) Then
                            d = CType(childc, CheckBox)
                            ' MsgBox("checked2=" & d.Checked)
                            'bubble = d.Checked
                            If (d.Checked = True) Then
                                state = "open"
                            Else
                                state = "closed"
                            End If
                        End If

                        If (TypeOf childc Is RadioButtonList) Then
                            f = CType(childc, RadioButtonList)
                            If (state = "open") Then
                                f.Enabled = True
                            Else
                                f.Enabled = False
                            End If

                            For Each item As Object In f.Items
                                If (InStr(1, item.Text, "!", 1) > 0) Then
                                    item.Attributes.Add("style", "visibility: hidden;")
                                End If
                            Next
                        End If
                    Next ' end of child list
                Next ' end of column
            Next ' end of row
        End If
    End Sub

    Protected Sub CheckBoxRequired_ServerValidate(ByVal Source As Object, ByVal args As ServerValidateEventArgs)
        args.IsValid = CheckBox1.Checked
    End Sub

    Protected Sub CheckBoxRequired2_ServerValidate(ByVal Source As Object, ByVal args As ServerValidateEventArgs)
        args.IsValid = CheckBox2.Checked
    End Sub

    Protected Sub Button2_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button2.Click
        Dim lan As String = TryCast(Session("eclUser"), User).LanID
        Dim formType = "Indirect"

        RequiredFieldValidator14.Enabled = True
        CompareValidator1.Enabled = True
        RequiredFieldValidator48.Enabled = True
        RequiredFieldValidator2.Enabled = True
        CheckBoxRequired.Enabled = True

        '''loop through GridView2
        Dim m As Label
        Dim d As CheckBox
        Dim f As RadioButtonList
        Dim g As ListBox
        Dim h As ListBox
        Dim j As RequiredFieldValidator
        Dim state As String
        state = "closed"

        found = 0
        For i As Integer = 0 To (grid.Rows.Count - 1)
            For k As Integer = 0 To (grid.Columns.Count - 1)
                Dim childc As Control
                For Each childc In grid.Rows(i).Cells(k).Controls
                    If (TypeOf childc Is RequiredFieldValidator) Then
                        j = CType(childc, RequiredFieldValidator)
                        If (state = "open") Then
                            j.Enabled = True
                        Else
                            j.Enabled = False
                        End If
                    End If

                    If ((k = 0) And ((InStr(1, childc.ClientID, "sub1", 1) > 0))) Then
                        Dim childgc As Control
                        For Each childgc In childc.Controls
                            If (InStr(1, childgc.ClientID, "SubReasons", 1) > 0) Then
                                h = CType(childgc, ListBox)
                                Dim b
                                b = CType(h.Parent, Panel)
                                If (state = "open") Then
                                    b.style("display") = "inline"
                                    b.style("visibility") = "visible"
                                Else
                                    b.style("display") = "none"
                                    b.style("visibility") = "hidden"
                                End If

                                If (TypeOf childgc Is ListBox) Then
                                    g = CType(childgc, ListBox)
                                    Dim x
                                    Dim z
                                    z = ""
                                    For x = 0 To g.Items.Count - 1
                                        If ((state = "open") And (Len(g.Items(x).Value) > 0) And (g.Items(x).Selected = True)) Then
                                            z = z & g.Items(x).Value & ","
                                        End If
                                    Next
                                    If (Len(z) > 0) Then
                                        coachR(found, 1) = Left(z, Len(z) - 1) 'g.Items(x).Value  '
                                    End If
                                End If
                            End If

                            If (TypeOf childgc Is RequiredFieldValidator) Then
                                j = CType(childgc, RequiredFieldValidator)
                                If (state = "open") Then
                                    j.Enabled = True
                                Else
                                    j.Enabled = False
                                End If
                            End If
                        Next
                    End If

                    If (TypeOf childc Is CheckBox) Then
                        d = CType(childc, CheckBox)
                        If (d.Checked) Then
                            state = "open"
                        Else
                            state = "closed"
                        End If
                    End If

                    If (TypeOf childc Is Label) Then
                        m = CType(childc, Label)
                        If ((state = "open") And (InStr(1, m.ClientID, "Label65", 1) > 0)) Then
                            coachR(found, 0) = m.Text
                        End If
                    End If

                    If (TypeOf childc Is RadioButtonList) Then
                        f = CType(childc, RadioButtonList)
                        If (state = "open") Then
                            f.Enabled = True
                            If (f.SelectedIndex <> -1) Then
                                coachR(found, 2) = (f.SelectedItem.ToString())
                            End If
                        Else
                            f.Enabled = False
                        End If

                        For Each item As Object In f.Items
                            If (InStr(1, item.Text, "!", 1) > 0) Then
                                item.Attributes.Add("style", "visibility: hidden;")
                            End If
                        Next
                    End If
                Next ' end of child list
            Next ' end of column

            If (state = "open") Then
                found = found + 1
            End If
        Next ' end of row

        If (found = 0) Then
            Label239.Text = ""
            RequiredFieldValidator7.Enabled = True
        Else
            Label239.Text = "valid"
            RequiredFieldValidator7.Enabled = False
        End If

        If (RadioButton3.Checked = True) Then
            RequiredFieldValidator3.Enabled = True
            RegularExpressionValidator2.Enabled = True
            'http://www.w3schools.com/ASPnet/showaspx.asp?filename=demo_regularexpvalidator

            'alpha(numeric(upper And lowercase))
            'underscore
            'min 8 char
            'max 26 char
            RegularExpressionValidator2.ValidationExpression = calltype2.SelectedValue '"^[a-zA-Z0-9]{26}$"
        Else
            callID2.Text = ""
            RequiredFieldValidator3.Enabled = False
            RegularExpressionValidator2.Enabled = False
        End If

        Page.Validate()

        '  MsgBox("validating button 2...")
        '   MsgBox("found = " & found)
        If (Not Page.IsValid) Then
            Dim msg As String
            msg = ""
            ' Loop through all validation controls to see which 
            ' generated the error(s).
            Dim oValidator As IValidator
            For Each oValidator In Validators
                If oValidator.IsValid = False Then
                    msg = msg & "vbCrLf<br />" & oValidator.ErrorMessage
                End If
            Next
            '     MsgBox(msg)
        End If

        If Page.IsValid Then
            '   MsgBox("# of coaching reasons =" & found & "- validating....")
            Randomize()
            digit = (Int(Rnd() * 1000000)).ToString
            Label160.Text = "eCL-" & Label17.Text & "-" & digit 'New String(word)

            Dim mailString As String
            Dim statusName As String

            ' EC.sp_Select_Email_Attributes
            SqlDataSource25.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource25.SelectParameters("intSourceIDin").DefaultValue = howid2.SelectedValue

            If (cseradio2.SelectedValue = "Yes") Then
                SqlDataSource25.SelectParameters("bitisCSEin").DefaultValue = True
            Else
                SqlDataSource25.SelectParameters("bitisCSEin").DefaultValue = False
            End If

            GridView8.DataSource = SqlDataSource25
            GridView8.DataBind()

            statusName = (CType(GridView8.Rows(0).FindControl("statusName"), Label).Text)
            Label6.Text = statusName '"Pending Supervisor Review"
            Label158.Text = (CType(GridView8.Rows(0).FindControl("statusID"), Label).Text) '6 '"Pending Supervisor Review"

            If (Label158.Text <> 1) Then
                strPerson = Replace(Label23.Text, "'", "")
                Select Case (CType(GridView8.Rows(0).FindControl("receiver"), Label).Text)
                    Case "Employee"
                        strEmail = LCase(Label19.Text)
                    Case "Supervisor"
                        strEmail = LCase(Label36.Text)
                    Case "Manager"
                        strEmail = LCase(Label55.Text)
                    Case Else
                        strEmail = LCase(Label19.Text)
                End Select

                If ((CType(GridView8.Rows(0).FindControl("isCC"), Label).Text) = "1") Then
                    Select Case (CType(GridView8.Rows(0).FindControl("ccReceiver"), Label).Text)
                        Case "Employee"
                            strCopy = LCase(Label19.Text)
                        Case "Supervisor"
                            strCopy = LCase(Label36.Text)
                        Case "Manager"
                            strCopy = LCase(Label55.Text)
                    End Select
                End If

                strFormID = Label160.Text
                strSubject = "eCL: " & statusName & " (" & strPerson & ")"
                mailString = (CType(GridView8.Rows(0).FindControl("mailText"), Label).Text)
                mailString = Replace(mailString, "strDateTime", DateTime.Now().ToString)
                mailString = Replace(mailString, "strPerson", strPerson)
                strCtrMessage = mailString & "  <br /><br />" & vbCrLf _
    & "  <a href=""https://f3420-mwbp11.vangent.local/coach/default.aspx"" target=""_blank"">Please click here to open the coaching application and select the &#39;My Dashboard&#39; tab to view the below form ID for details.</a>"
            End If

            Label58.Text = Date1.Text 'DateTime.Now.ToString()
            Label60.Text = howid2.SelectedValue

            If (RadioButton3.Checked) Then
                Label62.Text = calltype2.SelectedValue ' RadioButton3.Checked
                Label82.Text = callID2.Text
            End If

            Label68.Text = TextBox5.Text
            If (Len(Label68.Text) > 3000) Then
                Label68.Text = Left(Label68.Text, 3000)
            End If

            Label82.Text = Server.HtmlEncode(Label82.Text)
            Label82.Text = Replace(Label82.Text, "’", "&rsquo;")
            Label82.Text = Replace(Label82.Text, "‘", "&lsquo;")
            Label82.Text = Replace(Label82.Text, "'", "&prime;")
            Label82.Text = Replace(Label82.Text, Chr(147), "&ldquo;")
            Label82.Text = Replace(Label82.Text, Chr(148), "&rdquo;")
            Label82.Text = Replace(Label82.Text, "-", "&ndash;")

            Label68.Text = Server.HtmlEncode(Label68.Text)
            Label68.Text = Replace(Label68.Text, "’", "&rsquo;")
            Label68.Text = Replace(Label68.Text, "‘", "&lsquo;")
            Label68.Text = Replace(Label68.Text, "'", "&prime;")
            Label68.Text = Replace(Label68.Text, Chr(147), "&ldquo;")
            Label68.Text = Replace(Label68.Text, Chr(148), "&rdquo;")
            Label68.Text = Replace(Label68.Text, "-", "&ndash;")

            ' EC.sp_InsertInto_Coaching_Log
            SqlDataSource6.InsertParameters("nvcEmplanID").DefaultValue = Label17.Text
            SqlDataSource6.InsertParameters("nvcFormName").DefaultValue = Label160.Text '"eCL-" & lan & numCount.Text

            modtype = Split(DropDownList3.SelectedItem.Value, "-", -1, 1)
            If (modtype(5) = 1) Then
                SqlDataSource6.InsertParameters("nvcProgramName").DefaultValue = programList.SelectedValue
            Else
                SqlDataSource6.InsertParameters("nvcProgramName").DefaultValue = ""
            End If

            If (modtype(6) = 1) Then
                SqlDataSource6.InsertParameters("Behaviour").DefaultValue = behaviorList.SelectedValue
            Else
                SqlDataSource6.InsertParameters("Behaviour").DefaultValue = ""
            End If

            SqlDataSource6.InsertParameters("intSourceID").DefaultValue = Label60.Text
            SqlDataSource6.InsertParameters("intStatusID").DefaultValue = Label158.Text
            SqlDataSource6.InsertParameters("nvcSubmitter").DefaultValue = lan
            SqlDataSource6.InsertParameters("dtmEventDate").DefaultValue = CDate(Label58.Text)
            SqlDataSource6.InsertParameters("dtmCoachingDate").DefaultValue = "" 'DateTime.Now() 'remove
            If (RadioButton3.Checked) Then
                Select Case calltype2.SelectedItem.Text 'Label62.Text
                    Case "Avoke"
                        SqlDataSource6.InsertParameters("bitisAvokeID").DefaultValue = True
                        SqlDataSource6.InsertParameters("nvcAvokeID").DefaultValue = Label82.Text
                        SqlDataSource6.InsertParameters("bitisVerintID").DefaultValue = False
                        SqlDataSource6.InsertParameters("nvcVerintID").DefaultValue = ""
                        SqlDataSource6.InsertParameters("bitisUCID").DefaultValue = False
                        SqlDataSource6.InsertParameters("nvcUCID").DefaultValue = ""
                        SqlDataSource6.InsertParameters("bitisNGDActivityID").DefaultValue = False
                        SqlDataSource6.InsertParameters("nvcNGDActivityID").DefaultValue = ""
                    Case "Verint"
                        SqlDataSource6.InsertParameters("bitisVerintID").DefaultValue = True
                        SqlDataSource6.InsertParameters("nvcVerintID").DefaultValue = Label82.Text
                        SqlDataSource6.InsertParameters("bitisAvokeID").DefaultValue = False
                        SqlDataSource6.InsertParameters("nvcAvokeID").DefaultValue = ""
                        SqlDataSource6.InsertParameters("bitisUCID").DefaultValue = False
                        SqlDataSource6.InsertParameters("nvcUCID").DefaultValue = ""
                        SqlDataSource6.InsertParameters("bitisNGDActivityID").DefaultValue = False
                        SqlDataSource6.InsertParameters("nvcNGDActivityID").DefaultValue = ""
                    Case "UCID"
                        SqlDataSource6.InsertParameters("bitisUCID").DefaultValue = True
                        SqlDataSource6.InsertParameters("nvcUCID").DefaultValue = Label82.Text
                        SqlDataSource6.InsertParameters("bitisVerintID").DefaultValue = False
                        SqlDataSource6.InsertParameters("nvcVerintID").DefaultValue = ""
                        SqlDataSource6.InsertParameters("bitisAvokeID").DefaultValue = False
                        SqlDataSource6.InsertParameters("nvcAvokeID").DefaultValue = ""
                        SqlDataSource6.InsertParameters("bitisNGDActivityID").DefaultValue = False
                        SqlDataSource6.InsertParameters("nvcNGDActivityID").DefaultValue = ""
                    Case "NGD ID"
                        SqlDataSource6.InsertParameters("bitisNGDActivityID").DefaultValue = True
                        SqlDataSource6.InsertParameters("nvcNGDActivityID").DefaultValue = Label82.Text
                        SqlDataSource6.InsertParameters("bitisVerintID").DefaultValue = False
                        SqlDataSource6.InsertParameters("nvcVerintID").DefaultValue = ""
                        SqlDataSource6.InsertParameters("bitisUCID").DefaultValue = False
                        SqlDataSource6.InsertParameters("nvcUCID").DefaultValue = ""
                        SqlDataSource6.InsertParameters("bitisAvokeID").DefaultValue = False
                        SqlDataSource6.InsertParameters("nvcAvokeID").DefaultValue = ""
                End Select
            Else
                SqlDataSource6.InsertParameters("bitisAvokeID").DefaultValue = False
                SqlDataSource6.InsertParameters("nvcAvokeID").DefaultValue = ""
                SqlDataSource6.InsertParameters("bitisVerintID").DefaultValue = False
                SqlDataSource6.InsertParameters("nvcVerintID").DefaultValue = ""
                SqlDataSource6.InsertParameters("bitisUCID").DefaultValue = False
                SqlDataSource6.InsertParameters("nvcUCID").DefaultValue = ""
                SqlDataSource6.InsertParameters("bitisNGDActivityID").DefaultValue = False
                SqlDataSource6.InsertParameters("nvcNGDActivityID").DefaultValue = ""
            End If

            Dim x
            Dim a, b, c
            For x = 0 To (found - 1)
                a = "intCoachReasonID" & x + 1
                b = "nvcSubCoachReasonID" & x + 1
                c = "nvcValue" & x + 1

                SqlDataSource6.InsertParameters(a).DefaultValue = coachR(x, 0)
                SqlDataSource6.InsertParameters(b).DefaultValue = coachR(x, 1)
                SqlDataSource6.InsertParameters(c).DefaultValue = coachR(x, 2)
            Next

            If (found < 12) Then
                For x = (found + 1) To 12 '(12 - found)
                    a = "intCoachReasonID" & x
                    b = "nvcSubCoachReasonID" & x
                    c = "nvcValue" & x

                    SqlDataSource6.InsertParameters(a).DefaultValue = ""
                    SqlDataSource6.InsertParameters(b).DefaultValue = ""
                    SqlDataSource6.InsertParameters(c).DefaultValue = ""
                Next
            End If

            SqlDataSource6.InsertParameters("nvcDescription").DefaultValue = Label68.Text
            SqlDataSource6.InsertParameters("nvcCoachingNotes").DefaultValue = ""
            SqlDataSource6.InsertParameters("bitisVerified").DefaultValue = True
            SqlDataSource6.InsertParameters("dtmSubmittedDate").DefaultValue = CDate(DateTime.Now())
            SqlDataSource6.InsertParameters("dtmStartDate").DefaultValue = CDate(Label10.Text)
            SqlDataSource6.InsertParameters("dtmSupReviewedAutoDate").DefaultValue = ""

            If (cseradio2.SelectedValue = "Yes") Then
                SqlDataSource6.InsertParameters("bitisCSE").DefaultValue = True
            Else
                SqlDataSource6.InsertParameters("bitisCSE").DefaultValue = False
            End If

            SqlDataSource6.InsertParameters("dtmMgrReviewManualDate").DefaultValue = ""
            SqlDataSource6.InsertParameters("dtmMgrReviewAutoDate").DefaultValue = ""
            SqlDataSource6.InsertParameters("nvcMgrNotes").DefaultValue = ""
            SqlDataSource6.InsertParameters("bitisCSRAcknowledged").DefaultValue = "" 'False
            SqlDataSource6.InsertParameters("dtmCSRReviewAutoDate").DefaultValue = ""
            SqlDataSource6.InsertParameters("nvcCSRComments").DefaultValue = ""
            SqlDataSource6.InsertParameters("bitEmailSent").DefaultValue = "True" 'mailSent
            SqlDataSource6.InsertParameters("ModuleID").DefaultValue = moduleIDlbl.Text 'DropDownList3.SelectedItem.Text

            SqlDataSource6.Insert()
            If (Label158.Text <> 1) Then
                SendMail_OnInsert()
            End If

            FromURL = Request.ServerVariables("URL")
            Response.Redirect("next1.aspx?FromURL=" & FromURL)
        Else
            Label2.Text = "Please correct all fields indicated in red to proceed."
        End If
    End Sub

    Protected Sub Button5_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button5.Click
        Dim lan As String = TryCast(Session("eclUser"), User).LanID
        Dim formType = "Direct"

        RequiredFieldValidator18.Enabled = True
        CompareValidator2.Enabled = True
        RequiredFieldValidator49.Enabled = True
        RequiredFieldValidator50.Enabled = True
        RequiredFieldValidator24.Enabled = True
        CustomValidator2.Enabled = True

        If (((lan = LCase(Label28.Text)) Or (lan = LCase(Label47.Text))) And (modtype(4) = 1)) Then
            warngroup2.Visible = True

            If (warnlist.SelectedIndex = 0) Then
                warngroup1.Style("display") = "inline" 'inline
                warngroup1.Style("visibility") = "visible" 'visible

                Labe27.Text = "Enter/Select the date the warning was issued:"
                RequiredFieldValidator18.Text = "Enter a valid warning date."

                Panel6.Style("display") = "none"
                Panel6.Style("visibility") = "hidden"
                Panel7.Style("display") = "none"
                Panel7.Style("visibility") = "hidden"

                nowarn.Style("display") = "none" 'inline
                nowarn.Style("visibility") = "hidden" 'visible

                RequiredFieldValidator49.Enabled = False
                RequiredFieldValidator50.Enabled = False

                CustomValidator2.Enabled = False
            Else
                warngroup1.Style("display") = "none" 'inline
                warngroup1.Style("visibility") = "hidden" 'visible

                Panel6.Style("display") = "inline"
                Panel6.Style("visibility") = "visible"
                Panel7.Style("display") = "inline"
                Panel7.Style("visibility") = "visible"

                CustomValidator2.Enabled = True

                RequiredFieldValidator11.Enabled = False
                CustomValidator3.Enabled = False

                Labe27.Text = "Enter/Select the date of coaching:"
                RequiredFieldValidator18.Text = "Enter a valid coaching date."
            End If
        Else
            warngroup2.Visible = False

            Panel6.Style("display") = "inline"
            Panel6.Style("visibility") = "visible"
            Panel7.Style("display") = "inline"
            Panel7.Style("visibility") = "visible"

            nowarn.Style("display") = "inline" 'inline
            nowarn.Style("visibility") = "visible" 'visible

            RequiredFieldValidator49.Enabled = True
            RequiredFieldValidator50.Enabled = True

            CustomValidator2.Enabled = True

            RequiredFieldValidator11.Enabled = False
            CustomValidator3.Enabled = False
        End If

        '''loop through GridView2
        Dim m As Label
        Dim d As CheckBox
        Dim f As RadioButtonList
        Dim g As ListBox
        Dim h As ListBox
        Dim j As RequiredFieldValidator
        Dim state As String

        state = "closed"
        found = 0
        If ((warngroup2.Visible = False) Or (warnlist.SelectedIndex = 1)) Then
            'disarm validation for warning group
            TextBox2.Text = "valid"
            RequiredFieldValidator9.Enabled = False

            For i As Integer = 0 To (grid.Rows.Count - 1)
                For k As Integer = 0 To (grid.Columns.Count - 1)
                    Dim childc As Control
                    For Each childc In grid.Rows(i).Cells(k).Controls
                        If (TypeOf childc Is RequiredFieldValidator) Then
                            j = CType(childc, RequiredFieldValidator)
                            If (state = "open") Then
                                j.Enabled = True
                            Else
                                j.Enabled = False
                            End If
                        End If

                        If ((k = 0) And ((InStr(1, childc.ClientID, "sub1", 1) > 0))) Then
                            Dim childgc As Control
                            For Each childgc In childc.Controls
                                If (InStr(1, childgc.ClientID, "SubReasons", 1) > 0) Then
                                    h = CType(childgc, ListBox)
                                    Dim b
                                    b = CType(h.Parent, Panel)
                                    If (state = "open") Then
                                        b.style("display") = "inline"
                                        b.style("visibility") = "visible"
                                    Else
                                        b.style("display") = "none"
                                        b.style("visibility") = "hidden"
                                    End If

                                    If (TypeOf childgc Is ListBox) Then
                                        g = CType(childgc, ListBox)
                                        Dim x
                                        Dim z
                                        z = ""
                                        For x = 0 To g.Items.Count - 1
                                            If ((state = "open") And (Len(g.Items(x).Value) > 0) And (g.Items(x).Selected = True)) Then
                                                z = z & g.Items(x).Value & ","
                                            End If
                                        Next
                                        If (Len(z) > 0) Then
                                            coachR(found, 1) = Left(z, Len(z) - 1) 'g.Items(x).Value  '
                                        End If
                                    End If
                                End If

                                If (TypeOf childgc Is RequiredFieldValidator) Then
                                    j = CType(childgc, RequiredFieldValidator)
                                    If (state = "open") Then
                                        j.Enabled = True
                                    Else
                                        j.Enabled = False
                                    End If
                                End If
                            Next
                        End If

                        If (TypeOf childc Is CheckBox) Then
                            d = CType(childc, CheckBox)
                            If (d.Checked) Then
                                state = "open"
                            Else
                                state = "closed"
                            End If
                        End If

                        If (TypeOf childc Is Label) Then
                            m = CType(childc, Label)
                            If ((state = "open") And (InStr(1, m.ClientID, "Label65", 1) > 0)) Then
                                coachR(found, 0) = m.Text
                            End If
                        End If

                        If (TypeOf childc Is RadioButtonList) Then
                            f = CType(childc, RadioButtonList)
                            If (state = "open") Then
                                f.Enabled = True
                                If (f.SelectedIndex <> -1) Then
                                    coachR(found, 2) = (f.SelectedItem.ToString())
                                End If
                            Else
                                f.Enabled = False
                            End If

                            For Each item As Object In f.Items
                                If (InStr(1, item.Text, "!", 1) > 0) Then
                                    item.Attributes.Add("style", "visibility: hidden;")
                                End If
                            Next
                        End If
                    Next ' end of child list
                Next ' end of column

                If (state = "open") Then
                    found = found + 1
                End If
            Next ' end of row
        Else
            'disarm validation for regular coaching
            TextBox1.Text = "valid"
            RequiredFieldValidator28.Enabled = False

            'warning field collection
            If (warnReasons.SelectedValue <> "Select...") Then
                coachR(0, 1) = warnReasons.SelectedValue
            End If

            If (warnlist2.SelectedValue <> "Select...") Then
                coachR(0, 0) = warnlist2.SelectedValue
            End If

            If ((warnlist2.SelectedValue <> "Select...") And (warnReasons.SelectedValue <> "Select...")) Then
                found = 1
            End If
        End If

        If (warnlist.SelectedIndex = 0) Then
            RequiredFieldValidator24.Enabled = False
            RequiredFieldValidator21.Enabled = False
            RegularExpressionValidator1.Enabled = False
            TextBox1.Text = "valid"
            RequiredFieldValidator28.Enabled = False

            RequiredFieldValidator11.Enabled = True
            CustomValidator3.Enabled = True

            If (found = 0) Then
                TextBox2.Text = ""
                RequiredFieldValidator9.Enabled = True
            Else
                TextBox2.Text = "valid"
                RequiredFieldValidator9.Enabled = False
            End If
        Else
            RequiredFieldValidator24.Enabled = True
            If (found = 0) Then
                TextBox1.Text = ""
                RequiredFieldValidator28.Enabled = True
            Else
                TextBox1.Text = "valid"
                RequiredFieldValidator28.Enabled = False
            End If

            RequiredFieldValidator11.Enabled = False
            CustomValidator3.Enabled = False

            If (RadioButton1.Checked = True) Then
                RequiredFieldValidator21.Enabled = True
                RegularExpressionValidator1.Enabled = True
                RegularExpressionValidator1.ValidationExpression = calltype.SelectedValue '"^[a-zA-Z0-9]{26}$"
            Else
                callID.Text = ""
                RequiredFieldValidator21.Enabled = False
                RegularExpressionValidator1.Enabled = False
            End If
        End If

        Page.Validate()

        If (Not Me.IsValid) Then
            Dim msg As String
            msg = ""
            ' Loop through all validation controls to see which 
            ' generated the error(s).
            Dim oValidator As IValidator
            For Each oValidator In Validators
                If oValidator.IsValid = False Then
                    msg = msg & "vbCrLf<br />" & oValidator.ErrorMessage
                End If
            Next
        End If

        If Page.IsValid Then
            Randomize()
            digit = (Int(Rnd() * 1000000)).ToString
            Label160.Text = "eCL-" & Label17.Text & "-" & digit 'New String(word)

            Dim mailString As String
            Dim statusName2 As String

            ' EC.sp_Select_Email_Attributes
            SqlDataSource25.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

            If (warnlist.SelectedIndex = 0) Then
                SqlDataSource25.SelectParameters("intSourceIDin").DefaultValue = 120
            Else
                SqlDataSource25.SelectParameters("intSourceIDin").DefaultValue = howid.SelectedValue
            End If

            If (cseradio.SelectedValue = "Yes") Then
                SqlDataSource25.SelectParameters("bitisCSEin").DefaultValue = True
            Else
                SqlDataSource25.SelectParameters("bitisCSEin").DefaultValue = False

            End If

            GridView8.DataSource = SqlDataSource25
            GridView8.DataBind()
            statusName2 = (CType(GridView8.Rows(0).FindControl("statusName"), Label).Text)

            Label6.Text = statusName2 '"Pending Supervisor Review"
            Label156.Text = (CType(GridView8.Rows(0).FindControl("statusID"), Label).Text) '6 '"Pending Supervisor Review"
            If (Label156.Text <> 1) Then
                strPerson = Replace(Label23.Text, "'", "")
                Select Case (CType(GridView8.Rows(0).FindControl("receiver"), Label).Text)
                    Case "Employee"
                        strEmail = LCase(Label19.Text)
                    Case "Supervisor"
                        strEmail = LCase(Label36.Text)
                    Case "Manager"
                        strEmail = LCase(Label55.Text)
                    Case Else
                        strEmail = LCase(Label19.Text)
                End Select

                If ((CType(GridView8.Rows(0).FindControl("isCC"), Label).Text) = "1") Then
                    Select Case (CType(GridView8.Rows(0).FindControl("ccReceiver"), Label).Text)
                        Case "Employee"
                            strCopy = LCase(Label19.Text)
                        Case "Supervisor"
                            strCopy = LCase(Label36.Text)
                        Case "Manager"
                            strCopy = LCase(Label55.Text)
                    End Select
                End If

                strFormID = Label160.Text
                strSubject = "eCL: " & statusName2 & " (" & strPerson & ")"

                mailString = (CType(GridView8.Rows(0).FindControl("mailText"), Label).Text)
                mailString = Replace(mailString, "strDateTime", DateTime.Now().ToString)
                mailString = Replace(mailString, "strPerson", strPerson)

                strCtrMessage = mailString & "  <br /><br />" & vbCrLf _
             & "  <a href=""https://f3420-mwbp11.vangent.local/coach/default.aspx"" target=""_blank"">Please click here to open the coaching application and select the &#39;My Dashboard&#39; tab to view the below form ID for details.</a>"
            End If

            Label69.Text = Date2.Text 'DateTime.Now.ToString()
            If (warnlist.SelectedIndex = 0) Then
                Label71.Text = 120
            Else
                Label71.Text = howid.SelectedValue
                If (RadioButton1.Checked) Then
                    Label62.Text = calltype.SelectedValue ' RadioButton1.Checked
                    Label82.Text = callID.Text
                End If

                Label93.Text = TextBox11.Text
                If (Len(Label93.Text) > 3000) Then
                    Label93.Text = Left(Label93.Text, 3000)
                End If

                Label95.Text = TextBox12.Text
                If (Len(Label95.Text) > 3000) Then
                    Label95.Text = Left(Label95.Text, 3000)
                End If

                Label93.Text = Server.HtmlEncode(Label93.Text)
                Label93.Text = Replace(Label93.Text, "’", "&rsquo;")
                Label93.Text = Replace(Label93.Text, "‘", "&lsquo;")
                Label93.Text = Replace(Label93.Text, "'", "&prime;")
                Label93.Text = Replace(Label93.Text, Chr(147), "&ldquo;")
                Label93.Text = Replace(Label93.Text, Chr(148), "&rdquo;")
                Label93.Text = Replace(Label93.Text, "-", "&ndash;")

                Label95.Text = Server.HtmlEncode(Label95.Text)
                Label95.Text = Replace(Label95.Text, "’", "&rsquo;")
                Label95.Text = Replace(Label95.Text, "‘", "&lsquo;")
                Label95.Text = Replace(Label95.Text, "'", "&prime;")
                Label95.Text = Replace(Label95.Text, Chr(147), "&ldquo;")
                Label95.Text = Replace(Label95.Text, Chr(148), "&rdquo;")
                Label95.Text = Replace(Label95.Text, "-", "&ndash;")
            End If

            modtype = Split(DropDownList3.SelectedItem.Value, "-", -1, 1)
            If (warnlist.SelectedIndex = 0) Then
                ' EC.sp_InsertInto_Warning_Log
                SqlDataSource27.InsertParameters("nvcEmplanID").DefaultValue = Label17.Text
                SqlDataSource27.InsertParameters("nvcFormName").DefaultValue = Label160.Text '"eCL-" & lan & numCount.Text
                If (modtype(0) = 1) Then
                    SqlDataSource27.InsertParameters("SiteID").DefaultValue = DropDownList1.SelectedValue 'Label49.Text 'Label49.Text
                Else
                    SqlDataSource27.InsertParameters("SiteID").DefaultValue = "" 'Label49.Text 'Label49.Text
                End If

                SqlDataSource27.InsertParameters("nvcSubmitter").DefaultValue = lan
                SqlDataSource27.InsertParameters("dtmEventDate").DefaultValue = CDate(Label69.Text)
                SqlDataSource27.InsertParameters("intCoachReasonID1").DefaultValue = coachR(0, 0)
                SqlDataSource27.InsertParameters("nvcSubCoachReasonID1").DefaultValue = coachR(0, 1)

                If (modtype(5) = 1) Then
                    SqlDataSource27.InsertParameters("nvcProgramName").DefaultValue = programList.SelectedValue
                Else
                    SqlDataSource27.InsertParameters("nvcProgramName").DefaultValue = ""
                End If

                SqlDataSource27.InsertParameters("dtmSubmittedDate").DefaultValue = DateTime.Now()
                SqlDataSource27.InsertParameters("ModuleID").DefaultValue = moduleIDlbl.Text 'DropDownList3.SelectedItem.Text

                SqlDataSource27.Insert()

                'submit data
                If (Len(Label169.Text) = 0) Then
                    FromURL = Request.ServerVariables("URL")
                    Response.Redirect("next1.aspx?FromURL=" & FromURL)
                End If
            Else
                ' EC.sp_InsertInto_Coaching_Log
                SqlDataSource6.InsertParameters("nvcEmplanID").DefaultValue = Label17.Text
                SqlDataSource6.InsertParameters("nvcFormName").DefaultValue = Label160.Text '"eCL-" & lan & numCount.Text

                If (modtype(5) = 1) Then
                    SqlDataSource6.InsertParameters("nvcProgramName").DefaultValue = programList.SelectedValue
                Else
                    SqlDataSource6.InsertParameters("nvcProgramName").DefaultValue = ""
                End If

                If (modtype(6) = 1) Then
                    SqlDataSource6.InsertParameters("Behaviour").DefaultValue = behaviorList.SelectedValue
                Else
                    SqlDataSource6.InsertParameters("Behaviour").DefaultValue = ""
                End If

                SqlDataSource6.InsertParameters("intSourceID").DefaultValue = Label71.Text
                SqlDataSource6.InsertParameters("intStatusID").DefaultValue = Label156.Text

                If (modtype(0) = 1) Then
                    SqlDataSource6.InsertParameters("SiteID").DefaultValue = DropDownList1.SelectedValue 'Label49.Text 'Label49.Text
                Else
                    SqlDataSource6.InsertParameters("SiteID").DefaultValue = "" 'Label49.Text 'Label49.Text
                End If

                SqlDataSource6.InsertParameters("nvcSubmitter").DefaultValue = lan
                SqlDataSource6.InsertParameters("dtmEventDate").DefaultValue = ""
                SqlDataSource6.InsertParameters("dtmCoachingDate").DefaultValue = CDate(Label69.Text) 'DateTime.Now() 'remove

                If (RadioButton1.Checked) Then
                    Select Case calltype.SelectedItem.Text 'Label62.Text
                        Case "Avoke"
                            SqlDataSource6.InsertParameters("bitisAvokeID").DefaultValue = True
                            SqlDataSource6.InsertParameters("nvcAvokeID").DefaultValue = Label82.Text
                            SqlDataSource6.InsertParameters("bitisVerintID").DefaultValue = False
                            SqlDataSource6.InsertParameters("nvcVerintID").DefaultValue = ""
                            SqlDataSource6.InsertParameters("bitisUCID").DefaultValue = False
                            SqlDataSource6.InsertParameters("nvcUCID").DefaultValue = ""
                            SqlDataSource6.InsertParameters("bitisNGDActivityID").DefaultValue = False
                            SqlDataSource6.InsertParameters("nvcNGDActivityID").DefaultValue = ""
                        Case "Verint"
                            SqlDataSource6.InsertParameters("bitisVerintID").DefaultValue = True
                            SqlDataSource6.InsertParameters("nvcVerintID").DefaultValue = Label82.Text
                            SqlDataSource6.InsertParameters("bitisAvokeID").DefaultValue = False
                            SqlDataSource6.InsertParameters("nvcAvokeID").DefaultValue = ""
                            SqlDataSource6.InsertParameters("bitisUCID").DefaultValue = False
                            SqlDataSource6.InsertParameters("nvcUCID").DefaultValue = ""
                            SqlDataSource6.InsertParameters("bitisNGDActivityID").DefaultValue = False
                            SqlDataSource6.InsertParameters("nvcNGDActivityID").DefaultValue = ""
                        Case "UCID"
                            SqlDataSource6.InsertParameters("bitisUCID").DefaultValue = True
                            SqlDataSource6.InsertParameters("nvcUCID").DefaultValue = Label82.Text
                            SqlDataSource6.InsertParameters("bitisVerintID").DefaultValue = False
                            SqlDataSource6.InsertParameters("nvcVerintID").DefaultValue = ""
                            SqlDataSource6.InsertParameters("bitisAvokeID").DefaultValue = False
                            SqlDataSource6.InsertParameters("nvcAvokeID").DefaultValue = ""
                            SqlDataSource6.InsertParameters("bitisNGDActivityID").DefaultValue = False
                            SqlDataSource6.InsertParameters("nvcNGDActivityID").DefaultValue = ""

                        Case "NGD ID"
                            SqlDataSource6.InsertParameters("bitisNGDActivityID").DefaultValue = True
                            SqlDataSource6.InsertParameters("nvcNGDActivityID").DefaultValue = Label82.Text
                            SqlDataSource6.InsertParameters("bitisVerintID").DefaultValue = False
                            SqlDataSource6.InsertParameters("nvcVerintID").DefaultValue = ""
                            SqlDataSource6.InsertParameters("bitisUCID").DefaultValue = False
                            SqlDataSource6.InsertParameters("nvcUCID").DefaultValue = ""
                            SqlDataSource6.InsertParameters("bitisAvokeID").DefaultValue = False
                            SqlDataSource6.InsertParameters("nvcAvokeID").DefaultValue = ""
                    End Select
                Else
                    SqlDataSource6.InsertParameters("bitisAvokeID").DefaultValue = False
                    SqlDataSource6.InsertParameters("nvcAvokeID").DefaultValue = ""
                    SqlDataSource6.InsertParameters("bitisVerintID").DefaultValue = False
                    SqlDataSource6.InsertParameters("nvcVerintID").DefaultValue = ""
                    SqlDataSource6.InsertParameters("bitisUCID").DefaultValue = False
                    SqlDataSource6.InsertParameters("nvcUCID").DefaultValue = ""
                    SqlDataSource6.InsertParameters("bitisNGDActivityID").DefaultValue = False
                    SqlDataSource6.InsertParameters("nvcNGDActivityID").DefaultValue = ""
                End If

                Dim x
                Dim a, b, c
                For x = 0 To (found - 1)
                    a = "intCoachReasonID" & x + 1
                    b = "nvcSubCoachReasonID" & x + 1
                    c = "nvcValue" & x + 1

                    SqlDataSource6.InsertParameters(a).DefaultValue = coachR(x, 0)
                    SqlDataSource6.InsertParameters(b).DefaultValue = coachR(x, 1)
                    SqlDataSource6.InsertParameters(c).DefaultValue = coachR(x, 2)
                Next

                If (found < 12) Then
                    For x = (found + 1) To 12 '(12 - found)
                        a = "intCoachReasonID" & x
                        b = "nvcSubCoachReasonID" & x
                        c = "nvcValue" & x

                        SqlDataSource6.InsertParameters(a).DefaultValue = ""
                        SqlDataSource6.InsertParameters(b).DefaultValue = ""
                        SqlDataSource6.InsertParameters(c).DefaultValue = ""
                    Next
                End If

                SqlDataSource6.InsertParameters("nvcDescription").DefaultValue = Label93.Text
                SqlDataSource6.InsertParameters("nvcCoachingNotes").DefaultValue = Label95.Text
                SqlDataSource6.InsertParameters("bitisVerified").DefaultValue = True
                SqlDataSource6.InsertParameters("dtmSubmittedDate").DefaultValue = DateTime.Now()
                SqlDataSource6.InsertParameters("dtmStartDate").DefaultValue = CDate(Label10.Text)
                SqlDataSource6.InsertParameters("dtmSupReviewedAutoDate").DefaultValue = ""

                If (cseradio.SelectedValue = "Yes") Then
                    SqlDataSource6.InsertParameters("bitisCSE").DefaultValue = True 'False
                Else
                    SqlDataSource6.InsertParameters("bitisCSE").DefaultValue = False 'False
                End If

                SqlDataSource6.InsertParameters("dtmMgrReviewManualDate").DefaultValue = ""
                SqlDataSource6.InsertParameters("dtmMgrReviewAutoDate").DefaultValue = ""
                SqlDataSource6.InsertParameters("nvcMgrNotes").DefaultValue = ""
                SqlDataSource6.InsertParameters("bitisCSRAcknowledged").DefaultValue = "" 'False
                SqlDataSource6.InsertParameters("dtmCSRReviewAutoDate").DefaultValue = ""
                SqlDataSource6.InsertParameters("nvcCSRComments").DefaultValue = ""
                SqlDataSource6.InsertParameters("bitEmailSent").DefaultValue = "True" 'mailSent
                SqlDataSource6.InsertParameters("ModuleID").DefaultValue = moduleIDlbl.Text 'DropDownList3.SelectedItem.Text
                SqlDataSource6.Insert()

                If (Label156.Text <> 1) Then
                    SendMail_OnInsert()
                End If

                'submit data
                FromURL = Request.ServerVariables("URL")
                Response.Redirect("next1.aspx?FromURL=" & FromURL)
            End If ' if warning is yes
        Else
            Label169.Text = "Please correct all fields indicated in red to proceed."
        End If
    End Sub

    Sub SendMail_OnInsert()
        Dim myMessage As System.Net.Mail.MailMessage = New System.Net.Mail.MailMessage()
        Dim mySmtpClient As New System.Net.Mail.SmtpClient()
        Dim mbody As String



        myMessage.From = New System.Net.Mail.MailAddress("VIP@gdit.com", "eCoaching Log")
        myMessage.To.Add(New MailAddress(strEmail))
        If (copy = True) Then
            myMessage.CC.Add(New MailAddress(strCopy))
        End If

        myMessage.Subject = strSubject ''

        mbody = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">" & vbCrLf _
        & "<html>" & vbCrLf _
        & "<head>" & vbCrLf _
        & " <title>eCoaching Log Automated Messaging</title>" & vbCrLf _
        & " <meta http-equiv=Content-Type content=""text/html; charset=iso-8859-1"">" & vbCrLf _
        & "</head>" & vbCrLf _
        & "<body style=""font-family: Tahoma,sans-serif; font-size: 10.0pt;"">" & vbCrLf _
        & " <p>** This is an automated email. Do not reply to this email. **</p>" & vbCrLf _
        & " <p>" & vbCrLf _
        & strCtrMessage & vbCrLf _
        & "  <br />" & vbCrLf _
        & "  Form ID: " & strFormID & vbCrLf _
        & "  <br /> <br />" & vbCrLf _
        & "  (Please do not respond to this automated notification)" & vbCrLf _
        & " <br /> <br />" & vbCrLf _
        & " Thank you," & vbCrLf _
        & " <br /> eCoaching Log Team <br />" & vbCrLf

        Dim htmlView As System.Net.Mail.AlternateView = System.Net.Mail.AlternateView.CreateAlternateViewFromString(mbody & "<img src=cid:HDIImage></body></html>", Nothing, "text/html")
        Dim ImagePath As String = Server.MapPath("images") & "\BCC-eCL-LOGO-10142011-185x40.png"
        Dim imageResource As New System.Net.Mail.LinkedResource(ImagePath, "image/png")

        imageResource.TransferEncoding = Net.Mime.TransferEncoding.Base64
        imageResource.ContentId = "HDIImage"
        htmlView.LinkedResources.Add(imageResource)
        myMessage.AlternateViews.Add(htmlView)

        'uncomment/comment to send mail/setup for dev
        'mySmtpClient = New SmtpClient("vadentexp01") ''old
        mySmtpClient = New SmtpClient("smtpout.gdit.com") ''new

        mySmtpClient.Send(myMessage)
    End Sub

    Protected Sub ARC_Selected(ByVal sender As Object, ByVal e As SqlDataSourceStatusEventArgs) Handles SqlDataSource14.Selected
        Label241.Text = e.Command.Parameters("@Indirect@return_value").Value
    End Sub

    Protected Sub CustomValidator1_ServerValidate(ByVal sender As Object, ByVal args As ServerValidateEventArgs)
        ' Indirect must be RadioButton1 or RadioButton2
        args.IsValid = (RadioButton1.Checked Or RadioButton2.Checked)

        If Page.IsValid Then
            If RadioButton1.Checked Then
                RequiredFieldValidator21.Enabled = True
                RegularExpressionValidator1.Enabled = True
            Else
                RequiredFieldValidator21.Enabled = False
                RegularExpressionValidator1.Enabled = False
            End If
        End If
    End Sub

    Protected Sub CustomValidator4_ServerValidate(ByVal sender As Object, ByVal args As ServerValidateEventArgs)
        Dim lan As String = TryCast(Session("eclUser"), User).LanID
        args.IsValid = (LCase(Label17.Text) <> LCase(lan))

        If Not (Page.IsValid) Then
            CustomValidator4.Enabled = False
        Else
            CustomValidator4.Enabled = True
        End If
    End Sub

    Protected Sub CustomValidator2_ServerValidate(ByVal sender As Object, ByVal args As ServerValidateEventArgs)
        ' Direct must be RadioButton3 or RadioButton4
        args.IsValid = (RadioButton3.Checked Or RadioButton4.Checked)

        If Page.IsValid Then
            If RadioButton3.Checked Then
                RequiredFieldValidator3.Enabled = True
                RegularExpressionValidator2.Enabled = True
            Else
                RequiredFieldValidator3.Enabled = False
                RegularExpressionValidator2.Enabled = False
            End If
        End If
    End Sub

    Protected Sub CustomValidator3_ServerValidate(ByVal sender As Object, ByVal args As ServerValidateEventArgs)
        ' Indirect must be RadioButton1 or RadioButton2
        If (warnReasons.Items(0).Selected = True) Then
            args.IsValid = False
        Else
            args.IsValid = True
        End If
    End Sub

    Protected Sub OnRowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs) Handles GridView2.RowDataBound
        Dim lan As String = TryCast(Session("eclUser"), User).LanID

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim rowCheck As CheckBox = e.Row.FindControl("check1")
            Dim rowPanel As Panel = e.Row.FindControl("sub1")
            Dim reason As Label = e.Row.FindControl("Label1")
            Dim rowButtons As RadioButtonList = e.Row.FindControl("buttons1")

            ' EC.sp_Select_Values_By_Reason
            SqlDataSource17.SelectParameters("strReasonin").DefaultValue = reason.Text
            SqlDataSource17.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource17.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

            rowButtons.DataSource = SqlDataSource17
            rowButtons.DataBind()

            Dim subMenu As ListBox = e.Row.FindControl("SubReasons")

            SqlDataSource11.SelectParameters("strReasonin").DefaultValue = reason.Text
            SqlDataSource11.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource11.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource11.SelectParameters("nvcEmpLanIDin").DefaultValue = lan

            subMenu.DataSource = SqlDataSource11
            subMenu.DataBind()

            rowCheck.Attributes.Add("onclick", "javascript: togglemenu(" & rowCheck.ClientID & "," & rowPanel.ClientID & "," & rowButtons.ClientID & "," & subMenu.ClientID & ");")

            For Each item As Object In rowButtons.Items
                '   MsgBox("first" & rowButtons.Items(0).Text & "-" & rowButtons.Items(1).Text)
                '  MsgBox("Second" & rowButtons.Items(0).Value & "-" & rowButtons.Items(1).Value)
                If (Len(rowButtons.Items(0).Text) < 1) Then
                    Select Case rowButtons.Items(1).Text
                        Case "Opportunity"
                            rowButtons.Items(0).Text = "Opportunity"
                            rowButtons.Items(1).Text = "Re!nforcement" 'Reinforcement
                            rowButtons.Items(1).Attributes.Add("style", "visibility: hidden;")
                        Case Else
                            rowButtons.Items(0).Text = "Opportun!ty" 'Opportunity
                            rowButtons.Items(0).Attributes.Add("style", "visibility: hidden;")
                    End Select
                End If
            Next
        End If
    End Sub

    Protected Sub OnRowDataBound2(ByVal sender As Object, ByVal e As GridViewRowEventArgs) Handles GridView4.RowDataBound
        Dim lan As String = TryCast(Session("eclUser"), User).LanID

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim rowCheck As CheckBox = e.Row.FindControl("check1")
            ''  MsgBox(rowCheck.ClientID)
            'rowCheck.ID = "check" & e.Row.RowIndex

            Dim rowPanel As Panel = e.Row.FindControl("sub1")
            Dim reason As Label = e.Row.FindControl("Label1")
            Dim rowButtons As RadioButtonList = e.Row.FindControl("buttons1")

            ' EC.sp_Select_Values_By_Reason
            SqlDataSource16.SelectParameters("strReasonin").DefaultValue = reason.Text
            SqlDataSource16.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource16.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

            rowButtons.DataSource = SqlDataSource16
            rowButtons.DataBind()

            Dim subMenu As ListBox = e.Row.FindControl("SubReasons")

            ' EC.sp_Select_SubCoachingReasons_By_Reason
            SqlDataSource13.SelectParameters("strReasonin").DefaultValue = reason.Text
            SqlDataSource13.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource13.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource13.SelectParameters("nvcEmpLanIDin").DefaultValue = lan

            subMenu.DataSource = SqlDataSource13
            subMenu.DataBind()

            rowCheck.Attributes.Add("onclick", "javascript: togglemenu(" & rowCheck.ClientID & "," & rowPanel.ClientID & "," & rowButtons.ClientID & "," & subMenu.ClientID & ");")
            For Each item As Object In rowButtons.Items
                '   MsgBox("first" & rowButtons.Items(0).Text & "-" & rowButtons.Items(1).Text)
                '  MsgBox("Second" & rowButtons.Items(0).Value & "-" & rowButtons.Items(1).Value)
                If (Len(rowButtons.Items(0).Text) < 1) Then
                    Select Case rowButtons.Items(1).Text
                        Case "Opportunity"
                            rowButtons.Items(0).Text = "Opportunity"
                            rowButtons.Items(1).Text = "Re!nforcement" 'Reinforcement
                            rowButtons.Items(1).Attributes.Add("style", "visibility: hidden;")
                        Case Else
                            rowButtons.Items(0).Text = "Opportun!ty" 'Opportunity
                            rowButtons.Items(0).Attributes.Add("style", "visibility: hidden;")
                    End Select
                End If
            Next
        End If
    End Sub

    Protected Sub OnRowDataBound3(ByVal sender As Object, ByVal e As GridViewRowEventArgs) Handles GridView5.RowDataBound
        Dim lan As String = TryCast(Session("eclUser"), User).LanID

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim rowCheck As CheckBox = e.Row.FindControl("check1")
            ''  MsgBox(rowCheck.ClientID)
            'rowCheck.ID = "check" & e.Row.RowIndex

            Dim rowPanel As Panel = e.Row.FindControl("sub1")
            'rowDiv.ID = "div" & e.Row.RowIndex

            Dim reason As Label = e.Row.FindControl("Label1")
            'MsgBox(reason.Text)

            'MsgBox(rowCheck.ID)
            '' MsgBox(rowPanel.ClientID)

            Dim rowButtons As RadioButtonList = e.Row.FindControl("buttons1")
            ' MsgBox(rowButtons.ClientID)
            'MsgBox("1-" & reason.Text)
            'MsgBox("2-" & RadioButtonList1.SelectedValue)
            'MsgBox("3-" & DropDownList3.SelectedItem.Text)

            ' EC.sp_Select_Values_By_Reason
            SqlDataSource20.SelectParameters("strReasonin").DefaultValue = reason.Text
            SqlDataSource20.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource20.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

            rowButtons.DataSource = SqlDataSource20
            rowButtons.DataBind()

            Dim subMenu As ListBox = e.Row.FindControl("SubReasons")

            'MsgBox(reason.Text)
            ' EC.sp_Select_SubCoachingReasons_By_Reason
            SqlDataSource19.SelectParameters("strReasonin").DefaultValue = reason.Text
            SqlDataSource19.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource19.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource19.SelectParameters("nvcEmpLanIDin").DefaultValue = lan

            subMenu.DataSource = SqlDataSource19
            subMenu.DataBind()

            Dim validation1 As RequiredFieldValidator = e.Row.FindControl("RequiredFieldValidator1")
            Dim validation2 As RequiredFieldValidator = e.Row.FindControl("RequiredFieldValidator2")

            rowCheck.Attributes.Add("onclick", "javascript: togglemenu(" & rowCheck.ClientID & "," & rowPanel.ClientID & "," & rowButtons.ClientID & "," & subMenu.ClientID & ");")

            For Each item As Object In rowButtons.Items
                '   MsgBox("first" & rowButtons.Items(0).Text & "-" & rowButtons.Items(1).Text)
                '  MsgBox("Second" & rowButtons.Items(0).Value & "-" & rowButtons.Items(1).Value)
                If (Len(rowButtons.Items(0).Text) < 1) Then
                    Select Case rowButtons.Items(1).Text
                        Case "Opportunity"
                            rowButtons.Items(0).Text = "Opportunity"
                            rowButtons.Items(1).Text = "Re!nforcement" 'Reinforcement
                            rowButtons.Items(1).Attributes.Add("style", "visibility: hidden;")
                        Case Else
                            rowButtons.Items(0).Text = "Opportun!ty" 'Opportunity
                            rowButtons.Items(0).Attributes.Add("style", "visibility: hidden;")
                    End Select
                End If
            Next
        End If
    End Sub

    Protected Sub OnRowDataBound4(ByVal sender As Object, ByVal e As GridViewRowEventArgs) Handles GridView6.RowDataBound
        Dim lan As String = TryCast(Session("eclUser"), User).LanID

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim rowCheck As CheckBox = e.Row.FindControl("check1")
            Dim rowPanel As Panel = e.Row.FindControl("sub1")
            Dim reason As Label = e.Row.FindControl("Label1")
            Dim rowButtons As RadioButtonList = e.Row.FindControl("buttons1")

            ' EC.sp_Select_Values_By_Reason
            SqlDataSource23.SelectParameters("strReasonin").DefaultValue = reason.Text
            SqlDataSource23.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource23.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

            rowButtons.DataSource = SqlDataSource23
            rowButtons.DataBind()

            Dim subMenu As ListBox = e.Row.FindControl("SubReasons")

            ' EC.sp_Select_SubCoachingReasons_By_Reason
            SqlDataSource22.SelectParameters("strReasonin").DefaultValue = reason.Text
            SqlDataSource22.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource22.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource22.SelectParameters("nvcEmpLanIDin").DefaultValue = lan

            subMenu.DataSource = SqlDataSource22
            subMenu.DataBind()

            Dim validation1 As RequiredFieldValidator = e.Row.FindControl("RequiredFieldValidator1")
            Dim validation2 As RequiredFieldValidator = e.Row.FindControl("RequiredFieldValidator2")

            rowCheck.Attributes.Add("onclick", "javascript: togglemenu(" & rowCheck.ClientID & "," & rowPanel.ClientID & "," & rowButtons.ClientID & "," & subMenu.ClientID & ");")

            For Each item As Object In rowButtons.Items
                '   MsgBox("first" & rowButtons.Items(0).Text & "-" & rowButtons.Items(1).Text)
                '  MsgBox("Second" & rowButtons.Items(0).Value & "-" & rowButtons.Items(1).Value)
                If (Len(rowButtons.Items(0).Text) < 1) Then
                    Select Case rowButtons.Items(1).Text
                        Case "Opportunity"
                            rowButtons.Items(0).Text = "Opportunity"
                            rowButtons.Items(1).Text = "Re!nforcement" 'Reinforcement
                            rowButtons.Items(1).Attributes.Add("style", "visibility: hidden;")
                        Case Else
                            rowButtons.Items(0).Text = "Opportun!ty" 'Opportunity
                            rowButtons.Items(0).Attributes.Add("style", "visibility: hidden;")
                    End Select
                End If
            Next
        End If
    End Sub

    Protected Sub Button3_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button3.Click
        Response.Redirect("default2.aspx")
    End Sub

    Protected Sub Button1_Click1(ByVal sender As Object, e As EventArgs) Handles Button1.Click
        Response.Redirect("default2.aspx")
        'Server.Transfer("/default2")
    End Sub

    Protected Sub cseradio_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cseradio.SelectedIndexChanged
        Dim lan As String = TryCast(Session("eclUser"), User).LanID

        If cseradio.SelectedValue = "Yes" Then
            ' EC.sp_Select_CoachingReasons_By_Module
            SqlDataSource18.SelectParameters("strSourcein").DefaultValue = "Direct"
            SqlDataSource18.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource18.SelectParameters("isSplReason").DefaultValue = True
            SqlDataSource18.SelectParameters("splReasonPrty").DefaultValue = 2
            SqlDataSource18.SelectParameters("strCSRin").DefaultValue = Label17.Text
            SqlDataSource18.SelectParameters("strSubmitterin").DefaultValue = lan

            GridView5.DataBind()
        Else
            ' EC.sp_Select_CoachingReasons_By_Module
            SqlDataSource12.SelectParameters("strSourcein").DefaultValue = "Direct"
            SqlDataSource12.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource12.SelectParameters("isSplReason").DefaultValue = False
            SqlDataSource12.SelectParameters("splReasonPrty").DefaultValue = 2
            SqlDataSource12.SelectParameters("strCSRin").DefaultValue = Label17.Text
            SqlDataSource12.SelectParameters("strSubmitterin").DefaultValue = lan

            GridView4.DataBind()
        End If
    End Sub

    Protected Sub cseradio2_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cseradio2.SelectedIndexChanged
        Dim lan As String = TryCast(Session("eclUser"), User).LanID

        If cseradio2.SelectedValue = "Yes" Then
            ' EC.sp_Select_CoachingReasons_By_Module
            SqlDataSource21.SelectParameters("strSourcein").DefaultValue = "Indirect"
            SqlDataSource21.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource21.SelectParameters("isSplReason").DefaultValue = True
            SqlDataSource21.SelectParameters("splReasonPrty").DefaultValue = 2
            SqlDataSource21.SelectParameters("strCSRin").DefaultValue = Label17.Text
            SqlDataSource21.SelectParameters("strSubmitterin").DefaultValue = lan

            GridView6.DataBind()
        Else
            ' EC.sp_Select_CoachingReasons_By_Module
            SqlDataSource10.SelectParameters("strSourcein").DefaultValue = "Indirect"
            SqlDataSource10.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource10.SelectParameters("isSplReason").DefaultValue = False
            SqlDataSource10.SelectParameters("splReasonPrty").DefaultValue = 2
            SqlDataSource10.SelectParameters("strCSRin").DefaultValue = Label17.Text
            SqlDataSource10.SelectParameters("strSubmitterin").DefaultValue = lan

            GridView2.DataBind()
        End If
    End Sub

    Protected Sub module_SelectedIndexChanged(sender As Object, e As EventArgs) Handles DropDownList3.SelectedIndexChanged
        Dim modSplit As Array
        modSplit = Split(DropDownList3.SelectedValue, "-", -1, 1)
        Label6.Text = "New - " & modSplit(1) & " Coaching"
    End Sub

    Protected Sub SqlDataSource1_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource1.Selecting
        'EC.sp_Select_Employees_By_Module 
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource3_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource3.Selecting
        'EC.sp_Display_Sites_For_Module
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource4_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource4.Selecting
        'EC.sp_Select_Programs 
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource5_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource5.Selecting
        'EC.sp_Select_Source_By_Module        
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource6_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource6.Selecting
        'EC.sp_InsertInto_Coaching_Log               
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource7_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource7.Selecting
        'EC.sp_Select_Source_By_Module             
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource8_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource8.Selecting
        'EC.sp_Select_CallID_By_Module         
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource9_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource9.Selecting
        'EC.sp_Select_CallID_By_Module              
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource10_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource10.Selecting
        'EC.sp_Select_CoachingReasons_By_Module      
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource11_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource11.Selecting
        'EC.sp_Select_SubCoachingReasons_By_Reason      
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource12_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource12.Selecting
        'EC.sp_Select_CoachingReasons_By_Module           
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource13_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource13.Selecting
        'EC.sp_Select_SubCoachingReasons_By_Reason            
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource14_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource14.Selecting
        'EC.sp_Check_AgentRole 
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource15_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource15.Selecting
        'EC.sp_Select_Modules_By_Job_Code
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource16_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource16.Selecting
        'EC.sp_Select_Values_By_Reason            
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource17_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource17.Selecting
        'EC.sp_Select_Values_By_Reason       
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource18_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource18.Selecting
        'EC.sp_Select_CoachingReasons_By_Module         
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource19_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource19.Selecting
        'EC.sp_Select_SubCoachingReasons_By_Reason          
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource20_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource20.Selecting
        'EC.sp_Select_Values_By_Reason           
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource21_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource21.Selecting
        'EC.sp_Select_CoachingReasons_By_Module  
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource22_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource22.Selecting
        'EC.sp_Select_SubCoachingReasons_By_Reason    
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource23_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource23.Selecting
        'EC.sp_Select_Values_By_Reason     
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource24_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource24.Selecting
        'EC.sp_Select_CoachingReasons_By_Module     
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource25_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource25.Selecting
        'EC.sp_Select_Email_Attributes
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource26_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource26.Selecting
        'EC.sp_Select_SubCoachingReasons_By_Reason
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource28_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource28.Selecting
        'EC.sp_Select_Behaviors 
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource6_Inserting(ByVal sender As Object, e As SqlDataSourceCommandEventArgs) Handles SqlDataSource6.Inserting
        'EC.sp_InsertInto_Coaching_Log
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub Warning_Inserted(ByVal sender As Object, ByVal e As SqlDataSourceStatusEventArgs) Handles SqlDataSource27.Inserted
        If (e.Command.Parameters("@isDup").Value = 1) Then
            Label169.Text = "A warning with the same category and type already exists. Please review your warning section in the My Dashboard for details."
        Else
            Label169.Text = ""
        End If
    End Sub
End Class
