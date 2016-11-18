var oTable;
$(document).ready(function () {
    $('.modal-content').css('width', '1000px');

    // Initialize datatable
    oTable = $('#dataTables-coaching-log-list').DataTable({
        renderer: "bootstrap",
        "processing": true, // Show progress bar
        "serverSide": true, // Process server side
        "filter": true,     // Enable filter (search box)
        "orderMulti": false,// Disable multiple column sorting
        "ajax": {
            url: GetLogListUrl,
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
    }); // oTable

    if (logStatus === "Completed") {
        $("#coaching-log-list").removeClass("panel-primary").addClass("panel-green");
        $("#title").text(" Completed eCoaching Logs");
    };

    if (logStatus === "Active") {
        $("#coaching-log-list").removeClass("panel-primary").addClass("panel-red");
        $("#title").text(" Active Warning Logs");
    };

    $('body').on('click', '#a-close', function () {
        $("#coaching-log-list").slideUp();
    });

    $('body').on('click', '.modal-link', function (e) {
        //http://blog.roymj.co.in/prevent-jquery-events-firing-multiple-times/
        e.preventDefault();

        if (e.handled !== true) {
            e.handled = true;

        var formId = $(this).attr("rel");
            $.ajax({
                type: 'POST',
                // Call GetLogDetail method.
                url: getLogDetailsUrl,
                //dataType: 'html',
                // Get the value of the selected type (coaching or warning), module (csr, training...) and pass to GetEmployees method.
                data: { logId: formId },

                success: function (data) {
                    $('.modal-content').html(data);
                },
                error: function (ex) {
                    alert('Failed to retrieve log detail.' + ex);
                }
            });
        }
    });

});