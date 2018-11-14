var myTable;
$(document).ready(function () {
    alert('list ready');

    // Initialize datatable
    myTable = $('#dataTables-coaching-log-list').DataTable({
        renderer: "bootstrap",
        "processing": true, // Show progress bar
        "serverSide": true, // Process server side
        "filter": true,     // Enable filter (search box)
        "orderMulti": false,// Disable multiple column sorting
        "ajax": {
            url: loadDataUrl,
            "type": "POST",
            "datatype": "json",
            "data": { logStatus: logStatus },
        },
        "columns": [
            {
                "targets": 0,
                "data": "ID", "name": "strFormID",
                "visible": false,
                "searchable": false
            },  // Log ID
            {
                "data": "FormName", "name": "strFormID", "autowidth": true,
                "render": function (data, type, row, meta) {
                    return '<a href="#"' + 'rel="' + row['ID'] + '" ' + 'class="modal-link"' + 'style="color: #337ab7;">' + data + '</a>';
                }
            },  // Log Name
            { "data": "EmployeeName", "name": "strEMPName", "autowidth": true },
            { "data": "SupervisorName", "name": "strEMPSupName", "autowidth": true },
            { "data": "ManagerName", "name": "strEMPMgrName", "autowidth": true },
            { "data": "SubmitterName", "name": "SubmitterName", "autowidth": true, "orderable": false },
            { "data": "Source", "name": "strSource", "autowidth": true },
            { "data": "Status", "name": "strFormStatus", "autowidth": true },
            { "data": "Reasons", "name": "strCoachingReason", "autowidth": true, "orderable": false },
            { "data": "SubReasons", "name": "strSubCoachingReason", "autowidth": true, "orderable": false },
            { "data": "Value", "name": "strValue", "autowidth": true, "orderable": false },
            { "data": "CreatedDate", "name": "SubmittedDate", "autowidth": true },
        ]
    }); // myTable



    
    //$('.btn-filter').click(function () {

    //    var $panel = $(this).parents('.filterable');
    //    var $filters = $panel.find('.filters input');
    //    //var $tbody = $panel.find('.table tbody');

    //    if ($filters.prop('disabled') == true) {
    //        $filters.prop('disabled', false);
    //        $filters.first().focus();
    //    }
    //    else
    //    {
    //        $filters.val('').prop('disabled', true);
    //        //$tbody.find('.no-result').remove();
    //        //$tbody.find('tr').show();
    //    }
    //  });



    //$('#modal-container').css('margin-top', '0%');
    //$('.modal-content').css('width', '60%');

    //// Initialize datatable
    //oTable = $('#dataTables-coaching-log-list').DataTable({
    //    renderer: "bootstrap",
    //    "processing": true, // Show progress bar
    //    "serverSide": true, // Process server side
    //    "filter": true,     // Enable filter (search box)
    //    "orderMulti": false,// Disable multiple column sorting
    //    "ajax": {
    //        url: GetLogListUrl,
    //        "type": "POST",
    //        "datatype": "json",
    //        "data": { logStatus: logStatus },
    //    },
    //    "columns": [
    //        {
    //            "targets": 0,
    //            "data": "ID", "name": "strFormID",
    //            "visible": false,
    //            "searchable": false
    //        },  // Log ID
    //        {
    //            "data": "FormName", "name": "strFormID", "autowidth": true,
    //            "render": function (data, type, row, meta) {
    //                return '<a href="#"' + 'rel="' + row['ID'] + '" ' + 'class="modal-link"' + 'style="color: #337ab7;">' + data + '</a>';
    //            }
    //        },  // Log Name
    //        { "data": "EmployeeName", "name": "strEMPName", "autowidth": true },
    //        { "data": "SupervisorName", "name": "strEMPSupName", "autowidth": true },
    //        { "data": "ManagerName", "name": "strEMPMgrName", "autowidth": true },
    //        { "data": "SubmitterName", "name": "SubmitterName", "autowidth": true, "orderable": false },
    //        { "data": "Source", "name": "strSource", "autowidth": true },
    //        { "data": "Status", "name": "strFormStatus", "autowidth": true },
    //        { "data": "Reasons", "name": "strCoachingReason", "autowidth": true, "orderable": false },
    //        { "data": "SubReasons", "name": "strSubCoachingReason", "autowidth": true, "orderable": false },
    //        { "data": "Value", "name": "strValue", "autowidth": true, "orderable": false },
    //        { "data": "CreatedDate", "name": "SubmittedDate", "autowidth": true },
    //    ]
    //}); // oTable

    //if (logStatus === "Completed") {
    //    $("#coaching-log-list").removeClass("panel-primary").addClass("panel-green");
    //    $("#title").text(" Completed eCoaching Logs");
    //};

    //if (logStatus === "Active") {
    //    $("#coaching-log-list").removeClass("panel-primary").addClass("panel-red");
    //    $("#title").text(" Active Warning Logs");
    //};

    //$('body').on('click', '#a-close', function () {
    //    $("#coaching-log-list").slideUp();
    //});

    //$('body').on('click', '.modal-link', function (e) {
    //    //http://blog.roymj.co.in/prevent-jquery-events-firing-multiple-times/
    //    e.preventDefault();

    //    alert('modal-link clicked');
    //    if (e.handled !== true) {
    //    	e.handled = true;

    //    $.ajax({
    //        type: 'POST',
    //        // Call GetLogDetail method.
    //        url: getLogDetailsUrl,
    //        data: { logId: $(this).attr("rel")},

    //        success: function (data) {
    //        	alert('detail loaded');
    //            $('.modal-content').html(data);
    //        }
    //    });
    //    }
    //});

});