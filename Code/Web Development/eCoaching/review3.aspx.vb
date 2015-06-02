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
 
    Protected Sub Page_Load3(ByVal sender As Object, ByVal e As System.EventArgs) Handles ListView2.DataBound
        '************************************
        'check the user's SUP and MGR and assign to values
        ' csupervisor
        'cmanager
        '********************
        Dim pHolder1a As Label
        Dim pHolder2a As Label
        Dim pHolder3a As Label
        Dim pHolder4a As Label
        Dim eclUser As User = Session("eclUser")
        Dim lan As String = eclUser.LanID

        pHolder1a = ListView2.Items(0).FindControl("Label49")
        pHolder2a = ListView2.Items(0).FindControl("Label48")
        pHolder3a = ListView2.Items(0).FindControl("Label47")
        pHolder4a = ListView2.Items(0).FindControl("Label1")



        If ((lan <> (Replace(LCase(pHolder4a.Text), "'", ""))) And (lan <> (Replace(LCase(pHolder1a.Text), "'", ""))) And (lan <> (Replace(LCase(pHolder2a.Text), "'", ""))) And (lan <> (Replace(LCase(pHolder3a.Text), "'", ""))) And (Label241.Text = 0) And (InStr(1, userTitle, "WHHR", 1) = 0) And (InStr(1, userTitle, "WHER", 1) = 0)) Then

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

      
        pHolder = ListView2.Items(0).FindControl("Label52") ' warning date
            Label7.Text = (CDate(pHolder.Text)).ToShortDateString() 'pHolder.Text
            'Label7.Text = pHolder.Text
      


        pHolder = ListView2.Items(0).FindControl("Label55")
        Label66.Text = pHolder.Text


        '  panelHolder = ListView2.Items(0).FindControl("Panel32")
        ' panelHolder.Visible = True



    End Sub

    Public Overrides Sub HandlePageDisplay()
    End Sub

    Public Overrides Sub Initialize()
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
            'error
            'If ((idArray(0) = "eCL") And (Len(idArray(1)) = 4) Or (CInt(idArray(2)) > -1)) Then


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