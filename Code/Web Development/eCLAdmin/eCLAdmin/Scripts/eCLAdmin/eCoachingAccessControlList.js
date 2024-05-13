var userTable;
var rowSelected;
var dataSelected;

$(document).ready(function () {
    $('#modal-container').css('margin-top', '0%');
    $('.modal-content').css('width', '60%');

    // Initialize datatable
    userTable = $('#dataTables-ecoaching-access-control-list').DataTable({
        "iDisplayLength": 25, // Default page size to 100
        "renderer": "bootstrap",
        "processing": true, // Show progress bar
        "serverSide": false, // Process on client side
        "filter": true,     // Enable filter (search box)
        "orderMulti": false,// Disable multiple column sorting
        "ajax": {
            url: getUserListUrl,
            "type": "POST"
        },
        "columns": [
            {
                "targets": 0,
                "data": "RowId", "name": "RowId",
                "visible": false,
                "searchable": false
            },  // Row_ID

            { "data": "LanId", "name": "LanId", "searchable": true },
            { "data": "Name", "name": "Name", "searchable": true},
            { "data": "Role", "name": "Role", "searchable": true },
            /* EDIT / DELETE*/
            {
                "searchable": false,
                "sortable": false,
                "data": "RowId",
                "render": function (data, type, row, meta) {
                    return '<a href="#" action="edit"' + 'rel="' + data + '" class="modal-link">Edit</a>' + '&nbsp;&nbsp;' + '<a href="#" action="delete"' + 'rel="' + data + '" class="modal-link">Delete</a>';
                }
            }
        ],
        "initComplete": function () {
            //console.log('done');
        }
    }); // userTable

    $('#dataTables-ecoaching-access-control-list thead').on('click', 'th', function () {
        var colIdx = userTable.column(this).index();
        $(userTable.cells().nodes()).css('background-color', 'white');
        $(userTable.column(colIdx).nodes()).css('background-color', 'whitesmoke');
    });

    $('body').on('click', '.modal-link', function (e) {
        //http://blog.roymj.co.in/prevent-jquery-events-firing-multiple-times/
        e.preventDefault();

        if (e.handled !== true) {
            e.handled = true;

            rowSelected = $(this);

            var rowId = $(this).attr("rel");
            var token = $('input[name="__RequestVerificationToken"]').val();
            //console.log("token=" + token);
            //console.log("%%%%%%rowId=" + rowId);
            var action = $(this).attr("action");
            var actionUrl = showEditUserUrl;
            if (action === 'delete') {
                actionUrl = showDeleteModalUrl;
            } else if (action === 'add') {
                actionUrl = showAddUserUrl;
            };

            $.ajax({
                type: 'POST',
                url: actionUrl,
                data: {
                    __RequestVerificationToken: token,
                    rowId: rowId
                },
                dataType: 'html',

                success: function (data) {
                    $('.modal-content').html(data);
                }
            });
        }
    });

    $('#dataTables-ecoaching-access-control-list tbody').on('click', 'tr', function () {
        dataSelected = userTable.row(this).data();
        //console.log(dataSelected);
    });
})

