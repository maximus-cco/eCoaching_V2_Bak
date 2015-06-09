Imports NPOI.SS.UserModel
Imports NPOI.XSSF.UserModel

Public Class HistoricalDashboardHandler

    Private Const CacheExpireInMinutes As Integer = 480 ' 8 hours
    Private historicalDashboardDBAccess As HistoricalDashboardDBAccess

    Public Sub New()
        historicalDashboardDBAccess = New HistoricalDashboardDBAccess()
    End Sub

    Public Function GetAllSites() As DataTable
        If HttpContext.Current.Cache("AllSites") Is Nothing Then
            HttpContext.Current.Cache.Insert("AllSites", historicalDashboardDBAccess.GetAllSites(), Nothing, Cache.NoAbsoluteExpiration, Cache.NoSlidingExpiration)
        End If
        Return HttpContext.Current.Cache("AllSites")
    End Function

    Public Function GetAllCSRs() As DataTable
        If HttpContext.Current.Cache("AllCSRs") Is Nothing Then
            HttpContext.Current.Cache.Insert("AllCSRs", historicalDashboardDBAccess.GetAllCSRs(), Nothing, DateTime.Now.AddMinutes(CacheExpireInMinutes), Cache.NoSlidingExpiration)
        End If
        Return HttpContext.Current.Cache("AllCSRs")
    End Function

    Public Function GetAllSupervisors() As DataTable
        If HttpContext.Current.Cache("AllSupervisors") Is Nothing Then
            HttpContext.Current.Cache.Insert("AllSupervisors", historicalDashboardDBAccess.GetAllSupervisors(), Nothing, DateTime.Now.AddMinutes(CacheExpireInMinutes), Cache.NoSlidingExpiration)
        End If
        Return HttpContext.Current.Cache("AllSupervisors")
    End Function

    Public Function GetAllManagers() As DataTable
        If HttpContext.Current.Cache("AllManagers") Is Nothing Then
            HttpContext.Current.Cache.Insert("AllManagers", historicalDashboardDBAccess.GetAllManagers(), Nothing, DateTime.Now.AddMinutes(CacheExpireInMinutes), Cache.NoSlidingExpiration)
        End If
        Return HttpContext.Current.Cache("AllManagers")
    End Function

    Public Function GetAllSubmitters() As DataTable
        If HttpContext.Current.Cache("AllSubmitters") Is Nothing Then
            HttpContext.Current.Cache.Insert("AllSubmitters", historicalDashboardDBAccess.GetAllSubmitters(), Nothing, DateTime.Now.AddMinutes(CacheExpireInMinutes), Cache.NoSlidingExpiration)
        End If
        Return HttpContext.Current.Cache("AllSubmitters")
    End Function

    Public Function GetAllStatuses() As DataTable
        If HttpContext.Current.Cache("AllStatuses") Is Nothing Then
            HttpContext.Current.Cache.Insert("AllStatuses", historicalDashboardDBAccess.GetAllStatuses(), Nothing, DateTime.Now.AddMinutes(CacheExpireInMinutes), Cache.NoSlidingExpiration)
        End If
        Return HttpContext.Current.Cache("AllStatuses")
    End Function

    Public Function GetAllSources(ByVal userLanID As String) As DataTable
        If HttpContext.Current.Cache("AllSources") Is Nothing Then
            HttpContext.Current.Cache.Insert("AllSources", historicalDashboardDBAccess.GetAllSources(userLanID), Nothing, DateTime.Now.AddMinutes(CacheExpireInMinutes), Cache.NoSlidingExpiration)
        End If
        Return HttpContext.Current.Cache("AllSources")
    End Function

    Public Function GetAllValues() As DataTable
        If HttpContext.Current.Cache("AllValues") Is Nothing Then
            HttpContext.Current.Cache.Insert("AllValues", historicalDashboardDBAccess.GetAllValues(), Nothing, DateTime.Now.AddMinutes(CacheExpireInMinutes), Cache.NoSlidingExpiration)
        End If
        Return HttpContext.Current.Cache("AllValues")
    End Function

    Public Function GetCSRsBySite(ByVal site As String) As DataTable
        Dim allCSRs As DataTable = Me.GetAllCSRs()
        Dim query = From CSR In allCSRs.AsEnumerable()
                    Where (CSR.Field(Of String)("strCSRSite") = site Or CSR.Field(Of String)("strCSRSite") = "%")
                    Select CSR
        Return query.CopyToDataTable()
    End Function

    Public Function GetSupervisorsBySite(ByVal site As String) As DataTable
        Dim allSupervisors As DataTable = HttpContext.Current.Cache("AllSupervisors")
        If allSupervisors Is Nothing Then
            allSupervisors = GetAllSupervisors()
        End If
        Dim query = From supervisor In allSupervisors.AsEnumerable()
                    Where (supervisor.Field(Of String)("strCSRSite") = site Or supervisor.Field(Of String)("strCSRSite") = "%")
                    Select supervisor
        Return query.CopyToDataTable()
    End Function

    Public Function GetManagersBySite(ByVal site As String) As DataTable
        Dim allManagers As DataTable = HttpContext.Current.Cache("AllManagers")
        If allManagers Is Nothing Then
            allManagers = GetAllManagers()
        End If
        Dim query = From manager In allManagers.AsEnumerable()
                    Where (manager.Field(Of String)("strCSRSite") = site Or manager.Field(Of String)("strCSRSite") = "%")
                    Select manager
        Return query.CopyToDataTable()
    End Function

    ' custom paging 
    Public Function GetTotalRowCount(ByVal strSourcein As String,
                                ByVal strCSRSitein As String,
                                ByVal strCSRin As String,
                                ByVal strSUPin As String,
                                ByVal strMGRin As String,
                                ByVal strSubmitterin As String,
                                ByVal strSDatein As String,
                                ByVal strEDatein As String,
                                ByVal strStatusin As String,
                                ByVal strjobcode As String,
                                ByVal strValue As String,
                                ByVal sortBy As String,
                                ByVal sortDirection As String
                            ) As Integer


        ' user clicks APPLY to search (sortBy is null and pageIndexChangingTo not exist in current request)
        ' OR somehow totalCount not exists in Session
        ' need to get the total count from DB for this search
        If (String.IsNullOrEmpty(sortBy) AndAlso
            HttpContext.Current.Items("pageIndexChangingTo") Is Nothing) OrElse
            HttpContext.Current.Session("totalCount") Is Nothing Then

            Dim totalCount As Integer = historicalDashboardDBAccess.GetTotalRowCount(strSourcein, strCSRSitein, strCSRin, strSUPin, strMGRin, strSubmitterin, strSDatein,
                                            strEDatein, strStatusin, strjobcode, strValue)
            HttpContext.Current.Session("totalCount") = totalCount

            Return totalCount
        End If

        ' user clicks sortable column header to sort, or user clicks page number
        ' no need to call sp to get the total count
        ' use the one stored in session
        Return HttpContext.Current.Session("totalCount")
    End Function

    ' custom paging
    Public Function GetRows(ByVal startRowIndex As Integer,
                        ByVal pageSize As Integer,
                        ByVal strSourcein As String,
                        ByVal strCSRSitein As String,
                        ByVal strCSRin As String,
                        ByVal strSUPin As String,
                        ByVal strMGRin As String,
                        ByVal strSubmitterin As String,
                        ByVal strSDatein As String,
                        ByVal strEDatein As String,
                        ByVal strStatusin As String,
                        ByVal strjobcode As String,
                        ByVal strValue As String,
                        ByVal sortBy As String,
                        ByVal sortDirection As String
                    ) As List(Of HistoricalDashboard)

        'startRowIndex starts from zero
        startRowIndex = startRowIndex + 1
        sortBy = If(String.IsNullOrEmpty(sortBy), "strFormID", sortBy)

        Dim sortASC As String = "Y"
        If String.Compare(sortDirection, "DESC", True) = 0 Then
            sortASC = "N"
        End If

        Return historicalDashboardDBAccess.GetRows(startRowIndex, pageSize, strSourcein, strCSRSitein, strCSRin, strSUPin, strMGRin, strSubmitterin, strSDatein,
                    strEDatein, strStatusin, strjobcode, strValue, sortBy, sortASC)
    End Function

    Public Function CreateExcel(ByRef filter As HistoricalDashboardFilter) As IWorkbook
        Dim workbook As IWorkbook = New XSSFWorkbook()
        Dim sheet As ISheet = workbook.CreateSheet("Sheet1")
        Dim fileName As String = GetFileName()
        Dim startDate As String = filter.StartDate
        Dim endDate As String = filter.EndDate

        Dim excelDataTable As DataTable = historicalDashboardDBAccess.GetExcelDataTable(filter)

        Dim rowNumber As Integer = 2
        Dim cellStyle As ICellStyle = workbook.CreateCellStyle()
        Dim row As IRow
        Dim cell As ICell

        CreateFiltersRow(sheet, filter)
        CreateHeaderRow(excelDataTable, workbook, sheet)
        ' Set Columns width
        SetAllColumnsWidth(sheet)

        cellStyle.WrapText = True

        For Each dataRow As DataRow In excelDataTable.Rows
            row = sheet.CreateRow(rowNumber)
            Dim i As Integer = 0
            For Each item In dataRow.ItemArray
                cell = row.CreateCell(i)
                cell.SetCellValue(If(item Is DBNull.Value, String.Empty, item.ToString().Trim())) ' trim in stored procedure as well
                cell.CellStyle = cellStyle
                i += 1
            Next
            rowNumber += 1
        Next

        Return workbook
    End Function

    Public Function GetFileName() As String
        Dim fileDateTime As String = DateTime.Now.ToString("yyyyMMdd") & "_" & DateTime.Now.ToString("HHmmss")
        Return "HistoricalLogs_" & fileDateTime & ".xlsx"
    End Function

    Private Sub CreateFiltersRow(ByRef sheet As ISheet, ByRef filter As HistoricalDashboardFilter)
        Dim row As IRow = sheet.CreateRow(0)
        Dim cell As ICell = row.CreateCell(0)
        Dim filters As New StringBuilder
        Dim site As String = If(String.Compare(filter.Site, "%", True) = 0, "All", filter.Site)
        Dim employeeName As String = If(String.Compare(filter.CSRName, "%", True) = 0, "All", filter.CSRName)
        Dim supervisorName As String = If(String.Compare(filter.SupervisorName, "%", True) = 0, "All", filter.SupervisorName)
        Dim managerName As String = If(String.Compare(filter.ManagerName, "%", True) = 0, "All", filter.ManagerName)
        Dim submitter As String = If(String.Compare(filter.SubmitterName, "%", True) = 0, "All", filter.SubmitterName)
        Dim status As String = If(String.Compare(filter.Status, "%", True) = 0, "All", filter.Status)
        Dim source As String = If(String.Compare(filter.Source, "%", True) = 0, "All", filter.Source)
        Dim value As String = If(String.Compare(filter.Value, "%", True) = 0, "All", filter.Value)

        filters.Append("Site: " & site & ";  ")
        filters.Append("Employee: " & employeeName & ";  ")
        filters.Append("Manager: " & supervisorName & ";  ")
        filters.Append("Submitter: " & submitter & ";  ")
        filters.Append("Status: " & status & ";  ")
        filters.Append("Source: " & source & ";  ")
        filters.Append("Value: " & value & ";  ")
        filters.Append("Submitted: " & filter.StartDate & " ~ " & filter.EndDate)

        cell.SetCellValue(filters.ToString())
    End Sub

    Private Sub CreateHeaderRow(ByRef dataTable As DataTable, ByRef workbook As IWorkbook, ByRef sheet As ISheet)
        Dim headerRow As IRow = sheet.CreateRow(1)
        Dim cell As ICell
        Dim cellStyle As ICellStyle = workbook.CreateCellStyle()
        Dim font As IFont = workbook.CreateFont()

        font.Boldweight = FontBoldWeight.Bold
        cellStyle.SetFont(font)

        Dim i As Integer = 0
        For Each column As DataColumn In dataTable.Columns
            cell = headerRow.CreateCell(i)
            cell.SetCellValue(column.ColumnName)
            cell.CellStyle = cellStyle
            i += 1
        Next
    End Sub

    Private Sub SetAllColumnsWidth(ByRef sheet As ISheet)
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
