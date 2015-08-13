Imports System.Data.SqlClient
Imports System.Net.Mail
Imports System.DirectoryServices
Imports System
Imports System.Configuration
Imports System.Web.UI.WebControls
Imports AjaxControlToolkit


Public Class review3
    Inherits BasePage

    Dim pHolder As Label
    Dim panelHolder As Panel
    Dim recStatus As Label
    Dim userName As String
    Dim userTitle As String
    Dim csr As String

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
    ' Employee_Hierarchy.SupID
    Private m_strHierarchySupEmployeeID As String

    ' The employee's manager employee ID in the Employee_Hierarchy table.
    ' Employee_Hierarchy.MgrID
    Private m_strHierarchyMgrEmployeeID As String

    ' The submitter employee ID in the log record.
    ' coaching_log.SubmitterID
    Private m_strSubmitterEmployeeID As String

    ' Indicates if the user is a Senior Manager.
    ' Historical_Dashboard_ACL.Role as "SRMGR"
    Private m_blnUserIsSrManager As Boolean

    Private Function IsAccessAllowed() As Boolean
        If (m_strUserEmployeeID = m_strSubmitterEmployeeID OrElse
            m_strUserEmployeeID = m_strEmployeeID OrElse
            m_strUserEmployeeID = m_strHierarchySupEmployeeID OrElse
            m_strUserEmployeeID = m_strHierarchyMgrEmployeeID OrElse
            m_blnUserIsSrManager OrElse
            m_strUserJobCode.StartsWith("WHHR") OrElse
            m_strUserJobCode.StartsWith("WHER") OrElse
            m_strUserJobCode.StartsWith("WHRC")
            ) Then

            Return True
        End If

        Return False
    End Function

    Protected Sub Page_Load3(ByVal sender As Object, ByVal e As System.EventArgs) Handles ListView2.DataBound
        Dim eclUser As User = Session("eclUser")
        m_strUserJobCode = eclUser.JobCode.Trim().ToUpper()
        m_strUserEmployeeID = Session("eclUser").EmployeeID

        m_strEmployeeID = LCase(DirectCast(ListView2.Items(0).FindControl("EmployeeID"), Label).Text)
        m_strHierarchySupEmployeeID = LCase(DirectCast(ListView2.Items(0).FindControl("HierarchySupEmployeeID"), Label).Text)
        m_strHierarchyMgrEmployeeID = LCase(DirectCast(ListView2.Items(0).FindControl("HierarchyMgrEmployeeID"), Label).Text)
        m_strSubmitterEmployeeID = LCase(DirectCast(ListView2.Items(0).FindControl("SubmitterEmployeeID"), Label).Text)

        m_blnUserIsSrManager = Label241.Text <> "0"

        If (Not IsAccessAllowed()) Then
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

        pHolder = ListView2.Items(0).FindControl("Label52") ' warning date
        Label7.Text = (CDate(pHolder.Text)).ToShortDateString() 'pHolder.Text

        pHolder = ListView2.Items(0).FindControl("Label55")
        Label66.Text = pHolder.Text
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            HandlePageNonPostBack()
        End If
    End Sub

    ' called on page non post back but after authentication is successful
    Public Sub HandlePageNonPostBack()
        Dim eclUser As User = Session("eclUser")
        userTitle = eclUser.JobCode 'GetJobCode(Session("userInfo"))

        ' sp_Check_AgentRole 
        SqlDataSource3.SelectParameters("nvcLanID").DefaultValue = eclUser.LanID
        SqlDataSource3.SelectParameters("nvcRole").DefaultValue = "SRMGR"
        GridView2.DataBind()

        Dim formID
        Dim idArray

        formID = Request.QueryString("id")
        If (Len(formID) > 9) Then
            idArray = Split(formID, "-", -1, 1)
            If ((LCase(idArray(0)) = "ecl") And (CInt(UBound(idArray)) > -1)) Then
                ListView2.Visible = True
                Panel31.Visible = True
                Label6.Text = "Final"
            Else
                Panel31.Visible = False
                Panel4a.Visible = True
                Label28.Visible = False
                Label29.Visible = False
            End If
        Else
            Panel31.Visible = False
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
                    If (j = 0 AndAlso row.Cells(j + 1).Text <> previousRow.Cells(j + 1).Text AndAlso row.Cells(j + 1).RowSpan > 0) Then
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

    Protected Sub SRMGR_Selected(ByVal sender As Object, ByVal e As SqlDataSourceStatusEventArgs) Handles SqlDataSource3.Selected
        'EC.sp_Check_AgentRole 
        Label241.Text = e.Command.Parameters("@Indirect@return_value").Value
    End Sub

    Protected Sub SqlDataSource3_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource3.Selecting
        'EC.sp_Check_AgentRole 
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource2_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource2.Selecting
        'EC.sp_SelectReviewFrom_Warning_Log 
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

    Protected Sub SqlDataSource8_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource8.Selecting
        'EC.sp_SelectReviewFrom_Warning_Log_Reasons 
        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout
    End Sub

End Class