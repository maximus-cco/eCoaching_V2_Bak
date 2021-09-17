var myTable;
$(document).ready(function () {
    //console.log('read');
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
            /* Review and Coach */
            {
                data: 'ID',
                render:
                    function (data, type, row, meta) {
                        //console.log(data);
                        // TODO: remove id check, instead, will add logic in service to determine based on each log's IsFiveEvalLog or IsOneEvalLog
                        // all log under Pending Review or _MyPendingFollowupCoaching  needs these 2 links
                        if (showPrepareLink === 'True' && showCoachLink === 'True') {
                        //if (data == 188111) {
                            var prepare = '<a href="#"' + 'data-action="editSummary"' + 'data-log-id="' + data + '" ' + 'data-is-coaching="' + row["IsCoaching"] + '"' +
                            'class="modal-link-qn"' + 'style="border-bottom: blue 0.125em solid;">' + '<b>Prepare</b>' + '</a>&nbsp;<font color="red">' + row['LogNewText'] + '</font>';
                            var coach = '<a href="#"' + 'data-action="coach"' + 'data-log-id="' + data + '" ' + 'data-is-coaching="' + row["IsCoaching"] + '"' +
                                'class="modal-link-qn"' + 'style="color: green; border-bottom: blue 0.125em solid;">' + '<b>Coach</b>' + '</a>&nbsp;<font color="red">' + row['LogNewText'] + '</font>';
                            return prepare + '&nbsp;&nbsp;' + coach;
                        }
                        

                        if (showCsrReviewLink === 'True') {
                            var csrReview = '<a href="#"' + 'data-action="csrReview"' + 'data-log-id="' + data + '" ' + 'data-is-coaching="' + row["IsCoaching"] + '"' +
                                'class="modal-link-qn"' + 'style="border-bottom: blue 0.125em solid;">' + '<b>Review</b>' + '</a>&nbsp;<font color="red">' + row['LogNewText'] + '</font>';
                            return csrReview;
                        }

                        // decide if additional coaching (followup coaching is needed)
                        if (showFollowupReviewLink === 'True') {
                            var followup = '<a href="#"' + 'data-action="followupReview"' + 'data-log-id="' + data + '" ' + 'data-is-coaching="' + row["IsCoaching"] + '"' +
                                'class="modal-link-qn"' + 'style="border-bottom: blue 0.125em solid;">' + '<b>Review</b>' + '</a>&nbsp;<font color="red">' + row['LogNewText'] + '</font>';
                            return followup;
                        }

                        var view = '<a href="#"' + 'data-action="view"' + 'data-log-id="' + data + '" ' + 'data-is-coaching="' + row["IsCoaching"] + '"' +
                                'class="modal-link-qn"' + 'style="border-bottom: blue 0.125em solid;">' + '<b>View</b>' + '</a>&nbsp;<font color="red">' + row['LogNewText'] + '</font>';
                        return view;
                }
            },
            { data: "FormName", name: "strFormID" },
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
            //console.log('complete');
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