var myTable;
$(document).ready(function () {
	// Initialize datatable
	$(".please-wait").slideDown(500);
    myTable = $('#dataTables-coaching-log-list').DataTable({
    	renderer: "bootstrap",
		autowidth: false,
		language: {
			processing: "<span>Loading...... Please wait...</span>",
		},
		processing: true,
        serverSide: true, // Process server side
        filter: true,     // Enable filter (search box)
        orderMulti: false,// Disable multiple column sorting
		iDisplayLength: 25,
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
                	return '<a href="#"' + 'data-log-id="' + row['ID'] + '" ' + 'data-is-coaching="' + row["IsCoaching"] + '"' +
						'class="modal-link"' + 'style="color: #337ab7;">' + data + '</a>';
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
        ],

        initComplete: function (settings, json) {
        	$(".please-wait").slideUp(500);
        }
    }); // myTable

	// Dynamically hide column(s)
    if (showSupervisorColumn === 'False')
    {
    	myTable.column('strEmpSupName:name').visible(false);
    }

	// Handle 'GO' button clicked, submit the form
    $('#form-search-logs-mysite').on('submit', function (e) {
    	e.preventDefault();

    	// Disable Go button to prevent multiple clicks
    	$(this).attr('disabled', 'disabled');

    	var ajaxRequest = $.ajax({
    		url: searchMySiteLogs,
    		type: 'POST',
    		data: {}
    	});
    })
    
});