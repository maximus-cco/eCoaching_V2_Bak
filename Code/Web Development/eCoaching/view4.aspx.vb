Imports System
Imports System.Configuration
Imports System.Web.UI.WebControls
Imports AjaxControlToolkit
Imports System.Data.SqlClient
Imports System.Web.Configuration

Public Class view4
    Inherits BasePage

    Dim TodaysDate As String = DateTime.Today.ToShortDateString()
    Dim backDate As String = DateAdd("D", -30, TodaysDate).ToShortDateString()
    'Dim connString As String = "server=VRIVFSSDBT02\SCORT01,1438; Integrated Security=true; Initial Catalog=eCoachingTest"
    'Dim connString As String = "server=VDENSSDBP07\SCORP01,1436; Integrated Security=true; Initial Catalog=eCoaching"
    Dim connString As String = WebConfigurationManager.ConnectionStrings("CoachingConnectionString").ConnectionString

    Dim counter As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' authentication is done in BasePage
        ' if it makes it here, it means authentication is successful
        ' still need to initialize the page on initial display
        If Not IsPostBack Then
            InitializePageDisplay()
        End If
    End Sub

    Private Sub InitializePageDisplay()
        getFilters1()
        getFilters2()
        getFilters3()
        getFilters4()
        getFilters5()
        getFilters6()
        getFilters7()
        getFilters8()

        Date1.Text = backDate
        Date2.Text = TodaysDate

        Label6a.Text = GetJobCode(Session("userInfo"))
        Select Case True 'Label6a.Text
            Case (InStr(1, Label6a.Text, "40", 1) > 0), (InStr(1, Label6a.Text, "50", 1) > 0), (InStr(1, Label6a.Text, "60", 1) > 0), (InStr(1, Label6a.Text, "70", 1) > 0), (InStr(1, Label6a.Text, "WISO", 1) > 0), (InStr(1, Label6a.Text, "WSTE", 1) > 0), (InStr(1, Label6a.Text, "WSQE", 1) > 0), (InStr(1, Label6a.Text, "WACQ", 1) > 0), (InStr(1, Label6a.Text, "WPPM", 1) > 0), (InStr(1, Label6a.Text, "WPSM", 1) > 0), (InStr(1, Label6a.Text, "WEEX", 1) > 0), (InStr(1, Label6a.Text, "WISY", 1) > 0), (InStr(1, Label6a.Text, "WPWL51", 1) > 0), (InStr(1, Label6a.Text, "WHER", 1) > 0), (InStr(1, Label6a.Text, "WHHR", 1) > 0)
                '"WACS40", "WMPR40", "WPPT40", "WSQA40", "WTTR40", "WTTR50", "WPSM11", "WPSM12", "WPSM13", "WPSM14", "WPSM15", "WACS50", "WACS60", "WFFA60", "WPOP50", "WPOP60", "WPPM50", "WPPM60", "WPPT50", "WPPT60", "WSQA50", "WSQA70", "WPPM70", "WPPM80", "WEEX90", "WEEX91", "WISO11", "WISO13", "WISO14", "WSTE13", "WSTE14", "WSQE14", "WSQE15", "WBCO50", "WEEX"
                Label26.Text = "Welcome to the Historical Reporting Dashboard"

                CalendarExtender1.EndDate = TodaysDate
                CalendarExtender2.EndDate = TodaysDate
            Case Else
                Response.Redirect("error.aspx")
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


    'Protected Function oLink(ByVal destination As String, ByVal indicator As String) As String
    Protected Function oLink(ByVal indicator As String) As String

        If (indicator = "Warning") Then

            Return ("review3.aspx?id={0}")
        Else
            Return ("review2.aspx?id={0}")

        End If
    End Function


    Protected Sub getFilters1()

        Dim conn As New SqlConnection(connString)
        Dim comm As New SqlCommand("EC.sp_Select_Sites_For_Dashboard", conn)

        comm.CommandType = CommandType.StoredProcedure
        'Dim da As New SqlDataAdapter(comm)
        'Dim ds As New DataSet()


        Try

            conn.Open()
            ddSite.DataSource = comm.ExecuteReader()
            ddSite.DataTextField = "SiteText"
            ddSite.DataValueField = "SiteValue"
            ddSite.DataBind()

        Catch ex As Exception
            Throw ex
            'MsgBox("site")
            'Response.Redirect("error4.aspx")

        Finally

            conn.Close()
            conn.Dispose()

        End Try



    End Sub


    Protected Sub getFilters2()

        Dim conn As New SqlConnection(connString)
        Dim comm As New SqlCommand("EC.sp_SelectFrom_Coaching_LogDistinctCSRCompleted2", conn)

        comm.CommandType = CommandType.StoredProcedure
        ' Dim da As New SqlDataAdapter(comm)
        ' Dim ds As New DataSet()

        Try
            conn.Open()
            ddCSR.DataSource = comm.ExecuteReader()
            ddCSR.DataTextField = "CSRText"
            ddCSR.DataValueField = "CSRValue"
            ddCSR.DataBind()

        Catch ex As Exception
            Throw ex
            'MsgBox("CSR1")
            'Response.Redirect("error4.aspx")

        Finally

            conn.Close()
            conn.Dispose()

        End Try



    End Sub



    Protected Sub getFilters2a()

        Dim conn As New SqlConnection(connString)
        Dim comm As New SqlCommand("EC.sp_SelectFrom_Coaching_LogDistinctCSRCompleted", conn)

        comm.CommandType = CommandType.StoredProcedure
        Dim da As New SqlDataAdapter(comm)
        Dim ds As New DataSet
        Dim dv As DataView



        Try
            conn.Open()
            da.SelectCommand = comm
            da.Fill(ds, "Filter DataView")

            da.Dispose()
            dv = ds.Tables(0).DefaultView
            '   MsgBox(ddSite.SelectedValue)
            dv.RowFilter = "strCSRSite Like '" & ddSite.SelectedValue & "' OR strCSRSite = '%'"

            ddCSR.DataSource = dv 'comm.ExecuteReader()
            ddCSR.DataTextField = "CSRText"
            ddCSR.DataValueField = "CSRValue"
            ddCSR.DataBind()

        Catch ex As Exception
            Throw ex

            'MsgBox("CSR2")
            'Response.Redirect("error4.aspx")

        Finally

            conn.Close()
            conn.Dispose()

        End Try



    End Sub




    Protected Sub getFilters3()

        Dim conn As New SqlConnection(connString)
        Dim comm As New SqlCommand("EC.sp_SelectFrom_Coaching_LogDistinctSUPCompleted2", conn)

        comm.CommandType = CommandType.StoredProcedure
        ' Dim da As New SqlDataAdapter(comm)
        ' Dim ds As New DataSet()

        Try
            conn.Open()
            ddSUP.DataSource = comm.ExecuteReader()
            ddSUP.DataTextField = "SUPText"
            ddSUP.DataValueField = "SUPValue"
            ddSUP.DataBind()

        Catch ex As Exception
            Throw ex
            'MsgBox("sup1")
            'Response.Redirect("error4.aspx")

        Finally

            conn.Close()
            conn.Dispose()

        End Try



    End Sub


    Protected Sub getFilters3a()

        Dim conn As New SqlConnection(connString)
        Dim comm As New SqlCommand("EC.sp_SelectFrom_Coaching_LogDistinctSUPCompleted", conn)

        comm.CommandType = CommandType.StoredProcedure
        Dim da As New SqlDataAdapter(comm)
        Dim ds As New DataSet
        Dim dv As DataView



        Try
            conn.Open()
            da.SelectCommand = comm
            da.Fill(ds, "Filter DataView")

            da.Dispose()
            dv = ds.Tables(0).DefaultView
            '   MsgBox(ddSite.SelectedValue)
            dv.RowFilter = "strCSRSite Like '" & ddSite.SelectedValue & "' OR strCSRSite = '%'"


            ddSUP.DataSource = dv 'comm.ExecuteReader()
            ddSUP.DataTextField = "SUPText"
            ddSUP.DataValueField = "SUPValue"
            ddSUP.DataBind()

        Catch ex As Exception
            Throw ex
            'MsgBox("Sup2")
            'Response.Redirect("error4.aspx")

        Finally

            conn.Close()
            conn.Dispose()

        End Try



    End Sub


    Protected Sub getFilters4()

        Dim conn As New SqlConnection(connString)
        Dim comm As New SqlCommand("EC.sp_SelectFrom_Coaching_LogDistinctMGRCompleted2", conn)

        comm.CommandType = CommandType.StoredProcedure
        'Dim da As New SqlDataAdapter(comm)
        'Dim ds As New DataSet()

        Try
            conn.Open()
            ddMGR.DataSource = comm.ExecuteReader()
            ddMGR.DataTextField = "MGRText"
            ddMGR.DataValueField = "MGRValue"
            ddMGR.DataBind()

        Catch ex As Exception
            Throw ex
            'MsgBox("Mgr1")
            'Response.Redirect("error4.aspx")

        Finally

            conn.Close()
            conn.Dispose()

        End Try



    End Sub




    Protected Sub getFilters4a()

        Dim conn As New SqlConnection(connString)
        Dim comm As New SqlCommand("EC.sp_SelectFrom_Coaching_LogDistinctMGRCompleted", conn)

        comm.CommandType = CommandType.StoredProcedure
        Dim da As New SqlDataAdapter(comm)
        Dim ds As New DataSet
        Dim dv As DataView



        Try
            conn.Open()
            da.SelectCommand = comm
            da.Fill(ds, "Filter DataView")

            da.Dispose()
            dv = ds.Tables(0).DefaultView
            '   MsgBox(ddSite.SelectedValue)
            dv.RowFilter = "strCSRSite Like '" & ddSite.SelectedValue & "' OR strCSRSite = '%'"


            ddMGR.DataSource = dv 'comm.ExecuteReader()
            ddMGR.DataTextField = "MGRText"
            ddMGR.DataValueField = "MGRValue"
            ddMGR.DataBind()

        Catch ex As Exception
            Throw ex
            'MsgBox("mgr2")
            'Response.Redirect("error4.aspx")

        Finally

            conn.Close()
            conn.Dispose()

        End Try



    End Sub


    Protected Sub getFilters5()

        Dim conn As New SqlConnection(connString)
        Dim comm As New SqlCommand("EC.sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2", conn)

        comm.CommandType = CommandType.StoredProcedure
        'Dim da As New SqlDataAdapter(comm)
        'Dim ds As New DataSet()

        Try
            conn.Open()
            ddSubmitter.DataSource = comm.ExecuteReader()
            ddSubmitter.DataTextField = "SubmitterText"
            ddSubmitter.DataValueField = "SubmitterValue"
            ddSubmitter.DataBind()


        Catch ex As Exception
            Throw ex
            'MsgBox("submitter")
            'Response.Redirect("error4.aspx")

        Finally

            conn.Close()
            conn.Dispose()

        End Try


    End Sub


    Protected Sub getFilters6()

        Dim conn As New SqlConnection(connString)
        Dim comm As New SqlCommand("EC.sp_Select_Values_For_Dashboard", conn)

        comm.CommandType = CommandType.StoredProcedure
        'Dim da As New SqlDataAdapter(comm)
        'Dim ds As New DataSet()

        Try
            conn.Open()
            ddValue.DataSource = comm.ExecuteReader()
            ddValue.DataTextField = "ValueText"
            ddValue.DataValueField = "ValueValue"
            ddValue.DataBind()

        Catch ex As Exception
            Throw ex
            'MsgBox("3")
            'Response.Redirect("error4.aspx")

        Finally

            conn.Close()
            conn.Dispose()

        End Try



    End Sub


    Protected Sub getFilters7()

        Dim conn As New SqlConnection(connString)
        Dim comm As New SqlCommand("EC.sp_Select_Sources_For_Dashboard", conn)

        comm.CommandType = CommandType.StoredProcedure
        comm.Parameters.Add("@strUserin", SqlDbType.VarChar).Value = lan


        'Dim da As New SqlDataAdapter(comm)
        'Dim ds As New DataSet()

        Try
            conn.Open()
            ddSource.DataSource = comm.ExecuteReader()
            ddSource.DataTextField = "SourceText"
            ddSource.DataValueField = "SourceValue"
            ddSource.DataBind()

        Catch ex As Exception
            Throw ex
            'MsgBox("2")
            'Response.Redirect("error4.aspx")

        Finally

            conn.Close()
            conn.Dispose()

        End Try



    End Sub


    Protected Sub getFilters8()

        Dim conn As New SqlConnection(connString)
        Dim comm As New SqlCommand("EC.sp_Select_Statuses_For_Dashboard", conn)

        comm.CommandType = CommandType.StoredProcedure
        'Dim da As New SqlDataAdapter(comm)
        'Dim ds As New DataSet()

        Try
            conn.Open()
            ddStatus.DataSource = comm.ExecuteReader()
            ddStatus.DataTextField = "StatusText"
            ddStatus.DataValueField = "StatusValue"
            ddStatus.DataBind()

        Catch ex As Exception
            Throw ex
            'MsgBox("1")
            'Response.Redirect("error4.aspx")
        Finally

            conn.Close()
            conn.Dispose()

        End Try

    End Sub


    Protected Sub getDashboard()

        Dim conn As New SqlConnection(connString)
        Dim comm As New SqlCommand("EC.sp_SelectFrom_Coaching_Log_HistoricalSUP", conn)

        comm.CommandType = CommandType.StoredProcedure
        Dim da As New SqlDataAdapter(comm)
        'Dim ds As New DataSet()
        Dim dt As New DataTable()

        comm.Parameters.Add("@strSDatein", SqlDbType.DateTime).Value = Date1.Text
        comm.Parameters.Add("@strEDatein", SqlDbType.DateTime).Value = Date2.Text
        comm.Parameters.Add("@strjobcode", SqlDbType.NVarChar).Value = Label6a.Text
        comm.Parameters.Add("@strValue", SqlDbType.NVarChar).Value = ddValue.SelectedValue
        comm.Parameters.Add("@strCSRin", SqlDbType.NVarChar).Value = ddCSR.SelectedValue
        comm.Parameters.Add("@strSUPin", SqlDbType.NVarChar).Value = ddSUP.SelectedValue
        comm.Parameters.Add("@strMGRin", SqlDbType.NVarChar).Value = ddMGR.SelectedValue
        comm.Parameters.Add("@strSubmitterin", SqlDbType.NVarChar).Value = ddSubmitter.SelectedValue
        comm.Parameters.Add("@strCSRSitein", SqlDbType.NVarChar).Value = ddSite.SelectedValue
        comm.Parameters.Add("@strSourcein", SqlDbType.NVarChar).Value = ddSource.SelectedValue
        comm.Parameters.Add("@strStatusin", SqlDbType.NVarChar).Value = ddStatus.SelectedValue


        Try
            conn.Open()
            da.SelectCommand = comm
            ' Dim dt As New DataTable

            GridView1.EmptyDataText = "There are no items to display."
            da.Fill(dt)

            '  da.Fill(ds)
            GridView1.DataSource = dt
            Session("dashboard") = dt
            ' Session("dashboard") = dt

            counter = dt.Rows.Count '(Session("dashboard").Tables(0).Rows.Count)

            GridView1.DataBind()
            GridView1.Visible = True


        Catch ex As Exception

            Throw ex

            'Response.Redirect("error4.aspx")
        Finally


            conn.Close()


            dt.Dispose()
            conn.Dispose()

        End Try


    End Sub

    Protected Sub OnPaging(ByVal sender As Object, ByVal e As GridViewPageEventArgs)

        GridView1.PageIndex = e.NewPageIndex
        GridView1.DataSource = CType(Session("dashboard"), DataTable)
        GridView1.DataBind()

    End Sub


    Public Sub gvSorting(ByVal sender As Object, ByVal e As GridViewSortEventArgs)

        Dim dt = TryCast(Session("dashboard"), DataTable)
        'Dim dt = TryCast(Session("dashboard"), DataTable)

        If dt IsNot Nothing Then

            dt.DefaultView.Sort = e.SortExpression & " " & GetSortDirection(e.SortExpression)
            GridView1.DataSource = Session("dashboard") 'Session("dashboard")
            GridView1.DataBind()


        End If

    End Sub

    Private Function GetSortDirection(ByVal column As String) As String

        Dim sortDirection = "ASC"

        Dim sortExpression = TryCast(ViewState("SortExpression"), String)

        If sortExpression IsNot Nothing Then

            If sortExpression = column Then

                Dim lastDirection = TryCast(ViewState("SortDirection"), String)

                If lastDirection IsNot Nothing _
                    AndAlso lastDirection = "ASC" Then

                    sortDirection = "DESC"


                End If
            End If
        End If

        ViewState("SortDirection") = sortDirection
        ViewState("SortExpression") = column


        Return sortDirection

    End Function



    Protected Sub getFiltersx()

        'Dim conn As New SqlConnection("server=VRIVFSSDBT02\SCORT01,1438; Integrated Security=true; Initial Catalog=eCoachingTest")
        'Dim conn As New SqlConnection("server=VDENSSDBP07\SCORP01,1436; Integrated Security=true; Initial Catalog=eCoaching")
        Dim conn As New SqlConnection(connString)


        Dim ddlValues As SqlDataReader
        conn.Open()
        Dim comm As New SqlCommand("EC.sp_SelectFrom_Coaching_LogDistinctCSRCompleted2", conn)

        ddlValues = comm.ExecuteReader()

        ddCSR.DataSource = ddlValues
        ddCSR.DataTextField = "CSRText"
        ddCSR.DataValueField = "CSRValue"
        ddCSR.DataBind()

        conn.Close()
        conn.Dispose()

    End Sub


    Protected Sub GridView1_Bound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound


        If e.Row.RowType = DataControlRowType.Footer Then
            Dim dt = TryCast(Session("dashboard"), DataTable)

            counter = dt.Rows.Count

            DirectCast(e.Row.FindControl("lblTotal"), Label).Text = counter & " records"
        End If


        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim id As Label = e.Row.FindControl("Label1")

            Dim mainReason As DataList = e.Row.FindControl("Dlist1")
            Dim subReason As DataList = e.Row.FindControl("Dlist2")
            Dim Value As DataList = e.Row.FindControl("Dlist3")


            If (Len(id.Text) > 0) Then



                Dim conn2 As New SqlConnection(connString)
                Dim comm2 As New SqlCommand("EC.sp_SelectReviewFrom_Coaching_Log_Reasons", conn2)


                comm2.CommandType = CommandType.StoredProcedure
                comm2.Parameters.Add("@strFormIDin", SqlDbType.VarChar).Value = id.Text
                Dim da As New SqlDataAdapter(comm2)
                Dim ds As New DataSet()

                da.Fill(ds)
                mainReason.DataSource = ds
                mainReason.DataBind()

                subReason.DataSource = ds
                subReason.DataBind()

                Value.DataSource = ds
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

        getDashboard()

    End Sub



    Protected Sub ddSite1_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddSite.SelectedIndexChanged


        If ddSite.SelectedValue = "%" Then

            getFilters2()
            getFilters3()
            getFilters4()
        Else

            getFilters2a()
            getFilters3a()
            getFilters4a()

        End If


    End Sub

End Class
