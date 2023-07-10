$(function () {
    $('#btn-export-excel').on('click', function (e) {
        e.preventDefault();
        $(this).prop('disabled', true);

        if (e.handled !== true) {
            e.handled = true;
            $(".please-wait").slideDown(500);
            $.ajax({
                type: 'POST',
                url: exportToExcelUrl,
                data: $("form").serialize(),
                success: function (data) {
                    // clean up
                    $('#btn-export-excel').prop('disabled', false);
                    $(".please-wait").slideUp(500);

                    if (data.result === 'success') {
                        window.location = downloadExcelUrl;
                    } else {
                        $('#modal-container .modal-content').html(
							'<div class="modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button><h4 class="modal-title">Export to Excel</h4></div>' +
							'<div class="modal-body"><p>Something went wrong. Please try again later.</p></div>' +
							'<div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">Close</button></div>');
                        $('#modal-container').modal();
                    }
                }
            }); // $.ajax
        }
    }); // end Export to excel
    
})