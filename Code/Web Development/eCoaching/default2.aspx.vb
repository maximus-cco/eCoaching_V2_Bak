Imports System.Data.SqlClient
Imports System.Net.Mail
Imports System
Imports System.Configuration
Imports AjaxControlToolkit


'still left to be done, add domain as a behind the scenes property of the selected CSR and pass that so on check u can see who the supervisor is in the right domain

'Garcia, Shawn R (CNV)
'Gonzales, Ramsey (CNV)

Public Class default2
    Inherits System.Web.UI.Page
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
    ' Dim status As String
    '  Dim status2 As String
    '  Dim status3 As String

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
    'Dim word(6) As Char
    ' Dim rnd As New Random()
    Dim digit
    Dim found
    Dim coachR(13, 3)

    Dim copy As Boolean = False
    Dim strCopy As String

    Dim lan As String = LCase(User.Identity.Name) 'boulsh"
    Dim supervisor As String
    Dim domain As String

    Dim FromURL As String
    Dim userTitle As String
    Dim moduleID As Integer
    Dim modtype As Array
    Dim grid As GridView



    Protected Sub DropDownList1_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        DropDownList1 = CType(sender, DropDownList)



        Dim site = DropDownList1.SelectedItem.Text


        ' MsgBox(site)

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
        '''Next1.Enabled = False

        '      If (site <> "Select...") Then

        '---------------------

        ' Label242.Text = x

        '    Else
        If (site <> "Select...") Then

            ' RequiredFieldValidator4.Validate()

            '   Label230.Text = "Please correct all fields indicated in red to proceed."

            'Else
            SqlDataSource1.SelectParameters("strCSRSitein").DefaultValue = site
            SqlDataSource1.SelectParameters("strModulein").DefaultValue = "CSR"
            SqlDataSource1.SelectParameters("strUserLanin").DefaultValue = lan

        Else

            Panel0a.Visible = False


            Select Case True

                Case Panel1.Visible


                    Date1.Text = ""
                    TextBox5.Text = ""
                    'howid.SelectedIndex = 0
                    callID2.Text = ""
                    calltype2.SelectedIndex = 0

                    cseradio2.SelectedIndex = 1


                    RadioButton4.Checked = True
                    RadioButton3.Checked = False

                    CheckBox1.Checked = False
                    GridView6.DataSourceID = ""
                    GridView6.DataBind()
                    GridView6.DataSourceID = "SqlDataSource21"
                    GridView6.DataBind()

                    GridView2.DataSourceID = ""
                    GridView2.DataBind()
                    GridView2.DataSourceID = "SqlDataSource10"
                    GridView2.DataBind()

                    Panel1.Visible = False

                Case Panel2.Visible

                    If (warnlist.SelectedIndex = 0) Then

                        warnlist.SelectedIndex = 1
                        ' warngroup1.Style("display") = "none" 'inline
                        'warngroup1.Style("visibility") = "hidden" 'visible
                        '''MsgBox("1")
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
                        'RequiredFieldValidator10.Enabled = False
                        CustomValidator3.Enabled = False

                        nowarn.Style("display") = "inline" 'inline
                        nowarn.Style("visibility") = "visible" 'visible

                        '' RequiredFieldValidator49.Enabled = True
                        ''RequiredFieldValidator50.Enabled = True


                        Labe27.Text = "Enter/Select the date of coaching:"

                    End If

                    Date2.Text = ""
                    TextBox11.Text = ""
                    TextBox12.Text = ""
                    'howid.SelectedIndex = 0
                    callID.Text = ""
                    calltype.SelectedIndex = 0
                    cseradio.SelectedIndex = 1

                    RadioButton2.Checked = True
                    RadioButton1.Checked = False

                    CheckBox2.Checked = False
                    GridView5.DataSourceID = ""
                    GridView5.DataBind()
                    GridView5.DataSourceID = "SqlDataSource18"
                    GridView5.DataBind()

                    GridView4.DataSourceID = ""
                    GridView4.DataBind()
                    GridView4.DataSourceID = "SqlDataSource12"
                    GridView4.DataBind()

                    Panel2.Visible = False

            End Select

        End If



    End Sub



    Protected Sub warnlist2_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        ' warnlist2 = CType(sender, DropDownList)

        Dim site = warnlist2.SelectedItem.Text
        ''' MsgBox("2")
        warnReasons.Items.Clear()
        warnReasons.Items.Add(New ListItem("Select...", "Select..."))

        If (warnlist2.SelectedValue <> "Select...") Then

            ' MsgBox("changing")

            SqlDataSource26.SelectParameters("strReasonin").DefaultValue = warnlist2.SelectedItem.Text
            SqlDataSource26.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource26.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource26.SelectParameters("nvcEmpLanIDin").DefaultValue = lan
            ' SqlDataSource26.DataBind()


            'MsgBox(warnlist2.SelectedItem.Text)
            'MsgBox(RadioButtonList1.SelectedValue)
            'MsgBox(DropDownList3.SelectedItem.Text)


            ''' MsgBox("a")
            warnReasons.DataSource = SqlDataSource26
            warnReasons.DataBind()
            warnReasons.SelectedIndex = 0

        End If



    End Sub




    Protected Sub DropDownList3_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
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
	'programList.SelectedIndex = 0

        RadioButtonList1.SelectedIndex = -1

        '''  Next1.Enabled = False

        Panel0.Visible = False
        Panel2.Visible = False
        Panel1.Visible = False


        If (recipient = "Select...") Then

            Panel0.Visible = False

        Else




            Panel0.Visible = True

            ' warnlist2.Items.Clear()


            SqlDataSource3.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource4.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text	
	    SqlDataSource28.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text




            modtype = Split(DropDownList3.SelectedItem.Value, "-", -1, 1)

            moduleIDlbl.Text = modtype(2)
            ' MsgBox("first Instance=" & moduleIDlbl.Text)
            If (modtype(0) = 1) Then


                Panel29.Visible = True


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


                ' Label63.Text = "5. "

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
            '  RequiredFieldValidator1.Validate()
            '''   Next1.Enabled = False
            '  Label230.Text = "Please correct all fields indicated in red to proceed."


            Panel0a.Visible = False


            Select Case True

                Case Panel1.Visible


                    Date1.Text = ""
                    TextBox5.Text = ""
                    'howid.SelectedIndex = 0
                    callID2.Text = ""
                    calltype2.SelectedIndex = 0

                    cseradio2.SelectedIndex = 1


                    RadioButton4.Checked = True
                    RadioButton3.Checked = False

                    CheckBox1.Checked = False
                    GridView6.DataSourceID = ""
                    GridView6.DataBind()
                    GridView6.DataSourceID = "SqlDataSource21"
                    GridView6.DataBind()

                    GridView2.DataSourceID = ""
                    GridView2.DataBind()
                    GridView2.DataSourceID = "SqlDataSource10"
                    GridView2.DataBind()


                    Panel1.Visible = False

                Case Panel2.Visible


                    If (warnlist.SelectedIndex = 0) Then

                        warnlist.SelectedIndex = 1
                        'warngroup1.Style("display") = "none" 'inline
                        'warngroup1.Style("visibility") = "hidden" 'visible
                        ''' MsgBox("3")
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
                        'RequiredFieldValidator10.Enabled = False
                        CustomValidator3.Enabled = False

                        nowarn.Style("display") = "inline" 'inline
                        nowarn.Style("visibility") = "visible" 'visible

                        '' RequiredFieldValidator49.Enabled = True
                        ''RequiredFieldValidator50.Enabled = True


                        Labe27.Text = "Enter/Select the date of coaching:"

                    End If

                    Date2.Text = ""
                    TextBox11.Text = ""
                    TextBox12.Text = ""
                    'howid.SelectedIndex = 0
                    callID.Text = ""
                    calltype.SelectedIndex = 0
                    cseradio.SelectedIndex = 1

                    RadioButton2.Checked = True
                    RadioButton1.Checked = False

                    CheckBox2.Checked = False
                    GridView5.DataSourceID = ""
                    GridView5.DataBind()
                    GridView5.DataSourceID = "SqlDataSource18"
                    GridView5.DataBind()

                    GridView4.DataSourceID = ""
                    GridView4.DataBind()
                    GridView4.DataSourceID = "SqlDataSource12"
                    GridView4.DataBind()


                    Panel2.Visible = False


            End Select

        Else

            Panel0a.Visible = False


            SupervisorDropDownList.Text = ""

            MGRDropDownList.Text = ""

            '''  Next1.Enabled = False


            Dim y As String
            Dim z As String
            ' MsgBox(ddCSR.SelectedValue)

            arrCSR = Split(ddCSR.SelectedValue, "$", -1, 1)

            y = arrCSR(3) & " (" & arrCSR(5) & ") - " & arrCSR(6)
            z = arrCSR(7) & " (" & arrCSR(9) & ") - " & arrCSR(10)
            'MsgBox(y)
            SupervisorDropDownList.Text = y
            ' MsgBox(z)
            MGRDropDownList.Text = z






            Label23.Text = arrCSR(0)
            ' MsgBox("lan" & arrCSR(2))
            'MsgBox("value=" & ddCSR.SelectedValue)
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

            ' warnlist2.Items.Clear()


            'warnlist2.DataSourceID = "SqlDataSource24"


            Select Case True

                Case Panel1.Visible


                    Date1.Text = ""
                    TextBox5.Text = ""
                    'howid.SelectedIndex = 0
                    callID2.Text = ""
                    calltype2.SelectedIndex = 0

                    cseradio2.SelectedIndex = 1


                    RadioButton4.Checked = True
                    RadioButton3.Checked = False

                    CheckBox1.Checked = False
                    GridView6.DataSourceID = ""
                    GridView6.DataBind()
                    GridView6.DataSourceID = "SqlDataSource21"
                    GridView6.DataBind()

                    GridView2.DataSourceID = ""
                    GridView2.DataBind()
                    GridView2.DataSourceID = "SqlDataSource10"
                    GridView2.DataBind()


                    Panel1.Visible = False

                Case Panel2.Visible


                    If (warnlist.SelectedIndex = 0) Then
                        ''' MsgBox("4")
                        warnlist.SelectedIndex = 1
                        'warngroup1.Style("display") = "none" 'inline
                        'warngroup1.Style("visibility") = "hidden" 'visible

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
                        'RequiredFieldValidator10.Enabled = False
                        CustomValidator3.Enabled = False

                        nowarn.Style("display") = "inline" 'inline
                        nowarn.Style("visibility") = "visible" 'visible

                        '' RequiredFieldValidator49.Enabled = True
                        ''RequiredFieldValidator50.Enabled = True


                        Labe27.Text = "Enter/Select the date of coaching:"

                    End If

                    Date2.Text = ""
                    TextBox11.Text = ""
                    TextBox12.Text = ""
                    'howid.SelectedIndex = 0
                    callID.Text = ""
                    calltype.SelectedIndex = 0
                    cseradio.SelectedIndex = 1

                    RadioButton2.Checked = True
                    RadioButton1.Checked = False

                    CheckBox2.Checked = False
                    GridView5.DataSourceID = ""
                    GridView5.DataBind()
                    GridView5.DataSourceID = "SqlDataSource18"
                    GridView5.DataBind()

                    GridView4.DataSourceID = ""
                    GridView4.DataBind()
                    GridView4.DataSourceID = "SqlDataSource12"
                    GridView4.DataBind()


                    Panel2.Visible = False


            End Select




            '  If ((Panel2.Visible = True) Or (Panel1.Visible = True)) Then

            Label21.Visible = True
            Label23.Visible = True
            Label30.Visible = True
            Label32.Visible = True
            Label52.Visible = True
            Label53.Visible = True


            ' End If



            '  Page.Validate()

            ' If Page.IsValid Then

            'Label230.Text = "&nbsp;"
            'If (RadioButtonList1.SelectedIndex <> -1) Then

            Button1_Click() ' Next1.Enabled = True

            'End If


            ' Else
            ' Label230.Text = "&nbsp;"
            '''      Next1.Enabled = False
            '   Label230.Text = "Please correct all fields indicated in red to proceed."
            'End If

        End If



        'MsgBox(ddCSR.SelectedValue)


    End Sub



    Protected Sub ProgramList_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)


        programList = CType(sender, DropDownList)

        ' If (programList.SelectedValue = "Select...") Then

        'RequiredFieldValidator22.Validate()
        '''   Next1.Enabled = False
        'Label230.Text = "Please correct all fields indicated in red to proceed."

        'Else

        '''    Next1.Enabled = False

        ' Page.Validate()

        'If Page.IsValid Then

        'Label230.Text = "&nbsp;"
        Button1_Click() '  Next1.Enabled = True
        'Else
        'Label230.Text = "&nbsp;"
        '''  Next1.Enabled = False
        'End If

        'End If

    End Sub


   Protected Sub BehaviorList_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)



        behaviorList = CType(sender, DropDownList)

        Button1_Click() '  Next1.Enabled = True

    End Sub

    Protected Sub RadioButtonList1_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        ' CoachingButtonList1 = CType(sender, RadioButtonList)

        'Page.Validate()

        'If Page.IsValid Then

        ' Label230.Text = "&nbsp;"
        Button1_Click() '  Next1.Enabled = True


        ' Else
        '''  Next1.Enabled = False
        '     Label230.Text = "Please correct all fields indicated in red to proceed."
        'End If
    End Sub





    Protected Sub Button1_Click()
        ' MsgBox("cbl") '
        'Select Case True


        'Case (InStr(1, lan, "vngt\", 1) > 0)
        'lan = (Replace(lan, "vngt\", ""))
        '   Case (InStr(1, lan, "ad\", 1) > 0)
        'lan = (Replace(lan, "ad\", ""))
        '   Case Else

        'lan = lan

        'End Select

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
                ' MsgBox(cbl)
                Dim site = DropDownList1.SelectedValue
                Dim menu '= CType(sender, DropDownList)


                '  Dim arrCSR As Array
                ' arrCSR = Split(CSRDropDownList.SelectedValue, "-", -1, 1)

                'Dim arrSUP As Array
                'arrSUP = Split(SupervisorDropDownList.SelectedValue, "-", -1, 1)

                'Dim arrMGR As Array
                'arrMGR = Split(MGRDropDownList.SelectedValue, "-", -1, 1)


                '        Me.Master.FindControl("ContentPlaceHolder4").Visible = True

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


                '        Dim subEmail As Label
                '       Dim subName As Label

                'subEmail = DataList1.Items(0).FindControl("Label175")
                'subName = DataList1.Items(0).FindControl("Label176")

                ' MsgBox(Label6.Text)
                'Label6.Text = "New"
                ' Label10.Text = Now()
                'Label23.Text = Replace(arrCSR(0), "$", "-")
                'Label17.Text = arrCSR(2)
                'Label19.Text = Replace(arrCSR(1), "$", "-")

                ' Label32.Text = Replace(arrSUP(0), "$", "-")
                'Label28.Text = arrSUP(2)
                'Label36.Text = Replace(arrSUP(1), "$", "-")

                'Label53.Text = Replace(arrMGR(0), "$", "-")
                'Label47.Text = arrMGR(2)
                'Label55.Text = Replace(arrMGR(1), "$", "-")

                If (DropDownList1.SelectedIndex <> 0) Then

                    Label49.Text = DropDownList1.SelectedItem.Text        'site

                Else

                    Label49.Text = Label49.Text        'site

                End If


                Label51.Text = cbl
                Label57.Text = lan
                ''   Label152.Text = ""



                '  Label152.Text =    'count

                '''   Panel0.Visible = False ' no longer need to hide page 1 fields
                ''' Panel28.Visible = False ' no longer need to hide page 1 fields

                'Panel0a.Visible = True

                ' MsgBox("label=" & Label63.Text)

                Dim numCur As Integer

                numCur = CInt(Replace(Label63.Text, ". ", ""))


                '  MsgBox("number = " & numCur)


                If (cbl = "Indirect") Then

                    '           Image7.ToolTip = "Average Handle Time is the amount of time a CSR takes to complete a beneficiary call." & vbCrLf & vbCrLf & "Example : CSR() 's AHT for last week was 6:58 which is a 5 on the BCC Scorecard and considered excellent."
                    ''Image23.ToolTip = "Average Handle Time is the amount of time a CSR takes to complete a beneficiary call." & vbCrLf & vbCrLf & "Example : CSR() 's AHT for last week was 6:58 which is a 5 on the BCC Scorecard and considered excellent."

                    '          Image11.ToolTip = "Any process procedure" & vbCrLf & vbCrLf & "Discussed with CSR where to go in East & West building, if we have severe weather. CSR signed the roster agreeing that he read and understands this procedure."
                    ''Image27.ToolTip = "Any process procedure" & vbCrLf & vbCrLf & "Discussed with CSR where to go in East & West building, if we have severe weather. CSR signed the roster agreeing that he read and understands this procedure."



                    ''' Next1.Visible = False '''
                    '''  MsgBox("5")
                    warnlist.SelectedIndex = 1
                    Labe27.Text = "Enter/Select the date of coaching:"
                    warnReasons.Items.Clear()
                    warnReasons.Items.Add(New ListItem("Select...", "Select..."))


                    Button2.Visible = True
                    Panel2.Visible = False
                    Panel1.Visible = True
                    CalendarExtender1.EndDate = TodaysDate

                    SqlDataSource10.SelectParameters("strSourcein").DefaultValue = "Indirect"
                    SqlDataSource10.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
                    SqlDataSource10.SelectParameters("isSplReason").DefaultValue = False
                    SqlDataSource10.SelectParameters("splReasonPrty").DefaultValue = 2
                    ' MsgBox(Label17.Text)
                    SqlDataSource10.SelectParameters("strCSRin").DefaultValue = Label17.Text
                    SqlDataSource10.SelectParameters("strSubmitterin").DefaultValue = lan

                    SqlDataSource21.SelectParameters("strSourcein").DefaultValue = "Indirect"
                    SqlDataSource21.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
                    SqlDataSource21.SelectParameters("isSplReason").DefaultValue = True
                    SqlDataSource21.SelectParameters("splReasonPrty").DefaultValue = 2
                    ' MsgBox(Label17.Text)
                    SqlDataSource21.SelectParameters("strCSRin").DefaultValue = Label17.Text
                    SqlDataSource21.SelectParameters("strSubmitterin").DefaultValue = lan

                    Label188.Text = "Indirect Entry [2 of 2]"

                    'RadioButtonList2.Items(0).Attributes.Add("onclick", "javascript: toggle('1','panel1a');")
                    'RadioButtonList2.Items(1).Attributes.Add("onclick", "javascript: toggle('0','panel1a');")
                    '  OnClick = "toggleCallID1('1', '<%= panel2c2.ClientID %>', '<%= callID2.ClientID %>', '<%= calltype2.ClientID %>');"

                    'RadioButtonList2.Items(0).Attributes.Add("onclick", "javascript: toggle('1','panel1a');")"
                    RadioButton3.Attributes.Add("onclick", "javascript: toggleCallID1('1','" & panel2c2.ClientID & "','" & callID2.ClientID & "','" & calltype2.ClientID & "');")
                    RadioButton4.Attributes.Add("onclick", "javascript: toggleCallID1('0','" & panel2c2.ClientID & "','" & callID2.ClientID & "','" & calltype2.ClientID & "');")

                    'RadioButtonList3.Items(1).Attributes.Add("onclick", "javascript: toggle('0','panel1b');")

                    'RadioButtonList4.Items(0).Attributes.Add("onclick", "javascript: toggle('1','panel1c');")
                    'RadioButtonList4.Items(1).Attributes.Add("onclick", "javascript: toggle('0','panel1c');")

                    ''' Next1.Enabled = False
                    CompareValidator1.ValueToCompare = TodaysDate
                    'Date1.Text = DateTime.Now.ToString("d")



                    menu = howid2
                    menu.Items.Clear()
                    menu.Items.Add(New ListItem("Select...", "Select..."))

                    SqlDataSource5.SelectParameters("strSourcein").DefaultValue = "Indirect"
                    SqlDataSource5.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

                    SqlDataSource8.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text




                    '    Select Case Label63.Text

                    'Case "6. "
                    numCur = numCur + 1
                    Label66.Text = (numCur) & ". "
                    numCur = numCur + 1
                    'Label72.Text = (numCur) & ". "
                    'numCur = numCur + 1

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

                    '    Case "5. "

                    '  Label66.Text = "6. "
                    '  Label72.Text = "7. "
                    '  Label73.Text = "8. "
                    ' Label74.Text = "9. "
                    '  Label75.Text = "10. "
                    '  Label76.Text = "11. "


                    'End Select
                    warngroup2.Visible = False

                    Panel6.Style("display") = "inline"
                    Panel6.Style("visibility") = "visible"
                    Panel7.Style("display") = "inline"
                    Panel7.Style("visibility") = "visible"

                    CustomValidator2.Enabled = True


                    RequiredFieldValidator11.Enabled = False
                    ' RequiredFieldValidator10.Enabled = False
                    CustomValidator3.Enabled = False


                Else
                    'Check for Direct & SUP, MGR, Sr. MGR or program to add "ETS" to Attendance sub reason menu
                    '  If ((RadioButtonList1.SelectedValue = "Direct") And ((InStr(1, userTitle, "40", 1) > 0) Or (InStr(1, userTitle, "50", 1) > 0) Or (InStr(1, userTitle, "60", 1) > 0) Or (InStr(1, userTitle, "WISY13", 1) > 0))) Then

                    '''   attdrop.Items.Add(New ListItem("ETS", "48"))
                    '''attdrop.Items.Add(New ListItem("Other: Specify reason under Question 4 below", "42"))

                    'Else
                    ''' attdrop.Items.Add(New ListItem("Other: Specify reason under Question 4 below", "42"))

                    ' attdrop.Items.RemoveAt(1)
                    ' attdrop.Items.Insert(0, "try this")
                    'End If

                    ' MsgBox("tick tick")
                    '' Image7.ToolTip = "Average Handle Time is the amount of time a CSR takes to complete a beneficiary call." & vbCrLf & vbCrLf & "Example : CSR() 's AHT for last week was 6:58 which is a 5 on the BCC Scorecard and considered excellent."
                    'Image23.ToolTip = "Average Handle Time is the amount of time a CSR takes to complete a beneficiary call." & vbCrLf & vbCrLf & "Example : CSR() 's AHT for last week was 6:58 which is a 5 on the BCC Scorecard and considered excellent."

                    '' Image11.ToolTip = "Any process procedure" & vbCrLf & vbCrLf & "Discussed with CSR where to go in East & West building, if we have severe weather. CSR signed the roster agreeing that he read and understands this procedure."
                    'Image27.ToolTip = "Any process procedure" & vbCrLf & vbCrLf & "Discussed with CSR where to go in East & West building, if we have severe weather. CSR signed the roster agreeing that he read and understands this procedure."

                    Button5.Visible = True
                    Panel1.Visible = False
                    Panel2.Visible = True
                    CalendarExtender2.EndDate = TodaysDate

                    SqlDataSource12.SelectParameters("strSourcein").DefaultValue = "Direct"
                    SqlDataSource12.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
                    SqlDataSource12.SelectParameters("isSplReason").DefaultValue = False
                    SqlDataSource12.SelectParameters("splReasonPrty").DefaultValue = 2
                    ' MsgBox(Label17.Text)
                    SqlDataSource12.SelectParameters("strCSRin").DefaultValue = Label17.Text
                    SqlDataSource12.SelectParameters("strSubmitterin").DefaultValue = lan


                    SqlDataSource18.SelectParameters("strSourcein").DefaultValue = "Direct"
                    SqlDataSource18.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
                    SqlDataSource18.SelectParameters("isSplReason").DefaultValue = True
                    SqlDataSource18.SelectParameters("splReasonPrty").DefaultValue = 2
                    ' MsgBox(Label17.Text)
                    SqlDataSource18.SelectParameters("strCSRin").DefaultValue = Label17.Text
                    SqlDataSource18.SelectParameters("strSubmitterin").DefaultValue = lan
                    'MsgBox(lan)
                    'MsgBox(Label28.Text)
                    'MsgBox(Label47.Text)

                    If (((lan = LCase(Label28.Text)) Or (lan = LCase(Label47.Text))) And (modtype(4) = 1)) Then

                        warngroup2.Visible = True



                        warnlist2.Items.Clear() 'clear site list
                        warnlist2.Items.Add(New ListItem("Select...", "Select..."))

                        'Warning setup
                        SqlDataSource24.SelectParameters("strSourcein").DefaultValue = "Direct"
                        SqlDataSource24.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
                        SqlDataSource24.SelectParameters("isSplReason").DefaultValue = True
                        SqlDataSource24.SelectParameters("splReasonPrty").DefaultValue = 1
                        ' MsgBox(Label17.Text)
                        SqlDataSource24.SelectParameters("strCSRin").DefaultValue = Label17.Text
                        SqlDataSource24.SelectParameters("strSubmitterin").DefaultValue = lan
                        ' warnlist2.DataSourceID = "SqlDataSource24"

                    Else

                        warngroup2.Visible = False

                    End If

                    ' Panel5.Visible = False
                    'Panel6.Visible = False
                    'Panel7.Visible = True

                    '' sideCol2.Attributes.Add("style", "height: 1640px; ")

                    Label188.Text = "Direct Entry [2 of 2]"


                    RadioButton1.Attributes.Add("onclick", "javascript: toggleCallID1('1','" & panel2c.ClientID & "','" & callID.ClientID & "','" & calltype.ClientID & "');")
                    RadioButton2.Attributes.Add("onclick", "javascript: toggleCallID1('0','" & panel2c.ClientID & "','" & callID.ClientID & "','" & calltype.ClientID & "');")

                    'RadioButtonList18.Items(0).Attributes.Add("onclick", "javascript: toggle('1','panel2a');")
                    'RadioButtonList18.Items(1).Attributes.Add("onclick", "javascript: toggle('0','panel2a');")

                    'RadioButtonList19.Items(0).Attributes.Add("onclick", "javascript: toggle('1','panel2b');")
                    'RadioButtonList19.Items(1).Attributes.Add("onclick", "javascript: toggle('0','panel2b');")

                    'RadioButtonList20.Items(0).Attributes.Add("onclick", "javascript: toggle('1','panel2c');")
                    'RadioButtonList20.Items(1).Attributes.Add("onclick", "javascript: toggle('0','panel2c');")

                    'RadioButtonList31.Items(0).Attributes.Add("onclick", "javascript: toggle('1','panel2d');")
                    'RadioButtonList31.Items(1).Attributes.Add("onclick", "javascript: toggle('0','panel2d');")

                    'RadioButtonList31.Items(0).Attributes.Add("onclick", "javascript: toggle('1','panel2d');")
                    'RadioButtonList31.Items(1).Attributes.Add("onclick", "javascript: toggle('0','panel2d');")


                    '''  Next1.Enabled = False
                    CompareValidator2.ValueToCompare = TodaysDate


                    menu = howid
                    menu.Items.Clear()
                    menu.Items.Add(New ListItem("Select...", "Select..."))

                    SqlDataSource7.SelectParameters("strSourcein").DefaultValue = "Direct"
                    SqlDataSource7.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
                    SqlDataSource9.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

                    ' Date2.Text = DateTime.Now.ToString("d")

                    ' MsgBox(Label63.Text)

                    'Select Case Label63.Text

                    '   Case "6. "


                    'Label77.Text = (numCur + 1) & ". "
                    'Label78.Text = (numCur + 2) & ". "
                    'Label79.Text = (numCur + 3) & ". "
                    'Label80.Text = (numCur + 4) & ". "
                    'Label83.Text = (numCur + 5) & ". "
                    'Label84.Text = (numCur + 6) & ". "
                    'Label85.Text = (numCur + 7) & ". "

                    If (((lan = LCase(Label28.Text)) Or (lan = LCase(Label47.Text))) And (modtype(4) = 1)) Then
                        'RadioButtonList1_SelectedIndexChanged
                        '  MsgBox("boom")
                        numCur = numCur + 1
                        Label64.Text = (numCur) & ". "

                    End If


                    numCur = numCur + 1
                    Label77.Text = (numCur) & ". "
                    numCur = numCur + 1
                    'Label78.Text = (numCur) & ". "
                    'numCur = numCur + 1

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

                    ' Label77.Text = "7. "
                    ' Label78.Text = "8. "
                    ' Label79.Text = "9. "
                    ' Label80.Text = "10. "
                    ' Label83.Text = "11. "
                    ' Label84.Text = "12. "
                    ' Label85.Text = "13. "

                    '     Case "5. "

                    'Label77.Text = "6. "
                    'Label78.Text = "7. "
                    'Label79.Text = "8. "
                    'Label80.Text = "9. "
                    'Label83.Text = "10. "
                    'Label84.Text = "11. "
                    'Label85.Text = "12. "

                    'End Select

                End If
                'Table4.Visible = False
                'Next1.Visible = False

            End If


     


        End If

    End Sub





    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load


        Select Case True


            Case (InStr(1, lan, "vngt\", 1) > 0)
                lan = (Replace(lan, "vngt\", ""))
                domain = "LDAP://dc=vangent,dc=local"
            Case (InStr(1, lan, "ad\", 1) > 0)
                lan = (Replace(lan, "ad\", ""))
                domain = "LDAP://dc=ad,dc=local"

            Case Else
                ' MsgBox("2" & lan)
                Response.Redirect("error.aspx")

        End Select



        ' MsgBox(lan)
        SqlDataSource14.SelectParameters("nvcLanID").DefaultValue = lan
        SqlDataSource14.SelectParameters("nvcRole").DefaultValue = "ARC"

        GridView1.DataBind()
        SqlDataSource2.SelectParameters("strUserin").DefaultValue = lan

        SqlDataSource2.DataBind()
        GridView3.DataBind()


        SqlDataSource15.SelectParameters("nvcEmpLanIDin").DefaultValue = lan
        SqlDataSource15.DataBind()

        Dim subString As String

        Try

            subString = (CType(GridView3.Rows(0).FindControl("Job"), Label).Text)
        Catch ex As Exception
            subString = ""
            'MsgBox("1" & lan)
            Response.Redirect("error.aspx")
        End Try


        If (Len(subString) > 0) Then

            Dim subArray As Array

            subArray = Split(subString, "$", -1, 1)
            Label57.Text = lan

            Label178.Text = subArray(2) ' name

            Label180.Text = subArray(1) 'mail
            userTitle = subArray(0) 'title
        Else

            userTitle = "Error"

        End If


        If ((InStr(1, userTitle, "WACS0", 1) > 0) And (Label241.Text = 0)) Then
            '       MsgBox("test1")
            Response.Redirect("error2.aspx")
        End If

       


      

        '  Dim grid As GridView
        grid = GridView4
        'MsgBox(DropDownList3.SelectedItem.Value)

 If (DropDownList3.SelectedIndex > 0) Then

            modtype = Split(DropDownList3.SelectedItem.Value, "-", -1, 1)


            'MsgBox(DropDownList3.SelectedItem.Value)
            'MsgBox("2" & modtype)
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
            '    MsgBox(modtype(3))
            '   MsgBox(warnlist.SelectedIndex)
            If ((modtype(3) = 1) And (warnlist.SelectedIndex <> 0)) Then
                ' MsgBox("1")

                Panel6.Style("display") = "inline"
                Panel6.Style("visibility") = "visible"
                Panel7.Style("display") = "inline"
                Panel7.Style("visibility") = "visible"

                '' CustomValidator2.Enabled = True


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
                'MsgBox("2")
                warngroup2.Visible = True
                ' grid = GridView7

                If (warnlist.SelectedIndex = 0) Then
                    ' MsgBox("3")
                    warngroup1.Style("display") = "inline" 'inline
                    warngroup1.Style("visibility") = "visible" 'visible

                    Labe27.Text = "Enter/Select the date the warning was issued:"
                    ' RequiredFieldValidator18.ErrorMessage = "Enter a valid warning date.6"
                    ' RequiredFieldValidator18.Text = "Enter a valid warning date.9"

                    Panel6.Style("display") = "none"
                    Panel6.Style("visibility") = "hidden"
                    Panel7.Style("display") = "none"
                    Panel7.Style("visibility") = "hidden"


                    '' SqlDataSource26.SelectParameters("strReasonin").DefaultValue = warnlist2.SelectedItem.Text
                    '' SqlDataSource26.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
                    '' SqlDataSource26.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
                    '' SqlDataSource26.SelectParameters("nvcEmpLanIDin").DefaultValue = lan

                    ' SqlDataSource26.DataBind()
                    '  MsgBox(warnlist2.SelectedItem.Text)
                    ' MsgBox(RadioButtonList1.SelectedValue)
                    ' MsgBox(DropDownList3.SelectedItem.Text)
                    ''' MsgBox("6")
                    'MsgBox("changing2")
                    ''  warnReasons.DataSource = SqlDataSource26
                    ''  warnReasons.DataBind()


                    CustomValidator2.Enabled = False


                    '' RequiredFieldValidator11.Enabled = True
                    'RequiredFieldValidator10.Enabled = True
                    ''CustomValidator3.Enabled = True

                    nowarn.Style("display") = "none" 'inline
                    nowarn.Style("visibility") = "hidden" 'visible

                    RequiredFieldValidator49.Enabled = False
                    RequiredFieldValidator50.Enabled = False

                    'Label80.Text = "9. "
                    'Label83.Text = "10. "

                Else
                    'MsgBox("4")
                    warngroup1.Style("display") = "none" 'inline
                    warngroup1.Style("visibility") = "hidden" 'visible
                    '
                    Panel6.Style("display") = "inline"
                    Panel6.Style("visibility") = "visible"
                    Panel7.Style("display") = "inline"
                    Panel7.Style("visibility") = "visible"


                    '' CustomValidator2.Enabled = True

                    RequiredFieldValidator11.Enabled = False
                    'RequiredFieldValidator10.Enabled = False
                    CustomValidator3.Enabled = False

                    nowarn.Style("display") = "inline" 'inline
                    nowarn.Style("visibility") = "visible" 'visible

                    '' RequiredFieldValidator49.Enabled = True
                    ''RequiredFieldValidator50.Enabled = True


                    Labe27.Text = "Enter/Select the date of coaching:"

                    'Label80.Text = "11. "
                    'Label83.Text = "12. "
                End If

            Else

                'MsgBox("5")
                warngroup2.Visible = False

                Panel6.Style("display") = "inline"
                Panel6.Style("visibility") = "visible"
                Panel7.Style("display") = "inline"
                Panel7.Style("visibility") = "visible"

                '' CustomValidator2.Enabled = True

                RequiredFieldValidator11.Enabled = False
                'RequiredFieldValidator10.Enabled = False
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



        ' MsgBox("cse=" & cseradio.SelectedValue)
        ' MsgBox("onload-" & grid.ClientID)

        Dim d As CheckBox
        Dim f As RadioButtonList
        Dim g As ListBox
        Dim h As ListBox
        Dim j As RequiredFieldValidator
        Dim state As String
        state = "closed"


        If (warngroup2.Visible = False) Then ' check for regular coaching reasons - not warning

            RequiredFieldValidator11.Enabled = False
            'RequiredFieldValidator10.Enabled = False
            CustomValidator3.Enabled = False

            For i As Integer = 0 To (grid.Rows.Count - 1)
                'MsgBox("1row= " & i)
                For k As Integer = 0 To (grid.Columns.Count - 1)
                    Dim childc As Control

                    '   MsgBox("1column= " & k)

                    For Each childc In grid.Rows(i).Cells(k).Controls

                        If (TypeOf childc Is RequiredFieldValidator) Then
                            '        MsgBox("1state=" & state)
                            '       MsgBox("1id=" & childc.ClientID)
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
                            '     MsgBox("state=" & state)
                            'If (Len(f.SelectedValue) > 0) Then
                            'MsgBox(f.SelectedItem.ToString())

                            'f.Enabled = True

                            'Else

                            'f.Enabled = False
                            If (state = "open") Then

                                'Dim li1 As ListItem
                                '  MsgBox("radiolist=" & f.Enabled)

                                f.Enabled = True

                                'MsgBox("foundA")

                                ''

                                ' For Each li1 In f.Items

                                ' MsgBox("list bullet=" & li1.Enabled)
                                ' li1.Enabled = True

                                'Next
                            Else

                                f.Enabled = False


                            End If

                            For Each item As Object In f.Items

                                If (InStr(1, item.Text, "!", 1) > 0) Then
                                    item.Attributes.Add("style", "visibility: hidden;")
                                End If

                            Next
                            ' End If

                        End If


                    Next ' end of child list

                Next ' end of column


            Next ' end of row

            '' Else

            'check for warning conditions/selections


            '  warnlist2.SelectedValue
            ''RequiredFieldValidator11.Enabled = True
            'RequiredFieldValidator10.Enabled = True
            ''CustomValidator3.Enabled = True

        End If
        '''
        'Label10.Text = CDate(DateTime.Now()) 'DateTime.Today.ToShortDateString() 'DateTime.Now()
        Label10.Text = DateTime.Today.ToShortDateString() 'DateTime.Now()

        ' MsgBox("bubble = " & bubble)

    End Sub




    Protected Sub CheckBoxRequired_ServerValidate(ByVal Source As Object, ByVal args As ServerValidateEventArgs)

        args.IsValid = CheckBox1.Checked


    End Sub


    Protected Sub CheckBoxRequired2_ServerValidate(ByVal Source As Object, ByVal args As ServerValidateEventArgs)

        args.IsValid = CheckBox2.Checked


    End Sub


    Protected Sub Button2_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button2.Click

        Select Case True


            Case (InStr(1, lan, "vngt\", 1) > 0)
                lan = (Replace(lan, "vngt\", ""))
            Case (InStr(1, lan, "ad\", 1) > 0)
                lan = (Replace(lan, "ad\", ""))
            Case Else

                lan = lan

        End Select

        '' GridView2.DataBind()


        Dim formType = "Indirect"
        ' Dim grid As GridView
        ' grid = GridView2


        '*** Possibly check to see if at least one Coaching is selected when not CSE ***


        'modtype = Split(DropDownList3.SelectedItem.Value, "-", -1, 1)

        'If (modtype(3) = 1) Then

        'If (cseradio2.SelectedValue = "Yes") Then
        'grid = GridView6

        '''RequiredFieldValidator41.Enabled = True
        ' Label239.Text = "valid"
        'RequiredFieldValidator7.Enabled = False
        'Else
        'grid = GridView2

        'End If

        'End If

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
            'MsgBox("2row= " & i)
            For k As Integer = 0 To (grid.Columns.Count - 1)
                Dim childc As Control

                '   MsgBox("2column= " & k)

                For Each childc In grid.Rows(i).Cells(k).Controls

                    If (TypeOf childc Is RequiredFieldValidator) Then
                        ' MsgBox("2state=" & state)
                        'MsgBox("2id=" & childc.ClientID)
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
                                        'MsgBox("count=" & (g.Items.Count - 1))
                                        If ((state = "open") And (Len(g.Items(x).Value) > 0) And (g.Items(x).Selected = True)) Then
                                            '   MsgBox("found" & x & "=" & g.Items(x).Value)
                                            z = z & g.Items(x).Value & ","
                                            'z = z + ","
                                            '' coachR(found, 1) = g.Items(x).Value  ' Left(z, Len(z) - 1)
                                        End If

                                    Next
                                    ' MsgBox("z1=" & z)
                                    If (Len(z) > 0) Then

                                        coachR(found, 1) = Left(z, Len(z) - 1) 'g.Items(x).Value  '
                                        '  MsgBox("z2=" & coachR(found, 1))
                                    End If

                                End If



                            End If

                            If (TypeOf childgc Is RequiredFieldValidator) Then
                                '  MsgBox("2-state=" & state)
                                ' MsgBox("2-id=" & childgc.ClientID)
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
                        'MsgBox("checked=" & d.Checked)
                        If (d.Checked) Then

                            state = "open"
                            ' coachR(found, 0) = 

                        Else
                            state = "closed"
                        End If

                    End If

                    If (TypeOf childc Is Label) Then

                        m = CType(childc, Label)

                        If ((state = "open") And (InStr(1, m.ClientID, "Label65", 1) > 0)) Then

                            'MsgBox("name=" & a.ClientID)
                            'MsgBox("label=" & m.Text)
                            coachR(found, 0) = m.Text

                        End If

                    End If




                    If (TypeOf childc Is RadioButtonList) Then
                        f = CType(childc, RadioButtonList)
                        '     MsgBox("state=" & state)
                        'If (Len(f.SelectedValue) > 0) Then
                        'MsgBox(f.SelectedItem.ToString())

                        'f.Enabled = True

                        'Else

                        'f.Enabled = False
                        If (state = "open") Then

                            'Dim li1 As ListItem
                            '  MsgBox("radiolist=" & f.Enabled)
                            f.Enabled = True

                            ' For Each li1 In f.Items

                            ' MsgBox("list bullet=" & li1.Enabled)
                            ' li1.Enabled = True
                            ' MsgBox("testing1..." & f.SelectedValue)
                            ' MsgBox("testing2..." & f.SelectedIndex)
                            If (f.SelectedIndex <> -1) Then

                                coachR(found, 2) = (f.SelectedItem.ToString())

                            End If


                            'Next
                        Else

                            f.Enabled = False


                        End If

                        For Each item As Object In f.Items

                            If (InStr(1, item.Text, "!", 1) > 0) Then
                                item.Attributes.Add("style", "visibility: hidden;")
                            End If

                        Next

                        ' End If

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


            'do last minute check here

            '' GridView2.Visible = True

            'randomize - tail
            'For x As Integer = 0 To word.Length - 1
            'word(x) = chars.Chars(rnd.Next(chars.Length))
            'Next
            Randomize()
            digit = (Int(Rnd() * 1000000)).ToString


            Label160.Text = "eCL-" & Label17.Text & "-" & digit 'New String(word)

            Dim mailString As String
            Dim statusName As String


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


                ' strEmail = Label36.Text ' "jourdain.augustin@vangent.com"
                strFormID = Label160.Text
                'MsgBox(strFormID)

                strSubject = "eCL: " & statusName & " (" & strPerson & ")"




                mailString = (CType(GridView8.Rows(0).FindControl("mailText"), Label).Text)
                mailString = Replace(mailString, "strDateTime", DateTime.Now().ToString)
                mailString = Replace(mailString, "strPerson", strPerson)

                strCtrMessage = mailString & "  <br /><br />" & vbCrLf _
    & "  <a href=""https://f3420-mwbp11.vangent.local/coach/default.aspx"" target=""_blank"">Please click here to open the coaching application and select the &#39;My Dashboard&#39; tab to view the below form ID for details.</a>"

            End If



            'Panel0b.Visible = True
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



            '''      If (cseradio2.SelectedValue = "Yes") Then
            'MsgBox("cse=yes")
            '''SqlDataSource6.InsertParameters("intCoachReasonID1").DefaultValue = 6

            '''            SqlDataSource6.InsertParameters("intSubCoachReasonID1").DefaultValue = "test" ''' GridView6.Rows[0].FindControl("
            'csedrop2.SelectedValue()
            '''         SqlDataSource6.InsertParameters("nvcValue1").DefaultValue = ""
            '''      SqlDataSource6.InsertParameters("intCoachReasonID2").DefaultValue = ""
            '''   SqlDataSource6.InsertParameters("intSubCoachReasonID2").DefaultValue = ""
            ''' SqlDataSource6.InsertParameters("nvcValue2").DefaultValue = ""
            '''SqlDataSource6.InsertParameters("intCoachReasonID3").DefaultValue = ""
            '''SqlDataSource6.InsertParameters("intSubCoachReasonID3").DefaultValue = ""
            '''SqlDataSource6.InsertParameters("nvcValue3").DefaultValue = ""
            '''SqlDataSource6.InsertParameters("intCoachReasonID4").DefaultValue = ""
            '''SqlDataSource6.InsertParameters("intSubCoachReasonID4").DefaultValue = ""
            '''SqlDataSource6.InsertParameters("nvcValue4").DefaultValue = ""

            '''Else
            'MsgBox("cse=no")
            Dim x
            Dim a, b, c
            '  MsgBox(found)
            For x = 0 To (found - 1)

                a = "intCoachReasonID" & x + 1
                b = "nvcSubCoachReasonID" & x + 1
                c = "nvcValue" & x + 1

                ' MsgBox(coachR(x, 1))
                SqlDataSource6.InsertParameters(a).DefaultValue = coachR(x, 0)
                SqlDataSource6.InsertParameters(b).DefaultValue = coachR(x, 1)
                SqlDataSource6.InsertParameters(c).DefaultValue = coachR(x, 2)
                'MsgBox("1-" & coachR(x, 0))
                'MsgBox("2-" & coachR(x, 1))
                'MsgBox("3-" & coachR(x, 2))


                '  MsgBox(a)
                '   MsgBox(coachR(x, 0))
                ' MsgBox(b)
                ' MsgBox(coachR(x, 1))
                '  MsgBox(c)
                ' MsgBox(coachR(x, 2))
                ' MsgBox(a)
                'MsgBox(b)
                'MsgBox(c)


            Next

            If (found < 12) Then

                For x = (found + 1) To 12 '(12 - found)
                    'MsgBox(x & " ID")
                    a = "intCoachReasonID" & x
                    b = "nvcSubCoachReasonID" & x
                    c = "nvcValue" & x

                    SqlDataSource6.InsertParameters(a).DefaultValue = ""
                    SqlDataSource6.InsertParameters(b).DefaultValue = ""
                    SqlDataSource6.InsertParameters(c).DefaultValue = ""

                    'MsgBox(a)
                    'MsgBox(b)
                    'MsgBox(c)
                Next


            End If


            ''' End If
            '  MsgBox(Label68.Text)
            ' MsgBox(TextBox5.Text)


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


            '       SqlDataSource6.InsertParameters("nvcSubmitterName").DefaultValue = Label178.Text
            '      SqlDataSource6.InsertParameters("nvcSubmitterEmail").DefaultValue = Replace(Label180.Text, "'", "''") 'Label180.Text
            '     SqlDataSource6.InsertParameters("nvcCSRName").DefaultValue = Replace(Label23.Text, "'", "&prime;")
            '    SqlDataSource6.InsertParameters("nvcCSREmail").DefaultValue = Replace(Label19.Text, "'", "''") 'Label19.Text

            'SqlDataSource6.InsertParameters("nvcCSRSup").DefaultValue = Label28.Text
            'SqlDataSource6.InsertParameters("nvcCSRSupName").DefaultValue = Label32.Text
            'SqlDataSource6.InsertParameters("nvcCSRSupEmail").DefaultValue = Replace(Label36.Text, "'", "''") 'Label36.Text
            'SqlDataSource6.InsertParameters("nvcCSRMgr").DefaultValue = Label47.Text
            'SqlDataSource6.InsertParameters("nvcCSRMgrName").DefaultValue = Label53.Text
            'SqlDataSource6.InsertParameters("nvcCSRMgrEmail").DefaultValue = Replace(Label55.Text, "'", "''") 'Label55.Text
            'SqlDataSource6.InsertParameters("nvcCID").DefaultValue = ""
            'SqlDataSource6.InsertParameters("bitisVerintMonitor").DefaultValue = CBool(Label62.Text)

            SqlDataSource6.InsertParameters("bitEmailSent").DefaultValue = "True" 'mailSent
            ' MsgBox(moduleIDlbl.Text)
            SqlDataSource6.InsertParameters("ModuleID").DefaultValue = moduleIDlbl.Text 'DropDownList3.SelectedItem.Text



            'MsgBox("inserting")
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

        Select Case True


            Case (InStr(1, lan, "vngt\", 1) > 0)
                lan = (Replace(lan, "vngt\", ""))
            Case (InStr(1, lan, "ad\", 1) > 0)
                lan = (Replace(lan, "ad\", ""))
            Case Else

                lan = lan

        End Select


        ''  GridView2.DataBind()
        Dim formType = "Direct"
        'Dim grid As GridView = GridView4

        '*** Possibly check to see if at least one Coaching is selected when not CSE ***
        '   MsgBox(cseradio.SelectedValue)

        ' modtype = Split(DropDownList3.SelectedItem.Value, "-", -1, 1)
        'MsgBox(modtype(3))
        'If (modtype(3) = 1) Then


        'If (cseradio.SelectedValue = "Yes") Then
        'grid = GridView5
        '  RequiredFieldValidator57.Enabled = True

        '  TextBox1.Text = "valid"
        ' RequiredFieldValidator28.Enabled = False

        'turn off validator for remaining reasons
        'Else
        ' RequiredFieldValidator57.Enabled = False
        'grid = GridView4


        'End If

        'End If

        'modtype = Split(DropDownList3.SelectedItem.Value, "-", -1, 1)

        'If (modtype(3) = 1) Then

        'If (cseradio.SelectedValue = "Yes") Then
        'grid = GridView5

        '''RequiredFieldValidator41.Enabled = True
        ' Label239.Text = "valid"
        'RequiredFieldValidator7.Enabled = False
        'Else
        'grid = GridView4

        'End If

        'End If
        ' MsgBox("hello1")
        'MsgBox(LCase(Label28.Text))
        'MsgBox(LCase(Label47.Text))
        'MsgBox(modtype(4))
        'MsgBox(warnlist.SelectedIndex)

        RequiredFieldValidator18.Enabled = True
        CompareValidator2.Enabled = True
        RequiredFieldValidator49.Enabled = True
        RequiredFieldValidator50.Enabled = True
        RequiredFieldValidator24.Enabled = True
        CustomValidator2.Enabled = True


        If (((lan = LCase(Label28.Text)) Or (lan = LCase(Label47.Text))) And (modtype(4) = 1)) Then
            'MsgBox("hello2")

            ' MsgBox("2")
            warngroup2.Visible = True
            ' grid = GridView7

            If (warnlist.SelectedIndex = 0) Then
                ' MsgBox("3")
                warngroup1.Style("display") = "inline" 'inline
                warngroup1.Style("visibility") = "visible" 'visible

                Labe27.Text = "Enter/Select the date the warning was issued:"
                'RequiredFieldValidator18.ErrorMessage = "Enter a valid warning date.2"
                RequiredFieldValidator18.Text = "Enter a valid warning date."

                Panel6.Style("display") = "none"
                Panel6.Style("visibility") = "hidden"
                Panel7.Style("display") = "none"
                Panel7.Style("visibility") = "hidden"

                nowarn.Style("display") = "none" 'inline
                nowarn.Style("visibility") = "hidden" 'visible

                RequiredFieldValidator49.Enabled = False
                RequiredFieldValidator50.Enabled = False


                'Label80.Text = "9. "
                'Label83.Text = "10. "
                ''' MsgBox("b")

                '' SqlDataSource26.SelectParameters("strReasonin").DefaultValue = warnlist2.SelectedItem.Text
                ''SqlDataSource26.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
                '' SqlDataSource26.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
                ''  SqlDataSource26.SelectParameters("nvcEmpLanIDin").DefaultValue = lan

                'SqlDataSource26.DataBind()

                ' warnReasons.DataSource = SqlDataSource26
                'warnReasons.DataBind()

                CustomValidator2.Enabled = False

                ''  RequiredFieldValidator11.Enabled = True
                'RequiredFieldValidator10.Enabled = True
                ''CustomValidator3.Enabled = True

            Else
                '   MsgBox("4")
                warngroup1.Style("display") = "none" 'inline
                warngroup1.Style("visibility") = "hidden" 'visible

                Panel6.Style("display") = "inline"
                Panel6.Style("visibility") = "visible"
                Panel7.Style("display") = "inline"
                Panel7.Style("visibility") = "visible"

                CustomValidator2.Enabled = True

                RequiredFieldValidator11.Enabled = False
                'RequiredFieldValidator10.Enabled = False
                CustomValidator3.Enabled = False

                Labe27.Text = "Enter/Select the date of coaching:"
                RequiredFieldValidator18.Text = "Enter a valid coaching date."

            End If

        Else

            'MsgBox("5")
            warngroup2.Visible = False

            Panel6.Style("display") = "inline"
            Panel6.Style("visibility") = "visible"
            Panel7.Style("display") = "inline"
            Panel7.Style("visibility") = "visible"

            nowarn.Style("display") = "inline" 'inline
            nowarn.Style("visibility") = "visible" 'visible

            RequiredFieldValidator49.Enabled = True
            RequiredFieldValidator50.Enabled = True


            'Label80.Text = "11. "
            'Label83.Text = "12. "

            CustomValidator2.Enabled = True

            RequiredFieldValidator11.Enabled = False
            'RequiredFieldValidator10.Enabled = False
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
                'MsgBox("2row= " & i)
                For k As Integer = 0 To (grid.Columns.Count - 1)
                    Dim childc As Control

                    '   MsgBox("2column= " & k)

                    For Each childc In grid.Rows(i).Cells(k).Controls

                        If (TypeOf childc Is RequiredFieldValidator) Then
                            ' MsgBox("2state=" & state)
                            'MsgBox("2id=" & childc.ClientID)
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
                                            'MsgBox("count=" & (g.Items.Count - 1))
                                            If ((state = "open") And (Len(g.Items(x).Value) > 0) And (g.Items(x).Selected = True)) Then
                                                '   MsgBox("found" & x & "=" & g.Items(x).Value)
                                                z = z & g.Items(x).Value & ","
                                                'z = z + ","
                                                '' coachR(found, 1) = g.Items(x).Value  ' Left(z, Len(z) - 1)
                                            End If

                                        Next
                                        ' MsgBox("z1=" & z)
                                        If (Len(z) > 0) Then

                                            coachR(found, 1) = Left(z, Len(z) - 1) 'g.Items(x).Value  '
                                            '  MsgBox("z2=" & coachR(found, 1))
                                        End If

                                    End If



                                End If

                                If (TypeOf childgc Is RequiredFieldValidator) Then
                                    '  MsgBox("2-state=" & state)
                                    ' MsgBox("2-id=" & childgc.ClientID)
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
                            'MsgBox("checked=" & d.Checked)
                            If (d.Checked) Then

                                state = "open"
                                ' coachR(found, 0) = 

                            Else
                                state = "closed"
                            End If

                        End If

                        If (TypeOf childc Is Label) Then

                            m = CType(childc, Label)

                            If ((state = "open") And (InStr(1, m.ClientID, "Label65", 1) > 0)) Then

                                ' MsgBox("name=" & m.ClientID)
                                'MsgBox("label=" & m.Text)
                                coachR(found, 0) = m.Text

                            End If

                        End If




                        If (TypeOf childc Is RadioButtonList) Then
                            f = CType(childc, RadioButtonList)
                            '     MsgBox("state=" & state)
                            'If (Len(f.SelectedValue) > 0) Then
                            'MsgBox(f.SelectedItem.ToString())

                            'f.Enabled = True

                            'Else

                            'f.Enabled = False
                            If (state = "open") Then


                                ' MsgBox("foundB")

                                'Dim li1 As ListItem
                                '  MsgBox("radiolist=" & f.Enabled)
                                f.Enabled = True

                                ' For Each li1 In f.Items

                                ' MsgBox("list bullet=" & li1.Enabled)
                                ' li1.Enabled = True
                                ' MsgBox("testing1..." & f.SelectedValue)
                                ' MsgBox("testing2..." & f.SelectedIndex)
                                If (f.SelectedIndex <> -1) Then

                                    coachR(found, 2) = (f.SelectedItem.ToString())

                                End If


                                'Next
                            Else

                                f.Enabled = False


                            End If


                            For Each item As Object In f.Items

                                If (InStr(1, item.Text, "!", 1) > 0) Then
                                    item.Attributes.Add("style", "visibility: hidden;")
                                End If

                            Next
                            ' End If

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

      
            '''MsgBox("7")

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
           ' RequiredFieldValidator10.Enabled = True
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
            '' RequiredFieldValidator28.Enabled = True

            RequiredFieldValidator11.Enabled = False
            'RequiredFieldValidator10.Enabled = False
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
        'MsgBox("validating Button 5...")

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
            ' MsgBox(msg)
        End If


        If Page.IsValid Then
            '  MsgBox("# of coaching reasons =" & found & "- validating....")

            ' For x As Integer = 0 To word.Length - 1
            'word(x) = chars.Chars(Rnd.Next(chars.Length))
            'Next

            Randomize()
            digit = (Int(Rnd() * 1000000)).ToString

            Label160.Text = "eCL-" & Label17.Text & "-" & digit 'New String(word)


            Dim mailString As String
            Dim statusName2 As String


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

            'MsgBox(Label95.Text)
            If (warnlist.SelectedIndex = 0) Then
                '   MsgBox(TextBox11.Text)
                '   MsgBox(Label93.Text)
                SqlDataSource27.InsertParameters("nvcEmplanID").DefaultValue = Label17.Text
                SqlDataSource27.InsertParameters("nvcFormName").DefaultValue = Label160.Text '"eCL-" & lan & numCount.Text



                If (modtype(0) = 1) Then

                    SqlDataSource27.InsertParameters("SiteID").DefaultValue = DropDownList1.SelectedValue 'Label49.Text 'Label49.Text

                Else

                    SqlDataSource27.InsertParameters("SiteID").DefaultValue = "" 'Label49.Text 'Label49.Text


                End If


                SqlDataSource27.InsertParameters("nvcSubmitter").DefaultValue = lan
                SqlDataSource27.InsertParameters("dtmEventDate").DefaultValue = CDate(Label69.Text)


                'MsgBox("cse=no")
                ' Dim x = 0
                ' Dim a, b, c
                ' MsgBox(found)
                '  For x = 0 To 1 '(found - 1)

                'a = "intCoachReasonID" & x + 1
                'b = "nvcSubCoachReasonID" & x + 1
                'c = "nvcValue" & x + 1

                ' MsgBox(a)
                ' MsgBox(b)
                ' MsgBox(c)
                ' MsgBox(coachR(x, 0))
                ' MsgBox(coachR(x, 1))

                '  MsgBox(coachR(0, 1))
                SqlDataSource27.InsertParameters("intCoachReasonID1").DefaultValue = coachR(0, 0)
                SqlDataSource27.InsertParameters("nvcSubCoachReasonID1").DefaultValue = coachR(0, 1)
                ' SqlDataSource27.InsertParameters("nvcValue").DefaultValue = coachR(0, 2)

                ' MsgBox(a)
                ' MsgBox(coachR(x, 0))
                'MsgBox(b)
                'MsgBox(coachR(x, 1))
                'MsgBox(c)
                'MsgBox(coachR(x, 2))
                ' MsgBox(a)
                ' MsgBox(b)
                ' MsgBox(c)


                'Next

                ' If (found > 12) Then ' change back to <
                'For x = (found + 1) To 12 '(12 - found)
                '  MsgBox(x & " ID")
                ' a = "intCoachReasonID" & x
                ' b = "nvcSubCoachReasonID" & x
                '   c = "nvcValue" & x

                '   SqlDataSource27.InsertParameters(a).DefaultValue = ""
                '   SqlDataSource27.InsertParameters(b).DefaultValue = ""
                '    SqlDataSource27.InsertParameters(c).DefaultValue = ""

                ' MsgBox(a)
                ' MsgBox(b)
                ' MsgBox(c)
                '    Next

                '    End If

                '   MsgBox(TextBox11.Text)
                ' MsgBox(Label93.Text)

                'MsgBox(Label95.Text)
                If (modtype(5) = 1) Then

                    SqlDataSource27.InsertParameters("nvcProgramName").DefaultValue = programList.SelectedValue

                Else
                    SqlDataSource27.InsertParameters("nvcProgramName").DefaultValue = ""

                End If


                '' If (modtype(6) = 1) Then

                '' SqlDataSource27.InsertParameters("Behaviour").DefaultValue = behaviorList.SelectedValue

                ''Else
                ''  SqlDataSource27.InsertParameters("Behaviour").DefaultValue = ""

                ''End If

                'SqlDataSource27.InsertParameters("nvcProgramName").DefaultValue = programList.SelectedValue
                'SqlDataSource27.InsertParameters("nvcDescription").DefaultValue = Label93.Text
                'SqlDataSource27.InsertParameters("nvcCoachingNotes").DefaultValue = Label95.Text

                ' SqlDataSource6.InsertParameters("bitisVerified").DefaultValue = True
                SqlDataSource27.InsertParameters("dtmSubmittedDate").DefaultValue = DateTime.Now()
                ' SqlDataSource27.InsertParameters("dtmStartDate").DefaultValue = CDate(Label10.Text)
                '
                ' SqlDataSource27.InsertParameters("dtmSupReviewedAutoDate").DefaultValue = ""

                ' If (cseradio.SelectedValue = "Yes") Then

                'SqlDataSource6.InsertParameters("bitisCSE").DefaultValue = True 'False

                'Else
                '   SqlDataSource6.InsertParameters("bitisCSE").DefaultValue = False 'False

                'End If
                ' MsgBox(mailSent)
                'SqlDataSource6.InsertParameters("dtmMgrReviewManualDate").DefaultValue = ""
                'SqlDataSource6.InsertParameters("dtmMgrReviewAutoDate").DefaultValue = ""
                'SqlDataSource6.InsertParameters("nvcMgrNotes").DefaultValue = ""
                'SqlDataSource6.InsertParameters("bitisCSRAcknowledged").DefaultValue = "" 'False
                'SqlDataSource6.InsertParameters("dtmCSRReviewAutoDate").DefaultValue = ""
                'SqlDataSource6.InsertParameters("nvcCSRComments").DefaultValue = ""



                ' SqlDataSource6.InsertParameters("bitEmailSent").DefaultValue = "True" 'mailSent
                ' MsgBox(moduleIDlbl.Text)
                SqlDataSource27.InsertParameters("ModuleID").DefaultValue = moduleIDlbl.Text 'DropDownList3.SelectedItem.Text




                SqlDataSource27.Insert()
                ' If (Label156.Text <> 1) Then

                ' SendMail_OnInsert()


                'End If

                'Response.Redirect("default.aspx")


                'submit data

                If (Len(Label169.Text) = 0) Then

                    FromURL = Request.ServerVariables("URL")
                    Response.Redirect("next1.aspx?FromURL=" & FromURL)

                End If

            Else

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


                'MsgBox("cse=no")
                Dim x
                Dim a, b, c
                ' MsgBox(found)
                For x = 0 To (found - 1)

                    a = "intCoachReasonID" & x + 1
                    b = "nvcSubCoachReasonID" & x + 1
                    c = "nvcValue" & x + 1

                    ' MsgBox(a)
                    ' MsgBox(b)
                    ' MsgBox(c)
                    ' MsgBox(coachR(x, 0))
                    ' MsgBox(coachR(x, 1))

                    SqlDataSource6.InsertParameters(a).DefaultValue = coachR(x, 0)
                    SqlDataSource6.InsertParameters(b).DefaultValue = coachR(x, 1)
                    SqlDataSource6.InsertParameters(c).DefaultValue = coachR(x, 2)

                    ' MsgBox(a)
                    ' MsgBox(coachR(x, 0))
                    'MsgBox(b)
                    'MsgBox(coachR(x, 1))
                    'MsgBox(c)
                    'MsgBox(coachR(x, 2))
                    ' MsgBox(a)
                    ' MsgBox(b)
                    ' MsgBox(c)


                Next

                If (found < 12) Then
                    For x = (found + 1) To 12 '(12 - found)
                        '  MsgBox(x & " ID")
                        a = "intCoachReasonID" & x
                        b = "nvcSubCoachReasonID" & x
                        c = "nvcValue" & x

                        SqlDataSource6.InsertParameters(a).DefaultValue = ""
                        SqlDataSource6.InsertParameters(b).DefaultValue = ""
                        SqlDataSource6.InsertParameters(c).DefaultValue = ""

                        ' MsgBox(a)
                        ' MsgBox(b)
                        ' MsgBox(c)
                    Next

                End If


                'MsgBox(Label93.Text)
                'MsgBox(Label95.Text)
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
                ' MsgBox(mailSent)
                SqlDataSource6.InsertParameters("dtmMgrReviewManualDate").DefaultValue = ""
                SqlDataSource6.InsertParameters("dtmMgrReviewAutoDate").DefaultValue = ""
                SqlDataSource6.InsertParameters("nvcMgrNotes").DefaultValue = ""
                SqlDataSource6.InsertParameters("bitisCSRAcknowledged").DefaultValue = "" 'False
                SqlDataSource6.InsertParameters("dtmCSRReviewAutoDate").DefaultValue = ""
                SqlDataSource6.InsertParameters("nvcCSRComments").DefaultValue = ""



                SqlDataSource6.InsertParameters("bitEmailSent").DefaultValue = "True" 'mailSent
                ' MsgBox(moduleIDlbl.Text)
                SqlDataSource6.InsertParameters("ModuleID").DefaultValue = moduleIDlbl.Text 'DropDownList3.SelectedItem.Text




                SqlDataSource6.Insert()
                If (Label156.Text <> 1) Then

                    SendMail_OnInsert()


                End If

                'Response.Redirect("default.aspx")


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
        ' If (e.Command.Parameters("@Indirect@return_value").Value) Then
        'uncomment when there is an ARC check
        '  MsgBox(e.Command.Parameters("@Indirect@return_value"))
        ' MsgBox(e.Command.Parameters("@Indirect@return_value").Value)
        Label241.Text = e.Command.Parameters("@Indirect@return_value").Value

        'Else
        'Label241.Text = 0
        'End If

        'Label241.Text = e.Command.Parameters("@Indirect@return_value").Value
    End Sub


    Protected Sub CustomValidator1_ServerValidate(ByVal sender As Object, ByVal args As ServerValidateEventArgs)
        ' Indirect must be RadioButton1 or RadioButton2
        args.IsValid = (RadioButton1.Checked Or RadioButton2.Checked)

        If Page.IsValid Then
            ' Label2.Text = ""

            If RadioButton1.Checked Then

                RequiredFieldValidator21.Enabled = True
                RegularExpressionValidator1.Enabled = True
            Else
                RequiredFieldValidator21.Enabled = False
                RegularExpressionValidator1.Enabled = False

            End If

            ' Else
            '    Label2.Text = "Please correct all fields indicated in red to proceed."

        End If

    End Sub

    Protected Sub CustomValidator4_ServerValidate(ByVal sender As Object, ByVal args As ServerValidateEventArgs)
        ' MsgBox("1=" & LCase(Label17.Text))
        'MsgBox("2=" & LCase(lan))
        args.IsValid = (LCase(Label17.Text) <> LCase(lan))

        If Not (Page.IsValid) Then
            ' MsgBox("true")
            CustomValidator4.Enabled = False
        Else
            'MsgBox("false")
            CustomValidator4.Enabled = True
        End If

    End Sub

    Protected Sub CustomValidator2_ServerValidate(ByVal sender As Object, ByVal args As ServerValidateEventArgs)
        ' Direct must be RadioButton3 or RadioButton4
        args.IsValid = (RadioButton3.Checked Or RadioButton4.Checked)

        If Page.IsValid Then
            'Label169.Text = ""

            If RadioButton3.Checked Then

                RequiredFieldValidator3.Enabled = True
                RegularExpressionValidator2.Enabled = True
            Else
                RequiredFieldValidator3.Enabled = False
                RegularExpressionValidator2.Enabled = False

            End If
            ' Else
            '    Label169.Text = "Please correct all fields indicated in red to proceed."
        End If

    End Sub

    Protected Sub CustomValidator3_ServerValidate(ByVal sender As Object, ByVal args As ServerValidateEventArgs)
        ' Indirect must be RadioButton1 or RadioButton2
        ' MsgBox(warnReasons.SelectedIndex)
        ' MsgBox(warnReasons.SelectedValue)

        If (warnReasons.Items(0).Selected = True) Then

            args.IsValid = False

        Else

            args.IsValid = True

        End If



    End Sub



    Protected Sub OnRowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs) Handles GridView2.RowDataBound

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

            SqlDataSource17.SelectParameters("strReasonin").DefaultValue = reason.Text

            SqlDataSource17.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource17.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

            rowButtons.DataSource = SqlDataSource17
            rowButtons.DataBind()


            Dim subMenu As ListBox = e.Row.FindControl("SubReasons")

            'MsgBox(reason.Text)
            SqlDataSource11.SelectParameters("strReasonin").DefaultValue = reason.Text

            SqlDataSource11.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource11.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource11.SelectParameters("nvcEmpLanIDin").DefaultValue = lan


            subMenu.DataSource = SqlDataSource11
            subMenu.DataBind()

            ''Dim validation1 As RequiredFieldValidator = e.Row.FindControl("RequiredFieldValidator1")
            ' MsgBox(validation1)
            ' MsgBox(validation1.ControlToValidate)
            ' MsgBox(subMenu.ClientID)

            'validation1.ControlToValidate = subMenu.ClientID

            ''Dim validation2 As RequiredFieldValidator = e.Row.FindControl("RequiredFieldValidator2")


            ' validation2.ControlToValidate = rowButtons.ClientID


            ''rowCheck.Attributes.Add("onclick", "javascript: togglemenu(" & rowCheck.ClientID & "," & rowPanel.ClientID & "," & rowButtons.ClientID & "," & validation1.ClientID & "," & validation2.ClientID & "," & subMenu.ClientID & ");")
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



            SqlDataSource16.SelectParameters("strReasonin").DefaultValue = reason.Text

            SqlDataSource16.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource16.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

            rowButtons.DataSource = SqlDataSource16
            rowButtons.DataBind()


            Dim subMenu As ListBox = e.Row.FindControl("SubReasons")

            'MsgBox(reason.Text)
            SqlDataSource13.SelectParameters("strReasonin").DefaultValue = reason.Text
            SqlDataSource13.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource13.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource13.SelectParameters("nvcEmpLanIDin").DefaultValue = lan

            subMenu.DataSource = SqlDataSource13
            subMenu.DataBind()

            '' Dim validation1 As RequiredFieldValidator = e.Row.FindControl("RequiredFieldValidator1")
            ' MsgBox(validation1)
            ' MsgBox(validation1.ControlToValidate)
            ' MsgBox(subMenu.ClientID)

            'validation1.ControlToValidate = subMenu.ClientID

            '' Dim validation2 As RequiredFieldValidator = e.Row.FindControl("RequiredFieldValidator2")


            ' validation2.ControlToValidate = rowButtons.ClientID


            ''rowCheck.Attributes.Add("onclick", "javascript: togglemenu(" & rowCheck.ClientID & "," & rowPanel.ClientID & "," & rowButtons.ClientID & "," & validation1.ClientID & "," & validation2.ClientID & "," & subMenu.ClientID & ");")
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

            SqlDataSource20.SelectParameters("strReasonin").DefaultValue = reason.Text

            SqlDataSource20.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource20.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

            rowButtons.DataSource = SqlDataSource20
            rowButtons.DataBind()


            Dim subMenu As ListBox = e.Row.FindControl("SubReasons")

            'MsgBox(reason.Text)
            SqlDataSource19.SelectParameters("strReasonin").DefaultValue = reason.Text
            SqlDataSource19.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource19.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource19.SelectParameters("nvcEmpLanIDin").DefaultValue = lan

            subMenu.DataSource = SqlDataSource19
            subMenu.DataBind()

            Dim validation1 As RequiredFieldValidator = e.Row.FindControl("RequiredFieldValidator1")
            ' MsgBox(validation1)
            ' MsgBox(validation1.ControlToValidate)
            ' MsgBox(subMenu.ClientID)

            'validation1.ControlToValidate = subMenu.ClientID

            Dim validation2 As RequiredFieldValidator = e.Row.FindControl("RequiredFieldValidator2")


            ' validation2.ControlToValidate = rowButtons.ClientID


            'rowCheck.Attributes.Add("onclick", "javascript: togglemenu(" & rowCheck.ClientID & "," & rowPanel.ClientID & "," & rowButtons.ClientID & "," & validation1.ClientID & "," & validation2.ClientID & "," & subMenu.ClientID & ");")
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

            SqlDataSource23.SelectParameters("strReasonin").DefaultValue = reason.Text

            SqlDataSource23.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource23.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

            'MsgBox(reason.Text)
            'MsgBox(RadioButtonList1.SelectedValue)
            'MsgBox(DropDownList3.SelectedItem.Text)

            rowButtons.DataSource = SqlDataSource23
            rowButtons.DataBind()


            Dim subMenu As ListBox = e.Row.FindControl("SubReasons")

            'MsgBox(reason.Text)
            SqlDataSource22.SelectParameters("strReasonin").DefaultValue = reason.Text
            SqlDataSource22.SelectParameters("strSourcein").DefaultValue = RadioButtonList1.SelectedValue
            SqlDataSource22.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource22.SelectParameters("nvcEmpLanIDin").DefaultValue = lan

            subMenu.DataSource = SqlDataSource22
            subMenu.DataBind()

            Dim validation1 As RequiredFieldValidator = e.Row.FindControl("RequiredFieldValidator1")
            ' MsgBox(validation1)
            ' MsgBox(validation1.ControlToValidate)
            ' MsgBox(subMenu.ClientID)

            'validation1.ControlToValidate = subMenu.ClientID

            Dim validation2 As RequiredFieldValidator = e.Row.FindControl("RequiredFieldValidator2")


            ' validation2.ControlToValidate = rowButtons.ClientID


            'rowCheck.Attributes.Add("onclick", "javascript: togglemenu(" & rowCheck.ClientID & "," & rowPanel.ClientID & "," & rowButtons.ClientID & "," & validation1.ClientID & "," & validation2.ClientID & "," & subMenu.ClientID & ");")
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

        'Server.Transfer("/default2")

    End Sub

    Protected Sub Button1_Click1(ByVal sender As Object, e As EventArgs) Handles Button1.Click
        Response.Redirect("default2.aspx")
        'Server.Transfer("/default2")
    End Sub


    Protected Sub cseradio_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cseradio.SelectedIndexChanged

        '  MsgBox(cseradio.SelectedValue)
        '  MsgBox(cseradio.SelectedIndex)
        'SqlDataSource12.SelectParameters("strSourcein").DefaultValue = "Direct"
        'SqlDataSource12.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

        If cseradio.SelectedValue = "Yes" Then

            SqlDataSource18.SelectParameters("strSourcein").DefaultValue = "Direct"
            SqlDataSource18.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource18.SelectParameters("isSplReason").DefaultValue = True
            SqlDataSource18.SelectParameters("splReasonPrty").DefaultValue = 2
            'MsgBox(Label17.Text)
            SqlDataSource18.SelectParameters("strCSRin").DefaultValue = Label17.Text
            SqlDataSource18.SelectParameters("strSubmitterin").DefaultValue = lan

            GridView5.DataBind()

        Else

            SqlDataSource12.SelectParameters("strSourcein").DefaultValue = "Direct"
            SqlDataSource12.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource12.SelectParameters("isSplReason").DefaultValue = False
            SqlDataSource12.SelectParameters("splReasonPrty").DefaultValue = 2
            'MsgBox(Label17.Text)
            SqlDataSource12.SelectParameters("strCSRin").DefaultValue = Label17.Text
            SqlDataSource12.SelectParameters("strSubmitterin").DefaultValue = lan

            GridView4.DataBind()


        End If

    End Sub

    Protected Sub cseradio2_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cseradio2.SelectedIndexChanged
        '  MsgBox(cseradio2.SelectedValue)
        ' MsgBox(cseradio2.SelectedIndex)
        'SqlDataSource10.SelectParameters("strSourcein").DefaultValue = "Indirect"
        'SqlDataSource10.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text

        If cseradio2.SelectedValue = "Yes" Then

            SqlDataSource21.SelectParameters("strSourcein").DefaultValue = "Indirect"
            SqlDataSource21.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource21.SelectParameters("isSplReason").DefaultValue = True
            SqlDataSource21.SelectParameters("splReasonPrty").DefaultValue = 2
            ' MsgBox(Label17.Text)
            SqlDataSource21.SelectParameters("strCSRin").DefaultValue = Label17.Text
            SqlDataSource21.SelectParameters("strSubmitterin").DefaultValue = lan

            GridView6.DataBind()

        Else

            SqlDataSource10.SelectParameters("strSourcein").DefaultValue = "Indirect"
            SqlDataSource10.SelectParameters("strModulein").DefaultValue = DropDownList3.SelectedItem.Text
            SqlDataSource10.SelectParameters("isSplReason").DefaultValue = False
            SqlDataSource10.SelectParameters("splReasonPrty").DefaultValue = 2
            ' MsgBox(Label17.Text)
            SqlDataSource10.SelectParameters("strCSRin").DefaultValue = Label17.Text
            SqlDataSource10.SelectParameters("strSubmitterin").DefaultValue = lan

            GridView2.DataBind()

        End If

    End Sub



    Protected Sub module_SelectedIndexChanged(sender As Object, e As EventArgs) Handles DropDownList3.SelectedIndexChanged

        '  MsgBox(cseradio.SelectedValue)
        '  MsgBox(cseradio.SelectedIndex)
        Dim modSplit As Array


        modSplit = Split(DropDownList3.SelectedValue, "-", -1, 1)
        Label6.Text = "New - " & modSplit(1) & " Coaching"

    End Sub



    Protected Sub SqlDataSource1_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource1.Selecting
        'EC.sp_Select_Employees_By_Module 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



  Protected Sub SqlDataSource2_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource2.Selecting

        'EC.sp_Whoami
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


    ' Protected Sub SqlDataSource5_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource5.Selecting

    'EC.sp_SelectMaxnumID2 
    ' e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    'End Sub

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