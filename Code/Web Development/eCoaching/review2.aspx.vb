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

    ' The user employee ID.
    ' Employee_Hierarchy.EmpID
    Private m_strUserEmployeeID As String

    ' The user job code.
    ' Employee_Hierarchy.Emp_Job_Code
    Private m_strUserJobCode As String

    ' The employee's employee ID in the log record.
    ' coaching_log.EmpID
    Private m_strEmployeeID As String

    ' The employee's supervisor employee ID in the Employee_Hierarchy table.
    ' Employee_Hierarchy.Sup_ID
    Private m_strHierarchySupEmployeeID As String

    ' The employee's manager employee ID in the Employee_Hierarchy table.
    ' Employee_Hierarchy.Mgr_ID
    Private m_strHierachyMgrEmployeeID As String

    ' The submitter employee ID in the log record.
    ' coaching_log.SubmitterID
    Private m_strSubmitterEmployeeID As String

    ' Indicates if the user is an ECL user. 
    ' Historical_Dashboard_ACL.Role as "ECL"
    Private m_blnUserIsECL As Boolean

    ' Indicates if the user is Senior Manager. 
    ' Historical_Dashboard_ACL.Role as "SRMGR"
    Private m_blnUserIsSeniorMgr As Boolean

    Private Function IsAccessAllowed() As Boolean
        If (m_strUserEmployeeID = m_strSubmitterEmployeeID OrElse
            m_strUserEmployeeID = m_strEmployeeID OrElse
            m_strUserEmployeeID = m_strHierarchySupEmployeeID OrElse
            m_strUserEmployeeID = m_strHierachyMgrEmployeeID OrElse
            m_blnUserIsECL OrElse
            m_blnUserIsSeniorMgr OrElse
            m_strUserJobCode.StartsWith("WHHR") OrElse
            m_strUserJobCode.StartsWith("WHER") OrElse
            m_strUserJobCode.StartsWith("WHRC")
            ) Then

            Return True
        End If

        Return False
    End Function

    Protected Sub Page_Load3(ByVal sender As Object, ByVal e As System.EventArgs) Handles ListView2.DataBound
        'csrLabel = ListView2.Items(0).FindControl("Label88")
        'csr = csrLabel.Text
        '' Get the CSR's supervisor and manager from employee_hierarchy table
        'SqlDataSource3.SelectParameters("strUserin").DefaultValue = csr
        'SqlDataSource3.DataBind()
        'GridView2.DataBind()

        'Dim subString As String
        'Try
        '    ' supervisorLanID$supervisorEmployeeID$managerLanID$managerEmployeeID
        '    subString = (CType(GridView2.Rows(0).FindControl("Flow"), Label).Text)
        'Catch ex As Exception
        '    subString = ""
        'End Try

        'If (Len(subString) > 0) Then
        '    Dim subArray As Array
        '    subArray = Split(subString, "$", -1, 1)
        '    m_strCSRSupHierarchyEmployeeID = subArray(1)
        '    m_strCSRMgrHierachyEmployeeID = subArray(3)
        'Else
        '    csupervisor = "Unavailable"
        '    cmanager = "Unavailable"
        'End If

        Dim eclUser As User = Session("eclUser")
        m_strUserJobCode = eclUser.JobCode.Trim().ToUpper()
        m_strUserEmployeeID = Session("eclUser").EmployeeID

        m_strEmployeeID = LCase(DirectCast(ListView2.Items(0).FindControl("EmployeeID"), Label).Text)
        m_strHierarchySupEmployeeID = LCase(DirectCast(ListView2.Items(0).FindControl("HierarchySupEmployeeID"), Label).Text)
        m_strHierachyMgrEmployeeID = LCase(DirectCast(ListView2.Items(0).FindControl("HierarchyMgrEmployeeID"), Label).Text)
        m_strSubmitterEmployeeID = LCase(DirectCast(ListView2.Items(0).FindControl("SubmitterEmployeeID"), Label).Text)

        m_blnUserIsECL = Label241.Text <> "0"
        m_blnUserIsSeniorMgr = Label31.Text <> "0"

        If (Not IsAccessAllowed()) Then
            ' Send the user to the unauthorized page.
            Response.Redirect("error3.aspx")
        End If

        pHolder = ListView2.Items(0).FindControl("Label50")
        Label3.Text = pHolder.Text
        pHolder = ListView2.Items(0).FindControl("Label51")
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
        Else '= Direct
            Panel16.Visible = True
            pHolder = ListView2.Items(0).FindControl("Label52")
            Label7.Text = (CDate(pHolder.Text)).ToShortDateString() 'pHolder.Text
            Panel17.Visible = False
        End If

        pHolder = ListView2.Items(0).FindControl("Label55")
        Label66.Text = pHolder.Text

        pHolder = ListView2.Items(0).FindControl("Label67")
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
        If (pHolder.Text = "False") Then
            Panel19.Visible = False
        Else
            Panel19.Visible = True
            pHolder = ListView2.Items(0).FindControl("Label57")
            Label19.Text = Server.HtmlDecode(pHolder.Text)
        End If

        pHolder = ListView2.Items(0).FindControl("Label69")
        If (pHolder.Text = "False") Then
            Panel20.Visible = False
        Else
            Panel20.Visible = True
            pHolder = ListView2.Items(0).FindControl("Label58")
            Label21.Text = Server.HtmlDecode(pHolder.Text)
        End If

        pHolder = ListView2.Items(0).FindControl("Label157")
        If (pHolder.Text = "False") Then
            Panel14.Visible = False
        Else
            Panel14.Visible = True
            pHolder = ListView2.Items(0).FindControl("Label158")
            Label149.Text = Server.HtmlDecode(pHolder.Text)
        End If

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
            pHolder = ListView2.Items(0).FindControl("Label100")
            pHolder.Text = "Reviewed and acknowledged coaching opportunity on"
            panelHolder = ListView2.Items(0).FindControl("Panel32")
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
        userTitle = eclUser.JobCode 'GetJobCode(Session("userInfo"))

        ' sp_Check_AgentRole - ARC
        SqlDataSource14.SelectParameters("nvcLanID").DefaultValue = lan
        SqlDataSource14.SelectParameters("nvcRole").DefaultValue = "ECL"
        GridView1.DataBind()

        ' sp_Check_AgentRole - SRMGR
        SqlDataSource4.SelectParameters("nvcLanID").DefaultValue = lan
        SqlDataSource4.SelectParameters("nvcRole").DefaultValue = "SRMGR"
        GridView5.DataBind()

        Select Case True
            Case (InStr(1, userTitle, "40", 1) > 0), (InStr(1, userTitle, "50", 1) > 0), (InStr(1, userTitle, "60", 1) > 0), (InStr(1, userTitle, "70", 1) > 0), (InStr(1, userTitle, "WISO", 1) > 0), (InStr(1, userTitle, "WSTE", 1) > 0), (InStr(1, userTitle, "WSQE", 1) > 0), (InStr(1, userTitle, "WACQ", 1) > 0), (InStr(1, userTitle, "WPPM", 1) > 0), (InStr(1, userTitle, "WPSM", 1) > 0), (InStr(1, userTitle, "WEEX", 1) > 0), (InStr(1, userTitle, "WPWL51", 1) > 0), (InStr(1, userTitle, "WHER", 1) > 0), (InStr(1, userTitle, "WHHR", 1) > 0),
                (InStr(1, userTitle, "WHRC", 1) > 0)
                '"WPWL51","WACS40", "WMPR40", "WPPT40", "WSQA40", "WTTR40", "WTTR50", "WPSM11", "WPSM12", "WPSM13", "WPSM14", "WPSM15", "WACS50", "WACS60", "WFFA60", "WPOP50", "WPOP60", "WPPM50", "WPPM60", "WPPT50", "WPPT60", "WSQA50", "WSQA70", "WPPM70", "WPPM80", "WEEX90", "WEEX91", "WISO11", "WISO13", "WISO14", "WSTE13", "WSTE14", "WSQE14", "WSQE15", "WBCO50"
            Case Else
                If ((Label241.Text = 0) And (Label31.Text = 0)) Then
                    Response.Redirect("error.aspx")
                End If
        End Select

        Dim formID
        Dim idArray
        formID = Request.QueryString("id")
        If (Len(formID) > 9) Then
            idArray = Split(formID, "-", -1, 1)
            If ((LCase(idArray(0)) = "ecl") And (CInt(UBound(idArray)) > -1)) Then
                recStatus = DataList1.Items(0).FindControl("LabelStatus")
                If ((recStatus.Text = "Completed") Or (InStr(recStatus.Text, "Pending") > 0)) Then
                    'CHECK USER COMPARE
                    ListView2.Visible = True
                    Panel31.Visible = True
                    Label6.Text = recStatus.Text '"Final"
                Else
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
        For i As Integer = (GridView4.Rows.Count - 1) To 1 Step -1
            Dim row As GridViewRow = GridView4.Rows(i)
            Dim previousRow As GridViewRow = GridView4.Rows(i - 1)

            For j As Integer = 0 To row.Cells.Count - 1
                If (row.Cells(j).Text = previousRow.Cells(j).Text) Then
                    ' fixed issue for coaching_log.CoachingID: 1412519
                    ' AHT - Keeping the call on track - Opportunity
                    ' AHT - Other: Specify reason under coaching details - Opportunity
                    ' Attendance - Other: Specify reason under coaching details - Opportunity
                    ' Quality - Other: Specify reason under coaching details - Opportunity
                    If (j < row.Cells.Count - 1 AndAlso row.Cells(j + 1).Text <> previousRow.Cells(j + 1).Text AndAlso row.Cells(j + 1).RowSpan > 0) Then
                        Continue For
                    End If

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
        Label241.Text = e.Command.Parameters("@Indirect@return_value").Value
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