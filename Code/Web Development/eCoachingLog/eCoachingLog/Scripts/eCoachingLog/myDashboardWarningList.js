// TODO: rename to warningList.js, since historical dashboard will use it as well
var warningTable;
$(document).ready(function () {
	// Initialize datatable
	warningTable = $('#dataTables-warning-log-list').DataTable({
		"renderer": "bootstrap",
		"autowidth": false,
		"processing": true, // Show progress bar
		"serverSide": true, // Process server side
		"filter": true,     // Enable filter (search box)
		"orderMulti": false,// Disable multiple column sorting
		"iDisplayLength": 50,
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
            { "data": "SupervisorName", "name": "supervisorName" },
			{ "data": "ManagerName", "name": "managerName" },
            { "data": "WarningType", "name": "warningType" },
            { "data": "WarningReasons", "name": "warningReasons", "orderable": false },
            { "data": "CreatedDate", "name": "CreateDate" }
		],

		"initComplete": function (settings, json) {
			//console.log('dataTables-warning-log-list init complete.');
		}
	}); // warningType

	// Dynamically hide column(s)
	//if (showSupervisorColumn === 'False') {
	//	warningTable.column('supervisorName:name').visible(false);
	//}

});