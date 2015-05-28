Imports System.Data.SqlClient
Imports System.Net.Mail
Imports System.DirectoryServices
Imports System
Imports System.Configuration
Imports System.Web.UI.WebControls
Imports AjaxControlToolkit



Public Class review2
    Inherits BasePage

    Dim pHolder As Label
    Dim panelHolder As Panel
    Dim recStatus As Label
    Dim userName As String
    Dim userTitle As String
    Dim csupervisor As String
    Dim cmanager As String
    Dim csr As String
    Dim csrLabel As Label

    Dim dssearch As System.DirectoryServices.DirectorySearcher
    Dim sresult As System.DirectoryServices.SearchResult
    Dim dresult As System.DirectoryServices.DirectoryEntry

    ' Dim historyAccess = "harkda;carvmi;lindlo;dougei;colwmi;schrst;walll1;FitzDr;martb1;zeitsh;fjorbj;pattb1;arguma;sigama;daviev;ThyeCh;HessJo;sampjo;beauda;dyexbr;riddju;kinckr;fostm1;reynsc;curtja;cortco;augujo;mainsc;warrsc"

    Protected Sub Page_Load3(ByVal sender As Object, ByVal e As System.EventArgs) Handles ListView2.DataBound



        csrLabel = ListView2.Items(0).FindControl("Label88")
        csr = csrLabel.Text


        SqlDataSource3.SelectParameters("strUserin").DefaultValue = csr

        SqlDataSource3.DataBind()
        GridView2.DataBind()




        Dim subString As String


        Try

            subString = (CType(GridView2.Rows(0).FindControl("Flow"), Label).Text)
        Catch ex As Exception
            subString = ""
            ' MsgBox("hello")
            '   Response.Redirect("error.aspx")
        End Try


        If (Len(subString) > 0) Then

            Dim subArray As Array

            subArray = Split(subString, "$", -1, 1)
            csupervisor = subArray(0)
            cmanager = subArray(1)
        Else
            csupervisor = "Unavailable"
            cmanager = "Unavailable"

        End If




        '************************************
        'check the user's SUP and MGR and assign to values
        ' csupervisor
        'cmanager

        '********************



        Dim pHolder1a As Label
        Dim pHolder2a As Label
        Dim pHolder3a As Label
        Dim pHolder4a As Label


        pHolder1a = ListView2.Items(0).FindControl("Label49")
        pHolder2a = ListView2.Items(0).FindControl("Label48")
        pHolder3a = ListView2.Items(0).FindControl("Label47")
        pHolder4a = ListView2.Items(0).FindControl("Label1")


   

        If ((lan <> (Replace(pHolder4a.Text, "'", ""))) And (lan <> (Replace(pHolder1a.Text, "'", ""))) And (lan <> (Replace(pHolder2a.Text, "'", ""))) And (lan <> (Replace(pHolder3a.Text, "'", ""))) And (lan <> LCase(csupervisor)) And (lan <> LCase(cmanager)) And (Label241.Text = 0) And (Label31.Text = 0) And (InStr(1, userTitle, "WHHR", 1) = 0) And (InStr(1, userTitle, "WHER", 1) = 0)) Then
            '  MsgBox(lan)
            '  MsgBox(cmanager)
            '  MsgBox(pHolder3a.Text)
            '  MsgBox("you are not of the 3")
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



        panelHolder = ListView2.Items(0).FindControl("Panel33")
        panelHolder.Visible = True

        pHolder = ListView2.Items(0).FindControl("Label107")

        If (pHolder.Text = "1") Then


            pHolder = ListView2.Items(0).FindControl("Label89")

            If (pHolder.Text = "True") Then

                pHolder = ListView2.Items(0).FindControl("Label43")
                pHolder.Visible = True


            Else

                panelHolder = ListView2.Items(0).FindControl("Panel35")
                panelHolder.Visible = True

            End If

        End If

        panelHolder = ListView2.Items(0).FindControl("Panel36")
        pHolder = ListView2.Items(0).FindControl("Label103")


        If (pHolder.Text <> "") Then

            panelHolder.Visible = True


        End If

        panelHolder = ListView2.Items(0).FindControl("Panel23")
        panelHolder.Visible = True



        pHolder = ListView2.Items(0).FindControl("Label101")

        If (Len(pHolder.Text) > 0) Then

            pHolder.Text = pHolder.Text & "&nbsp;PDT"

        End If



        Dim pHolder6
        Dim pHolder7
        pHolder6 = ListView2.Items(0).FindControl("Label33") 'isIQS
        pHolder7 = ListView2.Items(0).FindControl("Label50")

        If (pHolder6.Text = "1") Then

            pHolder = ListView2.Items(0).FindControl("Label100")
            pHolder.Text = "Reviewed and acknowledged Quality Monitor on"

            panelHolder = ListView2.Items(0).FindControl("Panel41")
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

            panelHolder = ListView2.Items(0).FindControl("Panel32")
            panelHolder.Visible = True


        End If


        'pHolder = ListView2.Items(0).FindControl("Label80")
        'pHolder.Visible = True

        'pHolder = ListView2.Items(0).FindControl("Label100")
        ' pHolder.Visible = True

        '  panelHolder = ListView2.Items(0).FindControl("Panel32")
        '   panelHolder.Visible = True



    End Sub


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' authentication is done in BasePage
        ' if it makes it here, it means authentication is successful
        ' still need to initialize the page on initial display
        If Not IsPostBack Then
            InitializePageDisplay()
        End If
    End Sub

    Private Sub InitializePageDisplay()
        userTitle = GetJobCode(Session("userInfo"))

        ' sp_Check_AgentRole - ARC
        SqlDataSource14.SelectParameters("nvcLanID").DefaultValue = lan
        SqlDataSource14.SelectParameters("nvcRole").DefaultValue = "ECL"
        GridView1.DataBind()

        ' sp_Check_AgentRole - SRMGR
        SqlDataSource4.SelectParameters("nvcLanID").DefaultValue = lan
        SqlDataSource4.SelectParameters("nvcRole").DefaultValue = "SRMGR"
        GridView5.DataBind()

        Select Case True
            Case (InStr(1, userTitle, "40", 1) > 0), (InStr(1, userTitle, "50", 1) > 0), (InStr(1, userTitle, "60", 1) > 0), (InStr(1, userTitle, "70", 1) > 0), (InStr(1, userTitle, "WISO", 1) > 0), (InStr(1, userTitle, "WSTE", 1) > 0), (InStr(1, userTitle, "WSQE", 1) > 0), (InStr(1, userTitle, "WACQ", 1) > 0), (InStr(1, userTitle, "WPPM", 1) > 0), (InStr(1, userTitle, "WPSM", 1) > 0), (InStr(1, userTitle, "WEEX", 1) > 0), (InStr(1, userTitle, "WPWL51", 1) > 0), (InStr(1, userTitle, "WHER", 1) > 0), (InStr(1, userTitle, "WHHR", 1) > 0)
                '"WPWL51","WACS40", "WMPR40", "WPPT40", "WSQA40", "WTTR40", "WTTR50", "WPSM11", "WPSM12", "WPSM13", "WPSM14", "WPSM15", "WACS50", "WACS60", "WFFA60", "WPOP50", "WPOP60", "WPPM50", "WPPM60", "WPPT50", "WPPT60", "WSQA50", "WSQA70", "WPPM70", "WPPM80", "WEEX90", "WEEX91", "WISO11", "WISO13", "WISO14", "WSTE13", "WSTE14", "WSQE14", "WSQE15", "WBCO50"
            Case Else
                If ((Label241.Text = 0) And (Label31.Text = 0)) Then
                    ' MsgBox("hello6")
                    Response.Redirect("error.aspx")
                End If
        End Select

        Dim formID
        Dim idArray
        formID = Request.QueryString("id")
        If (Len(formID) > 9) Then
            idArray = Split(formID, "-", -1, 1)
            'error
            'If ((idArray(0) = "eCL") And (Len(idArray(1)) = 4) Or (CInt(idArray(2)) > -1)) Then
            If ((LCase(idArray(0)) = "ecl") And (CInt(UBound(idArray)) > -1)) Then
                recStatus = DataList1.Items(0).FindControl("LabelStatus")
                If ((recStatus.Text = "Completed") Or (InStr(recStatus.Text, "Pending") > 0)) Then
                    'CHECK USER COMPARE
                    ListView2.Visible = True
                    Panel31.Visible = True
                    Label6.Text = recStatus.Text '"Final"
                Else
                    ' MsgBox("hello7")
                    Response.Redirect("error3.aspx")
                End If
            Else
                Panel31.Visible = False
                DataList1.Visible = False
                DataList1.Enabled = False

                Panel4a.Visible = True
                Label28.Visible = False
                Label29.Visible = False
            End If
        Else
            Panel31.Visible = False
            DataList1.Visible = False
            DataList1.Enabled = False
            Panel4a.Visible = True
            Label28.Visible = False
            Label29.Visible = False
        End If
    End Sub

    Protected Sub OnRowDataBound2(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView4.DataBound
        'MsgBox("test=" & (GridView4.Rows.Count - 1))
        '  MsgBox("testing2")
        ' MsgBox(GridView4.Rows.Count)

        ' For k As Integer = 0 To GridView4.Rows.Count - 1
        '    MsgBox(GridView4.Rows(k).Cells.Count)
        'For l As Integer = 0 To GridView4.Rows(k).Cells.Count - 1

        'MsgBox("Value=" & GridView4.Rows(k).Cells(l).Text)
        'Next

        'Next


        For i As Integer = (GridView4.Rows.Count - 1) To 1 Step -1

            Dim row As GridViewRow = GridView4.Rows(i)
            Dim previousRow As GridViewRow = GridView4.Rows(i - 1)
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


    Protected Sub ARC_Selected(ByVal sender As Object, ByVal e As SqlDataSourceStatusEventArgs) Handles SqlDataSource14.Selected
        'EC.sp_Check_AgentRole 
        'MsgBox("param=" & e.Command.Parameters("nvcLanID").Value)
        Label241.Text = e.Command.Parameters("@Indirect@return_value").Value
        'MsgBox(Label241.Text)

        'Dim spot3
        'For Each param In e.Command.Parameters

        ' Extract the name and value of the parameter.
        'spot3 = param.ParameterName & " - " & param.Value.ToString()
        'MsgBox(spot3)
        'Next

        'MsgBox("1-" & Label241.Text)
    End Sub



    Protected Sub SRMGR_Selected(ByVal sender As Object, ByVal e As SqlDataSourceStatusEventArgs) Handles SqlDataSource4.Selected
        'EC.sp_Check_AgentRole 

        Label31.Text = e.Command.Parameters("@Indirect@return_value").Value

    End Sub


    Protected Sub SqlDataSource14_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource14.Selecting
        'EC.sp_Check_AgentRole 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource4_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource4.Selecting
        'EC.sp_Check_AgentRole 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource6_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource6.Selecting
        'EC.sp_SelectRecordStatus 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource3_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource3.Selecting
        'EC.sp_Whoisthis 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource2_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource2.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource8_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource8.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


End Class