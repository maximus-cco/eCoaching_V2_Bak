Imports System.Data.SqlClient
Imports System.Net.Mail
Imports System
Imports System.Configuration
Imports System.Web.UI.WebControls
Imports AjaxControlToolkit


Public Class review
    Inherits BasePage

    Dim pHolder As Label
    Dim panelHolder As Panel
    Dim pHolder2 As Label
    Dim panelHolder2 As Panel
    Dim recStatus As Label
    Dim userTitle As String

    Dim panelHolder1 As Panel
    Dim statusLevel As String

    Dim TodaysDate As String = DateTime.Today.ToShortDateString()
    Dim FromURL As String

    'Dim lan As String

    Protected Sub Page_Load2(ByVal sender As Object, ByVal e As System.EventArgs) Handles ListView1.DataBound 'record modifyable
        Dim eclUser As User = Session("eclUser")
        Dim lan As String = eclUser.LanID

        Dim pHolder1a As Label
        Dim pHolder2a As Label
        Dim pHolder3a As Label
        Dim pHolder4a As Label


        pHolder1a = ListView1.Items(0).FindControl("Label88")
        pHolder2a = ListView1.Items(0).FindControl("Label45")
        pHolder3a = ListView1.Items(0).FindControl("Label75")
        pHolder4a = ListView1.Items(0).FindControl("Label125")
        'MsgBox(Label241.Text)
        If (((lan <> LCase(pHolder4a.Text)) And (lan <> LCase(pHolder1a.Text)) And (lan <> LCase(pHolder2a.Text)) And (lan <> LCase(pHolder3a.Text))) Or ((lan = LCase(pHolder4a.Text)) And (CInt(Label241.Text) > 0))) Then

            'MsgBox("you are not of the 3")

            Response.Redirect("error3.aspx")

        End If




        'if user is CSR III and submitter then redirect
        ' Case (InStr(1, LCase(arcAccess), lan, 1) > 0)
        'MsgBox(LCase(pHolder4a.Text))
        ' MsgBox(Label241.Text)
        'If ((lan = LCase(pHolder4a.Text)) And (InStr(1, LCase(arcAccess), lan, 1) > 0)) Then
        ' If ((lan = LCase(pHolder4a.Text)) And (Len(Label241.Text) > 0)) Then
        'Response.Redirect("error3.aspx")

        'End If



        'Dim i As Integer
        ' MsgBox("hello")
        'MsgBox(ListView1.Items.Count)
        ' For i = 0 To ListView1.Items.Count - 1
        'MsgBox(i & "-")



        pHolder = ListView1.Items(0).FindControl("Label50")
        Label3.Text = pHolder.Text
        pHolder = ListView1.Items(0).FindControl("Label51")
        'Label10.Text = (CDate(pHolder.Text)).ToShortDateString() 'pHolder.Text
        Label10.Text = pHolder.Text & "&nbsp;PDT"



        pHolder = ListView1.Items(0).FindControl("Label53") ' and here
        Label15.Text = pHolder.Text
        pHolder = ListView1.Items(0).FindControl("Label96")
        Label118.Text = pHolder.Text
        pHolder = ListView1.Items(0).FindControl("Label59")
        Label23.Text = pHolder.Text

        pHolder = ListView1.Items(0).FindControl("Label60")
        Label25.Text = pHolder.Text

        pHolder = ListView1.Items(0).FindControl("Label61")
        Label27.Text = pHolder.Text

        Panel34.Visible = True
        pHolder = ListView1.Items(0).FindControl("Label121")
        Label120.Text = pHolder.Text

        pHolder = ListView1.Items(0).FindControl("Label62")
        Label11.Text = pHolder.Text

        If (pHolder.Text <> "Direct") Then ' = indirect
            Panel16.Visible = False
            Panel17.Visible = True

            pHolder = ListView1.Items(0).FindControl("Label54")
            Label13.Text = (CDate(pHolder.Text)).ToShortDateString() 'pHolder.Text
            'Label13.Text = pHolder.Text
        Else '=direct
            Panel17.Visible = False
            Panel16.Visible = True
            pHolder = ListView1.Items(0).FindControl("Label52") '-hhere
            Label7.Text = (CDate(pHolder.Text)).ToShortDateString() 'pHolder.Text
            'Label7.Text = pHolder.Text

        End If



        pHolder = ListView1.Items(0).FindControl("Label55")
        Label66.Text = pHolder.Text

        pHolder = ListView1.Items(0).FindControl("Label67")
        'MsgBox(pHolder.Text)
        If (pHolder.Text = "False") Then

            Panel18.Visible = False
        Else

            Panel18.Visible = True

            pHolder = ListView1.Items(0).FindControl("Label56")
            Label17.Text = Server.HtmlDecode(pHolder.Text)

            pHolder = ListView1.Items(0).FindControl("Label159")

            Label64.Text = Server.HtmlDecode(pHolder.Text)

        End If


        pHolder = ListView1.Items(0).FindControl("Label68")
        'MsgBox(pHolder.Text)
        If (pHolder.Text = "False") Then
            Panel19.Visible = False
        Else
            Panel19.Visible = True

            pHolder = ListView1.Items(0).FindControl("Label57")
            Label19.Text = Server.HtmlDecode(pHolder.Text)

        End If


        pHolder = ListView1.Items(0).FindControl("Label69")
        'MsgBox(pHolder.Text)
        If (pHolder.Text = "False") Then
            Panel20.Visible = False
        Else
            Panel20.Visible = True

            pHolder = ListView1.Items(0).FindControl("Label58")
            Label21.Text = Server.HtmlDecode(pHolder.Text)

        End If


        pHolder = ListView1.Items(0).FindControl("Label157")
        'MsgBox(pHolder.Text)
        If (pHolder.Text = "False") Then
            Panel14.Visible = False
        Else
            Panel14.Visible = True

            pHolder = ListView1.Items(0).FindControl("Label158")
            Label149.Text = Server.HtmlDecode(pHolder.Text)

        End If

        '   MsgBox(i & "-" & pHolder.Text)

        'Next
        'find the controls relating to coaching reason and check the name

        'outside panels
        Dim pHolder7 As Label
        pHolder7 = ListView1.Items(0).FindControl("Label31")
        ' MsgBox(lan)
        'MsgBox(pHolder7.Text)

        Select Case pHolder7.Text ' Module check


            Case "CSR", "Training"

                Select Case recStatus.Text ' status check

                    Case "Pending Employee Review"
                        statusLevel = 1
                    Case "Pending Supervisor Review"
                        statusLevel = 2
                    Case "Pending Manager Review"
                        statusLevel = 3
                    Case "Pending Acknowledgement"
                        statusLevel = 4
                End Select

            Case "Supervisor"

                Select Case recStatus.Text ' status check

                    Case "Pending Employee Review"
                        statusLevel = 1
                    Case "Pending Manager Review"
                        statusLevel = 2
                    Case "Pending Sr. Manager Review"
                        statusLevel = 3
                    Case "Pending Acknowledgement"
                        statusLevel = 4
                End Select



            Case "Quality"

                Select Case recStatus.Text ' status check

                    Case "Pending Employee Review"
                        statusLevel = 1
                    Case "Pending Quality Lead Review"
                        statusLevel = 2
                    Case "Pending Deputy Program Manager Review"
                        statusLevel = 3
                    Case "Pending Acknowledgement"
                        statusLevel = 4
                End Select


            Case "LSA"

                Select Case recStatus.Text ' status check

                    Case "Pending Employee Review"
                        statusLevel = 1
                    Case "Pending Supervisor Review"
                        statusLevel = 2
                End Select


        End Select
        ' MsgBox(statusLevel)
        pHolder = ListView1.Items(0).FindControl("Label45")

        If (lan = LCase(pHolder.Text)) Then ' I'm the current record's supervisor
            ' Date1.Text = DateTime.Now.ToString("d")
            CompareValidator1.ValueToCompare = TodaysDate

            Dim pHolder3
            Dim pHolder4
            Dim pHolder5
            Dim pHolder6

            pHolder3 = ListView1.Items(0).FindControl("Label126")
            pHolder4 = ListView1.Items(0).FindControl("Label106") 'txtMgrNotes
            pHolder5 = ListView1.Items(0).FindControl("Label33") 'isIQS

            '  MsgBox("supervisor")
            If ((pHolder3.Text = "True") Or (pHolder4.Text <> "")) Then

                panelHolder = ListView1.Items(0).FindControl("Panel15")
                panelHolder.Visible = True

            End If

            recStatus = DataList1.Items(0).FindControl("LabelStatus")
            pHolder6 = ListView1.Items(0).FindControl("Label90")






            Select Case statusLevel

                Case 2


                    If (pHolder5.Text = "1") Then 'IQS

                        'If ((pHolder5.Text = "IQS") And (pHolder6.Text = "True")) Then

                        panelHolder = ListView1.Items(0).FindControl("Panel28")
                        panelHolder.Visible = True

                        pHolder = ListView1.Items(0).FindControl("Label83")
                        panelHolder = ListView1.Items(0).FindControl("Panel29") 'Management Notes

                        If ((pHolder.Text <> "") And (ListView1.Items(0).FindControl("Panel15").Visible = False)) Then

                            panelHolder.Visible = True
                        End If


                        If (pHolder6.Text = "True") Then

                            Panel40.Visible = True

                        Else

                            Panel25.Visible = True

                        End If




                    Else


                        Dim pHolder2v ''
                        Dim pHolder2w

                        pHolder2v = ListView1.Items(0).FindControl("Label34") 'ETS / OAE
                        pHolder2w = ListView1.Items(0).FindControl("Label35") 'ETS / OAS

                        If ((pHolder2v.Text = "1") Or (pHolder2w.Text = "1")) Then 'Research Required?
                            '   MsgBox("found 1")
                            ''panelHolder1 = ListView1.Items(0).FindControl("Panel38") 'Details of the behavior being coached
                            ''panelHolder1.Visible = True 'display txtDescription 

                            Panel37.Visible = True ' coaching required question group
                            Label138.Text = "3. Provide the details from the coaching session including action plans developed"
                            CalendarExtender4.EndDate = TodaysDate
                            CompareValidator5.ValueToCompare = TodaysDate
                            RequiredFieldValidator10.Enabled = True
                            HyperLink1.Text = "Contact Center Operations 3.06 Timecard Audit SOP"

                            If (pHolder2v.Text = "1") Then 'ETS OAE

                                Label134.Text = "You are receiving this eCL record because an Employee on your team was identified on the CCO TC Outstanding Actions report (also known as the TC Compliance Action report).  Please research why the employee did not complete their timecard before the deadline laid out in the latest "

                            End If

                            If (pHolder2w.Text = "1") Then 'ETS OAS

                                Label134.Text = "You are receiving this eCL record because a Supervisor on your team was identified on the CCO TC Outstanding Actions report (also known as the TC Compliance Action report).  Please research why the supervisor did not approve or reject their CSR’s timecard before the deadline laid out in the latest "

                            End If


                        Else

                            '' panelHolder = ListView1.Items(0).FindControl("Panel21")
                            '' panelHolder.Visible = True
                            Panel25.Visible = True
                            calendarButtonExtender.EndDate = TodaysDate
                            RequiredFieldValidator3.Enabled = True

                        End If


                    End If



                Case 4
                    Panel40.Visible = True 'Check the box below to acknowledge the monitor

                    panelHolder = ListView1.Items(0).FindControl("Panel28")
                    panelHolder.Visible = True

                    pHolder = ListView1.Items(0).FindControl("Label83")
                    panelHolder = ListView1.Items(0).FindControl("Panel29") 'Management Notes

                    If ((pHolder.Text <> "") And (ListView1.Items(0).FindControl("Panel15").Visible = False)) Then

                        panelHolder.Visible = True
                    End If
                Case Else

                    panelHolder = ListView1.Items(0).FindControl("Panel28")
                    panelHolder.Visible = True

                    pHolder = ListView1.Items(0).FindControl("Label83")
                    panelHolder = ListView1.Items(0).FindControl("Panel29") 'Management Notes

                    If ((pHolder.Text <> "") And (ListView1.Items(0).FindControl("Panel15").Visible = False)) Then

                        panelHolder.Visible = True
                    End If

            End Select



        End If

        ' MsgBox("testing1")


        pHolder = ListView1.Items(0).FindControl("Label75")
        ''panelHolder = ListView1.Items(0).FindControl("Panel22") 'Display details of the behavior being coached and coaching notes
        ' MsgBox(pHolder.Text)
        If (lan = LCase(pHolder.Text)) Then ' I'm the current record's level 3

            'recStatus = DataList1.Items(0).FindControl("LabelStatus")
            'If ((InStr(recStatus.Text, "Pending Manager Review") > 0) Or ((InStr(recStatus.Text, "Pending Sr. Manager Review") > 0)) Or ((InStr(recStatus.Text, "Pending Deputy Program Manager Review") > 0))) Then
            If (statusLevel = 3) Then

                Dim pHolder2x As Label
                Dim pHolder2y As Label
                Dim pHolder2z As Label

                pHolder2x = ListView1.Items(0).FindControl("Label133") 'Current Coaching Initiative
                pHolder2y = ListView1.Items(0).FindControl("Label151") 'OMR / Exceptions
                pHolder2z = ListView1.Items(0).FindControl("Label36") 'Low CSAT

                '  MsgBox("manager2")
                'MsgBox(pHolder2x.Text)
                'MsgBox(pHolder2y.Text)
                'MsgBox(pHolder2z.Text)
                If ((pHolder2x.Text = "1") Or (pHolder2y.Text = "1") Or (pHolder2z.Text = "1")) Then 'Research Required?

                    '   MsgBox("found 1")
                    ''panelHolder1 = ListView1.Items(0).FindControl("Panel38") 'Details of the behavior being coached
                    ''panelHolder1.Visible = True 'display txtDescription 

                    Panel37.Visible = True ' coaching required question group

                    CalendarExtender4.EndDate = TodaysDate
                    CompareValidator5.ValueToCompare = TodaysDate
                    RequiredFieldValidator10.Enabled = True

                    If (pHolder2z.Text = "1") Then 'change text for Low CSAT

                        Label134.Text = "You are receiving this eCL because you have been assigned to listen to and provide feedback on a call that was identified as having low customer satisfaction.  Please review the call from a PPoM perspective and provide details on the specific opportunities  requiring coaching in the record below. "
                        HyperLink1.Visible = "False" ' hide hyperlink
                        Label132.Text = "" 'hide 2nd part of paragraph

                    End If

                Else


                    Panel26.Visible = True 'Customer Service Escalation (CSE) question group
                    CalendarExtender1.EndDate = TodaysDate
                    CalendarExtender2.EndDate = TodaysDate 'new


                    If (RadioButtonList1.SelectedValue = "1") Then 'CSE

                        panel24.Style("display") = "inline"
                        panel24.Style("visibility") = "visible"
                        panel27.Style("display") = "none"
                        panel27.Style("visibility") = "hidden"
                        CalendarExtender1.EndDate = TodaysDate
                        RequiredFieldValidator1.Enabled = True
                        RequiredFieldValidator6.Enabled = True
                        RequiredFieldValidator2.Enabled = False
                        RequiredFieldValidator5.Enabled = False
                        CompareValidator2.Enabled = True
                        CompareValidator3.Enabled = False

                    End If
                    If (RadioButtonList1.SelectedValue = "0") Then 'NOT CSE


                        panel27.Style("display") = "inline"
                        panel27.Style("visibility") = "visible"
                        CalendarExtender2.EndDate = TodaysDate
                        RequiredFieldValidator1.Enabled = False
                        RequiredFieldValidator6.Enabled = False
                        RequiredFieldValidator2.Enabled = True
                        RequiredFieldValidator5.Enabled = True
                        CompareValidator3.Enabled = True
                        CompareValidator2.Enabled = False

                        panel24.Style("display") = "none"
                        panel24.Style("visibility") = "hidden"

                    End If

                    ''panelHolder.Visible = True

                    'Dim pHolderX As TextBox

                    'pHolderX = ListView1.Items(0).FindControl("TextBox1")
                    pHolder = ListView1.Items(0).FindControl("Label72")

                    'MsgBox(pHolder.Text)
                    panelHolder = ListView1.Items(0).FindControl("Panel23")
                    'TextBox3.Text = "Enter Text..." 'pHolder.Text
                    '' Dim pHolder2 As Label

                    '' pHolder2 = ListView1.Items(0).FindControl("Label105")
                    'TextBox2.Text = "Enter Text..." 'pHolder2.Text

                    If (pHolder.Text <> "") Then

                        panelHolder.Visible = True



                    End If

                End If


            Else

                panelHolder = ListView1.Items(0).FindControl("Panel28")
                panelHolder.Visible = True

                pHolder = ListView1.Items(0).FindControl("Label83")
                panelHolder = ListView1.Items(0).FindControl("Panel29") 'Management Notes

                If ((pHolder.Text <> "") And (ListView1.Items(0).FindControl("Panel15").Visible = False)) Then

                    panelHolder.Visible = True
                End If


            End If




        End If


        '-End If


        Dim pHolder2
        Dim pHolder8

        pHolder2 = ListView1.Items(0).FindControl("Label33") 'iSIQS




        pHolder = ListView1.Items(0).FindControl("Label88")

        ''panelHolder = ListView1.Items(0).FindControl("Panel28")

        If (lan = LCase(pHolder.Text)) Then ' I'm the current record's csr

            ''panelHolder.Visible = True


            ' recStatus = DataList1.Items(0).FindControl("LabelStatus")

            'If (InStr(recStatus.Text, "Pending Employee Review") > 0) Then
            If (statusLevel = 1) Then


                pHolder8 = ListView1.Items(0).FindControl("Label148") 'SupReviewedAutoDate

                If ((pHolder2.Text = "1") And (Len(pHolder8.Text) > 4)) Then ' IQS

                    Panel39.Visible = True 'acknowledge monitor

                Else
                    Panel30.Visible = True 'acknowledge the coaching opportunity and comments

                End If

            End If

            If (statusLevel = 4) Then

                Panel39.Visible = True 'acknowledge monitor
            End If
        End If


        ''   pHolder = ListView1.Items(0).FindControl("Label90") ' removed for IQS
        '' If (pHolder.Text = "True") Then ' I'm the current record's csr
        '??????????????????????????????????
        ''Button4.Visible = True

        ''  End If

        'Label90
        'Button4


        If ((lan = LCase(pHolder4a.Text)) And (lan <> LCase(pHolder1a.Text)) And (lan <> LCase(pHolder2a.Text)) And (lan <> LCase(pHolder3a.Text))) Then


            'User is submitter but not CSR, SUP, or MGR

            panelHolder = ListView1.Items(0).FindControl("Panel28")
            panelHolder.Visible = True

            pHolder = ListView1.Items(0).FindControl("Label83") '' remove if shouldn't have for Outlier
            panelHolder = ListView1.Items(0).FindControl("Panel29") ''Management Notes remove if shouldn't have for Outlier

            If ((pHolder.Text <> "") And (ListView1.Items(0).FindControl("Panel15").Visible = False)) Then '' remove if shouldn't have for Outlier

                panelHolder.Visible = True '' remove if shouldn't have for Outlier


            End If '' remove if shouldn't have for Outlier
        End If


    End Sub



    Protected Sub Page_Load3(ByVal sender As Object, ByVal e As System.EventArgs) Handles ListView2.DataBound ' record not modifyable
        Dim eclUser As User = Session("eclUser")
        Dim lan As String = eclUser.LanID

        Dim pHolder1a As Label
        Dim pHolder2a As Label
        Dim pHolder3a As Label
        Dim pHolder4a As Label


        pHolder1a = ListView2.Items(0).FindControl("Label88")
        pHolder2a = ListView2.Items(0).FindControl("Label45")
        pHolder3a = ListView2.Items(0).FindControl("Label75")
        pHolder4a = ListView2.Items(0).FindControl("Label125")
        'MsgBox(Label241.Text)
        If (((lan <> LCase(pHolder4a.Text)) And (lan <> LCase(pHolder1a.Text)) And (lan <> LCase(pHolder2a.Text)) And (lan <> LCase(pHolder3a.Text))) Or ((lan = LCase(pHolder4a.Text)) And (CInt(Label241.Text) > 0))) Then

            'MsgBox("you are not of the 3")
            Response.Redirect("error3.aspx")

        End If

        'Dim i As Integer
        ' MsgBox("hello")
        'MsgBox(ListView1.Items.Count)
        ' For i = 0 To ListView1.Items.Count - 1
        'MsgBox(i & "-")
        pHolder = ListView2.Items(0).FindControl("Label50")
        Label3.Text = pHolder.Text
        pHolder = ListView2.Items(0).FindControl("Label51")
        'Label10.Text = (CDate(pHolder.Text)).ToShortDateString() 'pHolder.Text
        Label10.Text = pHolder.Text & "&nbsp;PDT"

        pHolder = ListView2.Items(0).FindControl("Label53")
        Label15.Text = pHolder.Text
        pHolder = ListView2.Items(0).FindControl("Label96")
        Label118.Text = pHolder.Text


        pHolder = ListView2.Items(0).FindControl("Label59")
        Label23.Text = pHolder.Text

        pHolder = ListView2.Items(0).FindControl("Label60")
        Label25.Text = pHolder.Text

        pHolder = ListView2.Items(0).FindControl("Label61")
        Label27.Text = pHolder.Text

        Panel34.Visible = True
        pHolder = ListView2.Items(0).FindControl("Label121")
        Label120.Text = pHolder.Text

        pHolder = ListView2.Items(0).FindControl("Label62")
        Label11.Text = pHolder.Text

        If (pHolder.Text <> "Direct") Then '=Indirect
            Panel16.Visible = False
            Panel17.Visible = True

            pHolder = ListView2.Items(0).FindControl("Label54")
            Label13.Text = (CDate(pHolder.Text)).ToShortDateString() 'pHolder.Text
            'Label13.Text = pHolder.Text


        Else '= Direct
            Panel16.Visible = True
            pHolder = ListView2.Items(0).FindControl("Label52")
            Label7.Text = (CDate(pHolder.Text)).ToShortDateString() 'pHolder.Text
            'Label7.Text = pHolder.Text
            Panel17.Visible = False

        End If



        pHolder = ListView2.Items(0).FindControl("Label55")
        Label66.Text = pHolder.Text

        pHolder = ListView2.Items(0).FindControl("Label67")
        'MsgBox(pHolder.Text)
        If (pHolder.Text = "False") Then
            Panel18.Visible = False
        Else
            Panel18.Visible = True

            pHolder = ListView2.Items(0).FindControl("Label56")
            Label17.Text = Server.HtmlDecode(pHolder.Text)

            pHolder = ListView2.Items(0).FindControl("Label159")

            Label64.Text = Server.HtmlDecode(pHolder.Text)

        End If


        pHolder = ListView2.Items(0).FindControl("Label68")
        'MsgBox(pHolder.Text)
        If (pHolder.Text = "False") Then
            Panel19.Visible = False
        Else
            Panel19.Visible = True

            pHolder = ListView2.Items(0).FindControl("Label57")
            Label19.Text = Server.HtmlDecode(pHolder.Text)

        End If


        pHolder = ListView2.Items(0).FindControl("Label69")
        'MsgBox(pHolder.Text)
        If (pHolder.Text = "False") Then
            Panel20.Visible = False
        Else
            Panel20.Visible = True

            pHolder = ListView2.Items(0).FindControl("Label58")
            Label21.Text = Server.HtmlDecode(pHolder.Text)

        End If



        pHolder = ListView2.Items(0).FindControl("Label157")
        'MsgBox(pHolder.Text)
        If (pHolder.Text = "False") Then
            Panel14.Visible = False
        Else
            Panel14.Visible = True

            pHolder = ListView2.Items(0).FindControl("Label158")
            Label149.Text = Server.HtmlDecode(pHolder.Text)

        End If


        '   MsgBox(i & "-" & pHolder.Text)

        'Next

        'outside panels



        '' panelHolder = ListView2.Items(0).FindControl("Panel33") 'Details of the behavior being coached
        '' panelHolder.Visible = True

        pHolder = ListView2.Items(0).FindControl("Label107")
        ' MsgBox(pHolder.Text)
        If (pHolder.Text = "1") Then
            'MsgBox("found 1 again")

            pHolder = ListView2.Items(0).FindControl("Label89") 'isCSE

            If (pHolder.Text = "True") Then

                pHolder = ListView2.Items(0).FindControl("Label43")
                pHolder.Visible = True


            Else

                panelHolder = ListView2.Items(0).FindControl("Panel35") 'not CSE
                panelHolder.Visible = True

                panelHolder = ListView2.Items(0).FindControl("Panel36") 'Management Notes
                pHolder = ListView2.Items(0).FindControl("Label103")


                If (pHolder.Text <> "") Then

                    panelHolder.Visible = True


                End If
            End If

        End If


        pHolder = ListView2.Items(0).FindControl("Label101")

        If (Len(pHolder.Text) > 0) Then

            pHolder.Text = pHolder.Text & "&nbsp;PDT"

        End If





        panelHolder = ListView2.Items(0).FindControl("Panel23") 'Coaching Notes
        panelHolder.Visible = True


        Dim pHolder6
        Dim pHolder7
        pHolder6 = ListView2.Items(0).FindControl("Label33") 'isIQS
        pHolder7 = ListView2.Items(0).FindControl("Label50")

        If ((pHolder6.Text = "1") And (pHolder7.Text = "Completed")) Then ' IQS

            pHolder = ListView2.Items(0).FindControl("Label100")
            pHolder.Text = "Reviewed and acknowledged Quality Monitor on"

            panelHolder = ListView2.Items(0).FindControl("Panel41") 'Supervisor Review Information & Quality Monitor acknowledgement date
            panelHolder.Visible = True

            Dim pHolder8

            pHolder8 = ListView2.Items(0).FindControl("Label155")

            If (Len(pHolder8.Text) > 0) Then

                pHolder8.Text = pHolder8.Text & "&nbsp;PDT"

            End If

        Else
            '   pHolder = ListView2.Items(0).FindControl("Label80")
            ' pHolder.Visible = True

            pHolder = ListView2.Items(0).FindControl("Label100")
            pHolder.Text = "Reviewed and acknowledged coaching opportunity on"

            panelHolder = ListView2.Items(0).FindControl("Panel32") 'CSR Comments/Feedback
            panelHolder.Visible = True


        End If



    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            HandlePageNonPostBack()
        End If
    End Sub

    ' called on page non post back but after authentication is successful
    Public Sub HandlePageNonPostBack()
        Dim eclUser As User = Session("eclUser")
        Dim lan As String = eclUser.LanID

        ' sp_Check_AgentRole
        SqlDataSource14.SelectParameters("nvcLanID").DefaultValue = lan
        SqlDataSource14.SelectParameters("nvcRole").DefaultValue = "ARC"
        GridView1.DataBind()

        Dim formID
        Dim idArray

        formID = Request.QueryString("id")
        If (RadioButtonList1.SelectedValue = "1") Then
            panel24.Style("display") = "inline"
            panel24.Style("visibility") = "visible"
            panel27.Style("display") = "none"
            panel27.Style("visibility") = "hidden"
        End If
        If (RadioButtonList1.SelectedValue = "0") Then
            panel27.Style("display") = "inline"
            panel27.Style("visibility") = "visible"
            panel24.Style("display") = "none"
            panel24.Style("visibility") = "hidden"
        End If

        If (Len(formID) > 9) Then
            'eCL-Lanisa.Rodriguez-Tov-409432
            idArray = Split(formID, "-", -1, 1)
            'error
            'MsgBox(idArray(0) = "eCL")
            'MsgBox(UBound(idArray))
            'If ((idArray(0) = "eCL") And (Len(idArray(1)) = 4) Or (CInt(idArray(2)) > -1)) Then
            If ((LCase(idArray(0)) = "ecl") And (CInt(UBound(idArray)) > -1)) Then

                'If (LCase((idArray(0) = "eCL")) And (CInt(UBound(idArray)) > -1)) Then
                recStatus = DataList1.Items(0).FindControl("LabelStatus")

                If (recStatus.Text = "Completed") Then

                    ListView2.Visible = True
                    Panel31.Visible = True
                    Label6.Text = "Final"

                End If

                If (InStr(recStatus.Text, "Pending") > 0) Then

                    ListView1.Visible = True
                    Panel31.Visible = True
                    Label6.Text = "Review"

                End If

                CompareValidator2.ValueToCompare = TodaysDate
                CompareValidator3.ValueToCompare = TodaysDate
            Else
                Panel31.Visible = False
                DataList1.Visible = False
                DataList1.Enabled = False

                Panel4a.Visible = False ''True
                Label28.Visible = False
                Label29.Visible = False
            End If
        Else
            Panel31.Visible = False
            DataList1.Visible = False
            DataList1.Enabled = False
            Panel4a.Visible = False ''True
            Label28.Visible = False
            Label29.Visible = False
        End If
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button1.Click
        Dim eclUser As User = Session("eclUser")
        Dim lan As String = eclUser.LanID

        'Supervisor submit
        Page.Validate()
        If Page.IsValid Then

            '   MsgBox(Request.QueryString("id"))
            SqlDataSource1.UpdateParameters("nvcFormID").DefaultValue = Request.QueryString("id")
            SqlDataSource1.UpdateParameters("nvcReviewSupLanID").DefaultValue = lan
            SqlDataSource1.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Employee Review"
            SqlDataSource1.UpdateParameters("dtmSupReviewedAutoDate").DefaultValue = CDate(DateTime.Now())

            If (Len(TextBox5.Text) > 3000) Then

                TextBox5.Text = Left(TextBox5.Text, 3000)

            End If

            TextBox5.Text = Server.HtmlEncode(TextBox5.Text)
            TextBox5.Text = Replace(TextBox5.Text, "’", "&rsquo;")
            TextBox5.Text = Replace(TextBox5.Text, "‘", "&lsquo;")
            TextBox5.Text = Replace(TextBox5.Text, "'", "&prime;")
            TextBox5.Text = Replace(TextBox5.Text, Chr(147), "&ldquo;")
            TextBox5.Text = Replace(TextBox5.Text, Chr(148), "&rdquo;")
            TextBox5.Text = Replace(TextBox5.Text, "-", "&ndash;")


            SqlDataSource1.UpdateParameters("nvctxtCoachingNotes").DefaultValue = TextBox5.Text
            SqlDataSource1.UpdateParameters("dtmCoachingDate").DefaultValue = CDate(Date1.Text)


            SqlDataSource1.Update()

            FromURL = Request.ServerVariables("URL")
            Response.Redirect("next1.aspx?FromURL=" & FromURL)


            ' Response.Redirect("next1.aspx")  ' Response.Redirect("view2.aspx")
        Else

            Label116.Text = "Please correct all fields indicated in red to proceed."

        End If


    End Sub

    Protected Sub Button2_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button2.Click
        Dim eclUser As User = Session("eclUser")
        Dim lan As String = eclUser.LanID

        'Manager submit 1
        '' add dtmMgrReviewAutoDate to update parameters = CDate(DateTime.Now())
        'MsgBox("goodbye")

        If (RadioButtonList1.SelectedValue = "1") Then 'Panel26
            RequiredFieldValidator6.Enabled = True
            RequiredFieldValidator1.Enabled = True

            CompareValidator2.Enabled = True


            RequiredFieldValidator5.Enabled = False
            RequiredFieldValidator2.Enabled = False
            CompareValidator3.Enabled = False


            panel24.Style("display") = "inline"
            panel24.Style("visibility") = "visible"
            panel27.Style("display") = "none"
            panel27.Style("visibility") = "hidden"

        Else 'Panel26
            RequiredFieldValidator5.Enabled = True
            RequiredFieldValidator2.Enabled = True


            CompareValidator3.Enabled = True


            RequiredFieldValidator6.Enabled = False
            RequiredFieldValidator1.Enabled = False
            CompareValidator2.Enabled = False



            panel27.Style("display") = "inline"
            panel27.Style("visibility") = "visible"
            panel24.Style("display") = "none"
            panel24.Style("visibility") = "hidden"
        End If




        Page.Validate()

        If Page.IsValid Then


            SqlDataSource3.UpdateParameters("nvcFormID").DefaultValue = Request.QueryString("id")
            SqlDataSource3.UpdateParameters("nvcReviewMgrLanID").DefaultValue = lan
            SqlDataSource3.UpdateParameters("bitisCSE").DefaultValue = CBool(RadioButtonList1.SelectedValue)

            Dim pHolder7 As Label
            pHolder7 = ListView1.Items(0).FindControl("Label31")

            Select Case pHolder7.Text ' Module check


                Case "CSR", "Training"
                    SqlDataSource3.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Supervisor Review"

                Case "Supervisor"
                    SqlDataSource3.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Manager Review"

                Case "Quality"
                    SqlDataSource3.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Quality Lead Review"


            End Select



            ''SqlDataSource3.UpdateParameters("dtmMgrReviewedAutoDate").DefaultValue = CDate(DateTime.Now())
            SqlDataSource3.UpdateParameters("dtmSupReviewedAutoDate").DefaultValue = CDate(DateTime.Now())



            'MsgBox("hello")
            'supervisor /QS comments originally combined for notes
            pHolder2 = ListView1.Items(0).FindControl("Label105")
            TextBox2.Text = "1. " & Label25.Text & " (Sup/QS " & Label10.Text & ")" & Server.HtmlDecode(pHolder2.Text) & "-----------------2. " & Label27.Text & " (MGMT " & TodaysDate & ") " & TextBox2.Text
            '"\r\n", "<br />"
            If (Len(TextBox2.Text) > 3000) Then

                TextBox2.Text = Left(TextBox2.Text, 3000)

            End If
            'MsgBox(TextBox2.Text)
            'add manager name and date for CSE manager notes
            TextBox2.Text = Label27.Text & " (MGMT " & TodaysDate & ") " & Server.HtmlEncode(TextBox2.Text)
            TextBox2.Text = Replace(TextBox2.Text, "’", "&rsquo;")
            TextBox2.Text = Replace(TextBox2.Text, "‘", "&lsquo;")
            TextBox2.Text = Replace(TextBox2.Text, "'", "&prime;")
            TextBox2.Text = Replace(TextBox2.Text, Chr(147), "&ldquo;")
            TextBox2.Text = Replace(TextBox2.Text, Chr(148), "&rdquo;")
            TextBox2.Text = Replace(TextBox2.Text, "-", "&ndash;")

            ''SqlDataSource3.UpdateParameters("nvctxtMgrNotes").DefaultValue = TextBox2.Text
            SqlDataSource3.UpdateParameters("nvctxtCoachingNotes").DefaultValue = TextBox2.Text
            SqlDataSource3.UpdateParameters("dtmCoachingDate").DefaultValue = CDate(Date2.Text)



            SqlDataSource3.Update()

            FromURL = Request.ServerVariables("URL")
            Response.Redirect("next1.aspx?FromURL=" & FromURL)


        End If




    End Sub

    Protected Sub Button3_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button3.Click
        Dim eclUser As User = Session("eclUser")
        Dim lan As String = eclUser.LanID

        'Manager submit 2


        If (RadioButtonList1.SelectedValue = "1") Then 'Panel26
            RequiredFieldValidator6.Enabled = True
            RequiredFieldValidator1.Enabled = True

            CompareValidator2.Enabled = True


            RequiredFieldValidator5.Enabled = False
            RequiredFieldValidator2.Enabled = False
            CompareValidator3.Enabled = False

        Else 'Panel26
            RequiredFieldValidator5.Enabled = True
            RequiredFieldValidator2.Enabled = True


            CompareValidator3.Enabled = True


            RequiredFieldValidator6.Enabled = False
            RequiredFieldValidator1.Enabled = False
            CompareValidator2.Enabled = False
        End If



        Page.Validate()
        If Page.IsValid Then


            SqlDataSource4.UpdateParameters("nvcFormID").DefaultValue = Request.QueryString("id")
            SqlDataSource4.UpdateParameters("nvcReviewMgrLanID").DefaultValue = lan
            SqlDataSource4.UpdateParameters("bitisCSE").DefaultValue = CBool(RadioButtonList1.SelectedValue)
            SqlDataSource4.UpdateParameters("dtmMgrReviewManualDate").DefaultValue = CDate(Date3.Text)
            SqlDataSource4.UpdateParameters("dtmMgrReviewAutoDate").DefaultValue = CDate(DateTime.Now()) 'already existing for outlier, update EC.sp_Update3Review_Coaching_Log



            Dim pHolder7 As Label
            pHolder7 = ListView1.Items(0).FindControl("Label31")

            Select Case pHolder7.Text ' Module check


                Case "CSR", "LSA", "Training"
                    SqlDataSource4.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Supervisor Review"

                Case "Supervisor"
                    SqlDataSource4.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Manager Review"

                Case "Quality"
                    SqlDataSource4.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Quality Lead Review"


            End Select

            ' SqlDataSource4.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Supervisor Review"
            '' SqlDataSource4.UpdateParameters("bitisCoachingRequired").DefaultValue = CBool(RadioButtonList3.SelectedValue) 'new for outlier, update EC.sp_Update2Review_Coaching_Log

            If (Len(TextBox3.Text) > 3000) Then

                TextBox3.Text = Left(TextBox3.Text, 3000)

            End If

            TextBox3.Text = Server.HtmlEncode(TextBox3.Text)
            TextBox3.Text = Replace(TextBox3.Text, "’", "&rsquo;")
            TextBox3.Text = Replace(TextBox3.Text, "‘", "&lsquo;")
            TextBox3.Text = Replace(TextBox3.Text, "'", "&prime;")
            TextBox3.Text = Replace(TextBox3.Text, Chr(147), "&ldquo;")
            TextBox3.Text = Replace(TextBox3.Text, Chr(148), "&rdquo;")
            TextBox3.Text = Replace(TextBox3.Text, "-", "&ndash;")

            SqlDataSource4.UpdateParameters("nvcMgrNotes").DefaultValue = TextBox3.Text


            SqlDataSource4.Update()

            FromURL = Request.ServerVariables("URL")
            Response.Redirect("next1.aspx?FromURL=" & FromURL)


            ' Response.Redirect("next1.aspx")  ' Response.Redirect("view2.aspx")
        Else

            Label116.Text = "Please correct all fields indicated in red to proceed."

        End If

    End Sub

    Protected Sub Button5_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button5.Click
        Dim eclUser As User = Session("eclUser")
        Dim lan As String = eclUser.LanID

        'Manager or Supervisor submit 3 - Outlier [OMR, OAE, OAM]

        RequiredFieldValidator10.Enabled = True

        If (RadioButtonList3.SelectedValue = "0") Then 'panel37
            RequiredFieldValidator9.Enabled = False
            RequiredFieldValidator4.Enabled = True

            panel0a.Style("display") = "inline"
            panel0a.Style("visibility") = "visible"
            panel0b.Style("display") = "none"
            panel0b.Style("visibility") = "hidden"
            '  MsgBox("AddlNotes")

        End If

        If (RadioButtonList3.SelectedValue = "1") Then 'panel37

            'panel37
            RequiredFieldValidator4.Enabled = False
            RequiredFieldValidator9.Enabled = True
            panel0b.Style("display") = "inline"
            panel0b.Style("visibility") = "visible"
            panel0a.Style("display") = "none"
            panel0a.Style("visibility") = "hidden"

            'MsgBox("TextBox1")
        End If




        Page.Validate()
        If Page.IsValid Then


            SqlDataSource7.UpdateParameters("nvcFormID").DefaultValue = Request.QueryString("id")
            SqlDataSource7.UpdateParameters("nvcReviewerLanID").DefaultValue = lan
            SqlDataSource7.UpdateParameters("dtmReviewAutoDate").DefaultValue = CDate(DateTime.Now()) 'already existing for outlier, update EC.sp_Update3Review_Coaching_Log
            SqlDataSource7.UpdateParameters("bitisCoachingRequired").DefaultValue = CBool(RadioButtonList3.SelectedValue)
            SqlDataSource7.UpdateParameters("dtmReviewManualDate").DefaultValue = CDate(Date4.Text)

            If RadioButtonList3.SelectedValue = "1" Then '[isCoachingRequired] = True/Yes/1

                ''    SqlDataSource7.UpdateParameters("nvcstrCoachReason_Current_Coaching_Initiatives").DefaultValue = "Opportunity"


                Dim pHolder7 As Label
                pHolder7 = ListView1.Items(0).FindControl("Label31")

                Dim pHolder1 As Label = ListView1.Items(0).FindControl("Label133") 'Current Coaching Initiative
                Dim pHolder2 As Label = ListView1.Items(0).FindControl("Label151") 'OMR / Exceptions
                Dim pHolder3 As Label = ListView1.Items(0).FindControl("Label34") 'ETS / OAE
                Dim pHolder4 As Label = ListView1.Items(0).FindControl("Label35") 'ETS / OAS
                Dim pHolder5 As Label = ListView1.Items(0).FindControl("Label36") 'Low CSAT


                Select Case pHolder7.Text ' Module check

                    Case "CSR", "Training"

                        If ((pHolder1.Text = "1") Or (pHolder2.Text = "1") Or (pHolder5.Text = "1")) Then

                            SqlDataSource7.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Supervisor Review"

                        End If


                        If (pHolder3.Text = "1") Then

                            SqlDataSource7.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Employee Review"

                        End If


                    Case "Supervisor"

                        If ((pHolder1.Text = "1") Or (pHolder2.Text = "1")) Then

                            SqlDataSource7.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Manager Review"


                        Else

                            SqlDataSource7.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Employee Review"

                        End If




                    Case "Quality"


                        If ((pHolder1.Text = "1") Or (pHolder2.Text = "1")) Then

                            SqlDataSource7.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Quality Lead Review"


                        Else

                            SqlDataSource7.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Employee Review"

                        End If




                End Select



                ' SqlDataSource7.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Supervisor Review"

                SqlDataSource7.UpdateParameters("nvcstrReasonNotCoachable").DefaultValue = ""

                'crop text if it is larger than 3000 chars
                If (Len(AddlNotes.Text) > 3000) Then

                    AddlNotes.Text = Left(AddlNotes.Text, 3000)

                End If

                'encode strings that are not valid and not caught by htmlencode
                AddlNotes.Text = Server.HtmlEncode(AddlNotes.Text)
                AddlNotes.Text = Replace(AddlNotes.Text, "’", "&rsquo;")
                AddlNotes.Text = Replace(AddlNotes.Text, "‘", "&lsquo;")
                AddlNotes.Text = Replace(AddlNotes.Text, "'", "&prime;")
                AddlNotes.Text = Replace(AddlNotes.Text, Chr(147), "&ldquo;")
                AddlNotes.Text = Replace(AddlNotes.Text, Chr(148), "&rdquo;")
                AddlNotes.Text = Replace(AddlNotes.Text, "-", "&ndash;")



                SqlDataSource7.UpdateParameters("nvctxtReasonNotCoachable").DefaultValue = ""
                SqlDataSource7.UpdateParameters("nvcReviewerNotes").DefaultValue = AddlNotes.Text
                SqlDataSource7.UpdateParameters("nvcstrReasonNotCoachable").DefaultValue = ""

            Else '[isCoachingRequired] = False/No/0

                ''     SqlDataSource7.UpdateParameters("nvcstrCoachReason_Current_Coaching_Initiatives").DefaultValue = "Not Coachable"
                SqlDataSource7.UpdateParameters("nvcFormStatus").DefaultValue = "Inactive"
                SqlDataSource7.UpdateParameters("nvcstrReasonNotCoachable").DefaultValue = "Other"

                'crop text if it is larger than 3000 chars
                If (Len(TextBox1.Text) > 3000) Then

                    TextBox1.Text = Left(TextBox1.Text, 3000)

                End If

                'encode strings that are not valid and not caught by htmlencode
                TextBox1.Text = Server.HtmlEncode(TextBox1.Text)
                TextBox1.Text = Replace(TextBox1.Text, "’", "&rsquo;")
                TextBox1.Text = Replace(TextBox1.Text, "‘", "&lsquo;")
                TextBox1.Text = Replace(TextBox1.Text, "'", "&prime;")
                TextBox1.Text = Replace(TextBox1.Text, Chr(147), "&ldquo;")
                TextBox1.Text = Replace(TextBox1.Text, Chr(148), "&rdquo;")
                TextBox1.Text = Replace(TextBox1.Text, "-", "&ndash;")

                SqlDataSource7.UpdateParameters("nvcReviewerNotes").DefaultValue = ""
                SqlDataSource7.UpdateParameters("nvctxtReasonNotCoachable").DefaultValue = TextBox1.Text
            End If


            SqlDataSource7.Update()

            FromURL = Request.ServerVariables("URL")
            Response.Redirect("next1.aspx?FromURL=" & FromURL)


            ' Response.Redirect("next1.aspx")  ' Response.Redirect("view2.aspx")
        Else

            Label116.Text = "Please correct all fields indicated in red to proceed."

        End If

    End Sub


    Protected Sub Button4_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button4.Click
        'CSR Submit
        Page.Validate()

        If Page.IsValid Then

            ''add dtmSupReviewedAutoDate = current date to update fields
            SqlDataSource5.UpdateParameters("nvcFormID").DefaultValue = Request.QueryString("id")
            SqlDataSource5.UpdateParameters("nvcFormStatus").DefaultValue = "Completed"
            SqlDataSource5.UpdateParameters("dtmCSRReviewAutoDate").DefaultValue = CDate(DateTime.Now())

            If (Len(TextBox4.Text) > 3000) Then

                TextBox4.Text = Left(TextBox4.Text, 3000)

            End If

            TextBox4.Text = Server.HtmlEncode(TextBox4.Text)
            TextBox4.Text = Replace(TextBox4.Text, "’", "&rsquo;")
            TextBox4.Text = Replace(TextBox4.Text, "‘", "&lsquo;")
            TextBox4.Text = Replace(TextBox4.Text, "'", "&prime;")
            TextBox4.Text = Replace(TextBox4.Text, Chr(147), "&ldquo;")
            TextBox4.Text = Replace(TextBox4.Text, Chr(148), "&rdquo;")
            TextBox4.Text = Replace(TextBox4.Text, "-", "&ndash;")


            SqlDataSource5.UpdateParameters("nvcCSRComments").DefaultValue = TextBox4.Text
            SqlDataSource5.UpdateParameters("bitisCSRAcknowledged").DefaultValue = CheckBox2.Checked


            SqlDataSource5.Update()

            FromURL = Request.ServerVariables("URL")
            Response.Redirect("next1.aspx?FromURL=" & FromURL)

            'Response.Redirect("next1.aspx")  ' Response.Redirect("view2.aspx")

        Else

            Label116.Text = "Please correct all fields indicated in red to proceed."


        End If


    End Sub

    Protected Sub Button6_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button6.Click
        'CSR Pending Ack Submit

        Dim nextStep As String = ""

        Page.Validate()
        recStatus = DataList1.Items(0).FindControl("LabelStatus")
        If (recStatus.Text = "Pending Acknowledgement") Then


            Dim pHolder7 As Label
            pHolder7 = ListView1.Items(0).FindControl("Label31")

            Select Case pHolder7.Text ' Module check


                Case "CSR", "Training"
                    nextStep = "Pending Supervisor Review"

                Case "Supervisor"
                    nextStep = "Pending Manager Review"

                Case "Quality"
                    nextStep = "Pending Quality Lead Review"


            End Select


            ' nextStep = "Pending Supervisor Review"

        Else
            nextStep = "Completed"

        End If

        If Page.IsValid Then

            ''add dtmSupReviewedAutoDate = current date to update fields
            SqlDataSource9.UpdateParameters("nvcFormID").DefaultValue = Request.QueryString("id")
            SqlDataSource9.UpdateParameters("nvcFormStatus").DefaultValue = nextStep
            SqlDataSource9.UpdateParameters("dtmCSRReviewAutoDate").DefaultValue = CDate(DateTime.Now())
            SqlDataSource9.UpdateParameters("bitisCSRAcknowledged").DefaultValue = CheckBox1.Checked


            SqlDataSource9.Update()

            FromURL = Request.ServerVariables("URL")
            Response.Redirect("next1.aspx?FromURL=" & FromURL)

            'Response.Redirect("next1.aspx")  ' Response.Redirect("view2.aspx")

        Else

            Label116.Text = "Please correct all fields indicated in red to proceed."


        End If


    End Sub


    Protected Sub Button7_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button7.Click
        Dim eclUser As User = Session("eclUser")
        Dim lan As String = eclUser.LanID

        'SUP Pending Ack Submit
        Dim nextStep

        Page.Validate()
        recStatus = DataList1.Items(0).FindControl("LabelStatus")
        If (recStatus.Text = "Pending Acknowledgement") Then

            nextStep = "Pending Employee Review"

        Else
            nextStep = "Completed"

        End If

        If Page.IsValid Then

            ''add dtmSupReviewedAutoDate = current date to update fields
            SqlDataSource10.UpdateParameters("nvcFormID").DefaultValue = Request.QueryString("id")
            SqlDataSource10.UpdateParameters("nvcReviewSupLanID").DefaultValue = lan
            SqlDataSource10.UpdateParameters("nvcFormStatus").DefaultValue = nextStep
            SqlDataSource10.UpdateParameters("dtmSUPReviewAutoDate").DefaultValue = CDate(DateTime.Now())

            SqlDataSource10.Update()

            FromURL = Request.ServerVariables("URL")
            Response.Redirect("next1.aspx?FromURL=" & FromURL)

            'Response.Redirect("next1.aspx")  ' Response.Redirect("view2.aspx")

        Else

            Label116.Text = "Please correct all fields indicated in red to proceed."


        End If


    End Sub







    Protected Sub CheckBoxRequired1_ServerValidate(ByVal Source As Object, ByVal args As ServerValidateEventArgs)

        args.IsValid = CheckBox1.Checked


    End Sub

    Protected Sub CheckBoxRequired2_ServerValidate(ByVal Source As Object, ByVal args As ServerValidateEventArgs)

        args.IsValid = CheckBox2.Checked


    End Sub

    Protected Sub CheckBoxRequired3_ServerValidate(ByVal Source As Object, ByVal args As ServerValidateEventArgs)

        args.IsValid = CheckBox3.Checked

    End Sub



    Protected Sub ARC_Selected(ByVal sender As Object, ByVal e As SqlDataSourceStatusEventArgs) Handles SqlDataSource14.Selected
        'EC.sp_Check_AgentRole 
        'MsgBox("param=" & e.Command.Parameters("nvcLanID").Value)

        Label241.Text = e.Command.Parameters("@Indirect@return_value").Value
        ' MsgBox("2- " & Label241.Text)
        'Dim spot3
        'For Each param In e.Command.Parameters

        ' Extract the name and value of the parameter.
        'spot3 = param.ParameterName & " - " & param.Value.ToString()
        'MsgBox(spot3)
        'Next

        'MsgBox("1-" & Label241.Text)
    End Sub


    Protected Sub OnRowDataBound2(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView2.DataBound
        'MsgBox("test=" & (GridView2.Rows.Count - 1))
        '  MsgBox("testing2")
        ' MsgBox(GridView2.Rows.Count)

        ' For k As Integer = 0 To GridView2.Rows.Count - 1
        '    MsgBox(GridView2.Rows(k).Cells.Count)
        'For l As Integer = 0 To GridView2.Rows(k).Cells.Count - 1

        'MsgBox("Value=" & GridView2.Rows(k).Cells(l).Text)
        'Next

        'Next


        For i As Integer = (GridView2.Rows.Count - 1) To 1 Step -1

            Dim row As GridViewRow = GridView2.Rows(i)
            Dim previousRow As GridViewRow = GridView2.Rows(i - 1)
            'MsgBox(i)
            For j As Integer = 0 To row.Cells.Count - 1
                ' MsgBox("rowtext=" & row.Cells(j).Text)
                ' MsgBox("previous=" & previousRow.Cells(j).Text)
                'MsgBox(j)
                'MsgBox(row.Cells(j).Text)
                'MsgBox(previousRow.Cells(j).Text)
                If (row.Cells(j).Text = previousRow.Cells(j).Text) Then
                    If (previousRow.Cells(j).RowSpan = 0) Then
                        If (row.Cells(j).RowSpan = 0) Then
                            previousRow.Cells(j).RowSpan += 2
                        Else
                            previousRow.Cells(j).RowSpan = row.Cells(j).RowSpan + 1
                        End If
                        row.Cells(j).Visible = False
                    End If
                End If
            Next

        Next

    End Sub


     Protected Sub SqlDataSource2_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource2.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource6_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource6.Selecting
        'EC.sp_SelectRecordStatus 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource8_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource8.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource14_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource14.Selecting
        'EC.sp_Check_AgentRole 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub






    Protected Sub SqlDataSource1_Updating(ByVal sender As Object, e As SqlDataSourceCommandEventArgs) Handles SqlDataSource1.Updating
        'EC.sp_Update1Review_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource3_Updating(ByVal sender As Object, e As SqlDataSourceCommandEventArgs) Handles SqlDataSource3.Updating
        'EC.sp_Update2Review_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource4_Updating(ByVal sender As Object, e As SqlDataSourceCommandEventArgs) Handles SqlDataSource4.Updating
        'EC.sp_Update3Review_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource5_Updating(ByVal sender As Object, e As SqlDataSourceCommandEventArgs) Handles SqlDataSource5.Updating
        'EC.sp_Update4Review_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource7_Updating(ByVal sender As Object, e As SqlDataSourceCommandEventArgs) Handles SqlDataSource7.Updating


        'EC.sp_Update5Review_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource9_Updating(ByVal sender As Object, e As SqlDataSourceCommandEventArgs) Handles SqlDataSource9.Updating
        'EC.sp_Update6Review_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource10_Updating(ByVal sender As Object, e As SqlDataSourceCommandEventArgs) Handles SqlDataSource10.Updating
        'EC.sp_Update7Review_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



End Class