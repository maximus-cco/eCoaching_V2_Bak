// TODO: rename to warningList.js, since historical dashboard will use it as well
var warningTable;
$(document).ready(function () {
	var length = $('#PageSize').val();
	alert(length);
	// Initialize datatable
	warningTable = $('#dataTables-warning-log-list').DataTable({
		"renderer": "bootstrap",
		"autowidth": false,
		"processing": true, // Show progress bar
		"serverSide": true, // Process server side
		"filter": false,     // Disable filter (search box)
		"orderMulti": false,// Disable multiple column sorting
		"pageLength": length,
		"order": [[7, "desc"]], // Default order by SubmittedDate desc
		"ajax": {
			url: loadDataUrl,
			"type": "POST",
			"datatype": "json",
			"data": myDashboardSearch
		},
		"columns": [
            {
            	"targets": 0,
            	"data": "ID", "name": "strFormID",
            	"visible": false,
            	"searchable": false
            },  // Log ID
            {
            	"data": "FormName", "name": "strFormID",
            	"render": function (data, type, row, meta) {
            		return '<a href="#"' + 'data-log-id="' + row['ID'] + '" ' + 'data-is-coaching="' + row["IsCoaching"] + '"' +
						'class="modal-link"' + 'style="color: #337ab7;">' + data + '</a>';
            	}
            },  // Log Name
            { "data": "EmployeeName", "name": "strEMPName" },
            { "data": "SupervisorName", "name": "strEmpSupName" },
			{ "data": "ManagerName", "name": "strEmpMgrName" },
            { "data": "Reasons", "name": "strCoachingReason", "orderable": false },
            { "data": "SubReasons", "name": "strSubCoachingReason", "orderable": false },
            { "data": "CreatedDate", "name": "SubmittedDate" }
		],

		"initComplete": function (settings, json) {
			//console.log('dataTables-warning-log-list init complete.');
		}
	}); // warningType

	warningTable.page.len(length);

	$('#dataTables-warning-log-list').on('length.dt', function (e, settings, len) {
		$('input[name=pageSizeSelected').val(len);
	});

	// Dynamically hide column(s)
	//if (showSupervisorColumn === 'False') {
	//	warningTable.column('supervisorName:name').visible(false);
	//}

});