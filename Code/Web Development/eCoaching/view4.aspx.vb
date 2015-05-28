Imports System
Imports System.Configuration
Imports System.IO
Imports System.Web.UI.WebControls
Imports AjaxControlToolkit
Imports System.Data.SqlClient
Imports System.Web.Configuration

Imports NPOI.SS.UserModel
Imports NPOI.XSSF.UserModel

Public Class view4
    Inherits System.Web.UI.Page
    Dim lan As String = LCase(User.Identity.Name) 'boulsh
    Dim domain As String
    Dim TodaysDate As String = DateTime.Today.ToShortDateString()
    Dim backDate As String = DateAdd("D", -548, TodaysDate).ToShortDateString()
    Dim connectionString As String = WebConfigurationManager.ConnectionStrings("CoachingConnectionString").ConnectionString

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

        ' Needed for hiding Please Wait Modal dialog
        Response.AppendCookie(New HttpCookie("tokenValue", hiddenTokenId.Value))

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

    Protected Sub ddCSR_DataBound(ByVal sender As Object, ByVal e As EventArgs)

        Dim str As Integer = ddCSR.Items.Count
        MsgBox(ddCSR.Items.Count)


    End Sub

    Protected Sub ExportButton_Click(sender As Object, e As EventArgs) Handles ExportButton.Click
        ExportToExcel()
    End Sub


    Private Sub ExportToExcel()
        Dim workbook As IWorkbook = New XSSFWorkbook()
        Dim sheet As ISheet = workbook.CreateSheet("Sheet1")
        Dim fileName As String = ContructFileName()
        ' start date user selects on the page
        Dim startDate As String = IIf(String.IsNullOrEmpty(Date1.Text), backDate, Date1.Text)
        ' end date user selects on the page
        Dim endDate As String = IIf(String.IsNullOrEmpty(Date2.Text), TodaysDate, Date2.Text)

        Response.Clear()
        Response.Buffer = True
        ' Needed for hiding Please Wait Modal dialog
        Response.AppendCookie(New HttpCookie("tokenValue", hiddenTokenId.Value))
        Response.Charset = "UTF-8"
        ' Give user option to open or save the excel file
        Response.AddHeader("content-disposition", "attachment;filename=" & fileName)
        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"

        ' Call sp to get data and write to Sheet1
        Using connection As New SqlConnection(connectionString)
            Using Command As New SqlCommand("EC.sp_SelectFrom_Coaching_Log_Historical_Export", connection)
                connection.Open()
                Command.CommandType = CommandType.StoredProcedure
                Command.Parameters.AddWithValue("strSourcein", ddSource.SelectedValue)
                Command.Parameters.AddWithValue("@strCSRSitein", ddSite.SelectedValue)
                Command.Parameters.AddWithValue("@strCSRin", ddCSR.SelectedValue)
                Command.Parameters.AddWithValue("@strSUPin", ddSUP.SelectedValue)
                Command.Parameters.AddWithValue("@strMGRin", ddMGR.SelectedValue)
                Command.Parameters.AddWithValue("@strSubmitterin", ddSubmitter.SelectedValue)
                Command.Parameters.AddWithValue("@strSDatein", startDate)
                Command.Parameters.AddWithValue("@strEDatein", endDate)
                Command.Parameters.AddWithValue("@strStatusin", ddStatus.SelectedValue)
                Command.Parameters.AddWithValue("@strvalue", ddValue.SelectedValue)
                Command.CommandTimeout = 300

                Using dataReader As SqlDataReader = Command.ExecuteReader()
                    Dim rowNumber As Integer = 2
                    Dim cellStyle As ICellStyle = workbook.CreateCellStyle()
                    Dim row As IRow
                    Dim cell As ICell
                    Dim cellValue As String

                    CreateFiltersRow(sheet, startDate, endDate)
                    CreateHeaderRow(dataReader, workbook, sheet)
                    ' Set Columns width
                    SetAllColumnsWidth(sheet)

                    cellStyle.WrapText = True
                    While dataReader.Read()
                        ' Create a new row
                        row = sheet.CreateRow(rowNumber)
                        For i = 0 To (dataReader.FieldCount - 1)
                            cell = row.CreateCell(i)
                            cellValue = IIf(dataReader(i) Is DBNull.Value, String.Empty, dataReader(i).ToString())
                            cell.SetCellValue(dataReader(i).ToString())
                            cell.CellStyle = cellStyle
                        Next
                        rowNumber = rowNumber + 1
                    End While

                End Using
            End Using
        End Using

        ' Write Excel Workbook to response outputstream
        workbook.Write(Response.OutputStream)
        Response.Flush()
        Response.End()
    End Sub

    Private Sub CreateFiltersRow(ByVal sheet As ISheet, ByVal startDate As String, ByVal endDate As String)
        Dim row As IRow = sheet.CreateRow(0)
        Dim cell As ICell = row.CreateCell(0)
        Dim filters As New StringBuilder
        Dim site As String = IIf(String.Compare(ddSite.SelectedValue, "%", True) = 0, "All", ddSite.SelectedValue)
        Dim employeeName As String = IIf(String.Compare(ddCSR.SelectedValue, "%", True) = 0, "All", ddCSR.SelectedValue)
        Dim supervisorName As String = IIf(String.Compare(ddSUP.SelectedValue, "%", True) = 0, "All", ddSUP.SelectedValue)
        Dim managerName As String = IIf(String.Compare(ddMGR.SelectedValue, "%", True) = 0, "All", ddMGR.SelectedValue)
        Dim submitter As String = IIf(String.Compare(ddSubmitter.SelectedValue, "%", True) = 0, "All", ddSubmitter.SelectedValue)
        Dim status As String = IIf(String.Compare(ddStatus.SelectedValue, "%", True) = 0, "All", ddStatus.SelectedValue)
        Dim source As String = IIf(String.Compare(ddSource.SelectedValue, "%", True) = 0, "All", ddSource.SelectedValue)
        Dim value As String = IIf(String.Compare(ddValue.SelectedValue, "%", True) = 0, "All", ddValue.SelectedValue)

        filters.Append("Site: " & site & ";  ")
        filters.Append("Empployee: " & employeeName & ";  ")
        filters.Append("Manager: " & supervisorName & ";  ")
        filters.Append("Submitter: " & submitter & ";  ")
        filters.Append("Status: " & status & ";  ")
        filters.Append("Source: " & source & ";  ")
        filters.Append("Value: " & value & ";  ")
        filters.Append("Submitted: " & startDate & " ~ " & endDate)

        cell.SetCellValue(filters.ToString())
    End Sub

    Private Function ContructFileName() As String
        Dim fileDateTime As String = DateTime.Now.ToString("yyyyMMdd") & "_" & DateTime.Now.ToString("HHmmss")
        Return "HistoricalLogs_" & fileDateTime & ".xlsx"
    End Function

    Private Sub CreateHeaderRow(ByVal dataReader As SqlDataReader, ByVal workbook As IWorkbook, ByVal sheet As ISheet)
        Dim headerRow As IRow = sheet.CreateRow(1)
        Dim cell As ICell
        Dim cellStyle As ICellStyle = workbook.CreateCellStyle()
        Dim font As IFont = workbook.CreateFont()

        font.Boldweight = FontBoldWeight.Bold
        cellStyle.SetFont(font)

        For i = 0 To (dataReader.FieldCount - 1)
            cell = headerRow.CreateCell(i)
            cell.SetCellValue(dataReader.GetName(i))
            cell.CellStyle = cellStyle
        Next
    End Sub

    Private Sub SetAllColumnsWidth(ByVal sheet As ISheet)
        sheet.SetColumnWidth(0, 12 * 256)      ' coaching id
        sheet.SetColumnWidth(1, 32 * 256)      ' form name
        sheet.SetColumnWidth(2, 15 * 256)      ' program name 
        sheet.SetColumnWidth(3, 12 * 256)      ' employee id
        sheet.SetColumnWidth(4, 28 * 256)      ' employee name
        sheet.SetColumnWidth(5, 28 * 256)      ' supervisor name
        sheet.SetColumnWidth(6, 28 * 256)      ' manager name 
        sheet.SetColumnWidth(7, 12 * 256)      ' site
        sheet.SetColumnWidth(8, 12 * 256)      ' source
        sheet.SetColumnWidth(9, 22 * 256)      ' sub source
        sheet.SetColumnWidth(10, 28 * 256)     ' coaching reason
        sheet.SetColumnWidth(11, 40 * 256)     ' sub coaching reason    
        sheet.SetColumnWidth(12, 15 * 256)     ' value
        sheet.SetColumnWidth(13, 25 * 256)     ' form status
        sheet.SetColumnWidth(14, 28 * 256)     ' submitted by
        sheet.SetColumnWidth(15, 22 * 256)     ' event date
        sheet.SetColumnWidth(16, 32 * 256)     ' verint id
        sheet.SetColumnWidth(17, 70 * 256)     ' description - this is really really long!
        sheet.SetColumnWidth(18, 35 * 256)     ' coaching notes
        sheet.SetColumnWidth(19, 22 * 256)     ' submitted date
        sheet.SetColumnWidth(20, 22 * 256)     ' supervisor reviewed auto date
        sheet.SetColumnWidth(21, 22 * 256)     ' manager reviewed manual date
        sheet.SetColumnWidth(22, 22 * 256)     ' manager reviewed auto date
        sheet.SetColumnWidth(23, 35 * 256)     ' manager notes
        sheet.SetColumnWidth(24, 22 * 256)     ' employee review auto date
        sheet.SetColumnWidth(25, 22 * 256)     ' employee comments
    End Sub

End Class
