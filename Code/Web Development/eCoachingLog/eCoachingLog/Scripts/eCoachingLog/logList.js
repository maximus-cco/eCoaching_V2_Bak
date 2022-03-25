var myTable;
$(document).ready(function () {
	var length = $('#PageSize').val();
	// Initialize datatable
	$(".please-wait").slideDown(500);
    myTable = $('#dataTables-coaching-log-list').DataTable({
    	renderer: "bootstrap",
		autowidth: false,
		language: {
			processing: "<span>Loading...... Please wait...</span>",
    		emptyTable: "No matching logs found."
		},
		processing: true,
        serverSide: true, // Process server side
        filter: false,     // Enable filter (search box)
        orderMulti: false,// Disable multiple column sorting
        pageLength: length,
		order: [[9, "desc"]], // Default order by SubmittedDate desc
        ajax: {
        	url: loadDataUrl,
            type: "POST",
            datatype: "json",
            data: logFilter,
        },
        columns: [
            {
                targets: 0,
                data: "ID", name: "strFormID",
                visible: false,
                searchable: false
            },  // Log ID
            {
                data: "FormName", name: "strFormID",
                render: function (data, type, row, meta) {
                    return '<a href="#"' + 'data-log-id="' + row['ID'] + '" ' + ' data-is-coaching="' + row["IsCoaching"] + '"' +
						' class="modal-link"' + ' style="color: #337ab7;">' + data + '</a>&nbsp;<font color="red">' + row['LogNewText'] + '</font>';
                }
            },  // Log Name
            { data: "EmployeeName", name: "strEMPName" },
            { data: "SupervisorName", name: "strEmpSupName" },
			{ data: "ManagerName", name: "strEmpMgrName" },
            { data: "Status", name: "strFormStatus" },
            { data: "Reasons", name: "strCoachingReason", orderable: false },
            { data: "SubReasons", name: "strSubCoachingReason", orderable: false },
            { data: "Value", name: "strValue", orderable: false },
            { data: "CreatedDate", name: "SubmittedDate" },
			{ data: "FollowupDueDate", name: "FollowupDueDate", visible: true }
        ],

        initComplete: function (settings, json) {
        	$(".please-wait").slideUp(500);
        }

    }); // myTable

	// Set page length
    myTable.page.len(length);

    $('#dataTables-coaching-log-list').on('length.dt', function (e, settings, len) {
    	$('input[name=pageSizeSelected').val(len);
	});

	// Dynamically hide column(s)
    if (showSupervisorColumn === 'False') {
    	myTable.column('strEmpSupName:name').visible(false);
    }

    if (showFollowupDateColumn === 'True') {
    	myTable.column('FollowupDueDate:name').visible(true);
    }
	else
	{
		myTable.column('FollowupDueDate:name').visible(false);
	}
});